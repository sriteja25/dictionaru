//
//  ViewController.swift
//  dictionary
//
//  Created by Sriteja Chilakamarri on 13/07/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Alamofire

class MeaningViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textBox: UITextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    var word:String?
    var wordCount = [String]()
    var meaningOfWord = [String]()
    var examplesPrint = [String]()
    var pronounciation:String?
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //getMeaning()
        
        
        
        self.hideKeyboardWhenTappedAround()
        textBox.delegate = self
        sendButton.isEnabled = false
        textBox.addTarget(self, action: #selector(MeaningViewController.textBoxEditingChanged(textField:)), for: UIControlEvents.editingChanged)
        
        let tableViewNib = UINib(nibName: "SenderTableViewCell", bundle: nil)
        tableView.register(tableViewNib, forCellReuseIdentifier: "cell")
        
        let tableViewNib2 = UINib(nibName: "ReceiverTableViewCell", bundle: nil)
        tableView.register(tableViewNib2, forCellReuseIdentifier: "cell2")
        
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textBox.becomeFirstResponder()
        scrollView.setContentOffset(CGPoint(x: self.textBox.frame.origin.x, y: 300), animated: true)
    }

    func textBoxEditingChanged(textField: UITextField){
        if(textField == textBox){
            if(textBox.text != ""){
                sendButton.isEnabled = true
            }
            
         
        }
    
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        scrollView.setContentOffset(CGPoint(x: self.textBox.frame.origin.x, y: 300), animated: true)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField){
        scrollView.setContentOffset(CGPoint(x: 0, y: -40), animated: true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true
    }

    
    
    func getMeaning(word:String){
    
        let appId = "8065585a"
        let appKey = "a4b6fecaf1303680afeb129e40e72e56"
        let language = "en"
        let word = word
        var word_id = word.lowercased()
        word_id = word_id.replacingOccurrences(of: " ", with: "")
        //word id is case sensitive and lowercase is required
        let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v1/entries/\(language)/\(word_id)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(appId, forHTTPHeaderField: "app_id")
        request.addValue(appKey, forHTTPHeaderField: "app_key")
        
        let headers = ["app_id":appId,"app_key":appKey,"Accept":"application/json"]
        Alamofire.request("https://od-api.oxforddictionaries.com:443/api/v1/entries/\(language)/\(word_id)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            if(response.result.error != nil){
                self.meaningOfWord.append("Please check the word entered")
                self.examplesPrint.append("")
                self.wordCount.append("")
                print(response.error.debugDescription)
                self.tableView.reloadData()
            }else{
                print(response.result.value)
                let jsonData = response.result.value as! [String:Any]
                let results =  jsonData["results"] as! NSArray
                let items = results[0] as? [String:Any]
                let pronunciations = items?["pronunciations"] as? NSArray
                let lexicalEntries = items?["lexicalEntries"] as? NSArray
                let item = lexicalEntries?[0] as? [String:Any]
                let entries = item?["entries"] as? NSArray
                let itemEntries = entries?[0] as? [String:Any]
                let senses = itemEntries?["senses"] as? NSArray
                let itemSenses = senses?[0] as? [String:Any]
                let definitions = itemSenses?["definitions"] as! NSArray
                if(definitions.count > 2){
                
                    let item1 = definitions[0] as! String
                    let item2 = definitions[1] as! String
                    self.meaningOfWord.append(item1  + " ; " + item2 + " ;")
                }else{
                    let item1 = definitions[0] as! String
                    self.meaningOfWord.append(item1)
                }
                let examples = itemSenses?["examples"] as! NSArray
                if(examples.count > 2){
                    
                    let item1 = examples[0] as! [String:Any]
                    let item2 = examples[1] as! [String:Any]
                    
                    let text1 = item1["text"] as! String
                    let text2 = item2["text"] as! String
                    self.examplesPrint.append("1. " + text1  + "\n" + "2. " + text2)
                }else{
                     let item1 = examples[0] as! [String:Any]
                    let text1 = item1["text"] as! String
                    self.examplesPrint.append("1. " + text1)
                    
                }
                self.wordCount.append("")
                print(pronunciations)
                self.tableView.reloadData()
            
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordCount.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        
        if(indexPath.row % 2 == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SenderTableViewCell

            if(wordCount.count != 0){
                
                cell.senderText.text = wordCount[indexPath.row]
                //cell.senderContentView.backgroundColor = UIColor.blue
                cell.senderContentView.layer.cornerRadius = 12
            }
            return cell
        
        }else{
        
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ReceiverTableViewCell
            
            
            if(self.meaningOfWord.count != 0){
                
                if(meaningOfWord[indexPath.row] != "Please check the word entered"){
                    
                    cell2.ReceivercontentView.layer.cornerRadius = 12
                    cell2.meaning.text = meaningOfWord[indexPath.row]
                    cell2.examples.text = examplesPrint[indexPath.row]
                
                }else{
                
                    cell2.ReceivercontentView.layer.cornerRadius = 12
                    cell2.meaningLabel.isHidden = true
                    cell2.exampleLabel.isHidden = true
                    cell2.meaning.text = meaningOfWord[indexPath.row]
                    cell2.examples.isHidden = true
                
                }
                
                
                
            
            }
            return cell2
        }
  
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row % 2 == 0){
        
            return 50
        }else{
            if(meaningOfWord[indexPath.row] != "Please check the word entered"){
                return 233
            }else{
                
                return 139
            }
            
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        word = textBox.text
        wordCount.append(word!)
        meaningOfWord.append("")
        examplesPrint.append("")
        sendButton.isEnabled = false
        textBox.text = ""
        
        print("Enabled")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        getMeaning(word: word!)
    }
    
    
  
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

