Dashing Mailchimp Widget
=
Description
-

A [Dashing](http://shopify.github.com/dashing) widget to display email campaign information using the [Mailchimp](http://mailchimp.com/) API and [Gibbon](https://github.com/amro/gibbon)

Preview
-
![Screen Shot](/assets/images/screen_shot.png "Screen Shot")

Useage
-
To use this widget, copy `mailchimp.coffee`, `mailchimp.html`, and `mailchimp.scss` into the `/widgets/mailchimp` directory of your Dashing app.  This directory does not exist in new Dashing apps, so you may have to create it.  Copy the `mailchimp.rb` file into your `/jobs` folder, and include the Gibbon gem in your `Gemfile`.  Edit the `mailchimp.rb` file to include your Mailchimp API key and, optionally, your Mailchimp campaign id.

To include the widget in a dashboard, add the following to your dashboard layout file:

#####dashboards/sample.erb

```HTML+ERB
...
  <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
    <div data-id="mailchimp" data-view="Mailchimp" data-title="Mailchimp Campaign"></div>
  </li>
...
```

Requirements
-
* [Mailchimp](http://mailchimp.com/) API Key
* The [Gibbon](https://github.com/amro/gibbon) gem
* Optional: Your Mailchimp campaign id

Code
-
#####widgets/mailchimp/mailchimp.coffee

```coffee

class Dashing.Mailchimp extends Dashing.Widget

  ready: ->

  onData: (data) ->
```

#####widgets/mailchimp/mailchimp.html

```HTML
<img class="logo" src="http://kb.mailchimp.com/assets/images/freddie.164712579.svg">

<h1 class="title" data-bind="title"></h1>

<ul class="list-nostyle">
  <li>
  	<span class="column">Opens:</span>
    <span class="value" data-bind="uniq_opens | raw"></span>
  </li>
  <li>
  	<span class="column">Clicks:</span>
    <span class="value" data-bind="uniq_clicks | raw"></span>
  </li>
  <li>
  	<span class="column">Sent:</span>
    <span class="value" data-bind="sent | raw"></span>
  </li>
  <li>
  	<span class="column">Unsubscribes:</span>
    <span class="value" data-bind="unsubscribes | raw"></span>
  </li>
</ul>
```

#####widgets/mailchimp/mailchimp.scss

```SCSS
$background-color:  #52bad5;
$full-color:  rgba(255, 255, 255, 1);
$light-color: rgba(255, 255, 255, 0.7);

.widget-mailchimp {
  background-color: $background-color;
  color: $light-color;
  padding: 0;

  img {
    margin-bottom: 20px;
    height: 100px;
    width: 100px;
  }

  .title {
    font-size: 26px;
  }

  ul {
    margin: 0px 15px;
    text-align: left;
    
    li {
      margin: 7px 0;
    } 
    
    .value {
      float: right;
      color: $full-color;
      font-weight: 600;
      font-size: 20px;
      font-family: 'Open Sans', "Helvetica Neue", Helvetica, Arial, sans-serif;
    }
  }
}
```

#####jobs/mailchimp.rb

```rb
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
```
