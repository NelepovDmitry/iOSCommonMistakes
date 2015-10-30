//
//  ViewController.m
//  CollectionViewAsyncImageLoading
//
//  Created by Dmitry Nelepov on 30.10.15.
//  Copyright © 2015 NelepovDS. All rights reserved.
//

#import "ViewController.h"
#import "ImageLoadingCollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *images = @[
                        @"http://s1.iconbird.com/ico/0512/iconspackbyCem/w256h2561337871612256.png",
                        @"http://s1.iconbird.com/ico/0512/iconspackbyCem/w256h2561337871699256.png",
                        @"http://www.veziauto.ru/bitrix/images/w256h2571389895762BMW.png",
                        @"http://pngicon.ru//data/media/2/1_2882.png"
                        ];
    
    self.array = [NSMutableArray array];
    NSUInteger index = 0;
    for (NSInteger i = 0; i < 3000; i++) {
        
        [self.array addObject:images[index]];
        index ++;
        
        if (index == images.count) {
            index = 0;
        }
    }
    
    [self initCollectionView];
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerReload) userInfo:nil repeats:YES];
}

- (void)timerReload {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake(80, 80);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flow];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageLoadingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageLoadingCollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:@{ @"collectionView" : self.collectionView }]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:@{ @"collectionView" : self.collectionView }]];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageLoadingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageLoadingCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(ImageLoadingCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = [NSString stringWithFormat:@"Item:%@", @(indexPath.item)];
    cell.imageUrl = self.array[indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(ImageLoadingCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.titleLabel.text = @"";
//    cell.imageView.image = nil;
}


@end
