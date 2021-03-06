//
//  ServiceEngine.m
//  Ezine
//
//  Created by Nguyen van phuoc on 8/30/12.
//
//

#import "ServiceEngine.h"

@implementation ServiceEngine


#pragma mark - Implement service for cover page
/*
    Implement for cover service engine
*/
-(void) listTopCoveronCompletion:(ResponeBlock1) responeBlock onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"home/GetTopCoverArticle/5"];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        responeBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    [self enqueueOperation:op];
}

-(void) listTopSiteonCompletion:(ResponeBlock1) responeBlock onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"home/GetTopSite/5"];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        responeBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName;
    cacheDirectoryName= [documentsDirectory stringByAppendingPathComponent:@"ImageCache"];
    return cacheDirectoryName;
}


#pragma mark - Implement service for first page
/*
 
    Service for first page
*/
-(void) listSiteMasterPage:(BOOL)reload OnCompletion:(ResponeBlock) responeBlock onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"/home/GetListSite"];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        responeBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    if (reload==YES) {
        [self enqueueOperation:op];

    }else{
        [self enqueueOperationReload:op];

    }
}


#pragma mark - Implement service for list article page
// service for list article page
-(void) GetListArticleInSitePagingID:(int) siteID  onCompletion:( ResponeBlock1) completionBlock
                             onError:(MKNKErrorBlock) errorBlock{
    NSLog(@"site id===== %d",siteID);
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"site/GetListArticleInSitePaging/%d",siteID]];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}
// service update list article page 
-(MKNetworkOperation*) getListArticleUpdateInSitePagingID:(int) siteID inchanelID:(int)chanelID FromTime:(NSString*) time numberOffPage:(int) numberPage onCompletion:( ResponeBlock) completionBlock
                                   onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op;
    NSLog(@"get article in site: %d  and chanel: %d from time: %@",siteID,chanelID,time);
    if (chanelID>0) {
        MKNetworkOperation *op1 = [self operationWithPath:@"site/GetListArticlePaging"
                                                  params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [NSString stringWithFormat:@"%d",siteID], @"SiteID",
                                                          [NSString stringWithFormat:@"%d",chanelID], @"ChannelID",                                      time, @"FromTime",
                                                          [NSString stringWithFormat:@"%d" ,numberPage], @"NumberOfPage",
                                                          nil]
                                              httpMethod:@"POST"];
        
        
        // setFreezable uploads your images after connection is restored!
        [op1 setFreezable:YES];
        
        [op1 onCompletion:^(MKNetworkOperation* completedOperation) {
            
            completionBlock([completedOperation responseJSON]);
            
        }
                 onError:^(NSError* error) {
                     
                     errorBlock(error);
                 }];
        
        [self enqueueOperation:op1];
        
        
        return op1;

    }else{
        op = [self operationWithPath:@"site/GetListArticlePaging"
                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%d" ,siteID], @"SiteID",
                                      time, @"FromTime",
                                      [NSString stringWithFormat:@"%d" ,numberPage], @"NumberOfPage",
                                      nil]
                          httpMethod:@"POST"];

    }
        
    
    // setFreezable uploads your images after connection is restored!
    [op setFreezable:YES];
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        completionBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
             }];
    
    [self enqueueOperation:op];
    
    
    return op;

}

/*
 For SiteDetail service engine
 */
-(void) listCategoryForSource:(NSInteger) idSource onCompletion:(ResponeBlock1) responeBlock onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"services/rest/?method=flickr.photos.search&api_key=210af0ac7c5dad997a19f7667e5779d3&tags=Singapore&per_page=200&format=json&nojsoncallback=1"];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        NSDictionary *response = [completedOperation responseJSON];
        responeBlock([[response objectForKey:@"photos"] objectForKey:@"photo"]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

#pragma mark - Implement service for select site
-(void)ListCategories:(ResponeBlock1)responeBlock onError:(MKNKErrorBlock)errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"home/GetListCategory"];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        responeBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];

}

-(void)listSiteByCategoryID:(int)CategoryID onCompletion:(ResponeBlock)responeBlock onError:(MKNKErrorBlock)errorBlock{
    NSString *apiget=[[NSString alloc] initWithFormat:@"home/GetListSiteByCategoryID/%d",CategoryID];
    MKNetworkOperation *op = [self operationWithPath:apiget];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        responeBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    [self enqueueOperation:op];
}

