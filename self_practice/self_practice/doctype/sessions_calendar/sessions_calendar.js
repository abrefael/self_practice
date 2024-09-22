// Copyright (c) 2024, Alon Ben Refael and contributors
// For license information, please see license.txt

// frappe.ui.form.on("Sessions Calendar", {
// 	refresh(frm) {

// 	},
// });


frappe.ui.form.on('Sessions Calendar', {
	go_to_session_summary(frm) {
	    if (!frm.doc.session_sum){
    		frappe.db.insert({
                doctype: 'Session summary',
                start: frm.doc.start,
                end: frm.doc.end,
                patient: frm.doc.patient
            }).then(doc => {
                frm.set_value('session_sum','/app/session-summary/' + doc.name);
            });
	    }
	    else{
	        window.location.href = frm.doc.session_sum;
	    }

	}
});
