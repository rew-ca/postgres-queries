drop table dup_id_new_slug_uid;

create table dup_id_new_slug_uid as
(select dup_id, slug, uid 
	from new_properties_final)