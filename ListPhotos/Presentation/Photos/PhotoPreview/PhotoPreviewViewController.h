//
//  PhotoPreviewViewController.h
//  ListPhotos
//
//  Created by Mohamed Ramadan on 08/01/2022.
//

#import <UIKit/UIKit.h> 

NS_ASSUME_NONNULL_BEGIN

@interface PhotoPreviewViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property NSString *imageUrlString;
@end

NS_ASSUME_NONNULL_END
