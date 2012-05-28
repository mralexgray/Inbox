////  SWScrollView.h//  SWGameLib//////  Copyright (c) 2010 Sangwoo Im////  Permission is hereby granted, free of charge, to any person obtaining a copy//  of this software and associated documentation files (the "Software"), to deal//  in the Software without restriction, including without limitation the rights//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell//  copies of the Software, and to permit persons to whom the Software is//  furnished to do so, subject to the following conditions:////  The above copyright notice and this permission notice shall be included in//  all copies or substantial portions of the Software.////  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN//  THE SOFTWARE.//  ////  Created by Sangwoo Im on 6/3/10.//  Copyright 2010 Sangwoo Im. All rights reserved.//#import "CCLayer.h"typedef enum {    SWScrollViewDirectionHorizontal,    SWScrollViewDirectionVertical,    SWScrollViewDirectionBoth} SWScrollViewDirection;@class SWScrollView;@protocol SWScrollViewDelegate<          NSObject>@optional-(void)scrollViewDidScroll:(SWScrollView *)view;-(void)scrollViewDidZoom:(SWScrollView *)view;@end@interface SWScrollView :          CCLayer {    BOOL touchMoved_;    BOOL isDragging_;    BOOL bounces_;    BOOL clipsToBounds_;    CCNode *container_;    CGPoint maxInset_;    CGPoint minInset_;    CGPoint scrollDistance_;    CGPoint touchPoint_;    CGSize viewSize_;    CGFloat minScale_, maxScale_;    CGFloat touchLength_;    NSMutableArray *touches_;    SWScrollViewDirection direction_;    id<SWScrollViewDelegate> delegate_; }@property (nonatomic, readonly) CCNode *container;@property (nonatomic, assign) CGFloat zoomScale;@property (nonatomic, assign) CGFloat minZoomScale;@property (nonatomic, assign) CGFloat maxZoomScale;@property (nonatomic, assign) id<SWScrollViewDelegate> delegate;@property (nonatomic, assign, readonly) BOOL isDragging;@property (nonatomic, assign) BOOL bounces;@property (nonatomic, assign) SWScrollViewDirection direction;@property (nonatomic, assign) BOOL clipsToBounds;@property (nonatomic, assign) CGPoint contentOffset;@property (nonatomic, assign, setter=setViewSize:) CGSize viewSize;+(id)viewWithViewSize:(CGSize)size;-(id)initWithViewSize:(CGSize)size;+(id)viewWithViewSize:(CGSize)size container:(CCNode *)container;-(id)initWithViewSize:(CGSize)size container:(CCNode *)container;-(void)setContentOffset:(CGPoint)offset animated:(BOOL)animated;-(void)setContentOffset:(CGPoint)offset animatedInDuration:(ccTime)dt; -(void)setZoomScale:(float)s animated:(BOOL)animated;-(void)setZoomScale:(float)s animatedInDuration:(ccTime)dt;-(CGPoint)minContainerOffset;-(CGPoint)maxContainerOffset; -(BOOL)isNodeVisible:(CCNode *)node;@end