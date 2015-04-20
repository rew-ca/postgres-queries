select distinct p.streetname, p.city, c.id
from postal_codes_2015 p, cities c
where c.name ~~* p.city and 
' '  ||  lower(p.streetname)  ||  ' ' similar to  '%( twenty| first | second | third | fourth | fifth | sixth | seventh | eighth | ninth | tenth | eleventh | twelfth | thirteenth | fourteenth | fifteenth | sixteenth | seventeenth | eighteenth | nineteenth | twentieth )%' and provincecode = 'BC' 
order by p.city, p.streetname

