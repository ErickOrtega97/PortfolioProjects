SELECT *
FROM Data_Cleaning.dbo.Nashville_Housing

-- Standardize Date format
Select Saledateconverted, Convert(Date, saledate)
FROM Data_Cleaning..Nashville_Housing

Update Data_Cleaning..Nashville_Housing
SET saledate = Convert(Date, saledate)

ALTER TABLE Data_cleaning..Nashville_housing
Add Saledateconverted Date;

Update Data_Cleaning..Nashville_Housing
SET Saledateconverted = Convert(Date,Saledate)



-- Populate Property address data

Select PropertyAddress
FROM Data_Cleaning..Nashville_Housing
WHere PropertyAddress is null

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.propertyaddress)
FROM Data_Cleaning..Nashville_Housing AS a
JOIN Data_Cleaning..Nashville_Housing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

Update a
SET Propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
FROM Data_Cleaning..Nashville_Housing AS a
JOIN Data_Cleaning..Nashville_Housing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]



-- Breaking out address into individual columns (Address, City, State)
Select propertyaddress
FROM Data_Cleaning..Nashville_Housing

SELECT
SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(propertyaddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM Data_cleaning..nashville_housing

ALTER TABLE Data_cleaning..Nashville_housing
Add PropertySplitAddress NVARCHAR(255);

UPDATE Data_Cleaning..Nashville_Housing
SET PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Data_cleaning..Nashville_housing
Add PropertySplitCity NVARCHAR(255);

UPDATE Data_Cleaning..Nashville_Housing
SET PropertySplitCity = SUBSTRING(propertyaddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From Data_Cleaning..Nashville_Housing


Select OwnerAddress
From Data_Cleaning..Nashville_Housing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)
FROM Data_Cleaning..Nashville_Housing

ALTER TABLE Data_cleaning..Nashville_housing
Add OwnerSplitAddress NVARCHAR(255);

UPDATE Data_Cleaning..Nashville_Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

ALTER TABLE Data_cleaning..Nashville_housing
Add OwnerSplitCity NVARCHAR(255);

UPDATE Data_Cleaning..Nashville_Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

ALTER TABLE Data_cleaning..Nashville_housing
Add OwnerSplitState NVARCHAR(255);

UPDATE Data_Cleaning..Nashville_Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)


-- Change Y and N to Yes and NO in "Sold as vacant" Column

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM Data_Cleaning..Nashville_Housing

UPDATE Data_Cleaning..Nashville_Housing
SET soldasvacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM Data_Cleaning..Nashville_Housing


-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				Saleprice,
				saledate,
				legalreference
				ORDER BY 
					UniqueID
					) Row_num

FROM Data_Cleaning..Nashville_Housing
)
DELETE
FROM RowNumCTE
Where Row_num > 1


-- Delete Unused Columns
SELECT *
FROM Data_Cleaning..Nashville_Housing

ALTER TABLE Data_cleaning..Nashville_housing
DROP Column OwnerAddress, Taxdistrict, Propertyaddress, Saledate