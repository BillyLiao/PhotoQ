//
//  AnswerTableViewController.swift
//  Pictures
//
//  Created by 廖慶麟 on 2015/12/23.
//  Copyright © 2015年 廖慶麟. All rights reserved.
//

import UIKit
import CoreData
import Parse


class AnswerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{

    // MARK Properties
    
    var answers = [Answer]()
    var fetchResultController:NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Load any saved meals, otherwise load sample data.
      
        // Load the sample data.
        // loadSampleAnswers()
        var fetchRequest = NSFetchRequest(entityName: "Answer")
        let predicate = NSPredicate(format: "answer != %@", "")
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "create_time", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            fetchResultController = NSFetchedResultsController(
                fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            var e: NSError?
            
            do {
                try fetchResultController.performFetch()
            } catch {
                print(e?.localizedDescription)
            }
            
            // if fetchedObjects.count >= remove the default cell
            if fetchResultController.fetchedObjects?.count >= 2 {
                fetchRequest.predicate = NSPredicate(format: "question != %@ AND answer != %@", "What's the name of the flower?","")
                fetchResultController = NSFetchedResultsController(
                    fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
                fetchResultController.delegate = self
                var e: NSError?
                
                do {
                    try fetchResultController.performFetch()
                } catch {
                    print(e?.localizedDescription)
                }

                
            }
        }
        refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func refresh(sender: AnyObject?){
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        let installation = PFInstallation.currentInstallation()
        installation.badge = 0
        installation.saveInBackground()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let sections = fetchResultController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("AnswerTableViewCell", forIndexPath: indexPath) as! AnswerTableViewCell
        // Fetches the appropriate answer for the data source layout.
        
        let answer = fetchResultController.objectAtIndexPath(indexPath) as! Answer
        
        cell.questionLabel.text = answer.question
        cell.questionPhoto.image = UIImage(data: answer.photo)
        cell.answerLabel.text = answer.answer
    
        return cell
    }

    
    // Update table view (tableView.beginUpdates -> insert/delete/update)
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController!
        , didChangeObject anObject: AnyObject!
        , atIndexPath indexPath: NSIndexPath!
        , forChangeType type: NSFetchedResultsChangeType
        , newIndexPath: NSIndexPath!) {
            
            switch type {
            case .Insert:
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            case .Update:
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade  )
            default:
                self.tableView.reloadData()
            }
            answers = fetchResultController.fetchedObjects as! [Answer]

    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let answerDetailViewController = segue.destinationViewController as!
            AnswerDetailViewController
            
            // Get the cell that generated this segue.
            if let selectAnswerCell = sender as? AnswerTableViewCell{
                let indexPath = tableView.indexPathForCell(selectAnswerCell)!
                let selectedAnswer = fetchResultController.objectAtIndexPath(indexPath)
                answerDetailViewController.answer = selectedAnswer as! Answer
            }
        }
    }
    

   
}
