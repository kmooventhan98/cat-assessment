class SlackWebhook
  HOOK_SLACK = 'slack'.freeze

  def initialize(payload:)
    @payload = payload
  end

  def notify
    begin
      response = connection.post do |req|
        req.body = {"text": slack_body}.to_json
      end
  
      puts "-----#{HOOK_SLACK}----- Response status: #{response.status}"
      puts "-----#{HOOK_SLACK}----- Response body: #{response.body}"
    
    rescue Faraday::Error => e
      puts "#{HOOK_SLACK} hook Error: #{e.response}"
    end
  end

  private

  attr_reader :payload, :connection

  def connection
    @connection ||= Faraday.new(url: ENV.fetch('slack_webhook_url')) do |faraday|
      faraday.headers['Content-Type'] = 'application/json'
    end
  end

  def slack_body
    if payload[:id].nil?
      "#{payload[:name]} booked appointment  on #{ format_date payload[:date]} 🎉!"
    else
      "#{payload[:name]} modified appointment to #{ format_date payload[:date]} 🎉!"
    end
  end

  def format_date(date)
    date.strftime("%m/%d/%Y %l:%M %p")
  end
end
