//
//  CardNameViewController.m
//  Matchismo
//
//  Created by Mario Russo on 2/5/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "CardNameViewController.h"
#import "PlayingCardDeck.h"

@interface CardNameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *displayCard;
@property (strong, nonatomic) PlayingCardDeck *deck;
@property (nonatomic) int flipCount;
@end

@implementation CardNameViewController

- (PlayingCardDeck *)deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipCountLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    // action only on card reveal
    if(!sender.isSelected)
    {
        Card *newCard = [self.deck drawRandomCard];
        [self.displayCard setTitle: newCard.contents forState:UIControlStateSelected];
        self.flipCount++;
    }
    
    sender.selected = !sender.isSelected;
}

@end
