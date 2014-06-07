SELECT * FROM FaktaPembelian
SELECT * FROM DimensiWaktu
SELECT * FROM FilterTimeStamp

DELETE FROM DimensiWaktu

DELETE FROM FilterTimeStamp WHERE NamaTable = 'FaktaPembelian'
DELETE FROM FilterTimeStamp WHERE NamaTable NOT LIKE 'DimensiWaktu'

SELECT * FROM FaktaPenjualan

SELECT * FROM DimensiEmployee

DELETE FROM FaktaPenyewaan
DELETE FROM FaktaPenjualan
DELETE FROM FaktaPembelian
DELETE FROM FaktaLayananService

SELECT * FROM DimensiComputerRent
SELECT * FROM DimensiCustomer
SELECT * FROM DimensiEmployee
SELECT * FROM DimensiProduct
SELECT * FROM DimensiServiceType
SELECT * FROM DimensiVendor
SELECT * FROM DimensiWaktu

SELECT * FROM FaktaLayananService
SELECT * FROM FaktaPenyewaan

