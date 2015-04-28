drop table dup_id_new_slug;

create table du_id_new_slug as
(select dup_id, slug 
	from new_properties_final)