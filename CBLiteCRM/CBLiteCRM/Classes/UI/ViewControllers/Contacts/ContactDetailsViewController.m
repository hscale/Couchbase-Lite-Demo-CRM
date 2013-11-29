//
//  ContactDetailsViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

//UI
#import "ContactDetailsViewController.h"
#import "ImagePickerAngel.h"
#import "CustomersViewController.h"

//Data
#import "DataStore.h"
#import "Contact.h"
#import "Customer.h"

@interface ContactDetailsViewController (){
    UIImage* selectedImage;
    UITapGestureRecognizer* photoTapRecognizer;
    ImagePickerAngel * imagePickerAngel;
}

@end

@implementation ContactDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.baseScrollView setContentSize:self.contentView.frame.size];
    if(!photoTapRecognizer){
        photoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnPhoto)];
        [self.photoView addGestureRecognizer:photoTapRecognizer];
        self.photoView.userInteractionEnabled = YES;
    }
    [self loadInfoForContact:self.currentContact];
}

- (void)loadInfoForContact:(Contact*)ct{
    if(ct){
        self.nameField.text = ct.name;
        self.positionField.text = ct.position;
        self.phoneField.text = ct.phoneNumber;
        self.mailField.text = ct.email;
        self.addressField.text = ct.address;
        [self updatePhotoWithContact:ct];
    }
}
- (void)updatePhotoWithContact:(Contact*)ct{
    UIImage* img = [self imageFromAttachment:[ct attachmentNamed:@"photo"]];
    if(img)
        self.photoView.image = img;
}

- (void)didTapOnPhoto{
    if([self.currentContact attachmentNames].count==0)
        [self pickNewImage];
}

- (void) pickNewImage
{
    if(!imagePickerAngel) {
        imagePickerAngel = [ImagePickerAngel new];
        imagePickerAngel.parentViewController = self;
    }
    imagePickerAngel.onPickedImage = [self createOnPickedImageBlock];
    [imagePickerAngel presentImagePicker];
}

- (ImagePickerAngelBlock) createOnPickedImageBlock
{
    __weak typeof(self) weakSelf = self;
    return ^(UIImage * image) { weakSelf.photoView.image = image; selectedImage = image;};
}

- (IBAction)back:(id)sender {
    self.currentContact = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveItem:(id)sender {
    if(self.mailField.text && ![self.mailField.text isEqualToString:@""]){
        Contact* newContact = self.currentContact;
        if(!newContact){
            newContact = [[DataStore sharedInstance] createContactWithMailOrReturnExist:self.mailField.text];
        }
        [self updateInfoForContact:newContact];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)deleteItem:(id)sender {
}

- (void)updateInfoForContact:(Contact*)ct{
    ct.name = self.nameField.text;
    ct.customer = [self selectedCustomer];
    ct.position = self.positionField.text;
    ct.phoneNumber = self.phoneField.text;
    ct.address = self.addressField.text;
    ct.opportunities = [self selectedOpportunities];
    if(selectedImage)
        [ct addAttachment:[self attachmentFromPhoto:selectedImage] named:@"photo"];
    NSError* error;
    [ct save:&error];
    if(error)
        NSLog(@"error in save contact: %@", error);
}

- (NSArray*)selectedOpportunities{
    return @[];
}

- (Customer*)selectedCustomer{
    return nil;
}

- (CBLAttachment*)attachmentFromPhoto:(UIImage*)image{
    return [[CBLAttachment alloc] initWithContentType:@"image/png" body:UIImagePNGRepresentation(image)];
}
- (UIImage*)imageFromAttachment:(CBLAttachment*)attach{
    return [UIImage imageWithData:attach.body];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end