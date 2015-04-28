
-- PART 1
-- create table property_details_temp1 as join of new_properties_dup_id with itself
create table property_details_temp1 as
(select np1.dup_id, 
	np1.latitude as latitude1,
	np2.latitude as latitude2,
	np1.longitude as longitude1,
	np2.longitude as longitude2,
	np1.geocode_source as geocode_source1,
	np2.geocode_source as geocode_source2,
	np1.geocode_type as geocode_type1,
	np2.geocode_type as geocode_type2,
	np1.geocode_status as geocode_status1,
	np2.geocode_status as geocode_status2,
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

--correct latitude
update property_details_temp1
set latitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then latitude2
	when geocode_status1 is null and geocode_status2 is not null
		then latitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then latitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then latitude2
	else latitude1
	end
);

-- change change field name and delete dup field
alter table property_details_temp1
	rename latitude1 to new_latitude;
alter table property_details_temp1
	drop column latitude2;

--correct longitude
update property_details_temp1
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then longitude2
	when geocode_status1 is null and geocode_status2 is not null
		then longitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then longitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then longitude2
	else longitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp1
	rename longitude1 to new_longitude;
alter table property_details_temp1
	drop column longitude2;

--correct geocode_source
update property_details_temp1
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_source2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_source2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_source2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_source2
	else geocode_source1
	end
);
-- change change field name and delete dup field
alter table property_details_temp1
	rename geocode_source1 to new_geocode_source;
alter table property_details_temp1
	drop column geocode_source2;

--correct geocode_type
update property_details_temp1
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_type2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_type2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_type2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_type2
	else geocode_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp1
	rename geocode_type1 to new_geocode_type;
alter table property_details_temp1
	drop column geocode_type2;

--correct geocode_status
update property_details_temp1
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_status2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_status2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_status2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_status2
	else geocode_status1
	end
);

-- change change field name and delete dup field
alter table property_details_temp1
	rename geocode_status1 to new_geocode_status;
alter table property_details_temp1
	drop column geocode_status2;

-- correct legal_type
update property_details_temp1
set legal_type1 = (
	case when legal_type1 is null and legal_type2 is not null
		then legal_type2
	when legal_type1 ~~* 'land' and legal_type2 ~~* 'strata'
		then 'STRATA'
	else legal_type1
	end
);
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
set assessed_type1 = (
	case when assessed_type1 is null and assessed_type2 is not null
		then assessed_type2
	when assessed_type1 similar to '(Strata Office - 1 To 10 Storey|Strata Lot - Parking Commercial|Strata Lot - Parking Residential)' and assessed_type2 ~~* 'Strata General Commercial'
		then assessed_type2
	when assessed_type1 ~~* '2 STY house - semicustom' and assessed_type2 ~~* '1 STY Duplex -  standard' 
		then assessed_type2
	when assessed_type1 ~~* 'Floating Marine Imprmnt' and assessed_type2 ~~* 'Retail Store'
		then assessed_type2
	when assessed_type1 ~~* 'Domestic Garage_2 Storey - Above Average Quality' and assessed_type2 ~~* '3 STY house - semicustom'
		then assessed_type2
	when assessed_type1 ~~* 'Paving - Asphalt' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* 'Wharf - Light Construction'
		then assessed_type2
	when assessed_type1 ~~* 'Vacant Residential Less Than 2 Acres' and assessed_type2 ~~* '1 1/2 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	else assessed_type1
	end
);
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
	where lower(normalized_type1) similar to '(apartment_condo|aptu)';
update property_details_temp1
	set normalized_type2 = 'Apartment Condo'
	where lower(normalized_type2) similar to '(apartment_condo|aptu)';
update property_details_temp1
	set normalized_type1 = 'Duplex'
	where lower(normalized_type1) similar to '(dupxh|duplx|duplex)';
update property_details_temp1
	set normalized_type2 = 'Duplex'
	where lower(normalized_type2) similar to '(dupxh|duplx|duplex)';
update property_details_temp1
	set normalized_type1 = 'Recre'
	where normalized_type1 ~~* 'recreational';
update property_details_temp1
	set normalized_type2 = 'Recre'
	where normalized_type2 ~~* 'recreational';
update property_details_temp1
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh|triplex|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily|land only|comprehensive development|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(land only|land_lot)' and lower(normalized_type2) similar to '(house|two family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu|dupxh|two family dwelling|apartment condo)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and lower(normalized_type2) similar to '(townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house|multiple family dwelling|duplex)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo|apartment condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'apartment condo' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'shared_owner' and lower(normalized_type2) similar to '(aptu|duplex|townhouse|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'recre' and lower(normalized_type2) similar to '(house|aptu|apartment condo|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'chalet' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mnfld' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when (normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'one family dwelling') or (normalized_type1 ~~* 'one family dwelling' and normalized_type2 ~~* 'two family dwelling')
		then 'Multi Family Dwelling'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(two family dwelling|one family dwelling)' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(duplex|3plex|triplex|fourplex|4plex)' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|one family dwelling|multifamily|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house|limited agricultural|two family dwelling|manuf|duplex|chalet|recre)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo|aptu|townhouse)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial|industrial|limited agricultural)' and lower(normalized_type2) similar to '(aptu|house|townhouse|apartment condo|comprehensive development|3plex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'light industrial' and normalized_type2 ~~* 'one family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'apartment condo' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|one family dwelling|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(manuf|mnfld)' and lower(normalized_type2) similar to '(mfd_mobile_home|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'timeshare' and normalized_type2 is not null
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

-- create temporary table with unique values from Part 1
create table property_details_dup_fix1 as 
(select distinct dup_id, new_legal_type, new_strata_fee, new_property_tax, new_year_built, new_floor_area, new_bedroom, new_bathroom, new_assessed_type, new_lot_size, new_den, new_normalized_type, new_lot_frontage, new_lot_depth from property_details_temp1);
alter table property_details_dup_fix1 add column id serial;

-----------------------------------------------------------------------------------------------------------------------

-- PART 2
-- create table property_details_temp2 as join of new_properties_dup_id with itself
create table property_details_temp2 as
(select np1.dup_id, 
	np1.latitude as latitude1,
	np2.latitude as latitude2,
	np1.longitude as longitude1,
	np2.longitude as longitude2,
	np1.geocode_source as geocode_source1,
	np2.geocode_source as geocode_source2,
	np1.geocode_type as geocode_type1,
	np2.geocode_type as geocode_type2,
	np1.geocode_status as geocode_status1,
	np2.geocode_status as geocode_status2,
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

--correct latitude
update property_details_temp2
set latitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then latitude2
	when geocode_status1 is null and geocode_status2 is not null
		then latitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then latitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then latitude2
	else latitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp2
	rename latitude1 to new_latitude;
alter table property_details_temp2
	drop column latitude2;

--correct longitude
update property_details_temp2
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then longitude2
	when geocode_status1 is null and geocode_status2 is not null
		then longitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then longitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then longitude2
	else longitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp2
	rename longitude1 to new_longitude;
alter table property_details_temp2
	drop column longitude2;

--correct geocode_source
update property_details_temp2
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_source2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_source2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_source2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_source2
	else geocode_source1
	end
);
-- change change field name and delete dup field
alter table property_details_temp2
	rename geocode_source1 to new_geocode_source;
alter table property_details_temp2
	drop column geocode_source2;

--correct geocode_type
update property_details_temp2
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_type2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_type2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_type2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_type2
	else geocode_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp2
	rename geocode_type1 to new_geocode_type;
alter table property_details_temp2
	drop column geocode_type2;

--correct geocode_status
update property_details_temp2
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_status2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_status2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_status2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_status2
	else geocode_status1
	end
);
-- change change field name and delete dup field
alter table property_details_temp2
	rename geocode_status1 to new_geocode_status;
alter table property_details_temp1
	drop column geocode_status2;

-- correct legal_type
update property_details_temp2
set legal_type1 = (
	case when legal_type1 is null and legal_type2 is not null
		then legal_type2
	when legal_type1 ~~* 'land' and legal_type2 ~~* 'strata'
		then 'STRATA'
	else legal_type1
	end
);
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
set assessed_type1 = (
	case when assessed_type1 is null and assessed_type2 is not null
		then assessed_type2
	when assessed_type1 similar to '(Strata Office - 1 To 10 Storey|Strata Lot - Parking Commercial|Strata Lot - Parking Residential)' and assessed_type2 ~~* 'Strata General Commercial'
		then assessed_type2
	when assessed_type1 ~~* '2 STY house - semicustom' and assessed_type2 ~~* '1 STY Duplex -  standard' 
		then assessed_type2
	when assessed_type1 ~~* 'Floating Marine Imprmnt' and assessed_type2 ~~* 'Retail Store'
		then assessed_type2
	when assessed_type1 ~~* 'Domestic Garage_2 Storey - Above Average Quality' and assessed_type2 ~~* '3 STY house - semicustom'
		then assessed_type2
	when assessed_type1 ~~* 'Paving - Asphalt' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* 'Wharf - Light Construction'
		then assessed_type2
	when assessed_type1 ~~* 'Vacant Residential Less Than 2 Acres' and assessed_type2 ~~* '1 1/2 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	else assessed_type1
	end
);
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
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh|triplex|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily|land only|comprehensive development|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(land only|land_lot)' and lower(normalized_type2) similar to '(house|two family dwelling|duplex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu|dupxh|two family dwelling|apartment condo)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and lower(normalized_type2) similar to '(townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house|multiple family dwelling)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo|apartment condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'apartment condo' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'shared_owner' and lower(normalized_type2) similar to '(aptu|duplex|townhouse|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'recre' and lower(normalized_type2) similar to '(house|aptu|apartment condo|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'chalet' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mnfld' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when (normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'one family dwelling') or (normalized_type1 ~~* 'one family dwelling' and normalized_type2 ~~* 'two family dwelling')
		then 'Multi Family Dwelling'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(two family dwelling|one family dwelling)' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(duplex|3plex|triplex|fourplex|4plex)' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|one family dwelling|multifamily|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house|limited agricultural|two family dwelling|manuf|duplex|chalet|recre)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo|aptu|townhouse)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial|industrial|limited agricultural)' and lower(normalized_type2) similar to '(aptu|house|townhouse|apartment condo|comprehensive development|3plex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'light industrial' and normalized_type2 ~~* 'one family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'apartment condo' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|one family dwelling|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(manuf|mnfld)' and lower(normalized_type2) similar to '(mfd_mobile_home|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'timeshare' and normalized_type2 is not null
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

-- create temporary table with unique values from Part 1
create table property_details_dup_fix2 as 
(select distinct dup_id, new_legal_type, new_strata_fee, new_property_tax, new_year_built, new_floor_area, new_bedroom, new_bathroom, new_assessed_type, new_lot_size, new_den, new_normalized_type, new_lot_frontage, new_lot_depth from property_details_temp2);
alter table property_details_dup_fix2 add column id serial;

-----------------------------------------------------------------------------------------------------------------------

-- PART 3
-- create table property_details_temp3 as join of new_properties_dup_id with itself
create table property_details_temp3 as
(select np1.dup_id, 
	np1.latitude as latitude1,
	np2.latitude as latitude2,
	np1.longitude as longitude1,
	np2.longitude as longitude2,
	np1.geocode_source as geocode_source1,
	np2.geocode_source as geocode_source2,
	np1.geocode_type as geocode_type1,
	np2.geocode_type as geocode_type2,
	np1.geocode_status as geocode_status1,
	np2.geocode_status as geocode_status2,
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

--correct latitude
update property_details_temp3
set latitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then latitude2
	when geocode_status1 is null and geocode_status2 is not null
		then latitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then latitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then latitude2
	else latitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp3
	rename latitude1 to new_latitude;
alter table property_details_temp3
	drop column latitude2;

--correct longitude
update property_details_temp3
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then longitude2
	when geocode_status1 is null and geocode_status2 is not null
		then longitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then longitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then longitude2
	else longitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp3
	rename longitude1 to new_longitude;
alter table property_details_temp3
	drop column longitude2;

--correct geocode_source
update property_details_temp3
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_source2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_source2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_source2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_source2
	else geocode_source1
	end
);
-- change change field name and delete dup field
alter table property_details_temp3
	rename geocode_source1 to new_geocode_source;
alter table property_details_temp3
	drop column geocode_source2;

--correct geocode_type
update property_details_temp3
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_type2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_type2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_type2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_type2
	else geocode_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp3
	rename geocode_type1 to new_geocode_type;
alter table property_details_temp3
	drop column geocode_type2;

--correct geocode_status
update property_details_temp3
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_status2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_status2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_status2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_status2
	else geocode_status1
	end
);
-- change change field name and delete dup field
alter table property_details_temp3
	rename geocode_status1 to new_geocode_status;
