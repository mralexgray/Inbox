//
//  EmailSynchronizer.m
//  Inbox
//
//  Created by Simon Watiau on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EmailSynchronizer.h"
#import "EmailAccountModel.h"
#import <CoreData/CoreData.h>
#import "CTCoreAccount.h"
#import "CTCoreMessage.h"
#import "AppDelegate.h"
#import "CTCoreFolder.h"
#import "MailCoreTypes.h"
#import "CTCoreAddress.h"
#import "FolderModel.h"
#import "EmailModel.h"
#import "DDLog.h"
#import "PersistMessagesSubSync.h"
#import "UpdateMessagesSubSync.h"
#import "FoldersSubSync.h"
#import "EmailSubSync.h"
#define ddLogLevel LOG_LEVEL_VERBOSE

@implementation EmailSynchronizer
@synthesize emailAccountModel;

- (id)initWithAccountId:(id)accountId {
    if ( self = [super init] ) {
        emailAccountModelId = [accountId retain];
        subSyncs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [subSyncs release];
    [emailAccountModel release];
    [emailAccountModelId release];
    [super dealloc];
}


+ (NSString *)decodeImapString:(NSString *)input {
    NSMutableDictionary* translationTable = [[NSMutableDictionary alloc] init];
    [translationTable setObject:@"&" forKey:@"&-"];
    [translationTable setObject:@"é" forKey:@"&AOk-"];
    [translationTable setObject:@"â" forKey:@"&AOI-"];
    [translationTable setObject:@"à" forKey:@"&AOA-"];
    [translationTable setObject:@"è" forKey:@"&AOg"];
    [translationTable setObject:@"ç" forKey:@"&AOc"];
    [translationTable setObject:@"ù" forKey:@"&APk"];
    [translationTable setObject:@"ê" forKey:@"&AOo"];
    [translationTable setObject:@"î" forKey:@"&AO4"];
    [translationTable setObject:@"ó" forKey:@"&APM"];
    [translationTable setObject:@"ñ" forKey:@"&APE"];
    [translationTable setObject:@"á" forKey:@"&AOE"];
    [translationTable setObject:@"ô" forKey:@"&APQ"];                   
    [translationTable setObject:@"É" forKey:@"&AMk"];
    [translationTable setObject:@"ë" forKey:@"&AOs"];
    
    for ( NSString* key in [translationTable allKeys] ) {
        input = [input stringByReplacingOccurrencesOfString:key withString:[translationTable objectForKey:key]];
    }
    [translationTable release];
    return input;
}

- (void)stopAsap {
    [super stopAsap];
    for (EmailSubSync* subSync in subSyncs) {
        [subSync stopAsap];
    }
}

- (void)sync:(NSError **)error {
    DDLogVerbose(@"sync started");
    if ( !error ) {
        NSError* err = nil;
        error = &err;
    }
    emailAccountModel = (EmailAccountModel*)[[self.context objectWithID:emailAccountModelId] retain];
    if ( self.shouldStopAsap ) return ;/* STOP ASAP */
    
    FoldersSubSync *foldersSync = [[FoldersSubSync alloc] initWithContext:self.context account:emailAccountModel];
    PersistMessagesSubSync* persistSync = [[PersistMessagesSubSync alloc] initWithContext:self.context account:emailAccountModel];
    UpdateMessagesSubSync* updateSync = [[UpdateMessagesSubSync alloc] initWithContext:self.context account:emailAccountModel];
    [subSyncs addObject:foldersSync];
    [subSyncs addObject:persistSync];
    [subSyncs addObject:updateSync];
    
    [foldersSync syncWithError:error];
    if ( *error ) {
        DDLogError(@"sync ended with an error");
        return;
    }
    [foldersSync release];
    foldersSync = nil;
    if ( self.shouldStopAsap ) return ;/* STOP ASAP */
    
    
    [persistSync syncWithError:error];
    if ( *error ) {
        DDLogError(@"sync ended with an error");
        return;
    }
    if ( self.shouldStopAsap ) return ;/* STOP ASAP */
    
    [updateSync syncWithError:error onStateChanged:^{
        [self onStateChanged];
    } periodicCall:^{
        [persistSync syncWithError:nil];
    }];
    
    if ( *error ){
        DDLogError(@"sync ended with an error");
        return;
    }
    if ( self.shouldStopAsap ) return ;/* STOP ASAP */
    [updateSync release];
    updateSync = nil;
    [persistSync release];
    persistSync = nil;
    
    [emailAccountModel release];
    emailAccountModel = nil;
    DDLogVerbose(@"sync successful");
    return;
}

@end