drop table property_details;

create table property_details_temp as
(select np1.dup_id, 
	np1.legal_type as legal_type1, 
	np2.legal_type as legal_type2, 
	np1.strata_fee as strata_fee1, 
	np2.strata_fee as strata_fee2, 
	np1.property_tax as property_tax1,
	np2.property_tax as property_tax2,
	np1.year_built as year_built1,
	np2.year_built as year_built2,
	np1.floor_area as floor_area1,
	np2.floor_area as floor_area2,
	np1.bedroom as bedroom1,
	np2.bedroom as bedroom2,
	np1.bathroom as bathroom1,
	np2.bathroom as bathroom2,
	np1.assessed_type as assessed_type1,
	np2.assessed_type as assessed_type2,
	np1.lot_size as lot_size1,
	np2.lot_size as lot_size2,
	np1.den as den1,
	np2.den as den2,
	np1.normalized_type as normalized_type1,
	np2.normalized_type as normalized_type2,
--	np1.parcel as parcel1,
--	np2.parcel as parcel2,
	np1.lot_frontage as lot_frontage1,
	np2.lot_frontage as lot_frontage2,
	np1.lot_depth as lot_depth1,
	np2.lot_depth as lot_depth2
from new_properties_dup_id np1
left join new_properties_dup_id  np2
using (dup_id)
where np1.id != np2.id or np2 is null)
;

update property_details_temp
set legal_type1 = legal_type2
where legal_type1 is null and legal_type2 is not null;

alter table property_details_temp
	rename legal_type1 to new_legal_type;
alter table property_details_temp
	drop column legal_type2;

update property_details_temp
set strata_fee1 = strata_fee2
where strata_fee1 is null and strata_fee2 is not null;

alter table property_details_temp
	rename strata_fee1 to new_strata_fee;
alter table property_details_temp
	drop column strata_fee2;

update property_details_temp
set property_tax1 = property_tax2
where property_tax1 is null and property_tax2 is not null;

alter table property_details_temp
	rename property_tax1 to new_property_tax;
alter table property_details_temp
	drop column property_tax2;

update property_details_temp
set year_built1 = year_built2
where year_built1 is null and year_built2 is not null;

alter table property_details_temp
	rename year_built1 to new_year_built;
alter table property_details_temp
	drop column year_built2;

update property_details_temp
set floor_area1 = (
	case when floor_area1 is null and floor_area2 is not null
		then floor_area2
	when floor_area1::int >  floor_area2::int
		then floor_area1
	when floor_area1::int <  floor_area2::int
		then floor_area2
	else floor_area1
	end
);

alter table property_details_temp
	rename floor_area1 to new_floor_area;
alter table property_details_temp
	drop column floor_area2;

update property_details_temp
set bedroom1 = (
	case when bedroom1 is null and bedroom2 is not null
		then bedroom2
	when bedroom1::numeric > bedroom2::numeric
		then bedroom1
	when bedroom1::numeric < bedroom2::numeric
		then bedroom2
	else bedroom1
	end
	);

alter table property_details_temp
	rename bedroom1 to new_bedroom;
alter table property_details_temp
	drop column bedroom2;

update property_details_temp
set bathroom1 = (
	case when bathroom1 is null and bathroom2 is not null
		then bathroom2
	when bathroom1::numeric > bathroom2::numeric
		then bathroom1
	when bathroom1::numeric < bathroom2::numeric
		then bathroom2
	else bathroom1
	end
	);

alter table property_details_temp
	rename bathroom1 to new_bathroom;
alter table property_details_temp
	drop column bathroom2;

update property_details_temp
set assessed_type1 = assessed_type2
where assessed_type1 is null and assessed_type2 is not null;

alter table property_details_temp
	rename assessed_type1 to new_assessed_type;
alter table property_details_temp
	drop column assessed_type2;

update property_details_temp
set lot_size1 = (
	case when lot_size1 is null and lot_size2 is not null and lot_size2 != '0'
		then lot_size2
	case when lot_size1 = '0' and lot_size2 is not null
		then null
	case when lot_size1 = null and lot_size2 '0'
		then null
	when lot_size1::int > lot_size2::int
		then lot_size1
	when lot_size1::int < lot_size2::int
		then lot_size2
	else lot_size1
	end
);

alter table property_details_temp
	rename lot_size1 to new_lot_size;
alter table property_details_temp
	drop column lot_size2;

update property_details_temp
set den1 = den2
where den1 is null and den2 is not null;

alter table property_details_temp
	rename den1 to new_den;
alter table property_details_temp
	drop column den2;

update property_details_temp
set normalized_type1 = null
where normalized_type1 ilike 'Residential Attached';
update property_details_temp
set normalized_type2 = null
where normalized_type2 ilike 'Residential Attached';
update property_details_temp
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and normalized_type2 ~~* 'one family dwelling'
		then initcap(normalized_type2)
	else initcap(normalized_type1)
	end
);

alter table property_details_temp
	rename normalized_type1 to new_normalized_type;
alter table property_details_temp
	drop column normalized_type2;

update property_details_temp
set parcel1 = parcel2
where parcel1 is null and parcel2 is not null;

alter table property_details_temp
	rename parcel1 to new_parcel;
alter table property_details_temp
	drop column parcel2;

update property_details_temp
set lot_frontage1 = lot_frontage2
where lot_frontage1 is null and lot_frontage2 is not null;

alter table property_details_temp
	rename lot_frontage1 to new_lot_frontage;
alter table property_details_temp
	drop column lot_frontage2;

update property_details_temp
set lot_depth1 = lot_depth2
where lot_depth1 is null and lot_depth2 is not null;

alter table property_details_temp
	rename lot_depth1 to new_lot_depth;
alter table property_details_temp
	drop column lot_depth2;

update property_details_temp set new_legal_type = -1 where new_legal_type is null;
update property_details_temp set new_strata_fee = -1 where new_strata_fee is null;
update property_details_temp set new_year_built = -1 where new_year_built is null;
update property_details_temp set new_floor_area = -1 where new_floor_area is null;
update property_details_temp set new_bedroom = -1 where new_bedroom is null;
update property_details_temp set new_bathroom = -1 where new_bathroom is null;
update property_details_temp set new_assessed_type = -1 where new_assessed_type is null;
update property_details_temp set new_lot_size = -1 where new_lot_size is null;
update property_details_temp set new_den = -1 where new_den is null;
update property_details_temp set new_normalized_type = -1 where new_normalized_type is null;
-- update property_details_temp set new_parcel = -1 where new_parcel is null;
update property_details_temp set new_lot_frontage = -1 where new_lot_frontage is null;
update property_details_temp set new_lot_depth = -1 where new_lot_depth is null;

create table property_details as
select distinct * from property_details_temp;

update property_details set new_legal_type = null where new_legal_type = '-1';
update property_details set new_strata_fee = null where new_strata_fee = '-1';
update property_details set new_year_built = null where new_year_built = '-1';
update property_details set new_floor_area = null where new_floor_area = '-1';
update property_details set new_bedroom = null where new_bedroom = '-1';
update property_details set new_bathroom = null where new_bathroom = '-1';
update property_details set new_assessed_type = null where new_assessed_type = '-1';
update property_details set new_lot_size = null where new_lot_size = '-1';
update property_details set new_den = null where new_den = '-1';
update property_details set new_normalized_type = null where new_normalized_type = '-1';
--update property_details set new_parcel = null where new_parcel = '-1';
update property_details set new_lot_frontage = null where new_lot_frontage = '-1';
update property_details set new_lot_depth = null where new_lot_depth = '-1';

drop table property_details_temp;