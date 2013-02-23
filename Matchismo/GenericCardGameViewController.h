//
//  GenericCardGameControllerViewController.h
//  Matchismo
//
//  Created by Mario Russo on 2/17/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGame.h"
#import "Deck.h"

@interface GenericCardGameViewController : UIViewController

-(void) updateFlipsLabel: (NSString *)flipsLabelValue;
-(void) updateScoreLabel: (NSString *)scoreLabelValue;
-(void) updateGameMessageLabel: (NSAttributedString *)messageValue;

@property (nonatomic) NSUInteger startingCardCount;

// abstract : subclasses should implement 
-(void) handleDealButtonPressed;
-(Deck *) createDeck;

// subclasses should provide the type of game
-(Class) cardGameClass;

@property (strong, nonatomic) CardGame *game;

@end
