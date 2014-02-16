Sugar = require 'sugar'
Meetup = require 'meetup'

class MeetupGroup
  constructor: (args = {}) ->
    this.group_id = args.group_id || null
    this.key = args.key || null
    this.expire_after = args.expire_after || null

    this.conn = new Meetup
    this.members = []

  get_profiles: (callback) ->
    this.members = []
    params =
      key: this.key
      group_id: this.group_id
      fields: "membership_dues"
    this.conn.get "/2/profiles", params, (err, data) =>
      parsed = JSON.parse data        
      parsed.results.each (profile) =>
        this.members.push this.updated_profile(profile)
      callback()
  
  updated_profile: (profile) ->
    today = (new Date).getTime()
    name    = profile.name 
    joined  = profile.created 
    status  = profile.membership_dues.period_status
    days    = ((today-joined) / 86400000).round(0)
    profile.status = "expired" if days > this.expire_after-1 and status == "unpaid" and name != "Mike R"
    profile.status = "current" if status == "paid" or name == "Mike R"
    profile.status = "trial" if days < this.expire_after and status == "unpaid"               
    profile.joined = (new Date(joined)).format("{MM}/{dd}/{yyyy}")
    profile.days = days
    profile

  show_member: (member, conditional=null) ->
      console.log "  #{member.name} (Joined #{member.days} days ago on #{member.joined})" if member.status == conditional

  show: () ->
    this.get_profiles () =>
      status = process.argv[2] || null
      console.log "Selected #{status}"
      if !status
        console.log "Please specify a status. ie:\n  node meetup.js [all|trial|current|expired]"
      else
        if status == "all"
          console.log "CURRENT"
          this.members.each (member) =>
            this.show_member member, "current"
          console.log "TRIAL"
          this.members.each (member) =>
            this.show_member member, "trial"
          console.log "EXPIRED"
          this.members.each (member) =>
            this.show_member member, "expired"
        else
          this.members.each (member) =>
            this.show_member member, status

module.exports = (args={}) -> new MeetupGroup(args)