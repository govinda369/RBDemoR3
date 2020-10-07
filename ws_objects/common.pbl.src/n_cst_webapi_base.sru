$PBExportHeader$n_cst_webapi_base.sru
forward
global type n_cst_webapi_base from n_base
end type
end forward

global type n_cst_webapi_base from n_base
end type
global n_cst_webapi_base n_cst_webapi_base

type variables
//Protected:
n_cst_httpclient inv_httpclient
n_cst_restclient inv_restclient
String is_controllername
end variables

forward prototypes
protected function string of_get_url_host ()
protected function integer of_get_service_type ()
public function string of_get_url (string as_action)
public function integer of_get_servicestatus (jsonpackage astr_jspack, string as_edittype)
public function string of_json_object2arrary (string as_json)
protected function boolean of_is_sqlmodelmapper ()
end prototypes

protected function string of_get_url_host ();Return gs_host
end function

protected function integer of_get_service_type ();Return gi_service_type
end function

public function string of_get_url (string as_action);Return of_get_url_host() + "/api/" + is_controllername + "/" + as_action
end function

public function integer of_get_servicestatus (jsonpackage astr_jspack, string as_edittype);String ls_status

ls_status = astr_jspack.GetValue("Status")
IF ls_status <> "Success" Then
	
	IF as_edittype = "Save" Then
		Messagebox("Error", ls_status)
	Else
		Messagebox("Error", "Failed to delete the data because it is used by another table.")
	End IF
	
	Return -1
End IF 

Return 1
end function

public function string of_json_object2arrary (string as_json);//Convert an object in JSON formatted string into an array in JSON formatted string.

If of_is_sqlmodelmapper() Then
	IF Left(as_json, 1) <> "[" Then
		as_json = "[" + as_json + "]"
	End IF
End If

Return as_json
end function

protected function boolean of_is_sqlmodelmapper ();Return This.of_get_service_type() = WEBAPI_SQLMODELMAPPER
end function

on n_cst_webapi_base.create
call super::create
end on

on n_cst_webapi_base.destroy
call super::destroy
end on

event constructor;call super::constructor;inv_restclient = create n_cst_restclient
end event

