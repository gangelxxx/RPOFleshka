/*

  File:     usb.h
  Author:   Alan Macek <www.alanmacek.com>
  Date:     March 1, 2001

  This file contains the declarations for connecting to USB HID devices.

  You are free to use this code for anything you want but please send me
  (al@alanmacek.com) an email telling me what you are using it for and
  how it works out.  You are NOT ALLOWED to use this code until you send
  me an email.
    
  This code comes with absolutely no warranty at all.
*/

#include <windows.h>

#ifdef __cplusplus
extern "C" {
#endif 

/* Both of these functions return INVALID_HANDLE_VALUE on an error, if there is no error
    then the HANDLE must be closed using 'CloseHandle' */

/* Connects to the ith USB HID device connected to the computer */
HANDLE connectToIthUSBHIDDevice (DWORD i);

/* Connects to the USB HID described by the combination of vendor id, product id
   If the attribute is null, it will connect to first device satisfying the remaining
   attributes. */
#ifdef __cplusplus
}
#endif
