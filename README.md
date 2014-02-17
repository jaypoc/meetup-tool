# Meetup.com Management Tool

**You probably don't need this script! Meetup.com has built in membership functions. This was created since I wanted to manage the memberships manually.**

This script dumps a list of Meetup.com group users and groups them into the following classifications: 
* `current` paid
* `trial` unpaid, less than *n+1* days
* `expired` unpaid, more than *n* days

Note: This version has a user, "Mike R" hard-coded to flad as "current". This should be removed if anybody else uses this script.

## Setup
Download dependencies via NPM:

````
$ npm install
````

Create your **api.key.js** configuration file as follows:
````javascript
var config = { 
  key: "ABCDE1234567890ABCDE123456789"
}
module.exports = config
````

Customize the **Meetup.coffee** script as follows:
````coffeescript
MeetupGroup = require "./meetup_group" # <-- path/file to meetup_group.coffee/.js
config = require "./api.key" # <-- path/file to api.key.js
myGroup = new MeetupGroup
  key: config.key
  group_id: 1234567 # <-- The ID of your group
  expire_after: 45 # <-- How many days you want members in the "trial" period
myGroup.show()
````

## Usage

Execute your scripts from the command line:

````
$ coffee meetup.coffee [all|trial|current|expired]
````
