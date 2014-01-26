//
//  WordRepository.h
//  BandNameGenerator
//
//  Created by Curtis Branum on 1/25/14.
//  Copyright (c) 2014 Morsekode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordRepository : NSObject
@property (strong, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Legacy
- (NSString *)getRandomBandName;
- (NSString *)getRandomStringFromArray: (NSArray *)paramArray;
@end
