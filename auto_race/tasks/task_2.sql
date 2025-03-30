WITH AvgPositions AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        cl.country AS car_country,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.name, c.class, cl.country
),
MinAvgPosition AS (
    SELECT MIN(average_position) AS min_avg_position
    FROM AvgPositions
)
SELECT 
    ap.car_name,
    ap.car_class,
    ap.average_position,
    ap.race_count,
    ap.car_country
FROM AvgPositions ap
JOIN MinAvgPosition mp ON ap.average_position = mp.min_avg_position
ORDER BY ap.car_name
LIMIT 1;
