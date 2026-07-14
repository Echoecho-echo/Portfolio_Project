--Project Objective: Data Cleaning
--Skills: Standardization, Populating columns, Case Statements, Dropping Columns, Parsing

-- Having a look at loaded data
SELECT *
FROM NashvilleHousing
WHERE PropertyAddress is null --check if data population worked

--Standardize date format

--Now adding it, officially, to the table.
ALTER TABLE NashvilleHousing
ADD Sale_Date date --Create new date column to be able to add data properly

UPDATE NashvilleHousing
SET Sale_Date = (cast (SaleDate as date)) --Add data from original date column to new column, cast differently.

--Looking at property address columns
SELECT * --PropertyAddress
FROM NashvilleHousing
ORDER BY ParcelID
--WHERE PropertyAddress is null

--Creating a self-join to populate null property address rows
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
, ISNULL(a.PropertyAddress, b.PropertyAddress) --Take rows with null values (from here, value2) and replace with value inputted in (value1, here)
FROM NashvilleHousing as a
JOIN NashvilleHousing as b --JOIN table to itself
 ON a.ParcelID = b.ParcelID --WHERE parcel_id columns are equal
AND a.[UniqueID ] < > b.[UniqueID ] --but where the unique IDs do not equal each other
WHERE a.PropertyAddress is null

--Observation: A and B have the same Parcel_IDs, and on parts where both addresses are present
--the parcel IDs are the same as well, we can infer the same about the addresses. 
--In this instance, we can populate the null addresses in table A 
--with the values from table B where the Parcel ID is the same as that of table A

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing as a
JOIN NashvilleHousing as b --JOIN table to itself
 ON a.ParcelID = b.ParcelID --WHERE parcel_id columns are equal
AND a.[UniqueID ] < > b.[UniqueID ] --but where the unique IDs do not equal each other
WHERE a.PropertyAddress is null

--Breaking out address into individual columns (Country, State/Province, City)
SELECT PropertyAddress
FROM NashvilleHousing

--ParseNaming the Property Address
SELECT 
PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1) as City
,PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2) as Street
FROM NashvilleHousing

--Altering the table by creating new columns for the new Property address data
ALTER TABLE NashvilleHousing
ADD PropertyCity nvarchar(255)

ALTER TABLE NashvilleHousing
ADD PropertyStreet nvarchar (255)

--Add the data to new columns
UPDATE NashvilleHousing
SET PropertyCity = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1)

UPDATE NashvilleHousing
SET PropertyStreet = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2)

--ParseName works the same as Substring & Indexing.
--But because it works for periods, I replaced the comma with a period
--also, it starts counting from the back so I need to flip the numbering of position when adding the data

SELECT 
PARSENAME (REPLACE(OwnerAddress,',', '.'), 1) AS State
,PARSENAME (REPLACE(OwnerAddress,',', '.'), 2) AS City
,PARSENAME (REPLACE(OwnerAddress,',', '.'), 3) AS Street
FROM NashvilleHousing

--Creating new columns and adding the data
--For State
ALTER TABLE NashvilleHousing
ADD OwnerState nvarchar (255)

UPDATE NashvilleHousing
SET OwnerState = PARSENAME (REPLACE(OwnerAddress,',', '.'), 1)

--For City
ALTER TABLE NashvilleHousing
ADD OwnersCity nvarchar (255)

UPDATE NashvilleHousing
SET OwnersCity = PARSENAME (REPLACE(OwnerAddress,',', '.'), 2)

--For Street Address
ALTER TABLE NashvilleHousing
ADD OwnersStreet nvarchar (255)

UPDATE NashvilleHousing
SET OwnersStreet = PARSENAME (REPLACE(OwnerAddress,',', '.'), 3)

--Creating uniformity by replacing the "Y/N" letters with full words "Yes/No"
--Yes and No seem to be the vastly populated ones, so it's only fitting to change the others to those values.
SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant),
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant --Else, keep it as SoldAsVacant
END
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant)

--Applying the uniformity to the actual data on the actual table
UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
	WHEN SoldAsVacant = 'N' THEN 'No' 
	ELSE SoldAsVacant
	END

--Removing duplicates
WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID, 
					PropertyAddress, 
					SalePrice, 
					Sale_Date,
					LegalReference
					ORDER BY 
						UniqueID) Row_num --Partitioning on things that should be unique
FROM NashvilleHousing)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate