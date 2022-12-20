select * from nh1;

describe nh1;

-- Looking around for missing data 

select TaxDistrict, count(TaxDistrict) from nh1
group by TaxDistrict;

-- some of the values are shown while using is null function so used this query to seperate the empty ones

select * from nh1
Where PropertyAddress = ''; -- 29 rows showed up

-- checking different columns to repopulate the data

select * from nh1
order by ParcelID; -- we can find the ParcelID being repeated and showing the same PropertyAddresses.

select a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress 
from nh1 a
join nh1 b
   on a.ParcelID = b.ParcelID
   and a.UniqueID <> b.UniqueID
where a.PropertyAddress = ""; -- displays 35 rows

update nh1
set PropertyAddress = null
where PropertyAddress = '';

select n.ParcelID, n.PropertyAddress, a.ParcelID, a.PropertyAddress, ifnull(n.PropertyAddress,a.PropertyAddress) 'Property_Address'
FROM nh1 n
join nh1 a 
		 on a.ParcelID = n.ParcelID
         and a.UniqueID <> n.UniqueID
where n.PropertyAddress is null; -- 29 rows are displayed in the scenerio

Update nh1 n , nh1 a
set n.PropertyAddress = ifnull(n.PropertyAddress,a.PropertyAddress)
where n.PropertyAddress is null and n.ParcelID = a.ParcelID; -- updated.

select * from nh1; -- no more null values in PropertyAddress

-- Breaking down addresses 

select nh1.PropertyAddress
from nh1;

select 
substring(PropertyAddress, 1, position(',' in PropertyAddress)-1) as Address,
substring(PropertyAddress, position(',' in PropertyAddress)+1, length(PropertyAddress)) as Address
from nh1; -- spliting addresses

Alter table nh1
Add column Property_Split_Address varchar(40) after PropertyAddress;

Alter table nh1
Add column Property_Split_city varchar(25) after Property_Split_Address;

update nh1
set Property_Split_Address = substring(PropertyAddress, 1, position(',' in PropertyAddress)-1); -- new addition to the table

update nh1
set Property_Split_city = substring(PropertyAddress, position(',' in PropertyAddress)+1, length(PropertyAddress)); -- new addition.

alter table nh1
drop PropertyAddress;

select * from nh1;

select nh1.OwnerAddress
from nh1;

select
substring_index(OwnerAddress, ',', 1) 'Owner_split_adress',
substring_index(substring_index(OwnerAddress, ',', 2), ',', -1) 'Owner_split_city',
substring_index(OwnerAddress, ',', -1) 'Owner_split_State'
from nh1;

Alter table nh1
Add column Owner_Split_Address varchar(40) after OwnerAddress;

Alter table nh1
Add column Owner_Split_city varchar(25) after Owner_Split_Address;

Alter table nh1
Add column Owner_Split_State varchar(40) after Owner_Split_city;

update nh1
set Owner_Split_Address = substring_index(OwnerAddress, ',', 1); -- new addition to the table

update nh1
set Owner_Split_city = substring_index(substring_index(OwnerAddress, ',', 2), ',', -1); -- new addition to the table

update nh1
set Owner_Split_State = substring_index(OwnerAddress, ',', -1); -- new addition.

Alter table nh1
drop column OwnerAddress;

-- cnaging Y,N as Yes and No
select * from nh1;

select distinct(SoldAsVacant), count(SoldAsVacant)
from nh1
group by SoldAsVacant;

select SoldAsVacant,
case When SoldAsVacant = 'Y' then 'Yes'
       When SoldAsVacant = 'N' then 'No'
       Else SoldAsVacant
       END
from nh1;


update nh1
set SoldAsVacant = case When SoldAsVacant = 'Y' then 'Yes'
       When SoldAsVacant = 'N' then 'No'
       Else SoldAsVacant
       END
;

select * from nh1;

-- removing Duplicates
with house_sales as(
select *, 
row_number() over(
partition by ParcelID,
			 Property_Split_Address,
			 SaleDate,
             SalePrice,
             LegalReference
             order by 
                     UniqueID) as row_num
from nh1
)
delete t
from house_sales
join nh1 t using(UniqueID)
where row_num > 1;-- 103 duplicates are found

