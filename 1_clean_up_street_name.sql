-- Remove obviously bad data
delete * from properties where id in (992218);

drop table new_properties;
drop view new_properties;

create table new_properties as 
with properties1 as(
	with properties2 as(
		with properties3 as(
			with properties4 as(
				with properties5 as(
					with properties6 as(
						with properties7 as (
							with properties8 as (
								with properties9 as(
									with properties10 as(
										with properties11 as(
											with properties12 as(

-- Filter invalid property addresses
-- Store all properties with valid addresses in properties12 table
select *,
	case when street_name ~~ '0  %'
	then regexp_replace(street_name, '0  ', '', 'g')
	
	else street_name
	
	end as street_name0
from properties
-- invalid unit numbers
where ((unit_number !~~* '%bl%' and unit_number !~~* '%lt%' and unit_number !~~* '%lot%' and unit_number !~~* '%sl%' and unit_number !~~* '%pcl%' and unit_number !~~* '%parcel%') or unit_number is null) 
and 
-- invalid street names
((street_name !~~* '%no name%' and street_name not similar to '%(Lot | Lt )%' and street_name !~~* '%right of way%' and street_name !~~* '%access line%') or street_name is null)
and
-- invalid street_number
((street_number !~~* '%bl%' and street_number !~~* '%lt%' and street_number !~~* '%lot%' and street_number !~~* '%sl%' and street_number !~~* '%pcl%' and street_number !~~* '%parcel%' and street_number !~~* '%.%' and street_number !~~* '"road"' and street_number !~~* '%(itel)%' and street_number !~~* '%mile%' and street_number !~~* '%track%' and street_number !~~* '%rogers%' and street_number !~~* 'rrrrr' and street_number !~~* '%cls%' and street_number !~~* '%fsf%' and street_number !~~* '%access%' and street_number !~~* '%lane%' and street_number !~~* '%paper%' and street_number !~~* '%scott%' and street_number !~~* 'l0t%' and street_number !~~* 'l%' and street_number !~~* 'site%' and street_number !~~* 'sec%' and street_number !~~* 'w13') or street_number is null)
										)
										
-- Creates properties11 from properties12
-- Fix street name, street number and unit number when street number in unit number and part of street name in street number
select *,
	case when street_number !~ '^[0-9]+$' and unit_number ~ '^[0-9]+$'
	then street_number || ' ' || street_name0

	when street_number ~~* 'dl%' and street_name0 ~ '^[0-9]+$'
	then null

	when street_number similar to '(Agamemnon|Anderson|Best|Britannia|Cheekye|Copper|Crystal|Eagle|Five|Helga|Indian|Old|Sandy|Squamish|Vedder|Vista|Zero)'
	then street_number || ' ' || street_name0 
	
	else street_name0
	end street_name1,

	case when street_number !~ '^[0-9]+$' and unit_number ~ '^[0-9]+$'
	then unit_number

	when street_number ~~ '%-%'
	then (string_to_array(street_number, '-'))[array_upper(string_to_array(street_number, '-'), 1)]

	when street_number similar to '(0|Week|Wk|Th%|Ph|Ch%)'
	then null

	when street_number ~~* 'dl%'
	then 
		case when street_name0 ~ '^[0-9]+$'
		then upper(street_number) || street_name0
		
		else upper(street_number)
		end

	when street_number ~~* '%-'
	then regexp_replace(street_number, '-$', '')

	when regexp_replace(street_number, '[a-z]', '', 'gi') ~~ ''
	then
		case when char_length(street_number) = 1 or street_number similar to '(VACANT|Unit|Upper|Sub|Lainl|Agamemnon|Anderson|Best|Britannia|Cheekye|Copper|Crystal|Eagle|Five|Helga|Indian|Old|Sandy|Squamish|Vedder|Vista|Zero)'
		then null

		else street_number

		end
	
	else street_number
	end street_number1,
	

	case when (street_number !~ '^[0-9]+$' and unit_number ~ '^[0-9]+$') 
		or unit_number ~~ '0' 
		or unit_number similar to '%(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)%' 
		or unit_number ilike 'c'
	then ''

	when street_number ~~ '%-%'
	then
		case when array_upper(string_to_array(street_number, '-'), 1) = 2
		then (string_to_array(street_number, '-'))[1]

		when array_upper(string_to_array(street_number, '-'), 1) > 2
		then 
			case when (string_to_array(street_number, '-'))[1] ~~* 't'
			then 'TH' || (string_to_array(street_number, '-'))[2]
			
			else array_to_string((string_to_array(street_number, '-'))[1:2], '-')
			end
		end
	
	when unit_number ~ '%.%'
	then regexp_replace(unit_number, '.', '', 'g')
	
	when (unit_number similar to 'T%' and substring(unit_number, 2, char_length(unit_number)) ~ '^[0-9]') or unit_number similar to '(T-|TH |TH-)%'
	then regexp_replace(unit_number, '(T|T-|TH |TH-|TH.)', 'TH', 'g')

	when (unit_number similar to 'P%' and substring(unit_number, 2, char_length(unit_number)) ~ '^[0-9]') or unit_number similar to '(P-|PH |PH-)%'
	then regexp_replace(unit_number, '(P|P-|PH |PH-|PH.)', 'PH', 'g')

	when street_number similar to '(Th|Ph)%'
	then upper(street_number)

	when regexp_replace(unit_number, '[a-z]', '', 'gi') ~~ '' and char_length(unit_number) > 1 and unit_number not similar to '%(TH|PH|UPPER|LOWER|MAIN)%'
	then null
	
	else unit_number
	end unit_number1
	
	from properties12
									)

-- properties10
-- Fix wrong street names
select *,
case when street_name1 ~~* '%West Seymour%'
then regexp_replace(street_name1, 'West Seymour', 'Seymour', 'g')

when street_name1 ~~* '%Street Davids Avenue%'
then regexp_replace(street_name1, 'Street Davids Avenue', 'St. Davids Avenue', 'g')

when street_name1 ~~* '%F North Road%'
then regexp_replace(street_name1, 'F North Road', 'North Road', 'g')

when street_name1 ~~* '%A East Road%'
then regexp_replace(street_name1, 'A East Road', 'East Road', 'g')

when street_name1 ~~* '%Kent Avenue North%'
then regexp_replace(street_name1, 'Kent Avenue North', 'East Kent Avenue North', 'g')

when street_name1 ~~* '%D North Road%'
then regexp_replace(street_name1, 'D North Road', 'North Road', 'g')

when street_name1 ~~* '%B West Saanich Road%'
then regexp_replace(street_name1, 'B West Saanich Road', 'West Saanich Road', 'g')

when street_name1 ~~* '%S South Dyke Road%'
then regexp_replace(street_name1, 'S South Dyke Road', 'South Dyke Road', 'g')

when street_name1 ~~* '%Kent Avenue South%'
then regexp_replace(street_name1, 'Kent Avenue South', 'East Kent Avenue South', 'g')

when street_name1 ~~* '%E Kent Ave South Avenue%'
then regexp_replace(street_name1, 'E Kent Ave South Avenue', 'East Kent Avenue South', 'g')

when street_name1 ~~* '%E Kent Avenue South Avenue%'
then regexp_replace(street_name1, 'E Kent Avenue South Avenue', 'East Kent Avenue South', 'g')

when street_name1 ~~* '%Sward North Road%'
then regexp_replace(street_name1, 'Sward North Road', 'North Sward Road', 'g')

when street_name1 ~~* '%Swart North Road%'
then regexp_replace(street_name1, 'Swart North Road', 'North Sward Road', 'g')

when street_name1 ~~* '%E Kent Ave North Avenue%'
then regexp_replace(street_name1, 'E Kent Ave North Avenue', 'East Kent Avenue North', 'g')

when street_name1 ~~* '%Nor West Bay Road%'
then regexp_replace(street_name1, 'Nor West Bay Road', 'Norwest Bay Road', 'g')

when street_name1 ~~* '%Street James Road%'
then regexp_replace(street_name1, 'Street James Road', 'St. James Road', 'g')

when street_name1 ~~* '%Piccadilly North Road%'
then regexp_replace(street_name1, 'Piccadilly North Road', 'Piccadilly North', 'g')

when street_name1 ~~* '%Piccadilly South Road%'
then regexp_replace(street_name1, 'Piccadilly South Road', 'Piccadilly South', 'g')

when street_name1 ~~* '%North Buff Road%'
then regexp_replace(street_name1, 'North Buff Road', 'North Bluff Road', 'g')

when street_name1 ~~* '%A 2707 East 45th Avenue%'
then regexp_replace(street_name1, 'A 2707 East 45th Avenue', '2707 East 45th Avenue', 'g')

when street_name1 ~~* '%East Mall Mall%'
then regexp_replace(street_name1, 'East Mall Mall', 'East Mall', 'g')

when street_name1 ~~* '%North View Street%'
then regexp_replace(street_name1, 'North View Street', 'Northview Street', 'g')

when street_name1 ~~* '%Sward North Drive%'
then regexp_replace(street_name1, 'Sward North Drive', 'North Sward Drive', 'g')

when street_name1 ~~* '%West View Crescent%'
then regexp_replace(street_name1, 'West View Crescent', 'Westview Crescent', 'g')

when street_name1 ~~* '%North View Crescent%'
then regexp_replace(street_name1, 'North View Crescent', 'Northview Crescent', 'g')

when street_name1 ~~* '%Leg Inlet Boot Square%'
then regexp_replace(street_name1, 'Leg Inlet Boot Square', 'Leg In Boot Square', 'g')

when street_name1 ~~* '- 2823 Jacklin Road'
then regexp_replace(street_name1, '- 2823 Jacklin Road', '2823 Jacklin Road', 'g')

when street_name1 ~~* '  006   8700 Bennett Road Road'
then regexp_replace(street_name1, '  006   8700 Bennett Road Road', '8700 Bennett Road ', 'g')

when street_name1 ~~* '0akridge Crescent'
then regexp_replace(street_name1, '0akridge Crescent', 'Oakridge Crescent', 'g')

when street_name1 ~~* '0ld Yale Road'
then regexp_replace(street_name1, '0ld Yale Road', 'Old Yale Road', 'g')

when street_name1 ~~* '%O Avenue%'
then regexp_replace(street_name1, 'O Avenue', '0 Avenue', 'g')

when street_name1 ~~* '%S0uthmere Crescent%'
then regexp_replace(street_name1, 'S0uthmere Crescent', 'Southmere Crescent', 'g')

when street_name1 ~~* '%1o1 Bb Highway%'
then regexp_replace(street_name1, '1o1 Bb Highway', '101 Highway', 'g')

when street_name1 ~~* '%Whitestone Islan Bb%'
then regexp_replace(street_name1, 'Whitestone Islan Bb', 'Whitestone Island', 'g')

when street_name1 ~~* '%St Street%'
then regexp_replace(street_name1, 'St Street', 'Street', 'g')

when street_name1 ~~* '%St. Street%'
then regexp_replace(street_name1, 'St. Street', 'Street', 'g')

when street_name1 ~~* '%Ave Avenue%'
then regexp_replace(street_name1, 'Ave Avenue', 'Avenue', 'g')

when street_name1 ~~* '%Avenue Avenue%'
then regexp_replace(street_name1, 'Avenue Avenue', 'Avenue', 'g')

when street_name1 ~~* '%Road Road%'
then regexp_replace(street_name1, 'Road Road', 'Road', 'g')

when street_name1 ~~* '%Crescent Crescent%'
then regexp_replace(street_name1, 'Crescent Crescent', 'Crescent', 'g')

when street_name1 ~~* '%Highway Highway%'
then regexp_replace(street_name1, 'Highway Highway', 'Highway', 'g')

when street_name1 ~~* '%Way Way%'
then regexp_replace(street_name1, 'Way Way', 'Way', 'g')

when street_name1 ~~* '%Rd Road%'
then regexp_replace(street_name1, 'Rd Road', 'Road', 'g')

else street_name1 

end as street_name2

from properties11
								)

-- properties9						
-- fix street type abbreviations
select *,
	case when ' ' || street_name2 || ' ' ~~* '% Cst %'
	then trim(both ' ' from (regexp_replace(' ' || street_name2 || ' ', ' Cst ', ' Crescent ', 'gi')))

	when ' ' || street_name2 || ' ' ~~* '% Dr %'
	then trim(both ' ' from (regexp_replace(' ' || street_name2 || ' ', ' Dr ', ' Drive ', 'gi')))

	when ' ' || street_name2 || ' ' ~~* '%( Blvd | Blv )%'
	then trim(both ' ' from (regexp_replace(regexp_replace(' ' || street_name2 || ' ', ' Blvd ', ' Boulevard ', 'gi'), ' Blv ', ' Boulevard ', 'gi')))

	when ' ' || street_name2 || ' ' ~~* '% St %' and street_name2 !~~* 'St %'
	then trim(both ' ' from (regexp_replace(' ' || street_name2 || ' ', ' St ', ' Street ', 'gi')))

	when ' ' || street_name2 || ' ' ~~* '% Ave %'
	then trim(both ' ' from (regexp_replace(' ' || street_name2 || ' ', ' Ave ', ' Avenue ', 'gi')))

	when ' ' || street_name2 || ' ' ~~* '% Hwy %'
	then trim(both ' ' from (regexp_replace(' ' || street_name2 || ' ', ' Hwy ', ' Highway ', 'gi')))

	when ' ' || street_name2 || ' ' ~~* '% Hw %'
	then trim(both ' ' from (regexp_replace(' ' || street_name2 || ' ', ' Hw ', ' Highway ', 'gi')))

	when ' ' || street_name2 || ' ' ~~* '% Rd %'
	then trim(both ' ' from (regexp_replace(' ' || street_name2 || ' ', ' Rd ', ' Road ', 'gi')))

	else street_name2

	end as street_name3
 
 from properties10
							)

-- properies8
-- convert all numeric spelled out street names to their numeric version (First --> 1st)
select *,
	case when street_name3 ~~* '%twenty%'
	then
		case when street_name3 ~~* '%first%'
		then regexp_replace(street_name3, '(twenty first|twenty-first|twentyfirst)', '21st', 'gi')

		when street_name3 ~~* '%second%'
		then regexp_replace(street_name3, '(twenty second|twenty-second|twentysecond)', '22nd', 'gi')

		when street_name3 ~~* '%third%'
		then regexp_replace(street_name3, '(twenty third|twenty-third|twentythird)', '23rd', 'gi')

		when street_name3 ~~* '%fourth%'
		then regexp_replace(street_name3, '(twenty fourth|twenty-fourth|twentyfourth)', '24th', 'gi')

		when street_name3 ~~* '%fifth%'
		then regexp_replace(street_name3, '(twenty fifth|twenty-fifth|twentyfifth)', '25th', 'gi')

		when street_name3 ~~* '%sixth%'
		then regexp_replace(street_name3, '(twenty sixth|twenty-sixth|twentysixth)', '26th', 'gi')

		when street_name3 ~~* '%seventh%'
		then regexp_replace(street_name3, '(twenty seventh|twenty-seventh|twentyseventh)', '27th', 'gi')

		when street_name3 ~~* '%eighth%'
		then regexp_replace(street_name3, '(twenty eighth|twenty-eighth|twentyeighth)', '28th', 'gi')

		when street_name3 ~~* '%ninth%'
		then regexp_replace(street_name3, '(twenty ninth|twenty-ninth|twentyninth)', '29th', 'gi')

		end

	when street_name3 ~~* '%first%'
	then regexp_replace(street_name3, 'first', '1st', 'gi')

	when street_name3 ~~* '%second%'
	then regexp_replace(street_name3, 'second', '2nd', 'gi')

	when street_name3 ~~* '%third%'
	then regexp_replace(street_name3, 'third', '3rd', 'gi')

	when street_name3 ~~* '%fourth%'
	then regexp_replace(street_name3, 'fourth', '4th', 'gi')

	when street_name3 ~~* '%fifth%'
	then regexp_replace(street_name3, 'fifth', '5th', 'gi')

	when street_name3 ~~* '%sixth%'
	then regexp_replace(street_name3, 'sixth', '6th', 'gi')

	when street_name3 ~~* '%seventh%'
	then regexp_replace(street_name3, 'seventh', '7th', 'gi')

	when street_name3 ~~* '%eighth%'
	then regexp_replace(street_name3, 'eighth', '8th', 'gi')

	when street_name3 ~~* '%ninth%'
	then regexp_replace(street_name3, 'ninth', '9th', 'gi')

	when street_name3 ~~* '%tenth%'
	then regexp_replace(street_name3, 'tenth', '10th', 'gi')

	when street_name3 ~~* '%eleventh%'
	then regexp_replace(street_name3, 'eleventh', '11th', 'gi')

	when street_name3 ~~* '%twelfth%'
	then regexp_replace(street_name3, 'twelfth', '12th', 'gi')

	when street_name3 ~~* '%thirteenth%'
	then regexp_replace(street_name3, 'thirteenth', '13th', 'gi')

	when street_name3 ~~* '%fourteenth%'
	then regexp_replace(street_name3, 'fourteenth', '14th', 'gi')

	when street_name3 ~~* '%fifteenth%'
	then regexp_replace(street_name3, 'fifteenth', '15th', 'gi')

	when street_name3 ~~* '%sixteenth%'
	then regexp_replace(street_name3, 'sixteenth', '16th', 'gi')

	when street_name3 ~~* '%seventeenth%'
	then regexp_replace(street_name3, 'seventeenth', '17th', 'gi')

	when street_name3 ~~* '%eighteenth%'
	then regexp_replace(street_name3, 'eighteenth', '18th', 'gi')

	when street_name3 ~~* '%nineteenth%'
	then regexp_replace(street_name3, 'nineteenth', '19th', 'gi')

	when street_name3 ~~* '%twentieth%'
	then regexp_replace(street_name3, 'twentieth', '20th', 'gi')

	else street_name3
	
	end as street_name4
	
from properties9
						)

-- create properties7	
-- convert street name to array 
select 
	string_to_array(trim(both ' ' from regexp_replace(regexp_replace(regexp_replace(street_name4 || ' ', '[\s]+', ' ', 'g'), ' Bb Path ', ' ', 'g'), ' Bb ', ' ', 'g')), ' ') as street_name_array7, 
	* 
from properties8
					)

-- create properties6
-- delete single letter from beginning of street name
select
*,
case when street_name_array7[1] similar to '[A-Z]' and array_length(street_name_array7, 1) > 2 and street_name_array7[1] not in ('N', 'E', 'W', 'S')
then street_name_array7[2 : array_upper(street_name_array7, 1)]

else street_name_array7

end street_name_array6

from properties7

)

-- create properties5
-- Fix unit number, street number and street name, if unit number in street name
select
*,
case when unit_number1 in ('PH', 'TH', 'U', 'P', 'LC', 'CH', 'L', 'MA', 'MZ', 'LW', 'M', 'T')
then
	case when array_length(string_to_array(street_number1, ' '), 1) > 1
	then unit_number1 || (string_to_array(street_number1, ' '))[1]
	
	when street_name_array6[1] ~ '^[0-9]+$'
	then unit_number1 || street_number1

	else unit_number1
	end
	
when (street_name_array6[1] similar to '(Th|Ph)' and street_name_array6[2] ~ '^[0-9]+$')
then 
	case when street_name_array6[3] ~ '^[0-9]+$'
	then upper(street_name_array6[1]) || street_name_array6[2]

	else street_name_array6[1]
	end

when (street_name_array6[1] similar to '(Th|Ph)%' and substring(street_name_array6[1] from 3) ~ '^[0-9]+$')
then upper(street_name_array6[1])

else unit_number1
end unit_number2,

-- street_number
case when unit_number1 in ('PH', 'TH', 'U', 'P', 'LC', 'CH', 'L', 'MA', 'MZ', 'LW', 'M', 'T')
then
	case when array_length(string_to_array(street_number1, ' '), 1) > 1
	then unit_number1 || (string_to_array(street_number1, ' '))[2]
	
	when street_name_array6[1] ~ '^[0-9]+$'
	then street_name_array6[1]

	else street_number1
	end

when (street_name_array6[1] similar to '(Th|Ph)' and street_name_array6[2] ~ '^[0-9]+$')
then
	case when street_name_array6[3] ~ '^[0-9]+$'
	then street_name_array6[3]

	else street_name_array6[2]
	end

when (street_name_array6[1] similar to '(Th|Ph)%' and substring(street_name_array6[1] from 3) ~ '^[0-9]+$')
then street_name_array6[2]
	
else street_number1

end street_number2,

-- street_name
case when unit_number1 in ('PH', 'TH', 'U', 'P', 'LC', 'CH', 'L', 'MA', 'MZ', 'LW', 'M', 'T')
then
	case when street_name_array6[1] ~ '^[0-9]+$'
	then street_name_array6[2 : array_upper(street_name_array6, 1)]

	else street_name_array6
	end

when (street_name_array6[1] similar to '(Th|Ph)' and street_name_array6[2] ~ '^[0-9]+$')
then
	case when street_name_array6[3] ~ '^[0-9]+$'
	then street_name_array6[4 : array_upper(street_name_array6, 1)]

	else street_name_array6[3 : array_upper(street_name_array6, 1)]
	end

when (street_name_array6[1] similar to '(Th|Ph)%' and substring(street_name_array6[1] from 3) ~ '^[0-9]+$')
then street_name_array6[3 : array_upper(street_name_array6, 1)]

else street_name_array6
end street_name_array5

from properties6
				)

-- create properties4
-- Fix street names for streets named with a number and a letter e.g. 113A Avenue
select
*,
CASE WHEN (substring(street_name_array5[1] from 1 for 1) ~ '^[0-9]' 
	and 
	substring(street_name_array5[1] from char_length(street_name_array5[1]) for 1) ~ '^[0-9]') 
	and 
	lower(street_name_array5[2]) in ('a', 'b', 'c')
THEN (street_name_array5[1] || street_name_array5[2]) || street_name_array5[3 : array_upper(street_name_array5, 1)]

WHEN (substring(street_name_array5[2] from 1 for 1) ~ '^[0-9]' 
	and 
	substring(street_name_array5[2] from char_length(street_name_array5[2]) for 1) ~ '^[0-9]') 
	and 
	lower(street_name_array5[3]) in ('a', 'b', 'c')
THEN street_name_array5[1] || (street_name_array5[2] || street_name_array5[3]) || street_name_array5[4 : array_upper(street_name_array5, 1)]

WHEN (substring(street_name_array5[3] from 1 for 1) ~ '^[0-9]' 
	and 
	substring(street_name_array5[3] from char_length(street_name_array5[3]) for 1) ~ '^[0-9]') 
	and 
	lower(street_name_array5[4]) in ('a', 'b', 'c')
THEN street_name_array5[1:2] || (street_name_array5[3] || street_name_array5[4]) || street_name_array5[5 : array_upper(street_name_array5, 1)]

WHEN (substring(street_name_array5[1] from 1 for char_length(street_name_array5[1]) - 1) ~ '^[0-9]+$' 
	and 
	substring(street_name_array5[1] from char_length(street_name_array5[1]) for 1) ~* '^[a-z]')
THEN (upper(street_name_array5[1]) || street_name_array5[2 : array_upper(street_name_array5, 1)])

WHEN (substring(street_name_array5[2] from 1 for char_length(street_name_array5[2]) - 1) ~ '^[0-9]+$' 
	and 
	substring(street_name_array5[2] from char_length(street_name_array5[2]) for 1) ~* '^[a-z]')
THEN street_name_array5[1]|| (upper(street_name_array5[2]) || street_name_array5[3 : array_upper(street_name_array5, 1)])

WHEN (substring(street_name_array5[3] from 1 for char_length(street_name_array5[3]) - 1) ~ '^[0-9]+$' 
	and 
	substring(street_name_array5[3] from char_length(street_name_array5[3]) for 1) ~* '^[a-z]')
THEN street_name_array5[1:2]|| (upper(street_name_array5[3]) || street_name_array5[4 : array_upper(street_name_array5, 1)])

WHEN char_length(street_name_array5[1]) = 1 
	and 
	street_name_array5[1] ~ '^[A-Z]' 
	and 
	street_name_array5[1] not in ('E', 'W', 'N', 'S', 'O') 
	and 
	street_name_array5[2] ~~* 'Ave%' 
	and 
	street_name_array5[2] similar to '(Ave|St)%'
THEN (street_number2 || street_name_array5[1]) || street_name_array5[2 : array_upper(street_name_array5, 1)]

ELSE street_name_array5
END street_name_array4,

CASE WHEN char_length(street_name_array5[1]) = 1 
	and 
	street_name_array5[1] ~ '^[A-Z]' 
	and 
	street_name_array5[1] not in ('E', 'W', 'N', 'S', 'O') 
	and 
	street_name_array5[2] ~~* 'Ave%' 
	and 
	street_name_array5[2] similar to '(Ave|St)%'
THEN unit_number2
ELSE street_number2

END street_number3,

CASE WHEN char_length(street_name_array5[1]) = 1 
	and 
	street_name_array5[1] ~ '^[A-Z]' 
	and 
	street_name_array5[1] not in ('E', 'W', 'N', 'S', 'O') 
	and 
	street_name_array5[2] ~~* 'Ave%' 
	and 
	street_name_array5[2] similar to '(Ave|St)%'
THEN ''
ELSE unit_number2

END unit_number3

from properties5
			)


-- create properties3
-- Extracting direction from street address. 
select 
*,
-- Creating new_street_address from street address and street direction:
CASE WHEN (array_to_string(street_name_array4, ' ') not like '%(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent|West Street)%')
THEN
	CASE WHEN ('W' = ANY (street_name_array4) 
		OR 
		'W.' = ANY (street_name_array4)
		OR 
		'West' = ANY (street_name_array4))
	THEN 'West'

	WHEN ('N' = ANY (street_name_array4) 
		OR 
		'N.' = ANY (street_name_array4)
		OR 
		'North' = ANY (street_name_array4))
	THEN 'North'

	WHEN ('S' = ANY (street_name_array4) 
		OR 
		'S.' = ANY (street_name_array4)
		OR 
		'South' = ANY (street_name_array4))
	THEN 'South'

	WHEN ('E' = ANY (street_name_array4) 
		OR 
		'E.' = ANY (street_name_array4)
		OR 
		'East' = ANY (street_name_array4))
	THEN 'East'
	
	WHEN ('NW' = ANY (street_name_array4) 
		OR 
		'Nw' = ANY (street_name_array4)
		OR 
		'nw' = ANY (street_name_array4)
		OR 
		'Northwest' = ANY (street_name_array4))
	THEN 'NW'

	WHEN ('NE' = ANY (street_name_array4) 
		OR 
		'Ne' = ANY (street_name_array4)
		OR 
		'ne' = ANY (street_name_array4)
		OR 
		'Northeast' = ANY (street_name_array4))
	THEN 'NE'

	WHEN ('SW' = ANY (street_name_array4) 
		OR 
		'Sw' = ANY (street_name_array4)
		OR
		'sw' = ANY (street_name_array4)
		OR
		'Southwest' = ANY (street_name_array4))
	THEN 'SW'

	WHEN ('SE' = ANY (street_name_array4) 
		OR 
		'Se' = ANY (street_name_array4)
		OR 
		'se' = ANY (street_name_array4)
		OR 
		'Southeast' = ANY (street_name_array4))
	THEN 'SE'

	ELSE trim(both ' ' from (regexp_replace(regexp_replace(regexp_replace(regexp_replace(' ' || street_direction || ' ', ' S ', 'South', 'g'), ' E ', 'East', 'g'),' N ', 'North', 'g'), ' W ', 'West', 'g')))
	END

WHEN array_to_string(street_name_array4, ' ') like '%(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent|West Street)%' 
	and array_to_string(street_name_array4, ' ') not like '(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent|West Street)'
	-- Need to make sure to extract the right direction
THEN 
	CASE WHEN ' ' || regexp_replace(array_to_string(street_name_array4, ' '), '(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent|West Street)', '') || ' ' like '%( West | W | W. )%'
	THEN 'West'

	WHEN ' ' || regexp_replace(array_to_string(street_name_array4, ' '), '(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent|West Street)', '') || ' ' like '%( North | N | N. )%'
	THEN 'North'

	WHEN ' ' || regexp_replace(array_to_string(street_name_array4, ' '), '(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent|West Street)', '') || ' ' like '%( South | S | S. )%'
	THEN 'South'

	WHEN ' ' || regexp_replace(array_to_string(street_name_array4, ' '), '(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent|West Street)', '') || ' ' like '%( East | E | E. )%'
	THEN 'East'

	WHEN ' ' || regexp_replace(array_to_string(street_name_array4, ' '), '(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent|West Street)', '') || ' ' like '%( NW | Nw | nw | Northwest )%'
	THEN 'NW'

	WHEN ' ' || regexp_replace(array_to_string(street_name_array4, ' '), '(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent|West Street)', '') || ' ' like '%( NE | Ne | ne | Northeast )%'
	THEN 'NE'

	WHEN ' ' || regexp_replace(array_to_string(street_name_array4, ' '), '(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent|West Street)', '') || ' ' like '%( SW | Sw | sw | Southwest )%'
	THEN 'SW'

	WHEN ' ' || regexp_replace(array_to_string(street_name_array4, ' '), '(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent|West Street)', '') || ' ' like '%( SE | Se | se | Southeast )%'
	THEN 'SE'

	WHEN array_to_string(street_name_array4, ' ') ~~* 'Granville Street'
	THEN null

	ELSE regexp_replace(regexp_replace(regexp_replace(regexp_replace(' ' || street_direction || ' ', ' S ', 'South', 'g'), ' E ', 'East', 'g'),' N ', 'North', 'g'), ' W ', 'West', 'g')

	END

ELSE regexp_replace(regexp_replace(regexp_replace(regexp_replace(' ' || street_direction || ' ', ' S ', 'South', 'g'), ' E ', 'East', 'g'),' N ', 'North', 'g'), ' W ', 'West', 'g')

END as new_street_direction,

-- Removing direction from street address:
CASE WHEN ('W' = ANY (street_name_array4) 
	OR
	'W.' = ANY(street_name_array4)
	OR 
	'West' = ANY (street_name_array4) 
	OR 
	'N' = ANY (street_name_array4) 
	OR
	'N.' = ANY(street_name_array4)
	OR 
	'North' = ANY (street_name_array4) 
	OR 
	'S' = ANY (street_name_array4) 
	OR
	'S.' = ANY(street_name_array4)
	OR 
	'South' = ANY (street_name_array4) 
	OR 
	'E' = ANY (street_name_array4)
	OR
	'E.' = ANY(street_name_array4)
	OR 
	'East' = ANY (street_name_array4) 
	OR 
	'SE' = ANY (street_name_array4) 
	OR 
	'Se' = ANY (street_name_array4) 
	OR 
	'se' = ANY (street_name_array4) 
	OR 
	'Southeast' = ANY (street_name_array4) 
	OR 
	'SW' = ANY (street_name_array4) 
	OR 
	'Sw' = ANY (street_name_array4)
	OR 
	'sw' = ANY (street_name_array4) 
	OR 
	'Southwest' = ANY (street_name_array4) 
	OR 
	'NE' = ANY (street_name_array4) 
	OR 
	'Ne' = ANY (street_name_array4)
	OR 
	'ne' = ANY (street_name_array4) 
	OR 
	'Northeast' = ANY (street_name_array4) 
	OR 
	'NW' = ANY (street_name_array4) 
	OR 
	'Nw' = ANY (street_name_array4)
	OR 
	'nw' = ANY (street_name_array4)
	OR 
	'Northwest' = ANY (street_name_array4))
THEN
	CASE WHEN (array_to_string(street_name_array4, ' ') not like '%(East Boulevard|West Boulevard|Nicklaus North Boulevard|North Road|Old West Saanich Road|North Sward Road|East Road|Broadway East Place|West Reed Road|North Parallel Road|South Parallel Road|West Saanich Road|East Saanich Road|North Ridge Road|Northwest Road|Northwest Bay Road|South Dyke Road|North Sward Road|Broadway East Street|North Charlotte Road|South Sumas Road|Old West Saanich Road|Old East Road|North Bluff Road|North Fletcher Road|Piccadilly South|North Dairy Road|North Nicomen Road|South Fletcher Road|North Fletcher Road|East Sooke Road|East Kent Avenue|West Avenue|North Burgess Avenue|West Railway Avenue|North Avenue|North Arm Avenue|West Beach Avenue|North Railway Avenue|East Mall|West Mall|North Fraser Crescent|North Fraser Way|South Fraser Way|West Vista Court|West Beach Avenue|North Sward Drive|West View Crescent|South Shore Crescent|West Street)%')
	THEN string_to_array(trim(both ' ' from regexp_replace(' ' || array_to_string(street_name_array4, ' ') || ' ', '( north | n | n. | east | e | e. | west | w | w. | south | s | s. | nw | northwest | se | southeast | sw | southwest | ne | northeast )', ' ', 'gi')), ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%East Boulevard%'
	THEN string_to_array('East Boulevard', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%West Boulevard%'
	THEN string_to_array('West Boulevard', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%Nicklaus North Boulevard%'
	THEN string_to_array('Nicklaus North Boulevard', ' ')				

	WHEN array_to_string(street_name_array4, ' ') like '%Old West Saanich Road%'
	THEN string_to_array('Old West Saanich Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Sward Road%'
	THEN string_to_array('North Sward Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%Broadway East Place%'
	THEN string_to_array('Broadway East Place', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%West Reed Road%'
	THEN string_to_array('West Reed Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Parallel Road%'
	THEN string_to_array('North Parallel Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%South Parallel Road%'
	THEN string_to_array('South Parallel Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%West Saanich Road%'
	THEN string_to_array('West Saanich Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%East Saanich Road%'
	THEN string_to_array('East Saanich Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Ridge Road%'
	THEN string_to_array('North Ridge Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%Northwest Bay Road%'
	THEN string_to_array('Northwest Bay Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%South Dyke Road%'
	THEN string_to_array('South Dyke Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Sward Road%'
	THEN string_to_array('North Sward Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%Broadway East Street%'
	THEN string_to_array('Broadway East Street', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Charlotte Road%'
	THEN string_to_array('North Charlotte Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%South Sumas Road%'
	THEN string_to_array('South Sumas Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%Old West Saanich Road%'
	THEN string_to_array('Old West Saanich Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%Old East Road%'
	THEN string_to_array('Old East Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Bluff Road%'
	THEN string_to_array('North Bluff Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Fletcher Road%'
	THEN string_to_array('North Fletcher Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%Piccadilly South%'
	THEN string_to_array('Piccadilly South', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Dairy Road%'
	THEN string_to_array('North Dairy Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Nicomen Road%'
	THEN string_to_array('North Nicomen Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%South Fletcher Road%'
	THEN string_to_array('South Fletcher Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Fletcher Road%'
	THEN string_to_array('North Fletcher Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%East Sooke Road%'
	THEN string_to_array('East Sooke Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%East Kent Avenue%'
	THEN string_to_array('East Kent Avenue', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Burgess Avenue%'
	THEN string_to_array('North Burgess Avenue', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%West Railway Avenue%'
	THEN string_to_array('West Railway Avenue', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Arm Avenue%'
	THEN string_to_array('North Arm Avenue', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%West Beach Avenue%'
	THEN string_to_array('West Beach Avenue', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Railway Avenue%'
	THEN string_to_array('North Railway Avenue', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Fraser Crescent%'
	THEN string_to_array('North Fraser Crescent', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Fraser Way%'
	THEN string_to_array('North Fraser Way', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%South Fraser Way%'
	THEN string_to_array('South Fraser Way', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%West Vista Court%'
	THEN string_to_array('West Vista Court', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%West Beach Avenue%'
	THEN string_to_array('West Beach Avenue', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Sward Drive%'
	THEN string_to_array('North Sward Drive', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%West View Crescent%'
	THEN string_to_array('West View Crescent', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%South Shore Crescent%'
	THEN string_to_array('South Shore Crescent', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%Northwest Road%'
	THEN string_to_array('Northwest Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%East Mall%'
	THEN string_to_array('East Mall', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%West Mall%'
	THEN string_to_array('West Mall', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Avenue%'
	THEN string_to_array('North Avenue', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%East Road%'
	THEN string_to_array('East Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%North Road%'
	THEN string_to_array('North Road', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%West Avenue%'
	THEN string_to_array('West Avenue', ' ')

	WHEN array_to_string(street_name_array4, ' ') like '%West Street%'
	THEN string_to_array('West Street', ' ')
	
	END

ELSE street_name_array4

END as street_name_array3

from properties4


	)

-- create properties2
-- fix street name and street number, if street number in street name
select 
*,
CASE WHEN street_name_array3[1] ~ '^(-)?[0-9]+$'
	and 
	(array_length(street_name_array3, 1) > 2 or street_name_array3[2] ilike 'kingsway')
THEN 
	CASE WHEN (street_number2 is null 
		or 
		street_number2 = ''
		or 
		substring(street_number3 from char_length(street_number3) for 1) = substring(unit_number3 from char_length(unit_number3) for 1)
		or (street_number3 ~ '^(-)?[0-9]+$' and @(street_number3::int - street_name_array3[1]::int) > 100)
		)
	THEN (street_name_array3[1])

	ELSE street_number3 || '-' || street_name_array3[1]
	END

ELSE street_number3
END new_street_number,


CASE WHEN street_name_array3[1] ~ '^(-)?[0-9]+$'
	and 
	(array_length(street_name_array3, 1) > 2 or street_name_array3[2] ilike 'kingsway')
THEN (street_name_array3[2 : array_upper(street_name_array3, 1)])

ELSE street_name_array3
END street_name_array2,


CASE WHEN (street_name_array3[1] ~ '^(-)?[0-9]+$'
	and 
	(array_length(street_name_array3, 1) > 2 or street_name_array3[2] ilike 'kingsway')
	and
	street_number3 ~ '^(-)?[0-9]+$'
	and
	@(street_number3::int - street_name_array3[1]::int) > 100
	)
THEN
	case when unit_number3 is null
	then street_number3
	else unit_number3 || street_number3
	end

ELSE unit_number3
END new_unit_number

from properties3
	)

-- create new_properties
-- Fix numbered streets without th, nd, st, rd:
select
*,
CASE WHEN street_name_array2[1] ~ '^[0-9]+$' 
	and 
	street_name_array2[1] !~~ '0'
	and 
	lower(street_name_array2[2]) ~ '^[a-z]'
THEN 
	CASE WHEN substring(street_name_array2[1] from char_length(street_name_array2[1]) for 1) = '1' and substring(street_name_array2[1] from char_length(street_name_array2[1]) - 1 for 2) != '11'
	THEN (street_name_array2[1] || 'st') || street_name_array2[2 : array_upper(street_name_array2, 1)]

	WHEN substring(street_name_array2[1] from char_length(street_name_array2[1]) for 1) = '2' and substring(street_name_array2[1] from char_length(street_name_array2[1]) - 1 for 2) != '12'
	THEN (street_name_array2[1] || 'nd') || street_name_array2[2 : array_upper(street_name_array2, 1)]

	WHEN substring(street_name_array2[1] from char_length(street_name_array2[1]) for 1) = '3' and substring(street_name_array2[1] from char_length(street_name_array2[1]) - 1 for 2) != '13'
	THEN (street_name_array2[1] || 'rd') || street_name_array2[2 : array_upper(street_name_array2, 1)]

	WHEN substring(street_name_array2[1] from char_length(street_name_array2[1]) for 1) in ('4', '5', '6', '7', '8', '9', '0') or substring(street_name_array2[1] from char_length(street_name_array2[1]) - 1 for 2) in ('11', '12', '13')
	THEN (street_name_array2[1] || 'th') || street_name_array2[2 : array_upper(street_name_array2, 1)]

	END
	
WHEN ((street_name_array2[1] not like 'No.' 
	and 
	street_name_array2[1] not like 'No') 
	and 
	street_name_array2[2] ~ '^[0-9]+$' 
	and 
	street_name_array2[3] !~~* 'highway'
	and 
	lower(street_name_array2[3]) ~ '^[a-z]')
THEN 
	CASE WHEN substring(street_name_array2[2] from char_length(street_name_array2[2]) for 1) = '1'
	THEN ARRAY[street_name_array2[1]] || ARRAY[(street_name_array2[2] || 'st')] || street_name_array2[3 : array_upper(street_name_array2, 1)]

	WHEN substring(street_name_array2[2] from char_length(street_name_array2[2]) for 1) = '2'
	THEN ARRAY[street_name_array2[1]] || ARRAY[(street_name_array2[2] || 'nd')] || street_name_array2[3 : array_upper(street_name_array2, 1)]

	WHEN substring(street_name_array2[2] from char_length(street_name_array2[2]) for 1) = '3'
	THEN ARRAY[street_name_array2[1]] || ARRAY[(street_name_array2[2] || 'rd')] || street_name_array2[3 : array_upper(street_name_array2, 1)]

	WHEN substring(street_name_array2[2] from char_length(street_name_array2[2]) for 1) in ('4', '5', '6', '7', '8', '9', '0')
	THEN ARRAY[street_name_array2[1]] || ARRAY[(street_name_array2[1] || 'th')] || street_name_array2[2 : array_upper(street_name_array2, 1)]

	END

ELSE street_name_array2

END as new_street_name_array

from properties2

		)



select	-- *,
	id,
	uid,
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

-- select * from new_properties limit 50;