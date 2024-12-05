//
//  ProductRoutes.swift
//  Stripe
//
//  Created by Andrew Edwards on 8/22/17.
//
//

import NIO
import NIOHTTP1

public protocol ProductRoutes: StripeAPIRoute {
    /// Creates a new product object.
    ///
    /// - Parameters:
    ///   - id: An identifier will be randomly generated by Stripe. You can optionally override this ID, but the ID must be unique across all products in your Stripe account.
    ///   - name: The product’s name, meant to be displayable to the customer.
    ///   - active: Whether the product is currently available for purchase. Defaults to `true`.
    ///   - description: The product’s description, meant to be displayable to the customer. Use this field to optionally store a long form explanation of the product being sold for your own rendering purposes.
    ///   - metadata: Set of key-value pairs that you can attach to an object. This can be useful for storing additional information about the object in a structured format. Individual keys can be unset by posting an empty value to them. All keys can be unset by posting an empty value to metadata.
    ///   - defaultPriceData: Data used to generate a new Price object. This Price will be set as the default price for this product.
    ///   - images: A list of up to 8 URLs of images for this product, meant to be displayable to the customer.
    ///   - packageDimensions: The dimensions of this product for shipping purposes. A SKU associated with this product can override this value by having its own `package_dimensions`.
    ///   - shippable: Whether this product is shipped (i.e., physical goods). Defaults to `true`.
    ///   - statementDescriptor: An arbitrary string to be displayed on your customer’s credit card or bank statement. While most banks display this information consistently, some may display it incorrectly or not at all.
    ///   This may be up to 22 characters. The statement description may not include `<`, `>`, `\`, `"`, `’` characters, and will appear on your customer’s statement in capital letters. Non-ASCII characters are automatically stripped. It must contain at least one letter.
    ///   - taxCode: A tax code ID.
    ///   - unitLabel: A label that represents units of this product. When set, this will be included in customers’ receipts, invoices, Checkout, and the customer portal.
    ///   - url: A URL of a publicly-accessible webpage for this product.
    /// - Returns: Returns a product object if the call succeeded.
    func create(id: String?,
                name: String,
                active: Bool?,
                description: String?,
                metadata: [String: String]?,
                defaultPriceData: [String: Any]?,
                images: [String]?,
                packageDimensions: [String: Any]?,
                shippable: Bool?,
                statementDescriptor: String?,
                taxCode: String?,
                unitLabel: String?,
                url: String?,
                expand: [String]?) async throws -> Product
    
    /// Retrieves the details of an existing product. Supply the unique product ID from either a product creation request or the product list, and Stripe will return the corresponding product information.
    ///
    /// - Parameter id: The identifier of the product to be retrieved.
    /// - Returns: Returns a product object if a valid identifier was provided.
    func retrieve(id: String, expand: [String]?) async throws -> Product
    
    /// Updates the specific product by setting the values of the parameters passed. Any parameters not provided will be left unchanged.
    /// - Parameters:
    ///   - product: The id of the product to update.
    ///   - active: Whether the product is available for purchase.
    ///   - defaultPrice: The ID of the Price object that is the default price for this product.
    ///   - description: The product’s description, meant to be displayable to the customer. Use this field to optionally store a long form explanation of the product being sold for your own rendering purposes.
    ///   - metadata: Set of key-value pairs that you can attach to an object. This can be useful for storing additional information about the object in a structured format. Individual keys can be unset by posting an empty value to them. All keys can be unset by posting an empty value to metadata.
    ///   - name: The product’s name, meant to be displayable to the customer.
    ///   - images: A list of up to 8 URLs of images for this product, meant to be displayable to the customer.
    ///   - packageDimensions: The dimensions of this product for shipping purposes. A SKU associated with this product can override this value by having its own `package_dimensions`.
    ///   - shippable: Whether this product is shipped (i.e., physical goods). Defaults to `true`.
    ///   - statementDescriptor: An arbitrary string to be displayed on your customer’s credit card or bank statement. While most banks display this information consistently, some may display it incorrectly or not at all.
    ///   This may be up to 22 characters. The statement description may not include `<`, `>`, `\`, `"`, `’` characters, and will appear on your customer’s statement in capital letters. Non-ASCII characters are automatically stripped. It must contain at least one letter.
    ///   - taxCode: A tax code ID.
    ///   - unitLabel: A label that represents units of this product. When set, this will be included in customers’ receipts, invoices, Checkout, and the customer portal.
    ///   - url: A URL of a publicly-accessible webpage for this product.
    /// - Returns: Returns the product object if the update succeeded.
    func update(product: String,
                active: Bool?,
                defaultPrice: String?,
                description: String?,
                metadata: [String: String]?,
                name: String?,
                images: [String]?,
                packageDimensions: [String: Any]?,
                shippable: Bool?,
                statementDescriptor: String?,
                taxCode: String?,
                unitLabel: String?,
                url: String?,
                expand: [String]?) async throws -> Product
    
