//
//  BIPickerView.h
//  PhotoPickerActionSheet
//
//  Created by Britto on 08/03/17.
//  Copyright © 2017 Britto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "CameraPreviewCollectionViewCell.h"
#import "BICollectionViewCell.h"

#define DefaultTitle    @"Select an Option"
#define DefaultaddLibraryItemButtonTitle    @"Add photo"
#define DefaultCancelButtonTitle    @"Cancel"
#define DefaultAddLibraryItemButtonTitleAfterSelection  @"Attach %ld photo"
@protocol BIPickerViewDelegate <NSObject>


- (void)actionButtonItemClicked:(NSInteger) itemInedx;
- (void)addAssetItemButtonClickedWithAssets:(NSArray *)selectedAssets;
- (void)cancelButtonClicked;
- (void)selectAssetFromView:(PHAsset *)asset;
- (void)showImagePickerView;

@end

@interface BIPickerView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,BICollectionCellDelegate>
{
    __weak IBOutlet UIView *topContainerView;
    __weak IBOutlet UIView *attachmentContainerView;
    __weak IBOutlet UICollectionView *assetCollectionView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIStackView *actionStackView;
    __weak IBOutlet UIButton *addLibraryItemButton;
    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet NSLayoutConstraint *attachmentViewBottom;
    
    __weak id <BIPickerViewDelegate> _delegate;

    NSString *addLibraryItemButtonTitle;

    NSString *addLibraryItemButtonTitleAfterSelection;
    NSArray *actionArray;

    PHFetchResult *fetchResult;
    PHCachingImageManager *imageManager;
    NSMutableArray *selectedAssetsArray;

}
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCamSetupResult permissionResult;
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic)NSUInteger maximunSelection;

@property(nonatomic,weak)id<BIPickerViewDelegate> myPickerDelegate;
-(instancetype)initWithTitle:(NSString *)title addLibraryTitle:(NSString *)addLibraryTitle alternateTitle:(NSString *)addLibraryAlternateTitle withActionTitles:(NSArray *)actioTitles cancelTitle:(NSString *)cancelTitle;
- (void)presentInView:(UIView *)view withCallback:(void (^)(BOOL))success;
-(void)setSelectedAssetsArray:(NSMutableArray *)thisSelectedAssets;
-(void)setMaximunSelectionProp:(NSUInteger)maximunSelection;

@end
