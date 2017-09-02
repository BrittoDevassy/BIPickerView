//
//  BIPickerView.m
//  PhotoPickerActionSheet
//
//  Created by Britto on 08/03/17.
//  Copyright © 2017 Britto. All rights reserved.
//

#import "BIPickerView.h"
#import <PhotosUI/PhotosUI.h>


typedef NS_ENUM( NSInteger, MaximunSelectionBlockingType) {
    MaximunSelectionBlockingTypeBlockSeletion,
    MaximunSelectionBlockingTypeRemoveFirstSelection
};



static const PHAssetMediaType myAssetType = PHAssetMediaTypeImage;
static const BOOL cameraViewPresent = YES;
static const NSUInteger maximumSelectionConstant = 5;
static const MaximunSelectionBlockingType mySelectionBlockType = MaximunSelectionBlockingTypeBlockSeletion;


static const CGSize thumbnailSize = {80, 80};

@implementation BIPickerView
@synthesize myPickerDelegate = _delegate;

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
    attachmentViewBottom.constant= -(attachmentContainerView.frame.size.height);
    topContainerView.layer.cornerRadius = 10.0f;
    topContainerView.clipsToBounds = YES;
    cancelButton.layer.cornerRadius = 10.0f;

    selectedAssetsArray = [NSMutableArray new];

    [assetCollectionView registerNib:[UINib nibWithNibName:@"BICollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BICollectionViewCell"];
    [assetCollectionView registerNib:[UINib nibWithNibName:@"CameraPreviewCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CameraPreviewCell"];

    assetCollectionView.dataSource = self;
    
    assetCollectionView.delegate = self;

    self.hidden = YES;
    
    self.permissionResult = AVCamSetupResultSuccess;

    [self configureSession];
    self.backgroundColor = [UIColor clearColor];

    
   
}


-(PHFetchResult *)fetchResultWithType:(PHAssetMediaType )assetType
{
    PHFetchOptions *allAssetOptions = [PHFetchOptions new];
    allAssetOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *allAssetResult;
    switch (assetType) {
        case PHAssetMediaTypeImage:
        case PHAssetMediaTypeVideo:

            allAssetResult = [PHAsset fetchAssetsWithMediaType:assetType options:allAssetOptions];

            break;
            
        default:
            
            allAssetResult = [PHAsset fetchAssetsWithOptions:allAssetOptions];
            break;
    }
    
    return  allAssetResult;

}
-(instancetype)initWithTitle:(NSString *)title addLibraryTitle:(NSString *)addLibraryTitle alternateTitle:(NSString *)addLibraryAlternateTitle withActionTitles:(NSArray *)actioTitles cancelTitle:(NSString *)cancelTitle
{
self = [[[NSBundle mainBundle] loadNibNamed:@"BIPickerView" owner:self options:nil] objectAtIndex:0];
    [self setTtitle:title addLibraryItemButtonTitle:addLibraryTitle alertnateTitle:addLibraryAlternateTitle actionTitiles:actioTitles cancelTitle:cancelTitle];
    
    return self;
}

-(void)setTtitle:(NSString *)title addLibraryItemButtonTitle:(NSString *)aLTitle alertnateTitle:(NSString *)alertnateTitle actionTitiles:(NSArray *)actionTitlesArray cancelTitle:(NSString *)cancelTitle
{
    addLibraryItemButtonTitle =  aLTitle.length > 0 ? aLTitle : DefaultaddLibraryItemButtonTitle;
    
    titleLabel.text = title.length > 0 ? title : DefaultTitle;
    [addLibraryItemButton setTitle:addLibraryItemButtonTitle forState:UIControlStateNormal];
    addLibraryItemButtonTitleAfterSelection = alertnateTitle.length > 0 ? alertnateTitle : DefaultAddLibraryItemButtonTitleAfterSelection;
    [cancelButton setTitle:cancelTitle.length > 0 ? cancelTitle : DefaultCancelButtonTitle forState:UIControlStateNormal];
    actionArray = actionTitlesArray;
    
}
-(void)addActionButtons:(NSArray *)actionTitlesArray
{
    for (NSString *actionTitle in actionTitlesArray) {
        [self addActionWithTitle:actionTitle atIndex:[actionTitlesArray indexOfObject:actionTitle]];
    }
    
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [self setNeedsUpdateConstraints];

}

-(void)addActionWithTitle:(NSString *)actionTtile atIndex:(NSUInteger)buttonIndex
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [button setTitle:actionTtile forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    button.tag = buttonIndex;
    
    [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (actionStackView.arrangedSubviews.count > buttonIndex) {
        [actionStackView insertArrangedSubview:button atIndex:buttonIndex+1];
    }

    
}

-(void)setSelectedAssetsArray:(NSMutableArray *)thisSelectedAssets
{
    if (self.hidden && thisSelectedAssets != nil) {
        selectedAssetsArray = thisSelectedAssets;
        if (selectedAssetsArray.count > 0) {
            [addLibraryItemButton setTitle:[NSString stringWithFormat:addLibraryItemButtonTitleAfterSelection,selectedAssetsArray.count] forState:UIControlStateNormal];
            
        }

    }
}
-(void)setMaximunSelectionProp:(NSUInteger)maximunSelection
{
    if (self.hidden) {
        self.maximunSelection = maximunSelection;
    }
}
-(NSUInteger)maximunSelectionVar
{
    return  self.maximunSelection;
}
#pragma mark - Presenting view Methods


- (void)presentInView:(UIView *)view withCallback:(void (^)(BOOL))success
{
    if (!self.hidden) {
        return;
    }
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        if (status == PHAuthorizationStatusAuthorized) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                imageManager = [[PHCachingImageManager alloc]init];

                fetchResult = [self fetchResultWithType:myAssetType];
                
                 
                [self addActionButtons:actionArray];
                
                [view addSubview:self];
                
                
                [self alignToView:view];
                [self animatePresentation];
                
                success(YES);
            });
        }
        else{
            
            success(NO);

        }
      }];
    
    
}


