#!/usr/bin/ruby
require 'faraday'

class Report
  attr_reader :token, :id_activity

  def initialize(email, password)
    @id_activity = []
    @conn = Faraday.new(
      url: 'https://api.kampusmerdeka.kemdikbud.go.id'
    )

    response = @conn.post('/user/auth/login/mbkm') do |req|
      req.body = { email: email, password: password }.to_json
      req.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'
      req.headers['Content-Type'] = 'application/json'
    end

    response.status == 200 ? @token = JSON.parse(response.body)["data"]["access_token"]
      : abort(JSON.parse(response.body)["error"]["message"])
  end

  def get_id_activity
    response = @conn.get('/mbkm/mahasiswa/active-activities/my') do |req|
      req.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'
      req.headers['Authorization'] = "Bearer #{@token}"
    end

    datas = JSON.parse(response.body)["data"]
    datas.each_with_index do |val, index|
      puts "#{index + 1}. #{val["nama_kegiatan"]} by #{val["mitra_brand_name"]} => #{val["id"]}"
      @id_activity.push(val["id"])
    end
  end
end
