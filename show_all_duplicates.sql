with duplicates as(
select array_to_string( array [p.new_unit_number, p.new_street_number, p.new_street_name, p.new_street_direction, c.name], ' ' ) as new_address, p.* 
	from new_properties p, cities c 
	where p.city_id = c.id
	and count(*) > 1)
select new_address, count(*) 
	from duplicates 
	group by new_address 
	having count(*) > 1;