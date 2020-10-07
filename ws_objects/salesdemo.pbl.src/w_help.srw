$PBExportHeader$w_help.srw
forward
global type w_help from w_base
end type
type wb_website from webbrowser within w_help
end type
end forward

global type w_help from w_base
string title = "Elevate 2019"
wb_website wb_website
end type
global w_help w_help

on w_help.create
int iCurrent
call super::create
this.wb_website=create wb_website
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.wb_website
end on

on w_help.destroy
call super::destroy
destroy(this.wb_website)
end on

event open;call super::open;//wb_website.navigate( "www.appeon.com")	//https://docs.appeon.com/appeon_online_help/snapdevelop2019/features_list/
end event

event resize;call super::resize;
wb_website.width = newwidth
wb_website.height = newheight
end event

type wb_website from webbrowser within w_help
integer width = 2976
integer height = 1268
string defaulturl = "https://www.appeon.com/elevate"
boolean border = false
borderstyle borderstyle = stylebox!
end type

