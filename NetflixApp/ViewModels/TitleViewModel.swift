//
//  TitlePreviewViewModel.swift
//  NetflixApp
//
//  Created by Mostafa Mahmoud on 3/1/22.
//

import Foundation
class TitleViewModel
{
    func DownloadPressed(movieInfo:MovieInfo) {
        RealmFunction.shared.downloadData(movieInfo: movieInfo)
    }


    
}
