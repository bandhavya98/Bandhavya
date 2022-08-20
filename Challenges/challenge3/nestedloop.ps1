$var1=Read-Host "Enter the nested object"
$var2=Read-Host "Enter the key in the foramt a/b/c"


$var3= $var1 -split'}|{|:'
$key= @($var2 -split'/')

$narr=@($var3[1,3,5,6])

for ( $i=0; $i -le ($narr.Length -1); $i +=1 )
{
$trimnarr=$narr[$i].Substring($narr[$i].length -2, 1)
$splitnarr=@($trimnarr -split '')
$finalarr=@($splitnarr[1,4,7,10])
$value=$finalarr | where {$key -notcontains $_}
echo $value
}
