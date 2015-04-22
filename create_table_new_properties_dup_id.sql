drop table new_properties_dup_id;

create table new_properties_dup_id as 
(
select *
from new_properties
left join unique_addresses
using (new_street_number, new_street_name, new_street_direction, new_unit_number, city_id)
)