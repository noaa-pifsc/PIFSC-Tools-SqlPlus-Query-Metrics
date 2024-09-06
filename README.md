# SQLPlus Query Metrics

## Overview
This project was developed to provide an automated method to capture performance metrics for a suite of Oracle queries using a docker container to execute them with SQL\*Plus.  This project provides a method to capture query metrics in a variety of configurations for flexibility and allows a user to define multiple queries and define the SQL\*Plus connection string to determine which Oracle database instance to execute the queries on.  

## Resources
-   SQLPlus Query Metrics Version Control Information:
    -   URL: git@github.com:noaa-pifsc/PIFSC-Tools-SqlPlus-Query-Metrics.git
    -   Version: 1.2 (Git tag: sqlplus_query_metrics_v1.2)

## Scenarios
-   There are three different scenarios implemented by the docker project:
    -   Local - this scenario deploys the docker container to a local docker host and connects to a local Oracle database
    -   Remote - this scenario deploys the docker container to a remote docker host and connects to a remote Oracle database
    -   Hybrid - this scenario deploys the docker container to a local docker host and connects to a remote Oracle database

## Setup Procedure
-   ### Standalone Implementation
    -   \*Note: this implementation option is provided for standalone tests, where this repository is cloned and prepared for deployment and the user updates the appropriate files below and builds/runs the container  
    -   Clone the SQLPlus Query Metrics repository to a working directory
    -   Update the bash script deployment configuration file ([project_deploy_config.sh](./docker/src/scripts/sh_script_config/project_deploy_config.sh)) with the appropriate values:
        -   project_path is the folder name of the working copy of the repository that will be used to build the container
        -   git_url is the project git URL value
    -   Execute the appropriate docker preparation script stored in the [deployment_scripts](./deployment_scripts) folder to prepare the docker container for deployment in a new working directory
        -   For example use the [prepare_docker_project.local.sh](./deployment_scripts/prepare_docker_project.local.sh) bash script to prepare the Local docker container for deployment in the c:/docker/sqlplus-query-metrics-local folder
    -   Update the SQLPlus configuration script (e.g. c:/sqlplus-query-metrics-local/docker/src/SQL/sqlplus_config/runtime_config.sql) to specify the appropriate values:
        -   V_CSV_OUTPUT_FILE_NAME is the CSV output file name
        -   V_DB_NAME is the database name (captured in CSV output file)
    -   Update the bash script runtime configuration file (e.g. c:/docker/sqlplus-query-metrics-local/docker/src/scripts/sh_script_config/project_runtime_config.sh) with the appropriate values:
        -   csv_output_file_name is the CSV output file name (this must match the V_CSV_OUTPUT_FILE_NAME value in the runtime_config.sql script)
        -   remote_traceroute_destination is the remote traceroute destination (hostname or IP address)
        -   local_traceroute_destination is the local traceroute destination (hostname or IP address)
        -   traceroute_wait_in_s is the total time in seconds between traceroute loop executions
    -   (if applicable) Update the Oracle tnsnames.ora configuration file (e.g. c:/docker/sqlplus-query-metrics-local/docker/src/oracle_configuration/tnsnames.ora) with the appropriate TNSName entry for the given database
    -   Create separate .sql files that each contain the SQL statement (without the ";" character) for each query you would like to capture metrics for using the docker container in the appropriate new working directory's automated_tests (e.g. c:/docker/sqlplus-query-metrics-local/docker/src/SQL/automated_tests) for the local scenario
        -   The name of each .sql file will be used as the "Query Name" in the exported metrics data file and the contents of the file
    -   Optional updates:
        -   Update the docker compose runtime configuration file (e.g. c:/docker/sqlplus-query-metrics-local/docker/docker-compose.prod.yml) to specify repository-specific the volume names and container name
        -   Update the docker compose configuration file (e.g. c:/docker/sqlplus-query-metrics-local/docker/docker-compose.yml) to specify the volume names and image/container names for the forked project
    -   Update the DB_credentials.sql file in the appropriate new working directory to specify the Oracle SQL*Plus database connection string (e.g. c:/docker/sqlplus-query-metrics-local/docker/src/SQL/credentials/DB_credentials.sql) for the local scenario
        -   \*\*Note: Do not commit the credentials for the given database instance/schema in the repository for security reasons
