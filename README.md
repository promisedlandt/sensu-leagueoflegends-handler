sensu-leagueoflegends-handler
=============================

# Purpose

Use this to send [Sensu](https://github.com/sensu/sensu) notifications to your League of Legends client.

# Prerequisites

This needs the [XMPP4R](http://home.gna.org/xmpp4r/) gem installed on the Sensu server.

Additionally, you need two League of Legends accounts - one to send the notifications from (any old lvl 1 account will do), and one account to send the message to (i.e. the account you're wasting your weekends on).

These accounts need to be on each others friends list.

# Usage

Put the json file in `/etc/sensu/conf.d` and edit it according to the instructions below.

Put the rb file in `/etc/sensu/handlers`.

Add `"leagueoflegends"` to your handler set.

# Configuration

The following settings are available in the JSON file:

 * `sender_name`: Login name of the account you want to send the message from.
 * `sender_password`: Password of the account you want to send the message from.
 * `server`: One of "euw", "na" or "eune". Alternatively, you can specify the chat server dns or IP directly here.
 * `target_summoner_name`: Summoner name (not login name!) of the account you want to notify.
