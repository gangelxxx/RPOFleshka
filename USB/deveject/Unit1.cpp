//---------------------------------------------------------------------------

#pragma hdrstop

//---------------------------------------------------------------------------

#pragma argsused
// DevEject.cpp
// Plug&Play-Geräte automatisch abmelden, für Windows 2000/XP/2003
// Übersetzen mit Visual C++:
//   cl deveject.cpp advapi32.lib
// 2003 c't/Matthias Withopf

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>

class TDeviceEject
  {
  public:
    typedef enum
	  {
		deec_Ok                        =  0,
        deec_UnsupportedOS             =  1,
        deec_ErrorLoadingLibrary       =  2,
        deec_LibraryFunctionMissing    =  3,
        deec_DeviceNotFound            =  4,
        deec_DeviceNotRemovable        =  5,
        deec_DeviceHasProblem          =  6,
        deec_NativeError               =  7,
        deec_ErrorGettingDevNodeStatus =  8,
        deec_ErrorGettingDeviceIdSize  =  9,
        deec_ErrorGettingDeviceId      = 10,
        deec_ErrorGettingChild         = 11,
        deec_ErrorGettingSibling       = 12,
        deec_ErrorLocatingDevNode      = 13,
        deec_ErrorDeviceEject          = 14,
        deec_ErrorEjectVetoed          = 15,
        deec_LAST
      } TDeviceEjectErrorCode;
    TDeviceEjectErrorCode DeviceEjectErrorCode;
    // Fehlercodes des Configuration Managers
    enum
      {
        CR_SUCCESS                  = 0x00,
        CR_DEFAULT                  = 0x01,
        CR_OUT_OF_MEMORY            = 0x02,
        CR_INVALID_POINTER          = 0x03,
        CR_INVALID_FLAG             = 0x04,
        CR_INVALID_DEVNODE          = 0x05,
        CR_INVALID_RES_DES          = 0x06,
        CR_INVALID_LOG_CONF         = 0x07,
        CR_INVALID_ARBITRATOR       = 0x08,
        CR_INVALID_NODELIST         = 0x09,
        CR_DEVNODE_HAS_REQS         = 0x0A,
        CR_INVALID_RESOURCEID       = 0x0B,
        CR_DLVXD_NOT_FOUND          = 0x0C,
        CR_NO_SUCH_DEVNODE          = 0x0D,
        CR_NO_MORE_LOG_CONF         = 0x0E,
        CR_NO_MORE_RES_DES          = 0x0F,
        CR_ALREADY_SUCH_DEVNODE     = 0x10,
        CR_INVALID_RANGE_LIST       = 0x11,
        CR_INVALID_RANGE            = 0x12,
        CR_FAILURE                  = 0x13,
        CR_NO_SUCH_LOGICAL_DEV      = 0x14,
        CR_CREATE_BLOCKED           = 0x15,
        CR_NOT_SYSTEM_VM            = 0x16,
        CR_REMOVE_VETOED            = 0x17,
        CR_APM_VETOED               = 0x18,
        CR_INVALID_LOAD_TYPE        = 0x19,
        CR_BUFFER_SMALL             = 0x1A,
        CR_NO_ARBITRATOR            = 0x1B,
        CR_NO_REGISTRY_HANDLE       = 0x1C,
        CR_REGISTRY_ERROR           = 0x1D,
        CR_INVALID_DEVICE_ID        = 0x1E,
        CR_INVALID_DATA             = 0x1F,
        CR_INVALID_API              = 0x20,
        CR_DEVLOADER_NOT_READY      = 0x21,
        CR_NEED_RESTART             = 0x22,
        CR_NO_MORE_HW_PROFILES      = 0x23,
        CR_DEVICE_NOT_THERE         = 0x24,
        CR_NO_SUCH_VALUE            = 0x25,
        CR_WRONG_TYPE               = 0x26,
        CR_INVALID_PRIORITY         = 0x27,
        CR_NOT_DISABLEABLE          = 0x28,
        CR_FREE_RESOURCES           = 0x29,
        CR_QUERY_VETOED             = 0x2A,
        CR_CANT_SHARE_IRQ           = 0x2B,
        CR_NO_DEPENDENT             = 0x2C,
        CR_SAME_RESOURCES           = 0x2D,
        CR_NO_SUCH_REGISTRY_KEY     = 0x2E,
        CR_INVALID_MACHINENAME      = 0x2F,
        CR_REMOTE_COMM_FAILURE      = 0x30,
        CR_MACHINE_UNAVAILABLE      = 0x31,
        CR_NO_CM_SERVICES           = 0x32,
        CR_ACCESS_DENIED            = 0x33,
        CR_CALL_NOT_IMPLEMENTED     = 0x34,
        CR_INVALID_PROPERTY         = 0x35,
        CR_DEVICE_INTERFACE_ACTIVE  = 0x36,
        CR_NO_SUCH_DEVICE_INTERFACE = 0x37,
        CR_INVALID_REFERENCE_STRING = 0x38,
        CR_INVALID_CONFLICT_LIST    = 0x39,
        CR_INVALID_INDEX            = 0x3A,
        CR_INVALID_STRUCTURE_SIZE   = 0x3B
      };
    DWORD NativeErrorCode;
    TDeviceEject(BOOL AVerbose,BOOL ADebug);
    ~TDeviceEject();
    TDeviceEjectErrorCode Eject(PCHAR EjectDevSpec,BOOL EjectDevSpecIsName,PDWORD NativeErrorCode,PDWORD EjectedCount);
    static BOOL GetDriveDeviceId(PCHAR DriveSpec,PCHAR DeviceId,DWORD MaxDeviceIdSize);
  private:
    BOOL    Verbose;
    BOOL    Debug;
    HMODULE Lib;
    BOOL    UnloadLib;
    typedef DWORD  DEVINST,*PDEVINST;
    typedef CHAR  *DEVINSTID_A;
    typedef enum
      {
        PNP_VetoTypeUnknown,
        PNP_VetoLegacyDevice,
        PNP_VetoPendingClose,
        PNP_VetoWindowsApp,
        PNP_VetoWindowsService,
        PNP_VetoOutstandingOpen,
        PNP_VetoDevice,
        PNP_VetoDriver,
        PNP_VetoIllegalDeviceRequest,
        PNP_VetoInsufficientPower,
        PNP_VetoNonDisableable,
        PNP_VetoLegacyDriver,
        PNP_VetoInsufficientRights
      } PNP_VETO_TYPE,* PPNP_VETO_TYPE;
    enum
      {
        DN_REMOVABLE = 0x00004000
      };
    typedef DWORD  CONFIGRET;
    typedef CONFIGRET (WINAPI *TCM_Locate_DevNodeA)      (OUT PDEVINST pdnDevInst,IN DEVINSTID_A pDeviceID,OPTIONAL IN ULONG ulFlags);
    typedef CONFIGRET (WINAPI *TCM_Get_Child)            (OUT PDEVINST pdnDevInst,IN DEVINST dnDevInst,IN ULONG ulFlags);
    typedef CONFIGRET (WINAPI *TCM_Get_Sibling)          (OUT PDEVINST pdnDevInst,IN DEVINST DevInst,IN ULONG ulFlags);
    typedef CONFIGRET (WINAPI *TCM_Get_DevNode_Status)   (OUT PULONG pulStatus,OUT PULONG pulProblemNumber,IN DEVINST dnDevInst,IN ULONG ulFlags);
    typedef CONFIGRET (WINAPI *TCM_Get_Device_ID_Size)   (OUT PULONG pulLen,IN DEVINST dnDevInst,IN ULONG ulFlags);
    typedef CONFIGRET (WINAPI *TCM_Get_Device_IDA)       (IN DEVINST dnDevInst,OUT PCHAR Buffer,IN ULONG BufferLen,IN ULONG ulFlags);
    typedef CONFIGRET (WINAPI *TCM_Request_Device_EjectA)(IN DEVINST dnDevInst,OUT PPNP_VETO_TYPE pVetoType,OUT LPSTR pszVetoName,IN ULONG ulNameLength,IN ULONG ulFlags);
    TCM_Locate_DevNodeA       Func_LocateDevNode;
    TCM_Get_Child             Func_GetChild;
    TCM_Get_Sibling           Func_GetSibling;
    TCM_Get_DevNode_Status    Func_GetDevNodeStatus;
    TCM_Get_Device_ID_Size    Func_GetDeviceIDSize;
    TCM_Get_Device_IDA        Func_GetDeviceID;
    TCM_Request_Device_EjectA Func_RequestDeviceEject;

    typedef struct _TEnumDeviceInfo
      {
        struct _TEnumDeviceInfo *Parent;
        DEVINST                  DevInst;
        ULONG                    Status;
        ULONG                    ProblemNumber;
      } TEnumDeviceInfo,* PEnumDeviceInfo;
    TDeviceEjectErrorCode EnumDevices(PEnumDeviceInfo ParentEnumDeviceInfo,PDWORD EjectDeviceFound,PCHAR EjectDevSpec,BOOL EjectDevSpecIsName,DEVINST DevInst,int Indent,PDWORD NativeErrorCode);
    BOOL                  GetFriendlyName(PCHAR DeviceId,PCHAR Name,DWORD MaxNameSize);
  };
