
$RgAKS = $Env:rg
$Subscription = $Env:subscription
$AKSName = "miraks"
az account set -s $Subscription

az aks create -n $AKSName -g $RgAKS --load-balancer-sku standard --enable-private-cluster  
