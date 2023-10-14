Use SQL_Data_Cleaning

-- Cleaning data in SQL Queries

select * from NashvilleHousing


-- Standard Date Format


Select SaleDate, CONVERT(Date,SaleDate) as Date from NashvilleHousing

Update NashvilleHousing SET SaleDate = CONVERT(Date,SaleDate)

-- Another way to convert into Date format

ALTER Table NashvilleHousing Add Sale_Date Date

Update NashvilleHousing SET Sale_Date = CONVERT(Date,SaleDate)

select Sale_Date, Convert(Date, SaleDate) as Sale_Date
from NashvilleHousing


-- Now we will populate the address Data


Select PropertyAddress from NashvilleHousing
where PropertyAddress is Null

select * from NashvilleHousing where PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from NashvilleHousing a JOIN NashvilleHousing b 
on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID where
a.PropertyAddress is null

Update a SET PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a JOIN NashvilleHousing b 
on a.ParcelID = b.ParcelID AND a.UniqueID = b.UniqueID
where a.PropertyAddress is null

--- Breaking out the address into Individual Columns such as Address, City, and State

Select * from NashvilleHousing

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as HomeAddress,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
from NashvilleHousing

Alter Table NashvilleHousing Add PropertySplitAddress Nvarchar(255)

Update NashvilleHousing SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing Add PropertySplitCity Nvarchar(255)

Update NashvilleHousing SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


Select * from NashvilleHousing

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from NashvilleHousing

Alter Table Nashvillehousing Add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER Table NashvilleHousing ADD OwnerSplitCity Nvarchar(255)

Update NashvilleHousing SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

Alter Table Nashvillehousing Add OwnerSplitState Nvarchar(255)

Update NashvilleHousing SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)



-- Change Y and N to Yes and No in 'Sold as Vacant' column


Select Distinct(SoldAsVacant), Count(SoldAsVacant) as SoldAsVacantCount
from NashvilleHousing Group by SoldAsVacant
order by 2

Select SoldAsVacant, 
CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END
from NashvilleHousing

Update NashvilleHousing SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
	 END


-- Remove Duplicates


With RowNumCTE AS(
Select *,
    ROW_NUMBER() OVER(
PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
Order By UniqueID ) row_num
from NashvilleHousing 
)
select * from RowNumCTE
--Delete from RowNumCTE
where row_num > 1
--order by PropertyAddress


-- Deleting Unsed columns

Alter table NashvilleHousing Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter table NashvilleHousing Drop Column SaleDate

Select * from NashvilleHousing



