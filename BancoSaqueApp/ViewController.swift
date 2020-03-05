//
//  ViewController.swift
//  BancoSaqueApp
//
//  Created by Tiago Correia De Lima on 17/02/20.
//  Copyright © 2020 Tiago Correia De Lima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblN100.alpha = 0
        lblN50.alpha = 0
        lblN20.alpha = 0
        lblN10.alpha = 0
        lblN5.alpha = 0
        nNotas100.alpha = 0
        nNotas50.alpha = 0
        nNotas20.alpha = 0
        nNotas10.alpha = 0
        nNotas5.alpha = 0
        
        txtDeposito.keyboardType = UIKeyboardType.decimalPad
        txtSaque.keyboardType = UIKeyboardType.decimalPad
    }
    
    @IBOutlet weak var txtDeposito: UITextField!
    @IBOutlet weak var lblSaldo: UILabel!
    @IBOutlet weak var txtSaque: UITextField!
    @IBOutlet weak var lblN100: UILabel!
    @IBOutlet weak var nNotas100: UILabel!
    @IBOutlet weak var lblN50: UILabel!
    @IBOutlet weak var nNotas50: UILabel!
    @IBOutlet weak var lblN20: UILabel!
    @IBOutlet weak var nNotas20: UILabel!
    @IBOutlet weak var lblN10: UILabel!
    @IBOutlet weak var nNotas10: UILabel!
    @IBOutlet weak var lblN5: UILabel!
    @IBOutlet weak var nNotas5: UILabel!
    
    var SaldoAtual: Double = 0
    var depositoAtual: Double = 0
    
    func limparNotas(){
        nNotas100.text = "0" 
        nNotas50.text = "0"
        nNotas20.text = "0"
        nNotas10.text = "0"
        nNotas5.text = "0"
    }
    
    @IBAction func txtDepositoChanged(_ sender: UITextField) {
        txtDeposito.text = txtDeposito.text?.currencyFormatting()
    }
    
    @IBAction func txtSaldoChanged(_ sender: UITextField) {
        txtSaque.text = txtSaque.text?.currencyFormatting()
    }
    
    func esconderMostrarNotas(i:Int){
        lblN100.alpha = CGFloat(i)
        lblN50.alpha = CGFloat(i)
        lblN20.alpha = CGFloat(i)
        lblN10.alpha = CGFloat(i)
        lblN5.alpha = CGFloat(i)
        nNotas100.alpha = CGFloat(i)
        nNotas50.alpha = CGFloat(i)
        nNotas20.alpha = CGFloat(i)
        nNotas10.alpha = CGFloat(i)
        nNotas5.alpha = CGFloat(i)
    }
    
    func aviso(_ title: String,_ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func transacaoMinima(_ valorTransacao: Double) -> Bool{
        return valorTransacao >= 10.0
    }
    
    func updateSaldo(){
        lblSaldo.text = formatSaldo(SaldoAtual)
    }
    
    func deposito(_ valorDepositado:Double) {
        SaldoAtual += valorDepositado
    }
    
    func formatSaldo(_ saldo:Double) -> String{
        return String(SaldoAtual*10).currencyFormatting()
    }
    
    func verificarSaldo(_ valor:Double) -> Bool {
        return valor <= SaldoAtual
    }
    
    func debitar(_ valorDebitado: Double){
        SaldoAtual -= valorDebitado
    }
    
    func qtdNotas(_ valorSaque: Double,_ cifra: Int) -> Int{
        return Int(valorSaque/Double(cifra))
    }
    
    func saqueParcial(_ valorSaque: Double,_ cifra: Int,_ nNotas: Int) -> Double{
        return Double(valorSaque - Double(nNotas * cifra))
    }
    
    func saque(_ valor:Double){
        var valorSaque:Double = valor
        if verificarSaldo(valorSaque) {
            var NumeroNotasAtual: Int = 0
            
            NumeroNotasAtual = qtdNotas(valorSaque, 100)
            nNotas100.text = String(NumeroNotasAtual)
            valorSaque = saqueParcial(valorSaque, 100, NumeroNotasAtual)
            
            NumeroNotasAtual = qtdNotas(valorSaque, 50)
            nNotas50.text = String(NumeroNotasAtual)
            valorSaque = saqueParcial(valorSaque, 50, NumeroNotasAtual)
            
            NumeroNotasAtual = qtdNotas(valorSaque, 20)
            nNotas20.text = String(NumeroNotasAtual)
            valorSaque = saqueParcial(valorSaque, 20, NumeroNotasAtual)
            
            NumeroNotasAtual = qtdNotas(valorSaque, 10)
            nNotas10.text = String(NumeroNotasAtual)
            valorSaque = saqueParcial(valorSaque, 10, NumeroNotasAtual)
            
            NumeroNotasAtual = qtdNotas(valorSaque, 5)
            nNotas5.text = String(NumeroNotasAtual)
            valorSaque = saqueParcial(valorSaque, 5, NumeroNotasAtual)
            
            debitar(valor)
            esconderMostrarNotas(i: 1)
        }else{
            aviso("Saldo Insuficiente", "Deposite um valor para que possa efetuar o saque")
        }
    }
    
    @IBAction func saqueDefinido(_ sender: UIButton) {
        let valorSaque = txtSaque.text?.formatCurrencyDouble()
        if verificarSaldo(valorSaque ?? 0.0) || transacaoMinima(valorSaque ?? 0.0){
            debitar(valorSaque ?? 0.0)
            updateSaldo()
            txtSaque.text = "0"
        } else {
            aviso("Defina valor para Saque","Não é possível sacar um valor inferior a R$10,00")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func btnDepositar(_ sender: UIButton) {
        let valDep = txtDeposito.text?.formatCurrencyDouble()
        if transacaoMinima(valDep ?? 0.0){
            deposito(valDep ?? 0.0)
            updateSaldo()
            esconderMostrarNotas(i: 0)
            limparNotas()
            txtDeposito.text = ""
        } else {
            aviso("Deposito insuficiente", "Por favor deposite um valor a partir de R$10,00")
        }
    }
    
    @IBAction func SaqueMaximo(_ sender: UIButton) {
        saque(SaldoAtual)
        updateSaldo()
    }
}

extension String {
    func currencyFormatting() -> String {
        
        var number: NSNumber!
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        
        formatter.currencySymbol = "R$"
        
        formatter.maximumFractionDigits = 2
        
        formatter.minimumFractionDigits = 2
        
        
        
        var amountWithPrefix = self
        
        
        
        // remove from String: "$", ".", ","
        
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        
        
        let double = (amountWithPrefix as NSString).doubleValue
        
        number = NSNumber(value: (double / 100))
        
        return formatter.string(from: number)!
        
    }
    
    func formatCurrencyDouble() -> Double? {
        
        let currencyString = self.replacingOccurrences(of: "R$", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        let currency = currencyString
            .replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        print(currency)
        return Double(currency)
    }
}




