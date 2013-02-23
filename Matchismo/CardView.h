//
//  CardView.h
//  SetGame
//
//  Created by Mario Russo on 2/21/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic)NSString *suit;
@property (nonatomic) BOOL faceUp;

- (UIBezierPath *) createContainingCardPath;

@end
