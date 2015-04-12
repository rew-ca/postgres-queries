drop view new_properties;

create view new_properties as 
with properties1 as(
	with properties2 as(
		with properties3 as(
			with properties4 as(
				with properties5 as(
					with properties6 as(
						--convert street name to array disregarding addresses with lot in unit number, since these are invalid addresses.
						select string_to_array( trim( both ' ' from regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(street_name || ' ', '[\s]+', ' ', 'g'), ' Bb Path ', ' ', 'g'), ' Bb ', ' ', 'g'), ' ne ', ' NE ', 'gi'), ' se ', ' SE ', 'gi'), ' sw ', ' SW ', 'gi'), ' nw ', ' NW ', 'gi'), ' Cst ', ' Crescent ', 'g'), ' Dr ', ' Drive', 'g'), ' Blvd ', ' Boulevard', 'g'), ' Blv ', ' Boulevard', 'g'), 'St ', 'Street ', 'g'), 'Ave ', 'Avenue ', 'g'), 'Kent Avenue North', 'East Kent Avenue North', 'g'), 'Kent Avenue South', 'East Kent Avenue South', 'g'), 'E Kent Ave South Avenue', 'East Kent Avenue South', 'g'), 'E Kent Avenue South Avenue', 'East Kent Avenue South', 'g'), 'E Kent Ave North Avenue', 'East Kent Avenue North', 'g'), ' Southeast', '', 'g'), 'Leg Inlet Boot Square', 'Leg In Boot Square', 'g')), ' ') as street_name_array1, * 
						from properties
						where (unit_number not ilike 'lot' or unit_number is null) and (street_name not ilike '%no name%' or street_number is null)
					)

					-- Fix unit number, if unit number in street number
					select
					*,
					CASE WHEN (unit_number in ('PH', 'TH', 'U', 'P') and substring(street_name from 1 for 1) ~ '^[0-9]' and regexp_replace(street_number, '[^0-9]', '', 'gi') != '' and regexp_replace(street_number, '[^0-9]', '', 'gi')::int < 500)
						THEN (unit_number || street_number)
					ELSE unit_number
					END as new_unit_number
					
					from properties6
				)

				-- Fix street names for streets named with a number and a letter e.g. 113A Avenue
				select
				*,
				CASE WHEN (substring(street_name_array1[1] from 1 for 1) ~ '^[0-9]' and substring(street_name_array1[1] from char_length(street_name_array1[1]) for 1) ~ '^[0-9]') and lower(street_name_array1[2]) in ('a', 'b', 'c')
					THEN (street_name_array1[1] || street_name_array1[2]) || street_name_array1[3 : array_upper(street_name_array1, 1)]
				WHEN (substring(street_name_array1[2] from 1 for 1) ~ '^[0-9]' and substring(street_name_array1[2] from char_length(street_name_array1[2]) for 1) ~ '^[0-9]') and lower(street_name_array1[3]) in ('a', 'b', 'c')
					THEN street_name_array1[1] || (street_name_array1[2] || street_name_array1[3]) || street_name_array1[4 : array_upper(street_name_array1, 1)]
				WHEN (substring(street_name_array1[3] from 1 for 1) ~ '^[0-9]' and substring(street_name_array1[3] from char_length(street_name_array1[3]) for 1) ~ '^[0-9]') and lower(street_name_array1[4]) in ('a', 'b', 'c')
					THEN street_name_array1[1:2] || (street_name_array1[3] || street_name_array1[4]) || street_name_array1[5 : array_upper(street_name_array1, 1)]
				ELSE street_name_array1
				END as street_name_array2
				from properties5

			)

			-- fix street name and street number, if street number in street name
			select 
			*,
			CASE WHEN street_name_array2[1] ~ '^[0-9]' and (array_length(street_name_array2, 1) > 2 or street_name_array2[2] ilike 'kingsway')
				THEN 
				CASE WHEN (street_number = '' or substring(street_number from char_length(street_number) for 1) = substring(new_unit_number from char_length(new_unit_number) for 1))
					THEN (street_name_array2[1])
				ELSE street_number || ' ' || street_name_array2[1]
				END
			ELSE street_number
			END as new_street_number,

			CASE WHEN street_name_array2[1] ~ '^[0-9]' and (array_length(street_name_array2, 1) > 2 or street_name_array2[2] ilike 'kingsway')
				THEN (street_name_array2[2 : array_upper(street_name_array2, 1)])
			ELSE street_name_array2
			END as street_name_array3

			from properties4

		)

		--  Fix numbered streets without th, nd, st, rd:
		select
		*,
		CASE WHEN ((substring(street_name_array3[1] from 1 for 1) ~ '^[0-9]' and substring(street_name_array3[1] from char_length(street_name_array3[1]) for 1) ~ '^[0-9]') and lower(street_name_array3[2]) ~ '^[a-z]')
			THEN 
			CASE WHEN substring(street_name_array3[1] from char_length(street_name_array3[1]) for 1) = '1'
				THEN (street_name_array3[1] || 'st') || street_name_array3[2 : array_upper(street_name_array3, 1)]
			WHEN substring(street_name_array3[1] from char_length(street_name_array3[1]) for 1) = '2'
				THEN (street_name_array3[1] || 'nd') || street_name_array3[2 : array_upper(street_name_array3, 1)]
			WHEN substring(street_name_array3[1] from char_length(street_name_array3[1]) for 1) = '3'
				THEN (street_name_array3[1] || 'rd') || street_name_array3[2 : array_upper(street_name_array3, 1)]
			WHEN substring(street_name_array3[1] from char_length(street_name_array3[1]) for 1) in ('4', '5', '6', '7', '8', '9', '0')
				THEN (street_name_array3[1] || 'th') || street_name_array3[2 : array_upper(street_name_array3, 1)]
			END
		WHEN ((street_name_array3[1] not like 'No.' and street_name_array3[1] not like 'No') and (substring(street_name_array3[2] from 1 for 1) ~ '^[0-9]' and substring(street_name_array3[2] from char_length(street_name_array3[2]) for 1) ~ '^[0-9]') and lower(street_name_array3[3]) ~ '^[a-z]')
			THEN 
			CASE WHEN substring(street_name_array3[2] from char_length(street_name_array3[2]) for 1) = '1'
				THEN ARRAY[street_name_array3[1]] || ARRAY[(street_name_array3[2] || 'st')] || street_name_array3[3 : array_upper(street_name_array3, 1)]
			WHEN substring(street_name_array3[2] from char_length(street_name_array3[2]) for 1) = '2'
				THEN ARRAY[street_name_array3[1]] || ARRAY[(street_name_array3[2] || 'nd')] || street_name_array3[3 : array_upper(street_name_array3, 1)]
			WHEN substring(street_name_array3[2] from char_length(street_name_array3[2]) for 1) = '3'
				THEN ARRAY[street_name_array3[1]] || ARRAY[(street_name_array3[2] || 'rd')] || street_name_array3[3 : array_upper(street_name_array3, 1)]
			WHEN substring(street_name_array3[2] from char_length(street_name_array3[2]) for 1) in ('4', '5', '6', '7', '8', '9', '0')
				THEN ARRAY[street_name_array3[1]] || ARRAY[(street_name_array3[1] || 'th')] || street_name_array3[2 : array_upper(street_name_array3, 1)]
			END
		ELSE street_name_array3
		END as street_name_array4
		from properties3
	)

	select 
		*,
		-- Extracting direction from street address. Creating new_street_address from street address and street direction:
		CASE 
		CASE WHEN street_name not similar to '%(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent)%'
		THEN
			CASE WHEN ('W' = ANY street_name_array4 OR 'West' = ANY street_name_array4)
				THEN 'West'
			CASE WHEN ('N' = ANY street_name_array4 OR 'North' = ANY street_name_array4)
				THEN 'North'
			CASE WHEN ('S' = ANY street_name_array4 OR 'South' = ANY street_name_array4)
				THEN 'South'
			CASE WHEN ('E' = ANY street_name_array4 OR 'East' = ANY street_name_array4)
				THEN 'East'
			CASE WHEN ('NW' = ANY street_name_array4 OR 'Nw' = ANY street_name_array4)
				THEN 'NW'
			CASE WHEN ('NE' = ANY street_name_array4 OR 'Ne' = ANY street_name_array4)
				THEN 'NE'
			CASE WHEN ('SW' = ANY street_name_array4 OR 'Sw' = ANY street_name_array4)
				THEN 'SW'
			CASE WHEN ('SE' = ANY street_name_array4 OR 'Se' = ANY street_name_array4)
				THEN 'SE'
			ELSE ''

		WHEN street_name similar to '%(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent)%' and 
			street_name not similar to '(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent)'
			-- Need to make sure to extract the right direction
			CASE WHEN ('W' = ANY street_name_array4 OR 'West' = ANY street_name_array4)
				THEN 'West'
			CASE WHEN ('N' = ANY street_name_array4 OR 'North' = ANY street_name_array4)
				THEN 'North'
			CASE WHEN ('S' = ANY street_name_array4 OR 'South' = ANY street_name_array4)
				THEN 'South'
			CASE WHEN ('E' = ANY street_name_array4 OR 'East' = ANY street_name_array4)
				THEN 'East'
			CASE WHEN ('NW' = ANY street_name_array4 OR 'Nw' = ANY street_name_array4)
				THEN 'NW'
			CASE WHEN ('NE' = ANY street_name_array4 OR 'Ne' = ANY street_name_array4)
				THEN 'NE'
			CASE WHEN ('SW' = ANY street_name_array4 OR 'Sw' = ANY street_name_array4)
				THEN 'SW'
			CASE WHEN ('SE' = ANY street_name_array4 OR 'Se' = ANY street_name_array4)
				THEN 'SE'
			ELSE ''

		ELSE ''
		
		END as new_street_direction,

		-- Removing direction from street address:
		CASE WHEN lower(street_name_array4[1]) in ('west', 'east', 'north', 'south', 'w', 'e', 'n', 's', 'se', 'sw', 'ne', 'nw') and (lower(street_name_array4[2]) not in ('boulevard', 'road', 'avenue', 'mall', 'parallel', 'fraser', 'vista', 'dyke', 'bluff', 'beach', 'sumas', 'sward', 'view', 'shore', 'kent') or substring(street_name_array4[2] from 1 for 1) ~ '^[0-9]')
			THEN 

			CASE WHEN lower(street_name_array4[array_upper(street_name_array4, 1)]) in ('west', 'east', 'north', 'south', 'w', 'e', 'n', 's', 'se', 'sw', 'ne', 'nw') 
				THEN (street_name_array4[2 : array_upper(street_name_array4, 1) - 1])
			ELSE (street_name_array4[2 : array_upper(street_name_array4, 1)])
			END

		WHEN lower(street_name_array4[1]) in ('west', 'east', 'north', 'south', 'w', 'e', 'n', 's', 'se', 'sw', 'ne', 'nw') and (lower(street_name_array4[2]) in ('boulevard', 'road', 'avenue', 'mall', 'parallel', 'fraser', 'vista', 'dyke', 'bluff', 'beach', 'sumas', 'sward', 'view', 'shore', 'kent'))
			THEN 
			CASE WHEN lower(street_name_array4[array_upper(street_name_array4, 1)]) in ('west', 'east', 'north', 'south', 'w', 'e', 'n', 's', 'se', 'sw', 'ne', 'nw') 
			THEN trim(both ' ' from regexp_replace(regexp_replace(regexp_replace(regexp_replace(street_name_array4[1] || ' ', 'W ', 'West', 'g'), 'E ', 'East', 'g'), 'S ', 'South', 'g'), 'N ', 'North', 'g')) || (street_name_array4[2 : array_upper(street_name_array4, 1) - 1])
			ELSE trim(both ' ' from regexp_replace(regexp_replace(regexp_replace(regexp_replace(street_name_array4[1] || ' ', 'W ', 'West', 'g'), 'E ', 'East', 'g'), 'S ', 'South', 'g'), 'N ', 'North', 'g')) || (street_name_array4[2 : array_upper(street_name_array4, 1)])
			END

		WHEN lower(street_name_array4[array_upper(street_name_array4, 1)]) in ('west', 'east', 'north', 'south', 'w', 'e', 'n', 's', 'se', 'sw', 'ne', 'nw') 
			THEN (street_name_array4[1 : array_upper(street_name_array4, 1) - 1])

		ELSE street_name_array4
		END as new_street_name_array
		
		from properties2
)


select id, 
	slug, 
	parcel_slug, 
	street_slug, 
	postal_code_slug, 
	street_number, 
	new_street_number, 
	street_name, 
	array_to_string(new_street_name_array, ' ') as new_street_name, 
	street_direction, 
	new_street_direction, 
	unit_number, 
	new_unit_number, 
	city_id, 
	postal_code, 
	formatted_address, 
	latitude, 
	longitude, 
	geocode_source, 
	geocode_type, 
	geocode_status, 
	legal_type, 
	strata_fee, 
	property_tax, 
	year_built, 
	floor_area, 
	bedroom, 
	bathroom, 
	assessed_type, 
	lot_size, 
	created_at, 
	updated_at, 
	den, 
	normalized_type, 
	parcel, 
	published, 
	lot_frontage, 
	lot_depth, 
	use_point_for_street_view, 
	matchable
from properties1;
	--where street_name_array1[1] like 'No.' or street_name_array3[1] like 'No'
	--where street_name not like array_to_string(new_street_name_array, ' ')
	--limit 1000;

select count(*) from new_properties;