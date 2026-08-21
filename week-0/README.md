# Week 0 — Onboarding

## Task

Set up and verify the working environment required for the DACA programme and establish a working connection between the main tools used during the course.

## Tools

- Supabase — PostgreSQL database
- VS Code — development environment
- SQLTools — PostgreSQL connection and SQL execution from VS Code
- Git and GitHub — version control and portfolio storage
- NotebookLM — course materials and reference sources

## Database Connection

I connected VS Code to my Supabase PostgreSQL database using SQLTools and verified that SQL queries can be executed successfully from VS Code.

The connection was tested using `test_connection.sql`.

I also created `hello_urbanstyle.sql` to query the `team_members` practice table:

SELECT id, name, role, week, joined_at
FROM team_members
ORDER BY id;

## Verification

I verified that:
- the Supabase project is accessible;
- VS Code can connect to Supabase through SQLTools;
- SQL queries can be executed successfully from VS Code;
- the query results match the practice data in Supabase;
- Git is connected to my GitHub repository;
- my Week 0 files can be committed and pushed to GitHub.