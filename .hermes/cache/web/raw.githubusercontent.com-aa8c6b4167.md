# Basalam Python SDK
## Introduction
Welcome to the Basalam Python SDK - a comprehensive client library for interacting with Basalam API services. This SDK
provides a clean, developer-friendly interface for all Basalam services with full async support. Whether you're building
a server-to-server integration or a user-facing application, this SDK provides the tools you need.
\*\*Supported Python Versions:\*\* Python 3.9+, Python 3.10+, Python 3.11+, Python 3.12+
\*\*Key Features:\*\*
- \*\*Full Async/Sync Support\*\*: All operations support both synchronous and asynchronous patterns
- \*\*Type Safety\*\*: Built with Pydantic for robust type checking and validation
- \*\*Multiple Authentication Methods\*\*: Support for client credentials, authorization code flow, and personal tokens
- \*\*Comprehensive Service Coverage\*\*: Access to all Basalam services including wallet, orders, chat, and more
- \*\*Error Handling\*\*: Detailed error classes for different types of failures
- \*\*Developer Friendly\*\*: Clean API design with comprehensive documentation
![Python Versions](https://img.shields.io/badge/python-3.9%20%7C%203.10%20%7C%203.11%20%7C%203.12-blue)
![License](https://img.shields.io/badge/license-MIT-green)
## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Authentication](#authentication)
- [Services](#services)
- [Core Service](#core-service)
- [Chat Service](#chat-service)
- [Order Service](#order-service)
- [Order Processing Service](#order-processing-service)
- [Wallet Service](#wallet-service)
- [Search Service](#search-service)
- [Upload Service](#upload-service)
- [Webhook Service](#webhook-service)
- [Shipping Service](#shipping-service)
- [Appstore Service](#appstore-service)
- [Story Service](#story-service)
- [Async/Sync Usage](#asyncsync-usage)
- [License](#license)
## Installation
\*\*📖 [Full Introduction Documentation](docs/en/intro.md)\*\*
Install the SDK using pip:
```bash
pip install basalam-sdk
```
## Quick Start
### 1. Import the SDK
```python
from basalam\_sdk import BasalamClient, PersonalToken
```
### 2. Set up Authentication
```python
# Personal Token (Token-based authentication)
auth = PersonalToken(
token="your-access-token",
refresh\_token="your-refresh-token"
)
```
### 3. Create the Client
```python
client = BasalamClient(auth=auth)
```
### 4. Your First API Calls
```python
import asyncio
async def main():
# Setup
auth = PersonalToken(
token="your-access-token",
refresh\_token="your-refresh-token"
)
client = BasalamClient(auth=auth)
# Get products
products = await client.get\_products()
print(f"Found {len(products)} products")
# Print first few products
for product in products[:3]:
print(f"Product: {product.name} - Price: {product.price}")
return products
# Run the async function
result = asyncio.run(main())
```
## Authentication
\*\*📖 [Full Authentication Documentation](docs/en/auth.md)\*\*
The SDK supports three main authentication methods:
### Personal Token (For Existing Tokens)
Use this method when you already have valid access and refresh tokens:
```python
from basalam\_sdk import BasalamClient, PersonalToken
auth = PersonalToken(
token="your\_existing\_access\_token",
refresh\_token="your\_existing\_refresh\_token"
)
client = BasalamClient(auth=auth)
```
### Authorization Code Flow (For User Authentication)
Use this method when you need to authenticate on behalf of a user:
```python
from basalam\_sdk import BasalamClient, AuthorizationCode, Scope
# Create auth object
auth = AuthorizationCode(
client\_id="your-client-id",
client\_secret="your-client-secret",
redirect\_uri="https://your-app.com/callback",
scopes=[Scope.CUSTOMER\_WALLET\_READ, Scope.CUSTOMER\_ORDER\_READ]
)
# Get authorization URL
auth\_url = auth.get\_authorization\_url(state="optional\_state\_parameter")
print(f"Visit: {auth\_url}")
# Exchange code for tokens (after user authorization)
token\_info = await auth.get\_token(code="authorization\_code\_from\_callback")
# Create authenticated client
client = BasalamClient(auth=auth)
```
### Client Credentials (For Server-to-Server)
Use this method for server-to-server applications:
```python
from basalam\_sdk import BasalamClient, ClientCredentials, Scope
auth = ClientCredentials(
client\_id="your-client-id",
client\_secret="your-client-secret",
scopes=[Scope.CUSTOMER\_WALLET\_READ, Scope.VENDOR\_PRODUCT\_WRITE]
)
client = BasalamClient(auth=auth)
```
## Services
The SDK provides access to all Basalam services through a unified client interface. All services support both
synchronous and asynchronous operations.
### Core Service
\*\*📖 [Full Core Service Documentation](docs/en/services/core.md)\*\*
Manage vendors, products, shipping methods, user information, and more with the Core Service. This service provides
comprehensive functionality for handling core business entities and operations: create and manage vendors, handle
product creation and updates (with file upload support), manage shipping methods, update user verification and
information, handle bank account operations, and manage categories and attributes.
\*\*Key Features:\*\*
- Create and manage vendors
- Handle product creation and updates with file upload support
- Manage shipping methods
- Update user verification and information
- Handle bank account operations
- Manage categories and attributes
\*\*Core Methods:\*\*
| Method | Description | Parameters |
|----------------------------------------------------|------------------------------------------------|----------------------------------------------------------------------------|
| `create\_vendor()` | Create new vendor | `user\_id`, `request: CreateVendorSchema` |
| `update\_vendor()` | Update vendor | `vendor\_id`, `request: UpdateVendorSchema` |
| `get\_vendor()` | Get vendor details | `vendor\_id`, `prefer` |
| `get\_default\_shipping\_methods()` ⚠️ \_deprecated\_ | Removed from API (use `client.shipping`) | `None` |
| `get\_shipping\_methods()` ⚠️ \_deprecated\_ | Removed from API (use `client.shipping`) | `ids`, `vendor\_ids`, `include\_deleted`, `page`, `per\_page` |
| `get\_working\_shipping\_methods()` ⚠️ \_deprecated\_ | Removed from API (use `client.shipping`) | `vendor\_id` |
| `update\_shipping\_methods()` ⚠️ \_deprecated\_ | Removed from API (use `client.shipping`) | `vendor\_id`, `request: UpdateShippingMethodSchema` |
| `get\_vendor\_products()` | Get vendor products | `vendor\_id`, `query\_params: GetVendorProductsSchema` |
| `update\_vendor\_status()` | Update vendor status | `vendor\_id`, `request: UpdateVendorStatusSchema` |
| `create\_vendor\_mobile\_change\_request()` | Create vendor mobile change | `vendor\_id`, `request: ChangeVendorMobileRequestSchema` |
| `create\_vendor\_mobile\_change\_confirmation()` | Confirm vendor mobile change | `vendor\_id`, `request: ChangeVendorMobileConfirmSchema` |
| `create\_product()` | Create a new product (supports file upload) | `vendor\_id`, `request: ProductRequestSchema`, `photo\_files`, `video\_file` |
| `update\_bulk\_products()` | Update multiple products | `vendor\_id`, `request: BatchUpdateProductsRequest`, `continue\_on\_error` |
| `update\_product()` | Update a single product (supports file upload) | `product\_id`, `request: ProductRequestSchema`, `photo\_files`, `video\_file` |
| `get\_product()` | Get product details | `product\_id`, `prefer` |
| `get\_products()` | Get products list | `query\_params: GetProductsQuerySchema`, `prefer` |
| `create\_product\_reminder()` | Create a product stock reminder | `product\_id` |
| `delete\_product\_reminder()` | Delete a product stock reminder | `product\_id` |
| `get\_product\_price\_history()` | Get a product's price history | `product\_id`, `start\_time`, `end\_time` |
| `create\_products\_bulk\_action\_request()` | Create bulk product updates | `vendor\_id`, `request: BulkProductsUpdateRequestSchema` |
| `update\_product\_variation()` | Update product variation | `product\_id`, `variation\_id`, `request: UpdateProductVariationSchema` |
| `get\_products\_bulk\_action\_requests()` | Get bulk update status | `vendor\_id`, `page`, `per\_page` |
| `get\_products\_bulk\_action\_requests\_count()` | Get bulk updates count | `vendor\_id` |
| `get\_products\_unsuccessful\_bulk\_action\_requests()` | Get failed updates | `request\_id`, `page`, `per\_page` |
| `get\_product\_shelves()` | Get product shelves | `product\_id` |
| `create\_discount()` | Create discount for products | `vendor\_id`, `request: CreateDiscountRequestSchema` |
| `delete\_discount()` | Delete discount for products | `vendor\_id`, `request: DeleteDiscountRequestSchema` |
| `get\_current\_user()` | Get current user info | `without\_vendor` |
| `create\_user\_mobile\_confirmation\_request()` | Create mobile confirmation request | `user\_id` |
| `verify\_user\_mobile\_confirmation\_request()` | Confirm user mobile | `user\_id`, `request: ConfirmCurrentUserMobileConfirmSchema` |
| `create\_user\_mobile\_change\_request()` | Create mobile change request | `user\_id`, `request: ChangeUserMobileRequestSchema` |
| `verify\_user\_mobile\_change\_request()` | Confirm mobile change | `user\_id`, `request: ChangeUserMobileConfirmSchema` |
| `get\_user\_bank\_accounts()` | Get user bank accounts | `user\_id`, `prefer` |
| `create\_user\_bank\_account()` | Create user bank account | `user\_id`, `request: UserCardsSchema`, `prefer` |
| `verify\_user\_bank\_account\_otp()` | Verify bank account OTP | `user\_id`, `request: UserCardsOtpSchema` |
| `verify\_user\_bank\_account()` | Verify bank accounts | `user\_id`, `request: UserVerifyBankInformationSchema` |
| `delete\_user\_bank\_account()` | Delete bank account | `user\_id`, `bank\_account\_id` |
| `update\_user\_bank\_account()` | Update bank account | `bank\_account\_id`, `request: UpdateUserBankInformationSchema` |
| `update\_user\_verification()` | Update user verification | `user\_id`, `request: UserVerificationSchema` |
| `get\_category\_attributes()` | Get category attributes | `category\_id`, `product\_id`, `vendor\_id`, `exclude\_multi\_selects` |
| `get\_categories()` | Get all categories | `None` |
| `get\_category()` | Get specific category | `category\_id` |
\*\*Example:\*\*
```python
from basalam\_sdk.core.models import CreateVendorSchema
# Create a new vendor
vendor = await client.create\_vendor(
user\_id=123,
request=CreateVendorSchema(
title="My Store",
identifier="store123",
category\_type=1,
city=1,
summary="A great store for all your needs"
)
)
# Get vendor details
vendor\_details = await client.get\_vendor(vendor\_id=vendor.id)
```
### Chat Service
\*\*📖 [Full Chat Service Documentation](docs/en/services/chat.md)\*\*
Handle messaging and chat functionalities with the Chat Service. This service provides comprehensive tools for managing
conversations, messages, and chat interactions.
\*\*Key Features:\*\*
- Create and manage chat conversations
- Send and retrieve messages
- Handle different message types
- Manage chat participants
- Track chat history and updates
\*\*Methods:\*\*
| Method | Description | Parameters |
|--------------------|-------------------|------------------------------------------------------------------------------------------------------|
| `create\_message()` | Create a message | `request`, `user\_agent`, `x\_client\_info`, `admin\_token` |
| `create\_chat()` | Create a chat | `request`, `x\_creation\_tags`, `x\_user\_session`, `x\_client\_info` |
| `get\_messages()` | Get chat messages | `chat\_id`, `msg\_id`, `limit`, `chat\_type`, `order`, `op`, `temp\_id` |
| `get\_chats()` | Get chats list | `limit`, `order\_by`, `updated\_from`, `updated\_before`, `modified\_from`, `modified\_before`, `filters` |
\*\*Example:\*\*
```python
from basalam\_sdk.chat.models import MessageRequest
# Create a message
message = await client.create\_message(
request=MessageRequest(
chat\_id=123,
content="Hello, how can I help you?",
message\_type="text"
),
user\_agent="MyApp/1.0",
x\_client\_info="web"
)
# Get messages from a chat
messages = await client.get\_messages(
chat\_id=123,
limit=20,
order="DESC"
)
```
### Order Service
\*\*📖 [Full Order Service Documentation](docs/en/services/order.md)\*\*
Manage baskets, payments, and invoices with the Order Service. This service provides comprehensive functionality for
handling order-related operations and payment processing.
\*\*Key Features:\*\*
- Manage shopping baskets
- Process payments and invoices
- Handle payment callbacks
- Track order status and product variations
- Manage payable and unpaid invoices
\*\*Methods:\*\*
| Method | Description | Parameters |
|----------------------------------|------------------------------|----------------------------------------------------|
| `get\_baskets()` | Get active baskets | `refresh` |
| `get\_product\_variation\_status()` | Get product variation status | `product\_id` |
| `create\_invoice\_payment()` | Create payment for invoice | `invoice\_id`, `request` |
| `get\_payable\_invoices()` | Get payable invoices | `page`, `per\_page` |
| `get\_unpaid\_invoices()` | Get unpaid invoices | `invoice\_id`, `status`, `page`, `per\_page`, `sort` |
| `get\_payment\_callback()` | Get payment callback | `payment\_id`, `callback` (`request` deprecated) |
| `create\_payment\_callback()` | Create payment callback | `payment\_id`, `callback` (`request` deprecated) |
\*\*Example:\*\*
```python
from basalam\_sdk.order.models import CreatePaymentRequestModel
# Get active baskets
baskets = await client.get\_baskets(refresh=True)
# Create payment for invoice
payment = await client.create\_invoice\_payment(
invoice\_id=123,
request=CreatePaymentRequestModel(
payment\_method="credit\_card",
amount=10000
)
)
```
### Order Processing Service
\*\*📖 [Full Order Processing Service Documentation](docs/en/services/order-processing.md)\*\*
Manage customer orders, vendor parcels, and the entire order lifecycle with the Order Processing Service. This service
provides comprehensive functionality to get and manage customer orders, track order items and details, handle vendor
parcels and shipping, generate order statistics, and monitor order status and updates.
\*\*Key Features:\*\*
- Get and manage customer orders
- Track order items and details
- Handle vendor parcels and shipping
- Generate order statistics
- Monitor order status and updates
\*\*Methods:\*\*
| Method | Description | Parameters |
|-------------------------------|----------------------|--------------------------------------------------------------------------------------------|
| `get\_customer\_orders()` | Get orders | `filters` (OrderFilter) |
| `get\_customer\_order()` | Get specific order | `order\_id` |
| `get\_customer\_order\_items()` | Get order items | `filters` (ItemFilter) |
| `get\_customer\_order\_item()` | Get specific item | `item\_id` |
| `get\_vendor\_orders\_parcels()` | Get orders parcels | `filters` (OrderParcelFilter) |
| `get\_order\_parcel()` | Get specific parcel | `parcel\_id` |
| `get\_orders\_stats()` | Get order statistics | `resource\_count`, `vendor\_id`, `product\_id`, `customer\_id`, `coupon\_code`, `cache\_control` |
\*\*Example:\*\*
```python
from basalam\_sdk.order\_processing.models import OrderFilter
# Get orders with filters
orders = await client.get\_customer\_orders(
filters=OrderFilter(
coupon\_code="SAVE10",
cursor="next\_cursor\_123",
customer\_ids="123,456,789",
customer\_name="John Doe"
)
)
# Get specific order details
order = await client.get\_customer\_order(order\_id=123)
```
### Wallet Service
\*\*📖 [Full Wallet Service Documentation](docs/en/services/wallet.md)\*\*
Manage user balances and expenses with the Wallet Service. This service provides comprehensive functionality
for handling user financial operations.
\*\*Key Features:\*\*
- Get user balance and transaction history
- Create and manage expenses
\*\*Methods:\*\*
| Method | Description | Parameters |
|--------------------------------|-------------------------------------|-------------------------------------------------------------------------------|
| `get\_balance()` | Get user's balance | `user\_id`, `filters`, `x\_operator\_id` |
| `get\_transactions()` | Get transaction history | `user\_id`, `page`, `per\_page`, `x\_operator\_id` |
| `create\_expense()` | Create an expense | `user\_id`, `request`, `x\_operator\_id` |
| `get\_expense()` | Get expense details | `user\_id`, `expense\_id`, `x\_operator\_id` |
| `delete\_expense()` | Delete/rollback expense | `user\_id`, `expense\_id`, `rollback\_reason\_id`, `x\_operator\_id` |
| `get\_expense\_by\_ref()` | Get expense by reference | `user\_id`, `reason\_id`, `reference\_id`, `x\_operator\_id` |
| `delete\_expense\_by\_ref()` | Delete expense by reference | `user\_id`, `reason\_id`, `reference\_id`, `rollback\_reason\_id`, `x\_operator\_id` |
\*\*Example:\*\*
```python
from basalam\_sdk.wallet.models import SpendCreditRequest
# Get user balance
balance = await client.get\_balance(user\_id=123)
# Create an expense
expense = await client.create\_expense(
user\_id=123,
request=SpendCreditRequest(
reason\_id=1,
reference\_id=456,
amount=10000,
description="Payment for order #456",
types=[1, 2],
settleable=True
)
)
```
### Search Service
\*\*📖 [Full Search Service Documentation](docs/en/services/search.md)\*\*
Search for products and entities with the Search Service. This service provides powerful search capabilities.
\*\*Key Features:\*\*
- Search for products with advanced filters
- Apply price ranges and category filters
- Sort results by various criteria
- Paginate through search results
- Get detailed product information
\*\*Methods:\*\*
| Method | Description | Parameters |
|---------------------|---------------------|------------|
| `search\_products()` | Search for products | `request` |
\*\*Example:\*\*
```python
from basalam\_sdk.search.models import ProductSearchModel
# Search for products
results = await client.search\_products(
request=ProductSearchModel(
query="laptop",
category\_id=123,
min\_price=100000,
max\_price=500000,
sort\_by="price",
sort\_order="asc",
page=1,
per\_page=20
)
)
```
### Upload Service
\*\*📖 [Full Upload Service Documentation](docs/en/services/upload.md)\*\*
Upload and manage files with the Upload Service. This service provides secure file upload capabilities.
\*\*Key Features:\*\*
- Upload files securely
- Support various file types (images, documents, videos)
- Set custom file names and expiration times
- Get file URLs for access
- Manage file lifecycle
\*\*Methods:\*\*
| Method | Description | Parameters |
|-----------------|---------------|-------------------------------------------------------------|
| `upload\_file()` | Upload a file | `file`, `file\_type`, `custom\_unique\_name`, `expire\_minutes` |
\*\*Example:\*\*
```python
from basalam\_sdk.upload.models import UserUploadFileTypeEnum
# Upload a file
with open("image.jpg", "rb") as file:
result = await client.upload\_file(
file=file,
file\_type=UserUploadFileTypeEnum.PRODUCT\_PHOTO,
custom\_unique\_name="my-product-image",
expire\_minutes=1440 # 24 hours
)
print(f"File uploaded: {result.url}")
```
### Webhook Service
\*\*📖 [Full Webhook Service Documentation](docs/en/services/webhook.md)\*\*
Manage webhook subscriptions and events with the Webhook Service. This service allows you to receive real-time
notifications about events happening in your Basalam account.
\*\*Key Features:\*\*
- Create and manage webhook subscriptions
- Handle different types of events
- Monitor webhook logs and delivery status
- Register and unregister clients to webhooks
\*\*Methods:\*\*
| Method | Description | Parameters |
|-----------------------------|----------------------------|----------------------------------|
| `get\_webhook\_services()` | Get webhook services | None |
| `create\_webhook\_service()` | Create webhook service | `request` |
| `get\_webhooks()` | Get webhooks list | `service\_id`, `event\_ids` |
| `create\_webhook()` | Create new webhook | `request` |
| `update\_webhook()` | Update webhook | `webhook\_id`, `request` |
| `delete\_webhook()` | Delete webhook | `webhook\_id` |
| `get\_webhook\_events()` | Get available events | None |
| `get\_webhook\_customers()` | Get webhook customers | `page`, `per\_page`, `webhook\_id` |
| `get\_webhook\_logs()` | Get webhook logs | `webhook\_id` |
| `register\_webhook()` | Register client to webhook | `request` |
| `unregister\_webhook()` | Unregister client | `request` |
| `get\_registered\_webhooks()` | Get registered webhooks | `page`, `per\_page`, `service\_id` |
\*\*Example:\*\*
```python
from basalam\_sdk.webhook.models import CreateWebhookRequest
# Create a new webhook
webhook = await client.create\_webhook(
request=CreateWebhookRequest(
service\_id=1,
event\_ids=["order.created", "payment.completed"],
request\_method="POST",
url="https://your-app.com/webhook",
is\_active=True
)
)
# Get webhook events
events = await client.get\_webhook\_events()
```
### Shipping Service
\*\*📖 [Full Shipping Service Documentation](docs/en/services/shipping.md)\*\*
Manage the vendor logistics/shipping configuration with the Shipping Service: shipping profiles, geographic zones,
carrier rates, vendor-defined "own" rates, carriers, locations and the profile strategy. This replaces the legacy
`shipping-methods` endpoints that used to live on the Core Service.
\*\*Key Features:\*\*
- Create and manage shipping profiles and assign products to them
- Define zones (locations) and per-zone carrier rates and own rates
- Manage free-shipping rules per product
- Read carriers, vendor carriers, delivery estimates and locations
- Configure the vendor profile strategy
\*\*Methods:\*\*
| Method | Description | Parameters |
|------------------------------------------|------------------------------------------|---------------------------------------------------------|
| `get\_profiles()` | List shipping profiles | `page`, `per\_page`, `vendor\_id` |
| `create\_profile()` | Create a profile | `request: CreateProfileRequest` |
| `get\_profile()` | Get a profile | `profile\_id` |
| `update\_profile()` | Update a profile | `profile\_id`, `request: UpdateProfileRequest` |
| `delete\_profile()` | Delete a profile | `profile\_id` |
| `get\_profile\_zones()` | List a profile's zones | `profile\_id`, `page`, `per\_page` |
| `create\_profile\_zone()` | Create a zone in a profile | `profile\_id`, `request: CreateProfileZoneRequest` |
| `get\_profile\_uncovered\_locations()` | Locations not covered by any zone | `profile\_id` |
| `get\_profile\_products()` | Products of a profile | `profile\_id`, `product\_title\_like`, `sort`, `cursor`, … |
| `create\_profile\_products()` | Assign products to a profile | `profile\_id`, `request: CreateProfileProductsRequest` |
| `get\_profile\_products\_list()` | Profile products across profiles | `profile\_id\_eq`, `vendor\_id`, `cursor`, … |
| `delete\_profile\_product()` | Remove a product from its profile | `product\_id` |
| `get\_profile\_product\_free\_shipping\_rules()` | Free-shipping rules of a product | `product\_id` |
| `batch\_update\_free\_shipping\_rules()` | Batch-update free-shipping rules | `request: BatchUpdateProfileProductsFreeShippingRulesRequest` |
| `get\_product\_shipping\_info()` | Public shipping zones for a product | `product\_id` |
| `get\_zone()` | Get a zone | `zone\_id` |
| `update\_zone()` | Update a zone | `zone\_id`, `request: UpdateProfileZoneRequest` |
| `delete\_zone()` | Delete a zone | `zone\_id` |
| `create\_zone\_carrier\_rate()` | Create a carrier rate in a zone | `zone\_id`, `request: CreateCarrierRateRequest` |
| `set\_zone\_carrier\_rates()` | Bulk-set a zone's carrier rates | `zone\_id`, `request: CreateCarrierRatesRequest` |
| `get\_zone\_carrier\_rates()` | List a zone's carrier rates | `zone\_id`, `page`, `per\_page` |
| `create\_zone\_own\_rates()` | Create an own rate in a zone | `zone\_id`, `request: CreateZoneOwnRatesRequest` |
| `get\_zone\_own\_rates()` | List a zone's own rates | `zone\_id`, `page`, `per\_page` |
| `get\_delivery\_estimates()` | List delivery estimates | `vendor\_id` |
| `get\_own\_rate()` | Get an own rate | `own\_rate\_id` |
| `update\_own\_rate()` | Update an own rate | `own\_rate\_id`, `request: UpdateOwnRatesRequest` |
| `delete\_own\_rate()` | Delete an own rate | `own\_rate\_id` |
| `get\_carriers()` | List carriers | `None` |
| `get\_vendor\_carriers()` | List vendor carriers | `status`, `vendor\_id`, `prefer` |
| `get\_carrier\_rate()` | Get a carrier rate | `carrier\_rate\_id` |
| `update\_carrier\_rate()` | Update a carrier rate | `carrier\_rate\_id`, `request: UpdateCarrierRateRequest` |
| `delete\_carrier\_rate()` | Delete a carrier rate | `carrier\_rate\_id` |
| `get\_locations()` | List nested shipping locations | `None` |
| `get\_profile\_strategy()` | Get the vendor profile strategy | `vendor\_id` |
| `set\_profile\_strategy()` | Set the vendor profile strategy | `request: ProfileStrategyRequest` |
\*\*Example:\*\*
```python
from basalam\_sdk.shipping import CreateProfileRequest
# Create a shipping profile
profile = await client.shipping.create\_profile(
request=CreateProfileRequest(title="Standard shipping", vendor\_id=123)
)
# List profiles
profiles = await client.shipping.get\_profiles(vendor\_id=123)
```
### Appstore Service
\*\*📖 [Full Appstore Service Documentation](docs/en/services/appstore.md)\*\*
Handle in-app payments and subscription plans with the Appstore Payment Service: payment methods, transactions,
pre-transactions (payment intents), plans and plan subscriptions. Most endpoints accept an optional
`gateway\_secret` argument that is sent as the `X-Gateway-Secret` header.
\*\*Key Features:\*\*
- List payment methods and transactions (including unverified)
- Create pre-transactions and verify/inquiry transactions
- List plans and plan subscriptions
\*\*Methods:\*\*
| Method | Description | Parameters |
|---------------------------------|--------------------------------------|----------------------------------------------------------------------|
| `get\_payment\_methods()` | List payment methods | `include\_disabled`, `gateway\_secret` |
| `list\_transactions()` | List transactions | `page`, `per\_page`, `status`, `from\_date`, `to\_date`, `gateway\_secret` |
| `list\_unverified\_transactions()`| List unverified transactions | `page`, `per\_page`, `gateway\_secret` |
| `inquiry\_transaction()` | Inquiry a transaction | `hash\_id`, `gateway\_secret` |
| `verify\_transaction()` | Verify a transaction | `hash\_id`, `gateway\_secret` |
| `create\_pre\_transaction()` | Create a pre-transaction | `request: CreatePreTransactionRequest`, `gateway\_secret` |
| `list\_plans()` | List subscription plans | `None` |
| `list\_plan\_subscriptions()` | List plan subscriptions | `plan\_id`, `status`, `customer\_id`, `page`, `per\_page` |
| `get\_plan\_subscription()` | Get a plan subscription | `subscription\_id` |
\*\*Example:\*\*
```python
from basalam\_sdk.appstore import CreatePreTransactionRequest
pre\_tx = await client.appstore.create\_pre\_transaction(
request=CreatePreTransactionRequest(
reference\_id="order-123",
amount=50000,
callback\_url="https://your-app.com/pay/callback",
)
)
```
### Story Service
\*\*📖 [Full Story Service Documentation](docs/en/services/story.md)\*\*
Manage stories and reels with the Story Service: create stories/reels, browse story discovery, list a user's reels,
like reels and read hashtag feeds. Responses are returned as raw dictionaries.
\*\*Key Features:\*\*
- Create stories and reels
- Story discovery and hashtag feeds
- List my/other users' reels, update, delete and like reels
\*\*Methods:\*\*
| Method | Description | Parameters |
|----------------------------|------------------------------|-----------------------------------------------------------------|
| `get\_my\_stories()` | Get the current user stories | `count`, `active\_only`, `last\_id` |
| `create\_story()` | Create a story | `request: CreateStoryBody` |
| `get\_stories\_discovery()` | Discover stories | `device\_id`, `city\_id`, `category\_ids`, `next\_idx`, `count`, … |
| `create\_reel()` | Create a reel | `request: CreateReelBody` |
| `get\_my\_reels()` | Get the current user reels | `limit`, `last\_idx`, `is\_confirmed`, `status\_filter` |
| `get\_user\_reels()` | Get a user's reels | `user\_id`, `limit`, `last\_idx` |
| `update\_reel()` | Update a reel | `reel\_id`, `request: UpdateReelBody` |
| `delete\_reel()` | Delete a reel | `reel\_id` |
| `like\_reel()` | Like/unlike a reel | `reel\_id`, `request: LikeReelBody` |
| `get\_hashtag\_feed()` | Get a hashtag feed | `hashtag`, `count`, `last\_id` |
\*\*Example:\*\*
```python
from basalam\_sdk.story import CreateReelBody, ReelMetadata
reel = await client.story.create\_reel(
request=CreateReelBody(
video\_id=98765,
product\_ids=[111, 222],
metadata=ReelMetadata(instagram\_reel\_id="abc"),
)
)
```
## Async/Sync Usage
All SDK methods support both synchronous and asynchronous patterns:
### Asynchronous (Recommended)
```python
async def async\_example():
auth = PersonalToken(token="your-token", refresh\_token="your-refresh-token")
client = BasalamClient(auth=auth)
# Async calls
balance = await client.get\_balance(user\_id=123)
webhooks = await client.get\_webhooks()
return balance, webhooks
# Run async function
result = asyncio.run(async\_example())
```
### Synchronous
```python
def sync\_example():
auth = PersonalToken(token="your-token", refresh\_token="your-refresh-token")
client = BasalamClient(auth=auth)
# Sync calls (note the \_sync suffix)
balance = client.get\_balance\_sync(user\_id=123)
webhooks = client.get\_webhooks\_sync()
return balance, webhooks
```
## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.