typedef TDeviceEject * PDeviceEject;

TDeviceEject::TDeviceEject(BOOL AVerbose,BOOL ADebug)
{
  DeviceEjectErrorCode    = deec_Ok;
  NativeErrorCode         = 0;
  Verbose                 = AVerbose;
  Debug                   = ADebug;
  Lib                     = NULL;
  UnloadLib               = FALSE;
  Func_LocateDevNode      = NULL;
  Func_GetChild           = NULL;
  Func_GetSibling         = NULL;
  Func_GetDevNodeStatus   = NULL;
  Func_GetDeviceIDSize    = NULL;
  Func_GetDeviceID        = NULL;
  Func_RequestDeviceEject = NULL;

  BOOL OSOk = FALSE;
  DWORD V = GetVersion();
  if (!(V & 0x80000000))
    {
      BYTE MajorVersion = (BYTE)V;
      if (MajorVersion >= 5)
        OSOk = TRUE;
    }
  if (!OSOk)
    DeviceEjectErrorCode = deec_UnsupportedOS;
  else
    {
      const PCHAR LibFileName = "setupapi.dll";
      Lib = GetModuleHandle(LibFileName);
      if (!Lib)
        {
          Lib = LoadLibrary(LibFileName);
          if (Lib)
            UnloadLib = TRUE;
        }
      if (!Lib)
        {
          DeviceEjectErrorCode = deec_ErrorLoadingLibrary;
          NativeErrorCode      = GetLastError();
        }
      else
        {
          Func_LocateDevNode      = (TCM_Locate_DevNodeA)      GetProcAddress(Lib,"CM_Locate_DevNodeA");
          Func_GetChild           = (TCM_Get_Child)            GetProcAddress(Lib,"CM_Get_Child");
          Func_GetSibling         = (TCM_Get_Sibling)          GetProcAddress(Lib,"CM_Get_Sibling");
          Func_GetDevNodeStatus   = (TCM_Get_DevNode_Status)   GetProcAddress(Lib,"CM_Get_DevNode_Status");
          Func_GetDeviceIDSize    = (TCM_Get_Device_ID_Size)   GetProcAddress(Lib,"CM_Get_Device_ID_Size");
          Func_GetDeviceID        = (TCM_Get_Device_IDA)       GetProcAddress(Lib,"CM_Get_Device_IDA");
          Func_RequestDeviceEject = (TCM_Request_Device_EjectA)GetProcAddress(Lib,"CM_Request_Device_EjectA");
        }
    }
}

