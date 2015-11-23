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
    var precioconcupon = 0.0
    var posterCupon : String? = nil
    var cantidadCupon = 0
    
    init(dictionary : [String:AnyObject]){
        id = dictionary["cup_id"] as! Int
        producto = dictionary["prod_descripcion"] as! String
        precior = dictionary["pro_precio"] as! Double
        descuento = dictionary["cup_descuento"] as! Double
        precioconcupon = dictionary["precio_concupon"] as! Double
        posterCupon = dictionary["pro_ubi_imagen"] as! String
        cantidadCupon = dictionary["cup_cantidad"] as! Int
        
        
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

