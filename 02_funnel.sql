SELECT
    step_num,
    step_name,
    users_count,
    round(users_count / maxOver * 100, 1) AS conversion_pct
FROM (
    SELECT
        step_num,
        step_name,
        users_count,
        max(users_count) OVER () AS maxOver
    FROM (
        SELECT 1 AS step_num, 'app_open' AS step_name,
            uniq(user_id) AS users_count
        FROM events WHERE event_type = 'app_open'
        UNION ALL
        SELECT 2, 'view_product',
            uniq(user_id)
        FROM events WHERE event_type = 'view_product'
        UNION ALL
        SELECT 3, 'add_to_cart',
            uniq(user_id)
        FROM events WHERE event_type = 'add_to_cart'
        UNION ALL
        SELECT 4, 'begin_checkout',
            uniq(user_id)
        FROM events WHERE event_type = 'begin_checkout'
        UNION ALL
        SELECT 5, 'purchase',
            uniq(user_id)
        FROM events WHERE event_type = 'purchase'
    )
)
ORDER BY step_num;