//
//  PhotoPreviewViewController.m
//  ListPhotos
//
//  Created by Mohamed Ramadan on 08/01/2022.
//

#import "PhotoPreviewViewController.h"
#import "ListPhotos-Swift.h"

@interface PhotoPreviewViewController ()

@end

@implementation PhotoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     
    _scrollView.delegate = self;
    
    // For supporting zoom,
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 3.0;
    
    if (self.imageUrlString != nil) {
        NSURL *url = [NSURL URLWithString:self.imageUrlString];
        [_photoImageView loadImageFrom:url backgroundImage:nil identifier:nil];
    }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    return _photoImageView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
