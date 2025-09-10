<%@ Page Title="" Language="C#" MasterPageFile="~/GTDMaster.master" AutoEventWireup="true" CodeFile="AddUsers.aspx.cs" Inherits="AddUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script>
        // Global variables
        let imagename = "";
        let base64Image = "";
        let selectedfiles = "0";
        let currentEditingUID = null;

        const swalInit = swal.mixin({
            buttonsStyling: false,
            customClass: {
                confirmButton: 'btn btn-primary btn-sm',
                cancelButton: 'btn btn-light btn-sm',
                denyButton: 'btn btn-light btn-sm',
                input: 'form-control'
            }
        });

        $(document).ready(function () {
            initializeControls();
            setupEventHandlers();
            loadInitialData();
        });

        // Initialize controls
        function initializeControls() {
            $("#divEntityID, #divKPTCLGenerator, #divGenerator, #divIndividualGenerator").hide();
            $("#divEscom, #divZone, #divCircle, #divDivision, #divStation").hide();
            $("#divrow").show();
            $("#divadd").hide();
            $("#btnback, #btnupdate").hide();
        }

        // Setup all event handlers
        function setupEventHandlers() {
            // Button events
            $("#btnadd").on('click', showAddForm);
            $("#btnback").on('click', showMainView);
            $("#btnSave").on('click', saveUser);
            $("#btnupdate").on('click', updateUser);
            $("#btnclear").on('click', clearForm);
            $("#btnLogView").on('click', showLogView);

            // File upload
            document.querySelector('.fileinput-button').addEventListener('click', function () {
                this.querySelector('input[type="file"]').click();
            });

            // Dropdown change events
            $('#ddllogin').on('change', handleLoginChange);
            $('#ddlStackHolder').on('change', handleStackHolderChange);
            $('#ddlGenerator').on('change', handleGeneratorChange);
            $('#ddlEscom').on('change', handleEscomChange);
            $('#ddlZone').on('change', handleZoneChange);
            $('#ddlCircle').on('change', handleCircleChange);
            $('#ddlDivision').on('change', handleDivisionChange);
        }

        // Load initial data
        function loadInitialData() {
            loadStackholders();
            loadEscoms();
            loadDesignations(); // Load all designations on page load
            loadUserData();
        }

        // Show/Hide form functions
        function showAddForm() {
            $("#divrow").hide();
            $("#divadd").show();
            $("#btnback").show();
            $("#btnadd").hide();
        }

        function showMainView() {
            $("#divrow").show();
            $("#divadd").hide();
            $("#btnback").hide();
            $("#btnadd").show();
            clearForm();
        }

        // Handle login type change
        function handleLoginChange() {
            const loginType = $(this).val();
            $("#divEntityID").toggle(loginType === "OFFICER");

            if (loginType !== "OFFICER") {
                $("#txtEntityID").val('');
            }

            filterStackholders(loginType === "IPP");
            $("#ddlStackHolder").val("0").trigger('change');
        }

        // Handle stackholder change
        function handleStackHolderChange() {
            const stackholderId = $(this).val();
            const stackholderText = $("#ddlStackHolder option:selected").text();

            // Hide all generator divs
            $("#divKPTCLGenerator, #divGenerator, #divIndividualGenerator").hide();

            // Show appropriate generator dropdown
            if (stackholderText === "KPTCL Generator") {
                $("#divKPTCLGenerator").show();
                loadKPTCLGenerators();
            } else if (stackholderText === "Generator") {
                $("#divGenerator").show();
                loadGenerators();
            } else if (stackholderText === "Individual Generator") {
                $("#divGenerator").show();
                loadGenerators();
            }

            // Show/hide location dropdowns based on stackholder ID
            const locationLevels = {
                "8": 1,  // ESCOM only
                "9": 2,  // ESCOM + Zone
                "10": 3, // ESCOM + Zone + Circle
                "11": 4, // ESCOM + Zone + Circle + Division
                "12": 5  // All levels
            };

            const level = locationLevels[stackholderId] || 0;
            toggleLocationDropdowns(level);
        }

        // Toggle location dropdowns based on level
        function toggleLocationDropdowns(level) {
            const divs = ["#divEscom", "#divZone", "#divCircle", "#divDivision", "#divStation"];

            divs.forEach((div, index) => {
                $(div).toggle(index < level);
            });
        }

        // Handle generator change for Individual Generator
        function handleGeneratorChange() {
            const stackholderText = $("#ddlStackHolder option:selected").text();
            if (stackholderText === "Individual Generator") {
                const entityId = $(this).val();
                if (entityId !== "0") {
                    $("#divIndividualGenerator").show();
                    loadIndividualGenerators(entityId);
                } else {
                    $("#divIndividualGenerator").hide();
                }
            }
        }

        // Handle location dropdown changes
        function handleEscomChange() {
            const compId = $(this).val();
            loadZones(compId);
            resetLocationDropdowns(['#ddlCircle', '#ddlDivision', '#ddlStation']);
        }

        function handleZoneChange() {
            const compId = $("#ddlEscom").val();
            const zoneId = $(this).val();
            loadCircles(compId, zoneId);
            resetLocationDropdowns(['#ddlDivision', '#ddlStation']);
        }

        function handleCircleChange() {
            const compId = $("#ddlEscom").val();
            const zoneId = $("#ddlZone").val();
            const circleId = $(this).val();
            loadDivisions(compId, zoneId, circleId);
            resetLocationDropdowns(['#ddlStation']);
        }

        function handleDivisionChange() {
            const compId = $("#ddlEscom").val();
            const zoneId = $("#ddlZone").val();
            const circleId = $("#ddlCircle").val();
            const divisionId = $(this).val();
            loadStations(compId, zoneId, circleId, divisionId);
        }

        // Reset dropdown helper
        function resetLocationDropdowns(selectors) {
            selectors.forEach(selector => {
                $(selector).val("0").trigger('change');
            });
        }

        // User model creation
        function createUserModel(isUpdate = false) {
            const model = {
                username: $("#txtuname_add").val(),
                fullname: $("#txtfullname").val(),
                phonenumber: $("#txtphone").val(),
                email: $("#txtmail").val(),
                password: $("#txtpassword").val(),
                loginfrom: $("#ddllogin").val(),
                DesignationId: $("#ddlDesignation").val(),
                DesignationName: $("#ddlDesignation option:selected").text(),
                StackHolderId: $("#ddlStackHolder").val(),
                StackHolderName: $("#ddlStackHolder option:selected").text(),
                remarks: $("#txtremark").val(),
                Address: $("#txtAddress").val(),
                status: $("input[name='inlineRadioOptions']:checked").val(),
                COMPID: $("#ddlEscom").val() || "0",
                ZONEID: $("#ddlZone").val() || "0",
                CIRID: $("#ddlCircle").val() || "0",
                DIVID: $("#ddlDivision").val() || "0",
                STNID: $("#ddlStation").val() || "0",
                imagename: imagename,
                base64Image: base64Image,
                image: (selectedfiles === "0") ? "default" : "dynamic",
                EntityID: $("#txtEntityID").val(),
                KPTCLGeneratorID: $("#ddlKPTCLGenerator").val(),
                GeneratorID: $("#ddlGenerator").val(),
                IndividualGeneratorID: $("#ddlIndividualGenerator").val()
            };

            if (isUpdate) {
                model.userid = currentEditingUID;
            }

            return model;
        }

        // Validation helper
        function validateField(value, errorLabel, errorMessage, focusElement) {
            if (!value || value === "0") {
                $(errorLabel).show().text(errorMessage);
                $(focusElement).focus();
                return false;
            }
            $(errorLabel).hide();
            return true;
        }

        // Main validation function
        function validateUserData(user) {
            // Basic field validations
            if (!validateField(user.username, "#lblreqname", "Username is required", "#txtuname_add")) return false;
            if (!/^[a-zA-Z].{2,}$/.test(user.username)) {
                $("#lblreqname").show().text("Username should be at least 3 characters and cannot start with a number or special character.");
                $("#txtuname_add").focus();
                return false;
            }

            if (!validateField(user.fullname, "#lblreqfirmname", "Full Name is required", "#txtfullname")) return false;
            if (!/^[a-zA-Z\s]+$/.test(user.fullname)) {
                $("#lblreqfirmname").show().text("Please enter a valid Full Name.");
                $("#txtfullname").focus();
                return false;
            }

            if (!validateField(user.phonenumber, "#lblreqphone", "Phone number is required", "#txtphone")) return false;
            if (!/^[6-9]\d{9}$/.test(user.phonenumber)) {
                $("#lblreqphone").show().text("Please enter a valid 10-digit phone number.");
                $("#txtphone").focus();
                return false;
            }

            if (!validateField(user.email, "#lblreqmail", "Email is required", "#txtmail")) return false;
            if (!/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(user.email)) {
                $("#lblreqmail").show().text("Please enter a valid email address.");
                $("#txtmail").focus();
                return false;
            }

            if (!validateField(user.password, "#lblreqpass", "Password is required", "#txtpassword")) return false;
            if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*_=+-]).{8,20}$/.test(user.password)) {
                $("#lblreqpass").show().text("Password must be 8-20 characters long and include uppercase, lowercase, a number, and a special character.");
                $("#txtpassword").focus();
                return false;
            }

            // Confirm password validation (only for new users)
            if (!currentEditingUID) {
                const confirmPassword = $("#txtconfmpass").val();
                if (!validateField(confirmPassword, "#lblreqconfmpass", "Confirm Password is required", "#txtconfmpass")) return false;
                if (user.password !== confirmPassword) {
                    $("#lblreqconfmpass").show().text("Passwords do not match.");
                    $("#txtconfmpass").focus();
                    return false;
                }
            }

            // Dropdown validations
            if (!validateField(user.loginfrom, "#lblloginfrom", "Login From is required", "#ddllogin")) return false;
            if (!validateField(user.StackHolderId, "#lblStackHolder", "StackHolder is required", "#ddlStackHolder")) return false;
            if (!validateField(user.DesignationId, "#lblDesignation", "Designation is required", "#ddlDesignation")) return false;

            // Conditional validations
            const validations = [
                { condition: $("#divEntityID").is(":visible"), field: user.EntityID, label: "#lblEntityID", message: "Entity ID is required", focus: "#txtEntityID" },
                { condition: $("#divKPTCLGenerator").is(":visible"), field: user.KPTCLGeneratorID, label: "#lblKPTCLGenerator", message: "Please select KPTCL Generator", focus: "#ddlKPTCLGenerator" },
                { condition: $("#divGenerator").is(":visible"), field: user.GeneratorID, label: "#lblGenerator", message: "Please select Generator", focus: "#ddlGenerator" },
                { condition: $("#divIndividualGenerator").is(":visible"), field: user.IndividualGeneratorID, label: "#lblIndividualGenerator", message: "Please select Individual Generator", focus: "#ddlIndividualGenerator" },
                { condition: $("#divEscom").is(":visible"), field: user.COMPID, label: "#lblEscom", message: "Please select ESCOM", focus: "#ddlEscom" },
                { condition: $("#divZone").is(":visible"), field: user.ZONEID, label: "#lblZone", message: "Please select Zone", focus: "#ddlZone" },
                { condition: $("#divCircle").is(":visible"), field: user.CIRID, label: "#lblCircle", message: "Please select Circle", focus: "#ddlCircle" },
                { condition: $("#divDivision").is(":visible"), field: user.DIVID, label: "#lblDivision", message: "Please select Division", focus: "#ddlDivision" },
                { condition: $("#divStation").is(":visible"), field: user.STNID, label: "#lblStation", message: "Please select Station", focus: "#ddlStation" }
            ];

            for (const validation of validations) {
                if (validation.condition && !validateField(validation.field, validation.label, validation.message, validation.focus)) {
                    return false;
                }
            }

            return true;
        }

        // Save user function
        function saveUser() {
            const user = createUserModel();

            if (!validateUserData(user)) return;

            callAjaxMethod('/templates/Master/AddUsers.aspx/saveUserDataNew', { user }, function (response) {
                handleSaveResponse(response);
            });
        }

        // Update user function  
        function updateUser() {
            const user = createUserModel(true);
            if (!validateUserData(user)) return;
            callAjaxMethod('/templates/Master/AddUsers.aspx/updateUserDataNew', { user }, function (response) {
                handleSaveResponse(response);
            });
        }

        function clearForm() {
            // Clear text inputs
            const textInputs = ["#txtuname_add", "#txtfullname", "#txtphone", "#txtmail", "#txtpassword", "#txtconfmpass", "#txtremark", "#txtAddress", "#txtEntityID"];
            textInputs.forEach(input => $(input).val(''));

            // Reset dropdowns
            const dropdowns = ["#ddllogin", "#ddlStackHolder", "#ddlDesignation", "#ddlEscom", "#ddlZone", "#ddlCircle", "#ddlDivision", "#ddlStation", "#ddlKPTCLGenerator", "#ddlGenerator", "#ddlIndividualGenerator"];
            dropdowns.forEach(dropdown => $(dropdown).val("0").trigger('change'));

            // Reset file upload
            resetFileUpload();

            // Reset buttons and visibility
            $('#btnupdate').hide();
            $('#btnSave').show();
            currentEditingUID = null;

            // Hide validation labels
            const labels = ["#lblDesignation", "#lblreqradio", "#lblreqconfmpass", "#lblreqpass", "#lblreqname", "#lblreqmail", "#lblreqphone", "#lblreqfirmname", "#lblreqremark", "#lblStackHolder", "#lblloginfrom", "#lblstrogpass", "#lblEscom", "#lblZone", "#lblCircle", "#lblDivision", "#lblStation", "#lblEntityID", "#lblKPTCLGenerator", "#lblGenerator", "#lblIndividualGenerator"];
            labels.forEach(label => $(label).hide());
        }

        // File handling
        function handleFileSelection(event) {
            const files = event.target.files;
            const tableBody = document.querySelector('.files');

            if (files.length > 0) {
                selectedfiles = "1";
                const file = files[0];

                if (file.type.startsWith('image/')) {
                    const reader = new FileReader();
                    reader.onloadend = function () {
                        base64Image = reader.result;
                    };
                    reader.readAsDataURL(file);

                    imagename = file.name;
                    displayFilePreview(file, tableBody);
                }
            } else {
                resetFileUpload();
            }
            event.target.value = '';
        }

        function displayFilePreview(file, container) {
            container.innerHTML = `
                <tr data-id="file-0">
                    <td><img src="${URL.createObjectURL(file)}" alt="${file.name}" style="width: 100px; height: 100px; object-fit: contain;"></td>
                    <td>
                        <div><strong>Name:</strong> ${file.name}</div>
                        <div><strong>Size:</strong> ${(file.size / 1024).toFixed(2)} KB</div>
                    </td>
                    <td>
                        <button class="btn btn-default cancel w-100px pe-20px d-block" onclick="resetFileUpload()">
                            <i class="fa fa-trash fa-fw text-muted"></i>
                            <span>Cancel</span>
                        </button>
                    </td>
                </tr>
            `;
        }

        function resetFileUpload() {
            selectedfiles = "0";
            imagename = "";
            base64Image = "";
            document.querySelector('.files').innerHTML = `
                <tr data-id="empty">
                    <td colspan="3" class="text-center text-gray-500 py-30px">
                        <div class="mb-10px"><i class="fa fa-file fa-3x"></i></div>
                        <div class="fw-bold">No file selected</div>
                    </td>
                </tr>
            `;
        }

        // API helper function
        function callAjaxMethod(url, data, successCallback, errorCallback) {
            $.ajax({
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json;charset=utf-8',
                url: url,
                data: JSON.stringify(data),
                success: function (response) {
                    successCallback(response.d);
                },
                error: function (xhr, status, error) {
                    if (errorCallback) {
                        errorCallback(error);
                    } else {
                        swalInit.fire({
                            title: 'Error',
                            text: 'An error occurred: ' + error,
                            icon: 'error'
                        });
                    }
                }
            });
        }

        // Data loading functions
        function loadStackholders() {
            callAjaxMethod('/templates/Master/AddUsers.aspx/GetStackholders', {}, function (data) {
                populateDropdown('#ddlStackHolder', JSON.parse(data), 'Sid', 'StackholderName', 'Select Stack Holders');
            });
        }

        function loadKPTCLGenerators() {
            callAjaxMethod('/templates/Master/AddUsers.aspx/GetKPTCLGenerators', {}, function (data) {
                populateDropdown('#ddlKPTCLGenerator', JSON.parse(data), 'GSTN_ID', 'GENSTN', 'Select KPTCL Generator');
            });
        }

        function loadGenerators() {
            callAjaxMethod('/templates/Master/AddUsers.aspx/GetGenerators', {}, function (data) {
                populateDropdown('#ddlGenerator', JSON.parse(data), 'ENTITY_ID', 'IFPOINTNAME', 'Select Generator');
            });
        }

        function loadIndividualGenerators(entityId) {
            callAjaxMethod('/templates/Master/AddUsers.aspx/GetIndividualGenerators', { entityId }, function (data) {
                populateDropdown('#ddlIndividualGenerator', JSON.parse(data), 'ID', 'GENERATOR_NAME', 'Select Individual Generator');
            });
        }

        function loadEscoms() {
            callAjaxMethod('/templates/Master/AddUsers.aspx/GetEscoms', {}, function (data) {
                populateDropdown('#ddlEscom', JSON.parse(data), 'COMPID', 'COMPANY', 'Select Escom');
            });
        }

        function loadZones(compId) {
            callAjaxMethod('/templates/Master/AddUsers.aspx/GetZones', { COMPID: compId }, function (data) {
                populateDropdown('#ddlZone', JSON.parse(data), 'ZONEID', 'ZONENAME', 'Select Zone');
            });
        }

        function loadCircles(compId, zoneId) {
            callAjaxMethod('/templates/Master/AddUsers.aspx/GetCircles', { COMPID: compId, ZONEID: zoneId }, function (data) {
                populateDropdown('#ddlCircle', JSON.parse(data), 'CIRID', 'CIRCLE', 'Select Circle');
            });
        }

        function loadDivisions(compId, zoneId, circleId) {
            callAjaxMethod('/templates/Master/AddUsers.aspx/GetDivisions', { COMPID: compId, ZONEID: zoneId, CIRID: circleId }, function (data) {
                populateDropdown('#ddlDivision', JSON.parse(data), 'DIVID', 'DIVISION', 'Select Division');
            });
        }

        function loadStations(compId, zoneId, circleId, divisionId) {
            callAjaxMethod('/templates/Master/AddUsers.aspx/GetStations', { COMPID: compId, ZONEID: zoneId, CIRID: circleId, DIVID: divisionId }, function (data) {
                populateDropdown('#ddlStation', JSON.parse(data), 'STNID', 'STATION', 'Select Station');
            });
        }

        function loadDesignations() {
            callAjaxMethod('/templates/Master/AddUsers.aspx/GetDesignationBind', {}, function (data) {
                populateDropdown('#ddlDesignation', JSON.parse(data), 'Did', 'DesignationName', 'Select Designation');
            });
        }

        // Dropdown population helper
        function populateDropdown(selector, data, valueField, textField, defaultText) {
            const dropdown = $(selector);
            dropdown.empty().append($('<option>', { value: 0, text: defaultText }));

            if (data && data.length > 0) {
                data.forEach(item => {
                    dropdown.append($('<option>', {
                        value: item[valueField],
                        text: item[textField]
                    }));
                });
            }
        }

        // Filter stackholders based on login type
        function filterStackholders(showAll) {
            const dropdown = $('#ddlStackHolder');

            if (!dropdown.data('allOptions')) {
                dropdown.data('allOptions', dropdown.html());
            }

            const allOptionsHtml = dropdown.data('allOptions');
            dropdown.empty().append($('<option>', { value: 0, text: 'Select Stack Holder' }));

            const tempDiv = $('<div>').html(allOptionsHtml);
            tempDiv.find('option').each(function () {
                const text = $(this).text();
                const value = $(this).val();

                if (value === "0") return;

                if (showAll || (text !== 'IPP' && text !== 'KPTCL Generator' && text !== 'Generator' && text !== 'Individual Generator')) {
                    dropdown.append($(this).clone());
                }
            });
        }

        // Load and display user data
        function loadUserData() {
            callAjaxMethod('/templates/Master/AddUsers.aspx/BindData', {}, function (data) {
                displayUserTable(JSON.parse(data));
            });
        }

        // Display user table - CORRECTED VERSION
        function displayUserTable(data) {
            // Destroy existing DataTable if it exists
            if ($.fn.DataTable.isDataTable('#UserTable')) {
                $('#UserTable').DataTable().clear().destroy();
            }

            // Clear and rebuild table headers
            $('#UserTable thead tr').empty();
            const headers = ['Action', 'SLNO', 'User Name', 'Full Name', 'Mobile Number', 'Email-Id', 'Login-From', 'Entity/Generator ID', 'Individual Gen ID', 'STACKHOLDER', 'Designation', 'Status', 'Address', 'Remarks'];
            headers.forEach(header => {
                $('#UserTable thead tr').append(`<th>${header}</th>`);
            });

            if (data && data.length > 0) {
                const columns = [
                    {
                        data: null,
                        orderable: false,
                        searchable: false,
                        render: function (data, type, row, meta) {
                            return `<button type="button" class="btnEdit btn btn-secondary btn-sm">Edit</button>`;
                        }
                    },
                    {
                        data: null,
                        title: 'SLNO',
                        orderable: false,
                        searchable: false,
                        render: function (data, type, row, meta) {
                            return meta.row + 1;
                        }
                    },
                    { data: 'User_NAME', title: 'User Name', defaultContent: '' },
                    { data: 'FULLNAME', title: 'Full Name', defaultContent: '' },
                    { data: 'MOBILE_NO', title: 'Mobile Number', defaultContent: '' },
                    { data: 'EMAIL', title: 'Email-Id', defaultContent: '' },
                    { data: 'USER_TYPE', title: 'Login-From', defaultContent: '' },
                    { data: 'EMPID_or_EntityID', title: 'Entity/Generator ID', defaultContent: '' },
                    { data: 'IN_GENID', title: 'Individual Gen ID', defaultContent: '' },
                    { data: 'STACKHOLDER_NAME', title: 'STACKHOLDER', defaultContent: '' },
                    { data: 'DESIGNATION_NAME', title: 'Designation', defaultContent: '' },
                    {
                        data: 'STATUS',
                        title: 'Status',
                        render: function (data, type, row) {
                            if (data === 'ACTIVE') {
                                return '<span class="badge bg-success">Active</span>';
                            } else {
                                return '<span class="badge bg-danger">Inactive</span>';
                            }
                        },
                        defaultContent: ''
                    },
                    { data: 'Address', title: 'Address', defaultContent: '' },
                    { data: 'COMMENTS', title: 'Remarks', defaultContent: '' },
                    { data: 'ID', visible: false } // Hidden ID column for edit operations
                ];

                try {
                    const table = $('#UserTable').DataTable({
                        data: data,
                        columns: columns,
                        destroy: true,
                        scrollX: true,
                        scrollY: '400px',
                        scrollCollapse: true,
                        autoWidth: false,
                        responsive: false,
                        paging: false,
                        pageLength: -1,
                        info: true,
                        fixedHeader: true,
                        dom: '<"row"<"col-sm-12 col-md-8"f><"col-sm-12 col-md-4"B>><"datatable-scroll-wrap"t><"row"<"col-sm-12 col-md-12"i>>',
                        language: {
                            search: '<span class="me-3">Filter:</span> <div class="form-control-feedback form-control-feedback-end">_INPUT_<div class="form-control-feedback-icon"><i class="ph-magnifying-glass opacity-50"></i></div></div>',
                            searchPlaceholder: 'Type to filter...',
                            info: 'Showing _TOTAL_ entries'
                        },
                        buttons: {
                            dom: {
                                button: {
                                    className: 'btn btn-light'
                                }
                            },
                            buttons: [
                                {
                                    extend: 'excelHtml5',
                                    text: 'Excel <i class="ph-file-xls ms-2"></i>',
                                    filename: 'UserData',
                                    autoFilter: true,
                                    title: 'User Table Report',
                                    className: 'btn btn-success bg-success text-white border-success me-2',
                                    exportOptions: {
                                        columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13] // Exclude action column
                                    }
                                },
                                {
                                    extend: 'pdfHtml5',
                                    text: 'PDF <i class="ph-file-pdf ms-2"></i>',
                                    filename: 'UserData',
                                    className: 'btn btn-danger bg-danger text-white border-danger',
                                    title: 'User Table Report',
                                    orientation: 'landscape',
                                    pageSize: 'A3', // Larger page size for more columns
                                    exportOptions: {
                                        columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13] // Exclude action column
                                    },
                                    customize: function (doc) {
                                        doc.defaultStyle.fontSize = 8;
                                        doc.styles.tableHeader.fontSize = 9;
                                        doc.styles.title.fontSize = 12;

                                        const table = doc.content.find(c => c.table);
                                        if (table && table.table && table.table.body && table.table.body.length > 0) {
                                            const columnCount = table.table.body[0].length;
                                            table.table.widths = Array(columnCount).fill('*');
                                        }
                                    }
                                }
                            ]
                        },
                        initComplete: function () {
                            console.log('User DataTable initialized successfully');
                        },
                        drawCallback: function (settings) {
                            console.log('User DataTable redrawn with ' + settings.aoData.length + ' records');
                        }
                    });

                    // Force table to take full width
                    $('#UserTable').css('width', '100%');
                    $('.dataTables_scrollBody').css('width', '100%');

                    // Adjust columns on window resize
                    $(window).off('resize.userTable').on('resize.userTable', function () {
                        table.columns.adjust().draw();
                    });

                    // Edit button click handler - captures ID dynamically from row data
                    $('#UserTable tbody').off('click', '.btnEdit').on('click', '.btnEdit', function (e) {
                        e.preventDefault();
                        const table = $('#UserTable').DataTable();
                        const rowData = table.row($(this).closest('tr')).data();

                        // Capture the ID from row data and store in global variable
                        currentEditingUID = rowData['ID'] || rowData['Id'] || rowData['id'];

                        console.log("Editing User ID:", currentEditingUID, "Row Data:", rowData);
                        editUser(rowData);
                    });

                    // Force columns adjustment after initialization
                    setTimeout(function () {
                        table.columns.adjust().draw();
                    }, 100);

                    console.log('User DataTable created successfully with ' + data.length + ' records');

                } catch (error) {
                    console.error('Error initializing User DataTable:', error);

                    // Fallback: show basic table
                    let tableHtml = '<tbody>';
                    data.forEach((row, index) => {
                        tableHtml += `<tr>
                    <td><button type="button" class="btnEdit btn btn-secondary btn-sm" onclick="editUser(${JSON.stringify(row).replace(/"/g, '&quot;')})">Edit</button></td>
                    <td>${index + 1}</td>
                    <td>${row.User_NAME || ''}</td>
                    <td>${row.FULLNAME || ''}</td>
                    <td>${row.MOBILE_NO || ''}</td>
                    <td>${row.EMAIL || ''}</td>
                    <td>${row.USER_TYPE || ''}</td>
                    <td>${row.EMPID_or_EntityID || ''}</td>
                    <td>${row.IN_GENID || ''}</td>
                    <td>${row.STACKHOLDER_NAME || ''}</td>
                    <td>${row.DESIGNATION_NAME || ''}</td>
                    <td>${row.STATUS === 'ACTIVE' ? '<span class="badge bg-success">Active</span>' : '<span class="badge bg-danger">Inactive</span>'}</td>
                    <td>${row.Address || ''}</td>
                    <td>${row.COMMENTS || ''}</td>
                </tr>`;
                    });
                    tableHtml += '</tbody>';
                    $('#UserTable tbody').html(tableHtml);
                }

            } else {
                console.log('No user data to display');
                // Handle empty data case with proper colspan
                $('#UserTable tbody').html('<tr><td colspan="14" class="text-center text-muted py-3">No Data Available</td></tr>');
            }
        }

        // Updated handleSaveResponse function to ensure proper data refresh
        function handleSaveResponse(response) {
            const errorMessages = {
                "UNAME": "User Name Already Exists",
                "PHNO": "Phone Number Already Exists",
                "EMAIL": "Email Already Exists",
                "ENTITY_DUPLICATE": "Duplicate Entity IDs are not allowed",
                "KPTCL_DUPLICATE": "This KPTCL Generator already exists",
                "GENERATOR_DUPLICATE": "This Generator already exists",
                "INDIVIDUAL_DUPLICATE": "This Generator + Individual Generator combination already exists"
            };

            const message = errorMessages[response] || response;
            const isError = Object.keys(errorMessages).includes(response);

            if (!isError) {
                showMainView();
                // Add longer delay and force refresh
                setTimeout(() => {
                    console.log('Refreshing user data after save/update...');
                    loadUserData();
                }, 500); // Increased delay to ensure backend processing is complete
            }

            swalInit.fire({
                title: message,
                icon: isError ? 'warning' : 'success',
                confirmButtonText: 'Close'
            });
        }

        // Edit user function
        function editUser(rowData) {
            showAddForm();
            $('#btnSave').hide();
            $("#btnupdate").show();
            currentEditingUID = rowData.ID;

            // Populate basic form fields
            $("#txtuname_add").val(rowData.User_NAME || '');
            $("#txtfullname").val(rowData.FULLNAME || '');
            $("#txtphone").val(rowData.MOBILE_NO || '');
            $("#txtmail").val(rowData.EMAIL || '');
            $("#txtpassword").val(rowData.PASSWORD || '');
            $("#txtconfmpass").val(rowData.PASSWORD || '');
            $("#txtAddress").val(rowData.Address || '');
            $("#txtremark").val(rowData.COMMENTS || '');

            // Set status radio button
            const status = rowData.STATUS || 'ACTIVE';
            $("input[name='inlineRadioOptions'][value='" + status + "']").prop('checked', true);

            // Handle Login From and show/hide fields
            const loginType = rowData.USER_TYPE || '';
            $("#ddllogin").val(loginType);

            // Show/hide EntityID field based on login type
            $("#divEntityID").toggle(loginType === "OFFICER");
            if (loginType === "OFFICER") {
                $("#txtEntityID").val(rowData.EMPID_or_EntityID || '');
            }

            // Filter and set StackHolder
            filterStackholders(loginType === "IPP");
            $("#ddlStackHolder").val(rowData.STACKHOLDER_ID || '');

            // Handle stackholder-specific fields
            const stackholderId = rowData.STACKHOLDER_ID;
            const stackholderText = $("#ddlStackHolder option:selected").text();

            // Hide all generator divs initially
            $("#divKPTCLGenerator, #divGenerator, #divIndividualGenerator").hide();

            // Show and load appropriate generator dropdown
            if (stackholderText === "KPTCL Generator") {
                $("#divKPTCLGenerator").show();
                loadKPTCLGenerators();
                setTimeout(() => {
                    $("#ddlKPTCLGenerator").val(rowData.EMPID_or_EntityID || '');
                }, 300);
            } else if (stackholderText === "Generator") {
                $("#divGenerator").show();
                loadGenerators();
                setTimeout(() => {
                    $("#ddlGenerator").val(rowData.EMPID_or_EntityID || '');
                }, 300);
            } else if (stackholderText === "Individual Generator") {
                $("#divGenerator").show();
                loadGenerators();
                setTimeout(() => {
                    $("#ddlGenerator").val(rowData.EMPID_or_EntityID || '');
                    if (rowData.EMPID_or_EntityID && rowData.EMPID_or_EntityID !== "0") {
                        $("#divIndividualGenerator").show();
                        loadIndividualGenerators(rowData.EMPID_or_EntityID);
                        setTimeout(() => {
                            $("#ddlIndividualGenerator").val(rowData.IN_GENID || '');
                        }, 300);
                    }
                }, 300);
            }
            // Handle location dropdowns based on stackholder ID
            const locationLevels = {
                "8": 1,  // ESCOM only
                "9": 2,  // ESCOM + Zone
                "10": 3, // ESCOM + Zone + Circle
                "11": 4, // ESCOM + Zone + Circle + Division
                "12": 5  // All levels
            };

            const level = locationLevels[stackholderId] || 0;
            toggleLocationDropdowns(level);

            // Load and set location data if applicable
            if (level >= 1 && rowData.ESCOMID) {
                $("#ddlEscom").val(rowData.ESCOMID);

                if (level >= 2 && rowData.ZONEID) {
                    loadZones(rowData.ESCOMID);
                    setTimeout(() => {
                        $("#ddlZone").val(rowData.ZONEID);

                        if (level >= 3 && rowData.CIRCLEID) {
                            loadCircles(rowData.ESCOMID, rowData.ZONEID);
                            setTimeout(() => {
                                $("#ddlCircle").val(rowData.CIRCLEID);

                                if (level >= 4 && rowData.DIVISIONID) {
                                    loadDivisions(rowData.ESCOMID, rowData.ZONEID, rowData.CIRCLEID);
                                    setTimeout(() => {
                                        $("#ddlDivision").val(rowData.DIVISIONID);

                                        if (level >= 5 && rowData.STATIONID) {
                                            loadStations(rowData.ESCOMID, rowData.ZONEID, rowData.CIRCLEID, rowData.DIVISIONID);
                                            setTimeout(() => {
                                                $("#ddlStation").val(rowData.STATIONID);
                                            }, 300);
                                        }
                                    }, 300);
                                }
                            }, 300);
                        }
                    }, 300);
                }
            }

            // Set designation
            setTimeout(() => {
                $("#ddlDesignation").val(rowData.DESIGNATION_ID || '');
            }, 100);
        }

        // Show log view
        function showLogView() {
            callAjaxMethod('/templates/Master/AddUsers.aspx/BindData_log', {}, function (data) {
                displayLogTable(JSON.parse(data));
            });
        }

        // Display log table
        function displayLogTable(data) {
            if ($.fn.DataTable.isDataTable('#UserTable_Log')) {
                $('#UserTable_Log').DataTable().clear().destroy();
                $('#UserTable_Log thead tr').empty();
            }

            if (data.length > 0) {
                const headers = ['SLNO', 'User Name', 'Full Name', 'Mobile', 'Email', 'Login-From', 'StackHolders', 'Designation', 'Status', 'Address', 'Remarks', 'Added By', 'Added On'];
                const headerRow = $('#tableHeadRow_Log');
                headers.forEach(header => headerRow.append(`<th>${header}</th>`));

                const columns = [
                    { data: null, render: function (data, type, row, meta) { return meta.row + 1; } },
                    { data: 'User_NAME' },
                    { data: 'FULLNAME' },
                    { data: 'MOBILE_NO' },
                    { data: 'EMAIL' },
                    { data: 'USER_TYPE' },
                    { data: 'STACKHOLDER_NAME' },
                    { data: 'DESIGNATION_NAME' },
                    { data: 'STATUS' },
                    { data: 'Address' },
                    { data: 'COMMENTS' },
                    { data: 'ADDEDBY' },
                    { data: 'ADDEDON' }
                ];

                $('#UserTable_Log').DataTable({
                    data: data,
                    columns: columns,
                    destroy: true,
                    pageLength: 10,
                    scrollCollapse: true,
                    scrollX: true,
                    scrollY: 250,
                    paging: false,
                    info: false,
                    dom: '<"datatable-header dt-buttons-right"fB><"datatable-scroll"tS><"datatable-footer"i>',
                    language: {
                        search: '<span class="me-3">Filter:</span> <div class="form-control-feedback form-control-feedback-end flex-fill">_INPUT_<div class="form-control-feedback-icon"><i class="ph-magnifying-glass opacity-50"></i></div></div>',
                        searchPlaceholder: 'Type to filter...'
                    },
                    buttons: [
                        {
                            extend: 'excelHtml5',
                            text: 'Excel <i class="ph-file-xls ms-2"></i>',
                            className: 'btn btn-success me-2',
                            title: 'User Log Table Report',
                            filename: 'user_table_export_LOG'
                        },
                        {
                            extend: 'pdfHtml5',
                            orientation: 'landscape',
                            pageSize: 'A2',
                            text: 'PDF <i class="ph-file-pdf ms-2"></i>',
                            className: 'btn btn-danger bg-danger text-white border-danger',
                            title: 'User Log Table Report',
                            filename: 'user_table_export_Log'
                        }
                    ]
                });
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container-fluid mt-3">
        <div class="card">
            <div class="card-header card-hearder-custom d-flex align-items-center py-0">
                <h6 class="mb-0">Add User</h6>
                <div class="ms-auto my-auto py-sm-1">
                    <button type="button" id="btnadd" class="btn btn-light">+ Add</button>
                    <button type="button" id="btnback" style="display: none" class="btn btn-light">Back</button>
                </div>
            </div>

            <!-- Add/Edit Form -->
            <div class="card-body" id="divadd" style="display: none">
                <div class="row">
                    <!-- Basic Information -->
                    <div class="col-md-3 mb-3">
                        <label class="form-label">User Name <span class="text-danger">*</span></label>
                        <input type="text" id="txtuname_add" class="form-control" placeholder="User Name" />
                        <div class="invalid-feedback" id="lblreqname"></div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Full Name <span class="text-danger">*</span></label>
                        <input type="text" id="txtfullname" class="form-control" placeholder="Full Name" />
                        <div class="invalid-feedback" id="lblreqfirmname"></div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Phone Number <span class="text-danger">*</span></label>
                        <input type="tel" id="txtphone" class="form-control" placeholder="Phone Number" maxlength="10" 
                               onkeydown="return (/^[0-9]*$/.test(event.key) || event.keyCode === 8 || event.keyCode === 9);">
                        <div class="invalid-feedback" id="lblreqphone"></div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Email <span class="text-danger">*</span></label>
                        <input type="email" id="txtmail" class="form-control" placeholder="Email" />
                        <div class="invalid-feedback" id="lblreqmail"></div>
                    </div>

                    <!-- Password Fields -->
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Password <span class="text-danger">*</span></label>
                        <input type="password" id="txtpassword" class="form-control" placeholder="Password" />
                        <div class="invalid-feedback" id="lblreqpass"></div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Confirm Password <span class="text-danger">*</span></label>
                        <input type="password" id="txtconfmpass" class="form-control" placeholder="Confirm Password" />
                        <div class="invalid-feedback" id="lblreqconfmpass"></div>
                    </div>

                    <!-- Login and Role Information -->
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Login From <span class="text-danger">*</span></label>
                        <select id="ddllogin" class="form-select">
                            <option value="0">Select Login</option>
                            <option value="OFFICER">Officer</option>
                            <option value="IPP">IPP</option>
                        </select>
                        <div class="invalid-feedback" id="lblloginfrom"></div>
                    </div>
                    <div class="col-md-3 mb-3" id="divEntityID" style="display: none;">
                        <label class="form-label">Entity ID <span class="text-danger">*</span></label>
                        <input type="text" id="txtEntityID" class="form-control" placeholder="Enter Entity ID" />
                        <div class="invalid-feedback" id="lblEntityID"></div>
                    </div>

                    <!-- Stakeholder and Generator Information -->
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Stack Holder <span class="text-danger">*</span></label>
                        <select id="ddlStackHolder" class="form-select">
                            <option value="0">Select Stack Holder</option>
                        </select>
                        <div class="invalid-feedback" id="lblStackHolder"></div>
                    </div>
                    <div class="col-md-3 mb-3" id="divKPTCLGenerator" style="display: none;">
                        <label class="form-label">KPTCL Generator <span class="text-danger">*</span></label>
                        <select id="ddlKPTCLGenerator" class="form-select">
                            <option value="0">Select KPTCL Generator</option>
                        </select>
                        <div class="invalid-feedback" id="lblKPTCLGenerator"></div>
                    </div>
                    <div class="col-md-3 mb-3" id="divGenerator" style="display: none;">
                        <label class="form-label">Generator <span class="text-danger">*</span></label>
                        <select id="ddlGenerator" class="form-select">
                            <option value="0">Select Generator</option>
                        </select>
                        <div class="invalid-feedback" id="lblGenerator"></div>
                    </div>
                    <div class="col-md-3 mb-3" id="divIndividualGenerator" style="display: none;">
                        <label class="form-label">Individual Generator <span class="text-danger">*</span></label>
                        <select id="ddlIndividualGenerator" class="form-select">
                            <option value="0">Select Individual Generator</option>
                        </select>
                        <div class="invalid-feedback" id="lblIndividualGenerator"></div>
                    </div>

                    <!-- Location Information -->
                    <div class="col-md-3 mb-3" id="divEscom">
                        <label class="form-label">ESCOM <span class="text-danger">*</span></label>
                        <select id="ddlEscom" class="form-select">
                            <option value="0">Select ESCOM</option>
                        </select>
                        <div class="invalid-feedback" id="lblEscom"></div>
                    </div>
                    <div class="col-md-3 mb-3" id="divZone">
                        <label class="form-label">Zone <span class="text-danger">*</span></label>
                        <select id="ddlZone" class="form-select">
                            <option value="0">Select Zone</option>
                        </select>
                        <div class="invalid-feedback" id="lblZone"></div>
                    </div>
                    <div class="col-md-3 mb-3" id="divCircle">
                        <label class="form-label">Circle <span class="text-danger">*</span></label>
                        <select id="ddlCircle" class="form-select">
                            <option value="0">Select Circle</option>
                        </select>
                        <div class="invalid-feedback" id="lblCircle"></div>
                    </div>
                    <div class="col-md-3 mb-3" id="divDivision">
                        <label class="form-label">Division <span class="text-danger">*</span></label>
                        <select id="ddlDivision" class="form-select">
                            <option value="0">Select Division</option>
                        </select>
                        <div class="invalid-feedback" id="lblDivision"></div>
                    </div>
                    <div class="col-md-3 mb-3" id="divStation">
                        <label class="form-label">Station <span class="text-danger">*</span></label>
                        <select id="ddlStation" class="form-select">
                            <option value="0">Select Station</option>
                        </select>
                        <div class="invalid-feedback" id="lblStation"></div>
                    </div>

                    <!-- Designation and Status -->
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Designation <span class="text-danger">*</span></label>
                        <select id="ddlDesignation" class="form-select">
                            <option value="0">Select Designation</option>
                        </select>
                        <div class="invalid-feedback" id="lblDesignation"></div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Status <span class="text-danger">*</span></label>
                        <div class="p-2">
                            <div class="form-check form-check-inline mb-1">
                                <input type="radio" class="form-check-input" name="inlineRadioOptions" id="Active" value="ACTIVE" checked>
                                <label class="form-check-label" for="Active">Active</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input type="radio" class="form-check-input" name="inlineRadioOptions" id="InActive" value="INACTIVE">
                                <label class="form-check-label" for="InActive">Inactive</label>
                            </div>
                        </div>
                        <div class="invalid-feedback" id="lblreqradio"></div>
                    </div>

                    <!-- Additional Information -->
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Remarks</label>
                        <textarea id="txtremark" class="form-control" placeholder="Remarks" rows="3"></textarea>
                        <div class="invalid-feedback" id="lblreqremark"></div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Address</label>
                        <textarea id="txtAddress" class="form-control" placeholder="Address" rows="3"></textarea>
                    </div>
                </div>

                <!-- File Upload Section -->
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Upload Profile Image</label>
                        <div class="input-group flex-nowrap mb-2">
                            <span class="btn btn-primary fileinput-button me-1">
                                <i class="ph-file-plus me-2"></i>
                                <span>Add Profile Image</span>
                                <input type="file" name="files[]" accept="image/*" style="display: none" onchange="handleFileSelection(event)">
                            </span>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="table-responsive">
                            <table class="table table-panel text-nowrap mb-0">
                                <thead>
                                    <tr>
                                        <th>Preview</th>
                                        <th>File Info</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody class="files">
                                    <tr data-id="empty">
                                        <td colspan="3" class="text-center text-gray-500 py-30px">
                                            <div class="mb-10px"><i class="fa fa-file fa-3x"></i></div>
                                            <div class="fw-bold">No file selected</div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="row">
                    <div class="text-end">
                        <button id="btnSave" class="btn btn-primary" type="button">Save</button>
                        <button id="btnupdate" class="btn btn-primary" style="display: none" type="button">Update</button>
                        <button type="button" id="btnLogView" class="btn btn-dark" data-bs-toggle="modal" data-bs-target="#modal_xlarge">Log View</button>
                        <button id="btnclear" class="btn btn-flat-secondary" type="button">Clear</button>
                    </div>
                </div>
            </div>

            <!-- User Table -->
            <div class="card-body" id="divrow">
                <div id="bindata">
                    <table id="UserTable" class="table table-striped table-bordered">
                        <thead>
                            <tr id="tableHeadRow"></tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Log Modal -->
    <div id="modal_xlarge" class="modal fade" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">User Log</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <table id="UserTable_Log" class="table table-striped table-bordered">
                        <thead>
                            <tr id="tableHeadRow_Log"></tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>