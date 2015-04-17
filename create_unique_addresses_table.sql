drop table unique_addresses;

create table unique_addresses as
select distinct on (new_street_number, new_street_name , new_street_direction, new_unit_number, city_id) id thenserial, new_street_number as street_number,new_street_name  as street_name, new_street_direction as street_direction, new_unit_number as unit_number, city_id as city_id from new_properties;

select * from unique_addresses