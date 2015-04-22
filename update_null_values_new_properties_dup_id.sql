alter table new_properties_dup_id rename "serial" to "dup_id";

update new_properties_dup_id set new_street_direction = null where new_street_direction = '-1';
update new_properties_dup_id set new_unit_number = null where new_unit_number = '-1';
update new_properties_dup_id set new_street_number = null where new_street_number = '-1';
update new_properties_dup_id set new_street_name = null where new_street_name = '-1';
update new_properties_dup_id set new_street_direction = null where new_street_direction = '-1';