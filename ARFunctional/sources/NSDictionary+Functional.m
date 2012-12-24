
// BSD License. Created by jano@jano.com.es

#import "NSDictionary+Functional.h"

@implementation NSDictionary(Functional)

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

- (instancetype) pluck: (NSString*)keyPath {
    return [self map:^id(id object) {
        return [object valueForKeyPath:keyPath];
    }];
}

-(NSArray*) split:(NSUInteger)numberOfPartitions {
    id result = [NSMutableArray new];
    if (numberOfPartitions>0){
        NSUInteger i = 0;
        id subcollection = [[self class] emptyMutable];
        for (id key in [self allKeys]){
            [subcollection setObject:[self objectForKey:key] forKey:key];
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

#pragma mark - Map Container

-(instancetype) map: (id(^)(id object))block {
    NSParameterAssert(block != nil);
    id result = [[self class] emptyMutable];
    for (id key in [self allKeys]){
        [result setObject:block([self objectForKey:key]) forKey:key];
    }
    return result;
}

- (instancetype) where: (BOOL(^)(id object))block {
	NSParameterAssert(block != nil);
    id result = [[self class] emptyMutable];
    for (id key in [self allKeys]){
        id object = [self objectForKey:key];
        if (block(object) == YES) {
            [result setObject:object forKey:key];
        }
    }
	return result;
}

#pragma mark - NSDictionary specific

+(id<ARMutableMapContainer>) emptyMutable {
    return [NSMutableDictionary new];
}

@end