-   ### Forked Repository Implementation
    -   \*Note: this repository can be forked for a specific database instance/schema to make it easier to build and deploy the container to capture metrics for a given database instance/schema.
        -   [SQL*Plus Query Metrics - IBBS](https://github.com/noaa-pifsc/PIFSC-Tools-IBBS-Web-App-Metrics) is provided as an example of how to implement the forked database-specific repository
    -   Update the SQLPlus configuration script [runtime_config.sql](./docker/src/SQL/sqlplus_config/runtime_config.sql) to specify the appropriate values:
        -   V_CSV_OUTPUT_FILE_NAME is the CSV output file name
        -   V_DB_NAME is the database name (captured in CSV output file)
    -   Update the bash script deployment configuration file [project_deploy_config.sh](./docker/src/scripts/sh_script_config/project_deploy_config.sh) to specify the appropriate values:
        -   project_path is the folder name of the working copy of the repository that will be used to build the container
        -   git_url is the project git URL value
    -   Update the bash script runtime configuration file [project_runtime_config.sh](./docker/src/scripts/sh_script_config/project_runtime_config.sh) to specify the appropriate values:
        -   csv_output_file_name is the CSV output file name (this must match the V_CSV_OUTPUT_FILE_NAME value in the runtime_config.sql script)
        -   remote_traceroute_destination is the remote traceroute destination (hostname or IP address)
        -   local_traceroute_destination is the local traceroute destination (hostname or IP address)
        -   traceroute_wait_in_s is the total time in seconds between traceroute loop executions
    -   Update the Oracle tnsnames.ora configuration files (e.g. [tnsnames.local.ora](./docker/src/oracle_configuration/tnsnames.local.ora) for the local scenario) with the appropriate TNSName entry for the given database
    -   Create separate .sql files that each contain the SQL statement (without the ";" character) for each query you would like to capture metrics for in the [automated_tests](./docker/src/SQL/automated_tests)
        -   The name of each .sql file will be used as the "Query Name" in the exported metrics data file and the contents of the file
    -   Update the [README.md](./README.md) file to change the volume names, document title heading, and setup procedure accordingly
    -   Update the docker compose runtime configuration file [docker-compose.prod.yml](./docker/docker-compose.prod.yml) to specify repository-specific the volume names and container name
    -   Update the docker compose configuration file [docker-compose.yml](./docker/docker-compose.yml) to specify the volume names and image/container names for the forked project
    -   Commit the changes to the forked repository

## Building/Running Container (Standalone Implementation Only)
-   Execute the appropriate build and deploy script for the given scenario (e.g. [build_deploy_project.remote.sh](./deployment_scripts/build_deploy_project.remote.sh) for the remote scenario)

## Docker Application Processing
-   The [run_query_metrics.sh](./docker/src/scripts/run_query_metrics.sh) bash script will execute when the container is executed
    -   The script will check the active project_scenario_config.sh file to determine if this is a local, remote, or hybrid scenario.    
        -   The active project_scenario_config.sh file will be determined by which docker preparation script is executed (e.g. [project_scenario_config.local.sh](./docker/src/scripts/sh_script_config/project_scenario_config.local.sh) for the [prepare_docker_project.local.sh](./deployment_scripts/prepare_docker_project.local.sh) preparation script)
    -   Scenarios:
        -   \*Note: the bash script variables are defined in project_config.sh (e.g. c:/docker/sqlplus-query-metrics-local/docker/src/scripts/project_config.sh) for the local scenario)
        -   local: a traceroute will be run in parallel to the $local_traceroute_destination and wait $traceroute_wait_in_s before executing again  
        -   remote: a traceroute will be run in parallel to the $remote_traceroute_destination and wait $traceroute_wait_in_s before executing again
         -   hybrid: a traceroute will be run to the $local_traceroute_destination and $remote_traceroute_destination separately in parallel and wait $traceroute_wait_in_s before executing a given traceroute command
        -   \*Note: the results of each traceroute can be found in the container volume's logs folder (local_traceroute.log and remote_traceroute.log for the local and remote servers respectively)  
    -   The bash script will loop through each .sql file in the automated_tests directory and execute a series of queries to capture metrics about the corresponding query and add a comma-delimited line to the $csv_output_file_name .csv file in the container volume's data folder

## Checking Results
-   Open the docker volume sqlplus-query-metrics-logs to view the log files for the different executions of the docker container
-   Open the docker volume sqlplus-query-metrics-data to view the exported data files for the different queries
    -   Open the query-metrics.csv to view the metrics that were captured for each query execution

## License
See the [LICENSE.md](./LICENSE.md) for details

## Disclaimer
This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.
