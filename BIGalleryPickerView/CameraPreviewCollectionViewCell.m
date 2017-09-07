//
//  CameraPreviewCollectionViewCell.m
//  PhotoPickerActionSheet
//
//  Created by Britto on 22/03/17.
//  Copyright © 2017 Britto. All rights reserved.
//

#import "CameraPreviewCollectionViewCell.h"

@implementation CameraPreviewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.cameraIconLabel setFont:[UIFont fontWithName:@"customFont" size:24]];
    [self.cameraIconLabel setText:@"\ue65F"];
    [self.cameraIconLabel setTextColor:[UIColor whiteColor]];
    
}


-(void)showSessionwithLayer:(AVCaptureVideoPreviewLayer *)previewLayer
{
    
    previewLayer.frame = self.layer.bounds;
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //Now you can add this layer to a view of your view controller
    [self.cameraPreviewView.layer addSublayer:previewLayer];
    
    [self.cameraPreviewView bringSubviewToFront:self.cameraIconLabel];
}


@end