TDeviceEject::~TDeviceEject()
{
  if (Lib && UnloadLib)
    FreeLibrary(Lib);
}

BOOL TDeviceEject::GetDriveDeviceId(PCHAR DriveSpec,PCHAR DeviceId,DWORD MaxDeviceIdSize)
{
  BOOL Result = FALSE;
  if (DeviceId && MaxDeviceIdSize)
    DeviceId[0] = '\0';
  if (DriveSpec && DriveSpec[0] && DeviceId && MaxDeviceIdSize)
    {
      HKEY Key;
      LONG L = RegOpenKeyEx(HKEY_LOCAL_MACHINE,"SYSTEM\\MountedDevices",0,KEY_QUERY_VALUE,&Key);
      if (L == ERROR_SUCCESS)
        {
          DWORD Type;
          BYTE  Value[1024];
          DWORD ValueSize = sizeof Value;
          CHAR  ValueName[256];
          strcpy(ValueName,"\\DosDevices\\");
          strncat(ValueName,DriveSpec,sizeof ValueName - 1);
          ValueName[sizeof ValueName - 1] = '\0';
          L = RegQueryValueEx(Key,ValueName,0,&Type,(BYTE *)Value,&ValueSize);
          RegCloseKey(Key);
          if ((L == ERROR_SUCCESS) && (Type == REG_BINARY))
            {
              // Beispielsweise:
              //   \??\SBP2#API-903-95__&1394_Storage_+_Repeater_&LUN0#0050c564500068e2#{53f5630d-b6bf-11d0-94f2-00a0c91efb8b}
              // ->
              //   SBP2\API-903-95__&1394_STORAGE_+_REPEATER_&LUN0\0050C564500068E2
              PWSTR p1 = (PWSTR)Value;
              ValueSize /= sizeof *p1;
              if ((p1[0] == '\\') && (p1[1] == '?') && (p1[2] == '?') && (p1[3] == '\\'))
                {
                  Result = TRUE;
                  p1        += 4;
                  ValueSize -= 4;
                  PCHAR p2 = DeviceId;
                  for (unsigned int i = 0;i < ValueSize;++i)
                    {
                      CHAR c = p1[i];
                      if ((c == '{') || ((c == '#') && (p1[i + 1] == '{')))
                        break;
                      if (c == '#')
                        c = '\\';
                      if ((p2 - DeviceId) < (MaxDeviceIdSize - 1))
                        *p2++ = c;
                    }
                  *p2 = '\0';
                }
            }
        }
    }
  return Result;
}