    /// Returns a list of your products. The products are returned sorted by creation date, with the most recently created products appearing first.
    ///
    /// - Parameter filter: A dictionary that will be used for the query parameters. [See More](https://stripe.com/docs/api/products/list)
    /// - Returns: A dictionary with a `data` property that contains an array of up to limit products, starting after product `starting_after`. Each entry in the array is a separate product object. If no more products are available, the resulting array will be empty. This request should never return an error.
    func listAll(filter: [String: Any]?) async throws -> ProductsList
    
    /// Delete a product. Deleting a product with `type=good` is only possible if it has no SKUs associated with it.
    ///
    /// - Parameter id: The ID of the product to delete.
    /// - Returns: Returns a deleted object on success. Otherwise, this call returns an error.
    func delete(id: String) async throws -> DeletedObject
    
    /// Search for products you’ve previously created using Stripe’s Search Query Language. Don’t use search in read-after-write flows where strict consistency is necessary. Under normal operating conditions, data is searchable in less than a minute. Occasionally, propagation of new or updated data can be up to an hour behind during outages. Search functionality is not available to merchants in India.
    /// - Parameters:
    ///   - query: The search query string. See search query language and the list of supported query fields for products.
    ///   - limit: A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 10.
    ///   - page: A cursor for pagination across multiple pages of results. Don’t include this parameter on the first call. Use the `next_page` value returned in a previous response to request subsequent results.
    /// - Returns: A dictionary with a `data` property that contains an array of up to `limit` products. If no objects match the query, the resulting array will be empty. See the related guide on expanding properties in lists.
    func search(query: String, limit: Int?, page: String?) async throws -> ProductSearchResult
    
    
    /// Search for products you’ve previously created using Stripe’s Search Query Language. Don’t use search in read-after-write flows where strict consistency is necessary. Under normal operating conditions, data is searchable in less than a minute. Occasionally, propagation of new or updated data can be up to an hour behind during outages. Search functionality is not available to merchants in India.
    /// - Parameters:
    ///   - query: The search query string. See search query language and the list of supported query fields for products.
    ///   - limit: A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 10.
    ///   - page: A cursor for pagination across multiple pages of results. Don’t include this parameter on the first call. Use the `next_page` value returned in a previous response to request subsequent results.
    ///   - expand: Specifies which fields in the response should be expanded.
    /// - Returns: A dictionary with a `data` property that contains an array of up to `limit` products. If no objects match the query, the resulting array will be empty. See the related guide on expanding properties in lists.
    func search(query: String, limit: Int?, page: String?, expand:[String]?) async throws -> ProductSearchResult
}

public struct StripeProductRoutes: ProductRoutes {
    public var headers: HTTPHeaders = [:]
    
