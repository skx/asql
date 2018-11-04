Homepage:
    http://www.steve.org.uk/Software/asql/

Git Repository:
    http://git.steve.org.uk/skx/asql


asql
----

ASQL is a simple tool to allow you to query Apache common logfiles
via SQL. (Only "Apache common" logfiles are currently supported.)

When asql starts up it creates a temporary SQLite database to hold
the contents of the parsed logfile(s) you might load.  This temporary
database may then be queried directly via SQL.

Why might you want to do this?  Well it does allow you to make certain
queries very easily.


Aliases
-------

Using the 'alias' command you may record and replay previous
queries by name, along with variable expansion.

For example the following query will show the number of hits
against your server:

     SELECT COUNT(id) FROM logs;

You could save this query via this:

     ALIAS hits SELECT COUNT(id) FROM logs;

Now at any future point entering 'hits' would run the query.

If you wish you can use variables in aliases such as:

     ALIAS hitsagent SELECT * FROM logs where agent like '%$1%';

The text `$1` will be replaced by the first argument you supply to the alias when running it:

     hitsagent mozilla
     hitsagent Slurp

You can use variables from $1 to $9.

(Aliases persist between sessions via the file `~/.asql.aliases`.)


Example Queries
---------------

The following examples give an idea of the kind of power an SQL query allows you:

Greediest downloaders:

     SELECT source,SUM(size) AS Number FROM logs GROUP BY source ORDER BY Number DESC, source

A count of each distinct referers:

     SELECT referer,COUNT(referer) AS number from logs WHERE referer NOT LIKE '%steve.org.uk%' GROUP BY referer ORDER BY number DESC,referer LIMIT 0,10


See which Debian packages were downloaded the most:

     SELECT request,COUNT(request) AS Number FROM logs WHERE request LIKE '%.deb' GROUP BY request ORDER BY Number DESC, request;


See who has downloaded me:

      select * FROM logs WHERE request='/etch/pool/main/a/asql/asql_0.6-1_all.deb';


Dependencies
------------

For parsing IPv6 log entries the Regexp::IPv6 module is required.


Steve
--
