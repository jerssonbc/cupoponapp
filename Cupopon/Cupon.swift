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
    var fechaVencimiento = ""
    var empRazonSocial = ""
    var empGiroNegocio = ""
    var empTelefono = ""
    var empWebSite = ""
    
    
    
    
    init(dictionary : [String:AnyObject]){
        id = dictionary["cup_id"] as! Int
        producto = dictionary["prod_descripcion"] as! String
        precior = dictionary["pro_precio"] as! Double
        descuento = dictionary["cup_descuento"] as! Double
        precioconcupon = dictionary["precio_concupon"] as! Double
        posterCupon = dictionary["pro_ubi_imagen"] as! String
        cantidadCupon = dictionary["cup_cantidad"] as! Int
        fechaVencimiento = dictionary["fecha_vencimiento"] as! String
        empRazonSocial = dictionary["emp_razon_social"] as! String
        empGiroNegocio = dictionary["emp_giro_negocio"] as! String
        empTelefono = dictionary["emp_telefono"] as! String
        empWebSite = dictionary["emp_website"] as! String
        
        
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

