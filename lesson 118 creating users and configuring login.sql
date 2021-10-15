/*if the postgres directory is set in the environment variables
  we can create a user by running a binary file
  in a windows terminal run

  createuser --interactive

  once a user is created we need to set a password.

  Run psql terminal and run the following command: */

ALTER ROLE user_name WITH ENCRYPTED PASSWORD 'password';

/*If you're a superuser wanting to set a postgresql.conf file
  run the command in the psql session to revel the directory in which the file is

  psql -> show config_file*/


/*by default all users connecting to a database within local pc will be granted access.
  No password is required
  If we want to prevent the behaviour we need to set scram-sha-256 in all rows in
  pg_hba.conf file and set password_encryption option to scram-sha-256 in
  postgresql.conf as well

  MIND! If we create a password before those options are changed we won't be able to
  get access to a database with our password since it hasn't been created with the
  encrypt method we select. It's vital to follow the order.
  1) postgresql.conf -> password_encryption = scram-sha-256
  2) ALTER ROLE user_name WITH ENCRYPTED PASSWORD 'password';
  3) change all rows with trust to scram-sha-256 in pg_hba.conf
  4) restart the postgres service
  5) psql -U username database
  6) input encrypted password.
  */
