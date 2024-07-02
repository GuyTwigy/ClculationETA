Address List Manager

Overview

Address List Manager is a simple iOS application that allows users to manage a list of addresses with start and arrival times calculated based on ETAs between consecutive destinations.
The app offers functionalities such as adding, deleting, and rearranging addresses in the list.

Features

1. Add Address: Users can add an address to the list by entering the address name in the text field and clicking the add button.
   The first address added becomes the start location with a default start time of 9:00 AM.
2. Calculate ETA: When a new address is added, the app calculates the Estimated Time of Arrival (ETA) between the last address in the list and the new address.
   The new address is displayed with its calculated arrival time (e.g., if the ETA is 20 minutes, the arrival time will be 9:20 AM).
3. Clear List: A button to erase the entire list of addresses.
4. Delete Address: Users can delete an address by sliding the row in the list.
5. Rearrange Addresses: Users can drag and drop addresses to different positions in the list. The ETAs and arrival times are recalculated based on the new positions.
6. Expandable Cells: All addresses except the first one can be expanded by tapping on them.
    When expanded, the cell provides detailed information including the start time, end time, and travel duration between the current and previous addresses.
7. Use of Google API: The app uses Google API to get ETAs and address locations.
   
Technologies Used

Language: Swift
Framework: UIKit
Architecture: MVVM (Model-View-ViewModel)
Networking: Async/Await for asynchronous network calls

Testing

The app includes test files to verify its functionality.