alter table property_details_temp3
	drop column geocode_status2;

-- correct legal_type
update property_details_temp3
set legal_type1 = (
	case when legal_type1 is null and legal_type2 is not null
		then legal_type2
	when legal_type1 ~~* 'land' and legal_type2 ~~* 'strata'
		then 'STRATA'
	else legal_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp3
	rename legal_type1 to new_legal_type;
alter table property_details_temp3
	drop column legal_type2;

-- correct strata fee
update property_details_temp3
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
alter table property_details_temp3
	rename strata_fee1 to new_strata_fee;
alter table property_details_temp3
	drop column strata_fee2;

-- correct property_tax
update property_details_temp3
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
alter table property_details_temp3
	rename property_tax1 to new_property_tax;
alter table property_details_temp3
	drop column property_tax2;
--
-- correct year built
update property_details_temp3
	set year_built1 = null
	where year_built1 > extract(year from current_date);
update property_details_temp3
	set year_built2 = null
	where year_built2 > extract(year from current_date);
update property_details_temp3
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
alter table property_details_temp3
	rename year_built1 to new_year_built;
alter table property_details_temp3
 	drop column year_built2;

-- correct floor area
update property_details_temp3
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
alter table property_details_temp3
	rename floor_area1 to new_floor_area;
alter table property_details_temp3
	drop column floor_area2;

-- correct bedrooms
update property_details_temp3
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
alter table property_details_temp3
	rename bedroom1 to new_bedroom;
alter table property_details_temp3
	drop column bedroom2;

-- correct bathrooms
update property_details_temp3
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
alter table property_details_temp3
	rename bathroom1 to new_bathroom;
alter table property_details_temp3
	drop column bathroom2;

-- correct assessed type
update property_details_temp3
set assessed_type1 = (
	case when assessed_type1 is null and assessed_type2 is not null
		then assessed_type2
	when assessed_type1 similar to '(Strata Office - 1 To 10 Storey|Strata Lot - Parking Commercial|Strata Lot - Parking Residential)' and assessed_type2 ~~* 'Strata General Commercial'
		then assessed_type2
	when assessed_type1 ~~* '2 STY house - semicustom' and assessed_type2 ~~* '1 STY Duplex -  standard' 
		then assessed_type2
	when assessed_type1 ~~* 'Floating Marine Imprmnt' and assessed_type2 ~~* 'Retail Store'
		then assessed_type2
	when assessed_type1 ~~* 'Domestic Garage_2 Storey - Above Average Quality' and assessed_type2 ~~* '3 STY house - semicustom'
		then assessed_type2
	when assessed_type1 ~~* 'Paving - Asphalt' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* 'Wharf - Light Construction'
		then assessed_type2
	when assessed_type1 ~~* 'Vacant Residential Less Than 2 Acres' and assessed_type2 ~~* '1 1/2 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	else assessed_type1
	end
);
-- change field name and delete dup field
alter table property_details_temp3
	rename assessed_type1 to new_assessed_type;
alter table property_details_temp3
	drop column assessed_type2;

-- correct lot size
update property_details_temp3
	set lot_size1 = null
	where lot_size1 = '0';
update property_details_temp3
	set lot_size2 = null
	where lot_size2 = '0';
update property_details_temp3
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
alter table property_details_temp3
	rename lot_size1 to new_lot_size;
alter table property_details_temp3
	drop column lot_size2;

-- correct den
update property_details_temp3
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
alter table property_details_temp3
	rename den1 to new_den;
alter table property_details_temp3
	drop column den2;

-- correct normalized type
update property_details_temp3
	set normalized_type1 = null
	where normalized_type1 ilike 'Residential Attached';
update property_details_temp3
	set normalized_type2 = null
	where normalized_type2 ilike 'Residential Attached';
update property_details_temp3
	set normalized_type1 = 'Townhouse'
	where normalized_type1 ~~* 'twnhs';
update property_details_temp3
	set normalized_type2 = 'Townhouse'
	where normalized_type2 ~~* 'twnhs';
update property_details_temp3
	set normalized_type1 = 'Apartment Condo'
	where normalized_type1 ~~* 'apartment_condo';
update property_details_temp3
	set normalized_type2 = 'Apartment Condo'
	where normalized_type2 ~~* 'apartment_condo';
update property_details_temp3
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh|triplex|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily|land only|comprehensive development|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(land only|land_lot)' and lower(normalized_type2) similar to '(house|two family dwelling|duplex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu|dupxh|two family dwelling|apartment condo)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and lower(normalized_type2) similar to '(townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house|multiple family dwelling)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo|apartment condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'apartment condo' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'shared_owner' and lower(normalized_type2) similar to '(aptu|duplex|townhouse|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'recre' and lower(normalized_type2) similar to '(house|aptu|apartment condo|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'chalet' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mnfld' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when (normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'one family dwelling') or (normalized_type1 ~~* 'one family dwelling' and normalized_type2 ~~* 'two family dwelling')
		then 'Multi Family Dwelling'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(two family dwelling|one family dwelling)' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(duplex|3plex|triplex|fourplex|4plex)' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|one family dwelling|multifamily|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house|limited agricultural|two family dwelling|manuf|duplex|chalet|recre)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo|aptu|townhouse)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial|industrial|limited agricultural)' and lower(normalized_type2) similar to '(aptu|house|townhouse|apartment condo|comprehensive development|3plex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'light industrial' and normalized_type2 ~~* 'one family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'apartment condo' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|one family dwelling|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(manuf|mnfld)' and lower(normalized_type2) similar to '(mfd_mobile_home|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'timeshare' and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'other' and normalized_type2 is not null
		then initcap(normalized_type2)
	else initcap(normalized_type1)
	end
);
-- change field name and delete dup field
alter table property_details_temp3
	rename normalized_type1 to new_normalized_type;
alter table property_details_temp3
	drop column normalized_type2;

-- correct lot frontage
update property_details_temp3
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
alter table property_details_temp3
	rename lot_frontage1 to new_lot_frontage;
alter table property_details_temp3
	drop column lot_frontage2;

-- correct lot depth
update property_details_temp3
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
alter table property_details_temp3
	rename lot_depth1 to new_lot_depth;
alter table property_details_temp3
	drop column lot_depth2;


---------------------------------------------------------------------------------------------------------------------------------

-- create temporary table with unique values from Part 3
create table property_details_dup_fix3 as 
(select distinct dup_id, new_legal_type, new_strata_fee, new_property_tax, new_year_built, new_floor_area, new_bedroom, new_bathroom, new_assessed_type, new_lot_size, new_den, new_normalized_type, new_lot_frontage, new_lot_depth from property_details_temp3);
alter table property_details_dup_fix3 add column id serial;

-----------------------------------------------------------------------------------------------------------------------

-- PART 4
-- create table property_details_temp4 as join of new_properties_dup_id with itself
create table property_details_temp4 as
(select np1.dup_id, 
	np1.latitude as latitude1,
	np2.latitude as latitude2,
	np1.longitude as longitude1,
	np2.longitude as longitude2,
	np1.geocode_source as geocode_source1,
	np2.geocode_source as geocode_source2,
	np1.geocode_type as geocode_type1,
	np2.geocode_type as geocode_type2,
	np1.geocode_status as geocode_status1,
	np2.geocode_status as geocode_status2,
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

--correct latitude
update property_details_temp4
set latitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then latitude2
	when geocode_status1 is null and geocode_status2 is not null
		then latitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then latitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then latitude2
	else latitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp4
	rename latitude1 to new_latitude;
alter table property_details_temp4
	drop column latitude2;

--correct longitude
update property_details_temp4
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then longitude2
	when geocode_status1 is null and geocode_status2 is not null
		then longitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then longitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then longitude2
	else longitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp4
	rename longitude1 to new_longitude;
alter table property_details_temp4
	drop column longitude2;

--correct geocode_source
update property_details_temp4
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_source2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_source2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_source2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_source2
	else geocode_source1
	end
);
-- change change field name and delete dup field
alter table property_details_temp4
	rename geocode_source1 to new_geocode_source;
alter table property_details_temp4
	drop column geocode_source2;

--correct geocode_type
update property_details_temp4
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_type2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_type2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_type2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_type2
	else geocode_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp4
	rename geocode_type1 to new_geocode_type;
alter table property_details_temp4
	drop column geocode_type2;

--correct geocode_status
update property_details_temp4
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_status2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_status2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_status2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_status2
	else geocode_status1
	end
);
-- change change field name and delete dup field
alter table property_details_temp4
	rename geocode_status1 to new_geocode_status;
alter table property_details_temp4
	drop column geocode_status2;

-- correct legal_type
update property_details_temp4
set legal_type1 = (
	case when legal_type1 is null and legal_type2 is not null
		then legal_type2
	when legal_type1 ~~* 'land' and legal_type2 ~~* 'strata'
		then 'STRATA'
	else legal_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp4
	rename legal_type1 to new_legal_type;
alter table property_details_temp4
	drop column legal_type2;

-- correct strata fee
update property_details_temp4
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
alter table property_details_temp4
	rename strata_fee1 to new_strata_fee;
alter table property_details_temp4
	drop column strata_fee2;

-- correct property_tax
update property_details_temp4
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
alter table property_details_temp4
	rename property_tax1 to new_property_tax;
alter table property_details_temp4
	drop column property_tax2;
--
-- correct year built
update property_details_temp4
	set year_built1 = null
	where year_built1 > extract(year from current_date);
update property_details_temp4
	set year_built2 = null
	where year_built2 > extract(year from current_date);
update property_details_temp4
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
alter table property_details_temp4
	rename year_built1 to new_year_built;
alter table property_details_temp4
 	drop column year_built2;

-- correct floor area
update property_details_temp4
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
alter table property_details_temp4
	rename floor_area1 to new_floor_area;
alter table property_details_temp4
	drop column floor_area2;

-- correct bedrooms
update property_details_temp4
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
alter table property_details_temp4
	rename bedroom1 to new_bedroom;
alter table property_details_temp4
	drop column bedroom2;

-- correct bathrooms
update property_details_temp4
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
alter table property_details_temp4
	rename bathroom1 to new_bathroom;
alter table property_details_temp4
	drop column bathroom2;

-- correct assessed type
update property_details_temp4
set assessed_type1 = (
	case when assessed_type1 is null and assessed_type2 is not null
		then assessed_type2
	when assessed_type1 similar to '(Strata Office - 1 To 10 Storey|Strata Lot - Parking Commercial|Strata Lot - Parking Residential)' and assessed_type2 ~~* 'Strata General Commercial'
		then assessed_type2
	when assessed_type1 ~~* '2 STY house - semicustom' and assessed_type2 ~~* '1 STY Duplex -  standard' 
		then assessed_type2
	when assessed_type1 ~~* 'Floating Marine Imprmnt' and assessed_type2 ~~* 'Retail Store'
		then assessed_type2
	when assessed_type1 ~~* 'Domestic Garage_2 Storey - Above Average Quality' and assessed_type2 ~~* '3 STY house - semicustom'
		then assessed_type2
	when assessed_type1 ~~* 'Paving - Asphalt' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* 'Wharf - Light Construction'
		then assessed_type2
	when assessed_type1 ~~* 'Vacant Residential Less Than 2 Acres' and assessed_type2 ~~* '1 1/2 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	else assessed_type1
	end
);
-- change field name and delete dup field
alter table property_details_temp4
	rename assessed_type1 to new_assessed_type;
alter table property_details_temp4
	drop column assessed_type2;

-- correct lot size
update property_details_temp4
	set lot_size1 = null
	where lot_size1 = '0';
update property_details_temp4
	set lot_size2 = null
	where lot_size2 = '0';
update property_details_temp4
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
alter table property_details_temp4
	rename lot_size1 to new_lot_size;
alter table property_details_temp4
	drop column lot_size2;

-- correct den
update property_details_temp4
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
alter table property_details_temp4
	rename den1 to new_den;
alter table property_details_temp4
	drop column den2;

-- correct normalized type
update property_details_temp4
	set normalized_type1 = null
	where normalized_type1 ilike 'Residential Attached';
update property_details_temp4
	set normalized_type2 = null
	where normalized_type2 ilike 'Residential Attached';
update property_details_temp4
	set normalized_type1 = 'Townhouse'
	where normalized_type1 ~~* 'twnhs';
update property_details_temp4
	set normalized_type2 = 'Townhouse'
	where normalized_type2 ~~* 'twnhs';
update property_details_temp4
	set normalized_type1 = 'Apartment Condo'
	where normalized_type1 ~~* 'apartment_condo';
update property_details_temp4
	set normalized_type2 = 'Apartment Condo'
	where normalized_type2 ~~* 'apartment_condo';
update property_details_temp4
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh|triplex|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily|land only|comprehensive development|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(land only|land_lot)' and lower(normalized_type2) similar to '(house|two family dwelling|duplex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu|dupxh|two family dwelling|apartment condo)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and lower(normalized_type2) similar to '(townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house|multiple family dwelling)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo|apartment condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'apartment condo' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'shared_owner' and lower(normalized_type2) similar to '(aptu|duplex|townhouse|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'recre' and lower(normalized_type2) similar to '(house|aptu|apartment condo|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'chalet' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mnfld' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when (normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'one family dwelling') or (normalized_type1 ~~* 'one family dwelling' and normalized_type2 ~~* 'two family dwelling')
		then 'Multi Family Dwelling'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(two family dwelling|one family dwelling)' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(duplex|3plex|triplex|fourplex|4plex)' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|one family dwelling|multifamily|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house|limited agricultural|two family dwelling|manuf|duplex|chalet|recre)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo|aptu|townhouse)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial|industrial|limited agricultural)' and lower(normalized_type2) similar to '(aptu|house|townhouse|apartment condo|comprehensive development|3plex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'light industrial' and normalized_type2 ~~* 'one family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'apartment condo' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|one family dwelling|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(manuf|mnfld)' and lower(normalized_type2) similar to '(mfd_mobile_home|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'timeshare' and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'other' and normalized_type2 is not null
		then initcap(normalized_type2)
	else initcap(normalized_type1)
	end
);
-- change field name and delete dup field
alter table property_details_temp4
	rename normalized_type1 to new_normalized_type;
