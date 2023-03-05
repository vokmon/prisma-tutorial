# Working with Prisma migration

Here are some useful links and commands for working with Prisma:

- [Deep Dive into Database Workflows with Prisma Migrate](https://prismaio.notion.site/Deep-Dive-into-Database-Workflows-with-Prisma-Migrate-d435a698d97144daaeb6f61f99c52dbf)
- [Prisma Quickstart Guide](https://www.prisma.io/docs/getting-started/quickstart)
- [YouTube Tutorial](https://www.youtube.com/watch?v=BkUH_6BSFyo)

## Setup database on cloud
- [https://app.supabase.com/](https://app.supabase.com/)

## Setting up Prisma

To set up Prisma for your app using PostgreSQL:

1. Run `npx prisma init --datasource-provider postgresql`.
2. Set the `DATABASE_URL` in the `.env` file to point to your existing database. If your database has no tables yet, read the [Getting Started Guide](https://pris.ly/d/getting-started).
3. Set the `SHADOW_DATABASE_URL` in the `.env` file to point to your existing database. Read the [to set up shadow database on cloud](https://www.prisma.io/docs/concepts/components/prisma-migrate/shadow-database).
4. Run `prisma db pull` to turn your database schema into a Prisma schema.
5. Run `prisma generate` to generate the Prisma Client. You can then start querying your database.

<br>

## Command usage

Command usage: `$ prisma [command]`

Available commands:

- `init`: Setup Prisma for your app
- `generate`: Generate artifacts (e.g. Prisma Client)
- `db`: Manage your database schema and lifecycle
- `migrate`: Migrate your database
- `studio`: Browse your data with Prisma Studio
- `validate`: Validate your Prisma schema
- `format`: Format your Prisma schema

Flags:

- `--preview-feature`: Run Preview Prisma commands


Examples

- Setup a new Prisma project
  ```
  $ npx prisma init
  ```

- Generate artifacts (e.g. Prisma Client)
  ```
  $ npx prisma generate
  ```

- Browse your data
  ```
  $ prisma studio
  ```

- Create migrations from your Prisma schema, apply them to the database, generate artifacts (e.g. Prisma Client)
  ```
  $ prisma migrate dev
  ```

- Pull the schema from an existing database, updating the Prisma schema
  ```
  $ prisma db pull
  ```

- Push the Prisma schema state to the database
  ```
  $ prisma db push
  ```

<br>


## Prisma Schema Synchronization and Migration

- synchronizes the Prisma schema with the database schema without persisting a migration to a file.
  ```
  npx prisma db push
  ```

- unlike `npx prisma db push`, automatically generates a history of SQL migration files which it uses to keep track of the database state. For cloud databases, see [Shadow Database](https://www.prisma.io/docs/concepts/components/prisma-migrate/shadow-database).
  ```
  npx migrate dev
  ``` 

- To only create a migration file.
  ```
  npx prisma migrate dev --name initial-migration --create-only
  ```

- To create and apply a migration file.
  ```
  npx prisma migrate dev --name initial-migration
  ```

- To apply a migration.
  ```
  npx prisma migrate dev
  ```

- To mark the previous migration as rolled back.
  ```
  npx prisma migrate resolve --rolled-back
  ```

- To deploy the change from the last migration.
  ```
  npx prisma migrate deploy
  ```
- `Revert the changes using prisma migrate diff and db execute.` To create a schema diff. Prisma compares the schema.prisma file with the actual database. It will use schema.prisma as the source of truth. This command will generate `
DROP TABLE "Order";` if there is no Order in the schema.prisma file. <br>

  - Find the diff with `npx prisma migrate diff`
    - from the database (using the URL)
    - to the schema datamodel
    - output the SQL into a file called `rollback.sql`
    ```
    npx prisma migrate diff --from-url "DATABASE_URL" --to-schema-datamodel ./prisma/schema.prisma --script > rollback.sql
    ```

  - To apply the change to the database
    ```
    npx prisma db execute --url "DATABASE_URL" --file rollback.sql
    ```

- `Moving forward and applying missing changes` 
  - Move the database schema ahead of the Prisma schema – including the migration history and migrations table
  - Move the Prisma schema, migration history, and migrations table forward
  - Find the diff with `npx prisma migrate diff`
    - from your Prisma schema data models
    - to the database (using the URL)
    - output the SQL into a file called `migration.sql`

      ```
      npx prisma migrate diff --from-schema-datamodel ./prisma/schema.prisma  --to-url "DATABASE_URL" --script > migration.sql
      ```
  - Create a folder in the `./prisma/migrations` and move the generated file to the created folder.
  - Mark the migration as applied using the `npx prisma migrate resolve`. This command will update the _prisma_migration table to mark that the newly generated migration.sql is already apply.
    ```
    npx prisma migrate resolve --applied "folder_name"
    ```
  - Run `npx prisma db pull` to now sync the changes in the Prisma schema:
    ```
    npx prisma db pull
    ```


<br><br>

## Practices

1. Generate a draft migration first <br>
  ```
  npx prisma migrate dev --name rename-description-field --create-only
  ```

2. Validate the draft migration sql and update it

3. Run migrate command <br>
  ```
  npx prisma migrate dev
  ```

<br><br>

## Important

1. In a development environment, use the `migrate dev` command to generate and apply migrations:
    ```
    npx prisma migrate dev

    npx prisma migrate dev --create-only
    ```
    **Note:** `npx prisma migrate dev` is a development command and should never be used in a production environment.


2. Reset the database yourself to undo manual changes or database push experiments by running:
    ```
    npx prisma migrate reset
    ```
    **Note:** `npx prisma migrate reset` is a development command and should never be used in a production environment.
    This command will remove all the tables and apply all the migration files again. All data will be lost.


3. In production and testing environments, use the `npx prisma migrate deploy` command to apply migrations:
    ```
    npx prisma migrate deploy
    ```
    **Note:** `npx prisma migrate deploy` should generally be part of an automated CI/CD pipeline, and we do not recommend running this command locally to deploy changes to a production database.



