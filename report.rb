require 'faraday'

class Report
  attr_reader :token

  def initialize(email, password)
    @conn = Faraday.new(
      url: 'https://api.kampusmerdeka.kemdikbud.go.id'
    )

    response = @conn.post('/user/auth/login/mbkm') do |req|
      req.body = { email: email, password: password }.to_json
      req.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'
      req.headers['Content-Type'] = 'application/json'
    end

    response.status == 200 ? @token = JSON.parse(response.body)["data"]["access_token"]
      : puts(JSON.parse(response.body)["error"]["message"])
  end

end
