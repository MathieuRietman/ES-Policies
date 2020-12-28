Cosmos uses a well azure know object id.
 Azure Cosmos DB principal and select it (to make it easier to find, you can also search by principal ID: a232010e-820c-4083-83bb-3ace5fc29d0b for any Azure region except Azure Government regions where the principal ID is 57506a73-e302-42a9-b869-6f12d9ec29e9)

https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-setup-cmk


Need to validate if object id is always the same  

$(Get-AzureADServicePrincipal -Filter "AppId eq 'a232010e-820c-4083-83bb-3ace5fc29d0b'").ObjectId