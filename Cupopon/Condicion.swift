//
//  Condicion.swift
//  Cupopon
//
//  Created by Jersson on 11/25/15.
//  Copyright © 2015 iweb2015. All rights reserved.
//

import UIKit


struct Condicion {
    var descripcion :String? = nil
    
    init(dictionary : [String:AnyObject]){
        descripcion = dictionary["con_descripcion"] as! String
    }
    static func condicionesFromResults(results : [[String : AnyObject]])->[Condicion]
    {
        var condciones = [Condicion]()
        for result in results{
            condciones.append(Condicion(dictionary: result))
        }
        
        return condciones
    }
}

