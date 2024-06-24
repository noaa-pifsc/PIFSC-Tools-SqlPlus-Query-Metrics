# SQLPlus Query Metrics

## Overview
This project was developed to provide an automated method to capture performance metrics for a suite of Oracle queries using a docker container to execute them with SQL\*Plus.  This project provides a method to capture query metrics in a variety of configurations for flexibility and allows a user to define multiple queries and define the SQL\*Plus connection string to determine which Oracle database instance to execute the queries on.  

## Resources
-   SQLPlus Query Metrics Version Control Information:
    -   URL: git@picgitlab.nmfs.local:centralized-data-tools/sqlplus-query-metrics.git
    -   Version: 1.0 (Git tag: sqlplus_query_metrics_v1.0)

## Scenarios
-   There are three different scenarios implemented by the docker project:
    -   Local - this scenario deploys the docker container to a local docker host and connects to a local Oracle database
    -   Remote - this scenario deploys the docker container to a remote docker host and connects to a remote Oracle database
    -   Hybrid - this scenario deploys the docker container to a local docker host and connects to a remote Oracle database

## Setup Procedure
-   ### Standalone Implementation
    -   \*Note: this implementation option is provided for standalone tests, where this repository is cloned and prepared for deployment and the user updates the appropriate files below and builds/runs the container  
    -   Execute the appropriate docker preparation script stored in the [deployment_scripts](./deployment_scripts) folder to prepare the docker container for deployment in a new working directory
        -   For example use the [prepare_docker_project.local.sh](./deployment_scripts/prepare_docker_project.local.sh) bash script to prepare the Local docker container for deployment in the c:/docker/sqlplus-query-metrics-local folder
    -   Update the SQL calling script query_metrics_calling_script.sql (e.g. c:/docker/sqlplus-query-metrics-local/docker/src/SQL/query_metrics_calling_script.sql) to change the V_DB_NAME variable to the name of the database that is being queried.
    -   Update the DB_credentials.sql file in the appropriate new working directory to specify the Oracle SQL*Plus database connection string (e.g. c:/docker/sqlplus-query-metrics-local/docker/src/SQL/credentials/DB_credentials.sql) for the local scenario
    -   Create separate .sql files that each contain the SQL statement (without the ";" character) for each query you would like to capture metrics for using the docker container in the appropriate new working directory's automated_tests (e.g. c:/docker/sqlplus-query-metrics-local/docker/src/SQL/automated_tests) for the local scenario
        -   The name of each .sql file will be used as the "Query Name" in the exported metrics data file and the contents of the file
    -   (Optional) Update the Oracle tnsnames.ora configuration file (e.g. c:/docker/sqlplus-query-metrics-local/docker/src/oracle_configuration/tnsnames.ora) with the appropriate TNSName entry for the given database
-   ### Forked Repository Implementation
    -   \*Note: this repository can be forked for a specific database instance/schema to make it easier to build and deploy the container to capture metrics for a given database instance/schema.  If this option is chosen the forked repository will still need to execute the [Standalone Implementation](#standalone-implementation) procedure defined above
        -   If this method is chosen the files in the automated_tests will need to be committed and pushed to the remote Git server and the docker preparation scripts will need to be updated to specify the forked repository URL
        -   [SQL*Plus Query Metrics - PARR Tools](https://picgitlab.nmfs.local/query-metrics/sqlplus-query-metrics-parr-tools) is provided as an example of how to implement the forked database-specific repository
    -   Update each of the SQL calling scripts (e.g. [query_metrics_calling_script.hybrid.sql](./docker/src/SQL/query_metrics_calling_script.hybrid.sql) for the hybrid scenario) to change the V_DB_NAME variable to the name of the database that is being queried.
    -   Update each of the docker project preparation bash scripts (e.g. [prepare_docker_project.local.sh](./deployment_scripts/prepare_docker_project.local.sh) for the local scenario) to change the git URL to the URL for the forked repository and optionally to change the deployment folder path.
        -   Update each of the docker project build and deploy bash scripts (e.g. [build_deploy_project.local.sh](./deployment_scripts/build_deploy_project.local.sh) for the local scenario) to change the deployment folder path if it was changed in the docker project preparation bash scripts.
    -   Optional updates:
        -   Update the [query_metrics_export.sql](./docker/src/SQL/query_metrics_export.sql) SQL script to change the output .csv file name  
        -   Update the [run_query_metrics.sh](./docker/src/run_query_metrics.sh) bash script to change the output .csv file name  
    -   Update the docker compose runtime configuration file [docker-compose.prod.yml](./docker/docker-compose.prod.yml) to specify the volume names and container name for the forked project
    -   Update the docker compose configuration file [docker-compose.yml](./docker/docker-compose.yml) to specify the volume names and image/container names for the forked project
    -   Update the [README.md](./README.md) file to change the volume names, document title heading, and setup procedure accordingly
    -   \*\*Note: Do not commit the credentials for the given database instance/schema in the repository for security reasons

## Building/Running Container
-   Execute the appropriate build and deploy script for the given scenario (e.g. [build_deploy_project.remote.sh](./deployment_scripts/build_deploy_project.remote.sh) for the remote scenario)

## Checking Results
-   Open the docker volume sqlplus-query-metrics-logs to view the log files for the different executions of the docker container
-   Open the docker volume sqlplus-query-metrics-data to view the exported data files for the different queries
    -   Open the query-metrics.csv to view the metrics that were captured for each query execution