BOOL TDeviceEject::GetFriendlyName(PCHAR DeviceId,PCHAR Name,DWORD MaxNameSize)
{
  BOOL Result = FALSE;
  if (Name && MaxNameSize)
    Name[0] = '\0';
  if (DeviceId && DeviceId[0] && Name && MaxNameSize)
    {
      HKEY Key;
      CHAR KeyName[1024];
      strcpy(KeyName,"SYSTEM\\CurrentControlSet\\Enum\\");
      strncat(KeyName,DeviceId,sizeof KeyName - 1);
      KeyName[sizeof KeyName - 1] = '\0';
      LONG L = RegOpenKeyEx(HKEY_LOCAL_MACHINE,KeyName,0,KEY_QUERY_VALUE,&Key);
      if (L == ERROR_SUCCESS)
        {
          DWORD Type;
          BYTE  Value[1024];
          DWORD ValueSize = sizeof Value;
          L = RegQueryValueEx(Key,"FriendlyName",0,&Type,(BYTE *)Value,&ValueSize);
          if (L != ERROR_SUCCESS)
            L = RegQueryValueEx(Key,"DeviceDesc",0,&Type,(BYTE *)Value,&ValueSize);
          RegCloseKey(Key);
          if ((L == ERROR_SUCCESS) && (Type == REG_SZ))
            {
              strncpy(Name,(PCHAR)Value,MaxNameSize - 1);
              Name[MaxNameSize - 1] = '\0';
              Result = TRUE;
            }
        }
    }
  return Result;
}

static BOOL CompareWithWildcard(PCHAR s1,PCHAR s2)
{
  if (s1 && s2)
    for (;;)
      {
        if (*s2 == '*')
          return TRUE;
        if (!*s1)
          {
            if (!*s2)
              return TRUE;
            break;
          }
        if (!*s2)
          {
            if (!*s1)
              return TRUE;
            break;
          }
        if (toupper(*s1++) != toupper(*s2++))
          break;
      }
  return FALSE;
}

