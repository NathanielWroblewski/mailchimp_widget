require 'gibbon'

SCHEDULER.every '5m', first_in: 0 do |job|
  gibbon = Gibbon::API.new
  gibbon.api_key = ''             # <--- Enter your Mailchimp API key here
  
  cid = gibbon.campaigns.list['data'][0]['id']
  response = gibbon.reports.summary(cid: cid)
  
  send_event('mailchimp', { 
    uniq_opens:   response['unique_opens'],
    uniq_clicks:  response['unique_clicks'],
    sent:         response['emails_sent'],
    unsubscribes: response['unsubscribes']
  })
end
