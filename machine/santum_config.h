#ifndef _SANCTUM_MEMORY_H
#define _SANCTUM_MEMORY_H

#define BOOT_ROM_BASE   (0x1000)
#define BOOT_ROM_SIZE   (0x1000)

#define MEM_LOADER_BASE 0x1000000
#define MSIP_BASE       0x2000000
#define FROMHOST        0x80000000
#define TOHOST          0x80000008
#define DRAM_BASE       (0x80000000)
#define DRAM_SIZE       (2048*1024*1024)

#define BOOTLOADER_BASE 0x80002000
#define BOOTLOADER_SIZE 131072

#define XLEN            64
#define NUM_HARTS       1
#define REGION_SIZE     (32*1024*1024)
#define M_STACK_SIZE    0x1000

#endif