TDeviceEject::TDeviceEjectErrorCode TDeviceEject::EnumDevices(PEnumDeviceInfo ParentEnumDeviceInfo,PDWORD EjectDeviceFound,PCHAR EjectDevSpec,BOOL EjectDevSpecIsName,DEVINST DevInst,int Indent,PDWORD NativeErrorCode)
{
  TDeviceEjectErrorCode Result = deec_Ok;

  DEVINST ThisDevInst = DevInst;
  while (Result == deec_Ok)
    {
      ULONG Status; // DN_...
      ULONG ProblemNumber;
      CONFIGRET r = Func_GetDevNodeStatus(&Status,&ProblemNumber,ThisDevInst,0);
      if (r == CR_NO_SUCH_DEVNODE)
        {
        }
      else if (r != CR_SUCCESS)
        {
          Result = deec_ErrorGettingDevNodeStatus;      
          *NativeErrorCode = r;
        }
      if (Result == deec_Ok)
        {
          ULONG DeviceIDLen;
          r = Func_GetDeviceIDSize(&DeviceIDLen,ThisDevInst,0);
          if (r != CR_SUCCESS)
            {
              Result = deec_ErrorGettingDeviceIdSize;
              *NativeErrorCode = r;
            }
          else
            {
              PCHAR DeviceID = new CHAR[DeviceIDLen + 1];
              if (DeviceID)
                {
                  r = Func_GetDeviceID(ThisDevInst,DeviceID,DeviceIDLen + 1,0);
                  if (r != CR_SUCCESS)
                    {
                      Result = deec_ErrorGettingDeviceId;
                      *NativeErrorCode = r;
                    }
                  else
                    {
                      CHAR FriendlyName[512];
                      if (!GetFriendlyName(DeviceID,FriendlyName,sizeof FriendlyName))
                        FriendlyName[0] = '\0';

                      if (Verbose)
                        {
                          for (int i = 0;i < Indent * 2;++i)
                            printf(" ");
                          printf("%s",DeviceID);

                          if (Debug)
                            {
                              printf(" DevInst: %u",ThisDevInst);
                              printf(" Status: 0x%X ",Status);
                            }

                          if (FriendlyName[0])
                            printf(" '%s'",FriendlyName);

                          if (Status & DN_REMOVABLE)
                            printf(" [REMOVEABLE]");
                          if (ProblemNumber)
                            printf(" ProblemNumber: %u",ProblemNumber);

                          printf("\n");
                        }
                      else
                        {
                          if (!EjectDevSpec || !EjectDevSpec[0])
                            if (Status & DN_REMOVABLE)
                              {
                                if (FriendlyName[0])
                                  printf("'%s' ",FriendlyName);
                                printf("'%s' [REMOVEABLE]\n",DeviceID);
                              }
                        }

                      BOOL Found = FALSE;
                      if (EjectDevSpec && EjectDevSpec[0])
                        {
                          if (EjectDevSpecIsName)
                            {
                              if (FriendlyName[0])
                                Found = CompareWithWildcard(FriendlyName,EjectDevSpec);
                            }
                          else
                            Found = CompareWithWildcard(DeviceID,EjectDevSpec);
                        }
                      if (Found)
                        {
                          ++*EjectDeviceFound;
                          DEVINST EjectDevInst = ThisDevInst;
                          if (!(Status & DN_REMOVABLE))
                            {
                              // Dieses Device ist nicht auswerfbar, probiere übergeordneten Eintrag
                              for (PEnumDeviceInfo EDI = ParentEnumDeviceInfo;EDI;EDI = EDI->Parent)
                                {
                                  if (EDI->Status & DN_REMOVABLE)
                                    {
                                      EjectDevInst  = EDI->DevInst;
                                      Status        = EDI->Status;
                                      ProblemNumber = EDI->ProblemNumber;
                                      break;
                                    }
                                }
                            }

                          if (!(Status & DN_REMOVABLE))
                            {
                              Result = deec_DeviceNotRemovable;

                              printf("Device");
                              if (FriendlyName[0])
                                printf(" '%s'",FriendlyName);
                              printf(" [%s] not removable!\n",DeviceID);
                            }
                          else
                            {
                              if (ProblemNumber)
                                {
                                  Result = deec_DeviceHasProblem;
                                  *NativeErrorCode = ProblemNumber;
                                }
                              else
                                {
                                  printf("Ejecting ");
                                  if (FriendlyName[0])
                                    printf(" '%s'",FriendlyName);
                                  printf(" [%s]...",DeviceID);

                                  PNP_VETO_TYPE VetoType;
                                  CHAR          VetoName[MAX_PATH];
                                  r = Func_RequestDeviceEject(EjectDevInst,&VetoType,VetoName,sizeof VetoName,0);
                                  if (r == CR_SUCCESS)
                                    printf("ok.\n");
                                  else
                                    {
                                      printf("FAILED (%u,%u)\n",r,VetoType);
                                      if (r == CR_REMOVE_VETOED)
                                        {
                                          Result = deec_ErrorEjectVetoed;
                                          *NativeErrorCode = VetoType;
                                        }
                                      else
                                        {
                                          Result = deec_ErrorDeviceEject;
                                          *NativeErrorCode = r;
                                        }
                                    }
                                }
                            }
                        }
                    }
                  delete [] DeviceID;
                }
            }
        }

      if (Result == deec_Ok)
        {
          DEVINST Child;
          r = Func_GetChild(&Child,ThisDevInst,0);
          if (r == CR_NO_SUCH_DEVNODE)
            {
            }
          else if (r != CR_SUCCESS)
            {
              Result = deec_ErrorGettingChild;
              *NativeErrorCode = r;
            }
          else
            {
              TEnumDeviceInfo EnumDeviceInfo;
              EnumDeviceInfo.Parent        = ParentEnumDeviceInfo;
              EnumDeviceInfo.DevInst       = ThisDevInst;
              EnumDeviceInfo.Status        = Status;
              EnumDeviceInfo.ProblemNumber = ProblemNumber;
              Result = EnumDevices(&EnumDeviceInfo,EjectDeviceFound,EjectDevSpec,EjectDevSpecIsName,Child,Indent + 1,NativeErrorCode);
            }
          if (Result == deec_Ok)
            {
              DEVINST Sibling;
              r = Func_GetSibling(&Sibling,ThisDevInst,0);
              if (r == CR_NO_SUCH_DEVNODE)
                break;
              if (r != CR_SUCCESS)
                {
                  Result = deec_ErrorGettingSibling;
                  *NativeErrorCode = r;
                }
              ThisDevInst = Sibling;
            }
        }
    }
  return Result;
}

