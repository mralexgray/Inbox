//
//  WordNode.m
//  gmailbattlefield
//
//  Created by Simon Watiau on 11/30/11.
//
#import "EmailNode.h"
#import "EmailModel.h"
#import "cocos2d.h"
@implementation EmailNode
@synthesize emailModel,didMoved,isAppearing,isDisappearing;

- (id)initWithEmailModel:(EmailModel*)model{
    self = [super init];
    if (self) {
        emailModel = [model retain];
        drawMe = true;
        isAppearing = true;
        isDisappearing = false;
        self.scale=0;
    }
    return self;    
}

-(void) draw {
    [super draw];
    if (drawMe){
        drawMe = false;
        // 217x135
        CCSprite* sprite = [CCSprite spriteWithFile:@"emailBackground.png"];
        sprite.position=CGPointMake(105,67);
        [self addChild:sprite];
        NSString* headline;
        
        title = [[CCLabelTTF labelWithString:emailModel.senderName dimensions:CGSizeMake(180, 20) alignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeTailTruncation fontName:@"Arial" fontSize:15] retain];
        title.color=ccc3(150, 150, 150);
        title.position=CGPointMake(105, 105);
        [self addChild:title];
        
        content = [[CCLabelTTF labelWithString:emailModel.subject dimensions:CGSizeMake(180, 65) alignment:UITextAlignmentLeft lineBreakMode:UILineBreakModeTailTruncation fontName:@"Arial" fontSize:13] retain];

        content.color=ccc3(0, 1, 0);
        content.position=CGPointMake(105, 56);
        
        [self addChild:content];
        [self setContentSize:CGSizeMake(217, 135)];
        [self setAnchorPoint:CGPointMake(0.5, 0.5)];
    }
}

-(void)setEmailModel:(EmailModel *)model{
    if (emailModel){
        [emailModel release];
    }
    if (model){
        emailModel = [model retain];
        [title setString:emailModel.senderName];
    }else{
        emailModel=nil;
    }
}

-(void)hideAndRemove{
    self.isAppearing = false;
    self.isDisappearing = true;
}

-(void)setNextStep{
    if (isAppearing){
        if (self.scale>=1){
            isAppearing=false;
        }else{
            self.scale+=0.08;
        }
        
    }else if (isDisappearing){
        if (self.scale>0){
            self.scale-=0.08;
        }
    }
    self.scale=self.scale<0?0:self.scale;
    self.scale=self.scale>1?1:self.scale;
}

-(BOOL)shouldBeRemoved{
    if (isDisappearing && self.scale==0){
        return true;
    }else{
        return false;
    }
}

-(void)dealloc{
    self.emailModel=nil;
    [title release];
    [content release];
    [super dealloc];
}

@end
