# Description:
#   Basic diagnostic behavior
#
# Commands:
#   hubot where are you - Get repository and hostname of running instance
#
# Author:
#   ikatz
#
# Notes:
#   The bot is assumed to be managed by a git repo, and running on
#   a machine with git installed


child_process = require 'child_process'
os = require 'os'

repo = child_process.spawnSync('git', ['ls-remote', '--get-url', 'origin']).stdout.toString()
host = os.hostname()

module.exports = (robot) ->

  robot.respond /where are you/, (msg) ->
    msg.send "I'm running on #{host}\nMy git repo URL is:\n>#{repo}"
