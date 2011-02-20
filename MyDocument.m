//
//  MyDocument.m
//  RaiseMan
//
//  Created by Charles Feduke on 2/13/11.
//  Copyright 2011 Mobile Posse. All rights reserved.
//

#import "MyDocument.h"
#import "PreferenceController.h"
#import "Person.h"

@implementation MyDocument

- (id)init {
    [super init];
	employees = [[NSMutableArray alloc] init];
	
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self 
		   selector:@selector(handleColorChange:) 
			   name:BNRColorChangedNotification 
			 object:nil];
	
	return self;
}

- (void)dealloc {
	[self setEmployees:nil];
	
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	
	
	[super dealloc];
}

-(void)handleColorChange:(NSNotification*)note {
	NSLog(@"received notification: %@", note);
	
	NSColor* color = [[note userInfo] objectForKey:@"color"];
	[tableView setBackgroundColor:color];
}

- (void)setEmployees:(NSMutableArray *)a {
	if (a == employees)
		return;
	
	for (Person *person in employees) {
		[self stopObservingPerson:person];
	}
	
	[a retain];
	[employees release];
	employees = a;
	
	for (Person *person in employees) {
		[self startObservingPerson:person];
	}
}

- (void)insertObject:(Person *)p inEmployeesAtIndex:(int)index {
	NSLog(@"adding %@ to %@", p, employees);
	NSUndoManager *undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] removeObjectFromEmployeesAtIndex:index];
	if (![undo isUndoing]) {
		[undo setActionName:@"Insert Person"];
	}
	[employees insertObject:p atIndex:index];
	[self startObservingPerson:p];
	
}

- (void)removeObjectFromEmployeesAtIndex:(int)index {
	Person *p = [employees objectAtIndex:index];
	NSLog(@"removing %@ from %@", p, employees);
	NSUndoManager *undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] insertObject:p
										 inEmployeesAtIndex:index];
	if (![undo isUndoing]) {
		[undo setActionName:@"Delete Person"];
	}
	
	[employees removeObjectAtIndex:index];
	[self stopObservingPerson:p];
}

- (void)startObservingPerson:(Person *)person {
	[person addObserver:self
			 forKeyPath:@"personName"
				options:NSKeyValueObservingOptionOld
				context:NULL];
	
	[person addObserver:self
			 forKeyPath:@"expectedRaise"
				options:NSKeyValueObservingOptionOld
				context:NULL];
}

- (void)stopObservingPerson:(Person *)person {
	[person removeObserver:self forKeyPath:@"personName"];
	[person removeObserver:self forKeyPath:@"expectedRaise"];
}

- (void)changeKeyPath:(NSString *)keyPath
			 ofObject:(id)obj
			  toValue:(id)newValue {
	[obj setValue:newValue forKeyPath:keyPath];
}
- (void)observeValueForKeyPath:(NSString *)keyPath 
					  ofObject:(id)object 
						change:(NSDictionary *)change 
					   context:(void *)context {
	NSUndoManager *undo = [self undoManager];
	id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
	
	if (oldValue == [NSNull null]) {
		oldValue = nil;
	}
	
	NSLog(@"oldValue = %@", oldValue);
	
	[[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
												  ofObject:object
												   toValue:oldValue];
	[undo setActionName:@"Edit"];
}

-(IBAction)createEmployee:(id)sender {
	NSWindow *w = [tableView window];
	
	BOOL editingEnded = [w makeFirstResponder:w];
	if (!editingEnded) {
		NSLog(@"Unable to end editing.");
		return;
	}
	
	NSUndoManager *undo = [self undoManager];
	
	if ([undo groupingLevel]) {
		[undo endUndoGrouping];
		[undo beginUndoGrouping];
	}
	
	Person *p = [employeeController newObject];
	
	[employeeController addObject:p];;
	[p release];
	
	[employeeController rearrangeObjects];
	
	NSArray *a = [employeeController arrangedObjects];
	
	int row = [a indexOfObjectIdenticalTo:p];
	NSLog(@"starting edit of %@ in row %d", p, row);
	
	[tableView editColumn:0
					  row:row
				withEvent:nil
				   select:YES];
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData* colorAsData;
	colorAsData = [defaults objectForKey:BNRTableBgColorKey];
	[tableView setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:colorAsData]];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	[[tableView window] endEditingFor:nil];
	
	return [NSKeyedArchiver archivedDataWithRootObject:employees];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSLog(@"About to read data of type %@", typeName);
	NSMutableArray *newArray = nil;
	@try {
		newArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
	@catch (NSException * e) {
		if (outError) {
			NSDictionary *d = [NSDictionary dictionaryWithObject:@"The data is corrupted."
														  forKey:NSLocalizedFailureReasonErrorKey];
			*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:d];
			return NO;
		}
	}
	
	[self setEmployees:newArray];
	return YES;
}
-(IBAction)removeEmployee:(id)sender {
	NSArray* selectedPeople = [employeeController selectedObjects];
	NSAlert* alert = [NSAlert alertWithMessageText:@"Delete?" 
									 defaultButton:@"Delete" 
								   alternateButton:@"Cancel" 
									   otherButton:@"No Raise" 
						 informativeTextWithFormat:@"Do you really want to delete %d people?", [selectedPeople count]]; 
	[alert beginSheetModalForWindow:[tableView window]
					  modalDelegate:self
					 didEndSelector:@selector(alertEnded:code:context:)
						contextInfo:NULL];
}

-(void)alertEnded:(NSAlert*)alert
			 code:(int)choice
		  context:(void*)v {
	NSLog(@"alert sheet ended");
	if (choice == NSAlertDefaultReturn) {
		NSLog(@"NSAlertDefaultReturn");
		[employeeController remove:nil];
	}
	else if (choice == NSAlertOtherReturn) {
		NSLog(@"NSAlertOtherReturn");
		for (Person* person in [employeeController selectedObjects]) {
			NSLog(@"removing raise for \"%s\"", [person personName]);
			[person removeRaise];
		}
	}
}
@end