-(void)getLastestForSourceOnCompletion:(ResponeBlock1)responeBlock onError:(MKNKErrorBlock)errorBlock{
    
    MKNetworkOperation *op = [self operationWithPath:@"home/GetListArticleHighlight"];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        responeBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperationReload:op];

}

-(void)SearchSiteEngineSiteName:(NSString *)siteName onCompletion:(ResponeBlock1)completionBlock onError:(MKNKErrorBlock)errorBlock{
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"home/SearchSite/%@",siteName]];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

#pragma mark - service for account settings

-(void) changePass:(NSDictionary*)infor onCompletion:(ResponeBlock) responeBlock onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"user/ChangePass"
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [infor objectForKey:@"UserID"], @"UserID",
                                                      [infor objectForKey:@"CurPassword"], @"CurPassword",
                                                      [infor objectForKey:@"NewPassword"], @"NewPassword",
                                                      nil]
                                          httpMethod:@"POST"];
    
    
    // setFreezable uploads your images after connection is restored!
    [op setFreezable:YES];
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        responeBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
             }];
    
    [self enqueueOperation:op];

}


#pragma mark-- service for Site

-(void) getDetailAsite:(int)site onCompletion:(ResponeBlock) responeBlock onError:(MKNKErrorBlock) errorBlock{
    NSString *apiget=[[NSString alloc] initWithFormat:@"site/GetSiteDetails/%d",site];
    MKNetworkOperation *op = [self operationWithPath:apiget];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        responeBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    [self enqueueOperationReload:op];
}

-(void) getChangeFromSite:(int)site onCompletion:(ResponeBlock1) responeBlock onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"site/GetListChannelInSite/%d",site]];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        responeBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

-(void) getLatestSourceNewSite:(int)idSite onCompletion:(ResponeBlock) responeBlock onError:(MKNKErrorBlock) errorBlock{
    NSString *apiget=[[NSString alloc] initWithFormat:@"site/GetListNewArticleInSite/%d",idSite];
    NSLog(@"url get =====%@",apiget);
    MKNetworkOperation *op = [self operationWithPath:apiget];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        responeBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    [self enqueueOperation:op];

}

// service get list article for 1 site
-(MKNetworkOperation*) getListArticleInsite:(int)siteID FromTime:(NSString*) time numberOffPage:(int) numberPage onCompletion:( ResponeBlock) completionBlock
                                    onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"site/GetListArticlePaging"
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSString stringWithFormat:@"%d",siteID], @"SiteID",
            [NSString stringWithFormat:@"%d" ,numberPage], @"NumberOfPage",
                                                      nil]
                                          httpMethod:@"POST"];
    
    
    // setFreezable uploads your images after connection is restored!
    [op setFreezable:YES];
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        completionBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
             }];
    
    [self enqueueOperation:op];
    
    
    return op;

}

    //========== get list article for chanel in a site
-(MKNetworkOperation*) getListArticleChanelInsite:(int)siteID chanelID:(int)chanelID FromTime:(NSString*) time numberOffPage:(int) numberPage onCompletion:( ResponeBlock) completionBlock
                                          onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"site/GetListArticlePaging"
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSString stringWithFormat:@"%d",siteID], @"SiteID",
                                                      [NSString stringWithFormat:@"%d",chanelID], @"ChannelID",                                      time, @"FromTime",
                                                      [NSString stringWithFormat:@"%d" ,numberPage], @"NumberOfPage",
                                                      nil]
                                          httpMethod:@"POST"];
    
    
    // setFreezable uploads your images after connection is restored!
    [op setFreezable:YES];
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        completionBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
             }];
    
    [self enqueueOperation:op];
    
    
    return op;

}
#pragma mark-- for Article
-(void) GetArticleDetail:(int) ArticleDetailID  onCompletion:( ResponeBlock) completionBlock
                 onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"Article/GetArticleDetails/%d",ArticleDetailID]];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    
}
//Service for sendComment

-(void)SentCommentwithSiteident:(int)SiteID userident:(int)userID withComment:(NSString *)commentText onCompletion:(ResponeBlock)responeBlock onError:(MKNKErrorBlock)errorBlock{
    
    
    MKNetworkOperation *op = [self operationWithPath:@"site/SentComment"
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [NSString stringWithFormat:@"%d" ,SiteID], @"SiteID",
                                                      commentText, @"Comment",
                                                      nil]
                                          httpMethod:@"POST"];
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        responeBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
             }];
    
    [self enqueueOperation:op];
    
    
}

