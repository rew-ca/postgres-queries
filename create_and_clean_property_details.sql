drop table property_details;
drop table property_details_temp;
drop table property_details_temp1;
drop table property_details_temp2;

-- PART 1
-- create table property_details_temp1 as join of new_properties_dup_id with itself
create table property_details_temp1 as
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
	np1.lot_frontage as lot_frontage1,
	np2.lot_frontage as lot_frontage2,
	np1.lot_depth as lot_depth1,
	np2.lot_depth as lot_depth2
from new_properties_dup_id np1
left join new_properties_dup_id  np2
using (dup_id)
where np1.id != np2.id)
;
alter table property_details_temp1 add column id serial;

-- correct legal_type
update property_details_temp1
set legal_type1 = legal_type2
where legal_type1 is null and legal_type2 is not null;
-- change change field name and delete dup field
alter table property_details_temp1
	rename legal_type1 to new_legal_type;
alter table property_details_temp1
	drop column legal_type2;

-- correct strata fee
update property_details_temp1
set strata_fee1 = (
	case when strata_fee1 is null and strata_fee2 is not null
		then strata_fee2
	when strata_fee1 > strata_fee2
		then strata_fee1
	when strata_fee1 < strata_fee2
		then strata_fee2
	else strata_fee1
	end
);
-- change field name and delete dup field
alter table property_details_temp1
	rename strata_fee1 to new_strata_fee;
alter table property_details_temp1
	drop column strata_fee2;

-- correct property_tax
update property_details_temp1
set property_tax1 = (
	case when property_tax1 is null and property_tax2 is not null
		then property_tax2
	when property_tax1 > property_tax2
		then property_tax1
	when property_tax1 < property_tax2
		then property_tax2
	else property_tax1
	end
);
-- change field name and delete dup field
alter table property_details_temp1
	rename property_tax1 to new_property_tax;
alter table property_details_temp1
	drop column property_tax2;
--
-- correct year built
update property_details_temp1
	set year_built1 = null
	where year_built1 > extract(year from current_date);
update property_details_temp1
	set year_built2 = null
	where year_built2 > extract(year from current_date);
update property_details_temp1
set year_built1 = (
	case when year_built1 is null and year_built2 is not null
		then year_built2
	when year_built1 > year_built2
		then year_built1
	when year_built1 < year_built2
		then year_built2
	else year_built1
	end
);
-- change field name and delete dup field
alter table property_details_temp1
	rename year_built1 to new_year_built;
alter table property_details_temp1
 	drop column year_built2;

-- correct floor area
update property_details_temp1
set floor_area1 = (
	case when floor_area1 is null and floor_area2 is not null
		then floor_area2
	when floor_area1 > floor_area2
		then floor_area1
	when floor_area1 < floor_area2
		then floor_area2
	else floor_area1
	end
);
-- change field name and delete dup field
alter table property_details_temp1
	rename floor_area1 to new_floor_area;
alter table property_details_temp1
	drop column floor_area2;

-- correct bedrooms
update property_details_temp1
set bedroom1 = (
	case when bedroom1 is null and bedroom2 is not null
		then bedroom2
	when bedroom1 > bedroom2
		then bedroom1
	when bedroom1 < bedroom2
		then bedroom2
	else bedroom1
	end
	);
-- change field name and delete dup field
alter table property_details_temp1
	rename bedroom1 to new_bedroom;
alter table property_details_temp1
	drop column bedroom2;

-- correct bathrooms
update property_details_temp1
set bathroom1 = (
	case when bathroom1 is null and bathroom2 is not null
		then bathroom2
	when bathroom1 > bathroom2
		then bathroom1
	when bathroom1 < bathroom2
		then bathroom2
	else bathroom1
	end
	);
-- change field name and delete dup field
alter table property_details_temp1
	rename bathroom1 to new_bathroom;
alter table property_details_temp1
	drop column bathroom2;

-- correct assessed type
update property_details_temp1
set assessed_type1 = assessed_type2
where assessed_type1 is null and assessed_type2 is not null;
-- change field name and delete dup field
alter table property_details_temp1
	rename assessed_type1 to new_assessed_type;
alter table property_details_temp1
	drop column assessed_type2;

-- correct lot size
update property_details_temp1
	set lot_size1 = null
	where lot_size1 = '0';
update property_details_temp1
	set lot_size2 = null
	where lot_size2 = '0';
update property_details_temp1
set lot_size1 = (
	case when lot_size1 is null and lot_size2 is not null
		then lot_size2
	when lot_size1 > lot_size2
		then lot_size1
	when lot_size1 < lot_size2
		then lot_size2
	else lot_size1
	end
);
-- change field name and delete dup field
alter table property_details_temp1
	rename lot_size1 to new_lot_size;
