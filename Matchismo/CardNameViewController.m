//
//  CardNameViewController.m
//  Matchismo
//
//  Created by Mario Russo on 2/5/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "CardNameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardNameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *playByPlayLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeControl;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allCards;
@end

@implementation CardNameViewController

- (CardMatchingGame *)game
{
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.allCards.count usingDeck:[[PlayingCardDeck alloc] init] usingNumCardsToMatch:2];
    
    return _game;
}

- (void) setAllCards:(NSArray *)allCards
{
    _allCards = allCards;
    [self updateUI];
}

- (void) updateUI
{
    for (UIButton *cardButton in self.allCards) {
        Card *card = [self.game cardAtIndex:[self.allCards indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        
//        UIImage *cardBackImage = [UIImage imageNamed:@"bear.jpg"];
//        [cardButton setBackgroundImage:cardBackImage forState:UIControlStateNormal];
//
//        [cardButton setBackgroundImage:nil forState:UIControlStateSelected];
//        [cardButton setBackgroundImage:nil forState:UIControlStateDisabled];
//        
//        if(!card.isFaceUp)
//        {
//            
//        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    
    self.flipCountLabel.text = [NSString stringWithFormat:@"Flips: %d",self.game.flipCount];
    
    self.playByPlayLabel.text = self.game.gameHistory.lastObject;
}

- (IBAction)dealNewGame:(id)sender
{
    self.game = nil;
    self.game.numCardsToMatch = (self.matchModeControl.selectedSegmentIndex + 2);
    [self updateUI];
    self.matchModeControl.enabled = TRUE;
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.allCards indexOfObject:sender]];
    [self updateUI];
    
    if(self.matchModeControl.isEnabled)
    {
        self.matchModeControl.enabled = FALSE;
    }
}

- (IBAction)matchMode:(UISegmentedControl *)sender
{
    self.game.numCardsToMatch = (sender.selectedSegmentIndex + 2);
    [self updateUI];
}

@end