alter table property_details_temp4
	drop column normalized_type2;

-- correct lot frontage
update property_details_temp4
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
alter table property_details_temp4
	rename lot_frontage1 to new_lot_frontage;
alter table property_details_temp4
	drop column lot_frontage2;

-- correct lot depth
update property_details_temp4
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
alter table property_details_temp4
	rename lot_depth1 to new_lot_depth;
alter table property_details_temp4
	drop column lot_depth2;


---------------------------------------------------------------------------------------------------------------------------------

-- create temporary table with unique values from Part 4
create table property_details_dup_fix4 as 
(select distinct dup_id, new_legal_type, new_strata_fee, new_property_tax, new_year_built, new_floor_area, new_bedroom, new_bathroom, new_assessed_type, new_lot_size, new_den, new_normalized_type, new_lot_frontage, new_lot_depth from property_details_temp4);
alter table property_details_dup_fix4 add column id serial;

-----------------------------------------------------------------------------------------------------------------------

-- PART 5
-- create table property_details_temp4 as join of new_properties_dup_id with itself
create table property_details_temp5 as
(select np1.dup_id, 
	np1.latitude as latitude1,
	np2.latitude as latitude2,
	np1.longitude as longitude1,
	np2.longitude as longitude2,
	np1.geocode_source as geocode_source1,
	np2.geocode_source as geocode_source2,
	np1.geocode_type as geocode_type1,
	np2.geocode_type as geocode_type2,
	np1.geocode_status as geocode_status1,
	np2.geocode_status as geocode_status2,
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

--correct latitude
update property_details_temp5
set latitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then latitude2
	when geocode_status1 is null and geocode_status2 is not null
		then latitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then latitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then latitude2
	else latitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp5
	rename latitude1 to new_latitude;
alter table property_details_temp5
	drop column latitude2;

--correct longitude
update property_details_temp5
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then longitude2
	when geocode_status1 is null and geocode_status2 is not null
		then longitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then longitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then longitude2
	else longitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp5
	rename longitude1 to new_longitude;
alter table property_details_temp5
	drop column longitude2;

--correct geocode_source
update property_details_temp5
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_source2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_source2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_source2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_source2
	else geocode_source1
	end
);
-- change change field name and delete dup field
alter table property_details_temp5
	rename geocode_source1 to new_geocode_source;
alter table property_details_temp5
	drop column geocode_source2;

--correct geocode_type
update property_details_temp5
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_type2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_type2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_type2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_type2
	else geocode_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp5
	rename geocode_type1 to new_geocode_type;
alter table property_details_temp5
	drop column geocode_type2;

--correct geocode_status
update property_details_temp5
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_status2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_status2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_status2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_status2
	else geocode_status1
	end
);
-- change change field name and delete dup field
alter table property_details_temp5
	rename geocode_status1 to new_geocode_status;
alter table property_details_temp5
	drop column geocode_status2;

-- correct legal_type
update property_details_temp5
set legal_type1 = (
	case when legal_type1 is null and legal_type2 is not null
		then legal_type2
	when legal_type1 ~~* 'land' and legal_type2 ~~* 'strata'
		then 'STRATA'
	else legal_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp5
	rename legal_type1 to new_legal_type;
alter table property_details_temp5
	drop column legal_type2;

-- correct strata fee
update property_details_temp5
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
alter table property_details_temp5
	rename strata_fee1 to new_strata_fee;
alter table property_details_temp5
	drop column strata_fee2;

-- correct property_tax
update property_details_temp5
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
alter table property_details_temp5
	rename property_tax1 to new_property_tax;
alter table property_details_temp5
	drop column property_tax2;
--
-- correct year built
update property_details_temp5
	set year_built1 = null
	where year_built1 > extract(year from current_date);
update property_details_temp5
	set year_built2 = null
	where year_built2 > extract(year from current_date);
update property_details_temp5
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
alter table property_details_temp5
	rename year_built1 to new_year_built;
alter table property_details_temp5
 	drop column year_built2;

-- correct floor area
update property_details_temp5
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
alter table property_details_temp5
	rename floor_area1 to new_floor_area;
alter table property_details_temp5
	drop column floor_area2;

-- correct bedrooms
update property_details_temp5
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
alter table property_details_temp5
	rename bedroom1 to new_bedroom;
alter table property_details_temp5
	drop column bedroom2;

-- correct bathrooms
update property_details_temp5
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
alter table property_details_temp5
	rename bathroom1 to new_bathroom;
alter table property_details_temp5
	drop column bathroom2;

-- correct assessed type
update property_details_temp5
set assessed_type1 = (
	case when assessed_type1 is null and assessed_type2 is not null
		then assessed_type2
	when assessed_type1 similar to '(Strata Office - 1 To 10 Storey|Strata Lot - Parking Commercial|Strata Lot - Parking Residential)' and assessed_type2 ~~* 'Strata General Commercial'
		then assessed_type2
	when assessed_type1 ~~* '2 STY house - semicustom' and assessed_type2 ~~* '1 STY Duplex -  standard' 
		then assessed_type2
	when assessed_type1 ~~* 'Floating Marine Imprmnt' and assessed_type2 ~~* 'Retail Store'
		then assessed_type2
	when assessed_type1 ~~* 'Domestic Garage_2 Storey - Above Average Quality' and assessed_type2 ~~* '3 STY house - semicustom'
		then assessed_type2
	when assessed_type1 ~~* 'Paving - Asphalt' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* 'Wharf - Light Construction'
		then assessed_type2
	when assessed_type1 ~~* 'Vacant Residential Less Than 2 Acres' and assessed_type2 ~~* '1 1/2 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	else assessed_type1
	end
);
-- change field name and delete dup field
alter table property_details_temp5
	rename assessed_type1 to new_assessed_type;
alter table property_details_temp5
	drop column assessed_type2;

-- correct lot size
update property_details_temp5
	set lot_size1 = null
	where lot_size1 = '0';
update property_details_temp5
	set lot_size2 = null
	where lot_size2 = '0';
update property_details_temp5
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
alter table property_details_temp5
	rename lot_size1 to new_lot_size;
alter table property_details_temp5
	drop column lot_size2;

-- correct den
update property_details_temp5
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
alter table property_details_temp5
	rename den1 to new_den;
alter table property_details_temp5
	drop column den2;

-- correct normalized type
update property_details_temp5
	set normalized_type1 = null
	where normalized_type1 ilike 'Residential Attached';
update property_details_temp5
	set normalized_type2 = null
	where normalized_type2 ilike 'Residential Attached';
update property_details_temp5
	set normalized_type1 = 'Townhouse'
	where normalized_type1 ~~* 'twnhs';
update property_details_temp5
	set normalized_type2 = 'Townhouse'
	where normalized_type2 ~~* 'twnhs';
update property_details_temp5
	set normalized_type1 = 'Apartment Condo'
	where normalized_type1 ~~* 'apartment_condo';
update property_details_temp5
	set normalized_type2 = 'Apartment Condo'
	where normalized_type2 ~~* 'apartment_condo';
update property_details_temp5
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh|triplex|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily|land only|comprehensive development|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(land only|land_lot)' and lower(normalized_type2) similar to '(house|two family dwelling|duplex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu|dupxh|two family dwelling|apartment condo)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and lower(normalized_type2) similar to '(townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house|multiple family dwelling)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo|apartment condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'apartment condo' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'shared_owner' and lower(normalized_type2) similar to '(aptu|duplex|townhouse|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'recre' and lower(normalized_type2) similar to '(house|aptu|apartment condo|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'chalet' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mnfld' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when (normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'one family dwelling') or (normalized_type1 ~~* 'one family dwelling' and normalized_type2 ~~* 'two family dwelling')
		then 'Multi Family Dwelling'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(two family dwelling|one family dwelling)' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(duplex|3plex|triplex|fourplex|4plex)' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|one family dwelling|multifamily|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house|limited agricultural|two family dwelling|manuf|duplex|chalet|recre)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo|aptu|townhouse)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial|industrial|limited agricultural)' and lower(normalized_type2) similar to '(aptu|house|townhouse|apartment condo|comprehensive development|3plex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'light industrial' and normalized_type2 ~~* 'one family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'apartment condo' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|one family dwelling|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(manuf|mnfld)' and lower(normalized_type2) similar to '(mfd_mobile_home|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'timeshare' and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'other' and normalized_type2 is not null
		then initcap(normalized_type2)
	else initcap(normalized_type1)
	end
);
-- change field name and delete dup field
alter table property_details_temp5
	rename normalized_type1 to new_normalized_type;
alter table property_details_temp5
	drop column normalized_type2;

-- correct lot frontage
update property_details_temp5
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
alter table property_details_temp5
	rename lot_frontage1 to new_lot_frontage;
alter table property_details_temp5
	drop column lot_frontage2;

-- correct lot depth
update property_details_temp5
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
alter table property_details_temp5
	rename lot_depth1 to new_lot_depth;
alter table property_details_temp5
	drop column lot_depth2;


---------------------------------------------------------------------------------------------------------------------------------


-- create temporary table with unique values from Part 5
create table property_details_dup_fix5 as 
(select distinct dup_id, new_legal_type, new_strata_fee, new_property_tax, new_year_built, new_floor_area, new_bedroom, new_bathroom, new_assessed_type, new_lot_size, new_den, new_normalized_type, new_lot_frontage, new_lot_depth from property_details_temp5);
alter table property_details_dup_fix5 add column id serial;

-----------------------------------------------------------------------------------------------------------------------

-- PART 6
-- create table property_details_temp6 as join of new_properties_dup_id with itself
create table property_details_temp6 as
(select np1.dup_id, 
	np1.latitude as latitude1,
	np2.latitude as latitude2,
	np1.longitude as longitude1,
	np2.longitude as longitude2,
	np1.geocode_source as geocode_source1,
	np2.geocode_source as geocode_source2,
	np1.geocode_type as geocode_type1,
	np2.geocode_type as geocode_type2,
	np1.geocode_status as geocode_status1,
	np2.geocode_status as geocode_status2,
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

--correct latitude
update property_details_temp6
set latitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then latitude2
	when geocode_status1 is null and geocode_status2 is not null
		then latitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then latitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then latitude2
	else latitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp6
	rename latitude1 to new_latitude;
alter table property_details_temp6
	drop column latitude2;

--correct longitude
update property_details_temp6
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then longitude2
	when geocode_status1 is null and geocode_status2 is not null
		then longitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then longitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then longitude2
	else longitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp6
	rename longitude1 to new_longitude;
alter table property_details_temp6
	drop column longitude2;

--correct geocode_source
update property_details_temp6
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_source2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_source2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_source2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_source2
	else geocode_source1
	end
);
-- change change field name and delete dup field
alter table property_details_temp6
	rename geocode_source1 to new_geocode_source;
alter table property_details_temp6
	drop column geocode_source2;

--correct geocode_type
update property_details_temp6
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_type2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_type2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_type2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_type2
	else geocode_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp6
	rename geocode_type1 to new_geocode_type;
alter table property_details_temp6
	drop column geocode_type2;

--correct geocode_status
update property_details_temp6
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_status2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_status2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_status2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_status2
	else geocode_status1
	end
);
-- change change field name and delete dup field
alter table property_details_temp6
	rename geocode_status1 to new_geocode_status;
