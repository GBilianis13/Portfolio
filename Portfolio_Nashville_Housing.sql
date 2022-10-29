/* cleaning Data in SQL Queries
*/

select * from Cleaning.dbo.NashvilleHousing

/* change date format*/

select SaleDate, CONVERT(date, SaleDate) as ModifiedDate
from Cleaning.dbo.NashvilleHousing

alter table Cleaning.dbo.NashvilleHousing
add NewDate date

update Cleaning.dbo.NashvilleHousing
set NewDate = CONVERT(date, SaleDate)

/* Change Property Address where null */
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress , isnull(a.PropertyAddress, b.PropertyAddress) as ModifiedAddress
from Cleaning.dbo.NashvilleHousing a
join Cleaning.dbo.NashvilleHousing b 
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from Cleaning.dbo.NashvilleHousing a
join Cleaning.dbo.NashvilleHousing b 
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


/* break address into address, city, state*/

select SUBSTRING (Cleaning.dbo.NashvilleHousing.PropertyAddress, 1, charindex(',', Cleaning.dbo.NashvilleHousing.PropertyAddress)-1) as Address,
SUBSTRING (Cleaning.dbo.NashvilleHousing.PropertyAddress, charindex(',', Cleaning.dbo.NashvilleHousing.PropertyAddress)+1, len(Cleaning.dbo.NashvilleHousing.PropertyAddress)) as city
from Cleaning.dbo.NashvilleHousing

ALTER TABLE Cleaning.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update Cleaning.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Cleaning.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update Cleaning.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


/* Change Y and N to Yes and No in "Sold as Vacant" field*/


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Cleaning.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Cleaning.dbo.NashvilleHousing


Update cleaning.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

/* Remove Duplicates*/

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Cleaning.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

/*delete columns that are not used */
Select *
From Cleaning.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate