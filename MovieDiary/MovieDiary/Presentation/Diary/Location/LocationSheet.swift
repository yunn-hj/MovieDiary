//
//  LocationSheet.swift
//  MovieDiary
//
//  Created by openobject2 on 10/21/25.
//

import SwiftUI

struct LocationSheet: View {
    @EnvironmentObject private var viewModel: LocationViewModel
    @State private var query: String = ""
    @Binding private var placeName: String
    @Environment(\.dismiss) private var dismiss
    
    init(placeName: Binding<String>) {
        self._placeName = placeName
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.location {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .success(let location):
                    locationListView(locations: location.documents)
                case .failure(let error):
                    Text("에러 발생: \(error.localizedDescription)")
                }
                Spacer()
             }
            .navigationTitle("장소 추가")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(
                text: $query,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "장소를 검색하세요"
            )
            .onSubmit(of: .search) {
                guard !query.isEmpty else { return }
                viewModel.requestLocation(query: query)
            }
        }
    }
    
    @ViewBuilder
    func locationListView(locations: [Document]) -> some View {
        List(locations, id: \.id) { location in
            locationItemView(location: location)
        }
    }
    
    @ViewBuilder
    func locationItemView(location: Document) -> some View {
        VStack(alignment: .leading) {
            Text(location.placeName)
                .font(.headline)
                .bold()
            
            Text(location.roadAddressName)
                .font(.body)
                .foregroundStyle(.gray)
            
            Text(location.addressName)
                .font(.footnote)
                .foregroundStyle(.gray)
            
            Text(location.phone)
                .font(.body)
                .foregroundStyle(.blue)
            
            Text(location.placeUrl)
                .lineLimit(1)
                .font(.body)
                .foregroundStyle(.blue)
        }
        .onTapGesture {
            placeName = location.placeName
            dismiss()
        }
    }
}