alter table property_details_temp6
	drop column geocode_status2;


-- correct legal_type
update property_details_temp6
set legal_type1 = (
	case when legal_type1 is null and legal_type2 is not null
		then legal_type2
	when legal_type1 ~~* 'land' and legal_type2 ~~* 'strata'
		then 'STRATA'
	else legal_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp6
	rename legal_type1 to new_legal_type;
alter table property_details_temp6
	drop column legal_type2;

-- correct strata fee
update property_details_temp6
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
alter table property_details_temp6
	rename strata_fee1 to new_strata_fee;
alter table property_details_temp6
	drop column strata_fee2;

-- correct property_tax
update property_details_temp6
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
alter table property_details_temp6
	rename property_tax1 to new_property_tax;
alter table property_details_temp6
	drop column property_tax2;
--
-- correct year built
update property_details_temp6
	set year_built1 = null
	where year_built1 > extract(year from current_date);
update property_details_temp6
	set year_built2 = null
	where year_built2 > extract(year from current_date);
update property_details_temp6
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
alter table property_details_temp6
	rename year_built1 to new_year_built;
alter table property_details_temp6
 	drop column year_built2;

-- correct floor area
update property_details_temp6
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
alter table property_details_temp6
	rename floor_area1 to new_floor_area;
alter table property_details_temp6
	drop column floor_area2;

-- correct bedrooms
update property_details_temp6
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
alter table property_details_temp6
	rename bedroom1 to new_bedroom;
alter table property_details_temp6
	drop column bedroom2;

-- correct bathrooms
update property_details_temp6
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
alter table property_details_temp6
	rename bathroom1 to new_bathroom;
alter table property_details_temp6
	drop column bathroom2;

-- correct assessed type
update property_details_temp6
set assessed_type1 = (
	case when assessed_type1 is null and assessed_type2 is not null
		then assessed_type2
	when assessed_type1 similar to '(Strata Office - 1 To 10 Storey|Strata Lot - Parking Commercial|Strata Lot - Parking Residential)' and assessed_type2 ~~* 'Strata General Commercial'
		then assessed_type2
	when assessed_type1 ~~* '2 STY house - semicustom' and assessed_type2 ~~* '1 STY Duplex -  standard' 
		then assessed_type2
	when assessed_type1 ~~* 'Floating Marine Imprmnt' and assessed_type2 ~~* 'Retail Store'
		then assessed_type2
	when assessed_type1 ~~* 'Domestic Garage_2 Storey - Above Average Quality' and assessed_type2 ~~* '3 STY house - semicustom'
		then assessed_type2
	when assessed_type1 ~~* 'Paving - Asphalt' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* 'Wharf - Light Construction'
		then assessed_type2
	when assessed_type1 ~~* 'Vacant Residential Less Than 2 Acres' and assessed_type2 ~~* '1 1/2 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	else assessed_type1
	end
);
-- change field name and delete dup field
alter table property_details_temp6
	rename assessed_type1 to new_assessed_type;
alter table property_details_temp6
	drop column assessed_type2;

-- correct lot size
update property_details_temp6
	set lot_size1 = null
	where lot_size1 = '0';
update property_details_temp6
	set lot_size2 = null
	where lot_size2 = '0';
update property_details_temp6
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
alter table property_details_temp6
	rename lot_size1 to new_lot_size;
alter table property_details_temp6
	drop column lot_size2;

-- correct den
update property_details_temp6
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
alter table property_details_temp6
	rename den1 to new_den;
alter table property_details_temp6
	drop column den2;

-- correct normalized type
update property_details_temp6
	set normalized_type1 = null
	where normalized_type1 ilike 'Residential Attached';
update property_details_temp6
	set normalized_type2 = null
	where normalized_type2 ilike 'Residential Attached';
update property_details_temp6
	set normalized_type1 = 'Townhouse'
	where normalized_type1 ~~* 'twnhs';
update property_details_temp6
	set normalized_type2 = 'Townhouse'
	where normalized_type2 ~~* 'twnhs';
update property_details_temp6
	set normalized_type1 = 'Apartment Condo'
	where normalized_type1 ~~* 'apartment_condo';
update property_details_temp6
	set normalized_type2 = 'Apartment Condo'
	where normalized_type2 ~~* 'apartment_condo';
update property_details_temp6
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh|triplex|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily|land only|comprehensive development|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(land only|land_lot)' and lower(normalized_type2) similar to '(house|two family dwelling|duplex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu|dupxh|two family dwelling|apartment condo)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and lower(normalized_type2) similar to '(townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house|multiple family dwelling)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo|apartment condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'apartment condo' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'shared_owner' and lower(normalized_type2) similar to '(aptu|duplex|townhouse|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'recre' and lower(normalized_type2) similar to '(house|aptu|apartment condo|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'chalet' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mnfld' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when (normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'one family dwelling') or (normalized_type1 ~~* 'one family dwelling' and normalized_type2 ~~* 'two family dwelling')
		then 'Multi Family Dwelling'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(two family dwelling|one family dwelling)' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(duplex|3plex|triplex|fourplex|4plex)' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|one family dwelling|multifamily|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house|limited agricultural|two family dwelling|manuf|duplex|chalet|recre)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo|aptu|townhouse)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial|industrial|limited agricultural)' and lower(normalized_type2) similar to '(aptu|house|townhouse|apartment condo|comprehensive development|3plex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'light industrial' and normalized_type2 ~~* 'one family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'apartment condo' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|one family dwelling|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(manuf|mnfld)' and lower(normalized_type2) similar to '(mfd_mobile_home|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'timeshare' and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'other' and normalized_type2 is not null
		then initcap(normalized_type2)
	else initcap(normalized_type1)
	end
);
-- change field name and delete dup field
alter table property_details_temp6
	rename normalized_type1 to new_normalized_type;
alter table property_details_temp6
	drop column normalized_type2;

-- correct lot frontage
update property_details_temp6
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
alter table property_details_temp6
	rename lot_frontage1 to new_lot_frontage;
alter table property_details_temp6
	drop column lot_frontage2;

-- correct lot depth
update property_details_temp6
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
alter table property_details_temp6
	rename lot_depth1 to new_lot_depth;
alter table property_details_temp6
	drop column lot_depth2;


---------------------------------------------------------------------------------------------------------------------------------


-- create temporary table with unique values from Part 6
create table property_details_dup_fix6 as 
(select distinct dup_id, new_legal_type, new_strata_fee, new_property_tax, new_year_built, new_floor_area, new_bedroom, new_bathroom, new_assessed_type, new_lot_size, new_den, new_normalized_type, new_lot_frontage, new_lot_depth from property_details_temp6);
alter table property_details_dup_fix6 add column id serial;

-----------------------------------------------------------------------------------------------------------------------

-- PART 7
-- create table property_details_temp7 as join of new_properties_dup_id with itself
create table property_details_temp7 as
(select np1.dup_id, 
	np1.latitude as latitude1,
	np2.latitude as latitude2,
	np1.longitude as longitude1,
	np2.longitude as longitude2,
	np1.geocode_source as geocode_source1,
	np2.geocode_source as geocode_source2,
	np1.geocode_type as geocode_type1,
	np2.geocode_type as geocode_type2,
	np1.geocode_status as geocode_status1,
	np2.geocode_status as geocode_status2,
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

--correct latitude
update property_details_temp7
set latitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then latitude2
	when geocode_status1 is null and geocode_status2 is not null
		then latitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then latitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then latitude2
	else latitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp7
	rename latitude1 to new_latitude;
alter table property_details_temp7
	drop column latitude2;

--correct longitude
update property_details_temp7
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then longitude2
	when geocode_status1 is null and geocode_status2 is not null
		then longitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then longitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then longitude2
	else longitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp7
	rename longitude1 to new_longitude;
alter table property_details_temp7
	drop column longitude2;

--correct geocode_source
update property_details_temp7
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_source2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_source2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_source2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_source2
	else geocode_source1
	end
);
-- change change field name and delete dup field
alter table property_details_temp7
	rename geocode_source1 to new_geocode_source;
alter table property_details_temp7
	drop column geocode_source2;

--correct geocode_type
update property_details_temp7
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_type2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_type2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_type2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_type2
	else geocode_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp7
	rename geocode_type1 to new_geocode_type;
alter table property_details_temp7
	drop column geocode_type2;

--correct geocode_status
update property_details_temp7
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_status2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_status2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_status2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_status2
	else geocode_status1
	end
);
-- change change field name and delete dup field
alter table property_details_temp7
	rename geocode_status1 to new_geocode_status;
alter table property_details_temp7
	drop column geocode_status2;

-- correct legal_type
update property_details_temp7
set legal_type1 = (
	case when legal_type1 is null and legal_type2 is not null
		then legal_type2
	when legal_type1 ~~* 'land' and legal_type2 ~~* 'strata'
		then 'STRATA'
	else legal_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp7
	rename legal_type1 to new_legal_type;
alter table property_details_temp7
	drop column legal_type2;

-- correct strata fee
update property_details_temp7
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
alter table property_details_temp7
	rename strata_fee1 to new_strata_fee;
alter table property_details_temp7
	drop column strata_fee2;

-- correct property_tax
update property_details_temp7
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
alter table property_details_temp7
	rename property_tax1 to new_property_tax;
alter table property_details_temp7
	drop column property_tax2;
--
-- correct year built
update property_details_temp7
	set year_built1 = null
	where year_built1 > extract(year from current_date);
update property_details_temp7
	set year_built2 = null
	where year_built2 > extract(year from current_date);
update property_details_temp7
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
alter table property_details_temp7
	rename year_built1 to new_year_built;
alter table property_details_temp7
 	drop column year_built2;

-- correct floor area
update property_details_temp7
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
alter table property_details_temp7
	rename floor_area1 to new_floor_area;
alter table property_details_temp7
	drop column floor_area2;

-- correct bedrooms
update property_details_temp7
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
alter table property_details_temp7
	rename bedroom1 to new_bedroom;
alter table property_details_temp7
	drop column bedroom2;

-- correct bathrooms
update property_details_temp7
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
alter table property_details_temp7
	rename bathroom1 to new_bathroom;
alter table property_details_temp7
	drop column bathroom2;

-- correct assessed type
update property_details_temp7
set assessed_type1 = (
	case when assessed_type1 is null and assessed_type2 is not null
		then assessed_type2
	when assessed_type1 similar to '(Strata Office - 1 To 10 Storey|Strata Lot - Parking Commercial|Strata Lot - Parking Residential)' and assessed_type2 ~~* 'Strata General Commercial'
		then assessed_type2
	when assessed_type1 ~~* '2 STY house - semicustom' and assessed_type2 ~~* '1 STY Duplex -  standard' 
		then assessed_type2
	when assessed_type1 ~~* 'Floating Marine Imprmnt' and assessed_type2 ~~* 'Retail Store'
		then assessed_type2
	when assessed_type1 ~~* 'Domestic Garage_2 Storey - Above Average Quality' and assessed_type2 ~~* '3 STY house - semicustom'
		then assessed_type2
	when assessed_type1 ~~* 'Paving - Asphalt' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* 'Wharf - Light Construction'
		then assessed_type2
	when assessed_type1 ~~* 'Vacant Residential Less Than 2 Acres' and assessed_type2 ~~* '1 1/2 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	else assessed_type1
	end
);
-- change field name and delete dup field
alter table property_details_temp7
	rename assessed_type1 to new_assessed_type;
alter table property_details_temp7
	drop column assessed_type2;

-- correct lot size
update property_details_temp7
	set lot_size1 = null
	where lot_size1 = '0';
update property_details_temp7
	set lot_size2 = null
	where lot_size2 = '0';
update property_details_temp7
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
alter table property_details_temp7
	rename lot_size1 to new_lot_size;
alter table property_details_temp7
	drop column lot_size2;

-- correct den
update property_details_temp7
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
alter table property_details_temp7
	rename den1 to new_den;
alter table property_details_temp7
	drop column den2;

-- correct normalized type
update property_details_temp7
	set normalized_type1 = null
	where normalized_type1 ilike 'Residential Attached';
update property_details_temp7
	set normalized_type2 = null
	where normalized_type2 ilike 'Residential Attached';
update property_details_temp7
	set normalized_type1 = 'Townhouse'
	where normalized_type1 ~~* 'twnhs';
update property_details_temp7
	set normalized_type2 = 'Townhouse'
	where normalized_type2 ~~* 'twnhs';
update property_details_temp7
	set normalized_type1 = 'Apartment Condo'
	where normalized_type1 ~~* 'apartment_condo';
update property_details_temp7
	set normalized_type2 = 'Apartment Condo'
	where normalized_type2 ~~* 'apartment_condo';
update property_details_temp7
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh|triplex|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily|land only|comprehensive development|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(land only|land_lot)' and lower(normalized_type2) similar to '(house|two family dwelling|duplex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu|dupxh|two family dwelling|apartment condo)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and lower(normalized_type2) similar to '(townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house|multiple family dwelling)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo|apartment condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'apartment condo' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'shared_owner' and lower(normalized_type2) similar to '(aptu|duplex|townhouse|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'recre' and lower(normalized_type2) similar to '(house|aptu|apartment condo|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'chalet' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mnfld' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when (normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'one family dwelling') or (normalized_type1 ~~* 'one family dwelling' and normalized_type2 ~~* 'two family dwelling')
		then 'Multi Family Dwelling'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(two family dwelling|one family dwelling)' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(duplex|3plex|triplex|fourplex|4plex)' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|one family dwelling|multifamily|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house|limited agricultural|two family dwelling|manuf|duplex|chalet|recre)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo|aptu|townhouse)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial|industrial|limited agricultural)' and lower(normalized_type2) similar to '(aptu|house|townhouse|apartment condo|comprehensive development|3plex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'light industrial' and normalized_type2 ~~* 'one family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'apartment condo' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|one family dwelling|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(manuf|mnfld)' and lower(normalized_type2) similar to '(mfd_mobile_home|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'timeshare' and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'other' and normalized_type2 is not null
		then initcap(normalized_type2)
	else initcap(normalized_type1)
	end
);
-- change field name and delete dup field
alter table property_details_temp7
	rename normalized_type1 to new_normalized_type;
