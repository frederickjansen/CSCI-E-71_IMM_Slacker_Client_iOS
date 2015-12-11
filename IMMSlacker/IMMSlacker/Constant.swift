//
//  Constant.swift
//  IMMSlacker
//
//  Created by Cornell Wright on 11/30/15.
//  Copyright © 2015 Cornell Wright. All rights reserved.
//

import Foundation

struct Slack {
    /// Slack HTTPS API URLs
    struct URL {
        struct rtm {
            static let start = "https://slack.com/api/rtm.start";
            
        }
        struct channels {
            static let create = "https://slack.com/api/channels.create";
            static let join = "https://slack.com/api/channels.join";
            static let invite = "https://slack.com/api/channels.invite";
        }
    }
    /// Parameter constants as found in Slack data
    struct param {
        static let token = "token";
        static let ok = "ok";
        static let url = "url";
        static let channels = "channels";
        static let name = "name";
        static let channel = "channel";
        static let id = "id";
        static let type = "type";
        static let text = "text";
        static let users = "users";
        static let user = "user";
        static let profile = "profile";
        static let image_32 = "image_32";
        static let color = "color";
        
        static let image = "image";
        static let image_data = "image_data";
    }
    // Message types as found in Slack data
    struct type {
        static let message = "message";
        static let user_typing = "user_typing";
    }
    // User tokens for the Slack bot and user. Note: storing these in a production app is very unsafe and not secure !!!
    struct token {
        static let bot = "xoxb-15107668371-YDHWvRvzWnYb4dKCMtfGRZlB";
        static let admin = "xoxp-10020492535-10634396486-15535136196-57f3ae4fec";
    }
    // Misc. constants, the username of the Slack bot, and don't forget your towel.
    struct misc {
        static let usernames = ["arthur", "ford", "trillian", "zaphod", "marvin", "eddie", "hamma-kavula", "slartibartfast", "deep-thought", "agrajag", "vogon-jeltz"];
        static let bot_name = "i-am-user";
    }
}

struct MessageCenter {
    // Dictionary keys for NSUserDefaults
    struct prefs {
        static let channelID = "channel_id";
    }
    // Notification types as used in the Message Center
    struct notification {
        static let newMessage = "new_message";
        static let userTyping = "user_typing";
    }
}