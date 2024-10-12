## Project Title: Flutter To-Do List and Sensor Tracking Application
Project Overview
This project is a mobile application developed using Flutter, designed to enhance user productivity through a robust To-Do List feature and provide real-time sensor tracking capabilities. The application integrates a user-friendly interface based on a provided Figma design and emphasizes functionality, usability, and responsiveness.

Key Features
To-Do List Functionality:

Task Management: Users can add, edit, and remove task headings, details, and due dates.  
Task Completion: Users can mark tasks as completed, allowing them to manage their to-do list effectively.
Due Date Notifications: The app sends in-app notifications when a task's due date matches the current date, ensuring users stay informed and on track.
Sensor Tracking:
Real-Time Data Visualization: The application features two graphs that continuously display real-time data from the device's gyroscope and accelerometer sensors.
Movement Alerts: An alert is triggered if significant movement is detected on any two axes simultaneously, notifying users with the message "ALERT".

Technical Details
Architecture: The application is structured around a local store database, utilizing a two-table relationship for effective data management and retrieval.
Local Notifications: Implemented using the local notification package to alert users of due dates in a timely manner.
Data Management: The app employs state management principles to ensure smooth data flow and user experience.
User Interface: Designed based on the provided Figma file, ensuring an intuitive and aesthetically pleasing user interface. The design has been improvised to enhance usability while staying true to the application's theme.
Technologies Used
Framework: Flutter
Database: Local storage (SQLite)
State Management: Provider / Riverpod (depending on your implementation)
Notifications: Local notifications package
Sensors: Sensors Plus package for gyroscope and accelerometer data
Charting: Syncfusion Flutter Charts for data visualization
samples, guidance on mobile development, and a full API reference.

# Screenshot of this application
<p float="left" >
<img src="https://github.com/md-arif-hossainn/todo_sensor/blob/master/lib/screen_shot/1.jpg" width="220"/>
<img src="https://github.com/md-arif-hossainn/todo_sensor/blob/master/lib/screen_shot/2.jpg" width="220"/>
<img src="https://github.com/md-arif-hossainn/todo_sensor/blob/master/lib/screen_shot/3.jpg" width="220"/>
<img src="https://github.com/md-arif-hossainn/todo_sensor/blob/master/lib/screen_shot/4.jpg"width="220"/>
<img src="https://github.com/md-arif-hossainn/todo_sensor/blob/master/lib/screen_shot/5.jpg" width="220"/>
<img src="https://github.com/md-arif-hossainn/todo_sensor/blob/master/lib/screen_shot/6.jpg" width="220"/>
<img src="https://github.com/md-arif-hossainn/todo_sensor/blob/master/lib/screen_shot/7.jpg" width="220"/>
<img src="https://github.com/md-arif-hossainn/todo_sensor/blob/master/lib/screen_shot/8.jpg"width="220"/>
</p>
