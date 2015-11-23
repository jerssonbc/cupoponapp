//
//  Cupon.swift
//  Cupopon
//
//  Created by Jersson on 11/15/15.
//  Copyright © 2015 iweb2015. All rights reserved.
//

import UIKit

struct Cupon {
    var id = 0
    var producto = ""
    var precior = 0.0
    var descuento = 0.0
    //var preciodesc = 0.0
    var posterCupon : String? = nil
    
    init(dictionary : [String:AnyObject]){
        id = dictionary["cup_id"] as! Int
        producto = dictionary["prod_descripcion"] as! String
        precior = dictionary["pro_precio"] as! Double
        descuento = dictionary["cup_descuento"] as! Double
        //preciodesc = dictionary["preciodesc"] as! Double
        posterCupon = dictionary["pro_ubi_imagen"] as! String
        
    }
    static func cuponesFromResults(results : [[String : AnyObject]])->[Cupon]
    {
        var cupones = [Cupon]()
        
        for result in results{
            cupones.append(Cupon(dictionary: result))
        }
        
        return cupones
    }
}

