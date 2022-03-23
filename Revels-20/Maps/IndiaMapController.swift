////
////  Maps-2.swift
////  uicollectionview
////
////  Created by Tushar Tapadia on 31/07/20.
////  Copyright © 2020 Tushar Tapadia. All rights reserved.
////
//
//import Foundation
//import Mapbox
//
////mapbox://styles/tushartapadia/ckd8yxaa902xc1ikcdkoh028z
//
//class MapViewController: UIViewController{
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//
//    }
//    
//    lazy var titleLabel:UILabel = {
//        let label = UILabel()
//        label.text = "Maps"
//        label.textColor = .white
//        label.font = UIFont.boldSystemFont(ofSize: 19)
//        return label
//    }()
//    
//    lazy var back:UIView = {
//        let backg = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
//        backg.backgroundColor = .black
//        backg.layer.cornerRadius = 10
//        
//        return backg
//    }()
//    
//    lazy var backlogo:UIView = {
//        let backg = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        backg.backgroundColor = .black
//        backg.layer.cornerRadius = 10
//        
//        return backg
//    }()
//    
//    lazy var logo:UIImageView = {
//        let iv = UIImageView(image: UIImage(named: "logobg1"))
//            iv.contentMode = .scaleAspectFill
//            iv.layer.cornerRadius = 10
//            iv.layer.masksToBounds = true
//            iv.clipsToBounds = true
//            return iv
//        }()
//    
//    lazy var legend:UIImageView = {
//        let iv = UIImageView(image: UIImage(named: "legend1"))
//        iv.contentMode = .scaleAspectFit
//            iv.layer.cornerRadius = 10
//            iv.layer.masksToBounds = true
//            iv.clipsToBounds = true
//            return iv
//        }()
//    lazy var legendTitleLabel:UILabel = {
//        let label = UILabel()
//        label.text = "MIT Community"
//        label.textColor = .white
//        label.font = UIFont.boldSystemFont(ofSize: 11)
//        return label
//    }()
//    
//    func setupViews(){
//        let url = URL(string: "mapbox://styles/tushartapadia/ckgxxgog26fn719paxkcpt5z8")
//               let mapView = MGLMapView(frame: view.bounds, styleURL: url)
//               mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        mapView.setCenter(CLLocationCoordinate2D(latitude: 20.59, longitude: 78.96), zoomLevel: 3, animated: false)
//        mapView.minimumZoomLevel = 3.0
//        mapView.maximumZoomLevel = 6.5
//        view.addSubview(mapView)
//        mapView.addSubview(back)
//        back.anchor(top: mapView.topAnchor, left: nil, bottom: nil, right: mapView.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: 70, heightConstant: 25)
//        back.addSubview(titleLabel)
//        titleLabel.anchorWithConstants(top: back.topAnchor, left: back.leftAnchor, bottom: back.bottomAnchor, right: back.rightAnchor, topConstant: 2, leftConstant: 10, bottomConstant: 2, rightConstant: 2)
//        
//        mapView.addSubview(backlogo)
//        backlogo.anchor(top: nil, left: nil, bottom: mapView.bottomAnchor, right: mapView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 7, widthConstant: 25, heightConstant: 25)
//        
//        mapView.addSubview(logo)
//        logo.anchor(top: nil, left: nil, bottom: mapView.bottomAnchor, right: mapView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 7, widthConstant: 25, heightConstant: 25)
//        
//        mapView.addSubview(legend)
//        legend.anchor(top: nil, left: mapView.leftAnchor, bottom: mapView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 40, rightConstant: 0,widthConstant: 160,heightConstant: 100)
//       
//    }
//    
//}
//
