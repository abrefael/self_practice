// Copyright (c) 2024, Alon Ben Refael and contributors
// For license information, please see license.txt

frappe.ui.form.on("Session summary", {
  session_start(frm) {
    frm.set_value("start",frappe.datetime.get_datetime_as_string());
  }
});

frappe.ui.form.on("Session summary", {
  session_end(frm) {
    frm.set_value("end",frappe.datetime.get_datetime_as_string());
  }
});
