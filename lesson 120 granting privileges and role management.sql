/*the key point to remember that tables are available for their owner only.
  If you want another user to get access to the tables you should first grand the
  appropriate privileges.
  Login as a super user and then type the following command*/

GRANT SELECT ON table_name TO user_name;

/*the user would be granted to SELECT a specific table (not all)
  Find out who is the owner type \dt command in the psql session

  the opposite command would be
 */
REVOKE SELECT ON table_name FROM user_name;

/*If you want to grant all privileges to a user specify a schema */

GRANT ALL ON ALL TABLES IN SCHEMA public TO user_name;

/*another way to grant a user privileges is to create a role, assign it privileges and then
  assign the role to the user*/

CREATE ROLE  new_role_name;

GRANT SELECT ON ALL TABLES IN SCHEMA PUBLIC TO new_role_name;

/*to see the role type \du in psql and eventually assign the role to the user*/

GRANT new_role_name TO user_name;

