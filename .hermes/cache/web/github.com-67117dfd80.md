## Navigation Menu

### Uh oh!

There was an error while loading. Please reload this page.

There was an error while loading. Please reload this page.

## FilesExpand file tree

## Breadcrumbs

# README.md

## Latest commit

## History

## Breadcrumbs

# README.md

## File metadata and controls

# Basalam Python SDK

## Introduction

Welcome to the Basalam Python SDK - a comprehensive client library for interacting with Basalam API services. This SDK
provides a clean, developer-friendly interface for all Basalam services with full async support. Whether you're building
a server-to-server integration or a user-facing application, this SDK provides the tools you need.

**Supported Python Versions:** Python 3.9+, Python 3.10+, Python 3.11+, Python 3.12+

**Key Features:**

[![Python Versions](https://camo.githubusercontent.com/b9ae7c36cf737d6737016871e188bc7c4227d3d089d91eb8951f65582b079676/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f707974686f6e2d332e39253230253743253230332e3130253230253743253230332e3131253230253743253230332e31322d626c7565)](https://camo.githubusercontent.com/b9ae7c36cf737d6737016871e188bc7c4227d3d089d91eb8951f65582b079676/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f707974686f6e2d332e39253230253743253230332e3130253230253743253230332e3131253230253743253230332e31322d626c7565)
[![License](https://camo.githubusercontent.com/f8df3091bbe1149f398a5369b2c39e896766f9f6efba3477c63e9b4aa940ef14/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c6963656e73652d4d49542d677265656e)](https://camo.githubusercontent.com/f8df3091bbe1149f398a5369b2c39e896766f9f6efba3477c63e9b4aa940ef14/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c6963656e73652d4d49542d677265656e)

![Python Versions](https://camo.githubusercontent.com/b9ae7c36cf737d6737016871e188bc7c4227d3d089d91eb8951f65582b079676/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f707974686f6e2d332e39253230253743253230332e3130253230253743253230332e3131253230253743253230332e31322d626c7565)
![License](https://camo.githubusercontent.com/f8df3091bbe1149f398a5369b2c39e896766f9f6efba3477c63e9b4aa940ef14/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c6963656e73652d4d49542d677265656e)

## Table of Contents

## Installation

**📖 [Full Introduction Documentation](/basalam/python-sdk/blob/main/docs/en/intro.md)**

Install the SDK using pip:

## Quick Start

### 1. Import the SDK

### 2. Set up Authentication

### 3. Create the Client

### 4. Your First API Calls

## Authentication

**📖 [Full Authentication Documentation](/basalam/python-sdk/blob/main/docs/en/auth.md)**

The SDK supports three main authentication methods:

### Personal Token (For Existing Tokens)

Use this method when you already have valid access and refresh tokens:

### Authorization Code Flow (For User Authentication)

Use this method when you need to authenticate on behalf of a user:

### Client Credentials (For Server-to-Server)

Use this method for server-to-server applications:

## Services

The SDK provides access to all Basalam services through a unified client interface. All services support both
synchronous and asynchronous operations.

### Core Service

**📖 [Full Core Service Documentation](/basalam/python-sdk/blob/main/docs/en/services/core.md)**

Manage vendors, products, shipping methods, user information, and more with the Core Service. This service provides
comprehensive functionality for handling core business entities and operations: create and manage vendors, handle
product creation and updates (with file upload support), manage shipping methods, update user verification and
information, handle bank account operations, and manage categories and attributes.

**Key Features:**

**Core Methods:**

| Method | Description | Parameters |
| --- | --- | --- |
| `create_vendor()` | Create new vendor | `user_id`, `request: CreateVendorSchema` |
| `update_vendor()` | Update vendor | `vendor_id`, `request: UpdateVendorSchema` |
| `get_vendor()` | Get vendor details | `vendor_id`, `prefer` |
| `get_default_shipping_methods()` ⚠️ *deprecated* | Removed from API (use `client.shipping`) | `None` |
| `get_shipping_methods()` ⚠️ *deprecated* | Removed from API (use `client.shipping`) | `ids`, `vendor_ids`, `include_deleted`, `page`, `per_page` |
| `get_working_shipping_methods()` ⚠️ *deprecated* | Removed from API (use `client.shipping`) | `vendor_id` |
| `update_shipping_methods()` ⚠️ *deprecated* | Removed from API (use `client.shipping`) | `vendor_id`, `request: UpdateShippingMethodSchema` |
| `get_vendor_products()` | Get vendor products | `vendor_id`, `query_params: GetVendorProductsSchema` |
| `update_vendor_status()` | Update vendor status | `vendor_id`, `request: UpdateVendorStatusSchema` |
| `create_vendor_mobile_change_request()` | Create vendor mobile change | `vendor_id`, `request: ChangeVendorMobileRequestSchema` |
| `create_vendor_mobile_change_confirmation()` | Confirm vendor mobile change | `vendor_id`, `request: ChangeVendorMobileConfirmSchema` |
| `create_product()` | Create a new product (supports file upload) | `vendor_id`, `request: ProductRequestSchema`, `photo_files`, `video_file` |
| `update_bulk_products()` | Update multiple products | `vendor_id`, `request: BatchUpdateProductsRequest`, `continue_on_error` |
| `update_product()` | Update a single product (supports file upload) | `product_id`, `request: ProductRequestSchema`, `photo_files`, `video_file` |
| `get_product()` | Get product details | `product_id`, `prefer` |
| `get_products()` | Get products list | `query_params: GetProductsQuerySchema`, `prefer` |
| `create_product_reminder()` | Create a product stock reminder | `product_id` |
| `delete_product_reminder()` | Delete a product stock reminder | `product_id` |
| `get_product_price_history()` | Get a product's price history | `product_id`, `start_time`, `end_time` |
| `create_products_bulk_action_request()` | Create bulk product updates | `vendor_id`, `request: BulkProductsUpdateRequestSchema` |
| `update_product_variation()` | Update product variation | `product_id`, `variation_id`, `request: UpdateProductVariationSchema` |
| `get_products_bulk_action_requests()` | Get bulk update status | `vendor_id`, `page`, `per_page` |
| `get_products_bulk_action_requests_count()` | Get bulk updates count | `vendor_id` |
| `get_products_unsuccessful_bulk_action_requests()` | Get failed updates | `request_id`, `page`, `per_page` |
| `get_product_shelves()` | Get product shelves | `product_id` |
| `create_discount()` | Create discount for products | `vendor_id`, `request: CreateDiscountRequestSchema` |
| `delete_discount()` | Delete discount for products | `vendor_id`, `request: DeleteDiscountRequestSchema` |
| `get_current_user()` | Get current user info | `without_vendor` |
| `create_user_mobile_confirmation_request()` | Create mobile confirmation request | `user_id` |
| `verify_user_mobile_confirmation_request()` | Confirm user mobile | `user_id`, `request: ConfirmCurrentUserMobileConfirmSchema` |
| `create_user_mobile_change_request()` | Create mobile change request | `user_id`, `request: ChangeUserMobileRequestSchema` |
| `verify_user_mobile_change_request()` | Confirm mobile change | `user_id`, `request: ChangeUserMobileConfirmSchema` |
| `get_user_bank_accounts()` | Get user bank accounts | `user_id`, `prefer` |
| `create_user_bank_account()` | Create user bank account | `user_id`, `request: UserCardsSchema`, `prefer` |
| `verify_user_bank_account_otp()` | Verify bank account OTP | `user_id`, `request: UserCardsOtpSchema` |
| `verify_user_bank_account()` | Verify bank accounts | `user_id`, `request: UserVerifyBankInformationSchema` |
| `delete_user_bank_account()` | Delete bank account | `user_id`, `bank_account_id` |
| `update_user_bank_account()` | Update bank account | `bank_account_id`, `request: UpdateUserBankInformationSchema` |
| `update_user_verification()` | Update user verification | `user_id`, `request: UserVerificationSchema` |
| `get_category_attributes()` | Get category attributes | `category_id`, `product_id`, `vendor_id`, `exclude_multi_selects` |
| `get_categories()` | Get all categories | `None` |
| `get_category()` | Get specific category | `category_id` |

`create_vendor()`
`user_id`
`request: CreateVendorSchema`
`update_vendor()`
`vendor_id`
`request: UpdateVendorSchema`
`get_vendor()`
`vendor_id`
`prefer`
`get_default_shipping_methods()`
`client.shipping`
`None`
`get_shipping_methods()`
`client.shipping`
`ids`
`vendor_ids`
`include_deleted`
`page`
`per_page`
`get_working_shipping_methods()`
`client.shipping`
`vendor_id`
`update_shipping_methods()`
`client.shipping`
`vendor_id`
`request: UpdateShippingMethodSchema`
`get_vendor_products()`
`vendor_id`
`query_params: GetVendorProductsSchema`
`update_vendor_status()`
`vendor_id`
`request: UpdateVendorStatusSchema`
`create_vendor_mobile_change_request()`
`vendor_id`
`request: ChangeVendorMobileRequestSchema`
`create_vendor_mobile_change_confirmation()`
`vendor_id`
`request: ChangeVendorMobileConfirmSchema`
`create_product()`
`vendor_id`
`request: ProductRequestSchema`
`photo_files`
`video_file`
`update_bulk_products()`
`vendor_id`
`request: BatchUpdateProductsRequest`
`continue_on_error`
`update_product()`
`product_id`
`request: ProductRequestSchema`
`photo_files`
`video_file`
`get_product()`
`product_id`
`prefer`
`get_products()`
`query_params: GetProductsQuerySchema`
`prefer`
`create_product_reminder()`
`product_id`
`delete_product_reminder()`
`product_id`
`get_product_price_history()`
`product_id`
`start_time`
`end_time`
`create_products_bulk_action_request()`
`vendor_id`
`request: BulkProductsUpdateRequestSchema`
`update_product_variation()`
`product_id`
`variation_id`
`request: UpdateProductVariationSchema`
`get_products_bulk_action_requests()`
`vendor_id`
`page`
`per_page`
`get_products_bulk_action_requests_count()`
`vendor_id`
`get_products_unsuccessful_bulk_action_requests()`
`request_id`
`page`
`per_page`
`get_product_shelves()`
`product_id`
`create_discount()`
`vendor_id`
`request: CreateDiscountRequestSchema`
`delete_discount()`
`vendor_id`
`request: DeleteDiscountRequestSchema`
`get_current_user()`
`without_vendor`
`create_user_mobile_confirmation_request()`
`user_id`
`verify_user_mobile_confirmation_request()`
`user_id`
`request: ConfirmCurrentUserMobileConfirmSchema`
`create_user_mobile_change_request()`
`user_id`
`request: ChangeUserMobileRequestSchema`
`verify_user_mobile_change_request()`
`user_id`
`request: ChangeUserMobileConfirmSchema`
`get_user_bank_accounts()`
`user_id`
`prefer`
`create_user_bank_account()`
`user_id`
`request: UserCardsSchema`
`prefer`
`verify_user_bank_account_otp()`
`user_id`
`request: UserCardsOtpSchema`
`verify_user_bank_account()`
`user_id`
`request: UserVerifyBankInformationSchema`
`delete_user_bank_account()`
`user_id`
`bank_account_id`
`update_user_bank_account()`
`bank_account_id`
`request: UpdateUserBankInformationSchema`
`update_user_verification()`
`user_id`
`request: UserVerificationSchema`
`get_category_attributes()`
`category_id`
`product_id`
`vendor_id`
`exclude_multi_selects`
`get_categories()`
`None`
`get_category()`
`category_id`

**Example:**

### Chat Service

**📖 [Full Chat Service Documentation](/basalam/python-sdk/blob/main/docs/en/services/chat.md)**

Handle messaging and chat functionalities with the Chat Service. This service provides comprehensive tools for managing
conversations, messages, and chat interactions.

**Key Features:**

**Methods:**

| Method | Description | Parameters |
| --- | --- | --- |
| `create_message()` | Create a message | `request`, `user_agent`, `x_client_info`, `admin_token` |
| `create_chat()` | Create a chat | `request`, `x_creation_tags`, `x_user_session`, `x_client_info` |
| `get_messages()` | Get chat messages | `chat_id`, `msg_id`, `limit`, `chat_type`, `order`, `op`, `temp_id` |
| `get_chats()` | Get chats list | `limit`, `order_by`, `updated_from`, `updated_before`, `modified_from`, `modified_before`, `filters` |

`create_message()`
`request`
`user_agent`
`x_client_info`
`admin_token`
`create_chat()`
`request`
`x_creation_tags`
`x_user_session`
`x_client_info`
`get_messages()`
`chat_id`
`msg_id`
`limit`
`chat_type`
`order`
`op`
`temp_id`
`get_chats()`
`limit`
`order_by`
`updated_from`
`updated_before`
`modified_from`
`modified_before`
`filters`

**Example:**

### Order Service

**📖 [Full Order Service Documentation](/basalam/python-sdk/blob/main/docs/en/services/order.md)**

Manage baskets, payments, and invoices with the Order Service. This service provides comprehensive functionality for
handling order-related operations and payment processing.

**Key Features:**

**Methods:**

| Method | Description | Parameters |
| --- | --- | --- |
| `get_baskets()` | Get active baskets | `refresh` |
| `get_product_variation_status()` | Get product variation status | `product_id` |
| `create_invoice_payment()` | Create payment for invoice | `invoice_id`, `request` |
| `get_payable_invoices()` | Get payable invoices | `page`, `per_page` |
| `get_unpaid_invoices()` | Get unpaid invoices | `invoice_id`, `status`, `page`, `per_page`, `sort` |
| `get_payment_callback()` | Get payment callback | `payment_id`, `callback` (`request` deprecated) |
| `create_payment_callback()` | Create payment callback | `payment_id`, `callback` (`request` deprecated) |

`get_baskets()`
`refresh`
`get_product_variation_status()`
`product_id`
`create_invoice_payment()`
`invoice_id`
`request`
`get_payable_invoices()`
`page`
`per_page`
`get_unpaid_invoices()`
`invoice_id`
`status`
`page`
`per_page`
`sort`
`get_payment_callback()`
`payment_id`
`callback`
`request`
`create_payment_callback()`
`payment_id`
`callback`
`request`

**Example:**

### Order Processing Service

**📖 [Full Order Processing Service Documentation](/basalam/python-sdk/blob/main/docs/en/services/order-processing.md)**

Manage customer orders, vendor parcels, and the entire order lifecycle with the Order Processing Service. This service
provides comprehensive functionality to get and manage customer orders, track order items and details, handle vendor
parcels and shipping, generate order statistics, and monitor order status and updates.

**Key Features:**

**Methods:**

| Method | Description | Parameters |
| --- | --- | --- |
| `get_customer_orders()` | Get orders | `filters` (OrderFilter) |
| `get_customer_order()` | Get specific order | `order_id` |
| `get_customer_order_items()` | Get order items | `filters` (ItemFilter) |
| `get_customer_order_item()` | Get specific item | `item_id` |
| `get_vendor_orders_parcels()` | Get orders parcels | `filters` (OrderParcelFilter) |
| `get_order_parcel()` | Get specific parcel | `parcel_id` |
| `get_orders_stats()` | Get order statistics | `resource_count`, `vendor_id`, `product_id`, `customer_id`, `coupon_code`, `cache_control` |

`get_customer_orders()`
`filters`
`get_customer_order()`
`order_id`
`get_customer_order_items()`
`filters`
`get_customer_order_item()`
`item_id`
`get_vendor_orders_parcels()`
`filters`
`get_order_parcel()`
`parcel_id`
`get_orders_stats()`
`resource_count`
`vendor_id`
`product_id`
`customer_id`
`coupon_code`
`cache_control`

**Example:**

### Wallet Service

**📖 [Full Wallet Service Documentation](/basalam/python-sdk/blob/main/docs/en/services/wallet.md)**

Manage user balances and expenses with the Wallet Service. This service provides comprehensive functionality
for handling user financial operations.

**Key Features:**

**Methods:**

| Method | Description | Parameters |
| --- | --- | --- |
| `get_balance()` | Get user's balance | `user_id`, `filters`, `x_operator_id` |
| `get_transactions()` | Get transaction history | `user_id`, `page`, `per_page`, `x_operator_id` |
| `create_expense()` | Create an expense | `user_id`, `request`, `x_operator_id` |
| `get_expense()` | Get expense details | `user_id`, `expense_id`, `x_operator_id` |
| `delete_expense()` | Delete/rollback expense | `user_id`, `expense_id`, `rollback_reason_id`, `x_operator_id` |
| `get_expense_by_ref()` | Get expense by reference | `user_id`, `reason_id`, `reference_id`, `x_operator_id` |
| `delete_expense_by_ref()` | Delete expense by reference | `user_id`, `reason_id`, `reference_id`, `rollback_reason_id`, `x_operator_id` |

`get_balance()`
`user_id`
`filters`
`x_operator_id`
`get_transactions()`
`user_id`
`page`
`per_page`
`x_operator_id`
`create_expense()`
`user_id`
`request`
`x_operator_id`
`get_expense()`
`user_id`
`expense_id`
`x_operator_id`
`delete_expense()`
`user_id`
`expense_id`
`rollback_reason_id`
`x_operator_id`
`get_expense_by_ref()`
`user_id`
`reason_id`
`reference_id`
`x_operator_id`
`delete_expense_by_ref()`
`user_id`
`reason_id`
`reference_id`
`rollback_reason_id`
`x_operator_id`

**Example:**

### Search Service

**📖 [Full Search Service Documentation](/basalam/python-sdk/blob/main/docs/en/services/search.md)**

Search for products and entities with the Search Service. This service provides powerful search capabilities.

**Key Features:**

**Methods:**

| Method | Description | Parameters |
| --- | --- | --- |
| `search_products()` | Search for products | `request` |

`search_products()`
`request`

**Example:**

### Upload Service

**📖 [Full Upload Service Documentation](/basalam/python-sdk/blob/main/docs/en/services/upload.md)**

Upload and manage files with the Upload Service. This service provides secure file upload capabilities.

**Key Features:**

**Methods:**

| Method | Description | Parameters |
| --- | --- | --- |
| `upload_file()` | Upload a file | `file`, `file_type`, `custom_unique_name`, `expire_minutes` |

`upload_file()`
`file`
`file_type`
`custom_unique_name`
`expire_minutes`

**Example:**

### Webhook Service

**📖 [Full Webhook Service Documentation](/basalam/python-sdk/blob/main/docs/en/services/webhook.md)**

Manage webhook subscriptions and events with the Webhook Service. This service allows you to receive real-time
notifications about events happening in your Basalam account.

**Key Features:**

**Methods:**

| Method | Description | Parameters |
| --- | --- | --- |
| `get_webhook_services()` | Get webhook services | None |
| `create_webhook_service()` | Create webhook service | `request` |
| `get_webhooks()` | Get webhooks list | `service_id`, `event_ids` |
| `create_webhook()` | Create new webhook | `request` |
| `update_webhook()` | Update webhook | `webhook_id`, `request` |
| `delete_webhook()` | Delete webhook | `webhook_id` |
| `get_webhook_events()` | Get available events | None |
| `get_webhook_customers()` | Get webhook customers | `page`, `per_page`, `webhook_id` |
| `get_webhook_logs()` | Get webhook logs | `webhook_id` |
| `register_webhook()` | Register client to webhook | `request` |
| `unregister_webhook()` | Unregister client | `request` |
| `get_registered_webhooks()` | Get registered webhooks | `page`, `per_page`, `service_id` |

`get_webhook_services()`
`create_webhook_service()`
`request`
`get_webhooks()`
`service_id`
`event_ids`
`create_webhook()`
`request`
`update_webhook()`
`webhook_id`
`request`
`delete_webhook()`
`webhook_id`
`get_webhook_events()`
`get_webhook_customers()`
`page`
`per_page`
`webhook_id`
`get_webhook_logs()`
`webhook_id`
`register_webhook()`
`request`
`unregister_webhook()`
`request`
`get_registered_webhooks()`
`page`
`per_page`
`service_id`

**Example:**

### Shipping Service

**📖 [Full Shipping Service Documentation](/basalam/python-sdk/blob/main/docs/en/services/shipping.md)**

Manage the vendor logistics/shipping configuration with the Shipping Service: shipping profiles, geographic zones,
carrier rates, vendor-defined "own" rates, carriers, locations and the profile strategy. This replaces the legacy
`shipping-methods` endpoints that used to live on the Core Service.

`shipping-methods`

**Key Features:**

**Methods:**

| Method | Description | Parameters |
| --- | --- | --- |
| `get_profiles()` | List shipping profiles | `page`, `per_page`, `vendor_id` |
| `create_profile()` | Create a profile | `request: CreateProfileRequest` |
| `get_profile()` | Get a profile | `profile_id` |
| `update_profile()` | Update a profile | `profile_id`, `request: UpdateProfileRequest` |
| `delete_profile()` | Delete a profile | `profile_id` |
| `get_profile_zones()` | List a profile's zones | `profile_id`, `page`, `per_page` |
| `create_profile_zone()` | Create a zone in a profile | `profile_id`, `request: CreateProfileZoneRequest` |
| `get_profile_uncovered_locations()` | Locations not covered by any zone | `profile_id` |
| `get_profile_products()` | Products of a profile | `profile_id`, `product_title_like`, `sort`, `cursor`, … |
| `create_profile_products()` | Assign products to a profile | `profile_id`, `request: CreateProfileProductsRequest` |
| `get_profile_products_list()` | Profile products across profiles | `profile_id_eq`, `vendor_id`, `cursor`, … |
| `delete_profile_product()` | Remove a product from its profile | `product_id` |
| `get_profile_product_free_shipping_rules()` | Free-shipping rules of a product | `product_id` |
| `batch_update_free_shipping_rules()` | Batch-update free-shipping rules | `request: BatchUpdateProfileProductsFreeShippingRulesRequest` |
| `get_product_shipping_info()` | Public shipping zones for a product | `product_id` |
| `get_zone()` | Get a zone | `zone_id` |
| `update_zone()` | Update a zone | `zone_id`, `request: UpdateProfileZoneRequest` |
| `delete_zone()` | Delete a zone | `zone_id` |
| `create_zone_carrier_rate()` | Create a carrier rate in a zone | `zone_id`, `request: CreateCarrierRateRequest` |
| `set_zone_carrier_rates()` | Bulk-set a zone's carrier rates | `zone_id`, `request: CreateCarrierRatesRequest` |
| `get_zone_carrier_rates()` | List a zone's carrier rates | `zone_id`, `page`, `per_page` |
| `create_zone_own_rates()` | Create an own rate in a zone | `zone_id`, `request: CreateZoneOwnRatesRequest` |
| `get_zone_own_rates()` | List a zone's own rates | `zone_id`, `page`, `per_page` |
| `get_delivery_estimates()` | List delivery estimates | `vendor_id` |
| `get_own_rate()` | Get an own rate | `own_rate_id` |
| `update_own_rate()` | Update an own rate | `own_rate_id`, `request: UpdateOwnRatesRequest` |
| `delete_own_rate()` | Delete an own rate | `own_rate_id` |
| `get_carriers()` | List carriers | `None` |
| `get_vendor_carriers()` | List vendor carriers | `status`, `vendor_id`, `prefer` |
| `get_carrier_rate()` | Get a carrier rate | `carrier_rate_id` |
| `update_carrier_rate()` | Update a carrier rate | `carrier_rate_id`, `request: UpdateCarrierRateRequest` |
| `delete_carrier_rate()` | Delete a carrier rate | `carrier_rate_id` |
| `get_locations()` | List nested shipping locations | `None` |
| `get_profile_strategy()` | Get the vendor profile strategy | `vendor_id` |
| `set_profile_strategy()` | Set the vendor profile strategy | `request: ProfileStrategyRequest` |

`get_profiles()`
`page`
`per_page`
`vendor_id`
`create_profile()`
`request: CreateProfileRequest`
`get_profile()`
`profile_id`
`update_profile()`
`profile_id`
`request: UpdateProfileRequest`
`delete_profile()`
`profile_id`
`get_profile_zones()`
`profile_id`
`page`
`per_page`
`create_profile_zone()`
`profile_id`
`request: CreateProfileZoneRequest`
`get_profile_uncovered_locations()`
`profile_id`
`get_profile_products()`
`profile_id`
`product_title_like`
`sort`
`cursor`
`create_profile_products()`
`profile_id`
`request: CreateProfileProductsRequest`
`get_profile_products_list()`
`profile_id_eq`
`vendor_id`
`cursor`
`delete_profile_product()`
`product_id`
`get_profile_product_free_shipping_rules()`
`product_id`
`batch_update_free_shipping_rules()`
`request: BatchUpdateProfileProductsFreeShippingRulesRequest`
`get_product_shipping_info()`
`product_id`
`get_zone()`
`zone_id`
`update_zone()`
`zone_id`
`request: UpdateProfileZoneRequest`
`delete_zone()`
`zone_id`
`create_zone_carrier_rate()`
`zone_id`
`request: CreateCarrierRateRequest`
`set_zone_carrier_rates()`
`zone_id`
`request: CreateCarrierRatesRequest`
`get_zone_carrier_rates()`
`zone_id`
`page`
`per_page`
`create_zone_own_rates()`
`zone_id`
`request: CreateZoneOwnRatesRequest`
`get_zone_own_rates()`
`zone_id`
`page`
`per_page`
`get_delivery_estimates()`
`vendor_id`
`get_own_rate()`
`own_rate_id`
`update_own_rate()`
`own_rate_id`
`request: UpdateOwnRatesRequest`
`delete_own_rate()`
`own_rate_id`
`get_carriers()`
`None`
`get_vendor_carriers()`
`status`
`vendor_id`
`prefer`
`get_carrier_rate()`
`carrier_rate_id`
`update_carrier_rate()`
`carrier_rate_id`
`request: UpdateCarrierRateRequest`
`delete_carrier_rate()`
`carrier_rate_id`
`get_locations()`
`None`
`get_profile_strategy()`
`vendor_id`
`set_profile_strategy()`
`request: ProfileStrategyRequest`

**Example:**

### Appstore Service

**📖 [Full Appstore Service Documentation](/basalam/python-sdk/blob/main/docs/en/services/appstore.md)**

Handle in-app payments and subscription plans with the Appstore Payment Service: payment methods, transactions,
pre-transactions (payment intents), plans and plan subscriptions. Most endpoints accept an optional
`gateway_secret` argument that is sent as the `X-Gateway-Secret` header.

`gateway_secret`
`X-Gateway-Secret`

**Key Features:**

**Methods:**

| Method | Description | Parameters |
| --- | --- | --- |
| `get_payment_methods()` | List payment methods | `include_disabled`, `gateway_secret` |
| `list_transactions()` | List transactions | `page`, `per_page`, `status`, `from_date`, `to_date`, `gateway_secret` |
| `list_unverified_transactions()` | List unverified transactions | `page`, `per_page`, `gateway_secret` |
| `inquiry_transaction()` | Inquiry a transaction | `hash_id`, `gateway_secret` |
| `verify_transaction()` | Verify a transaction | `hash_id`, `gateway_secret` |
| `create_pre_transaction()` | Create a pre-transaction | `request: CreatePreTransactionRequest`, `gateway_secret` |
| `list_plans()` | List subscription plans | `None` |
| `list_plan_subscriptions()` | List plan subscriptions | `plan_id`, `status`, `customer_id`, `page`, `per_page` |
| `get_plan_subscription()` | Get a plan subscription | `subscription_id` |

`get_payment_methods()`
`include_disabled`
`gateway_secret`
`list_transactions()`
`page`
`per_page`
`status`
`from_date`
`to_date`
`gateway_secret`
`list_unverified_transactions()`
`page`
`per_page`
`gateway_secret`
`inquiry_transaction()`
`hash_id`
`gateway_secret`
`verify_transaction()`
`hash_id`
`gateway_secret`
`create_pre_transaction()`
`request: CreatePreTransactionRequest`
`gateway_secret`
`list_plans()`
`None`
`list_plan_subscriptions()`
`plan_id`
`status`
`customer_id`
`page`
`per_page`
`get_plan_subscription()`
`subscription_id`

**Example:**

### Story Service

**📖 [Full Story Service Documentation](/basalam/python-sdk/blob/main/docs/en/services/story.md)**

Manage stories and reels with the Story Service: create stories/reels, browse story discovery, list a user's reels,
like reels and read hashtag feeds. Responses are returned as raw dictionaries.

**Key Features:**

**Methods:**

| Method | Description | Parameters |
| --- | --- | --- |
| `get_my_stories()` | Get the current user stories | `count`, `active_only`, `last_id` |
| `create_story()` | Create a story | `request: CreateStoryBody` |
| `get_stories_discovery()` | Discover stories | `device_id`, `city_id`, `category_ids`, `next_idx`, `count`, … |
| `create_reel()` | Create a reel | `request: CreateReelBody` |
| `get_my_reels()` | Get the current user reels | `limit`, `last_idx`, `is_confirmed`, `status_filter` |
| `get_user_reels()` | Get a user's reels | `user_id`, `limit`, `last_idx` |
| `update_reel()` | Update a reel | `reel_id`, `request: UpdateReelBody` |
| `delete_reel()` | Delete a reel | `reel_id` |
| `like_reel()` | Like/unlike a reel | `reel_id`, `request: LikeReelBody` |
| `get_hashtag_feed()` | Get a hashtag feed | `hashtag`, `count`, `last_id` |

`get_my_stories()`
`count`
`active_only`
`last_id`
`create_story()`
`request: CreateStoryBody`
`get_stories_discovery()`
`device_id`
`city_id`
`category_ids`
`next_idx`
`count`
`create_reel()`
`request: CreateReelBody`
`get_my_reels()`
`limit`
`last_idx`
`is_confirmed`
`status_filter`
`get_user_reels()`
`user_id`
`limit`
`last_idx`
`update_reel()`
`reel_id`
`request: UpdateReelBody`
`delete_reel()`
`reel_id`
`like_reel()`
`reel_id`
`request: LikeReelBody`
`get_hashtag_feed()`
`hashtag`
`count`
`last_id`

**Example:**

## Async/Sync Usage

All SDK methods support both synchronous and asynchronous patterns:

### Asynchronous (Recommended)

### Synchronous

## License

This project is licensed under the MIT License - see the [LICENSE](/basalam/python-sdk/blob/main/LICENSE) file for details.

## Footer

### Footer navigation