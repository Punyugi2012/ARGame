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
    @IBOutlet weak var plusBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = ARWorldTrackingConfiguration()
        myARView.session.run(configuration)
        myARView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        myARView.autoenablesDefaultLighting = true
    }

    @IBAction func tappedPlusBtn(_ sender: UIButton) {
        addBox()
    }
    
    func addBox() {
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0.0)
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
        boxNode.position = SCNVector3(0, 0, 0)
        myARView.scene.rootNode.addChildNode(boxNode)
    }

}
