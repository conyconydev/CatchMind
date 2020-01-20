//
//  SampleData.swift
//  CatchMind
//
//  Created by kwangrae kim on 2020/01/20.
//  Copyright © 2020 conyconydev. All rights reserved.
//

import Foundation

struct Sample {
    //MARK: value
    let title: String
    let description : String
    let image: String
    
}

struct SampleData {
    
    let samples = [Sample(title: "Phto" , description: "내용" , image: "이미지파일")];
    
}

