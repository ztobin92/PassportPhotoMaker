//
//  ChangeLanguageViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 25.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import UIKit
import SwiftUI
import Localize_Swift
import SwiftfulUI

final class ChangeLanguageViewController: BaseViewController<ChangeLanguageViewModel> {
    
    @State var  selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = L10n.Screens.Language.title
    }
    
}

extension ChangeLanguageViewController {
    private func setupUI() {
        view.stack(
            ListView(vm: viewModel).asUIView()
        )
    }

    struct ListView: View {
        @ObservedObject var vm: ChangeLanguageViewModel
        var body: some View {
            VStack (spacing: 32) {
            ScrollView(showsIndicators:false) {
                    LazyVStack(content: {
                        ForEach(vm.languages.filter({$0 != "Base"}), id: \.self) { lang in
                            HStack {
                                Text(Localize.displayNameForLanguage(lang).capitalized)
                                    .font(.system(size: 17, weight: lang == vm.selectedLanguage ? .bold : .regular))
                                Spacer()
                                Image(systemName: vm.selectedLanguage == lang ? "circle.circle.fill" : "circle")
                                    .foregroundColor(Color(vm.selectedLanguage == lang ? .blue : .gray.withAlphaComponent(0.5)))
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 55)
                            .withBackgroundAndBorder(
                                backgroundColor: .white,
                                borderColor: lang == vm.selectedLanguage ? .blue : Color( UIColor.quaternarySystemFill),
                                borderWidth: 1,
                                cornerRadius: 40
                            )
                            .contentShape(.rect)
                            .onTapGesture {
                                withAnimation {
                                    vm.selectedLanguage = lang
                                }
                            }
                        }
                    })
                    .padding()
                    .animation(.bouncy, value: vm.selectedLanguage)
                }
            }
        }
    }

}

@available(iOS 13.0, tvOS 13.0, *)
public extension SwiftUI.View {
    func asUIView() -> UIView {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        view?.backgroundColor = .clear
        return view!
    }
}
