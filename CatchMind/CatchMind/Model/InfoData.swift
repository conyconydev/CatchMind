//
//  SampleData.swift
//  CatchMind
//
//  Created by kwangrae kim on 2020/01/20.
//  Copyright © 2020 conyconydev. All rights reserved.
//

import Foundation

struct MainPageInfo {
    //MARK: value
    let title: String
    let description : String
    let image: String
    
}

struct InfoData {
    
    let samples = [
        MainPageInfo(title: "Photo Object Detection" , description: "불러온 이미지에 있는 사물 인식" , image: "ic_photo"),
        MainPageInfo(title: "Real Time Object Detection" , description: "실시간으로 카메라에 보이는 사물 인식" , image: "ic_camera"),
        MainPageInfo(title: "Facial Analysis" , description: "사람 얼굴로부터 나이, 성별, 감정 추측" , image: "ic_emotion")]
    
}