alter table property_details_temp1
	drop column lot_size2;

-- correct den
update property_details_temp1
set den1 = (
	case when den1 is null and den2 is not null
		then den2
	when den1 > den2
		then den1
	when den1 < den2
		then den2
	else den1
	end
);
-- change field name and delete dup field
alter table property_details_temp1
	rename den1 to new_den;
alter table property_details_temp1
	drop column den2;

-- correct normalized type
update property_details_temp1
	set normalized_type1 = null
	where normalized_type1 ilike 'Residential Attached';
update property_details_temp1
	set normalized_type2 = null
	where normalized_type2 ilike 'Residential Attached';
update property_details_temp1
	set normalized_type1 = 'Townhouse'
	where normalized_type1 ~~* 'twnhs';
update property_details_temp1
	set normalized_type2 = 'Townhouse'
	where normalized_type2 ~~* 'twnhs';
update property_details_temp1
	set normalized_type1 = 'Apartment Condo'
	where normalized_type1 ~~* 'apartment_condo';
update property_details_temp1
	set normalized_type2 = 'Apartment Condo'
	where normalized_type2 ~~* 'apartment_condo';
update property_details_temp1
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(dupxh|duplx|duplex)'
		then 'Duplex'
	when lower(normalized_type1) similar to '(land only|land_lot)' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* '3plex' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial)' and normalized_type2 ~~* 'aptu'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'aptu' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'manuf' and normalized_type2 ~~* 'mfd_mobile_home'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'other' and normalized_type2 is not null
		then initcap(normalized_type2)
	else initcap(normalized_type1)
	end
);
-- change field name and delete dup field
alter table property_details_temp1
	rename normalized_type1 to new_normalized_type;
alter table property_details_temp1
	drop column normalized_type2;

-- correct lot frontage
update property_details_temp1
set lot_frontage1 = (
	case when lot_frontage1 is null and lot_frontage2 is not null
		then lot_frontage2
	when lot_frontage1 > lot_frontage2
		then lot_frontage1
	when lot_frontage1 < lot_frontage2
		then lot_frontage2
	else lot_frontage1
	end
);
-- change field name and delete dup field
alter table property_details_temp1
	rename lot_frontage1 to new_lot_frontage;
alter table property_details_temp1
	drop column lot_frontage2;

-- correct lot depth
update property_details_temp1
set lot_depth1 = (
	case when lot_depth1 is null and lot_depth2 is not null
		then lot_depth2
	when lot_depth1 > lot_depth2
		then lot_depth1
	when lot_depth1 < lot_depth2
		then lot_depth2
	else lot_depth1
	end
);
-- change field name and delete dup field
alter table property_details_temp1
	rename lot_depth1 to new_lot_depth;
alter table property_details_temp1
	drop column lot_depth2;

---------------------------------------------------------------------------------------------------------------------------------

create table property_details_temp as 
(select distinct (dup_id, new_legal_type, new_strata_fee, new_property_tax, new_year_built, new_floor_area, new_bedroom, new_bathroom, new_assessed_type, new_lot_size, new_den, new_normalized_type, new_lot_frontage, new_lot_depth) dup_id, new_legal_type, new_strata_fee, new_property_tax, new_year_built, new_floor_area, new_bedroom, new_bathroom, new_assessed_type, new_lot_size, new_den, new_normalized_type, new_lot_frontage, new_lot_depth from property_details_temp1);

-----------------------------------------------------------------------------------------------------------------------

-- PART 2
-- create table property_details_temp2 as join of new_properties_dup_id with itself
create table property_details_temp2 as
(select pd1.dup_id, 
	pd1.new_legal_type as legal_type1, 
	pd2.new_legal_type as legal_type2, 
	pd1.new_strata_fee as strata_fee1, 
	pd2.new_strata_fee as strata_fee2, 
	pd1.new_property_tax as property_tax1,
	pd2.new_property_tax as property_tax2,
	pd1.new_year_built as year_built1,
	pd2.new_year_built as year_built2,
	pd1.new_floor_area as floor_area1,
	pd2.new_floor_area as floor_area2,
	pd1.new_bedroom as bedroom1,
	pd2.new_bedroom as bedroom2,
	pd1.new_bathroom as bathroom1,
	pd2.new_bathroom as bathroom2,
	pd1.new_assessed_type as assessed_type1,
	pd2.new_assessed_type as assessed_type2,
	pd1.new_lot_size as lot_size1,
	pd2.new_lot_size as lot_size2,
	pd1.new_den as den1,
	pd2.new_den as den2,
	pd1.new_normalized_type as normalized_type1,
	pd2.new_normalized_type as normalized_type2,
	pd1.new_lot_frontage as lot_frontage1,
	pd2.new_lot_frontage as lot_frontage2,
	pd1.new_lot_depth as lot_depth1,
	pd2.new_lot_depth as lot_depth2
from property_details_temp pd1
left join property_details_temp  pd2
using (dup_id)
where pd1.id != pd2.id)
;
-- alter table property_details_temp2 add column id serial;

