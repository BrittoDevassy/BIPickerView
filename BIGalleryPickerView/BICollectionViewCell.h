//
//  BICollectionViewCell.h
//  PhotoPickerActionSheet
//
//  Created by Britto on 08/03/17.
//  Copyright © 2017 Britto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BISelectionButton.h"

@protocol BICollectionCellDelegate <NSObject>

-(void)selectButtonTappedInCellTag:(NSUInteger)tag withState:(BOOL)selectedState;
-(void)tappedCellWithTag:(NSUInteger)tag;
@end


@interface BICollectionViewCell : UICollectionViewCell
{
    
    __weak id <BICollectionCellDelegate> _myDelegate;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet BISelectionButton *selectionButton;
@property(nonatomic,strong)NSString *representedAssetIdentifier;
@property (nonatomic,weak) id <BICollectionCellDelegate> myDelegate;

-(void)setSelectedButton:(BOOL)selected;

@end
