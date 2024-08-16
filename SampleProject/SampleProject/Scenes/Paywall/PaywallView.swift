//
//  PaywallView.swift
//  AirShareKit
//
//  Created by Furkan Hanci on 1/11/23.
//

import SwiftUI
import Defaults
import UIComponents

struct PaywallView: View {
    
    @State private var isLoading = false
    var closeByPresentation:Bool = true
    var router = PaywallRouter()
    @State private var selection: Int = 1
    @Default(.premium) var isPremium
    @State var weeklyPrice: String = ""
    @State var yearlyPrice: String = ""
    @State var yearlyAsWeekly: String = ""
    var comesFromSwiftUI: Bool = false
    var showPaywallWhenDisappear = false
    
    @State var showExit = false
    
    var normalTitles: [String] = [
        L10n.Screens.Paywall.Advantage._1,
        L10n.Screens.Paywall.Advantage._2,
        L10n.Screens.Paywall.Advantage._3,
        L10n.Screens.Paywall.Advantage._4
    ]
    
    @State private var yearlySelected : Bool = true
    
    var body: some View {
        
        return ZStack (alignment: .top) {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            Image(uiImage: .paywallBg)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.size.width)
                .scaleEffect(1.5)
                .contentShape(Rectangle())
                .clipped()
                .ignoresSafeArea()

            
            
            ZStack (alignment: .bottom)  {
                VStack (spacing: 30) {
                        //Main title
                        VStack {
                            Text(L10n.Screens.Paywall.Title._1)
                                .font(.system(size: 36))
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .lineSpacing(-2)
                                .padding(.top , 30)
                                .multilineTextAlignment(.center)
                            Text(L10n.Screens.Paywall.Title._2)
                                .font(.system(size: 36))
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .lineSpacing(-2)
                                .multilineTextAlignment(.center)

                        }
                        
                        //Suntitles
                        VStack (alignment: .leading, spacing: 22) {
                            HStack(spacing: 15) {
                                ZStack {
                                    
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 23))
                                        .foregroundColor(Color(UIColor.systemBlue))

                                }
                                
                                Text(normalTitles[0])
                                    .fontWeight(.regular)
                                    //.minimumScaleFactor(0.6)
                                    .font(.system(size: 18))
                                    .foregroundColor(.black)
                                
                            }
                            
                            HStack(spacing: 15) {
                                ZStack {
                                    
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 23))
                                        .foregroundColor(Color(UIColor.systemBlue))

                                }
                                
                                Text(normalTitles[1])
                                    .fontWeight(.regular)
                                    //.minimumScaleFactor(0.6)
                                    .font(.system(size: 18))
                                    .foregroundColor(.black)
                                
                            }
                            
