//
//  FoldersComponent.m
//  Inbox
//
//  Created by Simon Watiau on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoldersTable.h"
#import "DropZoneNode.h"
#import "cocos2d.h"
#import "FolderModel.h"
@interface FoldersTable()
@end

@implementation FoldersTable
@synthesize folders;
-(id)init{
    if (self = [super init]){
        table = [[SWTableView viewWithDataSource:self size:CGSizeMake(240, 748)] retain];
        [table setVerticalFillOrder:SWTableViewFillTopDown];
    }
    return self;
}

-(void)dealloc{
    [table release];
    self.folders = nil;
    [super dealloc];
}

-(CCNode*)view{
    return table;
}

-(void)setFolders:(NSArray *)f{
    [folders autorelease];
    folders = [f retain];
    [table reloadData];
    [table scrollToTop];
}

-(CGSize)cellSizeForTable:(SWTableView *)t{
    return CGSizeMake(240, 280);
}

-(SWTableViewCell *)table:(SWTableView *)t cellAtIndex:(NSUInteger)idx{
    DropZoneNode* node =  [[[DropZoneNode alloc] init] autorelease];
    
    if (folders){
        FolderModel* folder = [self.folders objectAtIndex:idx];
        node.folder = folder;
    }else{
        node.folder =  nil; 
    }
    return node;
}

-(NSUInteger)numberOfCellsInTableView:(SWTableView *)t{
    if (self.folders){
        int count = [self.folders count];
        return count;
    }
    return 10;
}

-(FolderModel*) folderModelAtPoint:(CGPoint)point{
    int cellIndex = [table cellIndexAt:point];
    if (cellIndex!=-1){
        FolderModel* folder = [self.folders objectAtIndex:cellIndex];
        return folder;
    }
    return nil;
}

@end