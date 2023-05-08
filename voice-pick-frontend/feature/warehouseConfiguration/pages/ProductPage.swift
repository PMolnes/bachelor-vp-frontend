//
//  ProductPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 12/04/2023.
//

import SwiftUI

import SwiftUI

struct ProductPage: View {
    
    @EnvironmentObject var authenticationService: AuthenticationService
    @ObservedObject var requestService = RequestService()
    @State private var products: [Product] = []
    
    @State var searchField: String = ""
    
    @State var selectedProduct: Product? = nil
    @State private var showingAlert = false
    @State private var showAlertDelete = false
    @State var errorMessage = ""
    @State private var indexSetToDelete: IndexSet?
    
    @Environment(\.dismiss) private var dismiss
    
    
    func fetchProducts() {
        requestService.get(path: "/products", token: authenticationService.accessToken, responseType: [Product].self) { result in
            switch result {
            case .success(let fetchedProducts):
                self.products = fetchedProducts
            case .failure(let error as RequestError):
                print(error)
                handleError(errorCode: error.errorCode)
            default:
                break
            }
        }
    }
    
    func deleteProduct(productId: Int) {
        requestService.delete(path: "/products/\(productId)", token: authenticationService.accessToken, responseType: String.self, completion: { result in
            switch result {
            case .success(_):
                selectedProduct = nil
                fetchProducts()
                break
            case .failure(let error as RequestError):
                handleError(errorCode: error.errorCode)
                break
            default:
                break
            }
        })
    }
    
    /**
     Error handling
     */
    func handleError(errorCode: Int) {
        switch errorCode {
        case 401:
            showingAlert = true
            errorMessage = "Bruker er uautorisert. Logg inn på nytt og pass på at du har riktig rettigheter."
        case 405:
            showingAlert = true
            errorMessage = "Produktet finnes ikke!"
            break
        case 500:
            showingAlert = true
            errorMessage = "Noe gikk galt med verifiseringen av en bruker."
            break
        default:
            showingAlert = true;
            errorMessage = "Noe gikk galt, vennligst lukk applikasjonen og prøv på nytt, eller rapporter hendelsen."
            break
        }
    }
    
    var filteredProducts: [Product] {
        if searchField.isEmpty {
            return products
        } else {
            return products.filter { product in
                product.name.localizedCaseInsensitiveContains(searchField)
            }
        }
    }
    
    func hideSheet() {
        selectedProduct = nil
        fetchProducts()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                DefaultInput(inputLabel: "Søk...", text: $searchField, valid: true)
                    .padding(5)
                List {
                    ForEach(filteredProducts, id: \.self) { product in
                        HStack {
                            Text(product.name)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }.contentShape(Rectangle())
                            .onTapGesture {
                                selectedProduct = product
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    showAlertDelete = true
                                    indexSetToDelete = IndexSet(arrayLiteral: products.firstIndex(of: product)!)
                                    selectedProduct = product
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }.tint(.red)
                            }
                    }
                    .listRowBackground(Color.backgroundColor)
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .refreshable {
                    fetchProducts()
                }
                .onAppear {
                    fetchProducts()
                }
            }
            .background(Color.backgroundColor)
            .foregroundColor(Color.foregroundColor)
            .alert("Fjern produkt", isPresented: $showAlertDelete, actions: {
                Button(role: .cancel) {} label: {
                    Text("Avbryt")
                }
                Button(role: .destructive){
                    deleteProduct(productId: selectedProduct?.id ?? 0)
                } label: {
                    Text("Slett")
                }
            }, message: {
                Text("Er du sikker på at du vil fjerne dette produkten fra varehuset ditt?")
            })
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Produkter")
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {dismiss()}) {
                    Label("Return", systemImage: "chevron.backward")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddProductPage()) {
                    Image(systemName: "plus")
                }
            }
        }
        .foregroundColor(Color.black)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.traceLightYellow, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .sheet(item: $selectedProduct, onDismiss: hideSheet) { product in
            UpdateProductPage(product: product)
        }
    }
}

struct ProductPage_Previews: PreviewProvider {
    static var previews: some View {
        ProductPage()
            .environmentObject(AuthenticationService())
    }
}
