//
//  BICollectionViewCell.m
//  PhotoPickerActionSheet
//
//  Created by Britto on 08/03/17.
//  Copyright © 2017 Britto. All rights reserved.
//

#import "BICollectionViewCell.h"

@implementation BICollectionViewCell
@synthesize myDelegate = _myDelegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}


-(IBAction)selectButtonTapped:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    
    [_myDelegate selectButtonTappedInCellTag:self.tag withState:sender.selected];
    
}
-(void)setSelectedButton:(BOOL)selected
{
    
    [self.selectionButton setSelected:selected];
}

@end
