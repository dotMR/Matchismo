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
#import "CardViewCell.h"

@interface GenericCardGameViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lbl_Score;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Flips;
@property (weak, nonatomic) IBOutlet UILabel *lbl_GameMessage;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@end

@implementation GenericCardGameViewController

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.game.numDealtCards;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * view = [collectionView dequeueReusableCellWithReuseIdentifier:[self cardTypeIdentifier] forIndexPath:indexPath];
    
    if( [view isKindOfClass:[CardViewCell class]] )
    {
        CardViewCell *cell = (CardViewCell *)view;
        
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    
    return view;
}

-(CardGame *) game
{
    if(!_game) _game = [[[self cardGameClassToInit] alloc] initGameWithNumCards:self.startingCardCount usingDeck:[[[self deckClassToInit] alloc] init]];
    
    return _game;
}

- (IBAction)action_dealMoreCards
{
    #define NUM_CARDS_TO_DEAL (3)
    
    if( [self.game deckHasMoreCards] )
    {
        [self.cardCollectionView performBatchUpdates:^{
            
            NSUInteger numExistingCards = self.game.numDealtCards;
            [self.game dealNewCards:NUM_CARDS_TO_DEAL];
            NSUInteger currentCardCount = self.game.numDealtCards;
            NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
            
            for (int i=numExistingCards; i<currentCardCount; i++)
                [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            
            [self.cardCollectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
            
        } completion:nil];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:(self.game.numDealtCards-1) inSection:0];
        [self scrollToIndexPath:path];
        
        [self updateUI];
    }
}

-(void) scrollToIndexPath: (NSIndexPath *)indexPath
{    
    [self.cardCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:TRUE];
}

- (IBAction)action_cardCollectionTap:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    if(indexPath)
    {
        [self.game flipCardAtIndex:indexPath.item];
        [self updateUI];
    }
}

-(IBAction) action_dealButtonPressed
{
    self.game = nil;
    
    // TODO: should this call both reload and updateUI?
    [self.cardCollectionView reloadData];
    [self updateUI];
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

// subclasses should call super if they override
-(void) updateUI
{
    for(UICollectionViewCell *cell in [self.cardCollectionView visibleCells])
    {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        
        if(card.isUnplayable)
        {
            [self.game removeDealtCardAtIndex:indexPath.item];
            [self.cardCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
        else
        {
            [self updateCell:cell usingCard:card];            
        }
    }
    
    [self updateScoreLabel:[NSString stringWithFormat:@"Score: %d",self.game.score]];
    [self updateFlipsLabel:[NSString stringWithFormat:@"Flips: %d",self.game.flipCount]];
    [self updateGameMessageLabel: [[NSAttributedString alloc] initWithString:self.game.gameHistory.lastObject]];
    
    [self doThisActionToUpdateUI];
}

// implementation left to subclasses
-(Class) cardGameClassToInit { return nil; }

// implementation left to subclasses
-(Class) deckClassToInit { return nil; }

// implementation left to subclasses
-(void) updateCell: (UICollectionViewCell *)cell usingCard:(Card *)card { }

// implementation left to subclasses if desired
-(void) doThisActionToUpdateUI { }

@end
