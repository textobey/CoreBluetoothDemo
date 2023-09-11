//
//  ViewController.swift
//  CoreBluetoothDemo
//
//  Created by 이서준 on 2023/09/11.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    // MARK: Property
    
    private var peripherals: [CBPeripheral] = []
    private lazy var centralManager = CBCentralManager(delegate: self, queue: nil)
    
    // MARK: UI
    
    lazy var baseView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var topStackView: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 8
        return view
    }()
    
    lazy var stateLb1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "블루투스 상태"
        return label
    }()
    
    lazy var stateLb2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ":"
        return label
    }()
    
    lazy var buttonStackView: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 14
        return view
    }()
    
    lazy var startBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("검색 시작", for: .normal)
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    
    lazy var stopBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("검색 중단", for: .normal)
        button.addTarget(self, action: #selector(didTapStopButton), for: .touchUpInside)
        return button
    }()
    
    lazy var searchLb: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "검색된 블루투스 기기"
        return label
    }()
    
    lazy var bottomBaseView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        var view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    lazy var bottomStackView: UIStackView = {
        var view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 8
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setupLayout()
    }
    
    private func addViews() {
        view.addSubview(baseView)
        baseView.addSubview(topStackView)
        baseView.addSubview(bottomBaseView)
        bottomBaseView.addSubview(scrollView)
        scrollView.addSubview(bottomStackView)
        topStackView.addArrangedSubview(stateLb1)
        topStackView.addArrangedSubview(stateLb2)
        topStackView.addArrangedSubview(buttonStackView)
        topStackView.addArrangedSubview(searchLb)
        buttonStackView.addArrangedSubview(startBtn)
        buttonStackView.addArrangedSubview(stopBtn)
    }
    
    private func setupLayout() {
        let baseViewConstraints = [
            baseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            baseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let topStackViewConstraints = [
            topStackView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 30),
            topStackView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -30),
            topStackView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 30),
        ]
        
        let bottomBaseViewConstraints = [
            bottomBaseView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 30),
            bottomBaseView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -30),
            bottomBaseView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 30),
            bottomBaseView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -30),
        ]
        
        let scrollViewConstraints = [
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: bottomBaseView.leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: bottomBaseView.trailingAnchor),
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: bottomBaseView.topAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: bottomBaseView.bottomAnchor)
        ]
        
        let bottomStackViewConstraints = [
            bottomStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            bottomStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            bottomStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(baseViewConstraints)
        NSLayoutConstraint.activate(topStackViewConstraints)
        NSLayoutConstraint.activate(bottomBaseViewConstraints)
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(bottomStackViewConstraints)
    }
    
    @objc func didTapStartButton() {
        print("==== Bluetooth 검색시작 =====")
        guard !centralManager.isScanning else {
            print("==== Bluetooth isScanning: \(centralManager.isScanning)")
            return
        }
        
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    @objc func didTapStopButton() {
        print("==== Bluetooth 검색종료 =====")
        centralManager.stopScan()
    }
    
    func addPeripheral(serial: String) {
        lazy var serialLb: UILabel = {
            let label = UILabel()
            label.text = serial
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        bottomStackView.addArrangedSubview(serialLb)
    }
}

extension ViewController: CBPeripheralDelegate, CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("centralMangerDidUpdateState.unknown")
        case .resetting:
            print("centralMangerDidUpdateState.resetting")
        case .unsupported:
            print("centralMangerDidUpdateState.unsupported")
        case .unauthorized:
            print("centralMangerDidUpdateState.unauthorized")
        case .poweredOn:
            print("centralMangerDidUpdateState.poweredOn")
            stateLb2.text = ": 블루투스 ON"
        case .poweredOff:
            print("centralMangerDidUpdateState.poweredOff")
            stateLb2.text = ": 블루투스 OFF"
        @unknown default:
            fatalError()
        }
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI: NSNumber
    ) {
        let check: Bool = false
        if !check {
            peripherals.append(peripheral)
            addPeripheral(serial: peripheral.name ?? peripheral.identifier.uuidString)
        }
    }
    
    /// 주변 장치가 연결되면 호출되는 메서드
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
    }
    
    /// 주변장치의 GATT 특성 검색에 성공하면 호출되는 메서드
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("==== didDiscoverCharacteristicsFor ====")
    }
    
    /// writeType이 .withResponse일 때, 주변장치로부터의 응답이 왔을 때 호출되는 함수.. GATT 특성이 쓰기가 가능할때인가?
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        // code
    }
    
    /// 주변장치의 신호 강도를 요청하는 peripheral.reeadRSSI()가 호출하는 함수입니다.
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        // 신호 강도와 관련된 코드를 작성
    }
}

