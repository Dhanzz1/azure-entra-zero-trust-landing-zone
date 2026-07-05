output "break_glass_exclude_group_id" {
  description = "Feed into every CA policy's excluded_groups."
  value       = azuread_group.break_glass_exclude.object_id
}