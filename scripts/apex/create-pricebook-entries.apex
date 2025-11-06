// Create Standard Pricebook Entries for Products
Id standardPricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;

List<Product2> products = [SELECT Id, Name, ProductCode FROM Product2 WHERE ProductCode LIKE 'SUB-%' OR ProductCode LIKE 'SUP-%' OR ProductCode LIKE 'SVC-%' OR ProductCode LIKE 'TRN-%' ORDER BY ProductCode];

Map<String, Decimal> priceMap = new Map<String, Decimal>{
    'SUB-PREM-001' => 99.00,
    'SUB-STD-001' => 49.00,
    'SUP-ENT-001' => 199.00,
    'SVC-PRO-001' => 150.00,
    'TRN-PKG-001' => 299.00
};

List<PricebookEntry> entries = new List<PricebookEntry>();

for (Product2 prod : products) {
    Decimal price = priceMap.get(prod.ProductCode);
    
    PricebookEntry pbe = new PricebookEntry(
        Pricebook2Id = standardPricebookId,
        Product2Id = prod.Id,
        UnitPrice = price,
        IsActive = true
    );
    entries.add(pbe);
}

insert entries;

System.debug('Created ' + entries.size() + ' Pricebook Entries');
for (PricebookEntry pbe : entries) {
    System.debug('PBE Id: ' + pbe.Id);
}
