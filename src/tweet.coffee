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

  ###
  new CronJob('0 0 21 * * 0', ->
    # '0 0 21 * * 0'

    # Seconds: 0-59
    # Minutes: 0-59
    # Hours: 0-23
    # Day of Month: 1-31
    # Months: 0-11
    # Day of Week: 0-6

    #doTweet('皆さん、進捗どうですか？')
    doTweet('CITERAの皆さん！進捗はどうですか？\nあと27日で津田沼祭だよ！')
  ).start()
  ###



  ###
  new CronJob('0 0 22 2 * 0', ->
    doTweet 'CITERAの皆さん！進捗はどうですか？\nあと20日で津田沼祭だよ！'
  ).start()

  new CronJob('0 0 22 9 * 0', ->
    doTweet 'CITERAの皆さん！進捗はどうですか？\nあと13日で津田沼祭だよ！'
  ).start()
  ###

  ###
  new CronJob('0 0 21 16 * 0', ->
    doTweet 'CITERAの皆さん！進捗はどうですか？あと6日で津田沼祭だよ！\n作品はもう出来たかな？見た目も大切だから、ちゃんとケースに入れようね。私のオススメはTAKACHIのプラケースだよ！'
  ).start()

  new CronJob('0 0 21 17 * 0', ->
    doTweet 'CITERAの皆さん！進捗はどうですか？\nあと5日で津田沼祭だよ！'
  ).start()

  new CronJob('0 0 21 18 * 0', ->
    doTweet 'CITERAの皆さん！進捗はどうですか？\nあと4日で津田沼祭だよ！'
  ).start()
  ###

  new CronJob('0 0 21 19 * 0', ->
    doTweet 'CITERAの皆さん！進捗はどうですか？\nあと3日で津田沼祭だよ！'
  ).start()

  new CronJob('0 0 21 20 * 0', ->
    doTweet 'CITERAの皆さん！進捗はどうですか？\nあと2日で津田沼祭だよ！'
  ).start()

  new CronJob('0 0 21 21 * 0', ->
    doTweet 'CITERAの皆さん！進捗はどうですか？\n明日は津田沼祭だよ！ちゃんと準備できた？'
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
    console.log msg
    t.post 'statuses/update', { status: msg }, (err, data, response) ->
      console.log err

