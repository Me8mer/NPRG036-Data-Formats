# Online Shop

## 1. Domain Overview
This conceptual model represents an online shop where an **Owner** operates one or more **E-Shops**. Each e-shop **displays** **Items** for sale. **Shoppers** can create **Accounts** within an e-shop and use a **Cart** to collect items they intend to purchase. The model captures data entities, their primitive attributes, and associations with explicit multiplicities.

---

## 2. Classes

### **Owner**
- **Description:**\
  Person or organization that operates one or more e-shops.
- **Attributes:**
  - `Name` – text, `1..1`
  - `CompanyID` – text, `1..1`
- **Relationships:**
  - **owns** (`Owner 1..1 <=> E-Shop 0..*`)
    The owner owns 0 or more e-shops.
---

### **E-Shop**
- **Description:**\
  Online storefront operated by an owner and displaying products.
- **Attributes:**
  - `Name` – text, `1..1`
  - `URL` – URL, `1..1`
  - `Icon` – URL, `1..1`
- **Relationships:**
  - **owns** (`Owner 1..1 <=> E-Shop 0..*`)\
    The e-shop is owned by exactly one owner.
  - **displays** (`E-Shop 0..1 <=> Item 0..*`)\
    The e-shop lists 0 or more items for sale.
  - **facilitates** (`E-Shop 1..1 <=> Account 0..*`)\
    The e-shop allows creation of multiple accounts or having no account.

---

### **Shopper**
- **Description:**\
  Customer who browses e-shops and may register an account.
- **Attributes:**
  - `FirstName` – text, `1..1`
  - `LastName` – text, `1..1`
- **Relationships:**
  - **owns** (`Shopper 0..1 <=> Account 0..*`)\
    A shopper may have zero or more accounts.

---

### **Account**
- **Description:**\
  Login credentials and user profile that identify a shopper within an e-shop.
- **Attributes:**
  - `Login` – text, `1..1`
  - `Password` – text, `1..1`
- **Relationships:**
  - **owns** (`Shopper 0..1 <=> Account 0..*`)\
    The account represents at most a single shopper who uses it for access. <!-- maybe 1..1? -->
  - **facilitates** (`E-Shop 1..1 <=> Account 0..*`)\
    Each account exists within one e-shop.
  - **possesses** (`Account 1..1 <=> Cart 0..*`)\
    Each account is linked to 0 or more carts for potential purchase.

---

### **Cart**
- **Description:**\
  Container of items selected by the shopper for purchase.
- **Attributes:**
  - `ItemCount` – integer, `1..1`
  - `TotalPrice` – decimal, `1..1`
- **Relationships:**
  - **possesses** (`Account 1..1 <=> Cart 0..*`)\
    The cart belongs to a specific account and cannot exist independently of it.
  - **contains** (`Cart 0..* <=> Item 0..*`)\
    The cart can include zero or more items.

---

### **Item**
- **Description:**\
  Product offered for sale in a specific e-shop.
- **Attributes:**
  - `Name` – text, `1..1`
  - `Price` – decimal, `1..1`
  - `Description` – text, `1..1`
  - `Available` – boolean, `1..1`
  - `PromoImages` – URL, `0..*`
- **Relationships:**
  - **displays** (`E-Shop 0..1 <=> Item 0..*`)\
    Each item can be displayed in one e-shop.
  - **contains** (`Cart 0..* <=> Item 0..*`)\
    The item may appear in zero or several carts simultaneously if chosen by multiple shoppers.

---
