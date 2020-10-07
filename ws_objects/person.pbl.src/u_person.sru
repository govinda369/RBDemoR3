$PBExportHeader$u_person.sru
forward
global type u_person from u_tab_base
end type
type dw_persondetail from u_dw within tabpage_1
end type
type st_1 from statictext within tabpage_1
end type
type sle_filter from singlelineedit within tabpage_1
end type
type cb_filter from commandbutton within tabpage_1
end type
type uo_search from u_searchbox within tabpage_1
end type
type dw_cust from u_dw within tabpage_2
end type
type st_2 from statictext within tabpage_2
end type
type st_3 from statictext within tabpage_2
end type
type st_4 from statictext within tabpage_2
end type
type cb_add from u_button within u_person
end type
type cb_del from u_button within u_person
end type
type cb_save from u_button within u_person
end type
end forward

global type u_person from u_tab_base
integer width = 4133
integer height = 2720
long backcolor = 16777215
cb_add cb_add
cb_del cb_del
cb_save cb_save
end type
global u_person u_person

type variables
Long il_personid = 0
String is_persontype = "IN"

Private:
n_cst_webapi_person inv_webapi


end variables

forward prototypes
public function integer of_winopen ()
public function integer of_retrieve (u_dw adw_data, string as_data)
public subroutine of_restore_data ()
end prototypes

public function integer of_winopen ();DataWindowChild ldwc_child

tab_1.tabpage_2.dw_master.GetChild("addressid", ldwc_child)
IF ldwc_child.RowCount() > 0 Then
	IF tab_1.tabpage_1.dw_browser.RowCount() > 0 Then
		tab_1.tabpage_1.dw_browser.ScrollToRow(1)
	End IF
	ib_modify = False
	Return 1
End IF

This.SetRedraw(False)
//Retrieve Dddw
inv_webapi.of_winopen(tab_1.tabpage_1.dw_browser, tab_1.tabpage_1.dw_persondetail, +&
			   			        tab_1.tabpage_2.dw_master, tab_1.tabpage_2.dw_detail, tab_1.tabpage_2.dw_cust)
 
This.SetRedraw(True)
Return 1
end function

public function integer of_retrieve (u_dw adw_data, string as_data);String ls_persontype
Long ll_businessentityid

Choose Case adw_data.ClassName()
	Case "dw_browser"
		ll_businessentityid = Long(as_data)
				
		inv_webapi.of_retrievepersonbykey(ll_businessentityid, tab_1.tabpage_2.dw_master, &
													tab_1.tabpage_2.dw_detail, tab_1.tabpage_2.dw_cust)
		
		IF tab_1.tabpage_2.dw_cust.RowCount() > 0 Then
			tab_1.tabpage_1.dw_persondetail.Modify("b_become.enabled = No")
		Else
			tab_1.tabpage_1.dw_persondetail.Modify("b_become.enabled = Yes")
		End IF	
End Choose

Return 1
end function

public subroutine of_restore_data ();
Long ll_row
DwItemStatus ldws_1
u_dw dw_cur
Long i

iuo_currentdw.AcceptText()

If Not ib_modify Then Return

ib_modify = False
w_main.ib_modify = False


IF iuo_currentdw.ClassName( ) = "dw_browser" OR iuo_currentdw.ClassName( ) = "dw_persondetail" THEN
	dw_cur = tab_1.tabpage_1.dw_persondetail
	dw_cur.AcceptText()
	ll_row = dw_cur.GetRow()
	of_restore_data_current(dw_cur, ll_row)
	dw_cur.ResetUpdate()
END IF


IF iuo_currentdw.ClassName( ) = "dw_master" OR iuo_currentdw.ClassName( ) = "dw_detail" OR iuo_currentdw.ClassName( ) = "dw_cust" THEN
	of_restore_data_mutil(tab_1.tabpage_2.dw_master)
	
	of_restore_data_mutil(tab_1.tabpage_2.dw_detail)

	dw_cur = tab_1.tabpage_2.dw_cust
	dw_cur.AcceptText()
	ll_row = dw_cur.GetRow()
	of_restore_data_current(dw_cur, ll_row)
	dw_cur.ResetUpdate()