alter table property_details_temp7
	drop column normalized_type2;

-- correct lot frontage
update property_details_temp7
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
alter table property_details_temp7
	rename lot_frontage1 to new_lot_frontage;
alter table property_details_temp7
	drop column lot_frontage2;

-- correct lot depth
update property_details_temp7
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
alter table property_details_temp7
	rename lot_depth1 to new_lot_depth;
alter table property_details_temp7
	drop column lot_depth2;


---------------------------------------------------------------------------------------------------------------------------------


-- create temporary table with unique values from Part 7
create table property_details_dup_fix7 as 
(select distinct dup_id, new_legal_type, new_strata_fee, new_property_tax, new_year_built, new_floor_area, new_bedroom, new_bathroom, new_assessed_type, new_lot_size, new_den, new_normalized_type, new_lot_frontage, new_lot_depth from property_details_temp7);
alter table property_details_dup_fix7 add column id serial;

-----------------------------------------------------------------------------------------------------------------------

-- PART 8
-- create table property_details_temp8 as join of new_properties_dup_id with itself
create table property_details_temp8 as
(select np1.dup_id, 
	np1.latitude as latitude1,
	np2.latitude as latitude2,
	np1.longitude as longitude1,
	np2.longitude as longitude2,
	np1.geocode_source as geocode_source1,
	np2.geocode_source as geocode_source2,
	np1.geocode_type as geocode_type1,
	np2.geocode_type as geocode_type2,
	np1.geocode_status as geocode_status1,
	np2.geocode_status as geocode_status2,
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

--correct latitude
update property_details_temp8
set latitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then latitude2
	when geocode_status1 is null and geocode_status2 is not null
		then latitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then latitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then latitude2
	else latitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp8
	rename latitude1 to new_latitude;
alter table property_details_temp8
	drop column latitude2;

--correct longitude
update property_details_temp8
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then longitude2
	when geocode_status1 is null and geocode_status2 is not null
		then longitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then longitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then longitude2
	else longitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp8
	rename longitude1 to new_longitude;
alter table property_details_temp8
	drop column longitude2;

--correct geocode_source
update property_details_temp8
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_source2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_source2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_source2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_source2
	else geocode_source1
	end
);
-- change change field name and delete dup field
alter table property_details_temp8
	rename geocode_source1 to new_geocode_source;
alter table property_details_temp8
	drop column geocode_source2;

--correct geocode_type
update property_details_temp8
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_type2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_type2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_type2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_type2
	else geocode_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp8
	rename geocode_type1 to new_geocode_type;
alter table property_details_temp8
	drop column geocode_type2;

--correct geocode_status
update property_details_temp8
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_status2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_status2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_status2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_status2
	else geocode_status1
	end
);
-- change change field name and delete dup field
alter table property_details_temp8
	rename geocode_status1 to new_geocode_status;
alter table property_details_temp8
	drop column geocode_status2;

-- correct legal_type
update property_details_temp8
set legal_type1 = (
	case when legal_type1 is null and legal_type2 is not null
		then legal_type2
	when legal_type1 ~~* 'land' and legal_type2 ~~* 'strata'
		then 'STRATA'
	else legal_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp8
	rename legal_type1 to new_legal_type;
alter table property_details_temp8
	drop column legal_type2;

-- correct strata fee
update property_details_temp8
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
alter table property_details_temp8
	rename strata_fee1 to new_strata_fee;
alter table property_details_temp8
	drop column strata_fee2;

-- correct property_tax
update property_details_temp8
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
alter table property_details_temp8
	rename property_tax1 to new_property_tax;
alter table property_details_temp8
	drop column property_tax2;
--
-- correct year built
update property_details_temp8
	set year_built1 = null
	where year_built1 > extract(year from current_date);
update property_details_temp8
	set year_built2 = null
	where year_built2 > extract(year from current_date);
update property_details_temp8
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
alter table property_details_temp8
	rename year_built1 to new_year_built;
alter table property_details_temp8
 	drop column year_built2;

-- correct floor area
update property_details_temp8
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
alter table property_details_temp8
	rename floor_area1 to new_floor_area;
alter table property_details_temp8
	drop column floor_area2;

-- correct bedrooms
update property_details_temp8
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
alter table property_details_temp8
	rename bedroom1 to new_bedroom;
alter table property_details_temp8
	drop column bedroom2;

-- correct bathrooms
update property_details_temp8
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
alter table property_details_temp8
	rename bathroom1 to new_bathroom;
alter table property_details_temp8
	drop column bathroom2;

-- correct assessed type
update property_details_temp8
set assessed_type1 = (
	case when assessed_type1 is null and assessed_type2 is not null
		then assessed_type2
	when assessed_type1 similar to '(Strata Office - 1 To 10 Storey|Strata Lot - Parking Commercial|Strata Lot - Parking Residential)' and assessed_type2 ~~* 'Strata General Commercial'
		then assessed_type2
	when assessed_type1 ~~* '2 STY house - semicustom' and assessed_type2 ~~* '1 STY Duplex -  standard' 
		then assessed_type2
	when assessed_type1 ~~* 'Floating Marine Imprmnt' and assessed_type2 ~~* 'Retail Store'
		then assessed_type2
	when assessed_type1 ~~* 'Domestic Garage_2 Storey - Above Average Quality' and assessed_type2 ~~* '3 STY house - semicustom'
		then assessed_type2
	when assessed_type1 ~~* 'Paving - Asphalt' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* 'Wharf - Light Construction'
		then assessed_type2
	when assessed_type1 ~~* 'Vacant Residential Less Than 2 Acres' and assessed_type2 ~~* '1 1/2 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	else assessed_type1
	end
);
-- change field name and delete dup field
alter table property_details_temp8
	rename assessed_type1 to new_assessed_type;
alter table property_details_temp8
	drop column assessed_type2;

-- correct lot size
update property_details_temp8
	set lot_size1 = null
	where lot_size1 = '0';
update property_details_temp8
	set lot_size2 = null
	where lot_size2 = '0';
update property_details_temp8
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
alter table property_details_temp8
	rename lot_size1 to new_lot_size;
alter table property_details_temp8
	drop column lot_size2;

-- correct den
update property_details_temp8
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
alter table property_details_temp8
	rename den1 to new_den;
alter table property_details_temp8
	drop column den2;

-- correct normalized type
update property_details_temp8
	set normalized_type1 = null
	where normalized_type1 ilike 'Residential Attached';
update property_details_temp8
	set normalized_type2 = null
	where normalized_type2 ilike 'Residential Attached';
update property_details_temp8
	set normalized_type1 = 'Townhouse'
	where normalized_type1 ~~* 'twnhs';
update property_details_temp8
	set normalized_type2 = 'Townhouse'
	where normalized_type2 ~~* 'twnhs';
update property_details_temp8
	set normalized_type1 = 'Apartment Condo'
	where normalized_type1 ~~* 'apartment_condo';
update property_details_temp8
	set normalized_type2 = 'Apartment Condo'
	where normalized_type2 ~~* 'apartment_condo';
update property_details_temp8
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh|triplex|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily|land only|comprehensive development|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(land only|land_lot)' and lower(normalized_type2) similar to '(house|two family dwelling|duplex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu|dupxh|two family dwelling|apartment condo)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and lower(normalized_type2) similar to '(townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house|multiple family dwelling)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo|apartment condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'apartment condo' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'shared_owner' and lower(normalized_type2) similar to '(aptu|duplex|townhouse|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'recre' and lower(normalized_type2) similar to '(house|aptu|apartment condo|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'chalet' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mnfld' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when (normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'one family dwelling') or (normalized_type1 ~~* 'one family dwelling' and normalized_type2 ~~* 'two family dwelling')
		then 'Multi Family Dwelling'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(two family dwelling|one family dwelling)' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(duplex|3plex|triplex|fourplex|4plex)' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|one family dwelling|multifamily|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house|limited agricultural|two family dwelling|manuf|duplex|chalet|recre)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo|aptu|townhouse)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial|industrial|limited agricultural)' and lower(normalized_type2) similar to '(aptu|house|townhouse|apartment condo|comprehensive development|3plex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'light industrial' and normalized_type2 ~~* 'one family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'apartment condo' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|one family dwelling|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(manuf|mnfld)' and lower(normalized_type2) similar to '(mfd_mobile_home|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'timeshare' and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'other' and normalized_type2 is not null
		then initcap(normalized_type2)
	else initcap(normalized_type1)
	end
);
-- change field name and delete dup field
alter table property_details_temp8
	rename normalized_type1 to new_normalized_type;
alter table property_details_temp8
	drop column normalized_type2;

-- correct lot frontage
update property_details_temp8
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
alter table property_details_temp8
	rename lot_frontage1 to new_lot_frontage;
alter table property_details_temp8
	drop column lot_frontage2;

-- correct lot depth
update property_details_temp8
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
alter table property_details_temp8
	rename lot_depth1 to new_lot_depth;
alter table property_details_temp8
	drop column lot_depth2;


---------------------------------------------------------------------------------------------------------------------------------


-- create temporary table with unique values from Part 8
create table property_details_dup_fix8 as 
(select distinct dup_id, new_legal_type, new_strata_fee, new_property_tax, new_year_built, new_floor_area, new_bedroom, new_bathroom, new_assessed_type, new_lot_size, new_den, new_normalized_type, new_lot_frontage, new_lot_depth from property_details_temp8);
alter table property_details_dup_fix8 add column id serial;

-----------------------------------------------------------------------------------------------------------------------

-- PART 9
-- create table property_details_temp8 as join of new_properties_dup_id with itself
create table property_details_temp9 as
(select np1.dup_id, 
	np1.latitude as latitude1,
	np2.latitude as latitude2,
	np1.longitude as longitude1,
	np2.longitude as longitude2,
	np1.geocode_source as geocode_source1,
	np2.geocode_source as geocode_source2,
	np1.geocode_type as geocode_type1,
	np2.geocode_type as geocode_type2,
	np1.geocode_status as geocode_status1,
	np2.geocode_status as geocode_status2,
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

--correct latitude
update property_details_temp9
set latitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then latitude2
	when geocode_status1 is null and geocode_status2 is not null
		then latitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then latitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then latitude2
	else latitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp9
	rename latitude1 to new_latitude;
alter table property_details_temp9
	drop column latitude2;

--correct longitude
update property_details_temp9
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then longitude2
	when geocode_status1 is null and geocode_status2 is not null
		then longitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then longitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then longitude2
	else longitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp9
	rename longitude1 to new_longitude;
alter table property_details_temp9
	drop column longitude2;

--correct geocode_source
update property_details_temp9
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_source2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_source2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_source2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_source2
	else geocode_source1
	end
);
-- change change field name and delete dup field
alter table property_details_temp9
	rename geocode_source1 to new_geocode_source;
alter table property_details_temp9
	drop column geocode_source2;

--correct geocode_type
update property_details_temp9
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_type2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_type2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_type2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_type2
	else geocode_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp9
	rename geocode_type1 to new_geocode_type;
alter table property_details_temp9
	drop column geocode_type2;

--correct geocode_status
update property_details_temp9
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_status2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_status2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_status2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_status2
	else geocode_status1
	end
);
-- change change field name and delete dup field
alter table property_details_temp9
	rename geocode_status1 to new_geocode_status;
