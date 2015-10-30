//
//  ImageLoadingCollectionViewCell.h
//  CollectionViewAsyncImageLoading
//
//  Created by Dmitry Nelepov on 30.10.15.
//  Copyright © 2015 NelepovDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageLoadingCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) NSString *imageUrl;

@end