END IF


end subroutine

on u_person.create
int iCurrent
call super::create
this.cb_add=create cb_add
this.cb_del=create cb_del
this.cb_save=create cb_save
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add
this.Control[iCurrent+2]=this.cb_del
this.Control[iCurrent+3]=this.cb_save
end on

on u_person.destroy
call super::destroy
destroy(this.cb_add)
destroy(this.cb_del)
destroy(this.cb_save)
end on

event ue_add;call super::ue_add;//====================================================================
//$<Event>: ue_add
//$<Arguments>:
// 	%ScriptArgs%
//$<Return>:  integer
//$<Description>: 
//$<Author>: (Appeon) Stephen
//--------------------------------------------------------------------
//$<Modify History>:
//====================================================================
Integer li_row
Integer li_custrow
DateTime ldt_date
  
ldt_date = DateTime(Today(), Now())
Choose Case iuo_currentdw.ClassName()
	Case "dw_browser", "dw_persondetail"
		
		IF ib_Modify = True Then
			MessageBox(gs_msg_title, "Please save the data first.")
			Return 1
		End IF

		iuo_currentdw = tab_1.tabpage_1.dw_persondetail
		li_row = iuo_currentdw.InsertRow(0)
		tab_1.tabpage_2.dw_cust.reset()
		tab_1.tabpage_2.dw_master.reset()
		tab_1.tabpage_2.dw_detail.reset()
		li_custrow = tab_1.tabpage_2.dw_cust.insertrow(0)
		
		iuo_currentdw.ScrolltoRow(li_row)
		iuo_currentdw.SetRow(li_row)
		iuo_currentdw.SetItem(li_row, "persontype", is_persontype)
		iuo_currentdw.SetItem(li_row, "modifieddate", ldt_date)
		
		tab_1.tabpage_2.dw_cust.SetItem(li_custrow, "storeid", 350)
		tab_1.tabpage_2.dw_cust.SetItem(li_custrow, "territoryid", 1)
		
	Case "dw_master", "dw_detail"
		
		li_row = iuo_currentdw.InsertRow(0)
		iuo_currentdw.SetRow(li_row)
		iuo_currentdw.ScrollToRow(li_row)
		IF il_personid > 0 Then
			iuo_currentdw.SetItem(li_row, "businessentityid", il_personid)
		End IF
		iuo_currentdw.SetItem(li_row, "modifieddate", ldt_date)		
		
End Choose

ib_modify = True
w_main.ib_modify = True

Return 1
end event

event ue_delete;Integer li_row
Integer li_ret
Integer li_status
Long    ll_personid
Long    ll_addressid
Long    ll_addresstypeid
Long    ll_phonetypeid
Long    ll_customerid
String  ls_phonenumber
DwitemStatus ldws_status
str_person_parm lstr_parm

li_row = iuo_currentdw.GetRow()
IF li_row < 1 Then Return	1	

