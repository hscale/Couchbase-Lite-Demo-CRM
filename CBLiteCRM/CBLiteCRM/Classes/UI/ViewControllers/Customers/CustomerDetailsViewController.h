//
//  CustomerDetailsViewController.h
//  CBLiteCRM
//
//  Created by Ruslan on 11/28/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "TextFieldsViewController.h"
#import "UIViewController+ReadOnlyOrWriteMode.h"

@class Customer;

@interface CustomerDetailsViewController : TextFieldsViewController<EditableViewControllers>

@property (weak, nonatomic) IBOutlet UITextField *companyNameField;
@property (weak, nonatomic) IBOutlet UITextField *industryField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *mailField;
@property (weak, nonatomic) IBOutlet UITextField *URLField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;

@property (strong, nonatomic) Customer *currentCustomer;

@end