                            HStack(spacing: 15) {
                                ZStack {
                                    
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 23))
                                        .foregroundColor(Color(UIColor.systemBlue))

                                }
                                
                                Text(normalTitles[2])
                                    .fontWeight(.regular)
                                   // .minimumScaleFactor(0.6)
                                    .font(.system(size: 18))
                                    .foregroundColor(.black)
                                
                            }
                            
                            HStack(spacing: 15) {
                                ZStack {
                                    
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 23))
                                        .foregroundColor(Color(UIColor.systemBlue))

                                }
                                
                                Text(normalTitles[3])
                                    .fontWeight(.regular)
                                  //  .minimumScaleFactor(0.6)
                                    .font(.system(size: 18))
                                    .foregroundColor(.black)
                                
                            }
                            
                            
                        }
                       
                        //Offers
                        VStack (spacing: 25) {
                            Button(action: {
                                self.yearlySelected = true
                            }) {
                                HStack {
                                        HStack (alignment: .center) {
                                            VStack (alignment: .leading) {
                                                Text(L10n.Screens.Paywall.yearly)
                                                    .font(.system(size: 14))
                                                    .fontWeight(.light)
                                                    .lineSpacing(-2)
                                                    .foregroundColor(.gray)
                                                    .padding(.leading , 20)
                                                HStack{
                                                    Text(L10n.Screens.Paywall
                                                        .Yearly.price(yearlyPrice))
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.black)
                                                        .fontWeight(.medium)
                                                        .lineSpacing(-2)
                                                        .padding(.leading , 20)
                                                }

                                            }
                                            Spacer()
                                            HStack (spacing: 10) {
                                                Spacer().frame(width: 1, height: 40)
                                                    .background(
                                                        Rectangle().foregroundColor(.gray.opacity(0.7))
                                                    )

                                                Text(L10n.Screens.Paywall.Weekly.price(yearlyAsWeekly))
                                                    .font(.system(size:10))
                                                    .fontWeight(.regular)
                                                    .foregroundColor(.black)
                                                    .padding(.trailing,10)
                                                    .frame(width: 100)
                                                    .multilineTextAlignment(.trailing)

                                            }
                                            
                                        }
                                        .frame(width: UIScreen.main.bounds.size.width / 1.15 , height: 60)
                                }
                                .frame(height: 55)

                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(self.yearlySelected ? Color(UIColor.systemBlue): .gray.opacity(0.6)  , lineWidth: 2)
                                )
                            }
                            Button(action: {
                                self.yearlySelected = false
                            }) {
                                HStack {
                                        HStack (alignment: .center) {
                                            VStack (alignment: .leading) {
                                                Text(L10n.Screens.Paywall.weekly)
                                                    .font(.system(size: 14))
                                                    .fontWeight(.light)
                                                    .lineSpacing(-2)
                                                    .foregroundColor(.gray)
                                                    .padding(.leading , 20)
                                                HStack{
                                                    Text(L10n.Screens.Paywall.Weekly.price(weeklyPrice))
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.black)
                                                        .fontWeight(.medium)
                                                        .lineSpacing(-2)
                                                        .padding(.leading , 20)
                                                }

                                            }
                                            Spacer()

                                            HStack (spacing: 10) {
                                                Spacer().frame(width: 1, height: 40)
                                                    .background(
                                                        Rectangle().foregroundColor(.gray.opacity(0.7))
                                                    )
                                                Text(L10n.Screens.Paywall.Weekly.price(weeklyPrice))
                                                    .font(.system(size:10))
                                                    .fontWeight(.regular)
                                                    .foregroundColor(.black)
                                                    .padding(.trailing,10)
                                                    .frame(width: 100)
                                                    .multilineTextAlignment(.trailing)

                                            }
                                            
                                        }
                                        .frame(width: UIScreen.main.bounds.size.width / 1.15 , height: 60)
                                }
                                .frame(height: 55)
                                
                                .background(
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(self.yearlySelected ? .gray.opacity(0.7) : Color(UIColor.systemBlue) , lineWidth: 2.2)
                                    }
                                )
                                
                            }

                        }
                        .padding(.horizontal,20)
                     
                        
                        //Continue
                        VStack {

                            //Continue button
                            VStack {
                                Button(action: {
                                    print("purchasing...")
                                    purchase()
                                }) {
                                    Text(L10n.Screens.continue)
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                    
                                        .frame(width: UIScreen.main.bounds.size.width / 1.15, height: 60)
                                    //.padding(.vertical, 15)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .foregroundColor(.blue)
                                        )
                                }
                                
                                HStack (spacing: 5) {
                                    Text(L10n.Screens.privacy)
                                        .onTapGesture {
                                            openInSafari(urlString: "https://docs.google.com/document/d/1yPIs6XCaIp9BSWKNsytYm6g15iG2Sm-78mPftSEpXWc")
                                        }
                                    Text("|")
                                    Text(L10n.Screens.terms)
                                        .onTapGesture {
                                            openInSafari(urlString: "https://docs.google.com/document/d/1IcZGaXCb3YNdYWd0p0xD2YFY6iFiAnRAruQZlQKvwV0")
                                        }
                                }
                                .padding(.bottom,5)
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)

                            }
                        }
                        
                    }
                    .frame(width: UIScreen.main.bounds.size.width)
                    .background(
                        Rectangle()
                            .cornerRadius(36, corners: [.topLeft, .topRight])
                            .foregroundColor(.white)
                            .ignoresSafeArea()
                    )
                
                //Exit Button
                Button {
                    if comesFromSwiftUI {
                    } else {
                        router.close()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .opacity(0.2)
                        .foregroundColor(.black.opacity(0.7))
                        .frame(width: 24, height: 24)
                )
                .position(x: 30, y: 10)
                .opacity(showExit ? 1 : 0)

            }

            LoadingView(isLoading: $isLoading)
        }
        .onAppear {
            handleShowExit()
            updatePrices()
            
            RevenueHelper.shared.updateUI = {
                updatePrices()
            }
        }
    }
    
    private func updatePrices() {
        weeklyPrice = RevenueHelper.shared.getPackage(for: .weekly)?.prettyPrice ?? ""
        yearlyPrice = RevenueHelper.shared.getPackage(for: .yearly)?.prettyPrice ?? ""
        
        var yearlyPriceDecimal: Double {
            return NSDecimalNumber(decimal: (RevenueHelper.shared.getPackage(for: .yearly)?.skProduct?.price ?? 0) as Decimal).doubleValue
        }
        
        let price = String(format: "%.2f", (yearlyPriceDecimal / 52))
        yearlyAsWeekly = "\(Locale.current.currencySymbol ?? "")\(price)"
    }
    
    private func handleShowExit() {
        DispatchQueue.main.async {
            showExit = true
        }
    }
    
    private func purchase() {
        isLoading = true
        RevenueHelper.shared.purchasePackage(for: yearlySelected ? .yearly : .weekly) { result in
            switch result {
            case .premiumCompleted:
                router.close()
            case .normalFinished:
                break
            case .failure:
                break
            }
            isLoading = false
        }
    }
    
    
    private func openInSafari(urlString: String) {
        let url = URL(string: urlString)!
        router.presentInSafari(with: url)
    }
    
    
}

public extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape( RoundedCorner(radius: radius, corners: corners) )
  }
}

struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}
