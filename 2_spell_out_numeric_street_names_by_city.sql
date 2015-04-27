update new_properties
set new_street_name = (
	case when city_id = 15 -- Chilliwack
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		when '2nd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '2nd', 'Second', 'g')

		when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		when '4th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '4th', 'Fourth', 'g')

		when '5th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '5th', 'Fifth', 'g')

		else new_street_name
		end

	when city_id = 104 -- Cultus Lake
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		when '2nd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '2nd', 'Second', 'g')

		when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		else new_street_name
		end

	when city_id = 198 -- Cumberland
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		when '8th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '8th', 'Eighth', 'g')

		when '9th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '9th', 'Ninth', 'g')

		when '10th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '10th', 'Tenth', 'g')

		else new_street_name
		end

	when city_id = 65 -- Duncan
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		when '2nd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '2nd', 'Second', 'g')

		when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		when '4th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '4th', 'Fourth', 'g')

		else new_street_name
		end

	when city_id = 185 -- Gibsons
	then
		case when '2nd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '2nd', 'Second', 'g')

		when '7th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '7th', 'Seventh', 'g')

		when '9th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '9th', 'Ninth', 'g')

		when '15th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '15th', 'Fifteenth', 'g')

		when '17th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '17th', 'Seventeenth', 'g')

		else new_street_name
		end

	when city_id = 572 -- Hazelton
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		else new_street_name
		end

	when city_id = 77 -- Invermere
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		when '4th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '4th', 'Fourth', 'g')

		else new_street_name
		end

	when city_id = 55 -- Kitimat
	then
		case when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		when '4th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '4th', 'Fourth', 'g')

		when '5th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '5th', 'Fifth', 'g')

		when '7th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '7th', 'Seventh', 'g')

		else new_street_name
		end

	when city_id = 44 -- Lake Country
	then
		case when '6th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '6th', 'Sixth', 'g')

		when '8th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '8th', 'Eighth', 'g')

		else new_street_name
		end

	when city_id = 13 -- Nanaimo
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		when '2nd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '2nd', 'Second', 'g')

		when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		when '4th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '4th', 'Fourth', 'g')

		when '5th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '5th', 'Fifth', 'g')

		when '6th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '6th', 'Sixth', 'g')

		when '7th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '7th', 'Seventh', 'g')

		when '8th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '8th', 'Eighth', 'g')

		when '9th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '9th', 'Ninth', 'g')

		when '10th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '10th', 'Tenth', 'g')

		when '12th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '12th', 'Twelfth', 'g')

		when '13th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '13th', 'Thirteenth', 'g')

		when '14th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '14th', 'Fourteenth', 'g')

		else new_street_name
		end

	when city_id = 52 -- Nelson
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		when '2nd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '2nd', 'Second', 'g')

		when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		when '4th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '4th', 'Fourth', 'g')

		when '5th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '5th', 'Fifth', 'g')

		when '6th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '6th', 'Sixth', 'g')

		when '7th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '7th', 'Seventh', 'g')

		when '8th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '8th', 'Eighth', 'g')

		when '9th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '9th', 'Ninth', 'g')

		when '10th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '10th', 'Tenth', 'g')

		when '11th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '11th', 'Eleventh', 'g')

		when '12th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '12th', 'Twelfth', 'g')

		when '13th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '13th', 'Thirteenth', 'g')

		else new_street_name
		end

	when city_id = 18 -- New Westminster
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		when '2nd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '2nd', 'Second', 'g')

		when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		when '4th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '4th', 'Fourth', 'g')
		
		when '5th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '5th', 'Fifth', 'g')

		when '6th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '6th', 'Sixth', 'g')

		when '7th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '7th', 'Seventh', 'g')

		when '8th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '8th', 'Eighth', 'g')

		when '9th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '9th', 'Ninth', 'g')

		when '10th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '10th', 'Tenth', 'g')
		
		when '11th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '11th', 'Eleventh', 'g')

		when '12th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '12th', 'Twelfth', 'g')

		when '13th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '13th', 'Thirteenth', 'g')

		when '14th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '14th', 'Fourteenth', 'g')

		when '15th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '15th', 'Fifteenth', 'g')

		when '16th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '16th', 'Sixteenth', 'g')

		when '17th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '17th', 'Seventeenth', 'g')
		
		when '18th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '18th', 'Eighteenth', 'g')

		when '19th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '19th', 'Nineteenth', 'g')

		when '20th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '20th', 'Twentieth', 'g')

		when '21th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '21th', 'Twenty First', 'g')

		when '23th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '23th', 'Twenty Third', 'g')

		else new_street_name
		end

	when city_id = 63 -- Peachland
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		when '2nd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '2nd', 'Second', 'g')

		else new_street_name
		end

	when city_id = 23 -- Port Moody
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		when '2nd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '2nd', 'Second', 'g')

		when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		else new_street_name
		end

	when city_id = 41-- Powell River
	then
		case when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		else new_street_name
		end

	when city_id = 121 -- Qualicum Beach
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		when '2nd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '2nd', 'Second', 'g')

		when '4th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '4th', 'Fourth', 'g')

		when '5th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '5th', 'Fifth', 'g')

		when '6th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '6th', 'Sixth', 'g')

		else new_street_name
		end

	when city_id = 154 -- Sidney
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		when '2nd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '2nd', 'Second', 'g')

		when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		when '4th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '4th', 'Fourth', 'g')

		when '5th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '5th', 'Fifth', 'g')

		when '6th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '6th', 'Sixth', 'g')

		when '7th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '7th', 'Seventh', 'g')

		when '8th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '8th', 'Eighth', 'g')

		else new_street_name
		end

	when city_id = 244 -- Smithers
	then
		case when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		when '4th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '4th', 'Fourth', 'g')

		else new_street_name
		end

	when city_id = 46 -- Smithers
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		else new_street_name
		end

	when city_id = 57 -- Trail
	then
		case when '2nd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '2nd', 'Second', 'g')

		when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		when '4th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '4th', 'Fourth', 'g')

		when '5th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '5th', 'Fifth', 'g')

		when '6th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '6th', 'Sixth', 'g')

		when '7th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '7th', 'Seventh', 'g')

		when '8th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '8th', 'Eighth', 'g')

		when '9th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '9th', 'Ninth', 'g')

		when '10th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '10th', 'Tenth', 'g')

		else new_street_name
		end

	when city_id = 14 -- Victoria
	then
		case when '5th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '5th', 'Fifth', 'g')

		else new_street_name
		end

	when city_id = 50 -- Williams Lake
	then
		case when '1st' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '1st', 'First', 'g')

		when '2nd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '2nd', 'Second', 'g')

		when '3rd' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '3rd', 'Third', 'g')

		when '4th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '4th', 'Fourth', 'g')

		when '5th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '5th', 'Fifth', 'g')

		when '6th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '6th', 'Sixth', 'g')

		when '7th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '7th', 'Seventh', 'g')

		when '9th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '9th', 'Ninth', 'g')

		when '10th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '10th', 'Tenth', 'g')

		when '11th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '11th', 'Eleventh', 'g')

		when '12th' = ANY (string_to_array(new_street_name, ' '))
		then regexp_replace(new_street_name, '12th', 'Twelfth', 'g')

		else new_street_name
		end

	else new_street_name
	end
)