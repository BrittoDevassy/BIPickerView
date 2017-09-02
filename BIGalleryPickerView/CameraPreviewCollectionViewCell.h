//
//  CameraPreviewCollectionViewCell.h
//  PhotoPickerActionSheet
//
//  Created by Britto on 22/03/17.
//  Copyright © 2017 Britto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM( NSInteger, AVCamSetupResult ) {
    AVCamSetupResultSuccess,
    AVCamSetupResultCameraNotAuthorized,
    AVCamSetupResultSessionConfigurationFailed
};

@interface CameraPreviewCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;
@property (weak, nonatomic) IBOutlet UILabel *cameraIconLabel;
-(void)showSessionwithLayer:(AVCaptureVideoPreviewLayer *)previewLayer;

@end
