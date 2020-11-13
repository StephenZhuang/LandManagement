//
//  ResourceRow.swift
//  LandManagement
//
//  Created by Stephen Zhuang on 2020/11/13.
//

import SwiftUI

struct ResourceRow: View {
    var resource: Resource
    var body: some View {
        HStack {
            Text("\(resource.level.intValue ?? 0)"+resource.resourceType.stringValue!)
            if resource.isIllegal.boolValue! {
                Image(systemName: "star")
            }
            Spacer()
            Text(resource.location.stringValue!)
            Spacer()
            Text(resource.owner?.name.stringValue ?? "")

        }
    }
}

struct ResourceRow_Previews: PreviewProvider {
    static var previews: some View {
        let resource = Resource(objectId: "5fab52e47f22434137f45ee4")
        ResourceRow(resource: resource)
    }
}
