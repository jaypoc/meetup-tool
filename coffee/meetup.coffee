MeetupGroup = require './meetup_group'
config = require './api.key'

lippw = new MeetupGroup
  key: config.key
  group_id: 3363152
  expire_after: 45

lippw.show() 

