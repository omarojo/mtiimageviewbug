//
//  UINavigationController+OrientationLock.swift
//  GenerateMetal-iOS
//
//  Created by Omar Juarez Ortiz on 2019-10-14.
//  Copyright © 2019 Generate Software Inc. All rights reserved.
//

import Foundation
import UIKit

class LockedNavigationController: UINavigationController {

    override var shouldAutorotate: Bool {
        let isiPad =  UIDevice.current.userInterfaceIdiom == .pad ? true : false
        if isiPad {
            return true
        }
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        let isiPad =  UIDevice.current.userInterfaceIdiom == .pad ? true : false
        if isiPad {
            return .all
        }
        return .portrait
    }

}
