//
//  GenericCardGameControllerViewController.m
//  Matchismo
//
//  Created by Mario Russo on 2/17/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "GenericCardGameViewController.h"
#import "CardGame.h"
#import "Deck.h"

@interface GenericCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_Score;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Flips;
@property (weak, nonatomic) IBOutlet UILabel *lbl_GameMessage;

@end

@implementation GenericCardGameViewController

- (CardGame *)game
{
    if(!_game) _game = [[[self cardGameClass] alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
    
    return _game;
}

- (IBAction)action_dealButtonPressed
{
    [self handleDealButtonPressed];
}

-(void) updateFlipsLabel: (NSString *) flipsLabelValue
{
    self.lbl_Flips.text = flipsLabelValue;
}

-(void) updateScoreLabel: (NSString *) scoreLabelValue
{
    self.lbl_Score.text = scoreLabelValue;
}

-(void) updateGameMessageLabel: (NSAttributedString *)messageValue
{
    self.lbl_GameMessage.attributedText = messageValue;
}

- (void) handleDealButtonPressed
{
    self.game = nil;
}

-(Class) cardGameClass
{
    // implementation left to subclasses
    return [CardGame class];
}

-(Deck *) createDeck
{
    // implementation left to subclasses
    return nil;
}

-(NSUInteger) startingCardCount
{
    // implementation left to subclasses
    return 0;
}

@end
