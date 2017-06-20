//
//  ViewController.swift
//  ShakeDevice
//
//  Created by 太阳在线YHY on 2017/3/29.
//  Copyright © 2017年 太阳在线. All rights reserved.
//

import UIKit
import SnapKit


class ViewController: UIViewController {

	var topView: UIView!  // 摇动分开始的上部分 View
	var bottomView: UIView!  // 下部分 View
	
	var topImageView: UIImageView!  // 上部分 imageView
	var bottomImageView: UIImageView!  // 下部分 imageView
	
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let label = UILabel()
		label.text = "我喜欢你，认真且怂，从一而终"
		label.textColor = UIColor(red: 1, green: 102/255, blue: 102/255, alpha: 1.0)
		label.textAlignment = .center
		view.addSubview(label)
		label.snp.makeConstraints { (make) in
			make.centerX.centerY.equalToSuperview()
		}
		
		// 使用 Snapkit 布局
		topView = UIView()
		topView.backgroundColor = UIColor.white
		view.addSubview(topView)
		topView.snp.makeConstraints { (make) in
			make.top.leading.trailing.equalToSuperview()
			make.height.equalToSuperview().multipliedBy(0.5)
		}
		
        bottomView = UIView()
		bottomView.backgroundColor = UIColor.white
		view.addSubview(bottomView)
		bottomView.snp.makeConstraints { (make) in
			make.bottom.leading.trailing.equalToSuperview()
			make.height.equalToSuperview().multipliedBy(0.5)
		}
		
		topImageView = UIImageView()
		topImageView.image = UIImage(named: "摇一摇1")
		//	topImageView.contentMode = .bottom
		topView.addSubview(topImageView)
		topImageView.snp.makeConstraints { (make) in
			make.bottom.equalToSuperview()
			make.centerX.equalToSuperview()
			make.width.equalTo(66)
			make.height.equalTo(33)
		}
		
		bottomImageView = UIImageView()
		bottomImageView.image = UIImage(named: "摇一摇2")
		//bottomImageView.contentMode = .top
		bottomView.addSubview(bottomImageView)
		bottomImageView.snp.makeConstraints { (make) in
			make.top.equalToSuperview()
			make.centerX.equalToSuperview()
			make.width.equalTo(66)
			make.height.equalTo(33)
		}
		
		// 添加一个监测 shake 的通知，当摇动结束的时候，发出通知，就可以实现我们想实现的功能了。示例中打印了“摇一摇”三个字
		// 注意： 其实本示例中，通知部分可以去掉，因为不使用通知，类似于微信摇一摇功能也已经实现了，写在这里只是提供，一种处理方式
		NotificationCenter.default.addObserver(self, selector: #selector(shake), name: NSNotification.Name(rawValue: "shake"), object: nil)

	}
	
	
	func shake() {
	     print("摇一摇")
	}
	
	// 开始摇动，添加你的需求代码
	override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
		
		// 这里判断了一下 motion 的值，可以点进去看一下 motion 都有哪些值。个人认为其实不判断也没关系
		if motion == .motionShake
		{
			// 使用 SnapKit 实现摇一摇开始的动画，图片分开，其实这里还可以加上声音，本示例未实现
			UIView.animate(withDuration: 1.5) {
				self.topView.snp.remakeConstraints { (make) in
					make.leading.trailing.equalToSuperview()
					make.top.equalToSuperview().offset(-66)
					make.height.equalToSuperview().multipliedBy(0.5)
				}
				
				self.bottomView.snp.remakeConstraints { (make) in
					make.leading.trailing.equalToSuperview()
					make.bottom.equalToSuperview().offset(66)
					make.height.equalToSuperview().multipliedBy(0.5)
				}
				self.view.layoutSubviews()
			}
		
		}
	}
	
	// 取消摇动
	override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
		// 摇一摇的时候会出现，两张图分开之后停住无法合在一起的状况，这里必须处理一下
		endShake()
		print("别啊啊")
		
	}
	
	// 摇动结束
	override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
		
		// 这里睡眠一秒，其实可以不加，只是为了视觉上舒服
		sleep(1)
		
		endShake()
	
		// 发出通知，其实本示例中，通知部分可以去掉，因为不使用通知，类似于微信摇一摇功能也已经实现了
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shake"), object: self)

	}
	
	func endShake() {

		// 使用 SnapKit 实现摇一摇结束的动画，图片合上
		UIView.animate(withDuration: 1.5) {
			self.topView.snp.remakeConstraints { (make) in
				make.top.leading.trailing.equalToSuperview()
				make.height.equalToSuperview().multipliedBy(0.5)
			}
			
			self.bottomView.snp.remakeConstraints { (make) in
				make.bottom.leading.trailing.equalToSuperview()
				make.height.equalToSuperview().multipliedBy(0.5)
			}
			self.view.layoutSubviews()
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		// 移除通知
		NotificationCenter.default.removeObserver(self)
	}


}

