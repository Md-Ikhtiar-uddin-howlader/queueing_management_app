![](https://lh7-us.googleusercontent.com/tjibtoJJ1ka90Y-tqpiZAFYtgW-M_sb28SLWGUxDgLgvhY2OBM6VSNJy19Bphjh8S7CDzh068rbUYkMiAYrK5NYo9eRKbGeNSBC1zzitxOgvdrJRBIZlT8RBgxCKiKRbrCSzWd5mCk_7wEfepHwOYlY)

**KULLIYYAH OF INFORMATION** 

**AND COMMUNICATION TECHNOLOGY**

 ****

                                                                                                                  ********

**INFO 4335 MOBILE APPLICATION DEVELOPMENT**

**SEMESTER 1 23/24** 

**SECTION 1**

                                                              ********

**Lecturer: Dr. MUHAMAD SADRY ABU SEMAN**

**Final project Mobile Application Development**

**Queue Management System**

 

|                               |               |
| ----------------------------- | ------------- |
| Name                          | Matric number |
| MD IKHTIAR UDDIN HOWLADER     | 1834619       |
| MUHAMMAD 'AFFIF BIN BIN RUSLI | 1923949       |
| AMIERUL SYAHMI BIN MOHD HASBI | 2016973       |
| DIMYATI AGUNG NABHAN          | 1929465       |

1. **Introduction**

Our project of Queue Management App, providing an in-depth exploration of an innovative mobile application built using the Flutter framework. This application redefines the traditional queue management system by incorporating cutting-edge technologies, such as QR codes and real-time Firebase Firestore integration. The primary objective is to create a seamless and efficient experience for both customers and counters, optimizing the overall queueing process.

On the Queue Management App offers an extensive examination of the app's functionalities, beginning with a role-based authentication system that distinguishes between customers and counters. Users can immerse themselves in the app's interface, simulating scenarios as both customers joining queues and counters managing the flow. Through the utilization of Firebase Firestore, the app ensures real-time updates, fostering a dynamic and responsive queue environment.

One of the app's key features is the QR code integration, allowing customers to effortlessly join queues by scanning unique QR codes. The app dynamically issues QR codes, ensuring a secure and efficient means of identification. The customer interface provides real-time information, including assigned queue numbers and notifications, while the counter interface facilitates smooth operations by managing and calling queue numbers.

2. **Objective**

The Queue Management App aims to revolutionize traditional queuing systems by introducing an efficient and user-friendly digital solution. With role-based authentication, the app caters to both customers and counters, providing tailored experiences based on their roles. Leveraging Firebase Firestore, the app ensures real-time data synchronization, allowing instant updates on queue numbers and statuses. The integration of QR code technology facilitates a secure and convenient method for customers to join queues, with counters having dedicated interfaces to manage the queue effectively.

3. **Features and Functionalities** 

The Queue Management App stands out as a sophisticated solution meticulously crafted to optimize and streamline the queuing process. Our system is designed with a user-centric approach, ensuring a seamless experience for both customers and counters. Packed with a multitude of functionalities and features, the app simplifies and enhances the entire queuing journey. Here are the features and functionalities

**1. QR Code Widget:**

Description: A reusable widget for displaying QR codes.

Functionality: Used across various screens to visually present and interact with QR codes.

**2. Authentication Screen (auth\_screen.dart):**

Description: Manages user authentication processes.

Features:

- User login and registration.

- Secure authentication mechanisms.

**3. Counter Screen (counter\_screen.dart):**

Description: This represents the interface for counters/staff members.

Features:

- Queue management functionalities for counters.

- Transaction handling and completion.

**4. Customer Screen (customer\_screen.dart):**

Description: This represents the interface for customers.

Features:

- Joining queues and receiving notifications.

- Real-time display of queue information.

**5. Dynamic QR Scanner Page (dynamic\_qr\_scanner\_page.dart):**

Description: Handles dynamic QR code scanning, possibly in real-time.

Features:

- Scanning and processing dynamic QR codes.

- Real-time interaction with changing QR codes.

**6. Home Screen (home\_screen.dart):**

Description: Initial screen where users can choose their role or navigate to different sections.

Features:

- Role selection for customers and counters.

- Navigation to different app sections.

**7. QR Scanner Page (qr\_scanner\_page.dart):**

Description: A screen dedicated to QR code scanning.

Features:

- QR code scanning for joining the queue using static QR codes.

- Verification of customer identities.

*

**8. Register Screen (register\_screen.dart):**

Description: Manages user registration processes during onboarding.

Features:

- User account creation.

- Collection of necessary information during registration.

**9. Queue QR Page (queue\_qr\_page.dart):**

Description: Possibly related to displaying or accessing QR codes associated with queues.

Features:

- Displaying queue-specific QR codes.

- Accessing queue-related functionalities.

**10. Firebase Service (firebase\_service.dart):**

Description: Likely provides services related to Firebase, such as authentication, Firestore integration, or other Firebase functionalities.

Features:

- Firebase authentication services.

- Firestore integration for real-time data.

**11. Firebase Options (firebase\_options.dart):**

Description: Contains configuration options for connecting your Flutter app to Firebase.

Features:

- Firebase authentication settings.

- Firestore configurations and options.

**12. Main Dart (main.dart):**

Description: The entry point of your Flutter application.

Features: Initializes the app and sets up the initial screen or widget to be displayed.

4. **Defining Routes and widget**

Screen Navigation (Routing):

The screen navigation in the Queue Management App is orchestrated through a well-defined routing system. The MaterialApp widget in main.dart serves as the entry point for the application and manages the routes to different screens.
![](https://lh7-us.googleusercontent.com/1osVVpmaBg9Yla2yk2GcfhSrDGCDd-WnYsa02aVqO4KHXINpNMs1yQyQiODx87LWNAEfbR-W_GSotncQaRZdAQn8Dx3LzCKqbKZAXUtSzQ4EtkbjstWromdOzWHHcELBaxAHS4sz7vTQ9OFL207FzN8)

In this configuration:

1. Home Screen Widget:

The HomeScreen widget provides a welcoming interface for users to start their interaction with the app.

2. Authentication Screen Widget:

The AuthScreen widget handles user authentication processes, including login and registration.

3. Counter Screen and Customer Screen

After authentication, users are navigated to either the Counter Screen or the Customer Screen, depending on their role. The Counter Screen is responsible for managing the queue at the counter, while the Customer Screen provides queue-related information to customers.

4. QR Scanner and Dynamic QR Scanner:

Both Counter Screen and Customer Screen may have QR Scanner functionalities. The QR Scanner allows customers to join the queue by scanning a QR code, while the Dynamic QR Scanner is used by the customer to join a queue that is issued by counter using QR codes.

5. Queue number issuing/Qr code:

the interface has been designed to empower counters with two key functionalities: creating a new queue number and issuing a QR code. The user-friendly layout includes a display of the current queue number, allowing the counter to seamlessly manage the ongoing queue. To initiate the next customer, a "Call Next Number" button is provided, ensuring a smooth and efficient process.

Widgets (UI and reusable widget)![](https://lh7-us.googleusercontent.com/2oJo-AzY10Frijh-ZqDxSQ8uAQvy0XoTh46Ksb-HcSIwdubfuG0ikRzjUizsmeoRnIfSFSpQ9ECMiP--Dnt8VjiGL1BgfH0XNeSklV6b1YalJEY-zH_8mcbFNzZrN3wTU2mXHkVrGZF-mczULcMSeb8)

1. Home Screen:

This screen likely contains buttons or elements for users to choose their role. Basic Flutter widgets like Scaffold and ElevatedButton are used.

2. Auth Screen:

Manages the authentication process and includes widgets for user interaction, such as a sign-in button. May include a form for user credentials.

3. Counter Screen and Customer Screen:

These screens consist of more complex widget hierarchies. They include widgets like AppBar for the top bar, Column and Row for layout, and specific widgets for displaying queue information.

4. QR Scanner and Dynamic QR Scanner:

These screens include the QR scanning functionality. The widget hierarchy would involve the QRView widget for camera integration, overlays for visual elements, and possibly additional widgets for user guidance.

5. Queue number issuing/Qr code:

the Counter Screen features an "Issue New Queue Number" button, enabling the counter to generate a fresh queue number for the upcoming customers. This innovative system enhances customer service by optimizing queue management. Alongside, the Counter Screen is equipped with the capability to generate QR codes for each issued queue number. This QR code serves as a convenient identification method for customers, facilitating easy scanning and tracking.

5. **Sequence Diagram

 ![](https://lh7-us.googleusercontent.com/alfL2uCGQg3ayFw7ImNXgaCQaEWjEdSyPSOWCTKVFH8_UvF8fTJ8rN6UFSpGlagvcpGMG5BJyGQQERpcm-ITXQ513erzRwWUKKoTzyVJkN8_BAWh8WJTLpWXWyMeeAfE6pUsjULKzTPfvLmIny65AZc)**

6) **References**

_Queue Management System (QMS) - Apps on Google Play_. (n.d.). Play.google.com. Retrieved January 30, 2024, from <https://play.google.com/store/apps/details?id=my.com.gms.qms.qmsapp&hl=en&gl=US>

‌AB, Q.-M. (n.d.). _Queue Management System_. Www\.qmatic.com. <https://www.qmatic.com/resources/queue-management-system>

‌
