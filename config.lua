Config = {
    JobRequirement = "scammer",
    ScamItems = {
        { itemName = "Laptop" }, -- Leave as laptop can rename but make sure this is number one
        { itemName = "card" }, -- can change item name but leave as number 2
        { itemName = "forgedcheck" }, -- can change item name but leave as number 3

    },
    LaptopFeatures = {
        LibSkillCheck = true, -- [true/false] Ethier way when talking to teller there is a skillcheck but for the scamming 'printing forged checks there is a minigame and this is one of the options...' 
        Glow_minigamesPathMiniGame = false, -- [true/false] same as above https://github.com/christikat/glow_minigames
        cd_keymaster = false, -- [true/false] https://github.com/dsheedes/cd_keymaster

    },
    BlackMarketLocations = {
        {
            x = 149.5987, 
            y = -1055.6990,
            z = 29.1986,
            name = "Black Market 1",
            items = {
                { itemName = "printer", price = 5000 },
                { itemName = "card", price = 100 },
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
        },
    },
}
