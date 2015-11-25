//
//  CuponDetalleViewController.swift
//  Cupopon
//
//  Created by Jersson on 11/24/15.
//  Copyright © 2015 iweb2015. All rights reserved.
//

import UIKit

class CuponDetalleViewController: UIViewController {
    
    
    @IBOutlet weak var nombreProductoLabel: UILabel!
    @IBOutlet weak var imageProductoLabel: UIImageView!
    @IBOutlet weak var descuentoCuponLabel: UILabel!
    @IBOutlet weak var precioConCuponLabel: UILabel!
    @IBOutlet weak var precioProductoLabel: UILabel!
    @IBOutlet weak var infoCuponSegmentedControl: UISegmentedControl!
    @IBOutlet weak var infoProductoView: UIView!
    @IBOutlet weak var infoCondicionesView: UIView!
    @IBOutlet weak var infoEmpresaView: UIView!
    
    @IBOutlet weak var cuponesDisponiblesLabel: UILabel!
    
    
    var appDelegate : AppDelegate!
    var session : NSURLSession!
    var cupon : Cupon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //obtener el delegato de a app
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        // obtener el shared URL session
        session = NSURLSession.sharedSession()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let cupon = cupon {
            // configuara algunas controels por defecto 
            nombreProductoLabel.text = cupon.producto
            print(cupon.producto)
            descuentoCuponLabel.text =  "\(cupon.descuento) %"
            precioConCuponLabel.text = "\(cupon.precioconcupon)"
            precioProductoLabel.text = "\(cupon.precior)"
            cuponesDisponiblesLabel.text = "\(cupon.cantidadCupon)"
            
           
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
