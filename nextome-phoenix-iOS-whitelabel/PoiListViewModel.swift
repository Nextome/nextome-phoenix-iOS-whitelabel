//
//  PoiListViewModel.swift
//  nextome-phoenix-iOS-whitelabel
//
//  Created by Anna Labellarte on 29/03/23.
//

import Foundation
import PhoenixSdk

class PoiListViewModel{
    private var poiList: [NextomePoi] = []
    private var filteredPoiList: [NextomePoi] = []
    var delegate: PoiListDelegate? = nil
    
    var uiData: [String]{
        get{
            return filteredPoiList.compactMap({$0.descriptions.first?.name})
        }
    }
    
    func updateFilter(filterValue filter: String?){
        if let searchName = filter, filter != "" {
            filteredPoiList = poiList.filter({item in
                var name = item.descriptions.first?.name ?? ""
                name = name.lowercased()
                return name.contains(searchName.lowercased())
            })
        }else{
            filteredPoiList = poiList
        }
        delegate?.onListUpdated()
    }
    
    func setPoi(poiList: [NextomePoi]){
        self.poiList = poiList
        self.filteredPoiList = poiList
        self.delegate?.onListUpdated()
    }
    
    func getItem(index: Int)->NextomePoi{
        return filteredPoiList[index]
    }
}


protocol PoiListDelegate{
    func onListUpdated()
    
}
