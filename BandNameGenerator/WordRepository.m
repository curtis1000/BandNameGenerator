//
//  WordRepository.m
//  BandNameGenerator
//
//  Created by Curtis Branum on 1/25/14.
//  Copyright (c) 2014 Morsekode. All rights reserved.
//
//  This site was a tremendous help:
//  http://www.codigator.com/tutorials/ios-core-data-tutorial-with-example/

#import "WordRepository.h"
#import "Word.h"

@implementation WordRepository

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

// Legacy
- (NSString *)getRandomBandName
{
    // Path to the plist (Supporting Files/WordsDictionary.plist)
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"WordsDictionary" ofType:@"plist"];
    
    // Build the array from the plist
    NSDictionary *wordsDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSArray *adjectives = [wordsDictionary objectForKey:@"Adjectives"];
    NSArray *nouns = [wordsDictionary objectForKey:@"Nouns"];
    
    NSString *adjective = [self getRandomStringFromArray:adjectives];
    NSString *noun = [self getRandomStringFromArray:nouns];
    
    // concatenate adjective and noun to form band name
    NSString *bandName = [NSString stringWithFormat:@"%@\n%@", adjective, noun];
    
    // max length of any single word
    NSInteger maxLength = 13;
    
    // if either word exceeds max length, try again
    if ([adjective length] > maxLength || [noun length] > maxLength) {
        return [self getRandomBandName];
    }
    
    // if band name contains invalid characters, try again
    NSString *invalidCharacters = @"-";
    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:invalidCharacters];
    NSRange range = [bandName rangeOfCharacterFromSet:cset];
    if (range.location != NSNotFound) {
        return [self getRandomBandName];
    }
    
    return bandName;
}

- (NSString *)getRandomStringFromArray: (NSArray *)paramArray
{
    NSString *randomString = [paramArray objectAtIndex: arc4random() % [paramArray count]];
    return randomString;
}

// Lazy Loader for Managed Object Context
- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

// Lazy Loader for Managed Object Model
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

// Lazy Loader for Persistent Store Coordinator
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"database.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
