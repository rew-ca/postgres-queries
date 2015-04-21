alter table new_properties drop column dup_id;

alter table new_properties add column dup_id integer;

update new_properties 
set n.dup_id = u.serial
from new_properties n, unique_addresses u
where n.new_street_number = u.new_street_number and n.new_street_name = u.new_street_name and n.new_street_direction = u.new_street_direction and n.new_unit_number = u.new_unit_number and n.city_id = u.city_id