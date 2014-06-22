# Description:
#   An HTTP Listener for notifications on github pushes
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#   "gitio2": "2.0.0"
#
# Configuration:
#   Just put this url <HUBOT_URL>:<PORT>/hubot/gh-commits?room=<room> into you'r github hooks
#
# Commands:
#   twitter
#
# URLS:
#   POST /hubot/gh-commits?room=<room>[&type=<type]
#
# Authors:
#   yuhki50

url = require('url')
querystring = require('querystring')
gitio = require('gitio2')
CronJob = require('cron').CronJob

module.exports = (robot) ->

  new CronJob('0 0 21 * * 0', ->
    # '0 0 21 * * 0'

    # Seconds: 0-59
    # Minutes: 0-59
    # Hours: 0-23
    # Day of Month: 1-31
    # Months: 0-11
    # Day of Week: 0-6

    doTweet('皆さん、進捗どうですか？')
  ).start()


  robot.respond /twitter\s+(.*)$/i, (msg) ->
    message = msg.match[1]

    if message
      doTweet message.replace('\\n', '\n')


  doTweet = (msg) ->
    config = {
      consumer_key: process.env.HUBOT_TWITTER_CONSUMER_KEY
      consumer_secret: process.env.HUBOT_TWITTER_CONSUMER_SECRET
      access_token: process.env.HUBOT_TWITTER_ACCESS_TOKEN
      access_token_secret: process.env.HUBOT_TWITTER_ACCESS_TOKEN_SECRET
    }

    unless config.consumer_key
      console.log "Please set the HUBOT_TWITTER_CONSUMER_KEY environment variable."
      return

    unless config.consumer_secret
      console.log "Please set the HUBOT_TWITTER_CONSUMER_SECRET environment variable."
      return

    unless config.access_token
      console.log "Please set the HUBOT_TWITTER_ACCESS_TOKEN environment variable."
      return

    unless config.access_token_secret
      console.log "Please set the HUBOT_TWITTER_ACCESS_TOKEN_SECRET environment variable."
      return

    Twit = require('twit')
    t = new Twit(config)
    t.post 'statuses/update', { status: msg }, (err, data, response) ->
      console.log err

