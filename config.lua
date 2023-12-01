Config = {
    JobRequirement = "scammer",
    ScamItems = {
        { itemName = "Laptop" }, -- Leave as laptop can rename but make sure this is number one
        { itemName = "card" }, -- can change item name but leave as number 2
        { itemName = "forgedcheck" }, -- can change item name but leave as number 3

    },
    BlackMarketLocations = {
        {
            x = 149.5987, 
            y = -1055.6990,
            z = 29.1986,
            name = "Black Market 1",
            items = {
                { itemName = "MSR", price = 5000 },
                { itemName = "Card", price = 100 },
            },
        },
    },
    ElectronicStoreLocations = {
        {
            x = 147.1117,
            y = -1065.8246,
            z = 29.1923,
            name = "Electronic Store 1",
            items = {
                { itemName = "laptop", price = 50 },
            },
        },
    },
    CashCheckingLocations = {
        {
            x = 251.6445, 
            y = 221.6884,
            z = 106.2866,
            name = "Cash Checking 1",
            conversionRate = 0.8,
        },
    },
}
