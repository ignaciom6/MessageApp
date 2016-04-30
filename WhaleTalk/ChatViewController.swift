//
//  ViewController.swift
//  WhaleTalk
//
//  Created by Ignacio on 5/4/16.
//  Copyright © 2016 Ignacio. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController
{
    private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
    private let newMessageField = UITextView()
    
    private var sections = [NSDate: [Message]]()
    private var dates = [NSDate]()
    private var bottomConstraint: NSLayoutConstraint!
    private let cellIdentifier = "Cell"
    
    var context: NSManagedObjectContext?
    
    var chat: Chat?
    
    private enum Error: ErrorType
    {
        case NoChat
        case NoContext
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        do {
            guard let chat = chat else {throw Error.NoChat}
            guard let context = context else {throw Error.NoContext}
            
            let request = NSFetchRequest(entityName: "Message")
            request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            if let result = try context.executeFetchRequest(request) as? [Message] {
                for message in result {
                    addMessage(message)
                }
                dates = dates.sort({$0.earlierDate($1) == $0})
            }
        } catch {
            print("We couldn't fetch")
        }
        
        automaticallyAdjustsScrollViewInsets = false
        
        let newMessageArea = UIView()
        newMessageArea.backgroundColor = UIColor.lightGrayColor()
        newMessageArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newMessageArea)
        
        newMessageField.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(newMessageField)
        newMessageField.scrollEnabled = false
        
        let sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(sendButton)
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.setContentHuggingPriority(251, forAxis: .Horizontal)
        sendButton.setContentCompressionResistancePriority(751, forAxis: .Horizontal)
        sendButton.addTarget(self, action: #selector(ChatViewController.pressedSend(_:)), forControlEvents: .TouchUpInside)
        
        bottomConstraint = newMessageArea.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        bottomConstraint.active = true
        
        let messageAreaConstraints: [NSLayoutConstraint] = [
            newMessageArea.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
            newMessageArea.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
            newMessageField.leadingAnchor.constraintEqualToAnchor(newMessageArea.leadingAnchor,constant:10),
            newMessageField.centerYAnchor.constraintEqualToAnchor(newMessageArea.centerYAnchor),
            sendButton.trailingAnchor.constraintEqualToAnchor(newMessageArea.trailingAnchor, constant:-10),
            newMessageField.trailingAnchor.constraintEqualToAnchor(sendButton.leadingAnchor,constant: -10),
            sendButton.centerYAnchor.constraintEqualToAnchor(newMessageField.centerYAnchor),
            newMessageArea.heightAnchor.constraintEqualToAnchor(newMessageField.heightAnchor, constant:20)
        ]
        
        NSLayoutConstraint.activateConstraints(messageAreaConstraints)
        
        tableView.registerClass(MessageCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "MessageBubble"))
        tableView.separatorColor = UIColor.clearColor()
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 25
        
        let tableViewConstraints: [NSLayoutConstraint] =
            [tableView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
             tableView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor),
             tableView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor),
             tableView.bottomAnchor.constraintEqualToAnchor(newMessageArea.topAnchor)]
        
        NSLayoutConstraint.activateConstraints(tableViewConstraints)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        if let mainContext = context?.parentContext ?? context
        {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contextUpdated:"), name: NSManagedObjectContextObjectsDidChangeNotification, object: mainContext)
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.handleSingleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.scrollToBottom()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        updateBottomConstraint(notification)
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        updateBottomConstraint(notification)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    func updateBottomConstraint(notification: NSNotification)
    {
        if let
            userInfo = notification.userInfo,
            frame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue,
            animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        {
            
            let newFrame = view.convertRect(frame, fromView: (UIApplication.sharedApplication().delegate?.window)!)
            bottomConstraint.constant = newFrame.origin.y - CGRectGetHeight(view.frame)
            UIView.animateWithDuration(animationDuration, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
        
        tableView.scrollToBottom()
    }
    
    func pressedSend(button: UIButton)
    {
        guard let text = newMessageField.text where text.characters.count > 0 else {return}
        
        checkTemporaryContext()
        
        guard let context = context else {return}
        guard let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context)
            as? Message else {return}
        
        message.text = text
        message.isIncoming = false
        message.timestamp = NSDate()
        do
        {
            try context.save()
        }
        catch
        {
            print("There was a problem saving")
            return
        }
        
        newMessageField.text = ""
        view.endEditing(true)
    }
    
    func addMessage(message: Message)
    {
        guard let date = message.timestamp else {return}
        let calendar = NSCalendar.currentCalendar()
        let startDay = calendar.startOfDayForDate(date)
        
        var messages = sections[startDay]
        if  messages == nil{
            dates.append(startDay)
            dates = dates.sort({$0.earlierDate($1) == $0})
            messages = [Message]()
        }
        messages!.append(message)
        messages!.sortInPlace{$0.timestamp!.earlierDate($1.timestamp!) == $0.timestamp!}
        sections[startDay] = messages
    }
    
    func contextUpdated(notification:NSNotification)
    {
        guard let set = (notification.userInfo![NSInsertedObjectsKey] as? NSSet) else {return}
        let objects = set.allObjects
        
        for obj in objects
        {
            guard let message = obj as? Message else {continue}
            if message.chat?.objectID == chat?.objectID
            {
                addMessage(message)
            }
        }
        
        tableView.reloadData()
        tableView.scrollToBottom()
    }
    
    func checkTemporaryContext()
    {
        if let mainContext = context?.parentContext, chat = chat
        {
            let tempContext = context
            context = mainContext
            do
            {
                try tempContext?.save()
            }
            catch
            {
                print("Error saving tempContext")
            }
            
            self.chat = mainContext.objectWithID(chat.objectID) as? Chat
        }
    }
}

extension ChatViewController: UITableViewDataSource
{
    func getMessages(section: Int) -> [Message]
    {
        let date = dates[section]
        return sections[date]!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return dates.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return getMessages(section).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MessageCell
        let messages = getMessages(indexPath.section)
        let message = messages[indexPath.row]
        
        cell.messageLabel.text = message.text
        cell.incoming(message.isIncoming)
        cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        
        let paddingView = UIView()
        view.addSubview(paddingView)
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        paddingView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints:[NSLayoutConstraint] = [
            paddingView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            paddingView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor),
            dateLabel.centerXAnchor.constraintEqualToAnchor(paddingView.centerXAnchor),
            dateLabel.centerYAnchor.constraintEqualToAnchor(paddingView.centerYAnchor),
            paddingView.heightAnchor.constraintEqualToAnchor(dateLabel.heightAnchor, constant: 5),
            paddingView.widthAnchor.constraintEqualToAnchor(dateLabel.widthAnchor, constant: 10),
            view.heightAnchor.constraintEqualToAnchor(paddingView.heightAnchor)
        ]
        NSLayoutConstraint.activateConstraints(constraints)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMM, YYYY"
        dateLabel.text = formatter.stringFromDate(dates[section])
        
        paddingView.layer.cornerRadius = 10
        paddingView.layer.masksToBounds = true
        paddingView.backgroundColor = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1.0)
        
        return view
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.01
    }
}

extension ChatViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return false
    }
}