- (void)animatePresentation{
    
    
    
    [assetCollectionView reloadData];
    
    
    self.backgroundColor = [UIColor clearColor];

    [self layoutIfNeeded];
    
    self.hidden = NO;
    
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        
        attachmentViewBottom.constant= 0.f;
        self.backgroundColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:0.5];

        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished){
        
    }];
}


-(void)alignToView:(UIView *)presentingView{
    
    
    
    [presentingView  addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:presentingView
                                                            attribute:NSLayoutAttributeWidth
                                                           multiplier:1
                                                             constant:0]];
    
    // Height constraint
    [presentingView  addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:presentingView
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1
                                                             constant:0]];
    
    // Center horizontally
    [presentingView addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:presentingView
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0
                                                            constant:0.0]];
    
    // Center vertically
    [presentingView addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:presentingView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0
                                                            constant:0.0]];
    
}


-(void) actionButtonClicked:(id)sender{
    
    UIButton * button = (UIButton *)sender;
    [_delegate actionButtonItemClicked:(button.tag+1)];
    [self cancelButtonClicked:nil];
    
}

- (IBAction)addPhotoButtonClicked:(id)sender {
    
    [_delegate addAssetItemButtonClickedWithAssets:[NSArray arrayWithArray:selectedAssetsArray]];
    [self cancelButtonClicked:nil];

}

- (IBAction)cancelButtonClicked:(id)sender {
    
    [self.session stopRunning];
    [selectedAssetsArray removeAllObjects];
    
    
    [self layoutIfNeeded];
    
    
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        
        attachmentViewBottom.constant= -(attachmentContainerView.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished){
        
        [_delegate cancelButtonClicked];
        self.backgroundColor = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:0.5];

    }];

    

}





#pragma mark - CollectionViewDelegate methods
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (cameraViewPresent && self.permissionResult == AVCamSetupResultSuccess && (indexPath.item == 0 )) {
        
        CameraPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CameraPreviewCell" forIndexPath:indexPath];
 
        [cell showSessionwithLayer:self.previewLayer];
        
        return cell;
    }
#warning  index out of bound if indexpath.item = 0
    
    PHAsset *asset ;

    if (fetchResult.count>indexPath.item ) {
        asset = [fetchResult objectAtIndex:indexPath.item-[self incrementor]];
    }
     BICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BICollectionViewCell" forIndexPath:indexPath];
    
    cell.tag = indexPath.item - [self incrementor];
    cell.myDelegate = self;
    cell.imageView.image = nil;
    
    if ([selectedAssetsArray containsObject:asset]) {
        [cell setSelectedButton:YES];
    }
    else
    {
        [cell setSelectedButton:NO];

    }
    if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        cell.imageView.image = [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];

    }
    else
    {
        cell.representedAssetIdentifier = asset.localIdentifier;
        
        [imageManager requestImageForAsset:asset targetSize:thumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"iddd block   = %@  cell idd == %@",asset.localIdentifier,cell.representedAssetIdentifier);

           if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                cell.imageView.image = result;
            }
        }];

    }
    
    
    
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return fetchResult.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
     if (( cameraViewPresent && self.permissionResult == AVCamSetupResultSuccess ) && indexPath.item == 0) {
        
        [_delegate showImagePickerView];
         [self cancelButtonClicked:nil];

    }
    else
    {
        
        PHAsset *asset ;
        
        
        if (fetchResult.count>indexPath.item ) {
            asset = [fetchResult objectAtIndex:indexPath.item-[self incrementor]];
        }
        

        [_delegate selectAssetFromView:asset];
    }
}

