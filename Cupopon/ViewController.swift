//
//  ViewController.swift
//  Cupopon
//
//  Created by Jersson on 10/8/15.
//  Copyright © 2015 iweb2015. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ingresarButtonTapped(sender: AnyObject) {
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        if(userEmail!.isEmpty || userPassword!.isEmpty){
            var myAlert = UIAlertController(title: "Alerta", message: "Todos los campos para completar son requeridos ", preferredStyle: UIAlertControllerStyle.Alert);
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
            myAlert.addAction(okAction);
            
            self.presentViewController(myAlert, animated: true, completion: nil);
            return
        }
        
        //Implementando barra de progreso
        let barraDeProgreso = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        barraDeProgreso.detailsLabelText = "Espere por favor"
        
        // objeto que represetna a una url que puede ser de un recuros remoto
        let myUrl = NSURL(string: "http://localhost:8888/appcupopon/scripts/ingresoCliente.php");
        // para cargar una peticion independientemente del protoclo y el esquema
        let request = NSMutableURLRequest(URL: myUrl!);
        
        
        request.HTTPMethod = "POST";
        
        let postString = "emailUser=\(userEmail!)&passwordUser=\(userPassword!)";
        
        //encodificacion del cuerpo de la peticion
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:{(data : NSData? , response : NSURLResponse?, error : NSError?) -> Void in
            // lanzar la ejecucion de un bloque en dicha cola en segudno plano
            dispatch_async(dispatch_get_main_queue()){
                
                barraDeProgreso.hide(true)
                
                if (error != nil)
                {
                    var myAlert = UIAlertController(title: "Alerta", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                    
                    var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
                    
                    myAlert.addAction(okAction);
                    
                    self.presentViewController(myAlert, animated: true, completion: nil);                    return
                }
                do{
                    var json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary

                    if let parseJSON = json {
                        
                        var userId = parseJSON["usuarioId"] as? Int
                        
                        if (userId != nil)
                        {
                            // Provee una interface programatica para intercutar con contenido por defecto del sistema
                            // setea un especifico valor para una clave en un domino standar de la  aplicacion
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["usuarioNombre"], forKey: "usuarioNombre")
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["usuarioApellidos"], forKey: "usuarioApellidos")
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["usuarioEmail"], forKey: "usuarioEmail")
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["usuarioId"], forKey: "usuarioId")
                            
                            
                            NSUserDefaults.standardUserDefaults().synchronize()
                            
                            
                            let principalPage = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerVC") as! ContainerVC
                            // gestiona la transicion com oun navigation controller
                            let principalPageNav = UINavigationController(rootViewController: principalPage)
                            
                            let appDelegate = UIApplication.sharedApplication().delegate
                            appDelegate?.window??.rootViewController = principalPageNav
                            
                            //let controller = self.storyboard!.instantiateViewControllerWithIdentifier("CuponesTabBarController") as! UITabBarController
                            //self.presentViewController(controller, animated: true, completion: nil)
                            
                           
                            
                        }else{
                            let userMessage = parseJSON["message"] as? String
                            
                            var myAlerta = UIAlertController(title: "Alerta", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
                            
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                                (action) in self.dismissViewControllerAnimated(true, completion: nil)
                            }
                            
                            myAlerta.addAction(okAction);
                            
                            self.presentViewController(myAlerta, animated : true, completion:nil)
                            
                        }
                    }
                    
                    
                }catch{
                    print(error)
                    print("Existe un error")
                }
                
                
            }
            
        }).resume()
    }
}

