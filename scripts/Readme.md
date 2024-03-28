# Managing PG Admin/Postgres

## Postgres

In practice, I expect this to be better managed by data PDEs than me, but one option for setting up multiple databases and limiting access to specific Postgres users is considered within [this SQL script](./create_db_and_user_with_limited_access.sql)

## PG Admin

Creating users within PG Admin has been flagged as a painful process, so a potential automation using the Playwright end-to-end testing framework with Python.

To use that:

Optionally:  set up & activate your virtual environment for Python:
- `python -m venv .venv`
- `.venv\ScriptS\activate` (Assumes Windows)

Once you're in the environment you want, then install the requirements with:
- `pip install -r requirements.txt`
  - (You may need to use `python -m pip install -r requirements.txt` within a Corndel environment)
- `python -m playwright install` - to install the browsers/drivers that Playwright wants to use

You can then prep the `create_pg_admin_users.py` script by modifying the variables at the top (`pgadmin_url`, `username`, `password` representing the PGAdmin address and your credentials, and `users_to_create` to define the accounts you want to set up)

And finally run the script with:
`python create_pg_admin_users.py`

It is set to run in headed mode, so you should see a browser pop up and visibly see the users being added.

### WARNING

DO NOT COMMIT CHANGES THAT INCLUDE YOUR PASSWORD.

Improving this by importing sensitive variables through `python-dotenv` would be a nice improvement.