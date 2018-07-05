*** subject
**** The project is focused on migration DB identity number to distributed architecture in order to scale and reduce coupling
*** background
**** The legacy system has members table and id column is identity. The challenges not only avoid change legacy system behaviors but also to get zookeeper system new identity number to re-write the identity column to ensure workflow be safe.
*** how to change sql server identity to SEQUENCE in order to keep custom update key column
1. create sequence set start number to max(id)+1
2. create tempid 
3. copy id to tempid  
4. change tempid default to sequence 
5. delete pk
6. delete id
7. rename tempid to id
8. create new pk
*** other solution in order to avoid modify schema and down time
**** use IDENTITY_INSERT dbo.members off to insert custom id. use DBCC CHECKIDENT command to resume identity id to origin
