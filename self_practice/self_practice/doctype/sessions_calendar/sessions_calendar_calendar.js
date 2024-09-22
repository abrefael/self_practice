
frappe.views.calendar["Sessions Calendar"] = {
	field_map: {
		start: "start",
		end: "start",
		id: "name",
		title: "patient",
		allDay: "allDay"
	},
	get_events_method: "frappe.desk.calendar.get_events",
};