Choose case iuo_currentdw.ClassName()
	Case	"dw_browser", "dw_persondetail"		
		li_ret = MessageBox("Delete Person", "Are you sure you want to delete this person?" , Question!, yesno!)
		IF li_ret = 1 Then
			ldws_status = iuo_currentdw.GetItemStatus(li_row, 0 , Primary!)
			IF ldws_status = New! Or ldws_status = NewModified! Then
				ib_Modify = False
				iuo_currentdw.DeleteRow(li_row)
				iuo_currentdw.ReSetUpdate()
				tab_1.tabpage_2.dw_cust.DeleteRow(tab_1.tabpage_2.dw_cust.GetRow())
				tab_1.tabpage_2.dw_cust.ReSetUpdate()
				Return 1
			End IF
		
			ll_personid = iuo_currentdw.GetItemNumber(li_row, "businessentityid")
			
			//Delete by key
			lstr_parm.table = "Person"
			lstr_parm.personid = ll_personid
			li_status = inv_webapi.of_DeleteByKey(lstr_parm)
			IF li_status = -1 Then Return -1
			
			iuo_currentdw.DeleteRow(li_row)
			iuo_currentdw.ReSetUpdate()
			
			IF iuo_currentdw.ClassName() = "dw_persondetail" Then
				li_row = tab_1.tabpage_1.dw_browser.GetRow()
				tab_1.tabpage_1.dw_browser.DeleteRow(li_row)
				
				IF tab_1.tabpage_1.dw_browser.RowCount() > 1 Then
					tab_1.tabpage_1.dw_browser.ScrollToRow(1)
				End IF
			End IF					
		End IF		
	Case "dw_master"		
		li_ret = MessageBox("Delete Address", "Are you sure you want to delete this address?" , Question!, yesno!)
		IF li_ret = 1 Then		
			ldws_status = iuo_currentdw.GetItemStatus(li_row, 0 , Primary!)
			IF ldws_status = New! Or ldws_status = NewModified! Then				
				iuo_currentdw.DeleteRow(li_row)
				Return 1
			End IF
			
			ll_personid = iuo_currentdw.GetItemNumber(li_row, "businessentityid")
			ll_addressid = iuo_currentdw.GetItemNumber(li_row, "addressid")
			ll_addresstypeid = iuo_currentdw.GetItemNumber(li_row, "addresstypeid")
			
			//Delete by key
			lstr_parm.table = "PersonAddress"
			lstr_parm.personid = ll_personid
			lstr_parm.addressid = ll_addressid
			lstr_parm.addresstypeid = ll_addresstypeid
			li_status = inv_webapi.of_DeleteByKey(lstr_parm)
			IF li_status = -1 Then Return -1
			
			iuo_currentdw.DeleteRow(li_row)		
		End IF		
	Case "dw_detail"	
		li_ret = MessageBox("Delete Phone", "Are you sure you want to delete this phone?" , Question!, yesno!)
		IF li_ret = 1 Then
			
			IF ldws_status = New! Or ldws_status = NewModified! Then				
				iuo_currentdw.DeleteRow(li_row)
				Return 1
			End IF
			
			ll_personid = iuo_currentdw.GetItemNumber(li_row, "businessentityid")
			ls_phonenumber = iuo_currentdw.GetItemString(li_row, "Phonenumber")
			ll_phonetypeid = iuo_currentdw.GetItemNumber(li_row, "phonenumbertypeid")
			
			//Delete by key
			lstr_parm.table = "PersonPhone"
			lstr_parm.personid = ll_personid
			lstr_parm.phonenumber = ls_phonenumber
			lstr_parm.phonetypeid = ll_phonetypeid
			li_status = inv_webapi.of_DeleteByKey(lstr_parm)
			IF li_status = -1 Then Return -1
			
			iuo_currentdw.DeleteRow(li_row)
		End IF
		
	Case "dw_cust"	
		li_ret = MessageBox("Delete Customer", "Are you sure you want to delete this customer?" , Question!, yesno!)
		IF li_ret = 1 Then			
			IF ldws_status = New! Or ldws_status = NewModified! Then				
				iuo_currentdw.DeleteRow(li_row)
				iuo_currentdw.ReSetUpdate()
				Return 1
			End IF
			
			ll_personid = iuo_currentdw.GetItemNumber(li_row, "personid")
			ll_customerid = iuo_currentdw.GetItemNumber(li_row, "customerid")
			
			//Delete by key
			lstr_parm.table = "Customer"
			lstr_parm.personid = ll_personid
			lstr_parm.customerid = ll_customerid
			li_status = inv_webapi.of_DeleteByKey(lstr_parm)
			IF li_status = -1 Then Return -1
			
			iuo_currentdw.DeleteRow(li_row)
			iuo_currentdw.ResetUpdate()		
		End IF		
End Choose

ib_Modify = False
w_main.ib_modify = False

Return 1
end event

event ue_save;call super::ue_save;Integer li_status
Long ll_row
Long ll_listrow
Long ll_rowcount
DwItemStatus ldws_status

