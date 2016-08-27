//
//  ChatViewController.swift
//  WhatsAppClone
//
//  Created by IMAC on 26/8/16.
//  Copyright © 2016 Andrew Ng. All rights reserved.
//

import UIKit
import Foundation

class ChatViewController: UIViewController {
    
    private let tableView = UITableView()
    private let newMessageField = UITextView()
    
    fileprivate var messages = [Message]()
    private var bottomConstraint: NSLayoutConstraint!
    
    fileprivate let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var localIncoming = true
        
        //Dummy Messages
        for i in 0...10 {
            let m = Message()
           // m.text = String(i)
            m.text = "This is a longer message. How does it look?"
            m.incoming = localIncoming
            localIncoming = !localIncoming
            messages.append(m)
        }
        
        let newMessageArea = UIView()
        newMessageArea.backgroundColor = UIColor.lightGray
        newMessageArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newMessageArea)
        
        newMessageField.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(newMessageField)
        newMessageField.isScrollEnabled = false
        
        
        let sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        newMessageArea.addSubview(sendButton)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(pressedSend), for: .touchUpInside)
        sendButton.setContentHuggingPriority(251, for: .horizontal)
        sendButton.setContentCompressionResistancePriority(751, for: .horizontal)
        
        bottomConstraint = newMessageArea.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.isActive = true
        
        let messageAreaConstraints : [NSLayoutConstraint] = [
            newMessageArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newMessageArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            newMessageField.leadingAnchor.constraint(equalTo: newMessageArea.leadingAnchor, constant: 10),
            newMessageField.centerYAnchor.constraint(equalTo: newMessageArea.centerYAnchor),
            
            sendButton.trailingAnchor.constraint(equalTo: newMessageArea.trailingAnchor, constant: -10),
            newMessageField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            
            sendButton.centerYAnchor.constraint(equalTo: newMessageField.centerYAnchor),
            newMessageArea.heightAnchor.constraint(equalTo: newMessageField.heightAnchor, constant: 20)
            
        ]
        
        NSLayoutConstraint.activate(messageAreaConstraints)
        
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let tableViewConstraints: [NSLayoutConstraint] = [
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: newMessageArea.topAnchor)
        ]
        
        NSLayoutConstraint.activate(tableViewConstraints)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow) , name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
         NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide) , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.handleSingleTap))
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
        
       
    }
    
    //#selector(keyboardWillShow(_:)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        

    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        updateBottomConstraint(notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        updateBottomConstraint(notification: notification)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func updateBottomConstraint(notification: NSNotification) {
        
        let userInfo = notification.userInfo
        let keyboardFrame: CGRect = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //let frame : CGRect = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSValue).cgRectValue
        let newFrame = view.convert(keyboardFrame, from: (UIApplication.shared.delegate?.window)!)
        bottomConstraint.constant = newFrame.origin.y - view.frame.height
        
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            
            self.view.layoutIfNeeded()
            
        })
    }
    
    func pressedSend(button: UIButton) {
        guard let text = newMessageField.text, text.characters.count > 0 else {return}
        let message = Message()
        message.text = text
        message.incoming = false
        messages.append(message)

        
        //let path = NSIndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)
        let lastSectionIndex = self.tableView.numberOfSections - 1
        let lastRowIndex = self.tableView.numberOfRows(inSection: lastSectionIndex)-1
        let pathToLastRow = NSIndexPath(row: lastRowIndex, section: lastSectionIndex)
        
        tableView.reloadData()

        tableView.scrollToRow(at: pathToLastRow as IndexPath, at: .bottom, animated: true)

        

        
    }

        
   
        /*
        
        if let
            userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue,
            let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            
            let newFrame = view.convert(frame, from: (UIApplication.shared.delegate?.window)!)
                //let newFrame = view.convert(frame, from: (UIApplication.shared.delegate?.window)!)
            
                bottomConstraint.constant = newFrame.origin.y - view.frame.height
            
            UIView.animate(withDuration: animationDuration, animations: {
                print(frame)
                print(animationDuration)
                
                self.view.layoutIfNeeded()
                
            })
        }
 
        */
    
    
    
    
    /*
    func keyboardWillHide(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
 
 */
    
}


extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatCell
        let message = messages[indexPath.row]

        cell.messageLabel.text = message.text
        cell.incoming(incoming: message.incoming)
        
        cell.separatorInset = UIEdgeInsetsMake(0, tableView.bounds.size.width, 0, 0)
        
        return cell
        
        
        
    }
    
    
    
    
}

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    
    
    
}