drop table property_details_temp;

-- correct legal_type
update property_details_temp2
set legal_type1 = legal_type2
where legal_type1 is null and legal_type2 is not null;
-- change change field name and delete dup field
alter table property_details_temp2
	rename legal_type1 to new_legal_type;
alter table property_details_temp2
	drop column legal_type2;

-- correct strata fee
update property_details_temp2
set strata_fee1 = (
	case when strata_fee1 is null and strata_fee2 is not null
		then strata_fee2
	when strata_fee1 > strata_fee2
		then strata_fee1
	when strata_fee1 < strata_fee2
		then strata_fee2
	else strata_fee1
	end
);
-- change field name and delete dup field
alter table property_details_temp2
	rename strata_fee1 to new_strata_fee;
alter table property_details_temp2
	drop column strata_fee2;

-- correct property_tax
update property_details_temp2
set property_tax1 = (
	case when property_tax1 is null and property_tax2 is not null
		then property_tax2
	when property_tax1 > property_tax2
		then property_tax1
	when property_tax1 < property_tax2
		then property_tax2
	else property_tax1
	end
);
-- change field name and delete dup field
alter table property_details_temp2
	rename property_tax1 to new_property_tax;
alter table property_details_temp2
	drop column property_tax2;
--
-- correct year built
update property_details_temp2
	set year_built1 = null
	where year_built1 > extract(year from current_date);
update property_details_temp2
	set year_built2 = null
	where year_built2 > extract(year from current_date);
update property_details_temp2
set year_built1 = (
	case when year_built1 is null and year_built2 is not null
		then year_built2
	when year_built1 > year_built2
		then year_built1
	when year_built1 < year_built2
		then year_built2
	else year_built1
	end
);
-- change field name and delete dup field
alter table property_details_temp2
	rename year_built1 to new_year_built;
alter table property_details_temp2
 	drop column year_built2;

-- correct floor area
update property_details_temp2
set floor_area1 = (
	case when floor_area1 is null and floor_area2 is not null
		then floor_area2
	when floor_area1 > floor_area2
		then floor_area1
	when floor_area1 < floor_area2
		then floor_area2
	else floor_area1
	end
);
-- change field name and delete dup field
alter table property_details_temp2
	rename floor_area1 to new_floor_area;
alter table property_details_temp2
	drop column floor_area2;

-- correct bedrooms
update property_details_temp2
set bedroom1 = (
	case when bedroom1 is null and bedroom2 is not null
		then bedroom2
	when bedroom1 > bedroom2
		then bedroom1
	when bedroom1 < bedroom2
		then bedroom2
	else bedroom1
	end
	);
-- change field name and delete dup field
alter table property_details_temp2
	rename bedroom1 to new_bedroom;
alter table property_details_temp2
	drop column bedroom2;

-- correct bathrooms
update property_details_temp2
set bathroom1 = (
	case when bathroom1 is null and bathroom2 is not null
		then bathroom2
	when bathroom1 > bathroom2
		then bathroom1
	when bathroom1 < bathroom2
		then bathroom2
	else bathroom1
	end
	);
-- change field name and delete dup field
alter table property_details_temp2
	rename bathroom1 to new_bathroom;
alter table property_details_temp2
	drop column bathroom2;

-- correct assessed type
update property_details_temp2
set assessed_type1 = assessed_type2
where assessed_type1 is null and assessed_type2 is not null;
-- change field name and delete dup field
alter table property_details_temp2
	rename assessed_type1 to new_assessed_type;
alter table property_details_temp2
	drop column assessed_type2;

-- correct lot size
update property_details_temp2
	set lot_size1 = null
	where lot_size1 = '0';
update property_details_temp2
	set lot_size2 = null
	where lot_size2 = '0';
update property_details_temp2
set lot_size1 = (
	case when lot_size1 is null and lot_size2 is not null
		then lot_size2
	when lot_size1 > lot_size2
		then lot_size1
	when lot_size1 < lot_size2
		then lot_size2
	else lot_size1
	end
);
-- change field name and delete dup field
alter table property_details_temp2
	rename lot_size1 to new_lot_size;
alter table property_details_temp2
	drop column lot_size2;

-- correct den
update property_details_temp2
set den1 = (
	case when den1 is null and den2 is not null
		then den2
	when den1 > den2
		then den1
	when den1 < den2
		then den2
	else den1
	end
);
-- change field name and delete dup field
alter table property_details_temp2
	rename den1 to new_den;