tab_1.tabpage_1.dw_persondetail.AcceptText()
tab_1.tabpage_2.dw_master.AcceptText()
tab_1.tabpage_2.dw_detail.AcceptText()
tab_1.tabpage_2.dw_cust.AcceptText()

ll_listrow = tab_1.tabpage_1.dw_browser.GetRow()
ll_row = tab_1.tabpage_1.dw_persondetail.GetRow()
IF ll_row > 0 Then
	ldws_status = tab_1.tabpage_1.dw_persondetail.GetItemStatus(ll_row, 0, Primary!)	
End IF

tab_1.tabpage_1.dw_browser.SetRedraw(False)
If tab_1.tabpage_1.dw_persondetail.Modifiedcount() > 0 Then
	
	li_status = inv_webapi.of_saveperson( tab_1.tabpage_1.dw_persondetail, tab_1.tabpage_2.dw_master, &
										tab_1.tabpage_2.dw_detail, tab_1.tabpage_2.dw_cust)		
										
	IF li_status = -1 Then 
		tab_1.tabpage_1.dw_browser.SetRedraw(True)
		Return -1 
	END IF
	
	ib_modify = False
	w_main.ib_modify = False
		
	IF ldws_status = Newmodified! Then
		ll_listrow = tab_1.tabpage_1.dw_browser.rowcount()  + 1
		tab_1.tabpage_1.dw_persondetail.Rowscopy(ll_row, ll_row, primary!, tab_1.tabpage_1.dw_browser, ll_listrow, primary!)	
		tab_1.tabpage_1.dw_browser.ResetUpdate()
	ElseIF ldws_status = DataModified! Then
		ll_row = tab_1.tabpage_1.dw_persondetail.GetRow()
		tab_1.tabpage_1.dw_persondetail.Rowscopy(ll_row, ll_row, primary!, tab_1.tabpage_1.dw_browser, ll_listrow + 1, primary!)	
		tab_1.tabpage_1.dw_browser.DeleteRow(ll_listrow)
	End IF
	
	tab_1.tabpage_1.dw_browser.ScrollToRow(ll_listrow)
	tab_1.tabpage_1.dw_browser.SelectRow (0, False)
	tab_1.tabpage_1.dw_browser.SelectRow (ll_listrow, True)
		
ElseIf tab_1.tabpage_2.dw_master.Modifiedcount()  + tab_1.tabpage_2.dw_detail.Modifiedcount()  + &
		tab_1.tabpage_2.dw_cust.Modifiedcount() > 0 Then
		li_status = inv_webapi.of_savechanges(tab_1.tabpage_2.dw_master, tab_1.tabpage_2.dw_detail, &
											tab_1.tabpage_2.dw_cust)
											
		IF li_status = -1 Then 
			tab_1.tabpage_1.dw_browser.SetRedraw(True)
			Return -1 			
		END IF
Else	
	tab_1.tabpage_1.dw_browser.SetRedraw(True)
	Return 1	
End IF

tab_1.tabpage_1.dw_browser.SetRedraw(True)
ib_modify = False
w_main.ib_modify = False
MessageBox(gs_msg_title, "Saved the data successfully.")

Return 1
end event

event ue_filter;call super::ue_filter;String ls_filter
String ls_txt

ls_txt = tab_1.tabpage_1.uo_search.of_getsearchtext() // tab_1.tabpage_1.sle_filter.text
ls_filter = ""
IF Len(ls_txt) > 0 Then
	ls_txt = "%" + ls_txt + "%"
	tab_1.tabpage_1.dw_browser.SetFilter("(lastname like '" + ls_txt+"') or (firstname like '" + ls_txt+"')")
	tab_1.tabpage_1.dw_browser.Filter()
	IF tab_1.tabpage_1.dw_browser.RowCount() > 0 THEN
		tab_1.tabpage_1.dw_browser.Event RowFocusChanged(1)
//		tab_1.tabpage_1.dw_browser.ScrollToRow(1)
//		tab_1.tabpage_1.dw_browser.SetRow(1)		
	END IF
Else
	tab_1.tabpage_1.dw_browser.SetFilter("")
	tab_1.tabpage_1.dw_browser.Filter()