    private let apiHandler: StripeAPIHandler
    private let products = APIBase + APIVersion + "products"
    private let search = APIBase + APIVersion + "products/search"
    
    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }
    
    public func create(id: String? = nil,
                       name: String,
                       active: Bool? = nil,
                       description: String? = nil,
                       metadata: [String: String]? = nil,
                       defaultPriceData: [String: Any]? = nil,
                       images: [String]? = nil,
                       packageDimensions: [String: Any]? = nil,
                       shippable: Bool? = nil,
                       statementDescriptor: String? = nil,
                       taxCode: String? = nil,
                       unitLabel: String? = nil,
                       url: String? = nil,
                       expand: [String]? = nil) async throws -> Product {
        var body: [String: Any] = [:]
        
        body["name"] = name

        if let id {
            body["id"] = id
        }

        if let active {
            body["active"] = active
        }
        
        if let description {
            body["description"] = description
        }
        
        if let metadata {
            metadata.forEach { body["metadata[\($0)]"] = $1 }
        }
        
        if let defaultPriceData {
            defaultPriceData.forEach { body["default_price_data[\($0)]"] = $1 }
        }
        
        if let images {
            body["images"] = images
        }

        if let packageDimensions {
            packageDimensions.forEach { body["package_dimensions[\($0)]"] = $1 }
        }
        
        if let shippable {
            body["shippable"] = shippable
        }
        
        if let statementDescriptor {
            body["statement_descriptor"] = statementDescriptor
        }
        
        if let taxCode {
            body["tax_code"] = taxCode
        }

        if let unitLabel {
            body["unit_label"] = unitLabel
        }
        
        if let url {
            body["url"] = url
        }

        if let expand {
            body["expand"] = expand
        }
        
        return try await apiHandler.send(method: .POST, path: products, body: .string(body.queryParameters), headers: headers)
    }
    
    public func retrieve(id: String, expand: [String]? = nil) async throws -> Product {
        var queryParams = ""
        if let expand {
            queryParams = ["expand": expand].queryParameters
        }
        return try await apiHandler.send(method: .GET, path: "\(products)/\(id)", query: queryParams, headers: headers)
    }
    
    public func update(product: String,
                       active: Bool? = nil,
                       defaultPrice: String? = nil,
                       description: String? = nil,
                       metadata: [String: String]? = nil,
                       name: String? = nil,
                       images: [String]? = nil,
                       packageDimensions: [String: Any]? = nil,
                       shippable: Bool? = nil,
                       statementDescriptor: String? = nil,
                       taxCode: String? = nil,
                       unitLabel: String? = nil,
                       url: String? = nil,
                       expand: [String]? = nil) async throws -> Product {
        var body: [String: Any] = [:]
        
        if let active {
            body["active"] = active
        }

        if let defaultPrice {
            body["default_price"] = defaultPrice
        }
        
        if let description {
            body["description"] = description
        }
        
        if let metadata {
            metadata.forEach { body["metadata[\($0)]"] = $1 }
        }
        
        if let name {
            body["name"] = name
        }
        
        if let images {
            body["images"] = images
        }
        
        if let packageDimensions {
            packageDimensions.forEach { body["package_dimensions[\($0)]"] = $1 }
        }
        
        if let shippable {
            body["shippable"] = shippable
        }

        if let statementDescriptor {
            body["statement_descriptor"] = statementDescriptor
        }
        
        if let taxCode {
            body["tax_code"] = taxCode
        }
        
        if let unitLabel {
            body["unit_label"] = unitLabel
        }
        
        if let url {
            body["url"] = url
        }

        if let expand {
            body["expand"] = expand
        }
        
        return try await apiHandler.send(method: .POST, path: "\(products)/\(product)", body: .string(body.queryParameters), headers: headers)
    }
    
    public func listAll(filter: [String: Any]? = nil) async throws -> ProductsList {
        var queryParams = ""
        if let filter {
            queryParams = filter.queryParameters
        }
        
        return try await apiHandler.send(method: .GET, path: products, query: queryParams, headers: headers)
    }
    
    public func delete(id: String) async throws -> DeletedObject {
        try await apiHandler.send(method: .DELETE, path: "\(products)/\(id)", headers: headers)
    }
    
    public func search(query: String,
                       limit: Int? = nil,
                       page: String? = nil) async throws -> ProductSearchResult {
        return try await self.search(query: query, limit:limit, page: page, expand:nil)
    }
    
    public func search(query: String,
                       limit: Int? = nil,
                       page: String? = nil,
                       expand:[String]? = nil) async throws -> ProductSearchResult {
        var queryParams: [String: Any] = ["query": query]
        
        var body: [String: Any] = [:]
        
        if let expand {
            body["expand"] = expand
        }
        
        if let limit {
            queryParams["limit"] = limit
        }
        
        if let page {
            queryParams["page"] = page
        }
        
        return try await apiHandler.send(method: .GET, path: search, query: queryParams.queryParameters, headers: headers)
    }
}
