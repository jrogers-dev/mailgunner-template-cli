#!/usr/bin/env ruby

#Require basic libraries for parsing command line arguments and JSON payload,
#and communicating with the Mailgun API
require 'optparse'
require 'json'
require 'restclient'


#Hash to hold command line arguments to utilize as flags 
args = {p: false}


#Attempt to parse JSON payload
def parse_payload(payload)
  begin
    parsed_payload = JSON.parse(payload, {:symbolize_names => true})
  rescue => e
    puts "Could not parse JSON payload"
    puts e.message
  else
    return parsed_payload
  end
end


#Check JSON payload to ensure it contains the three primary keys necessary 
#for Mailgun's API
def valid_payload?(payload)
  if payload.key?(:api_key) && payload.key?(:domain) && payload.key?(:from) && payload.key?(:to)\
     && payload.key?(:subject) && payload.key?(:body) && payload.key?(:template) && payload.key?(:parameters)
    return true
  else
    puts "Invalid payload: JSON Payload must include key/value pairs for 'api_key', 'domain', 'from'"\
    ", 'to', 'subject', 'template' and 'parameters'"
    return false
  end
end


#Check that the template specified in the payload exists as a file in the templates folder
def valid_template?(payload)
  template_name = payload[:template]
  if File.exists?("./templates/#{template_name}.txt")
    return true
  else
    puts "Invalid template name"
    return false
  end
end


#Open specified template file, and if successful, interpolate parameters
#from payload into the template text
def inject_template(payload)
  template_name = payload[:template]

  begin
    template_file = File.open("./templates/#{template_name}.txt")
  rescue => e1
    puts "Unable to open file ./templates/#{template_name}.txt"
    puts e1.message
  end

  begin
    payload[:body] = template_file.read % payload[:parameters] + payload[:body]
  rescue => e2
    puts "Invalid template parameters: " + e2.message
  else
    return payload
  ensure
    template_file.close
  end
end


#Post processed payload to Mailgun API, which should successfully send an email
def deliver_payload(payload)
  begin
    RestClient.post(
      "https://api:#{payload[:api_key]}"\
      "@api.mailgun.net/v3/#{payload[:domain]}/messages",
      :from => payload[:from],
      :to => payload[:to],
      :subject => payload[:subject],
      :html => payload[:body]
    )
  rescue => e
    puts "Error posting payload to Mailgun API\n"
    puts e.message
  else
    puts "Successfully posted payload to Mailgun API"
  end
end


#Parse command line arguments using OptionParser and use the -p argument
#block to call all other functions
OptionParser.new do |parser|
  parser.on("-p", "--payload PAYLOAD", "A JSON payload encapsulated in single quotes containing 'to', 'subject', 'body' and 'template' key/value pairs at its root") do |payload|
    args[:p] = true
    parsed_payload = parse_payload(payload)
    if valid_payload?(parsed_payload) == true
      if valid_template?(parsed_payload) == true
        processed_payload = inject_template(parsed_payload)
        deliver_payload(processed_payload)
      end
    end
  end
end.parse!


#Exit the script gracefully
if args[:p] == false 
  puts "Exiting: No payload given. Execute script with '-p' argument and a valid JSON payload"
else
  puts "Exiting"
end