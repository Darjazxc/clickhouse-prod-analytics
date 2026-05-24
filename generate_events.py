import uuid
import random
from datetime import datetime, timedelta
import pandas as pd
from faker import Faker
import os

fake = Faker()
random.seed(42)

n_users = 10_000
n_days = 90  # 3 месяца
start_date = datetime(2025, 1, 1)

platforms = ['ios', 'android', 'web']
countries = ['RU', 'US', 'DE', 'BR', 'IN', 'FR', 'GB', 'TR']
age_groups = ['18-24', '25-34', '35-44', '45+']
channels = ['organic', 'paid', 'referral', 'email']

funnel_events = [
    'app_open',
    'view_product',
    'add_to_cart',
    'begin_checkout',
    'purchase'
]

other_events = ['search', 'view_category', 'remove_from_cart', 'view_profile']

def generate_users():
    users = []
    for _ in range(n_users):
        registered_at = start_date + timedelta(
            days=random.randint(0, n_days - 1),
            hours=random.randint(0, 23)
        )
        users.append({
            'user_id': str(uuid.uuid4()),
            'registered_at': registered_at,
            'platform': random.choices(platforms, weights=[40, 45, 15])[0],
            'country': random.choices(countries, weights=[30,20,10,10,10,8,7,5])[0],
            'age_group': random.choices(age_groups, weights=[25, 40, 25, 10])[0],
            'channel': random.choices(channels, weights=[40, 30, 20, 10])[0]
        })
    return pd.DataFrame(users)

def generate_sessions_and_events(users_df):
    sessions = []
    events = []

    for _, user in users_df.iterrows():
        user_id = user['user_id']
        platform = user['platform']
        country = user['country']

        n_sessions = random.randint(1, 20)

        for _ in range(n_sessions):
            session_id = str(uuid.uuid4())
            session_start = user['registered_at'] + timedelta(
                days=random.randint(0, n_days - 1),
                hours=random.randint(0, 23),
                minutes=random.randint(0, 59)
            )

            duration_sec = random.randint(30, 1200)
            session_end = session_start + timedelta(seconds=duration_sec)

            funnel_depth = random.choices(
                [1, 2, 3, 4, 5],
                weights=[40, 25, 20, 10, 5]
            )[0]

            session_events = []
            current_time = session_start

            for i in range(funnel_depth):
                current_time += timedelta(seconds=random.randint(10, 120))
                session_events.append({
                    'event_id': str(uuid.uuid4()),
                    'user_id': user_id,
                    'session_id': session_id,
                    'event_type': funnel_events[i],
                    'event_time': current_time,
                    'platform': platform,
                    'country': country,
                    'properties': '{}'
                })

            n_extra = random.randint(0, 5)
            for _ in range(n_extra):
                current_time += timedelta(seconds=random.randint(5, 60))
                session_events.append({
                    'event_id': str(uuid.uuid4()),
                    'user_id': user_id,
                    'session_id': session_id,
                    'event_type': random.choice(other_events),
                    'event_time': current_time,
                    'platform': platform,
                    'country': country,
                    'properties': '{}'
                })

            events.extend(session_events)
            sessions.append({
                'session_id': session_id,
                'user_id': user_id,
                'started_at': session_start,
                'ended_at': session_end,
                'duration_sec': duration_sec,
                'platform': platform,
                'events_count': len(session_events)
            })

    return pd.DataFrame(sessions), pd.DataFrame(events)


if __name__ == '__main__':
    users_df = generate_users()
    print(len(users_df))

    sessions_df, events_df = generate_sessions_and_events(users_df)
    print(len(sessions_df))
    print(len(events_df))

    os.makedirs('data', exist_ok=True)
    users_df.to_csv('data/users.csv', index=False)
    sessions_df.to_csv('data/sessions.csv', index=False)
    events_df.to_csv('data/events.csv', index=False)