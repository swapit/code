`wish*.csv` files represent the wish lists of the users  
format: userID,itemID

`have*.csv` files represent the give-away lists of the users   
format: userID,itemID

`transac*.csv` files represent an item sent from a user to anoter  
format: GiverUserID,ReceiverUserID,itemID,timestamp

`pair*.csv` files represent a bidirectional transaction between users  
where user1 owns item1 and give it to user2  
format: format: user1ID,item1ID,user2ID,item2ID,timestamp
