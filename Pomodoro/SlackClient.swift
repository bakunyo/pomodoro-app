//
//  SlackClient.swift
//  Pomodoro
//
//  Created by Izuta Hiroyuki on 2017/01/01.
//  Copyright © 2017年 Izuta Hiroyuki. All rights reserved.
//

import Foundation
import SlackKit

class : MessageEventsDelegate {
    let bot: SlackKit
    init(token: String) {
        bot = SlackKit(withAPIToken: token)
        bot.onClientInitalization = { (client: Client) in
            client.messageEventsDelegate = self
        }
    }
    
    func received(_ message: Message, client: Client) {
        guard let text = message.text, let channel = message.channel else { return }
        if text == "swift" {
            client.webAPI.sendMessage(channel,
                                      text: "https://github.com/apple/swift",
                                      asUser: true,
                                      success: nil,
                                      failure: nil)
        }
    }
}
