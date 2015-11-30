//
//  IMMSlackerViewController.swift
//  IMMSlacker
//
//  Created by Cornell Wright on 11/30/15.
//  Copyright © 2015 Cornell Wright. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class IMMSlackerViewController: JSQMessagesViewController {

    
    var messages:[JSQMessage] = [JSQMessage]();
    var showTypingIndicatorTimer:NSTimer?;
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.senderId = "1234";
        self.senderDisplayName = "me";
        
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
        
        self.inputToolbar!.contentView!.leftBarButtonItem = nil;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onNewMessageReceived:"), name: MessageCenter.notification.newMessage, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onUserTypingReceived:"), name: MessageCenter.notification.userTyping, object: nil);
        
        IMMSlackerMessageCenterAPI.sharedInstance.configureChat();
        // Do any additional setup after loading the view.
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!)
    {
        let message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text);
        messages += [message];
        
        IMMSlackerSocketAPI.sharedInstance.sendMessage(0, type: "message", channelID: "C0F6U0R5E", text: text);
        
        self.finishSendingMessageAnimated(true);
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return(messages.count)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData!
    {
        return self.messages[indexPath.item];
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        let message = self.messages[indexPath.item];
        let factory = JSQMessagesBubbleImageFactory();
        
        if(message.senderId == self.senderId)
        {
            
            return factory.outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor());
        }
        
        if  let user = IMMSlackerMessageCenterAPI.sharedInstance.users[message.senderId],
            let color = user[Slack.param.color] as? String
            
        {
            // This is the Slack user color
            return factory.incomingMessagesBubbleImageWithColor(IMMSlackerMessageCenterAPI.sharedInstance.colorWithHexString(color));
        }
        
        return factory.outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor());
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath);
        
        // This doesn't really do anything, but it's a good point for customization
        let message = self.messages[indexPath.item];
        
        return cell;
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        
        let message = self.messages[indexPath.item];
        
        if let data = IMMSlackerMessageCenterAPI.sharedInstance.users_avatar[message.senderId]
        {
            return JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: data)!, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault));
        }
        
        return nil;    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func onUserTypingReceived(notification:NSNotification)
    {
        
        self.showTypingIndicator = true;
        
        showTypingIndicatorTimer?.invalidate();
        showTypingIndicatorTimer = nil;
        
        showTypingIndicatorTimer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: Selector("onTypingIndicatorTimerFire"), userInfo: nil, repeats: false);
        
    }
    
    func onNewMessageReceived(notification:NSNotification)
    {
        
        if  let info = notification.userInfo as? [String: String],
            let text = info[Slack.param.text],
            let user = info[Slack.param.user]
        {
            
            let message = JSQMessage(senderId: user, displayName: user, text: text);
            messages += [message];
            
            self.showTypingIndicator = false;
            
            self.collectionView!.reloadData();
            
        }
    }
    
    func onTypingIndicatorTimerFire()
    {
        self.showTypingIndicator = false;
        
        showTypingIndicatorTimer?.invalidate();
        showTypingIndicatorTimer = nil;
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