//Service for Rating star Okey=============

-(void) RatewithSiteID:(int)siteID anduserID:(int)userID andRateMark:(int)rateMark onCompletion:(ResponeBlock) responeBlock onError:(MKNKErrorBlock) errorBlock{
    
    MKNetworkOperation *op = [self operationWithPath:@"site/Rate"
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSString stringWithFormat:@"%d" ,siteID], @"SiteID",
                                                      [NSString stringWithFormat:@"%d" ,userID], @"UserID",
                                                      [NSString stringWithFormat:@"%d",rateMark], @"RateMark",
                                                      nil]
                                          httpMethod:@"POST"];
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        responeBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
             }];
    
    [self enqueueOperation:op];    
}
#pragma mark--- search keyword
// service for search keyword
-(MKNetworkOperation*) getListArticleSearchInAllsite:(NSString*)keyWord FromTime:(NSString*) time numberOffPage:(int) numberPage onCompletion:( ResponeBlock) completionBlock
                                             onError:(MKNKErrorBlock) errorBlock{
    
    MKNetworkOperation *op = [self operationWithPath:@"site/GetListArticlePaging"
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      keyWord, @"Keyword",
                                                      time, @"FromTime",
                                                      [NSString stringWithFormat:@"%d" ,numberPage], @"NumberOfPage",
                                                      nil]
                                          httpMethod:@"POST"];
    
    [op setPostDataEncoding:MKNKPostDataEncodingTypeURL];
    // setFreezable uploads your images after connection is restored!
    [op setFreezable:YES];
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        completionBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
             }];
    
    [self enqueueOperation:op];
    
    
    return op;
    

}
//=============seach in 1 site
-(MKNetworkOperation*) getListArticleSearchInSite:(int)siteID inchanelID:(int)chanelID KeyWold:(NSString*)keyWord FromTime:(NSString*) time numberOffPage:(int) numberPage onCompletion:( ResponeBlock) completionBlock
                                          onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op;
    if (chanelID>0) {
        op = [self operationWithPath:@"site/GetListArticlePaging"
                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%d",siteID],@"SiteID",
                                      [NSString stringWithFormat:@"%d",chanelID],@"ChannelID",
                                      keyWord, @"Keyword",
                                      time, @"FromTime",
                                      [NSString stringWithFormat:@"%d" ,numberPage], @"NumberOfPage",
                                      nil]
                          httpMethod:@"POST"];

    }else{
        op = [self operationWithPath:@"site/GetListArticlePaging"
                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%d",siteID],@"SiteID",
                                      keyWord, @"Keyword",
                                      time, @"FromTime",
                                      [NSString stringWithFormat:@"%d" ,numberPage], @"NumberOfPage",
                                      nil]
                          httpMethod:@"POST"];

    }
        
    [op setPostDataEncoding:MKNKPostDataEncodingTypeURL];
    // setFreezable uploads your images after connection is restored!
    [op setFreezable:YES];
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        completionBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
             }];
    
    [self enqueueOperation:op];
    
    
    return op;

}
#pragma mark--- rating and comment
-(void) listRaringSite:(int )SiteID onCompletion:(ResponeBlock) categoryBlock onError:(MKNKErrorBlock) errorBlock{
    NSString *apiget=[[NSString alloc] initWithFormat:@"site/GetFullSiteDetails/%d",SiteID];
    MKNetworkOperation *op = [self operationWithPath:apiget];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        // NSDictionary *response = [completedOperation responseJSON];
        categoryBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];

}

#pragma mark--- get list article from keyword
-(void) getListArticleUserKeyword:(ResponeBlock1) responeBlock onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"user/GetListKeyword"];
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        responeBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    [self enqueueOperationReload:op];
}

