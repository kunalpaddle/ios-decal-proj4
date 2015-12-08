<h1> MealPoint</h1>

<h2> Authors </h2>
- Kunal Patel

<h2> Purpose </h2>
MealPoint allows Berkeley students to buy and sell their meal points with ease.

<h2> Features </h2>
<h3> MVP </h3>
- Users "check in" to Cal Dining facilities as a buyer or seller using geofencing
- Users can create profiles including a photo. 
- Sellers can find buyers via their photos.
<h3> Future ideas</h3>
- Users can view menus at all Cal Dining locations.
- Meal point price is tracked over time, producing a Meal Point Pricing Index.
- Facebook profile integration 

<h2> Control Flow </h2>

-  Registration required for use. New users are presented with a splash screen to create an account.
- The app will request location access for basic functionality.
- Once registered and logged in, users are presented with a dashboard  featuring a table whose entries feature thumbnails and names of each dining facility, along with how many sellers are present at each dining facility.
- The user can press on the dining facility of their choice to be taken to another screen where he or she can:
>-  ***Check in as a seller.*** GPS location is verified to ensure seller is in reasonable proximity to dining facility. The seller specifies their price-per-point, along with an optional short blurb specifying his or her whereabouts. 

>-  ***Check in as a buyer.*** In this case, the buyer can browse available sellers and their prices, and specify the amount of points he or she needs. Once a choice is made, the seller is sent a notification to meet the buyer. If the seller verifies that they are available and ready make the transaction, the buyer will be notified of this as well. 

- After meeting in person with the buyer, the seller can charge the buyer via an interface used to hit the Venmo API. The buyer pays and enjoys his or her meal.

<h2> Implementation </h2>
<h3> Model </h3>

- DiningLocationCell.swift
- User.swift
- DiningFacility.swift
- Buyer.swift
- Seller.swift

<h3> View </h3>

- DiningLocationTableView
- SellerTableView
- VenmoChargeView
- LoginView
- DiningLocationView
- DashboardView

<h3> View Controller </h3>

- DashboardViewController
- LoginViewController
- DiningLocationViewController
- SellerTableViewController 

