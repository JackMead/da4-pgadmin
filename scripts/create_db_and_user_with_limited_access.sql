'''
Acknowledgements:
0. I am not a SQL expert, there may well be a better approach
1. Learners will be able to see the names of other learners
  - Can be solved by separating into multiple Postgres servers
2. Learners will be able to see the names of other DBs
  - Encourage learners to restrict to a specific DB in their connection
  - If only to make their life easier in avoiding clutter!
  - Dont use sensitive db names (potentially all learners share one DB)
3. Learners _may_ be able to derive information about the public schemas of databases they do not have access to
  - ChatGPT warns me of this
  - But on further pushing, fails to provide any mechanism, and accepts that they can\'t
  - I don\'t think we care too much, since the names of schema/tables should not be sensitive
  - The contents of schema will remain confidential
'''

-- Create user2 and user2's database
CREATE DATABASE user1db;
CREATE USER user1 WITH ENCRYPTED PASSWORD 'user1password';
GRANT ALL PRIVILEGES ON DATABASE user1db TO user1;

CREATE DATABASE user2db;
CREATE USER user2 WITH ENCRYPTED PASSWORD 'user2password';
GRANT ALL PRIVILEGES ON DATABASE user2db TO user2;

REVOKE CONNECT ON DATABASE user1db FROM PUBLIC;
GRANT CONNECT ON DATABASE user1db TO user1;
REVOKE CONNECT ON DATABASE user2db FROM PUBLIC;
GRANT CONNECT ON DATABASE user2db TO user2;