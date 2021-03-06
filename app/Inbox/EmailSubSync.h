#import <Foundation/Foundation.h>
@class NSManagedObjectContext, CTCoreAccount, EmailAccountModel;
@interface EmailSubSync : NSObject{
    NSManagedObjectContext* context;
    EmailAccountModel* accountModel;
    CTCoreAccount* coreAccount;
    BOOL shouldStopAsap;
}
@property(nonatomic, retain, readonly) NSManagedObjectContext* context;
@property(nonatomic, retain, readonly) EmailAccountModel* accountModel;
@property(nonatomic, retain, readonly) CTCoreAccount* coreAccount;
@property(nonatomic, assign, readonly) BOOL shouldStopAsap;

- (void)stopAsap;

-(id)initWithContext:(NSManagedObjectContext*)c account:(EmailAccountModel*)a;
-(CTCoreAccount*)coreAccountWithError:(NSError**)error;
@end
