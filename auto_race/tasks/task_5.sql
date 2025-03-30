WITH CarResults AS (
    SELECT 
        c.name AS car_name, 
        c.class AS car_class, 
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count, 
        cl.country AS car_country
    FROM Results r
    JOIN Cars c ON r.car = c.name
    JOIN Classes cl ON cl.class = c.class
    GROUP BY c.name, c.class, cl.country
    HAVING AVG(r.position) > 3.0
),

ClassResults AS (
    SELECT 
        c.class AS car_class, 
        COUNT(DISTINCT c.name) AS car_count,
        COUNT(r.race) AS total_races
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY c.class
)

SELECT 
    cr.car_name, 
    cr.car_class, 
    cr.average_position, 
    cr.race_count, 
    cr.car_country, 
    cls.total_races, 
    cls.car_count AS low_position_count
FROM CarResults cr
JOIN ClassResults cls ON cls.car_class = cr.car_class
ORDER BY low_position_count DESC, cr.car_class, cr.average_position;
