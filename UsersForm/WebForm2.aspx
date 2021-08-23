<%@ Page Language="C#" AutoEventWireup="True" %>
<%@ Import Namespace="System.Data" %><%@ Import Namespace="Newtonsoft.Json"  %><%@ Import Namespace="System.IO" %><%@ Import Namespace="UsersForm"%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
   
    <script runat="server">


        public int User_id_Last = 0;

        void Page_Load(Object sender, EventArgs e)
        {

            // Load sample data only once when the page is first loaded.
            if (!IsPostBack)
            {
                UsersForm.WebForm2 WF2 = new UsersForm.WebForm2();

                WF2.LoadDataSourse();

                //Выпадающий список Типы пользователей
                DropDownList1.DataSource = WF2.Tabl_UserType;
                DropDownList1.DataTextField = "Type_Name";
                DropDownList1.DataValueField = "id";
                DropDownList1.DataBind();


                LoadData_Users(WF2);

            }

        }

        private void LoadData_Users(UsersForm.WebForm2 WF2)
        {
            //Загрузка таблицы пользователей


            WF2.LoadDataSourse();

            if (Btn_Filtr.BorderColor == System.Drawing.Color.Red)
            {
                //С фильтром
                ItemsGrid.DataSource = WF2.Join_Users_UserTypes_Filter(DropDownList1.SelectedValue);
                ItemsGrid.DataBind();

            }
            else
            {
                // Обычная
                ItemsGrid.DataSource = WF2.Join_Users_UserTypes();
                ItemsGrid.DataBind();
            }
        }





        protected void Btn_Filtr_Click(object sender, EventArgs e)
        {
            Btn_Filtr.BorderColor = System.Drawing.Color.Red;


            UsersForm.WebForm2 WF2 = new UsersForm.WebForm2();

            WF2.LoadDataSourse();

            LoadData_Users(WF2);
        }



        protected void Btn_Add_Click(object sender, EventArgs e)
        {
            Btn_Add.BorderColor = System.Drawing.Color.Red;


            UsersForm.WebForm2 WF2 = new UsersForm.WebForm2();
            Lbl_Id_User.Text = (WF2.User_id_Last() + 1).ToString();


            Txt_UserName.Text = "";
            TxtBox_Login.Text = "";
            TxtBox_Password.Text = "";




            WF2.ReadJson_UserTypes();

            DropList_UserType.DataSource = WF2.ReadJson_UserTypes();
            DropList_UserType.DataTextField = "Type_Name";
            DropList_UserType.DataValueField = "id";
            DropList_UserType.DataBind();
        }



        protected void Btn_DeleteRow_Click(object sender, EventArgs e)
        {
            DataGridItem item = CheckedItem();

            if (item != null)
            {


                UsersForm.WebForm2 WF2 = new UsersForm.WebForm2();

                WF2.Delete_User(int.Parse(item.Cells[0].Text));

                LoadData_Users(WF2);

            }
        }



        protected void Btn_Save_Click(object sender, EventArgs e)
        {
            UsersForm.WebForm2 WF2 = new UsersForm.WebForm2();

            //Сохраняем
            if(Btn_Add.BorderColor == System.Drawing.Color.Red)
            {
                WF2.Write_NewUser(
                int.Parse(Lbl_Id_User.Text),
                TxtBox_Login.Text,
                TxtBox_Password.Text,
                Txt_UserName.Text,
                int.Parse(DropList_UserType.SelectedValue),
                DateTime.Now.ToString()
                );
            }

            if(Btn_Edit.BorderColor == System.Drawing.Color.Red)
            {
                WF2.Update_UsersT(
                int.Parse(Lbl_Id_User.Text),
                TxtBox_Login.Text,
                TxtBox_Password.Text,
                Txt_UserName.Text,
                int.Parse(DropList_UserType.SelectedValue),
                DateTime.Now.ToString()
                );
            }


            LoadData_Users(WF2);

            Update_Control(); //Обновление состояния элементов управления
        }


        protected void Btn_Cansel_Click(object sender, EventArgs e)
        {
            Update_Control();
        }

        private void Update_Control()
        {
            //Возвращаю элементы управления в исходное состояние
            Btn_Add.BorderColor = System.Drawing.Color.Gray;
            Btn_Edit.BorderColor = System.Drawing.Color.Gray;

            Lbl_Id_User.Text = "";
            Txt_UserName.Text = "";
            TxtBox_Login.Text = "";
            TxtBox_Password.Text = "";
        }

        protected void Btn_Edit_Click(object sender, EventArgs e)
        {
            Btn_Edit.BorderColor = System.Drawing.Color.Red;



            UsersForm.WebForm2 WF2 = new UsersForm.WebForm2();

            WF2.ReadJson_UserTypes();

            DropList_UserType.DataSource = WF2.ReadJson_UserTypes();
            DropList_UserType.DataTextField = "Type_Name";
            DropList_UserType.DataValueField = "id";
            DropList_UserType.DataBind();




            DataGridItem item = CheckedItem();

            if (item != null)
            {
                Lbl_Id_User.Text = item.Cells[0].Text;
                Txt_UserName.Text = item.Cells[3].Text;
                TxtBox_Login.Text = item.Cells[1].Text;
                TxtBox_Password.Text = item.Cells[2].Text;
                // DropList_UserType.Text = item.Cells[4].Text;
            }

        }


        private DataGridItem CheckedItem()
        {
            DataGridItem itemOut = null;

            foreach (DataGridItem item in ItemsGrid.Items)
            {
                CheckBox selection = (CheckBox)item.FindControl("SelectCheckBox");

                if (selection != null)
                {

                    if (selection.Checked)
                    {
                        itemOut = item;
                        return itemOut;
                    }

                }
            }
            return itemOut;
        }




        protected void Btn_Filtr_Clea_Click(object sender, EventArgs e)
        {
            if (Btn_Filtr.BorderColor == System.Drawing.Color.Red)
            {
                Btn_Filtr.BorderColor = System.Drawing.Color.Gray;

                UsersForm.WebForm2 WF2 = new UsersForm.WebForm2();

                WF2.LoadDataSourse();

                DropDownList1.DataSource = WF2.Tabl_UserType;
                DropDownList1.DataTextField = "Type_Name";
                DropDownList1.DataValueField = "id";
                DropDownList1.DataBind();

                LoadData_Users(WF2);
            }

        }


