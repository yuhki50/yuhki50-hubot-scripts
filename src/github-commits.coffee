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

    require('fs').writeFileSync('/tmp/hubot/' + event + '.log', JSON.stringify(data))

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

    eventMethod(robot, data)


  #Any time any event is triggered (Wildcard Event).
  doWildcardEvent = (robot, data) ->

  #Any time a Commit is commented on.
  doCommitCommentEvent = (robot, data) ->

  #Any time a Branch or Tag is created.
  doCreateEvent = (robot, data) ->

  #Any time a Branch or Tag is deleted.
  doDeleteEvent = (robot, data) ->

  #Any time a Repository has a new deployment created from the API.
  doDeploymentEvent = (robot, data) ->

  #Any time a deployment for the Repository has a status update from the API.
  doDeploymentStatusEvent = (robot, data) ->

  #Any time a Repository is forked.
  doForkEvent = (robot, data) ->

  #Any time a Wiki page is updated.
  doGollumEvent = (robot, data) ->

  #Any time an Issue is commented on.
  doIssueCommentEvent = (robot, data) ->

  #Any time an Issue is opened or closed.
  doIssuesEvent = (robot, data) ->

  #Any time a User is added as a collaborator to a non-Organization Repository.
  doMemberEvent = (robot, data) ->

  #Any time a Pages site is built or results in a failed build.
  doPageBuildEvent = (robot, data) ->

  #Any time a Repository changes from private to public.
  doPublicEvent = (robot, data) ->

  #Any time a Commit is commented on while inside a Pull Request review (the Files Changed tab).
  doPullRequestReviewCommentEvent = (robot, data) ->

  #Any time a Pull Request is opened, closed, or synchronized (updated due to a new push in the branch that the pull request is tracking).
  doPullRequestEvent = (robot, data) ->

  #Any git push to a Repository. This is the default event.
  doPushEvent = (robot, push) ->
#    try
#      if push.commits.length > 0
#        commitWord = if push.commits.length > 1 then "commits" else "commit"
#        robot.send user, "Got #{push.commits.length} new #{commitWord} from #{push.commits[0].author.name} on #{push.repository.name}"
#        for commit in push.commits
#          do (commit) ->
#            gitio commit.url, (err, data) ->
#              robot.send user, "  * #{commit.message} (#{if err then commit.url else data})"
#      else
#        if push.created
#          robot.send user, "#{push.pusher.name} created: #{push.ref}: #{push.base_ref}"
#        if push.deleted
#          robot.send user, "#{push.pusher.name} deleted: #{push.ref}"
#
#    catch error
#      console.log "github-commits error: #{error}. Push: #{push}"

  #Any time a Release is published in the Repository.
  doReleaseEvent = (robot, data) ->

  #Any time a Repository has a status update from the API
  doStatusEvent = (robot, data) ->

  #Any time a team is added or modified on a Repository.
  doTeamAddEvent = (robot, data) ->

  #Any time a User watches the Repository.
  doWatchEvent = (robot, data) ->

