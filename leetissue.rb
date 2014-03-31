require 'excon'
require 'sequel'

OWNER = 'roshfu'
REPO = 'choxi.github.com'
PULL_BRANCH = 'm4k3-7h15-31337'

TARGET_ISSUE = ENV.fetch("TARGET_ISSUE").to_i
abort unless TARGET_ISSUE > 1
TOKEN = ENV.fetch("GITHUB_TOKEN")

DB = Sequel.connect(ENV.fetch("DATABASE_URL"))
# create table flags(key text, value bool);

HEADERS = { 'Accept' => 'application/vnd.github.full+json', 'User-Agent' => 'will'}

def repo_url
  "https://#{TOKEN}:x-oauth-basic@api.github.com/repos/#{OWNER}/#{REPO}"
end

def issue_exists?(issue)
  r = Excon.get("#{repo_url}/issues/#{issue}", headers: HEADERS)
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
  p Excon.post("#{repo_url}/issues", headers: HEADERS, body: %q({"title": "m4k3 7h15 pr0j3c7 m0r3 1337", "body": "7HI5 pr0j37 i5 PR377Y g00D, bU7 N07 wha7 I'D cA11 1337. P3Rhap5 7h3r3 I5 50m3 wAy 70 maK3 i7 m0r3 1337."}))
end

def transform_pull!
  p Excon.post("#{repo_url}/pulls", headers: HEADERS, body: %Q({"issue": "#{TARGET_ISSUE}", "head": "will:#{PULL_BRANCH}", "base": "master" }))
end

def check_db_flag?
  DB[:flags][key: 'ran']
end

def set_db_flag!
  DB[:flags] << {key: 'ran', value: true}
end

loop do
  sleep 60

  if check_db_flag?
    if action_time?
      set_db_flag!
      create_issue!
      sleep 10
      transform_pull!
    end
  end
end


