//
//  GameViewController.swift
//  ARGame
//
//  Created by punyawee  on 23/8/61.
//  Copyright © พ.ศ. 2561 Punyugi. All rights reserved.
//

import UIKit
import ARKit

class GameViewController: UIViewController {

    @IBOutlet weak var myARView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = ARWorldTrackingConfiguration()
        myARView.session.run(configuration)
        myARView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
    }

  

}
