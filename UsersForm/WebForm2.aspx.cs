using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Linq;
using System.IO;
using System.Data;



namespace UsersForm
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        
        public DataTable Tabl_Users;
        public DataTable Tabl_UserType;
        protected void Page_Load(object sender, EventArgs e)
        {
            
            LoadDataSourse();
        }

        private String Patch()
        {
            string rootPath = Server.MapPath("~");
            string patch = rootPath + @"DataContent\";
            return patch;
        }

        public DataTable ReadJson_UserTypes()
        {
            DataTable dt = new DataTable();


            List<UserTypes> UserTypesT = new List<UserTypes>();
            UserTypesT = JsonConvert.DeserializeObject<List<UserTypes>>(File.ReadAllText(Patch() + "UserTypes.json"));

            //  Заполнение
            dt.Columns.Add("id");
            dt.Columns.Add("Type_Name");
            dt.Columns.Add("Allow_edit");


            foreach (var i in UserTypesT)
            {
                DataRow NewR = dt.NewRow();
                NewR["id"] = i.id;
                NewR["Type_Name"] = i.name;
                NewR["Allow_edit"] = i.allow_edit;

                dt.Rows.Add(NewR);
            }

            return dt;
        }

        public DataTable ReadJson_Users()
        {           

            List<Users> UserT = new List<Users>();
            UserT = JsonConvert.DeserializeObject<List<Users>>(File.ReadAllText(Patch() + "Users.json"));


            DataTable dt2 = new DataTable();
            //  Заполнение
            dt2.Columns.Add("id");
            dt2.Columns.Add("login");
            dt2.Columns.Add("password");
            dt2.Columns.Add("name");
            dt2.Columns.Add("type_id");
            dt2.Columns.Add("last_visit_date");


            foreach (var i in UserT)
            {
                DataRow NewR = dt2.NewRow();
                NewR["id"] = i.id;
                NewR["login"] = i.login;
                NewR["password"] = i.password;
                NewR["name"] = i.name;
                NewR["type_id"] = i.type_id;
                NewR["last_visit_date"] = i.last_visit_date;

                dt2.Rows.Add(NewR);
            }

            return dt2;
        }

        public DataTable Join_Users_UserTypes()
        {
            IEnumerable<Users_i> query = from Us in Tabl_Users.AsEnumerable()
                        join UsType in Tabl_UserType.AsEnumerable()
                        on Us["type_id"] equals UsType["id"] into TabResult
                        from or in TabResult
                        select new Users_i
                        {
                            id = int.Parse(Us["id"].ToString()),
                            login = Us["login"].ToString(),
                            password = Us["password"].ToString(),
                            name = Us["name"].ToString(),
                            allow_edit = bool.Parse(or["Allow_edit"].ToString()),
                            nameType = or["Type_Name"].ToString(),
                            last_visit_date = Us["last_visit_date"].ToString()
                        };

            return CreateUsers(query);
        }

        public DataTable Join_Users_UserTypes_Filter(string UserType_ID)
        {
            //Накладываем фильтр
            IEnumerable<Users_i> query = from Us in Tabl_Users.AsEnumerable()
                        join UsType in Tabl_UserType.AsEnumerable()
                        on Us["type_id"] equals UsType["id"] into TabResult
                        from or in TabResult
                        where Us["type_id"].ToString() == UserType_ID
                        select new Users_i
                        {
                            id= int.Parse(Us["id"].ToString()),
                            login = Us["login"].ToString(),
                            password = Us["password"].ToString(),
                            name = Us["name"].ToString(),
                            allow_edit = bool.Parse(or["Allow_edit"].ToString()),
                            nameType = or["Type_Name"].ToString(),
                            last_visit_date = Us["last_visit_date"].ToString()
                            
                        };

            return CreateUsers(query);

        }

        private DataTable CreateUsers(IEnumerable<Users_i> JoinQuery)
        {
            DataTable dtResult = new DataTable();

            //  Заполнение
            dtResult.Columns.Add("id");
            dtResult.Columns.Add("login");
            dtResult.Columns.Add("password");
            dtResult.Columns.Add("UserName");
            dtResult.Columns.Add("TypeName");
            dtResult.Columns.Add("Allow_edit");
            dtResult.Columns.Add("last_visit_date");

            foreach (var i in JoinQuery)
            {
                DataRow NewR = dtResult.NewRow();

                NewR["id"] = i.id;
                NewR["login"] = i.login;
                NewR["password"] = i.password;
                NewR["UserName"] = i.name;
                NewR["TypeName"] = i.nameType;
                NewR["Allow_edit"] = i.allow_edit;
                NewR["last_visit_date"] = i.last_visit_date;

                dtResult.Rows.Add(NewR);
            }
            return dtResult;
        }

        public void LoadDataSourse()
        {
            
            Tabl_Users = ReadJson_Users();
            Tabl_UserType = ReadJson_UserTypes();

        }

        public void Write_NewUser(int id, string login, string password, string UserName, int type_id, string last_visit_date)
        {

            Users DataUsers_Row = new Users();

            DataUsers_Row.id = id;
            DataUsers_Row.login = login;
            DataUsers_Row.password = password;
            DataUsers_Row.name = UserName;
            DataUsers_Row.type_id = type_id;
            DataUsers_Row.last_visit_date = last_visit_date;



            List<Users> UserT = new List<Users>();
            UserT = JsonConvert.DeserializeObject<List<Users>>(File.ReadAllText(Patch() + "Users.json"));

            UserT.Add(DataUsers_Row);

            // UserT.Add(DataUsers);
            string json = JsonConvert.SerializeObject(UserT.ToArray());

            //write string to file
            System.IO.File.WriteAllText(Patch() + "Users.json", json);

        }

        public void Update_UsersT(int id, string login, string password, string name, int type_id, string last_visit_date)
        {
            List<Users> UserT = new List<Users>();

            UserT = JsonConvert.DeserializeObject<List<Users>>(File.ReadAllText(Patch() + "Users.json"));

            for (int i = 0; i < UserT.Count; i++)
            {
                if (UserT[i].id == id)
                {
                    UserT[i].login = login;
                    UserT[i].password = password;
                    UserT[i].name = name;
                    UserT[i].type_id = type_id;
                    UserT[i].last_visit_date = last_visit_date;
                    break;
                }
            }

            // UserT.Add(DataUsers);
            string json = JsonConvert.SerializeObject(UserT.ToArray());

            //write string to file
            System.IO.File.WriteAllText(Patch() + "Users.json", json);
        }

        public int User_id_Last()
        {   
            // Возвращает ID последнего пользователя
            List<Users> UserT = new List<Users>();

            UserT = JsonConvert.DeserializeObject<List<Users>>(File.ReadAllText(Patch() + "Users.json"));
            int id_U = UserT[UserT.Count-1].id;

            return id_U;

        }

        public void Delete_User(int id)
        {   
            //Удаляет пользователя
            List<Users> UserT = new List<Users>();

            UserT = JsonConvert.DeserializeObject<List<Users>>(File.ReadAllText(Patch() + "Users.json"));

            for (int i = 0; i < UserT.Count; i++)
            {
                if (UserT[i].id == id)
                {
                    UserT.RemoveAt(i);

                    break;
                }
            }

            // UserT.Add(DataUsers);
            string json = JsonConvert.SerializeObject(UserT.ToArray());

            //write string to file
            System.IO.File.WriteAllText(Patch() + "Users.json", json);
        }
    }
}