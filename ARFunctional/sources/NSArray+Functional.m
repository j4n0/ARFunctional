
// BSD License. Created by jano@jano.com.es

#import "NSArray+Functional.h"

@implementation NSArray(Functional)

#pragma mark - Container

-(BOOL) and: (BOOL(^)(id object))block {
	NSParameterAssert(block != nil);
    BOOL result = YES;
    for (id object in ((id<NSFastEnumeration>)self)) {
        if (!block(object)){
            result = NO;
            break;
        }
    }
    return result;
}

-(BOOL) or: (BOOL(^)(id object))block {
	NSParameterAssert(block != nil);
    BOOL result = NO;
    for (id object in ((id<NSFastEnumeration>)self)) {
        if (block(object)){
            result = YES;
            break;
        }
    }
    return result;
}

- (void) each: (void (^)(id object))block {
    NSParameterAssert(block != nil);
    for (id object in ((id<NSFastEnumeration>)self)) {
        block(object);
    }
}

-(id) find: (BOOL(^)(id object))block {
	NSParameterAssert(block != nil);
    id result;
    for (id object in ((id<NSFastEnumeration>)self)) {
        if (block(object)){
            result = object;
            break;
        }
    }
    return result;
}

- (id) reduce: (id(^)(id a, id b))block {
    NSParameterAssert(block != nil);
    id result;
    for (id object in ((id<NSFastEnumeration>)self)){
        result = block(result,object);
    }
    return result;
}

#pragma mark - Element Container

-(instancetype) map: (id(^)(id object))block {
    NSParameterAssert(block != nil);
    id result = [[self class] emptyMutable];
    for (id object in ((id<NSFastEnumeration>)self)){
        [result addObject:block(object)];
    }
    return result;
}

- (instancetype) pluck: (NSString*)keyPath {
    NSParameterAssert(keyPath != nil);
    return [self map:^id(id object) {
        return [object valueForKeyPath:keyPath];
    }];
}

-(NSArray*) split:(NSUInteger)numberOfPartitions {
    id result = [NSMutableArray new];
    if (numberOfPartitions>0){
        NSUInteger i = 0;
        id subcollection = [[self class] emptyMutable];
        for (id object in ((id<NSFastEnumeration>)self)){
            [subcollection addObject:object];
            i++;
            if (i%numberOfPartitions==0) {
                [result addObject:subcollection];
                subcollection = [[self class] emptyMutable];
            } else if (i==[self count]){
                [result addObject:subcollection];
            }
        }
    }
	return [NSArray arrayWithArray:result];
}

- (instancetype) where: (BOOL(^)(id object))block {
	NSParameterAssert(block != nil);
    id result = [[self class] emptyMutable];
    for (id object in ((id<NSFastEnumeration>)self)){
        if (block(object)==YES){
            [result addObject:object];
        }
    }
	return result;
}

#pragma mark - NSArray specific

+(id<ARMutableElementContainer>) emptyMutable {
    return [NSMutableArray new];
}

- (void) eachWithIndex: (void (^)(id object, int index))block {
    NSParameterAssert(block != nil);
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj,idx);
    }];
}

- (instancetype) head: (NSUInteger)numberOfElements {
    if ([self count]<numberOfElements) numberOfElements = [self count];
    id result = [[self class] emptyMutable];
    for (NSUInteger i=0; i<numberOfElements; i++) {
        [result addObject:self[i]];
    }
    return result;
}

- (instancetype) tail: (NSUInteger)numberOfElements {
    if ([self count]<numberOfElements) numberOfElements = [self count];
    id result = [[self class] emptyMutable];
    numberOfElements = [self count] - numberOfElements;
    while (numberOfElements!=[self count]){
        [result addObject:self[numberOfElements]];
        numberOfElements++;
    }
    return result;
}

-(void) until: (BOOL(^)(id object))block {
	NSParameterAssert(block != nil);
    for (id object in ((id<NSFastEnumeration>)self)) {
        if (block(object)){
            break;
        }
    }
}

@end