#pragma mark -----------------------------------------------------------------------------------------------------------------------

-(NSUInteger)incrementor
{
  return   ( cameraViewPresent && self.permissionResult == AVCamSetupResultSuccess ) ? 1 : 0 ;
    
}

#pragma mark -----------------------------------------------------------------------------------------------------------------------
- (void)configureSession
{
    // if ( self.setupResult != AVCamSetupResultSuccess ) {
    //     return;
    // }
    self.session = [[AVCaptureSession alloc] init];

    NSError *error = nil;
    
    [self.session beginConfiguration];
    
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
     
    
    AVCaptureDevice *videoDevice = [self backCamera];
    if (!videoDevice) {
        videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
//    if ( ! videoDevice ) {
//        
//        videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
//        
//        if ( ! videoDevice ) {
//            videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
//        }
//    }
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if ( ! videoDeviceInput ) {
        NSLog( @"Could not create video device input: %@", error );
        self.permissionResult = AVCamSetupResultSessionConfigurationFailed;
        [self.session commitConfiguration];
        return;
    }
    if ( [self.session canAddInput:videoDeviceInput] ) {
        [self.session addInput:videoDeviceInput];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
            AVCaptureVideoOrientation initialVideoOrientation = AVCaptureVideoOrientationPortrait;
            if ( statusBarOrientation != UIInterfaceOrientationUnknown ) {
                initialVideoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
            }
            
            //self.previewView.videoPreviewLayer.connection.videoOrientation = initialVideoOrientation;
        } );
    }
    else {
        NSLog( @"Could not add video device input to the session" );
        self.permissionResult = AVCamSetupResultSessionConfigurationFailed;
        [self.session commitConfiguration];
        return;
    }
    
     
    
    [self.session commitConfiguration];
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [self.session startRunning];

}

- (AVCaptureDevice *)backCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            return device;
        }
    }
    return nil;
}

#pragma mark - BICollectionviewCell delegate methods

-(void)selectButtonTappedInCellTag:(NSUInteger)tag withState:(BOOL)selectedState
{
    if (fetchResult.count <= tag) {
      
        return;
    }

    
    
    

    // check whether maximum count reached
    if ([self maximumSelectionReached] && selectedState) {
        
        if ([self setMaximumCountReachedOnTag:tag]) {
            return;
        }
    }
    
    if (selectedState) {
        
            [selectedAssetsArray addObject:[fetchResult objectAtIndex:tag]];
  
    }
    else
    {

        [selectedAssetsArray removeObject:[fetchResult objectAtIndex:tag]];

    }
    
    // Change the button title if selected assets count is greater than zero
    if (selectedAssetsArray.count > 0 ) {
        
        [addLibraryItemButton setTitle:[NSString stringWithFormat:addLibraryItemButtonTitleAfterSelection,selectedAssetsArray.count] forState:UIControlStateNormal];
    }
    else
    {
        [addLibraryItemButton setTitle:addLibraryItemButtonTitle forState:UIControlStateNormal];
 
    }
    
}
-(BOOL)maximumSelectionReached
{
    if (selectedAssetsArray.count < [self maximunSelectionVar] ) {
        
        return NO;
    }
    
    return YES;
 
}

-(BOOL)setMaximumCountReachedOnTag:(NSUInteger)index
{
    NSUInteger incrementor = ( cameraViewPresent && self.permissionResult == AVCamSetupResultSuccess ) ? 1 : 0 ;


    switch (mySelectionBlockType) {
        case MaximunSelectionBlockingTypeBlockSeletion:
        {
            

            // Then dont add
            BICollectionViewCell *cell = (BICollectionViewCell *)[assetCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index+incrementor inSection:0]];
            if (cell) {
                [cell setSelectedButton:NO];
            }
            
            return YES;
        }

            break;
            
        case MaximunSelectionBlockingTypeRemoveFirstSelection:
            
        default:
        {

            if (selectedAssetsArray.count <= 0 ) {
                return NO;
            }
            PHAsset *firstSelectedAsset = selectedAssetsArray.firstObject;
            
            if ([fetchResult indexOfObject:firstSelectedAsset] != NSNotFound) {
                
                NSUInteger indexOfItem = [fetchResult indexOfObject:firstSelectedAsset];

                [selectedAssetsArray removeObject:firstSelectedAsset];
                
                // Then dont add
                BICollectionViewCell *cell = (BICollectionViewCell *)[assetCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexOfItem+incrementor inSection:0]];
                if (cell) {
                    [cell setSelectedButton:NO];
                }

            }
            
            
            return NO;
            
        }
            break;
    }
    
    
    
}


@end
