#keepaliveUrl = process.env.HUBOT_HEROKU_KEEPALIVE_URL or process.env.HEROKU_URL

module.exports = (robot) ->

  robot.hear /deploy (front|admin) dev/i, (res) ->
    inRepo = res.match[1]
    if inRepo != "front"
      res.reply "not compatible."
      return
    else
      repo  = process.env.HUBOT_DEPLOY_REPO_FRONT
      token = process.env.HUBOT_DEPLOY_CIRCLE_TOKEN_FRONT
      branch = "dev"
      $.ajax "https://circleci.com/api/v1.1/project/github/#{repo}/tree/#{branch}?circle-token=#{token}",
        type: "POST"
        headers:
          "Content-Type": "application/json"
        success: (data, textStatus, jqXHR) ->
          res.reply "Please check the build status here: #{data.build_url}"
        error: (jqXHR, textStatus, errorThrown) ->
          res.reply "Deploy error: #{textStatus}"

