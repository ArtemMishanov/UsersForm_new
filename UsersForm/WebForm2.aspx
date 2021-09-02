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

            for(int i = 0; i < ItemsGrid.Items.Count; i++)
            {
                ItemsGrid.Items[i].BackColor = System.Drawing.Color.White;
            }
            ItemsGrid.Enabled = false;
            Tabl_Filtr.Enabled = false;
            Btn_DeleteRow.Enabled = false;
            Btn_Edit.Enabled = false;

            UsersForm.WebForm2 WF2 = new UsersForm.WebForm2();
            Lbl_Id_User.Text = (WF2.User_id_Last() + 1).ToString();


            Txt_UserName.Text = "";
            TxtBox_Login.Text = "";
            TxtBox_Password.Text = "";
            LoadUserType_for_Edit();

            Tabl_ControlsEdit.Enabled = true;
            Btn_Save.Visible = true;
            Btn_Cansel.Visible = true;
        }



        protected void Btn_DeleteRow_Click(object sender, EventArgs e)
        {

            if (Lbl_Id_User.Text != null)
            {

                UsersForm.WebForm2 WF2 = new UsersForm.WebForm2();

                WF2.Delete_User(int.Parse(Lbl_Id_User.Text));

                LoadData_Users(WF2);

            }
        }



        protected void Btn_Save_Click(object sender, EventArgs e)
        {
           
            if (Txt_Zapolnen() == true)
            {
                ItemsGrid.Enabled = true;

                UsersForm.WebForm2 WF2 = new UsersForm.WebForm2();
                //Сохраняем
                if (Btn_Add.BorderColor == System.Drawing.Color.Red)
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

                if (Btn_Edit.BorderColor == System.Drawing.Color.Red)
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
            else 
            { 
                    Type cstype = this.GetType();

                    // Get a ClientScriptManager reference from the Page class.
                    ClientScriptManager cs = Page.ClientScript;

                    // Check to see if the startup script is already registered.
                    if (!cs.IsStartupScriptRegistered(cstype, "PopupScript"))
                    {
                        String cstext = "alert('На странице формы, заполнены не все поля');";
                        cs.RegisterStartupScript(cstype, "PopupScript", cstext, true);
                    }
            }
            
        }


        private Boolean Txt_Zapolnen()
        {// Проверяю заполненность всех полей
            if (TxtBox_Login.Text != "")
                if (Txt_UserName.Text != "")
                    if (TxtBox_Password.Text != "")
                    {
                        return true;
                    }

            return false;


        }


        protected void Btn_Cansel_Click(object sender, EventArgs e)
        {
            ItemsGrid.Enabled = true;
            Update_Control();

        }

        private void Update_Control()
        {
            //Возвращаю элементы управления в исходное состояние
            Btn_Add.BorderColor = System.Drawing.Color.Gray;
            Btn_Edit.BorderColor = System.Drawing.Color.Gray;
            Btn_Edit.Enabled = true;

            Txt_UserName.Text = "";
            TxtBox_Login.Text = "";
            TxtBox_Password.Text = "";
            DropList_UserType.Items.Clear();

            Btn_Save.Visible = false;
            Btn_Cansel.Visible = false;
            Tabl_ControlsEdit.Enabled = false;
            Btn_Add.Enabled = true;
            Btn_DeleteRow.Enabled = true;
            Tabl_Filtr.Enabled = true;
        }


        protected void Btn_Edit_Click(object sender, EventArgs e)
        {
            Btn_Edit.BorderColor = System.Drawing.Color.Red;
            Btn_Add.Enabled = false;
            Btn_DeleteRow.Enabled = false;
            Tabl_Filtr.Enabled = false;
            ItemsGrid.Enabled = false;//Закрыл выбор другого пользователя

            LoadUserType_for_Edit();

            DataGridItem item = Select_Item();//Выделенную Выбраного Пользователя

            if (item != null)
            {
                Lbl_Id_User.Text = item.Cells[0].Text;
                Txt_UserName.Text = item.Cells[3].Text;
                TxtBox_Login.Text = item.Cells[1].Text;
                TxtBox_Password.Text = item.Cells[2].Text;
                DropList_UserType.SelectedIndex = DropListIndexItem(item.Cells[4].Text);
            }

            Tabl_ControlsEdit.Enabled = true;
            Btn_Save.Visible = true;
            Btn_Cansel.Visible = true;
        }


        private void LoadUserType_for_Edit()
        {
            //Загружаю список ТиповПользователей для редактирования пользователя
            UsersForm.WebForm2 WF2 = new UsersForm.WebForm2();

            // Запрашиваю типы пользователей
            DropList_UserType.DataSource = WF2.ReadJson_UserTypes();
            DropList_UserType.DataTextField = "Type_Name";
            DropList_UserType.DataValueField = "id";
            DropList_UserType.DataBind();
        }


        private int DropListIndexItem(string UserType)
        {

            if(DropList_UserType.Items.Count>0)
            {
                for(int i = 0; i < DropList_UserType.Items.Count; i++)
                {
                    if (UserType == DropList_UserType.Items[i].Text)
                    {

                        return int.Parse(DropList_UserType.Items[i].Value);
                    }

                }
            }

            return 0;

        }


        private DataGridItem Select_Item()
        {
            DataGridItem itemOut = null;

            if (Lbl_Id_User.Text != null)
            {

                for(int i = 0; i < ItemsGrid.Items.Count; i++)
                {
                    if (Lbl_Id_User.Text == ItemsGrid.Items[i].Cells[0].Text)
                    {
                        itemOut = ItemsGrid.Items[i];
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


        void ItemsGrid_Command(Object sender, DataGridCommandEventArgs e)
        {

            for(int i = 0; i < ItemsGrid.Items.Count; i++)
            {
                ItemsGrid.Items[i].BackColor = System.Drawing.Color.White;
            }


            Lbl_Id_User.Text = ItemsGrid.Items[e.Item.ItemIndex].Cells[0].Text;

            ItemsGrid.Items[e.Item.ItemIndex].BackColor = System.Drawing.Color.Gray;

        }





</script>
 

<head runat="server">
    <title>Users List</title>
    </head>


<body>
 
   <form id="form1" runat="server">
 
      <%--<h3>DataGrid Example</h3>--%>
 
      <b>
               
                <asp:Table ID="Tabl_Filtr" runat="server">
                    <asp:TableRow runat="server">
                        <asp:TableCell runat="server" Width="375px"></asp:TableCell>

                        <asp:TableCell runat="server" Width="140px">
                            <asp:DropDownList ID="DropDownList1" runat="server" Height="17px" Width="137px"></asp:DropDownList>
                        
</asp:TableCell>

                        <asp:TableCell runat="server" Width="65px">
                            <asp:Button ID="Btn_Filtr" runat="server" OnClick="Btn_Filtr_Click" Text="Фильтр" />
                        
</asp:TableCell>

                        <asp:TableCell runat="server" Width="65px">
                            <asp:Button ID="Btn_Filtr_Clea" runat="server" OnClick="Btn_Filtr_Clea_Click" Text="Сброс" Width="60px" />
                        
</asp:TableCell>

                    </asp:TableRow>
       </asp:Table>
       
       <asp:DataGrid id="ItemsGrid"
           BorderColor="Black"
           BorderWidth="1px"
           CellPadding="3"
           AutoGenerateColumns="False"
           SelectionMode="Single"
           SelectionUnit="FullRow"
           OnItemCommand="ItemsGrid_Command"
           runat="server" Width="850px" BackColor="White" >
            
         <HeaderStyle BackColor="#00aaaa">
         </HeaderStyle>

         <Columns>
                         
            <asp:BoundColumn DataField="id" 
                 HeaderText="Номер">

                <HeaderStyle Width="20px" />
             </asp:BoundColumn>

            <asp:BoundColumn DataField="login" 
                 HeaderText="Логин">

                <HeaderStyle Width="55px" />
             </asp:BoundColumn>

            <asp:BoundColumn DataField="password" 
                 HeaderText="Пароль">

                <HeaderStyle Width="45px" />

               <ItemStyle HorizontalAlign="Right">
               </ItemStyle>

            </asp:BoundColumn>
             <asp:BoundColumn DataField="UserName" HeaderText="Пользователь">
                 <HeaderStyle Width="140px" />
             </asp:BoundColumn>
             <asp:BoundColumn DataField="TypeName" HeaderText="Тип доступа">
                 <HeaderStyle Width="80px" />
             </asp:BoundColumn>
             <asp:BoundColumn DataField="Allow_edit" HeaderText="Права радакотровать">
                 <HeaderStyle Width="30px" />
                 <ItemStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False" Font-Underline="False" HorizontalAlign="Center" />
             </asp:BoundColumn>
             <asp:BoundColumn DataField="last_visit_date" HeaderText="Последний вход">
                 <HeaderStyle Width="120px" />
             </asp:BoundColumn>

            <asp:EditCommandColumn
                 EditText = "<--"
                 HeaderText="">

               <ItemStyle Wrap="False">
               </ItemStyle>

               <HeaderStyle Wrap="False" Width="30px">
               </HeaderStyle>

            </asp:EditCommandColumn>

         </Columns>
           
        
         
 
      </asp:DataGrid>


      <br /><br />

      <asp:Button id="Btn_Edit"
           Text="Редактировать"
           OnClick = "Btn_Edit_Click"
           runat="server" Width="134px" BorderColor="#CCCCCC"/>

            <asp:Button ID="Btn_Add" runat="server" OnClick="Btn_Add_Click" Text="Добавить" />
            <asp:Button ID="Btn_DeleteRow" runat="server" Text="Удалить" OnClick="Btn_DeleteRow_Click" />

       <br />
       <br />
                <asp:Label ID="Lbl_Id_User" runat="server" Visible="False"></asp:Label>
       <asp:Table ID="Tabl_ControlsEdit" runat="server" Height="77px" Width="710px" BorderStyle="Solid" Enabled="False">

           <asp:TableRow runat="server">
               <asp:TableCell runat="server">
                    <asp:Label ID="Lbl_UserName" Width="140px" runat="server" Text="Имя пользователя"></asp:Label>
               </asp:TableCell>

               <asp:TableCell runat="server">
                   <asp:Label ID="Lbl_Login" runat="server" Text="Логин"></asp:Label>
               </asp:TableCell>

               <asp:TableCell runat="server">
                   <asp:Label ID="Lbl_Password" runat="server" Text="Пароль"></asp:Label>
               </asp:TableCell>

               <asp:TableCell runat="server">
                   <asp:Label ID="Lbl_UserType" runat="server" Text="Тип доступа к данным"></asp:Label>
               </asp:TableCell>

           </asp:TableRow>

           <asp:TableRow runat="server">

               <asp:TableCell runat="server">
                   <asp:TextBox ID="Txt_UserName" runat="server" Width="140px" MaxLength="25"></asp:TextBox>
               </asp:TableCell>

               <asp:TableCell runat="server">
                   <asp:TextBox ID="TxtBox_Login" runat="server" MaxLength="10" Width="140px"></asp:TextBox>
               </asp:TableCell>

               <asp:TableCell runat="server">
                   <asp:TextBox ID="TxtBox_Password" runat="server" MaxLength="8" Width="100px"></asp:TextBox>
               </asp:TableCell>

               <asp:TableCell runat="server">
                   <asp:DropDownList ID="DropList_UserType" runat="server" Height="22px" Width="150px"></asp:DropDownList>
               </asp:TableCell>

           </asp:TableRow>
       </asp:Table>
                <asp:Button ID="Btn_Save" runat="server" OnClick="Btn_Save_Click" Text="Сохранить" Visible="False" />

                &nbsp;&nbsp;<asp:Button ID="Btn_Cansel" runat="server" Text="Отмена" OnClick="Btn_Cansel_Click" Visible="False" />

                <br />
                
                <br />
 
   </form>
 
</body>

</html>
