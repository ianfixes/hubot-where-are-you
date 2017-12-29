# Description:
#   Basic diagnostic behavior
#
# Commands:
#   hubot where are you - Get repository and hostname of running instance
#
# Author:
#   Ian Katz <ianfixes@gmail.com>
#
# Notes:
#   The bot is assumed to be managed by a git repo, and running on
#   a machine with git installed.  Otherwise, the environment var
#   HUBOT_REPO_URL can be set to convey this information


child_process = require 'child_process'
os = require 'os'

determineRepo = () ->
  gitQuery = child_process.spawnSync('git', ['ls-remote', '--get-url', 'origin'])
  if !gitQuery.error?
    gitQuery.stdout.toString()
  else if process.env.HUBOT_REPO_URL?
    process.env.HUBOT_REPO_URL
  else
    "<undefined; no git response and no HUBOT_REPO_URL env var>"

determineIPs = () ->
  addresses = for _, ifaces of os.networkInterfaces()
    for f in ifaces when f.family == 'IPv4' && !f.internal
      f.address

  [].concat.apply([], addresses)

determineIP = () ->
  ips = determineIPs()
  return null if ips.length == 0
  ips[0]

determineLastOctet = () ->
  ip = determineIP()
  return null unless ip?
  /\d+\.\d+\.\d+\.(\d+)/.exec(ip)[1]

host = os.hostname()
repo = determineRepo()
ip = determineLastOctet()

module.exports = (robot) ->

  robot.respond /where are you/, (msg) ->
    msg.send "I'm running on #{host}\nMy git repo URL is:\n>#{repo}"

  robot.hear /all bots report in/, (msg) ->
    msg.send "@#{robot.name} standing by"

  robot.hear /all wings report in/, (msg) ->
    callsign = if ip? then "Red #{ip}" else "@#{robot.name}"
    msg.send "#{callsign} standing by"
