#!/usr/bin/env ruby
#

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-handler'
require 'xmpp4r/client'
require 'xmpp4r/roster'
include Jabber

class LeagueOfLegendsHandler < Sensu::Handler

  def event_name
    @event['client']['name'] + '/' + @event['check']['name']
  end

  def handle
    if @event['action'].eql?("resolve")
      body = "Sensu RESOLVED - [#{event_name}] - #{@event['check']['notification']}"
    else
      body = "Sensu ALERT - [#{event_name}] - #{@event['check']['notification']}"
    end

    handler_settings = settings['handlers']['leagueoflegends']

    server_dns = { "euw"  => "chat.eu.lol.riotgames.com",
                   "na"   => "chat.na1.lol.riotgames.com",
                   "eune" => "chat.eun1.lol.riotgames.com" }.fetch(handler_settings['server']) || handler_settings['server']

    server_port = handler_settings['port'] || 5223

    client = Client.new(JID::new("#{ handler_settings['sender_name'] }@pvp.net/xiff"))
    client.use_ssl = true
    client.connect(server_dns, server_port)
    client.auth("AIR_#{ handler_settings['sender_password'] }")
    client.send(Presence.new.set_type(:available))

    roster = Roster::Helper.new(client)
    roster.wait_for_roster

    roster.items.select { |id, item| item.to_s =~ /name='#{ handler_settings['target_summoner_name'] }'/i }.each do |jid, item |
      m = Message::new(jid, body).set_type(:chat)
      client.send(m)
    end
  end

end
