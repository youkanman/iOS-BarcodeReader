//
//  ViewController.swift
//  Sample1
//
//  Created by  on 2017/03/01.
//q
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var captureView: UIView!
    @IBOutlet weak var barcodeType: UILabel!
    @IBOutlet weak var barcodeValue: UILabel!
    
    // セッションの作成
    private lazy var captureSession: AVCaptureSession! = AVCaptureSession()
    // デバイス
    private lazy var captureDevice: AVCaptureDevice! = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    // 画像表示レイヤ
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        return layer!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // バックカメラをmyDeviceに格納
        /*for device in (discoverySession?.devices)!{
            captureDevice = device
        }
        */
        
        // バックカメラから入力（Input）を取得
//        let deviceInput = AVCaptureDeviceInput.init(device: myDevice!, error: nil)
        let deviceInput: AVCaptureInput!
        do{
            deviceInput = try AVCaptureDeviceInput.init(device: captureDevice)
        } catch {
            deviceInput = nil
        }
    
        // セッションに追加
        if captureSession.canAddInput(deviceInput){
            captureSession.addInput(deviceInput)
        }
        
        // 出力を取得
        let metaDataOutput: AVCaptureMetadataOutput! = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput){
            // セッションに追加
            captureSession.addOutput(metaDataOutput)
            // Meta情報取得時のDelegateを設定
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // Meta情報にQRCodeを設定
            metaDataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        }
        
        // 画像表示レイヤを生成
        previewLayer.frame = self.captureView.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Viewに追加
        captureView.layer.addSublayer(previewLayer)
        
        // セッション開始
        captureSession.startRunning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = self.captureView.bounds
    }
    
    // Meta読取時のdelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!){

        /*func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        */
 
        if metadataObjects.count > 0 {
            let qrData: AVMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            
            // print(qrData.type)
            // print(qrData.stringValue)
            
            // URLを表示
            // UIApplication.shared.open(NSURL(string: qrData.stringValue) as! URL)
            barcodeType.text = qrData.type
            barcodeValue.text = qrData.stringValue
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