TDeviceEject::TDeviceEjectErrorCode TDeviceEject::Eject(PCHAR EjectDevSpec,BOOL EjectDevSpecIsName,PDWORD NativeErrorCode,PDWORD EjectedCount)
{
  TDeviceEjectErrorCode Result = deec_Ok;
  *NativeErrorCode = 0;
  if (EjectedCount)
    *EjectedCount = 0;
  if (!Func_LocateDevNode || !Func_GetChild || !Func_GetSibling || !Func_GetDevNodeStatus || !Func_GetDeviceIDSize || !Func_GetDeviceID || !Func_RequestDeviceEject)
    Result = deec_LibraryFunctionMissing;
  else
    {
      DEVINST RootDevInst;
      CONFIGRET r = Func_LocateDevNode(&RootDevInst,NULL,0/*CM_LOCATE_DEVNODE_NORMAL*/);
      if (r != CR_SUCCESS)
        {
          Result = deec_ErrorLocatingDevNode;
          *NativeErrorCode = r;
        }
      else
        {
          DWORD EjectDeviceFound = 0;
          Result = EnumDevices(NULL,&EjectDeviceFound,EjectDevSpec,EjectDevSpecIsName,RootDevInst,0,NativeErrorCode);
          if ((Result == deec_Ok) && EjectDevSpec[0] && !EjectDeviceFound)
            Result = deec_DeviceNotFound;
          if (EjectedCount)
            *EjectedCount = EjectDeviceFound;
        }
    }
  return Result;
}

