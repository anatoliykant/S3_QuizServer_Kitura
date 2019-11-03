## S3 Quiz Kitura Server

This is an example of **Swift Kitura** backend for **Quiz game**

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