</script>
 

<head runat="server">
    <title>DataGrid Example</title>
</head>


<body>
 
   <form id="form1" runat="server">
 
      <%--<h3>DataGrid Example</h3>--%>
 
      <b>
                <asp:DropDownList ID="DropDownList1" runat="server" Height="17px" Width="137px">
                </asp:DropDownList>
                &nbsp;&nbsp;
                <asp:Button ID="Btn_Filtr" runat="server" OnClick="Btn_Filtr_Click" Text="Фильтр" />
                &nbsp;
       <asp:Button ID="Btn_Filtr_Clea" runat="server" OnClick="Btn_Filtr_Clea_Click" Text="Сброс" />
                <br />
       <br />
       Product List
 
       <asp:DataGrid id="ItemsGrid"
           BorderColor="Black"
           BorderWidth="1px"
           CellPadding="3"
           AutoGenerateColumns="False"
           runat="server" Width="1097px">

         <HeaderStyle BackColor="#00aaaa">
         </HeaderStyle>

         <Columns>
                         
            <asp:BoundColumn DataField="id" 
                 HeaderText="id"/>

            <asp:BoundColumn DataField="login" 
                 HeaderText="login"/>

            <asp:BoundColumn DataField="password" 
                 HeaderText="password">

               <ItemStyle HorizontalAlign="Right">
               </ItemStyle>

            </asp:BoundColumn>

             <asp:BoundColumn DataField="UserName" HeaderText="UserName"></asp:BoundColumn>
             <asp:BoundColumn DataField="TypeName" HeaderText="TypeName"></asp:BoundColumn>
             <asp:BoundColumn DataField="Allow_edit" HeaderText="Allow_edit"></asp:BoundColumn>
             <asp:BoundColumn DataField="last_visit_date" HeaderText="last_visit_date"></asp:BoundColumn>

            <asp:TemplateColumn HeaderText="Select Item">

               <ItemTemplate>

                  <asp:CheckBox id="SelectCheckBox"
                       Text=""
                       Checked="False"
                       runat="server"/>

               </ItemTemplate>

            </asp:TemplateColumn>
 
         </Columns> 

 
      </asp:DataGrid>

      <br /><br />

      <asp:Button id="Btn_Edit"
           Text="Редактировать"
           OnClick = "Btn_Edit_Click"
           runat="server" Width="134px" BorderColor="#CCCCCC"/>

            <asp:Button ID="Btn_Add" runat="server" OnClick="Btn_Add_Click" Text="Добавить" />
            <asp:Button ID="Btn_DeleteRow" runat="server" Text="Удалить" OnClick="Btn_DeleteRow_Click" />

      <br /><br />

       <br />
                <asp:Label ID="Lbl_Id_User" runat="server"></asp:Label>
                <br />
                <asp:Label ID="Lbl_UserName" runat="server" Text="Имя пользователя"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="Lbl_Login" runat="server" Text="Логин"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="Lbl_Password" runat="server" Text="Пароль"></asp:Label>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Label ID="Lbl_UserType" runat="server" Text="Тип доступа к данным"></asp:Label>
                <br />
                <asp:TextBox ID="Txt_UserName" runat="server" Width="140px" MaxLength="25"></asp:TextBox>
                &nbsp;&nbsp;<asp:TextBox ID="TxtBox_Login" runat="server" MaxLength="10" Width="140px"></asp:TextBox>
                &nbsp;&nbsp;&nbsp;<asp:TextBox ID="TxtBox_Password" runat="server" MaxLength="8" Width="140px"></asp:TextBox>
                &nbsp;&nbsp;<asp:DropDownList ID="DropList_UserType" runat="server" Height="22px" Width="150px">
                </asp:DropDownList>
                <br />
                <asp:Button ID="Btn_Save" runat="server" OnClick="Btn_Save_Click" Text="Сохранить" />
&nbsp;&nbsp;<asp:Button ID="Btn_Cansel" runat="server" Text="Отмена" OnClick="Btn_Cansel_Click" />
                <br />
 
   </form>
 
</body>

</html>
