//
//  SetCardView.m
//  Matchismo
//
//  Created by Mario Russo on 2/23/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (UIBezierPath *) createPillShapePathWithMidPoint:(CGPoint) midPoint width:(CGFloat)width height:(CGFloat)height
{
    CGFloat pillRadius = 12;
    
    return [UIBezierPath bezierPathWithRoundedRect:CGRectMake(midPoint.x-width/2, midPoint.y-height/2, width, height) cornerRadius:pillRadius];
}

- (UIBezierPath *) createDiamondShapePathWithMidPoint: (CGPoint) midPoint width:(CGFloat)width height:(CGFloat)height
{
    UIBezierPath *diamond = [UIBezierPath bezierPath];
    [diamond moveToPoint:CGPointMake(midPoint.x, midPoint.y-height/2)];
    [diamond addLineToPoint:CGPointMake(midPoint.x+width/2, midPoint.y)];
    [diamond addLineToPoint:CGPointMake(midPoint.x, midPoint.y+height/2)];
    [diamond addLineToPoint:CGPointMake(midPoint.x-width/2, midPoint.y)];
    [diamond closePath];
    
    return diamond;
}

- (UIBezierPath *) createSquiggleShapePathWithMidPoint: (CGPoint)midPoint width:(CGFloat)width height:(CGFloat)height
{
    UIBezierPath *squiggle = [UIBezierPath bezierPath];
    
    // ---------------------------
    //     x1    x2   x3     x4
    // y1: |-----------|
    //     |           |
    // y2: |------|    |
    //            |    |
    // y3:        |    |------|
    //            |           |
    // y4:        |-----------|
    //
    // ---------------------------
    
    CGFloat modifier_shape_width = 0.35;
    CGFloat modifier_shape_height = 0.42;
    
    CGFloat y1 = midPoint.y - height/2;
    CGFloat y2 = y1 + (height*modifier_shape_height);
    CGFloat y4 = y1 + height;
    CGFloat y3 = y4 - (height*modifier_shape_height);
    
    CGFloat x1 = midPoint.x - width/2;
    CGFloat x2 = x1 + (width*modifier_shape_width);
    CGFloat x4 = x1 + width;
    CGFloat x3 = x4 - (width*modifier_shape_width);
    
    [squiggle moveToPoint:CGPointMake(x1,y1)];
    [squiggle addLineToPoint:CGPointMake(x3,y1)];
    [squiggle addLineToPoint:CGPointMake(x3,y3)];
    [squiggle addLineToPoint:CGPointMake(x4,y3)];
    [squiggle addLineToPoint:CGPointMake(x4,y4)];
    [squiggle addLineToPoint:CGPointMake(x2,y4)];
    [squiggle addLineToPoint:CGPointMake(x2,y2)];
    [squiggle addLineToPoint:CGPointMake(x1,y2)];
    [squiggle closePath];
    
    return squiggle;
}

- (void)drawRect:(CGRect)rect
{
    // ##########################
    // draw actual card
    // ##########################
    UIBezierPath *roundedRect = [self createContainingCardPath];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    // ##########################
    // draw oval 'pill' shape
    // ##########################
    CGPoint pillMiddle = CGPointMake(self.bounds.size.width/2.0,self.bounds.size.height/2.0);
    CGFloat pillWidth = 50;
    CGFloat pillHeight = 20;
    
    UIBezierPath *pill = [self createPillShapePathWithMidPoint:pillMiddle width:pillWidth height:pillHeight];
    [[UIColor purpleColor] setFill];
    [pill fill];
    
    // ##########################
    // draw diamond shape
    // ##########################
    CGPoint diamondMiddle = CGPointMake(self.bounds.size.width/2.0,self.bounds.size.height*1/4);
    CGFloat diamondWidth = 46;
    CGFloat diamondHeight = 20;
    
    UIBezierPath *diamond = [self createDiamondShapePathWithMidPoint:diamondMiddle width:diamondWidth height:diamondHeight];
    [[UIColor redColor] setStroke];
    [diamond setLineWidth:2];
    [diamond stroke];
    
    // ##########################
    // draw my squiggle
    // ##########################
    CGPoint squiggleMiddle = CGPointMake(self.bounds.size.width/2.0,self.bounds.size.height*3/4);
    CGFloat squiggleWidth = 44;
    CGFloat squiggleHeight = 20;
    
    UIBezierPath *squiggle = [self createSquiggleShapePathWithMidPoint:squiggleMiddle width:squiggleWidth height:squiggleHeight];
    [[UIColor greenColor] setStroke];
    [squiggle setLineWidth:2];
    [squiggle stroke];
    
    // ##########################
    // striped background for squiggle
    // ##########################
    [squiggle addClip];
    
    UIBezierPath *stripes = [UIBezierPath bezierPath];
    
    for(int y=0;y<(self.bounds.size.height-3);y=y+3)
    {
        [stripes moveToPoint:CGPointMake(0, y)];
        [stripes addLineToPoint:CGPointMake(self.bounds.size.width, y)];
    }
    
    [stripes setLineWidth:0.5];
    [stripes stroke];
}


@end
