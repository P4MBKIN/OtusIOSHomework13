//
//  FeedDataProvider.swift
//  OTUS
//
//  Created by Дмитрий Матвеенко on 16/06/2019.
//  Copyright © 2019 GkFoxes. All rights reserved.
//

import Foundation

struct FeedDataProvider {
    
    func feedMockData() -> [FeedData] {
        return [
            FeedData(name: "Array"),
            FeedData(name: "Set"),
            FeedData(name: "Dictionary"),
        ]
    }
}
