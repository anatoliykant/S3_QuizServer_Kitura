## S3 Quiz Kitura Server

This is an example of **Swift Kitura** backend for **Quiz game**

### Table of Contents

- [S3 Quiz Kitura Server](#s3-quiz-kitura-server)
  - [Table of Contents](#table-of-contents)
    - [Project contents](#project-contents)
  - [Requirements](#requirements)
  - [Run](#run)

#### Project contents

This application has been generated with the following capabilities and services, which are described in full in their respective sections below:

* [CloudEnvironment](#configuration)
* [Embedded metrics dashboard](#embedded-metrics-dashboard)
* [Docker files](#docker-files)
* [Iterative Development](#iterative-development)
* [IBM Cloud deployment](#ibm-cloud-deployment)

### Requirements

* [Swift 5](https://swift.org/download/)
* [PostgreSQL](https://www.postgresql.org/download/) for the database

### Run

To build and run the application:

1. `swift build`                        # build swift project
2. `swift package generate-xcodeproj`   # generate xcodeproj file
3. `brew install postgresq`             # install PostgreSQL on localhost
4. `createdb quizdb`                    # cretae database with name **quizdb**
5. `.build/debug/ServerKitura`
or `open in Xcode and Run`              # run server on localhost