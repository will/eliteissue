require 'excon'

TOKEN = ENV.fetch("GITHUB_TOKEN")
REPO = ENV.fetch("REPO")
TARGET_ISSUE = ENV.fetch("TARGET_ISSUE").to_i
abort unless TARGET_ISSUE > 1

HEADERS = { 'Accept' => 'application/vnd.github.full+json', 'User-Agent' => 'will'}
def issues_url
  "https://#{TOKEN}:x-oauth-basic@api.github.com/repos/#{REPO}/issues"
end

def issue_exists?(issue)
  r = Excon.get("#{issues_url}/#{issue}", headers: HEADERS)
  r.status == 200
end

def prev_exists?
  issue_exists?(TARGET_ISSUE-1).tap {|b| puts "  prev: #{b}"}
end

def target_exists?
  issue_exists?(TARGET_ISSUE).tap {|b| puts "target: #{b}"}
end

def action_time?
  (prev_exists? && !target_exists?).tap {|b| puts "action: #{b}"}
end

def create_issue!
  p Excon.post("#{issues_url}", headers: HEADERS, body: %q({"title": "m4k3 7h15 pr0j3c7 m0r3 1337", "body": "7HI5 pr0j37 i5 PR377Y g00D, bU7 N07 wha7 I'D cA11 1337. P3Rhap5 7h3r3 I5 50m3 wAy 70 maK3 i7 m0r3 1337."}))
end

create_issue! if action_time?


# leetissue ➤ TARGET_ISSUE=8 REPO="heroku/reception" foreman run ruby leetissue.rb
# prev: true
# target: true
# actiontime? false
# leetissue ➤ TARGET_ISSUE=9 REPO="heroku/reception" foreman run ruby leetissue.rb
# prev: true
# target: false
# actiontime? true
# leetissue ➤ TARGET_ISSUE=8 REPO="heroku/reception" foreman run ruby leetissue.rb
# prev: true
# target: true
# actiontime? false
# leetissue ➤ TARGET_ISSUE=8 REPO="heroku/reception" foreman run ruby leetissue.rb
# prev: true
# target: true
# actiontime? false
# leetissue ➤ TARGET_ISSUE=10 REPO="heroku/reception" foreman run ruby leetissue.rb
# prev: false
