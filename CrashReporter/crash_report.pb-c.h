/* Generated by the protocol buffer compiler.  DO NOT EDIT! */

#ifndef PROTOBUF_C_Resources_2fcrash_5freport_2eproto__INCLUDED
#define PROTOBUF_C_Resources_2fcrash_5freport_2eproto__INCLUDED

#include "protobuf-c.h"

PROTOBUF_C_BEGIN_DECLS


typedef struct _Plcrash__CrashReport Plcrash__CrashReport;
typedef struct _Plcrash__CrashReport__SystemInfo Plcrash__CrashReport__SystemInfo;
typedef struct _Plcrash__CrashReport__ApplicationInfo Plcrash__CrashReport__ApplicationInfo;
typedef struct _Plcrash__CrashReport__Thread Plcrash__CrashReport__Thread;
typedef struct _Plcrash__CrashReport__Thread__StackFrame Plcrash__CrashReport__Thread__StackFrame;
typedef struct _Plcrash__CrashReport__Thread__RegisterValue Plcrash__CrashReport__Thread__RegisterValue;
typedef struct _Plcrash__CrashReport__BinaryImage Plcrash__CrashReport__BinaryImage;
typedef struct _Plcrash__CrashReport__Exception Plcrash__CrashReport__Exception;
typedef struct _Plcrash__CrashReport__Signal Plcrash__CrashReport__Signal;


/* --- enums --- */

typedef enum _Plcrash__Architecture {
  PLCRASH__ARCHITECTURE__X86_32 = 0,
  PLCRASH__ARCHITECTURE__X86_64 = 1,
  PLCRASH__ARCHITECTURE__ARM = 2,
  PLCRASH__ARCHITECTURE__PPC = 3,
  PLCRASH__ARCHITECTURE__PPC64 = 4
} Plcrash__Architecture;
typedef enum _Plcrash__OperatingSystem {
  PLCRASH__OPERATING_SYSTEM__MAC_OS_X = 0,
  PLCRASH__OPERATING_SYSTEM__IPHONE_OS = 1,
  PLCRASH__OPERATING_SYSTEM__IPHONE_SIMULATOR = 2
} Plcrash__OperatingSystem;

/* --- messages --- */

struct  _Plcrash__CrashReport__SystemInfo
{
  ProtobufCMessage base;
  Plcrash__OperatingSystem operating_system;
  char *os_version;
  Plcrash__Architecture architecture;
  uint32_t timestamp;
};
#define PLCRASH__CRASH_REPORT__SYSTEM_INFO__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&plcrash__crash_report__system_info__descriptor) \
    , 0, NULL, 0, 0 }


struct  _Plcrash__CrashReport__ApplicationInfo
{
  ProtobufCMessage base;
  char *identifier;
  char *version;
};
#define PLCRASH__CRASH_REPORT__APPLICATION_INFO__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&plcrash__crash_report__application_info__descriptor) \
    , NULL, NULL }


struct  _Plcrash__CrashReport__Thread__StackFrame
{
  ProtobufCMessage base;
  uint64_t pc;
};
#define PLCRASH__CRASH_REPORT__THREAD__STACK_FRAME__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&plcrash__crash_report__thread__stack_frame__descriptor) \
    , 0 }


struct  _Plcrash__CrashReport__Thread__RegisterValue
{
  ProtobufCMessage base;
  char *name;
  uint64_t value;
};
#define PLCRASH__CRASH_REPORT__THREAD__REGISTER_VALUE__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&plcrash__crash_report__thread__register_value__descriptor) \
    , NULL, 0 }


struct  _Plcrash__CrashReport__Thread
{
  ProtobufCMessage base;
  uint32_t thread_number;
  size_t n_frames;
  Plcrash__CrashReport__Thread__StackFrame **frames;
  protobuf_c_boolean crashed;
  size_t n_registers;
  Plcrash__CrashReport__Thread__RegisterValue **registers;
};
#define PLCRASH__CRASH_REPORT__THREAD__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&plcrash__crash_report__thread__descriptor) \
    , 0, 0,NULL, 0, 0,NULL }


struct  _Plcrash__CrashReport__BinaryImage
{
  ProtobufCMessage base;
  uint64_t base_address;
  uint64_t size;
  char *name;
  protobuf_c_boolean has_uuid;
  ProtobufCBinaryData uuid;
};
#define PLCRASH__CRASH_REPORT__BINARY_IMAGE__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&plcrash__crash_report__binary_image__descriptor) \
    , 0, 0, NULL, 0,{0,NULL} }


