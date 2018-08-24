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
    let configuration = ARWorldTrackingConfiguration()
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var startingPositionNode: SCNNode?
    var endingPositionNode: SCNNode?
    let cameraRelativePosition = SCNVector3(0, 0, -0.1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configuration.planeDetection = .horizontal
        myARView.session.run(configuration)
        myARView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        myARView.autoenablesDefaultLighting = true
        myARView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        myARView.addGestureRecognizer(tapGesture)
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
        boxNode.name = "Box"
        myARView.scene.rootNode.addChildNode(boxNode)
    }
    
    @IBAction func tappedResetBtn(_ sender: UIButton) {
        resetARView()
    }
    func removeAllNode() {
        for node in myARView.scene.rootNode.childNodes {
            node.removeFromParentNode()
        }
    }
    func resetARView() {
        removeAllNode()
        myARView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
    
    func getFloor(anchor: ARPlaneAnchor) -> SCNNode {
        let width = CGFloat(anchor.extent.x)
        let height = CGFloat(anchor.extent.y)
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = #colorLiteral(red: 0.9176, green: 0.3176, blue: 0.5647, alpha: 1)
        let planeNode = SCNNode(geometry: plane)
        let centerX = CGFloat(anchor.center.x)
        let centerY = CGFloat(anchor.center.y)
        let centerZ = CGFloat(anchor.center.z)
        planeNode.position = SCNVector3(centerX, centerY, centerZ)
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.name = "Floor"
        return planeNode
    }
    
    func removeAllNode(name: String) {
        for node in myARView.scene.rootNode.childNodes {
            if node.name == name {
                node.removeFromParentNode()
            }
        }
    }
}

extension GameViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("Added Anchor")
        guard let arPlaneAnchor = anchor as? ARPlaneAnchor else { return }
        let floor = getFloor(anchor: arPlaneAnchor)
        node.addChildNode(floor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print("Update Anchor")
        guard let arPlaneAnchor = anchor as? ARPlaneAnchor else { return }
        guard let planeNode = node.childNodes.first else { return }
        guard let plane = planeNode.geometry as? SCNPlane else { return }
        plane.width = CGFloat(arPlaneAnchor.extent.x)
        plane.height = CGFloat(arPlaneAnchor.extent.z)
        planeNode.position = SCNVector3(CGFloat(arPlaneAnchor.center.x), CGFloat(arPlaneAnchor.center.y), CGFloat(arPlaneAnchor.center.z))
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("Remove Anchor")
        removeAllNode(name: "Floor")
    }
    
    @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
        print("Tapped")
//        let location = gesture.location(in: myARView)
//        guard let result = myARView.hitTest(location, options: nil).first, let name = result.node.name else { return }
//        print(name)
        if startingPositionNode != nil && endingPositionNode != nil {
            startingPositionNode?.removeFromParentNode()
            endingPositionNode?.removeFromParentNode()
            startingPositionNode = nil
            endingPositionNode = nil
        }
        else if startingPositionNode != nil && endingPositionNode == nil {
            let sphere = SCNNode(geometry: SCNSphere(radius: 0.001))
            sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
            Service.addChildNode(sphere, toNode: myARView.scene.rootNode, inView: myARView, cameraRelativePosition: cameraRelativePosition)
            endingPositionNode = sphere
        }
        else if startingPositionNode == nil && endingPositionNode == nil {
            let sphere = SCNNode(geometry: SCNSphere(radius: 0.001))
            sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            Service.addChildNode(sphere, toNode: myARView.scene.rootNode, inView: myARView, cameraRelativePosition: cameraRelativePosition)
            startingPositionNode = sphere
        }

    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if startingPositionNode != nil && endingPositionNode != nil  {
            return
        }
        guard let xDistance = Service.distance3(fromStartingPositionNode: startingPositionNode, onView: myARView, cameraRelativePosition: cameraRelativePosition)?.x else {return}
        guard let yDistance = Service.distance3(fromStartingPositionNode: startingPositionNode, onView: myARView, cameraRelativePosition: cameraRelativePosition)?.y else {return}
        guard let zDistance = Service.distance3(fromStartingPositionNode: startingPositionNode, onView: myARView, cameraRelativePosition: cameraRelativePosition)?.z else {return}
        DispatchQueue.main.async {
            self.xLabel.text = String(format: "x: %.2f", xDistance) + "m"
            self.yLabel.text = String(format: "y: %.2f", yDistance) + "m"
            self.zLabel.text = String(format: "z: %.2f", zDistance) + "m"
            self.distanceLabel.text = String(format: "Distance: %.2f", Service.distance(x: xDistance, y: yDistance, z: zDistance)) + "m"
        }
    }
    
}
