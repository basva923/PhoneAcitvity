# PhoneAcitvity

This is NOT an application provided by Garmin.

This application can be installed on a Garmin device (with connect IQ) and sends live activity data to your phone.

## Requirements
- This application is installed on your Garmin device
- Garmin Connect is installed on your phone
- GarminLive is installed on your phone: [Github repo](https://github.com/basva923/GarminLive)

## Documentation
To show your activity on your phone:
1. Connect your Garmin device to your phone.
2. Open the PhoneActivity app on your Garmin device.
3. Wait for a GPS signal (shown on top).
4. Open the GarminLive app on your phone.
5. Press start to begin your activity.

## Build
This application can be build with Monkey C. For instructions, have a look at the [Garmin Documentation](https://developer.garmin.com/connect-iq/reference-guides/jungle-reference/).

If your want to contribute I recomment a setup using Docker: [docker-connectiq](https://github.com/kalemena/docker-connectiq)

A binary is also available in the bin directory.

## Limitations
- The only activity type that is supported is Cycling.