End IF

Return 1
end event

type tab_1 from u_tab_base`tab_1 within u_person
integer x = 0
integer width = 4133
integer height = 2708
end type

on tab_1.create
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
call super::destroy
end on

event tab_1::selectionchanged;call super::selectionchanged;IF newindex = 1 THEN
	IF oldindex = 2 THEN tab_1.tabpage_1.dw_browser.SetFocus()
ELSE
	IF oldindex = 1 THEN tab_1.tabpage_2.dw_master.SetFocus()
END IF
end event

event tab_1::selectionchanging;call super::selectionchanging;IF ib_Modify = True Then
	MessageBox(gs_msg_title, "Please save the data first.")
	Return 1
End IF
end event

type tabpage_1 from u_tab_base`tabpage_1 within tab_1
integer width = 3973
integer height = 2676
dw_persondetail dw_persondetail
st_1 st_1
sle_filter sle_filter
cb_filter cb_filter
uo_search uo_search
end type

on tabpage_1.create
this.dw_persondetail=create dw_persondetail
this.st_1=create st_1
this.sle_filter=create sle_filter
this.cb_filter=create cb_filter
this.uo_search=create uo_search
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_persondetail
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_filter
this.Control[iCurrent+4]=this.cb_filter
this.Control[iCurrent+5]=this.uo_search
end on

on tabpage_1.destroy
call super::destroy
destroy(this.dw_persondetail)
destroy(this.st_1)
destroy(this.sle_filter)
destroy(this.cb_filter)
destroy(this.uo_search)
end on

type dw_browser from u_tab_base`dw_browser within tabpage_1
integer x = 64
integer y = 244
integer width = 3845
integer height = 1608
string dataobject = "d_person_list"
end type

event dw_browser::rowfocuschanged;call super::rowfocuschanged;//====================================================================
//$<Function>: rowfocuschanged
//$<Arguments>:
// 	%ScriptArgs%
//$<Return>:  integer
//$<Description>: 
//$<Author>: (Appeon) Stephen 
//--------------------------------------------------------------------
//$<Modify History>:
//====================================================================
Long  ll_businessentityid
Integer li_ret

IF currentrow < 1 Then 	
	Return -1
End IF

tab_1.tabpage_1.dw_persondetail.AcceptText()

IF ib_Modify = True Then
	li_ret = MessageBox("Save Change", "You have not saved your changes yet.  Do you want to save the changes?" , Question!, YesNo!, 1)
	IF li_ret = 1 Then
		Return 1
	ELSE
		iuo_currentdw = tab_1.tabpage_1.dw_persondetail
		of_restore_data()
		iuo_currentdw = This
	End IF
End IF

This.SelectRow(0, False)
This.SelectRow(currentrow, True)

ll_businessentityid = This.GetItemNumber(currentrow, "businessentityid")
il_personid = ll_businessentityid

dw_persondetail.SetFilter("businessentityid = " + String(ll_businessentityid))
dw_persondetail.Filter()
dw_persondetail.SetFilter("")

of_retrieve(This, String(ll_businessentityid))	
ib_modify = False
w_main.ib_modify = False

il_last_row = currentrow


end event

type tabpage_2 from u_tab_base`tabpage_2 within tab_1
integer width = 3973
integer height = 2676
dw_cust dw_cust
st_2 st_2
st_3 st_3
st_4 st_4
end type

on tabpage_2.create
this.dw_cust=create dw_cust
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cust
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
end on

on tabpage_2.destroy
call super::destroy
destroy(this.dw_cust)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
end on

type dw_master from u_tab_base`dw_master within tabpage_2
integer x = 64
integer y = 196
integer width = 3845
integer height = 844
string dataobject = "d_businessentityaddress"
end type

event dw_master::itemchanged;call super::itemchanged;ib_modify = True
w_main.ib_modify = True
end event

type dw_detail from u_tab_base`dw_detail within tabpage_2
integer x = 64
integer y = 1216
integer width = 3845
integer height = 844
string dataobject = "d_personphone"
end type

