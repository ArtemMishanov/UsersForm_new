using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UsersForm
{
    
    
    public class Users
    {
        public int id { get; set; }
        public string login { get; set; }
        public string password { get; set; }
        public string name { get; set; }
        public int type_id { get; set; } //типа пользователя
        public string last_visit_date { get; set; } //Дата последнего визита
    }

    public class UserTypes
    {
        public int id { get; set; }
        public string name { get; set; } //Наименование типа пользователя
        public bool allow_edit { get; set; } //прав на редактирование данных пользователей
    }

    public class Users_i
    {
        public int id { get; set; }
        public string login { get; set; }
        public string password { get; set; }
        public string name { get; set; }
        public bool allow_edit { get; set; }
        public string nameType { get; set; }
        public string last_visit_date { get; set; } //Дата последнего визита
    }
}