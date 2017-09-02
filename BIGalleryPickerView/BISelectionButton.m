//
//  BISelectionButton.m
//  PhotoPickerActionSheet
//
//  Created by Britto on 23/03/17.
//  Copyright © 2017 Britto. All rights reserved.
//

#import "BISelectionButton.h"

@implementation BISelectionButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.titleLabel setFont:[UIFont fontWithName:@"cordiantlearn-icons-3" size:15]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:67.0/255.0 green:215.0/255.0 blue:82.0/255.0 alpha:1] forState:UIControlStateSelected];
    [self setTitle:@"\ue78c" forState:UIControlStateNormal];
    [self setTitle:@"\ue74b" forState:UIControlStateSelected];
    
    
}

@end