struct  _Plcrash__CrashReport__Exception
{
  ProtobufCMessage base;
  char *name;
  char *reason;
};
#define PLCRASH__CRASH_REPORT__EXCEPTION__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&plcrash__crash_report__exception__descriptor) \
    , NULL, NULL }


struct  _Plcrash__CrashReport__Signal
{
  ProtobufCMessage base;
  char *name;
  char *code;
  uint64_t address;
};
#define PLCRASH__CRASH_REPORT__SIGNAL__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&plcrash__crash_report__signal__descriptor) \
    , NULL, NULL, 0 }


struct  _Plcrash__CrashReport
{
  ProtobufCMessage base;
  Plcrash__CrashReport__SystemInfo *system_info;
  Plcrash__CrashReport__ApplicationInfo *application_info;
  size_t n_threads;
  Plcrash__CrashReport__Thread **threads;
  size_t n_binary_images;
  Plcrash__CrashReport__BinaryImage **binary_images;
  Plcrash__CrashReport__Exception *exception;
  Plcrash__CrashReport__Signal *signal;
};
#define PLCRASH__CRASH_REPORT__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&plcrash__crash_report__descriptor) \
    , NULL, NULL, 0,NULL, 0,NULL, NULL, NULL }


/* Plcrash__CrashReport methods */
void   plcrash__crash_report__init
                     (Plcrash__CrashReport         *message);
size_t plcrash__crash_report__get_packed_size
                     (const Plcrash__CrashReport   *message);
size_t plcrash__crash_report__pack
                     (const Plcrash__CrashReport   *message,
                      uint8_t             *out);
size_t plcrash__crash_report__pack_to_buffer
                     (const Plcrash__CrashReport   *message,
                      ProtobufCBuffer     *buffer);
Plcrash__CrashReport *
       plcrash__crash_report__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   plcrash__crash_report__free_unpacked
                     (Plcrash__CrashReport *message,
                      ProtobufCAllocator *allocator);
/* --- per-message closures --- */

typedef void (*Plcrash__CrashReport__SystemInfo_Closure)
                 (const Plcrash__CrashReport__SystemInfo *message,
                  void *closure_data);
typedef void (*Plcrash__CrashReport__ApplicationInfo_Closure)
                 (const Plcrash__CrashReport__ApplicationInfo *message,
                  void *closure_data);
typedef void (*Plcrash__CrashReport__Thread__StackFrame_Closure)
                 (const Plcrash__CrashReport__Thread__StackFrame *message,
                  void *closure_data);
typedef void (*Plcrash__CrashReport__Thread__RegisterValue_Closure)
                 (const Plcrash__CrashReport__Thread__RegisterValue *message,
                  void *closure_data);
typedef void (*Plcrash__CrashReport__Thread_Closure)
                 (const Plcrash__CrashReport__Thread *message,
                  void *closure_data);
typedef void (*Plcrash__CrashReport__BinaryImage_Closure)
                 (const Plcrash__CrashReport__BinaryImage *message,
                  void *closure_data);
typedef void (*Plcrash__CrashReport__Exception_Closure)
                 (const Plcrash__CrashReport__Exception *message,
                  void *closure_data);
typedef void (*Plcrash__CrashReport__Signal_Closure)
                 (const Plcrash__CrashReport__Signal *message,
                  void *closure_data);
typedef void (*Plcrash__CrashReport_Closure)
                 (const Plcrash__CrashReport *message,
                  void *closure_data);

/* --- services --- */


/* --- descriptors --- */

extern const ProtobufCEnumDescriptor    plcrash__architecture__descriptor;
extern const ProtobufCEnumDescriptor    plcrash__operating_system__descriptor;
extern const ProtobufCMessageDescriptor plcrash__crash_report__descriptor;
extern const ProtobufCMessageDescriptor plcrash__crash_report__system_info__descriptor;
extern const ProtobufCMessageDescriptor plcrash__crash_report__application_info__descriptor;
extern const ProtobufCMessageDescriptor plcrash__crash_report__thread__descriptor;
extern const ProtobufCMessageDescriptor plcrash__crash_report__thread__stack_frame__descriptor;
extern const ProtobufCMessageDescriptor plcrash__crash_report__thread__register_value__descriptor;
extern const ProtobufCMessageDescriptor plcrash__crash_report__binary_image__descriptor;
extern const ProtobufCMessageDescriptor plcrash__crash_report__exception__descriptor;
extern const ProtobufCMessageDescriptor plcrash__crash_report__signal__descriptor;

PROTOBUF_C_END_DECLS


#endif  /* PROTOBUF_Resources_2fcrash_5freport_2eproto__INCLUDED */