#pragma mark-  add remove keyword
-(void) UserAddKeyWord:(NSString*)keyword inSite:(int) siteID onCompletion:( ResponeBlock) completionBlock
               onError:(MKNKErrorBlock) errorBlock{
    if (siteID==0) {
        siteID=-1;
    }
    NSLog(@"siteID add==%d keyword===%@",siteID,keyword);

    MKNetworkOperation *op = [self operationWithPath:@"user/AddKeyword"
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      keyword, @"Keyword",[NSString stringWithFormat:@"%d",siteID],@"SiteID",nil]
                                          httpMethod:@"POST"];
    
    // setFreezable uploads your images after connection is restored!
    [op setPostDataEncoding:MKNKPostDataEncodingTypeURL];

    [op setFreezable:YES];
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        completionBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
                 NSString   *sessionID=[[NSUserDefaults standardUserDefaults] objectForKey:@"EzineAccountSessionId"];
                 
                 NSString *errors=[NSString stringWithFormat:@"api bị lỗi không gửi đc. Thông số api: \ntên api truyền : http://api.ezine.vn/user/AddKeyword \n site id: %d \n keyword:  %@ \n ASP.NET_SessionId:   %@\n method: POST",siteID, keyword,sessionID];
                 UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"api add keyword" message:errors delegate:self cancelButtonTitle:@"done" otherButtonTitles: nil];
                 [alert show];
                 [alert release];

             }];
    
    [self enqueueOperation:op];
    
   

    
}

#pragma mark--- bookmark
-(void) getListBookmarkFromtime:(NSString *)fromtime  numberPage:(int)numberpage onCompletion:( ResponeBlock) completionBlock onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"site/GetListArticlePaging"
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      fromtime, @"FromTime",[NSString stringWithFormat:@"%d",numberpage],@"NumberOfPage",nil]
                                          httpMethod:@"POST"];
    
    // setFreezable uploads your images after connection is restored!
    //[op setPostDataEncoding:MKNKPostDataEncodingTypeURL];
    
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        completionBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
             }];
    
    [self enqueueOperation:op];

}
//==== add bookmark
-(void) userAddBookMarkArticleID:(int)articleID onCompletion:( ResponeBlock) completionBlock onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"user/AddKeyword"
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",articleID],@"ArticleID",nil]
                                          httpMethod:@"POST"];
    
    // setFreezable uploads your images after connection is restored!
    //[op setPostDataEncoding:MKNKPostDataEncodingTypeURL];
    
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        completionBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
             }];
    
    [self enqueueOperation:op];
}

#pragma mark--- update list site user
-(void) updateListSiteUser:(NSString *)listSite onCompletion:( ResponeBlock) completionBlock onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"user/UpdateSiteList"
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      listSite, @"ListSite",nil]
                                          httpMethod:@"POST"];
    
    // setFreezable uploads your images after connection is restored!
    //[op setPostDataEncoding:MKNKPostDataEncodingTypeURL];
    
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        completionBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
             }];
    
    [self enqueueOperation:op];

    
}

#pragma mark-- remove a site from list
-(void) userremoveStie:(int)siteID onCompletion:( ResponeBlock) completionBlock onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"user/RemoveSite"
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSString stringWithFormat:@"%d",siteID], @"SiteID",nil]
                                          httpMethod:@"POST"];
    
    // setFreezable uploads your images after connection is restored!
    //[op setPostDataEncoding:MKNKPostDataEncodingTypeURL];
    
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        completionBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
             }];
    
    [self enqueueOperation:op];

}
#pragma mark--- add site to list
-(void) userAddsiteToList:(int)siteID onCompletion:( ResponeBlock) completionBlock onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:@"user/AddSite"
                                              params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSString stringWithFormat:@"%d",siteID], @"SiteID",nil]
                                          httpMethod:@"POST"];
    
    // setFreezable uploads your images after connection is restored!
    [op setPostDataEncoding:MKNKPostDataEncodingTypeURL];
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        completionBlock([completedOperation responseJSON]);
        
    }
             onError:^(NSError* error) {
                 
                 errorBlock(error);
             }];
    
    [self enqueueOperation:op];
   }

#pragma mark---- download offline
-(void) downloadDataOfflineSite:(int)siteID reload:(BOOL)reload onCompletion:( ResponeBlock) completionBlock onError:(MKNKErrorBlock) errorBlock{
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"site/GetListArticlePagingOffLine/%d",siteID]];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    if (reload) {
        [self enqueueOperation:op];

    }else{
        [self enqueueOperationReload:op];

    }

    
}

#pragma mark--- remove bookmark
- (void)GetListArticleRelative:(int) articleID  onCompletion:( ResponeBlock1) completionBlock onError:(MKNKErrorBlock) errorBlock{
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"Article/GetListArticleRelative/%d",articleID]];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        completionBlock([completedOperation responseJSON]);
        
    } onError:^(NSError *error) {
        
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];

}
@end