int main(int argc,char *argv[])
{
  int ExitCode = 0;

  printf("DevEject 1.0  2003 c't/Matthias Withopf\n\n");

  BOOL ArgsOk  = TRUE;
  BOOL Verbose = FALSE;
  BOOL Debug   = FALSE;
  CHAR EjectDrive[80];
  CHAR EjectDevSpec[1024];
  EjectDrive[0]   = '\0';
  EjectDevSpec[0] = '\0';
  BOOL EjectDevSpecIsName = FALSE;
  for (int i = 1;i < argc;++i)
    {
	  if (!strcmp(argv[i],"-v"))
        Verbose = TRUE;
	  else if (!strcmp(argv[i],"-Debug"))
        Debug = TRUE;
      else if (!strncmp(argv[i],"-EjectDrive:",12))
        {
          strncpy(EjectDrive,argv[i] + 12,sizeof EjectDrive - 1);
		  EjectDrive[sizeof EjectDrive - 1] = '\0';
		  if (!TDeviceEject::GetDriveDeviceId(EjectDrive,EjectDevSpec,sizeof EjectDevSpec))
            {
			  printf("Invalid drive specification '%s'!\n",EjectDrive);
              ArgsOk = FALSE;
              break;
            }
          EjectDevSpecIsName = FALSE;
        }
      else if (!strncmp(argv[i],"-EjectName:",11))
        {
          strncpy(EjectDevSpec,argv[i] + 11,sizeof EjectDevSpec - 1);
		  EjectDevSpec[sizeof EjectDevSpec - 1] = '\0';
          EjectDevSpecIsName = TRUE;
        }
      else if (!strncmp(argv[i],"-EjectId:",9))
        {
          strncpy(EjectDevSpec,argv[i] + 9,sizeof EjectDevSpec - 1);
          EjectDevSpec[sizeof EjectDevSpec - 1] = '\0';
          EjectDevSpecIsName = FALSE;
        }
      else
        {
          printf("Unknown argument '%s'!\n",argv[i]);
          ArgsOk = FALSE;
          break;
        }
    }

  if (!ArgsOk)
    {
      ExitCode = 10;
      printf("Usage: %s -EjectDrive:<Drive>|-EjectName:<Name>|-EjectId:<DeviceId> [-v] [-Debug]\n",argv[0]);
    }
  else
    {
      if (Verbose)
        {
          if (EjectDrive[0])
            printf("Ejecting: %s -> %s\n",EjectDrive,EjectDevSpec);
          else if (EjectDevSpec[0])
            printf("Ejecting: %s\n",EjectDevSpec);
        }

      PDeviceEject DeviceEject = new TDeviceEject(Verbose,Debug);
      if (!DeviceEject)
        ExitCode = 11;
      else
        {
          if (DeviceEject->DeviceEjectErrorCode)
            {
              ExitCode = 12;
              switch(DeviceEject->DeviceEjectErrorCode)
                {
                  case TDeviceEject::deec_UnsupportedOS:
                    printf("Operating system not supported!\n");
                    break;

                  default:
                    printf("Error in device eject, error code %u,%u!\n",DeviceEject->DeviceEjectErrorCode,DeviceEject->NativeErrorCode);
                    break;
                }
            }
          else
            {
              DWORD NativeErrorCode;
              DWORD EjectedCount;
              TDeviceEject::TDeviceEjectErrorCode ErrorCode = DeviceEject->Eject(EjectDevSpec,EjectDevSpecIsName,&NativeErrorCode,&EjectedCount);
              if (ErrorCode == TDeviceEject::deec_Ok)
                {
                  if (EjectDevSpec[0])
                    printf("%u device(s) ejected.\n",EjectedCount);
                }
              else
                {
                  ExitCode = 13;
                  switch(ErrorCode)
                    {
                      case TDeviceEject::deec_DeviceNotFound:
                        printf("Error ejecting device %s, not found (%u,%u)!\n",EjectDevSpec,ErrorCode,NativeErrorCode);
                        break;

                      case TDeviceEject::deec_DeviceNotRemovable:
                        printf("Error ejecting device %s, not removable (%u,%u)!\n",EjectDevSpec,ErrorCode,NativeErrorCode);
                        break;

                      case TDeviceEject::deec_DeviceHasProblem:
                        printf("Error ejecting device %s, has problem (%u,%u)!\n",EjectDevSpec,ErrorCode,NativeErrorCode);
                        break;

                      case TDeviceEject::deec_ErrorEjectVetoed:
                        printf("Error ejecting device %s, vetoed (%u,%u)!\n",EjectDevSpec,ErrorCode,NativeErrorCode);
                        break;

                      default:
                        printf("Error ejecting device %s, error code %u,%u!\n",EjectDevSpec,ErrorCode,NativeErrorCode);
                        break;
                    }
                }
            }
          delete DeviceEject;
        }
    }
  return ExitCode;
}
//---------------------------------------------------------------------------
