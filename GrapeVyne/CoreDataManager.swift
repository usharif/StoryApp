//
//  CoreDataManager.swift
//  StoryApp
//
//  Created by Umair Sharif on 2/5/17.
//  Copyright © 2017 usharif. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CoreDataManager {
    
    static func addStoryToCategory(category: Category, story: Story) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let categoryObject = fetchObject(entity: "CDCategory", title: category.title) as! CDCategory
        let storyObject = CDStory(context: context)
        storyObject.title = story.title
        storyObject.fact = story.fact
        storyObject.urlString = story.url
        categoryObject.addToStories(storyObject)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func removeStoryFromCategory(_ story: Story) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let storyObject = fetchObject(entity: "CDStory", title: story.title) as! CDStory
        storyObject.category?.removeFromStories(storyObject)
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func writeToModel(_ story: Story) -> Story? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var retStory: Story?
        let argStory = story
        
        let _story = CDStory(context: context)
        _story.title = argStory.title
        _story.fact = argStory.fact
        _story.urlString = argStory .url
        
        do {
            try context.save()
            if let title = _story.title, let url = _story.urlString {
                retStory = Story(title: title,
                                 url: url,
                                 fact: _story.fact,
                                 id: _story.objectID)
            }
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        return retStory
    }
    
    static func writeToModel(_ category: Category) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let _category = CDCategory(context: context)
        _category.title = category.title
        _category.urlString = category.url
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func writeMetricToModel(entity: String, value: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: entity, in: context)
        let metric = NSManagedObject(entity: entity!, insertInto: context)
        metric.setValue(value, forKey: "hasViewedAll")
        do {
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
    static func fetchModel(entity: String) -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        var managedObject = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let results = try context.fetch(fetchRequest)
            managedObject = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return managedObject
    }
    
    static func fetchObject(entity: String, title: String) -> NSManagedObject? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        var managedObject: NSManagedObject?
        let fetchPredicate = NSPredicate(format: "title == %@", title)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = fetchPredicate
        
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            if !results.isEmpty {
                managedObject = results[0]
            }
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return managedObject
    }
    
    static func fetchObjectBy(id: NSManagedObjectID) -> NSManagedObject? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        var managedObject: NSManagedObject?
        do {
            let result = try context.existingObject(with: id)
            managedObject = result
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return managedObject
    }
    
    static func deleteObjectBy(id: NSManagedObjectID) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            //let result = context.object(with: id)
            let result = try context.existingObject(with: id)
            context.delete(result)
            try context.save()
        } catch let error as NSError  {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    static func deleteObject(entity: String, title: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchPredicate = NSPredicate(format: "title == %@", title)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = fetchPredicate
        
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            for object in results {
             context.delete(object)
            }
            try context.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
