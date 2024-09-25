import frappe

def after_install():
	frappe.db.sql("""
		INSERT
		INTO `tabCustom HTML Block`
		SET
			name='Session_Calendar',
			creation=NOW(),
			modified=NOW(),
			modified_by='Administrator',
			owner='Administrator',
			docstatus=0,
			private=0,
			html='<iframe src="/app/sessions-calendar/view/calendar" style="width:100%;height: 850px;"></iframe>',
			script='',
			style='';
	""")
