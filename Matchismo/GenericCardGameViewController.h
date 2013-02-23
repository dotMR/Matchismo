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

@property (strong, nonatomic) CardGame *game;

-(void) updateFlipsLabel: (NSString *)flipsLabelValue;
-(void) updateScoreLabel: (NSString *)scoreLabelValue;
-(void) updateGameMessageLabel: (NSAttributedString *)messageValue;

// abstract: subclasses need to implement
@property (nonatomic) NSUInteger startingCardCount;
@property (nonatomic) NSString *cardTypeIdentifier;
-(Class) deckClassToInit;
-(Class) cardGameClassToInit;
-(void) updateCell: (UICollectionViewCell *)cell usingCard:(Card *)card;

@end