alter table property_details_temp9
	drop column geocode_status2;

-- correct legal_type
update property_details_temp9
set legal_type1 = (
	case when legal_type1 is null and legal_type2 is not null
		then legal_type2
	when legal_type1 ~~* 'land' and legal_type2 ~~* 'strata'
		then 'STRATA'
	else legal_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp9
	rename legal_type1 to new_legal_type;
alter table property_details_temp9
	drop column legal_type2;

-- correct strata fee
update property_details_temp9
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
alter table property_details_temp9
	rename strata_fee1 to new_strata_fee;
alter table property_details_temp9
	drop column strata_fee2;

-- correct property_tax
update property_details_temp9
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
alter table property_details_temp9
	rename property_tax1 to new_property_tax;
alter table property_details_temp9
	drop column property_tax2;
--
-- correct year built
update property_details_temp9
	set year_built1 = null
	where year_built1 > extract(year from current_date);
update property_details_temp9
	set year_built2 = null
	where year_built2 > extract(year from current_date);
update property_details_temp9
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
alter table property_details_temp9
	rename year_built1 to new_year_built;
alter table property_details_temp9
 	drop column year_built2;

-- correct floor area
update property_details_temp9
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
alter table property_details_temp9
	rename floor_area1 to new_floor_area;
alter table property_details_temp9
	drop column floor_area2;

-- correct bedrooms
update property_details_temp9
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
alter table property_details_temp9
	rename bedroom1 to new_bedroom;
alter table property_details_temp9
	drop column bedroom2;

-- correct bathrooms
update property_details_temp9
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
alter table property_details_temp9
	rename bathroom1 to new_bathroom;
alter table property_details_temp9
	drop column bathroom2;

-- correct assessed type
update property_details_temp9
set assessed_type1 = (
	case when assessed_type1 is null and assessed_type2 is not null
		then assessed_type2
	when assessed_type1 similar to '(Strata Office - 1 To 10 Storey|Strata Lot - Parking Commercial|Strata Lot - Parking Residential)' and assessed_type2 ~~* 'Strata General Commercial'
		then assessed_type2
	when assessed_type1 ~~* '2 STY house - semicustom' and assessed_type2 ~~* '1 STY Duplex -  standard' 
		then assessed_type2
	when assessed_type1 ~~* 'Floating Marine Imprmnt' and assessed_type2 ~~* 'Retail Store'
		then assessed_type2
	when assessed_type1 ~~* 'Domestic Garage_2 Storey - Above Average Quality' and assessed_type2 ~~* '3 STY house - semicustom'
		then assessed_type2
	when assessed_type1 ~~* 'Paving - Asphalt' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* 'Wharf - Light Construction'
		then assessed_type2
	when assessed_type1 ~~* 'Vacant Residential Less Than 2 Acres' and assessed_type2 ~~* '1 1/2 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	else assessed_type1
	end
);
-- change field name and delete dup field
alter table property_details_temp9
	rename assessed_type1 to new_assessed_type;
alter table property_details_temp9
	drop column assessed_type2;

-- correct lot size
update property_details_temp9
	set lot_size1 = null
	where lot_size1 = '0';
update property_details_temp9
	set lot_size2 = null
	where lot_size2 = '0';
update property_details_temp9
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
alter table property_details_temp9
	rename lot_size1 to new_lot_size;
alter table property_details_temp9
	drop column lot_size2;

-- correct den
update property_details_temp9
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
alter table property_details_temp9
	rename den1 to new_den;
alter table property_details_temp9
	drop column den2;

-- correct normalized type
update property_details_temp9
	set normalized_type1 = null
	where normalized_type1 ilike 'Residential Attached';
update property_details_temp9
	set normalized_type2 = null
	where normalized_type2 ilike 'Residential Attached';
update property_details_temp9
	set normalized_type1 = 'Townhouse'
	where normalized_type1 ~~* 'twnhs';
update property_details_temp9
	set normalized_type2 = 'Townhouse'
	where normalized_type2 ~~* 'twnhs';
update property_details_temp9
	set normalized_type1 = 'Apartment Condo'
	where normalized_type1 ~~* 'apartment_condo';
update property_details_temp9
	set normalized_type2 = 'Apartment Condo'
	where normalized_type2 ~~* 'apartment_condo';
update property_details_temp9
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh|triplex|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily|land only|comprehensive development|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(land only|land_lot)' and lower(normalized_type2) similar to '(house|two family dwelling|duplex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu|dupxh|two family dwelling|apartment condo)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and lower(normalized_type2) similar to '(townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house|multiple family dwelling)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo|apartment condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'apartment condo' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'shared_owner' and lower(normalized_type2) similar to '(aptu|duplex|townhouse|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'recre' and lower(normalized_type2) similar to '(house|aptu|apartment condo|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'chalet' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mnfld' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when (normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'one family dwelling') or (normalized_type1 ~~* 'one family dwelling' and normalized_type2 ~~* 'two family dwelling')
		then 'Multi Family Dwelling'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(two family dwelling|one family dwelling)' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(duplex|3plex|triplex|fourplex|4plex)' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|one family dwelling|multifamily|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house|limited agricultural|two family dwelling|manuf|duplex|chalet|recre)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo|aptu|townhouse)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial|industrial|limited agricultural)' and lower(normalized_type2) similar to '(aptu|house|townhouse|apartment condo|comprehensive development|3plex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'light industrial' and normalized_type2 ~~* 'one family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'apartment condo' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|one family dwelling|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(manuf|mnfld)' and lower(normalized_type2) similar to '(mfd_mobile_home|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'timeshare' and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'other' and normalized_type2 is not null
		then initcap(normalized_type2)
	else initcap(normalized_type1)
	end
);
-- change field name and delete dup field
alter table property_details_temp9
	rename normalized_type1 to new_normalized_type;
alter table property_details_temp9
	drop column normalized_type2;

-- correct lot frontage
update property_details_temp9
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
alter table property_details_temp9
	rename lot_frontage1 to new_lot_frontage;
alter table property_details_temp9
	drop column lot_frontage2;

-- correct lot depth
update property_details_temp9
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
alter table property_details_temp9
	rename lot_depth1 to new_lot_depth;
alter table property_details_temp9
	drop column lot_depth2;




---------------------------------------------------------------------------------------------------------------------------------


-- create temporary table with unique values from Part 9
create table property_details_dup_fix9 as 
(select distinct dup_id, new_legal_type, new_strata_fee, new_property_tax, new_year_built, new_floor_area, new_bedroom, new_bathroom, new_assessed_type, new_lot_size, new_den, new_normalized_type, new_lot_frontage, new_lot_depth from property_details_temp9);
alter table property_details_dup_fix9 add column id serial;

-----------------------------------------------------------------------------------------------------------------------

-- PART 10
-- create table property_details_temp10 as join of new_properties_dup_id with itself
create table property_details_temp10 as
(select np1.dup_id, 
	np1.latitude as latitude1,
	np2.latitude as latitude2,
	np1.longitude as longitude1,
	np2.longitude as longitude2,
	np1.geocode_source as geocode_source1,
	np2.geocode_source as geocode_source2,
	np1.geocode_type as geocode_type1,
	np2.geocode_type as geocode_type2,
	np1.geocode_status as geocode_status1,
	np2.geocode_status as geocode_status2,
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

--correct latitude
update property_details_temp10
set latitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then latitude2
	when geocode_status1 is null and geocode_status2 is not null
		then latitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then latitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then latitude2
	else latitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp10
	rename latitude1 to new_latitude;
alter table property_details_temp10
	drop column latitude2;

--correct longitude
update property_details_temp10
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then longitude2
	when geocode_status1 is null and geocode_status2 is not null
		then longitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then longitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then longitude2
	else longitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp10
	rename longitude1 to new_longitude;
alter table property_details_temp10
	drop column longitude2;

--correct geocode_source
update property_details_temp10
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_source2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_source2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_source2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_source2
	else geocode_source1
	end
);
-- change change field name and delete dup field
alter table property_details_temp10
	rename geocode_source1 to new_geocode_source;
alter table property_details_temp10
	drop column geocode_source2;

--correct geocode_type
update property_details_temp10
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_type2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_type2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_type2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_type2
	else geocode_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp10
	rename geocode_type1 to new_geocode_type;
alter table property_details_temp10
	drop column geocode_type2;

--correct geocode_status
update property_details_temp10
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_status2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_status2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_status2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_status2
	else geocode_status1
	end
);
-- change change field name and delete dup field
alter table property_details_temp10
	rename geocode_status1 to new_geocode_status;
alter table property_details_temp10
	drop column geocode_status2;

-- correct legal_type
update property_details_temp10
set legal_type1 = (
	case when legal_type1 is null and legal_type2 is not null
		then legal_type2
	when legal_type1 ~~* 'land' and legal_type2 ~~* 'strata'
		then 'STRATA'
	else legal_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp10
	rename legal_type1 to new_legal_type;
alter table property_details_temp10
	drop column legal_type2;

-- correct strata fee
update property_details_temp10
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
alter table property_details_temp10
	rename strata_fee1 to new_strata_fee;
alter table property_details_temp10
	drop column strata_fee2;

-- correct property_tax
update property_details_temp10
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
alter table property_details_temp10
	rename property_tax1 to new_property_tax;
alter table property_details_temp10
	drop column property_tax2;
--
-- correct year built
update property_details_temp10
	set year_built1 = null
	where year_built1 > extract(year from current_date);
update property_details_temp10
	set year_built2 = null
	where year_built2 > extract(year from current_date);
update property_details_temp10
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
alter table property_details_temp10
	rename year_built1 to new_year_built;
alter table property_details_temp10
 	drop column year_built2;

-- correct floor area
update property_details_temp10
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
alter table property_details_temp10
	rename floor_area1 to new_floor_area;
alter table property_details_temp10
	drop column floor_area2;

-- correct bedrooms
update property_details_temp10
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
alter table property_details_temp10
	rename bedroom1 to new_bedroom;
alter table property_details_temp10
	drop column bedroom2;

-- correct bathrooms
update property_details_temp10
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
alter table property_details_temp10
	rename bathroom1 to new_bathroom;
alter table property_details_temp10
	drop column bathroom2;

-- correct assessed type
update property_details_temp10
set assessed_type1 = (
	case when assessed_type1 is null and assessed_type2 is not null
		then assessed_type2
	when assessed_type1 similar to '(Strata Office - 1 To 10 Storey|Strata Lot - Parking Commercial|Strata Lot - Parking Residential)' and assessed_type2 ~~* 'Strata General Commercial'
		then assessed_type2
	when assessed_type1 ~~* '2 STY house - semicustom' and assessed_type2 ~~* '1 STY Duplex -  standard' 
		then assessed_type2
	when assessed_type1 ~~* 'Floating Marine Imprmnt' and assessed_type2 ~~* 'Retail Store'
		then assessed_type2
	when assessed_type1 ~~* 'Domestic Garage_2 Storey - Above Average Quality' and assessed_type2 ~~* '3 STY house - semicustom'
		then assessed_type2
	when assessed_type1 ~~* 'Paving - Asphalt' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* 'Wharf - Light Construction'
		then assessed_type2
	when assessed_type1 ~~* 'Vacant Residential Less Than 2 Acres' and assessed_type2 ~~* '1 1/2 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	else assessed_type1
	end
);
-- change field name and delete dup field
alter table property_details_temp10
	rename assessed_type1 to new_assessed_type;
alter table property_details_temp10
	drop column assessed_type2;

-- correct lot size
update property_details_temp10
	set lot_size1 = null
	where lot_size1 = '0';
update property_details_temp10
	set lot_size2 = null
	where lot_size2 = '0';
update property_details_temp10
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
alter table property_details_temp10
	rename lot_size1 to new_lot_size;
alter table property_details_temp10
	drop column lot_size2;

-- correct den
update property_details_temp10
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
alter table property_details_temp10
	rename den1 to new_den;
alter table property_details_temp10
	drop column den2;

-- correct normalized type
update property_details_temp10
	set normalized_type1 = null
	where normalized_type1 ilike 'Residential Attached';
update property_details_temp10
	set normalized_type2 = null
	where normalized_type2 ilike 'Residential Attached';
update property_details_temp10
	set normalized_type1 = 'Townhouse'
	where normalized_type1 ~~* 'twnhs';
update property_details_temp10
	set normalized_type2 = 'Townhouse'
	where normalized_type2 ~~* 'twnhs';
update property_details_temp10
	set normalized_type1 = 'Apartment Condo'
	where normalized_type1 ~~* 'apartment_condo';
update property_details_temp10
	set normalized_type2 = 'Apartment Condo'
	where normalized_type2 ~~* 'apartment_condo';
update property_details_temp10
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh|triplex|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily|land only|comprehensive development|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(land only|land_lot)' and lower(normalized_type2) similar to '(house|two family dwelling|duplex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu|dupxh|two family dwelling|apartment condo)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and lower(normalized_type2) similar to '(townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house|multiple family dwelling)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo|apartment condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'apartment condo' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'shared_owner' and lower(normalized_type2) similar to '(aptu|duplex|townhouse|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'recre' and lower(normalized_type2) similar to '(house|aptu|apartment condo|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'chalet' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mnfld' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when (normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'one family dwelling') or (normalized_type1 ~~* 'one family dwelling' and normalized_type2 ~~* 'two family dwelling')
		then 'Multi Family Dwelling'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(two family dwelling|one family dwelling)' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(duplex|3plex|triplex|fourplex|4plex)' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|one family dwelling|multifamily|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house|limited agricultural|two family dwelling|manuf|duplex|chalet|recre)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo|aptu|townhouse)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial|industrial|limited agricultural)' and lower(normalized_type2) similar to '(aptu|house|townhouse|apartment condo|comprehensive development|3plex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'light industrial' and normalized_type2 ~~* 'one family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'apartment condo' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|one family dwelling|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(manuf|mnfld)' and lower(normalized_type2) similar to '(mfd_mobile_home|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'timeshare' and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'other' and normalized_type2 is not null
		then initcap(normalized_type2)
	else initcap(normalized_type1)
	end
);
-- change field name and delete dup field
alter table property_details_temp10
	rename normalized_type1 to new_normalized_type;
