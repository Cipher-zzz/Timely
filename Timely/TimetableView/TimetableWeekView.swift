//
//  TimetableWeekView.swift
//  Timely
//  Copy from framework by Jeff Zhang on 3/4/18.
//  Created by 张泽正 on 2019/5/18.
//  Copyright © 2019 monash. All rights reserved.
//

import Foundation
import JZCalendarWeekView

class TimetableWeekView: JZLongPressWeekView {
    
    var viewController: TimetableViewController?
    
    override func registerViewClasses() {
        super.registerViewClasses()
        
        self.collectionView.register(UINib(nibName: EventCell.className, bundle: nil), forCellWithReuseIdentifier: EventCell.className)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.className, for: indexPath) as! EventCell
        cell.configureCell(event: getCurrentEvent(with: indexPath) as! AllDayEvent)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == JZSupplementaryViewKinds.allDayHeader {
            let alldayHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath) as! JZAllDayHeader
            let date = flowLayout.dateForColumnHeader(at: indexPath)
            let events = allDayEventsBySection[date]
            let views = getAllDayHeaderViews(allDayEvents: events as? [AllDayEvent] ?? [])
            alldayHeader.updateView(views: views)
            return alldayHeader
        }
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    private func getAllDayHeaderViews(allDayEvents: [AllDayEvent]) -> [UIView] {
        var allDayViews = [UIView]()
        for event in allDayEvents {
            let view = UINib(nibName: EventCell.className, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventCell
            view.configureCell(event: event, isAllDay: true)
            allDayViews.append(view)
        }
        return allDayViews
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // If the event cell been clicked, open the corespond task detail page.
        let selectedEvent = getCurrentEvent(with: indexPath) as! AllDayEvent
//         ToastUtil.toastMessageInTheMiddle(message: selectedEvent.title)
//        let taskDetailVC = TaskDetailViewController()
        let taskDetailVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
        taskDetailVC.task = selectedEvent.task!
        viewController!.navigationController?.pushViewController(taskDetailVC, animated: true)

    }
}

// From JZiOSFramework
// Have not been used, but save for future usage here.
open class ToastUtil {
    
    static private let defaultLabelSidesPadding: CGFloat = 20
    
    static private let defaultMidFont = UIFont.systemFont(ofSize: 13)
    static private let defaultMidBgColor = UIColor(hex: 0xE8E8E8)
    static private let defaultMidTextColor = UIColor.darkGray
    static private let defaultMidHeight: CGFloat = 40
    static private let defaultMidMinWidth: CGFloat = 80
    static private let defaultMidToBottom: CGFloat = 20 + UITabBarController().tabBar.frame.height
    
    static private let defaultExistTime: TimeInterval = 1.5
    static private let defaultShowTime: TimeInterval = 0.5
    
    static private var toastView: UIView!
    static private var toastLabel: UILabel!
    
    public static func toastMessageInTheMiddle(message: String, bgColor: UIColor? = nil, existTime: TimeInterval? = nil) {
        guard let currentWindow = UIApplication.shared.delegate?.window!, toastView == nil else { return }
        
        toastView = UIView()
        toastView.backgroundColor = defaultMidBgColor
        toastView.alpha = 0
        toastView.layer.cornerRadius = defaultMidHeight/2
        toastView.clipsToBounds = true
        addToastLabel(message: message)
        
        currentWindow.addSubview(toastView)
        var bottomYAnchor: NSLayoutYAxisAnchor
        // Support iPhone X
        if #available(iOS 11.0, *) {
            bottomYAnchor = currentWindow.safeAreaLayoutGuide.bottomAnchor
        } else {
            bottomYAnchor = currentWindow.bottomAnchor
        }
        toastView.setAnchorCenterHorizontallyTo(view: currentWindow, heightAnchor: defaultMidHeight, bottomAnchor: (bottomYAnchor, -defaultMidToBottom))
        toastView.widthAnchor.constraint(greaterThanOrEqualToConstant: defaultMidMinWidth).isActive = true
        
        let delay = existTime ?? defaultExistTime
        UIView.animate(withDuration: defaultShowTime, delay: 0, options: .curveEaseInOut, animations: {
            toastView.alpha = 1
            toastLabel.alpha = 1
        }, completion: { _ in
            
            UIView.animate(withDuration: defaultShowTime, delay: delay, options: .curveEaseInOut, animations: {
                toastView.alpha = 0
                toastLabel.alpha = 0
            }, completion: { _ in
                toastView.removeFromSuperview()
                toastView = nil
            })
        })
    }
    
    private static func addToastLabel(message: String) {
        toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.font = defaultMidFont
        toastLabel.textColor = defaultMidTextColor
        toastLabel.textAlignment = .center
        toastLabel.alpha = 0
        toastView.addSubview(toastLabel)
        toastLabel.centerYAnchor.constraint(equalTo: toastView.centerYAnchor, constant: 0).isActive = true
        toastLabel.setAnchorCenterVerticallyTo(view: toastView, heightAnchor: defaultMidHeight, leadingAnchor: (toastView.leadingAnchor, defaultLabelSidesPadding), trailingAnchor: (toastView.trailingAnchor, -defaultLabelSidesPadding))
    }
}

