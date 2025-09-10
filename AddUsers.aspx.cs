using System;
using System.Collections.Generic;
using System.Data;
using System.IdentityModel.Protocols.WSTrust;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AddUsers : System.Web.UI.Page
{
    static SqlCmd SqlCmds = new SqlCmd();
    static string[] Param = new string[30];
    static string[] PName = new string[30];
    static int Count = 0;
    static string msg = "";
    static string login_user = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        if (HttpContext.Current.Session["UserId"] == null)
        {
            Response.Redirect("/Login.aspx");
        }
        else
        {
            login_user = HttpContext.Current.Session["USERNAME"].ToString();
        }
    }
    public class UserModel
    {
        public string userid { get; set; }
        public string Username { get; set; }
        public string Fullname { get; set; }
        public string Phonenumber { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public string Base64Image { get; set; }
        public string DesignationName { get; set; }
        public string DesignationId { get; set; }
        public string StackHolderId { get; set; }
        public string StackHolderName { get; set; }
        public string LoginFrom { get; set; }
        public string COMPID { get; set; }
        public string ZONEID { get; set; }
        public string CIRID { get; set; }
        public string DIVID { get; set; }
        public string STNID { get; set; }
        public string Image { get; set; }
        public string Address { get; set; }

        // New properties for Entity management
        public string EntityID { get; set; }
        public string KPTCLGeneratorID { get; set; }
        public string GeneratorID { get; set; }
        public string IndividualGeneratorID { get; set; }
        public string Imagename { get; set; }
    }


    [WebMethod]
    public static Object GetStackholders()
    {
        object result = null;

        DataTable dt = SqlCmds.SelectQueryMaster("SP_AddUsers_Q1_RAGHAVA");

        if (dt != null && dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            result = "No data found";
        }
        return result;
    }


    [WebMethod]
    public static Object GetKPTCLGenerators()
    {
        object result = null;
        DataTable dt = SqlCmds.SelectQueryMaster("SP_AddUsers_GetKPTCLGenerator");
        if (dt != null && dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            result = "No data found";
        }
        return result;
    }

    [WebMethod]
    public static Object GetGenerators()
    {
        object result = null;
        DataTable dt = SqlCmds.SelectQueryMaster("SP_AddUsers_GetGeneratorStations");
        if (dt != null && dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            result = "No data found";
        }
        return result;
    }

    [WebMethod]
    public static Object GetIndividualGenerators(string entityId)
    {
        object result = null;
        Param[0] = entityId;
        PName[0] = "@EntityID";
        DataTable dt = SqlCmds.SelectDataMaster("SP_AddUsers_GetIndividualGenerator", Param, PName, Count = 1);
        if (dt != null && dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            result = "No data found";
        }
        return result;
    }

    [WebMethod]
    public static Object GetEscoms()
    {
        object result = null;

        DataTable dt = SqlCmds.SelectQueryMaster("SP_AddUsers_Q12_RAGHAVA");

        if (dt != null && dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            result = "No data found";
        }
        return result;
    }
    [WebMethod]
    public static Object GetZones(string COMPID)
    {
        object result = null;
        Param[0] = COMPID;
        PName[0] = "@COMPID";
        DataTable dt = SqlCmds.SelectDataMaster("SP_AddUsers_Q13_RAGHAVA", Param, PName, Count = 1);

        if (dt != null && dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            result = "No data found";
        }
        return result;
    }
    [WebMethod]
    public static Object GetCircles(string COMPID,string ZONEID)
    {
        object result = null;
        Param[0] = COMPID;
        PName[0] = "@COMPID";
        Param[1] = ZONEID;
        PName[1] = "@ZONEID";
        DataTable dt = SqlCmds.SelectDataMaster("SP_AddUsers_Q14_RAGHAVA", Param, PName, Count = 2);

        if (dt != null && dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            result = "No data found";
        }
        return result;
    }
    [WebMethod]
    public static Object GetDivisions(string COMPID,string ZONEID,string CIRID)
    {
        object result = null;
        Param[0] = COMPID;
        PName[0] = "@COMPID";
        Param[1] = ZONEID;
        PName[1] = "@ZONEID";
        Param[2] = CIRID;
        PName[2] = "@CIRID";
        DataTable dt = SqlCmds.SelectDataMaster("SP_AddUsers_Q15_RAGHAVA", Param, PName, Count = 3);

        if (dt != null && dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            result = "No data found";
        }
        return result;
    }
    [WebMethod]
    public static Object GetStations(string COMPID,string ZONEID,string CIRID,string DIVID)
    {
        object result = null;
        Param[0] = COMPID;
        PName[0] = "@COMPID";
        Param[1] = ZONEID;
        PName[1] = "@ZONEID";
        Param[2] = CIRID;
        PName[2] = "@CIRID";
        Param[3] = DIVID;
        PName[3] = "@DIVID";
        DataTable dt = SqlCmds.SelectDataMaster("SP_AddUsers_Q16_RAGHAVA", Param, PName, Count = 4);

        if (dt != null && dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            result = "No data found";
        }
        return result;
    }
    [WebMethod]
    public static Object GetDesignationBind()
    {
        object result = null;
        DataTable dt = SqlCmds.SelectQueryMaster("SP_ADDUSERS_Q2_RAGHAVA");

        if (dt != null && dt.Rows.Count > 0)
        {
            result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            result = "No data found";
        }
        return result;
    }

    [WebMethod]
    public static string saveUserData(UserModel user)
    {
        string fileName = "";
        string uid = "";
        string profileImagesDirectory = "";

        try
        {
            // Handle Image
            if (user.Image == "dynamic")
            {
                DataTable dt = SqlCmds.SelectQueryMaster("SP_ADDUSER_Q3");
                if (dt.Rows.Count > 0)
                {
                    uid = dt.Rows[0]["uid"].ToString();
                    int numericUid = int.Parse(uid);
                    fileName = "ProfileImage_" + (numericUid + 1) + ".png";
                }

                if (user.Base64Image.StartsWith("data:image"))
                {
                    int base64Index = user.Base64Image.IndexOf("base64,") + 7;
                    user.Base64Image = user.Base64Image.Substring(base64Index);
                }

                Directory.SetCurrentDirectory(AppDomain.CurrentDomain.BaseDirectory);
                profileImagesDirectory = Path.Combine("assets", "images", "ProfileImages").Replace("\\", "/");

                if (!Directory.Exists(profileImagesDirectory))
                {
                    Directory.CreateDirectory(profileImagesDirectory);
                }
                string fullFilePath = Path.Combine(profileImagesDirectory, fileName);
                byte[] fileBytes = Convert.FromBase64String(user.Base64Image);
                System.IO.File.WriteAllBytes(fullFilePath, fileBytes);
            }
            else
            {
                profileImagesDirectory = Path.Combine("assets", "images", "ProfileImages").Replace("\\", "/");
                fileName = "DefaultUser.jpg";
            }

            // Validation & Role Fetching
            Param[0] = user.Username;
            PName[0] = "@username";
            Param[1] = "";
            PName[1] = "@userid";

            DataTable chkuname = SqlCmds.SelectDataMaster("SP_ADDUSER_Q9", Param, PName, Count: 2);

            Param[0] = user.Phonenumber;
            PName[0] = "@phonenumber";
            Param[1] = "";
            PName[1] = "@userid";

            DataTable chkphno = SqlCmds.SelectDataMaster("SP_ADDUSER_Q7", Param, PName, Count: 2);

            Param[0] = user.Email.ToLower();
            PName[0] = "@email";
            Param[1] = "";
            PName[1] = "@userid";

            DataTable chkemail = SqlCmds.SelectDataMaster("SP_ADDUSER_Q8", Param, PName, Count: 2);

            // Get roles based on StackHolder & Designation
            Param[0] = user.StackHolderId;
            PName[0] = "@Sid";
            Param[1] = user.DesignationId;
            PName[1] = "@Did";

            DataTable dtroles = SqlCmds.SelectDataMaster("SP_Roles_Q1", Param, PName, Count: 2);
            string roles = dtroles.Rows.Count > 0 ? dtroles.Rows[0]["Id"].ToString() : "0";

            // Check duplicates
            if (chkuname.Rows.Count > 0) return "UNAME";
            if (chkphno.Rows.Count > 0) return "PHNO";
            if (chkemail.Rows.Count > 0) return "EMAIL";

            // Insert User
            Param[0] = user.Username; PName[0] = "@username";
            Param[1] = user.Fullname; PName[1] = "@fullname";
            Param[2] = user.Phonenumber; PName[2] = "@phonenumber";
            Param[3] = user.Email.ToLower(); PName[3] = "@email";
            Param[4] = Encryptus(user.Password); PName[4] = "@password";
            Param[5] = roles; PName[5] = "@role";
            Param[6] = user.Remarks; PName[6] = "@remarks";
            Param[7] = user.Status; PName[7] = "@status";
            Param[8] = fileName; PName[8] = "@imagename";
            Param[9] = user.LoginFrom; PName[9] = "@loginfrom";
            Param[10] = profileImagesDirectory + "/" + fileName; PName[10] = "@profilepath";
            Param[11] = login_user; PName[11] = "@addedby";
            Param[12] = user.Address; PName[12] = "@address";
            Param[13] = user.StackHolderName; PName[13] = "@STACKHOLDER_NAME";
            Param[14] = user.StackHolderId; PName[14] = "@STACKHOLDER_ID";
            Param[15] = user.DesignationId; PName[15] = "@DESIGNATION_ID";
            Param[16] = user.DesignationName; PName[16] = "@DESIGNATION_NAME";
            Param[17] = user.COMPID ?? "0"; PName[17] = "@ESCOMID";
            Param[18] = user.ZONEID ?? "0"; PName[18] = "@ZONEID";
            Param[19] = user.CIRID ?? "0"; PName[19] = "@CIRCLEID";
            Param[20] = user.DIVID ?? "0"; PName[20] = "@DIVISIONID";
            Param[21] = user.STNID ?? "0"; PName[21] = "@STATIONID";
            int i = SqlCmds.ExecNonQueryMaster("SP_ADDUSER_Q4_Raghava", Param, PName, Count: 22);

            return i > 0 ? "User Saved Successfully" : "Failed To Save the User";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }

    [WebMethod]
    public static string saveuser(string username, string fullname, string phonenumber, string email,
   string password, string remarks, string status, string base64Image, string DesignationName, string DesignationId, string StackHolderId, string StackHolderName,
   string loginfrom, string image, string Address)
    {
        string fileName = ""; string uid = ""; string profileImagesDirectory = "";
        try
        {

            if (image == "dynamic")
            {
                DataTable dt = SqlCmds.SelectQueryMaster("SP_ADDUSER_Q3");
                if (dt.Rows.Count > 0)
                {
                    uid = dt.Rows[0]["uid"].ToString();
                    int numericUid = int.Parse(uid);
                    fileName = "ProfileImage_" + (numericUid + 1) + ".png";
                }

                if (base64Image.StartsWith("data:image"))
                {
                    int base64Index = base64Image.IndexOf("base64,") + 7;
                    base64Image = base64Image.Substring(base64Index);
                }

                Directory.SetCurrentDirectory(AppDomain.CurrentDomain.BaseDirectory);
                profileImagesDirectory = Path.Combine("assets", "images", "ProfileImages");
                profileImagesDirectory = profileImagesDirectory.Replace("\\", "/");

                if (!Directory.Exists(profileImagesDirectory))
                {
                    Directory.CreateDirectory(profileImagesDirectory);
                }
                string fullFilePath = Path.Combine(profileImagesDirectory, fileName);
                byte[] fileBytes = Convert.FromBase64String(base64Image);
                System.IO.File.WriteAllBytes(fullFilePath, fileBytes);
            }
            else
            {
                profileImagesDirectory = Path.Combine("assets", "images", "ProfileImages");
                profileImagesDirectory = profileImagesDirectory.Replace("\\", "/");
                fileName = "DefaultUser.jpg";
            }


            Param[0] = username;
            PName[0] = "@username";
            Param[1] = "";
            PName[1] = "@userid";
            Count = 2;
            DataTable chkuname = SqlCmds.SelectDataMaster("SP_ADDUSER_Q9", Param, PName, Count: 2);

            Param[0] = phonenumber;
            PName[0] = "@phonenumber"; Param[1] = "";
            PName[1] = "@userid";
            DataTable chkphno = SqlCmds.SelectDataMaster("SP_ADDUSER_Q7", Param, PName, Count: 2);

            Param[0] = email.ToLower();
            PName[0] = "@email"; Param[1] = "";
            PName[1] = "@userid";
            DataTable chkemail = SqlCmds.SelectDataMaster("SP_ADDUSER_Q8", Param, PName, Count: 2);

                


            Param[0] = StackHolderId;
            PName[0] = "@Sid";
            Param[1] = DesignationId;
            PName[1] = "@Did";
            DataTable dtroles = SqlCmds.SelectDataMaster("SP_Roles_Q1", Param, PName, Count: 2);

            string roles = "0";

            if (dtroles.Rows.Count > 0)
            {
                roles = dtroles.Rows[0]["Id"].ToString();
            }

            if (chkuname.Rows.Count > 0)
            {
                return "UNAME";
            }

            else if (chkphno.Rows.Count > 0)
            {
                return "PHNO";
            }

            else if (chkemail.Rows.Count > 0)
            {
                return "EMAIL";
            }
            else
            {
                Param[0] = username; PName[0] = "@username";
                Param[1] = fullname; PName[1] = "@fullname";
                Param[2] = phonenumber; PName[2] = "@phonenumber";
                Param[3] = email.ToLower(); PName[3] = "@email";
                Param[4] = Encryptus(password); PName[4] = "@password";
                Param[5] = roles; PName[5] = "@role";
                Param[6] = remarks; PName[6] = "@remarks";
                Param[7] = status; PName[7] = "@status";
                Param[8] = fileName; PName[8] = "@imagename";
                Param[9] = loginfrom; PName[9] = "@loginfrom";
                Param[10] = profileImagesDirectory + "/" + fileName; PName[10] = "@profilepath";
                Param[11] = login_user; PName[11] = "@addedby";
                Param[12] = Address; PName[12] = "@address";
                Param[13] = StackHolderName; PName[13] = "@STACKHOLDER_NAME";
                Param[14] = StackHolderId; PName[14] = "@STACKHOLDER_ID";
                Param[15] = DesignationId; PName[15] = "@DESIGNATION_ID";
                Param[16] = DesignationName; PName[16] = "@DESIGNATION_NAME";

                //  int i = 1;
                int i = SqlCmds.ExecNonQueryMaster("SP_ADDUSER_Q4", Param, PName, Count = 17);
                if (i > 0)
                {
                    return "User Saved Successfully";
                }
                else
                {
                    return "Failed To Save the User";
                }
            }
        }
        catch (Exception ex)
        {
            return ex.Message;
        }

    }


    private static string Encryptus(string password)
    {
        string EncryptionKey = "TVDCOMKPTCLKARN123";
        byte[] clearBytes = Encoding.Unicode.GetBytes(password);
        using (Aes encryptor = Aes.Create())
        {
            Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
            encryptor.Key = pdb.GetBytes(32);
            encryptor.IV = pdb.GetBytes(16);
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(clearBytes, 0, clearBytes.Length);
                    cs.Close();
                }
                password = Convert.ToBase64String(ms.ToArray());
            }
        }
        return password;
    }

    public static string Decrypt(string password)
    {
        string pass = password;
        string EncryptionKey = "TVDCOMKPTCLKARN123";
        byte[] cipherBytes = Convert.FromBase64String(pass);
        using (Aes encryptor = Aes.Create())
        {
            Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
            encryptor.Key = pdb.GetBytes(32);
            encryptor.IV = pdb.GetBytes(16);
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(cipherBytes, 0, cipherBytes.Length);
                    cs.Close();
                }
                password = Encoding.Unicode.GetString(ms.ToArray());
            }
        }
        return password;
    }

    [WebMethod]
    public static Object BindData()
    {
        object result = null;
        try
        {

            DataTable dt = SqlCmds.SelectQueryMaster("SP_ADDUSER_Q5_NEW");

            if (dt != null && dt.Rows.Count > 0)
            {
                for (int i = 0; dt.Rows.Count > i; i++)
                {
                    string pass = dt.Rows[i]["PASSWORD"].ToString();
                    pass = Decrypt(pass);
                    dt.Rows[i]["PASSWORD"] = pass;
                }

                result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
            {
                result = "No data found";
            }

            return result;

        }
        catch (Exception ex)
        {

        }
        return null;
    }


    [WebMethod]
    public static string updatedetils(string username, string fullname, string phonenumber, string email,
    string password, string DesignationName, string DesignationId, string StackHolderId, string StackHolderName, string Address,
       string remarks, string status, string imagename, string base64Image, string loginfrom, string userid, string bindpath, string bindimage)
    {
        string fileName = ""; string uid = ""; string profileImagesDirectory = "";
        try
        {
            uid = userid;

            if (imagename != "" && imagename != null && base64Image != "" && base64Image != null)
            {
                if (base64Image.StartsWith("data:image"))
                {
                    int base64Index = base64Image.IndexOf("base64,") + 7;
                    base64Image = base64Image.Substring(base64Index);
                }
                Directory.SetCurrentDirectory(AppDomain.CurrentDomain.BaseDirectory);
                int numericUid = int.Parse(uid);
                fileName = "ProfileImage_" + (numericUid) + ".jpg";
                profileImagesDirectory = Path.Combine("assets", "images", "ProfileImages");
                profileImagesDirectory = profileImagesDirectory.Replace("\\", "/");
                if (!Directory.Exists(profileImagesDirectory))
                {
                    Directory.CreateDirectory(profileImagesDirectory);
                }

                // Directory.CreateDirectory(profileImagesDirectory);
                string fullFilePath = Path.Combine(profileImagesDirectory, fileName);
                byte[] fileBytes = Convert.FromBase64String(base64Image);
                System.IO.File.WriteAllBytes(fullFilePath, fileBytes);
            }
            Param[0] = username;
            PName[0] = "@username";
            Param[1] = uid;
            PName[1] = "@userid";
            Count = 2;
            DataTable chkuname = SqlCmds.SelectDataMaster("SP_ADDUSER_Q9", Param, PName, Count: 2);

            Param[0] = phonenumber; 
            PName[0] = "@phonenumber"; Param[1] = uid;
            PName[1] = "@userid";
            DataTable chkphno = SqlCmds.SelectDataMaster("SP_ADDUSER_Q7", Param, PName, Count: 2);

            Param[0] = email.ToLower();
            PName[0] = "@email"; Param[1] = uid;
            PName[1] = "@userid";
            DataTable chkemail = SqlCmds.SelectDataMaster("SP_ADDUSER_Q8", Param, PName, Count: 2);



            Param[0] = StackHolderId;
            PName[0] = "@Sid";
            Param[1] = DesignationId;
            PName[1] = "@Did";
            DataTable dtroles = SqlCmds.SelectDataMaster("SP_Roles_Q1", Param, PName, Count: 2);

            string roles = "0";

            if (dtroles.Rows.Count > 0) 
            {
                roles = dtroles.Rows[0]["Id"].ToString();
            }




            if (chkuname.Rows.Count > 0)
            {
                return "UNAME";
            }

            else if (chkphno.Rows.Count > 0)
            {
                return "PHNO";
            }

            else if (chkemail.Rows.Count > 0)
            {
                return "EMAIL";
            }

            else
            {

                Param[0] = username; PName[0] = "@username";
                Param[1] = fullname; PName[1] = "@fullname";
                Param[2] = phonenumber; PName[2] = "@phonenumber";
                Param[3] = email.ToLower(); PName[3] = "@email";
                Param[4] = Encryptus(password); PName[4] = "@password";
                Param[5] = StackHolderId; PName[5] = "@STACKHOLDER_ID";
                Param[6] = StackHolderName; PName[6] = "@STACKHOLDER_NAME";
                Param[7] = roles; PName[7] = "@role";
                Param[8] = remarks; PName[8] = "@remarks";
                Param[9] = status; PName[9] = "@status";

                if (fileName == "" || fileName == null)
                {
                    if (bindimage == "" || bindimage == null)
                    {
                        Param[10] = "DefaultUser.jpg"; PName[10] = "@imagename";

                    }
                    else
                    {
                        Param[10] = bindimage; PName[10] = "@imagename";

                    }
                }
                else
                {
                    Param[10] = fileName; PName[10] = "@imagename";

                }

                Param[11] = loginfrom; PName[11] = "@loginfrom";
                if (profileImagesDirectory == "" || profileImagesDirectory == null)
                {
                    if (bindpath == "" || bindpath == null)
                    {
                        Param[12] = "assets\\images\\ProfileImages\\DefaultUser.jpg"; PName[12] = "@profilepath";

                    }
                    else
                    {
                        Param[12] = bindpath; PName[12] = "@profilepath";

                    }

                }
                else
                {
                    Param[12] = profileImagesDirectory + "/" + fileName; PName[12] = "@profilepath";


                }
                Param[13] = login_user; PName[13] = "@addedby";
                Param[14] = DesignationId; PName[14] = "@DESIGNATION_ID";
                Param[15] = userid;  PName[15] = "@UID";
                Param[16] = DesignationName; PName[16] = "@DESIGNATION_NAME";
                Param[17] = Address; PName[17] = "@Address";
             //   int i = 1;
                 int i = SqlCmds.ExecNonQueryMaster("SP_ADDUSER_Q6", Param, PName, Count = 18);
                if (i > 0)
                {
                    return "User Updated Successfully";
                }
                else
                {
                    return "Failed To Save the User";
                }
            }



        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }

    [WebMethod]
    public static Object BindData_log()
    {
        object result = null;
        try
        {

            DataTable dt = SqlCmds.SelectQueryMaster("SP_ADDUSER_11");

            if (dt != null && dt.Rows.Count > 0)
            {
                for (int i = 0; dt.Rows.Count > i; i++)
                {
                    string pass = dt.Rows[i]["PASSWORD"].ToString();
                    pass = Decrypt(pass);
                    dt.Rows[i]["PASSWORD"] = pass;
                }

                result = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
            else
            {
                result = "No data found";
            }

            return result;

        }
        catch (Exception ex)
        {

        }
        return null;
    }

    [WebMethod]
    public static string deleteimage(string userid)
    {
        try
        {
            Param[0] = userid;
            PName[0] = "@userid";
            int i = SqlCmds.ExecNonQueryMaster("SP_ADDUSER_Q10", Param, PName, Count = 1);
            return i > 0 ? "Image Deleted successfully" : "";

        }
        catch (Exception ex)
        {
            return ex.Message;
        }

    }




    [WebMethod]
    public static string saveUserDataNew(UserModel user)
    {
        string fileName = "";
        string uid = "";
        string profileImagesDirectory = "";

        try
        {
            // Handle Image Upload (existing logic)
            if (user.Image == "dynamic")
            {
                DataTable dt = SqlCmds.SelectQueryMaster("SP_ADDUSER_Q3");
                if (dt.Rows.Count > 0)
                {
                    uid = dt.Rows[0]["uid"].ToString();
                    int numericUid = int.Parse(uid);
                    fileName = "ProfileImage_" + (numericUid + 1) + ".png";
                }

                if (user.Base64Image.StartsWith("data:image"))
                {
                    int base64Index = user.Base64Image.IndexOf("base64,") + 7;
                    user.Base64Image = user.Base64Image.Substring(base64Index);
                }

                Directory.SetCurrentDirectory(AppDomain.CurrentDomain.BaseDirectory);
                profileImagesDirectory = Path.Combine("assets", "images", "ProfileImages").Replace("\\", "/");

                if (!Directory.Exists(profileImagesDirectory))
                {
                    Directory.CreateDirectory(profileImagesDirectory);
                }
                string fullFilePath = Path.Combine(profileImagesDirectory, fileName);
                byte[] fileBytes = Convert.FromBase64String(user.Base64Image);
                System.IO.File.WriteAllBytes(fullFilePath, fileBytes);
            }
            else
            {
                profileImagesDirectory = Path.Combine("assets", "images", "ProfileImages").Replace("\\", "/");
                fileName = "DefaultUser.jpg";
            }

            // Validation for duplicates
            Param[0] = user.Username;
            PName[0] = "@username";
            Param[1] = "";
            PName[1] = "@userid";
            DataTable chkuname = SqlCmds.SelectDataMaster("SP_ADDUSER_Q9", Param, PName, Count: 2);

            Param[0] = user.Phonenumber;
            PName[0] = "@phonenumber";
            Param[1] = "";
            PName[1] = "@userid";
            DataTable chkphno = SqlCmds.SelectDataMaster("SP_ADDUSER_Q7", Param, PName, Count: 2);

            Param[0] = user.Email.ToLower();
            PName[0] = "@email";
            Param[1] = "";
            PName[1] = "@userid";
            DataTable chkemail = SqlCmds.SelectDataMaster("SP_ADDUSER_Q8", Param, PName, Count: 2);

            // New validation for Entity/Generator duplicates
            string entityValue = "";
            string inGenId = "";

            if (user.LoginFrom == "OFFICER" && !string.IsNullOrEmpty(user.EntityID))
            {
                entityValue = user.EntityID;
                // Check for Entity duplicate
                Param[0] = entityValue;
                PName[0] = "@entityId";
                Param[1] = "";
                PName[1] = "@userid";
                DataTable chkEntity = SqlCmds.SelectDataMaster("SP_CheckEntityDuplicate", Param, PName, Count: 2);
                if (chkEntity.Rows.Count > 0) return "ENTITY_DUPLICATE";
            }
            else if (user.LoginFrom == "IPP")
            {
                if (user.StackHolderName == "KPTCL Generator")
                {
                    entityValue = user.KPTCLGeneratorID;
                    // Check KPTCL Generator duplicate
                    Param[0] = entityValue;
                    PName[0] = "@entityId";
                    Param[1] = "";
                    PName[1] = "@userid";
                    DataTable chkKPTCL = SqlCmds.SelectDataMaster("SP_CheckKPTCLDuplicate", Param, PName, Count: 2);
                    if (chkKPTCL.Rows.Count > 0) return "KPTCL_DUPLICATE";
                }
                else if (user.StackHolderName == "Generator")
                {
                    entityValue = user.GeneratorID;
                    // Check Generator duplicate
                    Param[0] = entityValue;
                    PName[0] = "@entityId";
                    Param[1] = "";
                    PName[1] = "@userid";
                    DataTable chkGenerator = SqlCmds.SelectDataMaster("SP_CheckGeneratorDuplicate", Param, PName, Count: 2);
                    if (chkGenerator.Rows.Count > 0) return "GENERATOR_DUPLICATE";
                }
                else if (user.StackHolderName == "Individual Generator")
                {
                    entityValue = user.GeneratorID;
                    inGenId = user.IndividualGeneratorID;
                    // Check Individual Generator combination duplicate
                    Param[0] = entityValue;
                    PName[0] = "@generatorId";
                    Param[1] = inGenId;
                    PName[1] = "@individualGenId";
                    Param[2] = "";
                    PName[2] = "@userid";
                    DataTable chkIndividual = SqlCmds.SelectDataMaster("SP_CheckIndividualDuplicate", Param, PName, Count: 3);
                    if (chkIndividual.Rows.Count > 0) return "INDIVIDUAL_DUPLICATE";
                }
            }

            // Get roles based on StackHolder & Designation
            Param[0] = user.StackHolderId;
            PName[0] = "@Sid";
            Param[1] = user.DesignationId;
            PName[1] = "@Did";
            DataTable dtroles = SqlCmds.SelectDataMaster("SP_Roles_Q1", Param, PName, Count: 2);
            string roles = dtroles.Rows.Count > 0 ? dtroles.Rows[0]["Id"].ToString() : "0";

            // Check basic duplicates
            if (chkuname.Rows.Count > 0) return "UNAME";
            if (chkphno.Rows.Count > 0) return "PHNO";
            if (chkemail.Rows.Count > 0) return "EMAIL";

            // Insert User
            Param[0] = user.Username; PName[0] = "@username";
            Param[1] = user.Fullname; PName[1] = "@fullname";
            Param[2] = user.Phonenumber; PName[2] = "@phonenumber";
            Param[3] = user.Email.ToLower(); PName[3] = "@email";
            Param[4] = Encryptus(user.Password); PName[4] = "@password";
            Param[5] = roles; PName[5] = "@role";
            Param[6] = user.Remarks; PName[6] = "@remarks";
            Param[7] = user.Status; PName[7] = "@status";
            Param[8] = fileName; PName[8] = "@imagename";
            Param[9] = user.LoginFrom; PName[9] = "@loginfrom";
            Param[10] = profileImagesDirectory + "/" + fileName; PName[10] = "@profilepath";
            Param[11] = login_user; PName[11] = "@addedby";
            Param[12] = user.Address; PName[12] = "@address";
            Param[13] = user.StackHolderName; PName[13] = "@STACKHOLDER_NAME";
            Param[14] = user.StackHolderId; PName[14] = "@STACKHOLDER_ID";
            Param[15] = user.DesignationId; PName[15] = "@DESIGNATION_ID";
            Param[16] = user.DesignationName; PName[16] = "@DESIGNATION_NAME";
            Param[17] = user.COMPID ?? "0"; PName[17] = "@ESCOMID";
            Param[18] = user.ZONEID ?? "0"; PName[18] = "@ZONEID";
            Param[19] = user.CIRID ?? "0"; PName[19] = "@CIRCLEID";
            Param[20] = user.DIVID ?? "0"; PName[20] = "@DIVISIONID";
            Param[21] = user.STNID ?? "0"; PName[21] = "@STATIONID";
            Param[22] = entityValue; PName[22] = "@ENTITYID";
            Param[23] = inGenId; PName[23] = "@IN_GENID";

            int i = SqlCmds.ExecNonQueryMaster("SP_ADDUSER_Q4_NEW", Param, PName, Count: 24);

            return i > 0 ? "User Saved Successfully" : "Failed To Save the User";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }
    [WebMethod]
    public static string updateUserDataNew(UserModel user)
    {
        string fileName = "";
        string profileImagesDirectory = "";
        string userid = user.userid; // Get UID from model

        try
        {
            // Handle image update logic
            if (!string.IsNullOrEmpty(user.Imagename) && !string.IsNullOrEmpty(user.Base64Image))
            {
                if (user.Base64Image.StartsWith("data:image"))
                {
                    int base64Index = user.Base64Image.IndexOf("base64,") + 7;
                    user.Base64Image = user.Base64Image.Substring(base64Index);
                }
                Directory.SetCurrentDirectory(AppDomain.CurrentDomain.BaseDirectory);
                fileName = "ProfileImage_" + userid + ".jpg";
                profileImagesDirectory = Path.Combine("assets", "images", "ProfileImages").Replace("\\", "/");
                if (!Directory.Exists(profileImagesDirectory))
                {
                    Directory.CreateDirectory(profileImagesDirectory);
                }
                string fullFilePath = Path.Combine(profileImagesDirectory, fileName);
                byte[] fileBytes = Convert.FromBase64String(user.Base64Image);
                System.IO.File.WriteAllBytes(fullFilePath, fileBytes);
            }

            // Duplicate validation with userid exclusion
            Param[0] = user.Username;
            PName[0] = "@username";
            Param[1] = userid;
            PName[1] = "@userid";
            DataTable chkuname = SqlCmds.SelectDataMaster("SP_ADDUSER_Q9", Param, PName, Count: 2);

            Param[0] = user.Phonenumber;
            PName[0] = "@phonenumber";
            Param[1] = userid;
            PName[1] = "@userid";
            DataTable chkphno = SqlCmds.SelectDataMaster("SP_ADDUSER_Q7", Param, PName, Count: 2);

            Param[0] = user.Email.ToLower();
            PName[0] = "@email";
            Param[1] = userid;
            PName[1] = "@userid";
            DataTable chkemail = SqlCmds.SelectDataMaster("SP_ADDUSER_Q8", Param, PName, Count: 2);

            // Entity/Generator duplicate validation with userid exclusion
            string entityValue = "";
            string inGenId = "";

            if (user.LoginFrom == "OFFICER" && !string.IsNullOrEmpty(user.EntityID))
            {
                entityValue = user.EntityID;
                Param[0] = entityValue;
                PName[0] = "@entityId";
                Param[1] = userid;
                PName[1] = "@userid";
                DataTable chkEntity = SqlCmds.SelectDataMaster("SP_CheckEntityDuplicate", Param, PName, Count: 2);
                if (chkEntity.Rows.Count > 0) return "ENTITY_DUPLICATE";
            }
            else if (user.LoginFrom == "IPP")
            {
                if (user.StackHolderName == "KPTCL Generator")
                {
                    entityValue = user.KPTCLGeneratorID;
                    Param[0] = entityValue;
                    PName[0] = "@entityId";
                    Param[1] = userid;
                    PName[1] = "@userid";
                    DataTable chkKPTCL = SqlCmds.SelectDataMaster("SP_CheckKPTCLDuplicate", Param, PName, Count: 2);
                    if (chkKPTCL.Rows.Count > 0) return "KPTCL_DUPLICATE";
                }
                else if (user.StackHolderName == "Generator")
                {
                    entityValue = user.GeneratorID;
                    Param[0] = entityValue;
                    PName[0] = "@entityId";
                    Param[1] = userid;
                    PName[1] = "@userid";
                    DataTable chkGenerator = SqlCmds.SelectDataMaster("SP_CheckGeneratorDuplicate", Param, PName, Count: 2);
                    if (chkGenerator.Rows.Count > 0) return "GENERATOR_DUPLICATE";
                }
                else if (user.StackHolderName == "Individual Generator")
                {
                    entityValue = user.GeneratorID;
                    inGenId = user.IndividualGeneratorID;
                    Param[0] = entityValue;
                    PName[0] = "@generatorId";
                    Param[1] = inGenId;
                    PName[1] = "@individualGenId";
                    Param[2] = userid;
                    PName[2] = "@userid";
                    DataTable chkIndividual = SqlCmds.SelectDataMaster("SP_CheckIndividualDuplicate", Param, PName, Count: 3);
                    if (chkIndividual.Rows.Count > 0) return "INDIVIDUAL_DUPLICATE";
                }
            }

            // Get roles
            Param[0] = user.StackHolderId;
            PName[0] = "@Sid";
            Param[1] = user.DesignationId;
            PName[1] = "@Did";
            DataTable dtroles = SqlCmds.SelectDataMaster("SP_Roles_Q1", Param, PName, Count: 2);
            string roles = dtroles.Rows.Count > 0 ? dtroles.Rows[0]["Id"].ToString() : "0";

            // Check basic duplicates
            if (chkuname.Rows.Count > 0) return "UNAME";
            if (chkphno.Rows.Count > 0) return "PHNO";
            if (chkemail.Rows.Count > 0) return "EMAIL";

            // Update user
            Param[0] = user.Username; PName[0] = "@username";
            Param[1] = user.Fullname; PName[1] = "@fullname";
            Param[2] = user.Phonenumber; PName[2] = "@phonenumber";
            Param[3] = user.Email.ToLower(); PName[3] = "@email";
            Param[4] = Encryptus(user.Password); PName[4] = "@password";
            Param[5] = user.StackHolderId; PName[5] = "@STACKHOLDER_ID";
            Param[6] = user.StackHolderName; PName[6] = "@STACKHOLDER_NAME";
            Param[7] = user.DesignationId; PName[7] = "@DESIGNATION_ID";
            Param[8] = user.DesignationName; PName[8] = "@DESIGNATION_NAME";
            Param[9] = roles; PName[9] = "@role";
            Param[10] = user.Remarks; PName[10] = "@remarks";
            Param[11] = user.Status; PName[11] = "@status";
            Param[12] = fileName; PName[12] = "@imagename";
            Param[13] = user.LoginFrom; PName[13] = "@loginfrom";
            Param[14] = profileImagesDirectory + "/" + fileName; PName[14] = "@profilepath";
            Param[15] = login_user; PName[15] = "@addedby";
            Param[16] = user.Address; PName[16] = "@Address";
            Param[17] = userid; PName[17] = "@UID";
            Param[18] = user.COMPID ?? "0"; PName[18] = "@ESCOMID";
            Param[19] = user.ZONEID ?? "0"; PName[19] = "@ZONEID";
            Param[20] = user.CIRID ?? "0"; PName[20] = "@CIRCLEID";
            Param[21] = user.DIVID ?? "0"; PName[21] = "@DIVISIONID";
            Param[22] = user.STNID ?? "0"; PName[22] = "@STATIONID";
            Param[23] = entityValue; PName[23] = "@ENTITYID";
            Param[24] = inGenId; PName[24] = "@IN_GENID";

            int i = SqlCmds.ExecNonQueryMaster("SP_ADDUSER_Q6_NEW", Param, PName, Count: 25);
            return i > 0 ? "User Updated Successfully" : "Failed To Update the User";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }
}