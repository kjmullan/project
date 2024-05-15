# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## 1. Introduction

Welcome! This is our application for the project in Semester 2.
The repository contains all the essential things such as controllers, models, database, testings and views.
This web application is about an online learning platform for higher education students.
The users will include Learners, moderators, admin, trusted course providers and managers.

## 2. How to set up before using the application
To git clone the repository (If you don't have access to codio):

1) Open terminal windows

2) Moves to the repository where you want to clone the project to by executing
```console
cd FILENANE
```
3) git clone our git repository by executing 
```console
git clone https://git.shefcompsci.org.uk/com1001-2022-23/team03/project.git
```

4) Enter your user id and password in order to clone 

To start using the application:
1. Use **cd** command to go into the correct directory which is **web_app**

First:
```console
cd project/
```
then: 
```console
cd web_app/
```
**OR** simply:
```console
cd ~/workspace/project/web_app
```
To check if you are in the right directory, use command **pwd**:
```console
pwd
```

You should see ~/workspace/project/web_app$ 
3) In the web_app directory, install the gem bundle by command bundle install
```console
bundle install
```

## 3. How to use the application
1) After bundle install, in the same directory, run command **sinatra app.rb** to start the application: 
```console
sinatra app.rb
```
2) Click the link showing in the terminal which will look similar to: https://julietblonde-aromaprince-4567.codio.io/

3) Congratulation! You will now be able to use the application.

4) Remember to sign up an account before using by clicking the create account link.

To sign up: Pick your username and password and your user type.
Note: Standard usernames and passwords have been added to the database. Please see the table below:

| Types of users                   | Username           | Password         |
| :--------------------------------| :----------------: | :---------------:|
| Learners                         |  learner1          | learner1         |
|                                  |  learner2          | learner2         |
| Moderators                       |  moderator1        | moderator1       |
|                                  |  moderator2        | moderator2       |
| Admin                            |  admin1            | admin1           |
| Managers                         |  manager1          | manager1         |
|                                  |  manager2          | manager2         |
| Trusted course provider          |  tprovider1        | tprovider1       |
|                                  |  tprovider2        | tprovider2       |

To stop the application:
1. Make sure that you log out from the application
2. In terminal, execute shortcut ctrl + c
```console
Ctrl + c
```

### Common error when running the application
Sometimes, the database might be accidentally cleared and this might cause an initialisation problem of database and sinatra won't run
To resolve this issue:
1. Move to the right directory by executing:
```console
cd project/web_app/db/
```
2. Check if you are in the right directory by executing:
```console
pwd
```
You should see **/home/codio/workspace/project/web_app/db**

3. Start sqlite3 by executing:
```console
sqlite3
```

4. Open the correct sqlite file to read the sql file by executing:
```console
.open db.sqlite3
``` 

5. To read the sql file, execute:
```console
.read db.sql
```

6. The database has now been initialised, quit sqlite3 by executing:
```console
.quit
```

7. Now move to the web_app directory by executing:
```console
cd ~/workspace/project/web_app
```

8. Try executing sinatra to run the application again:
```console
sinatra app.rb
```

It should be running again, if not, please contact us via our email.
**Note:** As database is being initialised, the data that have been put in will be refreshed and have to be inserted again except for the default usernames and passwords

## 4. How to test the system
To run the **all the tests**:
1. Move to the right directory web_app in terminal by executing:
```console
cd ~/workspace/project/web_app
```
2.  Execute 
```console
rspec 
```
3. You can now see all the test results in the terminal

To run **unit testing** :
1) Move to the right directory **/unit** by executing:
```console
cd ~/workspace/project/web_app/spec/unit
```
2) Make sure you are in the right directory by executing:
```console
pwd
```
You should see **~/workspace/project/web_app/spec/unit$** 
3) To run test, execute rspec FILENAME.rb in terminal:
```console
rspec FILENAME.rb
```
4) You can now see which tests have passed or fail in the terminal.

To run **end-to-end testing**:
1) Move to the right directory **/feature** by executing:
```console
cd ~/workspace/project/web_app/spec/feature
```
2) Make sure you are in the right directory by executing:
```console
pwd
```
You should see **~/workspace/project/web_app/spec/feature$** 
3) To run test, execute rspec FILENAME.rb in terminal:
```console
rspec FILENAME.rb
```
4) You can now see which tests have passed or fail in the terminal.

## 5. What's in the repository
The repository consists of 7 main directories:
* `controllers` contains controllers to access pages
* `db` contains databases and tables for all the forms
* `log` contains all the interaction with the system
* `models`  contains models for all the functions
* `public` contains all the images and css stylesheets
* `spec` contains all the tests, unit tests, integrated tests etc for the application
* `views` contains all the htmls for all the pages 

## 6. Types of users in this application
| Types of users                   | Accesses                                                                        | Views                                |
| :--------------------------------| :-----------------------------------------------------------------------------: | :-----------------------------------:|
| Admin                         |  Enroll courses, record background, rate courses, change details and password   | Dashboard, Courses Account, Contact  |
| Supporter                       |  Add, edit, remove, hide or reveal courses                                      | Courses                              |
| Loved Ones                       |  Change password, details, suspend accounts                                     | Account, settings,                   |
| Young Person                         |  See reports and summaries for courses                                          | Summaries, Report                    |
| Trusted course provider          |  Provide, edit and delete courses                                               | Main page                            |



