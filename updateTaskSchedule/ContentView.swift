//
//  ContentView.swift
//  updateTaskSchedule
//
//  Created by Bo Zhang on 9/9/22.
//

import SwiftUI

struct ContentView: UIViewControllerRepresentable {
    @EnvironmentObject var appDelegate: AppDelegate
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = ContentViewController(storeManager: appDelegate.storeManager)
        return UINavigationController(rootViewController: vc)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppDelegate())
    }
}
