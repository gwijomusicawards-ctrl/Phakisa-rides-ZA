# Production backend contract

Use Firebase Cloud Functions, Cloud Run, or another secure backend.

Required server-side functions:
- createRide()
- findNearbyDrivers()
- acceptRide()
- cancelRide()
- startTrip()
- completeTrip()
- updateDriverLocation()
- calculateFare()
- createPaymentIntent()
- paymentWebhook()
- sendPushNotification()
- rateRide()
- verifyDriverDocuments()

Suggested Firestore collections:
users/{uid}
drivers/{uid}
vehicles/{vehicleId}
rides/{rideId}
driver_locations/{uid}
payments/{paymentId}
ratings/{ratingId}
promos/{promoId}
support_tickets/{ticketId}

Never trust fare totals, driver identity, payment state, or trip state sent only from the mobile client. Validate them on the server.