alter table property_details_temp10
	drop column normalized_type2;

-- correct lot frontage
update property_details_temp10
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
alter table property_details_temp10
	rename lot_frontage1 to new_lot_frontage;
alter table property_details_temp10
	drop column lot_frontage2;

-- correct lot depth
update property_details_temp10
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
alter table property_details_temp10
	rename lot_depth1 to new_lot_depth;
alter table property_details_temp10
	drop column lot_depth2;



---------------------------------------------------------------------------------------------------------------------------------


-- create temporary table with unique values from Part 10
create table property_details_dup_fix10 as 
(select distinct dup_id, new_legal_type, new_strata_fee, new_property_tax, new_year_built, new_floor_area, new_bedroom, new_bathroom, new_assessed_type, new_lot_size, new_den, new_normalized_type, new_lot_frontage, new_lot_depth from property_details_temp10);
alter table property_details_dup_fix10 add column id serial;

-----------------------------------------------------------------------------------------------------------------------

-- PART 11
-- create table property_details_temp11 as join of new_properties_dup_id with itself
create table property_details_temp11 as
(select np1.dup_id, 
	np1.latitude as latitude1,
	np2.latitude as latitude2,
	np1.longitude as longitude1,
	np2.longitude as longitude2,
	np1.geocode_source as geocode_source1,
	np2.geocode_source as geocode_source2,
	np1.geocode_type as geocode_type1,
	np2.geocode_type as geocode_type2,
	np1.geocode_status as geocode_status1,
	np2.geocode_status as geocode_status2,
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

--correct latitude
update property_details_temp11
set latitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then latitude2
	when geocode_status1 is null and geocode_status2 is not null
		then latitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then latitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then latitude2
	else latitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp11
	rename latitude1 to new_latitude;
alter table property_details_temp11
	drop column latitude2;

--correct longitude
update property_details_temp11
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then longitude2
	when geocode_status1 is null and geocode_status2 is not null
		then longitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then longitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then longitude2
	else longitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp11
	rename longitude1 to new_longitude;
alter table property_details_temp11
	drop column longitude2;

--correct geocode_source
update property_details_temp11
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_source2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_source2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_source2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_source2
	else geocode_source1
	end
);
-- change change field name and delete dup field
alter table property_details_temp11
	rename geocode_source1 to new_geocode_source;
alter table property_details_temp11
	drop column geocode_source2;

--correct geocode_type
update property_details_temp11
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_type2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_type2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_type2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_type2
	else geocode_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp11
	rename geocode_type1 to new_geocode_type;
alter table property_details_temp11
	drop column geocode_type2;

--correct geocode_status
update property_details_temp11
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_status2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_status2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_status2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_status2
	else geocode_status1
	end
);
-- change change field name and delete dup field
alter table property_details_temp11
	rename geocode_status1 to new_geocode_status;
alter table property_details_temp11
	drop column geocode_status2;

-- correct legal_type
update property_details_temp11
set legal_type1 = (
	case when legal_type1 is null and legal_type2 is not null
		then legal_type2
	when legal_type1 ~~* 'land' and legal_type2 ~~* 'strata'
		then 'STRATA'
	else legal_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp11
	rename legal_type1 to new_legal_type;
alter table property_details_temp11
	drop column legal_type2;

-- correct strata fee
update property_details_temp11
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
alter table property_details_temp11
	rename strata_fee1 to new_strata_fee;
alter table property_details_temp11
	drop column strata_fee2;

-- correct property_tax
update property_details_temp11
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
alter table property_details_temp11
	rename property_tax1 to new_property_tax;
alter table property_details_temp11
	drop column property_tax2;
--
-- correct year built
update property_details_temp11
	set year_built1 = null
	where year_built1 > extract(year from current_date);
update property_details_temp11
	set year_built2 = null
	where year_built2 > extract(year from current_date);
update property_details_temp11
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
alter table property_details_temp11
	rename year_built1 to new_year_built;
alter table property_details_temp11
 	drop column year_built2;

-- correct floor area
update property_details_temp11
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
alter table property_details_temp11
	rename floor_area1 to new_floor_area;
alter table property_details_temp11
	drop column floor_area2;

-- correct bedrooms
update property_details_temp11
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
alter table property_details_temp11
	rename bedroom1 to new_bedroom;
alter table property_details_temp11
	drop column bedroom2;

-- correct bathrooms
update property_details_temp11
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
alter table property_details_temp11
	rename bathroom1 to new_bathroom;
alter table property_details_temp11
	drop column bathroom2;

-- correct assessed type
update property_details_temp11
set assessed_type1 = (
	case when assessed_type1 is null and assessed_type2 is not null
		then assessed_type2
	when assessed_type1 similar to '(Strata Office - 1 To 10 Storey|Strata Lot - Parking Commercial|Strata Lot - Parking Residential)' and assessed_type2 ~~* 'Strata General Commercial'
		then assessed_type2
	when assessed_type1 ~~* '2 STY house - semicustom' and assessed_type2 ~~* '1 STY Duplex -  standard' 
		then assessed_type2
	when assessed_type1 ~~* 'Floating Marine Imprmnt' and assessed_type2 ~~* 'Retail Store'
		then assessed_type2
	when assessed_type1 ~~* 'Domestic Garage_2 Storey - Above Average Quality' and assessed_type2 ~~* '3 STY house - semicustom'
		then assessed_type2
	when assessed_type1 ~~* 'Paving - Asphalt' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* 'Wharf - Light Construction'
		then assessed_type2
	when assessed_type1 ~~* 'Vacant Residential Less Than 2 Acres' and assessed_type2 ~~* '1 1/2 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	else assessed_type1
	end
);
-- change field name and delete dup field
alter table property_details_temp11
	rename assessed_type1 to new_assessed_type;
alter table property_details_temp11
	drop column assessed_type2;

-- correct lot size
update property_details_temp11
	set lot_size1 = null
	where lot_size1 = '0';
update property_details_temp11
	set lot_size2 = null
	where lot_size2 = '0';
update property_details_temp11
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
alter table property_details_temp11
	rename lot_size1 to new_lot_size;
alter table property_details_temp11
	drop column lot_size2;

-- correct den
update property_details_temp11
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
alter table property_details_temp11
	rename den1 to new_den;
alter table property_details_temp11
	drop column den2;

-- correct normalized type
update property_details_temp11
	set normalized_type1 = null
	where normalized_type1 ilike 'Residential Attached';
update property_details_temp11
	set normalized_type2 = null
	where normalized_type2 ilike 'Residential Attached';
update property_details_temp11
	set normalized_type1 = 'Townhouse'
	where normalized_type1 ~~* 'twnhs';
update property_details_temp11
	set normalized_type2 = 'Townhouse'
	where normalized_type2 ~~* 'twnhs';
update property_details_temp11
	set normalized_type1 = 'Apartment Condo'
	where normalized_type1 ~~* 'apartment_condo';
update property_details_temp11
	set normalized_type2 = 'Apartment Condo'
	where normalized_type2 ~~* 'apartment_condo';
update property_details_temp11
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh|triplex|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily|land only|comprehensive development|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(land only|land_lot)' and lower(normalized_type2) similar to '(house|two family dwelling|duplex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu|dupxh|two family dwelling|apartment condo)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and lower(normalized_type2) similar to '(townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house|multiple family dwelling)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo|apartment condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'apartment condo' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'shared_owner' and lower(normalized_type2) similar to '(aptu|duplex|townhouse|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'recre' and lower(normalized_type2) similar to '(house|aptu|apartment condo|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'chalet' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mnfld' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when (normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'one family dwelling') or (normalized_type1 ~~* 'one family dwelling' and normalized_type2 ~~* 'two family dwelling')
		then 'Multi Family Dwelling'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(two family dwelling|one family dwelling)' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(duplex|3plex|triplex|fourplex|4plex)' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|one family dwelling|multifamily|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house|limited agricultural|two family dwelling|manuf|duplex|chalet|recre)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo|aptu|townhouse)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial|industrial|limited agricultural)' and lower(normalized_type2) similar to '(aptu|house|townhouse|apartment condo|comprehensive development|3plex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'light industrial' and normalized_type2 ~~* 'one family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'apartment condo' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|one family dwelling|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(manuf|mnfld)' and lower(normalized_type2) similar to '(mfd_mobile_home|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'timeshare' and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'other' and normalized_type2 is not null
		then initcap(normalized_type2)
	else initcap(normalized_type1)
	end
);
-- change field name and delete dup field
alter table property_details_temp11
	rename normalized_type1 to new_normalized_type;
alter table property_details_temp11
	drop column normalized_type2;

-- correct lot frontage
update property_details_temp11
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
alter table property_details_temp11
	rename lot_frontage1 to new_lot_frontage;
alter table property_details_temp11
	drop column lot_frontage2;

-- correct lot depth
update property_details_temp11
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
alter table property_details_temp11
	rename lot_depth1 to new_lot_depth;
alter table property_details_temp11
	drop column lot_depth2;




---------------------------------------------------------------------------------------------------------------------------------


-- create temporary table with unique values from Part 11
create table property_details_dup_fix11 as 
(select distinct dup_id, new_legal_type, new_strata_fee, new_property_tax, new_year_built, new_floor_area, new_bedroom, new_bathroom, new_assessed_type, new_lot_size, new_den, new_normalized_type, new_lot_frontage, new_lot_depth from property_details_temp11);
alter table property_details_dup_fix11 add column id serial;

-----------------------------------------------------------------------------------------------------------------------

-- PART 12
-- create table property_details_temp12 as join of new_properties_dup_id with itself
create table property_details_temp12 as
(select np1.dup_id, 
	np1.latitude as latitude1,
	np2.latitude as latitude2,
	np1.longitude as longitude1,
	np2.longitude as longitude2,
	np1.geocode_source as geocode_source1,
	np2.geocode_source as geocode_source2,
	np1.geocode_type as geocode_type1,
	np2.geocode_type as geocode_type2,
	np1.geocode_status as geocode_status1,
	np2.geocode_status as geocode_status2,
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

--correct latitude
update property_details_temp12
set latitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then latitude2
	when geocode_status1 is null and geocode_status2 is not null
		then latitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then latitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then latitude2
	else latitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp12
	rename latitude1 to new_latitude;
alter table property_details_temp12
	drop column latitude2;

--correct longitude
update property_details_temp12
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then longitude2
	when geocode_status1 is null and geocode_status2 is not null
		then longitude2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then longitude2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then longitude2
	else longitude1
	end
);
-- change change field name and delete dup field
alter table property_details_temp12
	rename longitude1 to new_longitude;
alter table property_details_temp12
	drop column longitude2;

--correct geocode_source
update property_details_temp12
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_source2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_source2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_source2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_source2
	else geocode_source1
	end
);
-- change change field name and delete dup field
alter table property_details_temp12
	rename geocode_source1 to new_geocode_source;
alter table property_details_temp12
	drop column geocode_source2;

--correct geocode_type
update property_details_temp12
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_type2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_type2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_type2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_type2
	else geocode_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp12
	rename geocode_type1 to new_geocode_type;
alter table property_details_temp12
	drop column geocode_type2;