event dw_detail::itemchanged;call super::itemchanged;ib_modify = True
w_main.ib_modify = True
end event

type dw_persondetail from u_dw within tabpage_1
integer x = 64
integer y = 2024
integer width = 3845
integer height = 588
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_person"
end type

event itemchanged;call super::itemchanged;ib_modify = True
w_main.ib_modify = True
end event

event getfocus;call super::getfocus;iuo_currentdw = This

end event

event losefocus;call super::losefocus;IF Not ib_modify THEN
	This.AcceptText( )
END IF
end event

type st_1 from statictext within tabpage_1
integer x = 69
integer y = 1912
integer width = 457
integer height = 80
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 553648127
string text = "Detail:"
boolean focusrectangle = false
end type

type sle_filter from singlelineedit within tabpage_1
boolean visible = false
integer x = 64
integer y = 68
integer width = 896
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string placeholder = "First Name / Last Name"
end type

type cb_filter from commandbutton within tabpage_1
boolean visible = false
integer x = 1029
integer y = 68
integer width = 366
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "Filter"
end type

event clicked;iuo_parent.Event ue_filter()
end event

type uo_search from u_searchbox within tabpage_1
integer x = 64
integer y = 60
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;of_setplaceholder("Filter by Last Name / First Name")
of_setrealtimesearch(true)
end event

on uo_search.destroy
call u_searchbox::destroy
end on

event ue_search;call super::ue_search;iuo_parent.Event ue_filter()
end event

type dw_cust from u_dw within tabpage_2
integer x = 64
integer y = 2236
integer width = 3845
integer height = 384
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_customer"
end type

event itemchanged;call super::itemchanged;ib_modify = True
w_main.ib_modify = True
end event

type st_2 from statictext within tabpage_2
integer x = 69
integer y = 2124
integer width = 457
integer height = 80
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 553648127
string text = "Customer:"
boolean focusrectangle = false
end type

type st_3 from statictext within tabpage_2
integer x = 69
integer y = 1104
integer width = 457
integer height = 80
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 553648127
string text = "Phone:"
boolean focusrectangle = false
end type

type st_4 from statictext within tabpage_2
integer x = 69
integer y = 84
integer width = 457
integer height = 80
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 553648127
string text = "Address:"
boolean focusrectangle = false
end type

type cb_add from u_button within u_person
boolean visible = false
integer x = 2665
integer y = 84
integer width = 366
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
string facename = "Segoe UI"
string text = "Add"
end type

event clicked;call super::clicked;//====================================================================
//$<Event>: clicked
//$<Arguments>:
// 	%ScriptArgs%
//$<Return>:  long
//$<Description>: 
//$<Author>: (Appeon) Stephen
//--------------------------------------------------------------------
//$<Modify History>:
//====================================================================

Parent.Event ue_add()
end event

type cb_del from u_button within u_person
boolean visible = false
integer x = 3104
integer y = 84
integer width = 366
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
string facename = "Segoe UI"
string text = "Delete"
end type

event clicked;call super::clicked;//====================================================================
//$<Event>: clicked
//$<Arguments>:
// 	%ScriptArgs%
//$<Return>:  long
//$<Description>: 
//$<Author>: (Appeon) Stephen 
//--------------------------------------------------------------------
//$<Modify History>:
//====================================================================

Integer li_modified

Parent.Event ue_delete()

li_modified =  tab_1.tabpage_2.dw_master.Modifiedcount() 
li_modified = li_modified + tab_1.tabpage_2.dw_detail.Modifiedcount()
li_modified = li_modified + tab_1.tabpage_2.dw_cust.Modifiedcount()
li_modified = li_modified + tab_1.tabpage_1.dw_persondetail.Modifiedcount()

IF li_modified  > 0 Then
	ib_modify = True
	w_main.ib_modify = True
Else
	ib_modify = False
	w_main.ib_modify = False
End IF
end event

type cb_save from u_button within u_person
boolean visible = false
integer x = 3543
integer y = 84
integer width = 366
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
string facename = "Segoe UI"
string text = "Save"
end type

event clicked;call super::clicked;Parent.Event ue_save()
end event

