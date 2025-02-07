SELECT
*
FROM NashvilleHousingData.dbo.NashvilleHousingCSV;


-- Determine the total number of rows and columns in the data table
SELECT
	(SELECT
	COUNT(*) 
	FROM NashvilleHousingData.dbo.NashvilleHousingCSV)
	AS TotalRows,

	(SELECT 
	COUNT(*)
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'NashvilleHousingCSV')
	AS TotalColumns;
-- 56477 rows, 19 columns

--------------------------------------------------------------------------

-- Change date format from datetime to date ("SaleDate") 

SELECT
SaleDate,
CONVERT(DATE, SaleDate)
FROM NashvilleHousingData.dbo.NashvilleHousingCSV;  -- visualize format

UPDATE NashvilleHousingCSV
SET SaleDate = CONVERT(DATE, SaleDate);		        -- update the stored values

ALTER TABLE NashvilleHousingCSV
ALTER COLUMN SaleDate DATE;							-- alter the column data type


SELECT
*
FROM NashvilleHousingData.dbo.NashvilleHousingCSV;

---------------------------------------------------------------------------------- 

-- Populate property address data

SELECT
*
FROM NashvilleHousingData.dbo.NashvilleHousingCSV
WHERE PropertyAddress IS NULL;  
-- 29 rows of data have NULL property addresses

SELECT
*
FROM NashvilleHousingCSV
ORDER BY ParcelID;  

/* 
It looks like the ParcelID corresponds to PropertyAddress based on duplicates.
So, we can use the ParcelID to populate missing PropertyAddress fields.  

Will need to use a self join
*/

SELECT
COUNT(ParcelID)
FROM NashvilleHousingData.dbo.NashvilleHousingCSV
WHERE ParcelID IS NULL;
-- 0 null values in ParcelID

SELECT
a.ParcelID,
a.PropertyAddress,
b.ParcelID,
b.PropertyAddress
FROM NashvilleHousingData.dbo.NashvilleHousingCSV a
JOIN NashvilleHousingData.dbo.NashvilleHousingCSV b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;
-- ALL a.PropertyAddress NULL values have a b.PropertyAddress full address value

SELECT
a.ParcelID,
a.PropertyAddress,
b.ParcelID,
b.PropertyAddress,
ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousingData.dbo.NashvilleHousingCSV a
JOIN NashvilleHousingData.dbo.NashvilleHousingCSV b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;
-- Returns specified columns plus a new column with the b.PropertyAddress addresses where a.PropertyAddress is Null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousingData.dbo.NashvilleHousingCSV a
JOIN NashvilleHousingData.dbo.NashvilleHousingCSV b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;
-- Update a.PropertyAddress column

SELECT
*
FROM NashvilleHousingData.dbo.NashvilleHousingCSV
WHERE PropertyAddress IS NULL;  
-- demonstrates that there are no longer NULL values in the PropertyAddress column

--------------------------------------------------------------------------------

-- Break out address into individual columns (address, city, state)

SELECT
PropertyAddress
FROM NashvilleHousingData.dbo.NashvilleHousingCSV;

/* 
The PropertyAddress field has a comma delimiter in the pattern address,city
*/

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM NashvilleHousingData.dbo.NashvilleHousingCSV;  -- separates address and city at the comma

/* 
Create two new columns to add the separated values into
*/

ALTER TABLE NashvilleHousingCSV
ADD PropSplitAddress NVARCHAR(255);		

UPDATE NashvilleHousingCSV
SET PropSplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);		

ALTER TABLE NashvilleHousingCSV
ADD PropSplitCity NVARCHAR(255);	

UPDATE NashvilleHousingCSV
SET PropSplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));		


SELECT
*
FROM NashvilleHousingData.dbo.NashvilleHousingCSV; -- Check for proper return 



/* 
Separate values in "OwnerAddress", which has address, city, state

Will use PARSENAME instead of SUBSTRING
*/

SELECT
OwnerAddress
FROM NashvilleHousingData.dbo.NashvilleHousingCSV;

SELECT
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1)
FROM NashvilleHousingData.dbo.NashvilleHousingCSV;

ALTER TABLE NashvilleHousingCSV
ADD OwnerSplitAddress NVARCHAR(255);		

UPDATE NashvilleHousingCSV
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3);		

ALTER TABLE NashvilleHousingCSV
ADD OwnerSplitCity NVARCHAR(255);	

UPDATE NashvilleHousingCSV
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2);

ALTER TABLE NashvilleHousingCSV
ADD OwnerSplitState NVARCHAR(255);	

UPDATE NashvilleHousingCSV
SET OwnerSplitSTATE = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1);

SELECT
*
FROM NashvilleHousingData.dbo.NashvilleHousingCSV; -- Check for proper return 


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT 
DISTINCT(SoldAsVacant),
COUNT(SoldAsVacant)
FROM NashvilleHousingData.dbo.NashvilleHousingCSV
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT
COUNT(SoldAsVacant)
FROM NashvilleHousingData.dbo.NashvilleHousingCSV
WHERE SoldAsVacant IS NULL;  
-- No NULL values

SELECT 
SoldAsVacant,
CASE
	WHEN SoldAsVacant = 0 THEN 'NO'
	ELSE 'Yes'
END
FROM NashvilleHousingData.dbo.NashvilleHousingCSV; -- Convert 0 to No and 1 to Yes

ALTER TABLE NashvilleHousingCSV
ALTER COLUMN SoldAsVacant VARCHAR(3);              -- Change data type from bit to varchar(3)

UPDATE NashvilleHousingCSV
SET 
SoldAsVacant = 
CASE
	WHEN SoldAsVacant = 0 THEN 'NO'
	ELSE 'Yes'
END
FROM NashvilleHousingData.dbo.NashvilleHousingCSV;  -- Update the values in the SoldAsVacant column

SELECT
*
FROM NashvilleHousingCSV                             -- Inspect the results

----------------------------------------------------------------------------

-- Remove duplicates
WITH RowNumCTE AS (
SELECT
*,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY UniqueID
			) row_num
FROM NashvilleHousingData.dbo.NashvilleHousingCSV
--ORDER BY ParcelID;
)
SELECT
*
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;  -- returns 104 duplicates.  So we will delete these rows


WITH RowNumCTE AS (
SELECT
*,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY UniqueID
			) row_num
FROM NashvilleHousingData.dbo.NashvilleHousingCSV
--ORDER BY ParcelID;
)
DELETE
FROM RowNumCTE
WHERE row_num > 1;  -- Delete 104 duplicate rows

----------------------------------------------------------------------------------------------

-- Delete unused columns

SELECT
*
FROM NashvilleHousingData.dbo.NashvilleHousingCSV;


ALTER TABLE NashvilleHousingCSV
DROP COLUMN
	OwnerAddress,
	TaxDistrict, 
	PropertyAddress;

ALTER TABLE NashvilleHousingCSV
DROP COLUMN SaleDate;