--correct geocode_status
update property_details_temp12
set longitude1 = (
	case when geocode_status1 ~~ 'FAILED' and geocode_status2 ~~ 'SUCCESS'
		then geocode_status2
	when geocode_status1 is null and geocode_status2 is not null
		then geocode_status2
	when geocode_source1 ~~* 'google' and geocode_source2 similar to '(Vancouver Open Data|PropertyInsight)'
		then geocode_status2
	when geocode_source1 ~~* 'Vancouver Open Data' and geocode_source2 ~~* 'PropertyInsight'
		then geocode_status2
	else geocode_status1
	end
);
-- change change field name and delete dup field
alter table property_details_temp12
	rename geocode_status1 to new_geocode_status;
alter table property_details_temp12
	drop column geocode_status2;

-- correct legal_type
update property_details_temp12
set legal_type1 = (
	case when legal_type1 is null and legal_type2 is not null
		then legal_type2
	when legal_type1 ~~* 'land' and legal_type2 ~~* 'strata'
		then 'STRATA'
	else legal_type1
	end
);
-- change change field name and delete dup field
alter table property_details_temp12
	rename legal_type1 to new_legal_type;
alter table property_details_temp12
	drop column legal_type2;

-- correct strata fee
update property_details_temp12
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
alter table property_details_temp12
	rename strata_fee1 to new_strata_fee;
alter table property_details_temp12
	drop column strata_fee2;

-- correct property_tax
update property_details_temp12
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
alter table property_details_temp12
	rename property_tax1 to new_property_tax;
alter table property_details_temp12
	drop column property_tax2;

-- correct year built
update property_details_temp12
	set year_built1 = null
	where year_built1 > extract(year from current_date);
update property_details_temp12
	set year_built2 = null
	where year_built2 > extract(year from current_date);
update property_details_temp12
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
alter table property_details_temp12
	rename year_built1 to new_year_built;
alter table property_details_temp12
 	drop column year_built2;

-- correct floor area
update property_details_temp12
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
alter table property_details_temp12
	rename floor_area1 to new_floor_area;
alter table property_details_temp12
	drop column floor_area2;

-- correct bedrooms
update property_details_temp12
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
alter table property_details_temp12
	rename bedroom1 to new_bedroom;
alter table property_details_temp12
	drop column bedroom2;

-- correct bathrooms
update property_details_temp12
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
alter table property_details_temp12
	rename bathroom1 to new_bathroom;
alter table property_details_temp12
	drop column bathroom2;

-- correct assessed type
update property_details_temp12
set assessed_type1 = (
	case when assessed_type1 is null and assessed_type2 is not null
		then assessed_type2
	when assessed_type1 similar to '(Strata Office - 1 To 10 Storey|Strata Lot - Parking Commercial|Strata Lot - Parking Residential)' and assessed_type2 ~~* 'Strata General Commercial'
		then assessed_type2
	when assessed_type1 ~~* '2 STY house - semicustom' and assessed_type2 ~~* '1 STY Duplex -  standard' 
		then assessed_type2
	when assessed_type1 ~~* 'Floating Marine Imprmnt' and assessed_type2 ~~* 'Retail Store'
		then assessed_type2
	when assessed_type1 ~~* 'Domestic Garage_2 Storey - Above Average Quality' and assessed_type2 ~~* '3 STY house - semicustom'
		then assessed_type2
	when assessed_type1 ~~* 'Paving - Asphalt' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* 'Wharf - Light Construction'
		then assessed_type2
	when assessed_type1 ~~* 'Vacant Residential Less Than 2 Acres' and assessed_type2 ~~* '1 1/2 STY house -  basic'
		then assessed_type2
	when assessed_type1 ~~* 'Gen Purpose Shed & Outbldg - Lower Qlty' and assessed_type2 ~~* '1 STY house -  basic'
		then assessed_type2
	else assessed_type1
	end
);
-- change field name and delete dup field
alter table property_details_temp12
	rename assessed_type1 to new_assessed_type;
alter table property_details_temp12
	drop column assessed_type2;

-- correct lot size
update property_details_temp12
	set lot_size1 = null
	where lot_size1 = '0';
update property_details_temp12
	set lot_size2 = null
	where lot_size2 = '0';
update property_details_temp12
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
alter table property_details_temp12
	rename lot_size1 to new_lot_size;
alter table property_details_temp12
	drop column lot_size2;

-- correct den
update property_details_temp12
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
alter table property_details_temp12
	rename den1 to new_den;
alter table property_details_temp12
	drop column den2;

-- correct normalized type
update property_details_temp12
	set normalized_type1 = null
	where normalized_type1 ilike 'Residential Attached';
update property_details_temp12
	set normalized_type2 = null
	where normalized_type2 ilike 'Residential Attached';
update property_details_temp12
	set normalized_type1 = 'Townhouse'
	where normalized_type1 ~~* 'twnhs';
update property_details_temp12
	set normalized_type2 = 'Townhouse'
	where normalized_type2 ~~* 'twnhs';
update property_details_temp12
	set normalized_type1 = 'Apartment Condo'
	where normalized_type1 ~~* 'apartment_condo';
update property_details_temp12
	set normalized_type2 = 'Apartment Condo'
	where normalized_type2 ~~* 'apartment_condo';
update property_details_temp12
set normalized_type1 = (
	case when normalized_type1 is null and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'house' and lower(normalized_type2) similar to '(one family dwelling|two family dwelling|multiple family dwelling|comprehensive development|duplex|dupxh|triplex|multifamily)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(dupxh|duplx|duplex)' and lower(normalized_type2) similar to '(multi family dwelling|multiple family dwelling|two family dwelling|one family dwelling|multifamily|land only|comprehensive development|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(land only|land_lot)' and lower(normalized_type2) similar to '(house|two family dwelling|duplex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'comprehensive development' and lower(normalized_type2) similar to '(townhouse|multiple family dwelling|aptu|dupxh|two family dwelling|apartment condo)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(multiple family dwelling|commercial|two family dwelling)' and lower(normalized_type2) similar to '(townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'land_lot' and lower(normalized_type2) similar to '(land only|house|multiple family dwelling)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(aptu|apartment_condo|apartment condo)' and lower(normalized_type2) similar to '(apartment_condo|apartment condo)'
		then 'Apartment Condo'
	when normalized_type1 ~~* 'apartment condo' and normalized_type2 ~~* 'townhouse'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'shared_owner' and lower(normalized_type2) similar to '(aptu|duplex|townhouse|apartment condo)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'recre' and lower(normalized_type2) similar to '(house|aptu|apartment condo|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'chalet' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mnfld' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when (normalized_type1 ~~* 'two family dwelling' and normalized_type2 ~~* 'one family dwelling') or (normalized_type1 ~~* 'one family dwelling' and normalized_type2 ~~* 'two family dwelling')
		then 'Multi Family Dwelling'
	when normalized_type1 ~~* 'townhouse' and lower(normalized_type2) similar to '(house|one family dwelling)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'mfd_mobile_home' and normalized_type2 ~~* 'house'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(two family dwelling|one family dwelling)' and normalized_type2 ~~* 'multiple family dwelling'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(duplex|3plex|triplex|fourplex|4plex)' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|one family dwelling|multifamily|townhouse)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'hacr' and lower(normalized_type2) similar to '(one family dwelling|land_lot|house|limited agricultural|two family dwelling|manuf|duplex|chalet|recre)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'historic area' and lower(normalized_type2) similar to '(apartment_condo|apartment condo|aptu|townhouse)'
		then 'Apartment Condo'
	when lower(normalized_type1) similar to '(light industrial|commercial|industrial|limited agricultural)' and lower(normalized_type2) similar to '(aptu|house|townhouse|apartment condo|comprehensive development|3plex)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'light industrial' and normalized_type2 ~~* 'one family dwelling'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'apartment condo' and lower(normalized_type2) similar to '(two family dwelling|multiple family dwelling|apartment condo|one family dwelling|townhouse)'
		then initcap(normalized_type2)
	when lower(normalized_type1) similar to '(manuf|mnfld)' and lower(normalized_type2) similar to '(mfd_mobile_home|house)'
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'timeshare' and normalized_type2 is not null
		then initcap(normalized_type2)
	when normalized_type1 ~~* 'other' and normalized_type2 is not null
		then initcap(normalized_type2)
	else initcap(normalized_type1)
	end
);
-- change field name and delete dup field
alter table property_details_temp12
	rename normalized_type1 to new_normalized_type;
alter table property_details_temp12
	drop column normalized_type2;

-- correct lot frontage
update property_details_temp12
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
alter table property_details_temp12
	rename lot_frontage1 to new_lot_frontage;
alter table property_details_temp12
	drop column lot_frontage2;

-- correct lot depth
update property_details_temp12
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
alter table property_details_temp12
	rename lot_depth1 to new_lot_depth;
alter table property_details_temp12
	drop column lot_depth2;


create table property_details_dup_fix12 as select distinct * from property_details_temp12;
alter table property_details_dup_fix12 add column id serial;

---------------------------------------------------------------------------------------------------------------------------------


-- PART 13
-- Create property_details table

delete from property_details_dup_fix1 where dup_id in (with temp_details as(select dup_id, count(dup_id) from property_details_dup_fix1 group by dup_id) select dup_id from temp_details where count >= 2);
delete from property_details_dup_fix2 where dup_id in (with temp_details as(select dup_id, count(dup_id) from property_details_dup_fix2 group by dup_id) select dup_id from temp_details where count >= 2);
delete from property_details_dup_fix3 where dup_id in (with temp_details as(select dup_id, count(dup_id) from property_details_dup_fix3 group by dup_id) select dup_id from temp_details where count >= 2);
delete from property_details_dup_fix4 where dup_id in (with temp_details as(select dup_id, count(dup_id) from property_details_dup_fix4 group by dup_id) select dup_id from temp_details where count >= 2);
delete from property_details_dup_fix5 where dup_id in (with temp_details as(select dup_id, count(dup_id) from property_details_dup_fix5 group by dup_id) select dup_id from temp_details where count >= 2);
delete from property_details_dup_fix6 where dup_id in (with temp_details as(select dup_id, count(dup_id) from property_details_dup_fix6 group by dup_id) select dup_id from temp_details where count >= 2);
delete from property_details_dup_fix7 where dup_id in (with temp_details as(select dup_id, count(dup_id) from property_details_dup_fix7 group by dup_id) select dup_id from temp_details where count >= 2);
delete from property_details_dup_fix8 where dup_id in (with temp_details as(select dup_id, count(dup_id) from property_details_dup_fix8 group by dup_id) select dup_id from temp_details where count >= 2);
delete from property_details_dup_fix9 where dup_id in (with temp_details as(select dup_id, count(dup_id) from property_details_dup_fix9 group by dup_id) select dup_id from temp_details where count >= 2);
delete from property_details_dup_fix10 where dup_id in (with temp_details as(select dup_id, count(dup_id) from property_details_dup_fix10 group by dup_id) select dup_id from temp_details where count >= 2);
delete from property_details_dup_fix11 where dup_id in (with temp_details as(select dup_id, count(dup_id) from property_details_dup_fix11 group by dup_id) select dup_id from temp_details where count >= 2);
delete from property_details_dup_fix12 where dup_id in (with temp_details as(select dup_id, count(dup_id) from property_details_dup_fix12 group by dup_id) select dup_id from temp_details where count >= 2);

-- create new property_details table with unique values from property_details temp value - removing duplicates
create table property_details as select * from property_details_dup_fix1;
insert into property_details select * from property_details_dup_fix2;
insert into property_details select * from property_details_dup_fix3;
insert into property_details select * from property_details_dup_fix4;
insert into property_details select * from property_details_dup_fix5;
insert into property_details select * from property_details_dup_fix6;
insert into property_details select * from property_details_dup_fix7;
insert into property_details select * from property_details_dup_fix8;
insert into property_details select * from property_details_dup_fix9;
insert into property_details select * from property_details_dup_fix10;
insert into property_details select * from property_details_dup_fix11;
insert into property_details select * from property_details_dup_fix12;

alter table property_details drop column "id"

drop table property_details_temp1;
drop table property_details_temp2;
drop table property_details_temp3;
drop table property_details_temp4;
drop table property_details_temp5;
drop table property_details_temp6;
drop table property_details_temp7;
drop table property_details_temp8;
drop table property_details_temp9;
drop table property_details_temp10;
drop table property_details_temp11;
drop table property_details_temp12;

drop table property_details_dup_fix1;
drop table property_details_dup_fix2;
drop table property_details_dup_fix3;
drop table property_details_dup_fix4;
drop table property_details_dup_fix5;
drop table property_details_dup_fix6;
drop table property_details_dup_fix7;
drop table property_details_dup_fix8;
drop table property_details_dup_fix9;
drop table property_details_dup_fix10;
drop table property_details_dup_fix11;
drop table property_details_dup_fix12;