alter table property_details_temp2
	drop column den2;

-- correct normalized type
update property_details_temp2
	set normalized_type1 = null
	where normalized_type1 ilike 'Residential Attached';
update property_details_temp2
	set normalized_type2 = null
	where normalized_type2 ilike 'Residential Attached';
update property_details_temp2
	set normalized_type1 = 'Townhouse'
	where normalized_type1 ~~* 'twnhs';
update property_details_temp2
	set normalized_type2 = 'Townhouse'
	where normalized_type2 ~~* 'twnhs';
update property_details_temp2
	set normalized_type1 = 'Apartment Condo'
	where normalized_type1 ~~* 'apartment_condo';
update property_details_temp2
	set normalized_type2 = 'Apartment Condo'
	where normalized_type2 ~~* 'apartment_condo';
update property_details_temp2
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(dupxh|duplx|duplex)'
		then 'Duplex'
	when lower(normalized_type1) similar to '(land only|land_lot)' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* '3plex' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial)' and normalized_type2 ~~* 'aptu'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'aptu' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'manuf' and normalized_type2 ~~* 'mfd_mobile_home'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'other' and normalized_type2 is not null
		then initcap(normalized_type2)
	else initcap(normalized_type1)
	end
);
-- change field name and delete dup field
alter table property_details_temp2
	rename normalized_type1 to new_normalized_type;
alter table property_details_temp2
	drop column normalized_type2;

-- correct lot frontage
update property_details_temp2
set lot_frontage1 = (
	case when lot_frontage1 is null and lot_frontage2 is not null
		then lot_frontage2
	when lot_frontage1 > lot_frontage2
		then lot_frontage1
	when lot_frontage1 < lot_frontage2
		then lot_frontage2
	else lot_frontage1
	end
);
-- change field name and delete dup field
alter table property_details_temp2
	rename lot_frontage1 to new_lot_frontage;
alter table property_details_temp2
	drop column lot_frontage2;

-- correct lot depth
update property_details_temp2
set lot_depth1 = (
	case when lot_depth1 is null and lot_depth2 is not null
		then lot_depth2
	when lot_depth1 > lot_depth2
		then lot_depth1
	when lot_depth1 < lot_depth2
		then lot_depth2
	else lot_depth1
	end
);
-- change field name and delete dup field
alter table property_details_temp2
	rename lot_depth1 to new_lot_depth;
alter table property_details_temp2
	drop column lot_depth2;


---------------------------------------------------------------------------------------------------------------------------------

-- PART 3
-- Create property_details table

-- change all null values to -1
update property_details_temp2 set new_legal_type = -1 where new_legal_type is null;
update property_details_temp2 set new_strata_fee = -1 where new_strata_fee is null;
update property_details_temp2 set new_property_tax = -1 where new_property_tax is null;
update property_details_temp2 set new_year_built = -1 where new_year_built is null;
update property_details_temp2 set new_floor_area = -1 where new_floor_area is null;
update property_details_temp2 set new_bedroom = -1 where new_bedroom is null;
update property_details_temp2 set new_bathroom = -1 where new_bathroom is null;
update property_details_temp2 set new_assessed_type = -1 where new_assessed_type is null;
update property_details_temp2 set new_lot_size = -1 where new_lot_size is null;
update property_details_temp2 set new_den = -1 where new_den is null;
update property_details_temp2 set new_normalized_type = -1 where new_normalized_type is null;
update property_details_temp2 set new_lot_frontage = -1 where new_lot_frontage is null;
update property_details_temp2 set new_lot_depth = -1 where new_lot_depth is null;

-- create new property_details table with unique values from property_details temp value - removing duplicates
create table property_details as
select distinct * from property_details_temp2;

-- change -1 values to null
update property_details set new_legal_type = null where new_legal_type = '-1';
update property_details set new_strata_fee = null where new_strata_fee = '-1';
update property_details set new_property_tax = null where new_property_tax = '-1';
update property_details set new_year_built = null where new_year_built = '-1';
update property_details set new_floor_area = null where new_floor_area = '-1';
update property_details set new_bedroom = null where new_bedroom = '-1';
update property_details set new_bathroom = null where new_bathroom = '-1';
update property_details set new_assessed_type = null where new_assessed_type = '-1';
update property_details set new_lot_size = null where new_lot_size = '-1';
update property_details set new_den = null where new_den = '-1';
update property_details set new_normalized_type = null where new_normalized_type = '-1';
update property_details set new_lot_frontage = null where new_lot_frontage = '-1';
update property_details set new_lot_depth = null where new_lot_depth = '-1';

-- drop table property_details_temp1;
-- drop table property_details_temp2;