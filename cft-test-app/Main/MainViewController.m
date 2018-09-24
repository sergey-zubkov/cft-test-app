//
//  MainViewController.m
//  ctf-test-app
//
//  Created by Sergey Zubkov on 19.09.2018.
//  Copyright © 2018 strann1k. All rights reserved.
//

#import "MainViewController.h"
#import "ImageEditorView.h"
#import "RotateImageFilter.h"
#import "MirrorImageFilter.h"
#import "GrayscaleImageFilter.h"
#import "FilterOperation.h"
#import "DataSourceEntity.h"
#import "FilterResultCell.h"
#import "StorageHistory.h"

@interface MainViewController ()<ImageEditorViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet ImageEditorView *imageEditor;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property (strong, nonatomic) NSMutableArray<DataSourceEntity*> *dataSource;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (nonatomic, strong) StorageHistory *storage;
@end

@implementation MainViewController

#pragma mark -
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.storage = [[StorageHistory alloc] init];
    self.dataSource = [[_storage loadHistory] mutableCopy];
    if (self.dataSource == nil) {
        self.dataSource = [NSMutableArray new];
    }
    
    _imageEditor.filters = @[[RotateImageFilter new], [MirrorImageFilter new], [GrayscaleImageFilter new]];
    _imageEditor.delegate = self;
    
    [_resultTableView registerNib:[UINib nibWithNibName:@"FilterResultCell" bundle:nil] forCellReuseIdentifier:@"FilterResultCell"];
    _resultTableView.estimatedRowHeight = 0;
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.qualityOfService = NSQualityOfServiceBackground;
}


#pragma mark -
#pragma mark - ImageEditorViewDelegate

- (void)needSetImageEditor:(ImageEditorView*)imageEditor {
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"Image source" message:@"Select the image source" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertControler addAction:albumAction];
    [alertControler addAction:cameraAction];
    [alertControler addAction:cancelAction];
    
    [self presentViewController:alertControler animated:YES completion:nil];
}

- (void)imageEditor:(ImageEditorView*)imageEditor pressedFilter:(id<ImageFilter>)filter {
    DataSourceEntity *entity = [DataSourceEntity new];
    
    FilterOperation *operation = [[FilterOperation alloc] initWithSourceImage:imageEditor.sourceImage filter:filter];
    operation.progressBlock = ^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateCellWithEntity:entity];
        });
    };
    operation.completionBlock = ^{
        // Нужно сохранить файл в хранилище.
        StorageEntity *storageEntity = [StorageHistory saveImage:operation.resultImage];
        entity.operation = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            entity.imageURLOriginal = storageEntity.original;
            entity.imageURLThumbnail = storageEntity.thumbnail;
            
            // Обновить таблицу.
            [self updateCellWithEntity:entity];
            
            // Сохранить историю.
            [_storage saveHistory:_dataSource];
        });
    };
    
    entity.operation = operation;
    [self addCellWithEntity:entity];
    
    [_operationQueue addOperation:operation];
}


#pragma mark -
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataSourceEntity *entity = _dataSource[indexPath.row];
    
    if (entity.imageURLThumbnail != nil) {
        return 120;
    } else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DataSourceEntity *entity = _dataSource[indexPath.row];
    if (entity.imageURLThumbnail == nil || entity.imageURLOriginal == nil) {
        return;
    }
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save to album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImage *image = [StorageHistory loadImageWithURL:entity.imageURLOriginal];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }];
    UIAlertAction *sourceAction = [UIAlertAction actionWithTitle:@"As source" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImage *image = [StorageHistory loadImageWithURL:entity.imageURLOriginal];
        self.imageEditor.sourceImage = image;
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        DataSourceEntity *entity = [_dataSource objectAtIndex:indexPath.row];
        [self deleteCellWithEntity:entity];
        //
        [StorageHistory removeFileWithURL:entity.imageURLOriginal];
        [StorageHistory removeFileWithURL:entity.imageURLThumbnail];
        [_storage saveHistory:_dataSource];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"Image result" message:@"What to do?" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertControler addAction:saveAction];
    [alertControler addAction:sourceAction];
    [alertControler addAction:deleteAction];
    [alertControler addAction:cancelAction];
    
    [self presentViewController:alertControler animated:YES completion:nil];
}


#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterResultCell"];
    cell.entity = _dataSource[indexPath.row];
    
    return cell;
}


#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *takeImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imageEditor.sourceImage = takeImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark - private

- (void)updateCellWithEntity:(DataSourceEntity*)entity {
    NSInteger indexEntity = [_dataSource indexOfObject:entity];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexEntity inSection:0];
    
    [_resultTableView beginUpdates];
    [_resultTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [_resultTableView endUpdates];
}

- (void)addCellWithEntity:(DataSourceEntity*)entity {
    [_dataSource insertObject:entity atIndex:0];
    NSInteger indexEntity = [_dataSource indexOfObject:entity];;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexEntity inSection:0];
    
    [_resultTableView beginUpdates];
    [_resultTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [_resultTableView endUpdates];
}

- (void)deleteCellWithEntity:(DataSourceEntity*)entity {
    NSInteger indexEntity = [_dataSource indexOfObject:entity];
    [_dataSource removeObject:entity];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexEntity inSection:0];
    
    [_resultTableView beginUpdates];
    [_resultTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [_resultTableView endUpdates];
}

@end
