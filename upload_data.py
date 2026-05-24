import clickhouse_connect
import pandas as pd

client = clickhouse_connect.get_client(
    host='',      
    port=8443,
    username='default',
    password='',   
    secure=True
)

users_df = pd.read_csv('data/users.csv')
sessions_df = pd.read_csv('data/sessions.csv')
events_df = pd.read_csv('data/events.csv')

users_df['registered_at'] = pd.to_datetime(users_df['registered_at'])
sessions_df['started_at'] = pd.to_datetime(sessions_df['started_at'])
sessions_df['ended_at'] = pd.to_datetime(sessions_df['ended_at'])
events_df['event_time'] = pd.to_datetime(events_df['event_time'])

client.insert_df('users', users_df)
print(len(users_df))

client.insert_df('sessions', sessions_df)
print(len(sessions_df))

batch_size = 100_000
for i in range(0, len(events_df), batch_size):
    batch = events_df.iloc[i:i+batch_size]
    client.insert_df('events', batch)
    print(min(i+batch_size, len(events_df)) / len(events_df))

result = client.query("SELECT count() FROM events")
print(result.result_rows[0][0])