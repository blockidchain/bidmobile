//
//  WalletInformationAndMarketWidget.swift
//  WalletInformationAndMarketWidget
//
//  Created by Marcos Rodriguez on 10/29/20.
//  Copyright © 2020 BidWallet. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), marketData: emptyMarketData)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry: SimpleEntry
    if (context.isPreview) {
      entry = SimpleEntry(date: Date(), marketData: MarketData(nextBlock: "26", sats: "9 134", price: "$10,000", rate: 10000), allWalletsBalance: WalletData(balance: 1000000, latestTransactionTime: 1568804029000))
    } else {
      entry = SimpleEntry(date: Date(), marketData: emptyMarketData)
    }
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    let userPreferredCurrency = WidgetAPI.getUserPreferredCurrency();
    let allwalletsBalance = WalletData(balance: UserDefaultsGroup.getAllWalletsBalance(), latestTransactionTime: UserDefaultsGroup.getAllWalletsLatestTransactionTime())
    let marketDataEntry = MarketData(nextBlock: "...", sats: "...", price: "...", rate: 0)
    WidgetAPI.fetchMarketData(currency: userPreferredCurrency, completion: { (result, error) in
      let entry: SimpleEntry
      if let result = result {
        entry = SimpleEntry(date: Date(), marketData: result, allWalletsBalance: allwalletsBalance)
        
      } else {
        entry = SimpleEntry(date: Date(), marketData: marketDataEntry, allWalletsBalance: allwalletsBalance)
      }
      entries.append(entry)
      let timeline = Timeline(entries: entries, policy: .atEnd)
      completion(timeline)
    })
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let marketData: MarketData
  var allWalletsBalance: WalletData = WalletData(balance: 0)
}

struct WalletInformationAndMarketWidgetEntryView : View {
  @Environment(\.widgetFamily) var family
  var entry: Provider.Entry
  
  
  var WalletBalance: some View {
    WalletInformationView(allWalletsBalance: entry.allWalletsBalance, marketData: entry.marketData).background(Color.widgetBackground)
  }
  
  var MarketStack: some View {
    MarketView(marketData: entry.marketData)
  }
  
  var SendReceiveButtonsView: some View {
    SendReceiveButtons().padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
  }
  
  var body: some View {
    if family == .systemLarge {
      HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
        VStack(alignment: .leading, spacing: nil, content: {
                HStack(content: {
                  WalletBalance.padding()
                }).background(Color.widgetBackground)
                HStack(content: {
                        MarketStack        }).padding()
                SendReceiveButtonsView        }).background(Color(.lightGray).opacity(0.77))
        
      })
      
    } else {
      HStack(content: {
        WalletBalance.padding()
        HStack(content: {
          MarketStack.padding()
        }).background(Color(.lightGray).opacity(0.77))
      }).background(Color.widgetBackground)
      
    }
  }
}

@main
struct WalletInformationAndMarketWidget: Widget {
  let kind: String = "WalletInformationAndMarketWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      WalletInformationAndMarketWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Wallet and Market")
    .description("View your total wallet balance and network prices.").supportedFamilies([.systemMedium, .systemLarge])
  }
}

struct WalletInformationAndMarketWidget_Previews: PreviewProvider {
  static var previews: some View {
    WalletInformationAndMarketWidgetEntryView(entry: SimpleEntry(date: Date(), marketData: MarketData(nextBlock: "26", sats: "9 134", price: "$10,000", rate: 0), allWalletsBalance: WalletData(balance: 10000, latestTransactionTime: 1568804029000)))
      .previewContext(WidgetPreviewContext(family: .systemMedium))
    WalletInformationAndMarketWidgetEntryView(entry: SimpleEntry(date: Date(), marketData: MarketData(nextBlock: "26", sats: "9 134", price: "$10,000", rate: 0), allWalletsBalance: WalletData(balance: 10000, latestTransactionTime: 1568804029000)))
      .previewContext(WidgetPreviewContext(family: .systemLarge))
  }
}