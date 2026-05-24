SELECT
    cohort_week,
    users_in_cohort,
    week_1_retention,
    week_2_retention,
    week_3_retention,
    week_4_retention,
    round(week_1_retention / users_in_cohort * 100, 1) AS week_1_pct,
    round(week_2_retention / users_in_cohort * 100, 1) AS week_2_pct,
    round(week_3_retention / users_in_cohort * 100, 1) AS week_3_pct,
    round(week_4_retention / users_in_cohort * 100, 1) AS week_4_pct
FROM (
    SELECT
        toMonday(u.registered_at) AS cohort_week,
        count(DISTINCT u.user_id) AS users_in_cohort,
        countDistinctIf(e.user_id, 
            toMonday(e.event_time) = toMonday(u.registered_at) + INTERVAL 1 WEEK
        ) AS week_1_retention,
        countDistinctIf(e.user_id,
            toMonday(e.event_time) = toMonday(u.registered_at) + INTERVAL 2 WEEK
        ) AS week_2_retention,
        countDistinctIf(e.user_id,
            toMonday(e.event_time) = toMonday(u.registered_at) + INTERVAL 3 WEEK
        ) AS week_3_retention,
        countDistinctIf(e.user_id,
            toMonday(e.event_time) = toMonday(u.registered_at) + INTERVAL 4 WEEK
        ) AS week_4_retention
    FROM users u
    LEFT JOIN events e ON u.user_id = e.user_id
    GROUP BY cohort_week
)
ORDER BY cohort_week;