WITH AvgPositions AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY c.name, c.class
),
MinAvgPositions AS (
    SELECT
        car_class,
        MIN(average_position) AS min_avg_position
    FROM AvgPositions
    GROUP BY car_class
)
SELECT 
    ap.car_name,
    ap.car_class,
    ap.average_position,
    ap.race_count
FROM AvgPositions ap
JOIN MinAvgPositions mp ON ap.car_class = mp.car_class AND ap.average_position = mp.min_avg_position
ORDER BY ap.average_position;
