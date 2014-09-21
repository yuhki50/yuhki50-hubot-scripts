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
#   None
#
# URLS:
#   POST /hubot/gh-commits?room=<room>[&type=<type]
#
# Authors:
#   yuhki50

url = require('url')
querystring = require('querystring')
gitio = require('gitio2')

module.exports = (robot) ->

  robot.router.post "/hubot/gh-commits", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    res.send 200

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type


    return if req.body.zen? # initial ping
    data = req.body


    event = req.headers['x-github-event'].toLowerCase()
    console.log(event)

    require('fs').writeFileSync('/tmp/hubot/' + event + '-' + (+new Date()) + '.log', JSON.stringify(data))

    eventMethods = {
      '*': doWildcardEvent,
      'commit_comment': doCommitCommentEvent,
      'create': doCreateEvent,
      'delete': doDeleteEvent,
      'deployment': doDeploymentEvent,
      'deployment_status': doDeploymentStatusEvent,
      'fork': doForkEvent,
      'gollum': doGollumEvent,
      'issue_comment': doIssueCommentEvent,
      'issues': doIssuesEvent,
      'member': doMemberEvent,
      'page_build': doPageBuildEvent,
      'public': doPublicEvent,
      'pull_request_review_comment': doPullRequestReviewCommentEvent,
      'pull_request': doPullRequestEvent,
      'push': doPushEvent,
      'release': doReleaseEvent,
      'status': doStatusEvent,
      'team_add': doTeamAddEvent,
      'watch': doWatchEvent
    }

    eventMethod = eventMethods[event]

    return unless eventMethod?

    eventMethod(robot, user, data)


  #Any time any event is triggered (Wildcard Event).
  doWildcardEvent = (robot, user, data) ->

  #Any time a Commit is commented on.
  doCommitCommentEvent = (robot, user, data) ->

  #Any time a Branch or Tag is created.
  doCreateEvent = (robot, user, data) ->

  #Any time a Branch or Tag is deleted.
  doDeleteEvent = (robot, user, data) ->

  #Any time a Repository has a new deployment created from the API.
  doDeploymentEvent = (robot, user, data) ->

  #Any time a deployment for the Repository has a status update from the API.
  doDeploymentStatusEvent = (robot, user, data) ->

  #Any time a Repository is forked.
  doForkEvent = (robot, user, data) ->

  #Any time a Wiki page is updated.
  doGollumEvent = (robot, user, data) ->

  #Any time an Issue is commented on.
  doIssueCommentEvent = (robot, user, data) ->
    do (data) ->
      issue = data.issue
      repository = data.repository

      console.log data

      gitio issue.html_url, (err, data) ->
        msg = "#{issue.sender.login}さんから#{repository.name}リポジトリにIssueのコメントをもらったよ！\nもらったIssueのコメントはこれね。 #{if err then commit.url else data}"

        robot.send user, msg
        doTweet msg

  #Any time an Issue is opened or closed.
  doIssuesEvent = (robot, user, data) ->
    do (data) ->
      issue = data.issue
      repository = data.repository

      gitio issue.html_url, (err, data) ->
        msg = "#{issue.sender.login}さんから#{repository.name}リポジトリにIssueをもらったよ！どうやって解決しようか？ \nもらったIssueはこれね。 #{if err then commit.url else data}"

        robot.send user, msg
        doTweet msg


  #Any time a User is added as a collaborator to a non-Organization Repository.
  doMemberEvent = (robot, user, data) ->

  #Any time a Pages site is built or results in a failed build.
  doPageBuildEvent = (robot, user, data) ->

  #Any time a Repository changes from private to public.
  doPublicEvent = (robot, user, data) ->

  #Any time a Commit is commented on while inside a Pull Request review (the Files Changed tab).
  doPullRequestReviewCommentEvent = (robot, user, data) ->

  #Any time a Pull Request is opened, closed, or synchronized (updated due to a new push in the branch that the pull request is tracking).
  doPullRequestEvent = (robot, user, data) ->

  #Any git push to a Repository. This is the default event.
  doPushEvent = (robot, user, data) ->
    do (data) ->
      pusher = data.pusher
      repository = data.repository
      commits = data.commits
      latestCommit = if commits.length > 0 then commits[commits.length - 1] else {}

      gitio latestCommit.url, (err, data) ->
        #msg = "#{pusher.name}さんが#{repository.name}リポジトリにPushしたよ！忘れずに git fetch してね！ \nPushしたコミットはこれね。 #{if err then latestCommit.url else data}"

        msg = "#{pusher.name}さんが#{repository.name}リポジトリにPushしたよ！忘れずに git fetch してね！"

        unless err
          msg += "\nPushしたコミットはこれね。 #{if err then latestCommit.url else data}"

        robot.send user, msg
        doTweet msg


  #Any time a Release is published in the Repository.
  doReleaseEvent = (robot, user, data) ->

  #Any time a Repository has a status update from the API
  doStatusEvent = (robot, user, data) ->

  #Any time a team is added or modified on a Repository.
  doTeamAddEvent = (robot, user, data) ->

  #Any time a User watches the Repository.
  doWatchEvent = (robot, user, data) ->

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

