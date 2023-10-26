//
//  ViewController.swift
//  Malfunction
//
//  Created by 新翌王 on 2023/10/26.
//


import UIKit
import SceneKit
import ARKit
import AVFoundation
import Combine

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    var videoPlayer: AVPlayer!
    var savedAnchors = [ARAnchor]()
    
    var imageAnchor: ARImageAnchor!
    var place: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView = ARSCNView(frame: view.bounds)
        view.addSubview(sceneView)

        sceneView.delegate = self    
        NotificationCenter.default.addObserver(self, selector: #selector(removeAnchor), name: NSNotification.Name(rawValue: "RemoveARAnchor"), object: nil)
    }
    
    @objc func removeAnchor() {
        // remove all anchors and nodes existing
        if let currentFrame = sceneView.session.currentFrame {
            let existingAnchors = currentFrame.anchors
            for anchor in existingAnchors {
                if anchor is ARImageAnchor {
                    // remove all nodes
                    for node in sceneView.scene.rootNode.childNodes {
                        node.removeFromParentNode()
                    }
                }
            }
        }
        let configuration = ARImageTrackingConfiguration()
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "before", bundle: nil) else {
            fatalError("Couldn't load tracking images")
        }
        configuration.trackingImages = trackingImages
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "before", bundle: nil) else {
            fatalError("Couldn't load tracking images")
        }
        
        configuration.trackingImages = trackingImages
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func removeAllImageAnchors() {
        guard let configuration = sceneView.session.configuration as? ARWorldTrackingConfiguration else { return }
        configuration.detectionImages = []
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        guard let place = imageAnchor.referenceImage.name else { return nil }
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ARImagedetected"), object: nil)
        }
        
        startRender = true
        print(place)
        
        let videoName = place + "故障"
        let videoURL = Bundle.main.url(forResource: videoName, withExtension: "mp4")!
        videoPlayer = AVPlayer(url: videoURL)
        let videoScene = SKScene(size: CGSize(width: 480, height: 360))
        let videoNode = SKVideoNode(avPlayer: videoPlayer)
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        videoNode.size = videoScene.size
        videoNode.yScale = -1.0
        videoNode.play()
        videoScene.addChild(videoNode)
        plane.firstMaterial?.diffuse.contents = videoScene
        
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem, queue: .main) { _ in
            stageObject.stage = "completed"
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ARImagedetected"), object: nil)
            
        }
        startRender = true
        let node = SCNNode()
        node.addChildNode(planeNode)
        
        savedAnchors.append(anchor)

        return node
    }

}

// Essentail for almost every single ARKit project
extension SCNNode {
    var width: Float {
        return (boundingBox.max.x - boundingBox.min.x) * scale.x
    }
    var height: Float {
        return (boundingBox.max.y - boundingBox.min.y) * scale.y
    }
    
    func pivotOnTopLeft() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation(min.x, (max.y - min.y) + min.y, 0)
    }
    
    func pivotOnTopCenter() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2 + min.x, (max.y - min.y) + min.y, 0)
    }
}
