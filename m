Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121C13BDFF5
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 01:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhGGAAA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Jul 2021 20:00:00 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:52964 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhGFX76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 19:59:58 -0400
Received: by mail-il1-f197.google.com with SMTP id a7-20020a9233070000b02901edc50cdfdcso287902ilf.19
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 16:57:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to
         :content-transfer-encoding;
        bh=LpoCm2n9B7wG2XedvKaqoDqkyOKY6/efT7ZGM3OQIqs=;
        b=pJPUdQ6LLXZR4/UxcI89hJOu/0aRTMKjFgHvzpQ1yvmZOzUa9crZIvUi6mNqzmA2c6
         P7kCT/+hRJjx6Hqz9gouSmOMJeiWhEF8oAIkLz3ewHge+XNcd0Nw+8eYP0uAGrfuycLO
         LQdDAnVqzS02zI56D+Z6SxVh/rMchxYzxU4DWl1J4u4G+YR2zRMBTdbn3/Rz6SZKmwsN
         rsPXUwdgDkoVF75mzEbMuQNMc9l4sUuQwvd3qpYDGwHN5NcI5MimWx07Yv0l6pu1jYXY
         ROvoTQ5Fx/SBZQg0B6cK9IAIWzSZyZS8nAmiO5cSpnp8XlXAS/707zgYaohaqgI9FZqI
         rAuQ==
X-Gm-Message-State: AOAM533BXHZC+fVLwSz59A49SKjsaskO3Q3sQfGHs5AwXSqIYGgrkTjN
        kDCPff+t4pFm8NF7m/SpZq8veetDd1YfvCeQruIHRFeAyGeh
X-Google-Smtp-Source: ABdhPJzr8WwKUgo1tJEwHnhENbj9Qf5mzcFU0afdU/MUH4fbW+VhOfZ6OJZdL3KBxQOWdSliXAL+IEIpEGinMplPl9zd2JRuB2kR
MIME-Version: 1.0
X-Received: by 2002:a92:a806:: with SMTP id o6mr16595787ilh.53.1625615838086;
 Tue, 06 Jul 2021 16:57:18 -0700 (PDT)
Date:   Tue, 06 Jul 2021 16:57:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000920a5e05c67d2e78@google.com>
Subject: [syzbot] net boot error: possible deadlock in get_page_from_freelist
From:   syzbot <syzbot+e14d0a60fd2ef5301544@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b43c8909 udp: properly flush normal packet at GRO time
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=140552e2300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=26b64b13fcecb7e1
dashboard link: https://syzkaller.appspot.com/bug?extid=e14d0a60fd2ef5301544

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e14d0a60fd2ef5301544@syzkaller.appspotmail.com

pci 0000:00:05.0: vgaarb: setting as boot VGA device
pci 0000:00:05.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
pci 0000:00:05.0: vgaarb: bridge control possible
vgaarb: loaded
SCSI subsystem initialized
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
mc: Linux media interface: v0.10
videodev: Linux video capture interface: v2.00
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
EDAC MC: Ver: 3.0.0
Advanced Linux Sound Architecture Driver Initialized.
Bluetooth: Core ver 2.22
NET: Registered PF_BLUETOOTH protocol family
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
NET: Registered PF_ATMPVC protocol family
NET: Registered PF_ATMSVC protocol family
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
NetLabel:  unlabeled traffic allowed by default
nfc: nfc_init: NFC Core ver 0.1
NET: Registered PF_NFC protocol family
PCI: Using ACPI for IRQ routing
clocksource: Switched to clocksource kvm-clock
VFS: Disk quotas dquot_6.6.0
VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
FS-Cache: Loaded
CacheFiles: Loaded
TOMOYO: 2.6.0
Mandatory Access Control activated.
AppArmor: AppArmor Filesystem Enabled
pnp: PnP ACPI init
pnp: PnP ACPI: found 7 devices
clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
NET: Registered PF_INET protocol family
IP idents hash table entries: 131072 (order: 8, 1048576 bytes, vmalloc)
tcp_listen_portaddr_hash hash table entries: 4096 (order: 6, 327680 bytes, vmalloc)
TCP established hash table entries: 65536 (order: 7, 524288 bytes, vmalloc)
TCP bind hash table entries: 65536 (order: 10, 4718592 bytes, vmalloc)
TCP: Hash tables configured (established 65536 bind 65536)

============================================
WARNING: possible recursive locking detected
5.13.0-syzkaller #0 Not tainted
--------------------------------------------
swapper/0/1 is trying to acquire lock:
ffff8880b9d31620 (lock#2){..-.}-{2:2}, at: rmqueue_pcplist mm/page_alloc.c:3675 [inline]
ffff8880b9d31620 (lock#2){..-.}-{2:2}, at: rmqueue mm/page_alloc.c:3713 [inline]
ffff8880b9d31620 (lock#2){..-.}-{2:2}, at: get_page_from_freelist+0x486/0x2f80 mm/page_alloc.c:4175

but task is already holding lock:
ffff8880b9d31620 (lock#2){..-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(lock#2);
  lock(lock#2);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by swapper/0/1:
 #0: ffff8880b9d31620 (lock#2){..-.}-{2:2}, at: __alloc_pages_bulk+0x4ad/0x1870 mm/page_alloc.c:5291

stack backtrace:
CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:96
 print_deadlock_bug kernel/locking/lockdep.c:2944 [inline]
 check_deadlock kernel/locking/lockdep.c:2987 [inline]
 validate_chain kernel/locking/lockdep.c:3776 [inline]
 __lock_acquire.cold+0x149/0x3ab kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 local_lock_acquire include/linux/local_lock_internal.h:42 [inline]
 rmqueue_pcplist mm/page_alloc.c:3675 [inline]
 rmqueue mm/page_alloc.c:3713 [inline]
 get_page_from_freelist+0x4aa/0x2f80 mm/page_alloc.c:4175
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5386
 alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2147
 alloc_pages+0x238/0x2a0 mm/mempolicy.c:2270
 stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
 save_stack+0x15e/0x1e0 mm/page_owner.c:120
 __set_page_owner+0x50/0x290 mm/page_owner.c:181
 prep_new_page mm/page_alloc.c:2445 [inline]
 __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5313
 alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
 vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
 __vmalloc_area_node mm/vmalloc.c:2845 [inline]
 __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2947
 __vmalloc_node mm/vmalloc.c:2996 [inline]
 __vmalloc+0x69/0x80 mm/vmalloc.c:3010
 alloc_large_system_hash+0x2b2/0x405 mm/page_alloc.c:8751
 mptcp_token_init+0x45/0xec net/mptcp/token.c:388
 mptcp_proto_init+0x1d9/0x22a net/mptcp/protocol.c:3415
 mptcp_init+0x10/0x47 net/mptcp/ctrl.c:180
 inet_init+0x250/0x424 net/ipv4/af_inet.c:2006
 do_one_initcall+0x103/0x650 init/main.c:1246
 do_initcall_level init/main.c:1319 [inline]
 do_initcalls init/main.c:1335 [inline]
 do_basic_setup init/main.c:1355 [inline]
 kernel_init_freeable+0x6b8/0x741 init/main.c:1557
 kernel_init+0x1a/0x1d0 init/main.c:1449
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
MPTCP token hash table entries: 8192 (order: 7, 720896 bytes, vmalloc)
UDP hash table entries: 4096 (order: 7, 655360 bytes, vmalloc)
UDP-Lite hash table entries: 4096 (order: 7, 655360 bytes, vmalloc)
NET: Registered PF_UNIX/PF_LOCAL protocol family
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
NET: Registered PF_XDP protocol family
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfefff window]
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:05.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
PCI: CLS 0 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
software IO TLB: mapped [mem 0x00000000b5c00000-0x00000000b9c00000] (64MB)
RAPL PMU: API unit is 2^-32 Joules, 0 fixed counters, 10737418240 ms ovfl timer
kvm: already loaded the other module
clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x212733415c7, max_idle_ns: 440795236380 ns
clocksource: Switched to clocksource tsc
Initialise system trusted keyrings
workingset: timestamp_bits=40 max_order=21 bucket_order=0
zbud: loaded
DLM installed
squashfs: version 4.0 (2009/01/31) Phillip Lougher
FS-Cache: Netfs 'nfs' registered for caching
NFS: Registering the id_resolver key type
Key type id_resolver registered
Key type id_legacy registered
nfs4filelayout_init: NFSv4 File Layout Driver Registering...
nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
FS-Cache: Netfs 'cifs' registered for caching
Key type cifs.spnego registered
Key type cifs.idmap registered
ntfs: driver 2.1.32 [Flags: R/W].
efs: 1.0a - http://aeschi.ch.eu.org/efs/
jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
QNX4 filesystem 0.2.3 registered.
qnx6: QNX6 filesystem 1.0.0 registered.
fuse: init (API version 7.33)
orangefs_debugfs_init: called with debug mask: :none: :0:
orangefs_init: module version upstream loaded
JFS: nTxBlock = 8192, nTxLock = 65536
SGI XFS with ACLs, security attributes, realtime, quota, fatal assert, debug enabled
9p: Installing v9fs 9p2000 file system support
FS-Cache: Netfs '9p' registered for caching
NILFS version 2 loaded
befs: version: 0.9.3
ocfs2: Registered cluster interface o2cb
ocfs2: Registered cluster interface user
OCFS2 User DLM kernel interface loaded
gfs2: GFS2 installed
FS-Cache: Netfs 'ceph' registered for caching
ceph: loaded (mds proto 32)
NET: Registered PF_ALG protocol family
xor: automatically using best checksumming function   avx       
async_tx: api initialized (async)
Key type asymmetric registered
Asymmetric key parser 'x509' registered
Asymmetric key parser 'pkcs8' registered
Key type pkcs7_test registered
Asymmetric key parser 'tpm_parser' registered
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 241)
io scheduler mq-deadline registered
io scheduler kyber registered
io scheduler bfq registered
start plist test
end plist test
usbcore: registered new interface driver udlfb
usbcore: registered new interface driver smscufx
uvesafb: failed to execute /sbin/v86d
uvesafb: make sure that the v86d helper is installed and executable
uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
uvesafb: vbe_init() failed with -22
uvesafb: probe of uvesafb.0 failed with error -22
vga16fb: initializing
vga16fb: mapped to 0xffff8880000a0000
Console: switching to colour frame buffer device 80x30
fb0: VGA16 VGA frame buffer device
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: button: Power Button [PWRF]
input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
ACPI: button: Sleep Button [SLPF]
ACPI: \_SB_.LNKC: Enabled at IRQ 11
virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
ACPI: \_SB_.LNKD: Enabled at IRQ 10
virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
ACPI: \_SB_.LNKB: Enabled at IRQ 10
virtio-pci 0000:00:06.0: virtio_pci: leaving for legacy driver
virtio-pci 0000:00:07.0: virtio_pci: leaving for legacy driver
N_HDLC line discipline registered with maxframe=4096
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
00:05: ttyS2 at I/O 0x3e8 (irq = 6, base_baud = 115200) is a 16550A
00:06: ttyS3 at I/O 0x2e8 (irq = 7, base_baud = 115200) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
[drm] Initialized vgem 1.0.0 20120112 for vgem on minor 0
[drm] Initialized vkms 1.0.0 20180514 for vkms on minor 1
checking generic (a0000 10000) vs hw (0 0)
platform vkms: [drm] fb1: vkmsdrmfb frame buffer device
usbcore: registered new interface driver udl
brd: module loaded
loop: module loaded
zram: Added device: zram0
null_blk: module loaded
Guest personality initialized and is inactive
VMCI host device registered (name=vmci, major=10, minor=120)
Initialized host personality
usbcore: registered new interface driver rtsx_usb
usbcore: registered new interface driver viperboard
usbcore: registered new interface driver dln2
usbcore: registered new interface driver pn533_usb
nfcsim 0.2 initialized
usbcore: registered new interface driver port100
usbcore: registered new interface driver nfcmrvl
Loading iSCSI transport class v2.0-870.
scsi host0: Virtio SCSI HBA
st: Version 20160209, fixed bufsize 32768, s/g segs 256
Rounding down aligned max_sectors from 4294967295 to 4294967288
db_root: cannot open: /etc/target
slram: not enough parameters.
ftl_cs: FTL header not found.
wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
MACsec IEEE 802.1AE
libphy: Fixed MDIO Bus: probed
tun: Universal TUN/TAP device driver, 1.6
vcan: Virtual CAN interface driver
vxcan: Virtual CAN Tunnel driver
slcan: serial line CAN interface driver
slcan: 10 dynamic interface channels.
CAN device driver interface
usbcore: registered new interface driver usb_8dev
usbcore: registered new interface driver ems_usb
usbcore: registered new interface driver esd_usb2
usbcore: registered new interface driver gs_usb
usbcore: registered new interface driver kvaser_usb
usbcore: registered new interface driver mcba_usb
usbcore: registered new interface driver peak_usb
e100: Intel(R) PRO/100 Network Driver
e100: Copyright(c) 1999-2006 Intel Corporation
e1000: Intel(R) PRO/1000 Network Driver
e1000: Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver
e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
mkiss: AX.25 Multikiss, Hans Albas PE1AYX
AX.25: 6pack driver, Revision: 0.3.0
AX.25: bpqether driver version 004
PPP generic driver version 2.4.2
PPP BSD Compression module registered
PPP Deflate Compression module registered
PPP MPPE Compression module registered
NET: Registered PF_PPPOX protocol family
PPTP driver version 0.8.5
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
CSLIP: code copyright 1989 Regents of the University of California.
SLIP linefill/keepalive option.
hdlc: HDLC support module revision 1.22
LAPB Ethernet driver version 0.02
usbcore: registered new interface driver ath9k_htc
usbcore: registered new interface driver carl9170
usbcore: registered new interface driver ath6kl_usb
usbcore: registered new interface driver ar5523
usbcore: registered new interface driver ath10k_usb
usbcore: registered new interface driver rndis_wlan
mac80211_hwsim: initializing netlink
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
usbcore: registered new interface driver atusb
mac802154_hwsim mac802154_hwsim: Added 2 mac802154 hwsim hardware radios
VMware vmxnet3 virtual NIC driver - version 1.5.0.0-k-NAPI
usbcore: registered new interface driver catc
usbcore: registered new interface driver kaweth
pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
usbcore: registered new interface driver pegasus
usbcore: registered new interface driver rtl8150
usbcore: registered new interface driver r8152
hso: drivers/net/usb/hso.c: Option Wireless
usbcore: registered new interface driver hso
usbcore: registered new interface driver lan78xx
usbcore: registered new interface driver asix
usbcore: registered new interface driver ax88179_178a
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver cdc_eem
usbcore: registered new interface driver dm9601
usbcore: registered new interface driver sr9700
usbcore: registered new interface driver CoreChips
usbcore: registered new interface driver smsc75xx
usbcore: registered new interface driver smsc95xx
usbcore: registered new interface driver gl620a
usbcore: registered new interface driver net1080
usbcore: registered new interface driver plusb
usbcore: registered new interface driver rndis_host
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
usbcore: registered new interface driver MOSCHIP usb-ethernet driver
usbcore: registered new interface driver int51x1
usbcore: registered new interface driver cdc_phonet
usbcore: registered new interface driver kalmia
usbcore: registered new interface driver ipheth
usbcore: registered new interface driver sierra_net
usbcore: registered new interface driver cx82310_eth
usbcore: registered new interface driver cdc_ncm
usbcore: registered new interface driver huawei_cdc_ncm
usbcore: registered new interface driver lg-vl600
usbcore: registered new interface driver qmi_wwan
usbcore: registered new interface driver cdc_mbim
usbcore: registered new interface driver ch9200
VFIO - User Level meta-driver version: 0.3
aoe: AoE v85 initialised.
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ehci-platform: EHCI generic platform driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci-pci: OHCI PCI platform driver
ohci-platform: OHCI generic platform driver
uhci_hcd: USB Universal Host Controller Interface driver
driver u132_hcd
fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
Warning! fotg210_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
usbcore: registered new interface driver cdc_acm
cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
usbcore: registered new interface driver cdc_wdm
usbcore: registered new interface driver usbtmc
usbcore: registered new interface driver uas
usbcore: registered new interface driver usb-storage
usbcore: registered new interface driver ums-alauda
usbcore: registered new interface driver ums-cypress
usbcore: registered new interface driver ums-datafab
usbcore: registered new interface driver ums_eneub6250
usbcore: registered new interface driver ums-freecom
usbcore: registered new interface driver ums-isd200
usbcore: registered new interface driver ums-jumpshot
usbcore: registered new interface driver ums-karma
usbcore: registered new interface driver ums-onetouch
usbcore: registered new interface driver ums-realtek
usbcore: registered new interface driver ums-sddr09
usbcore: registered new interface driver ums-sddr55
usbcore: registered new interface driver ums-usbat
usbcore: registered new interface driver mdc800
mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
usbcore: registered new interface driver microtekX6
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial support registered for generic
usbcore: registered new interface driver aircable
usbserial: USB Serial support registered for aircable
usbcore: registered new interface driver ark3116
usbserial: USB Serial support registered for ark3116
usbcore: registered new interface driver belkin_sa
usbserial: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
usbcore: registered new interface driver ch341
usbserial: USB Serial support registered for ch341-uart
usbcore: registered new interface driver cp210x
usbserial: USB Serial support registered for cp210x
usbcore: registered new interface driver cyberjack
usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card reader
usbcore: registered new interface driver cypress_m8
usbserial: USB Serial support registered for DeLorme Earthmate USB
usbserial: USB Serial support registered for HID->COM RS232 Adapter
usbserial: USB Serial support registered for Nokia CA-42 V2 Adapter
usbcore: registered new interface driver usb_debug
usbserial: USB Serial support registered for debug
usbserial: USB Serial support registered for xhci_dbc
usbcore: registered new interface driver digi_acceleport
usbserial: USB Serial support registered for Digi 2 port USB adapter
usbserial: USB Serial support registered for Digi 4 port USB adapter
usbcore: registered new interface driver io_edgeport
usbserial: USB Serial support registered for Edgeport 2 port adapter
usbserial: USB Serial support registered for Edgeport 4 port adapter
usbserial: USB Serial support registered for Edgeport 8 port adapter
usbserial: USB Serial support registered for EPiC device
usbcore: registered new interface driver io_ti
usbserial: USB Serial support registered for Edgeport TI 1 port adapter
usbserial: USB Serial support registered for Edgeport TI 2 port adapter
usbcore: registered new interface driver empeg
usbserial: USB Serial support registered for empeg
usbcore: registered new interface driver f81534a_ctrl
usbcore: registered new interface driver f81232
usbserial: USB Serial support registered for f81232
usbserial: USB Serial support registered for f81534a
usbcore: registered new interface driver f81534
usbserial: USB Serial support registered for Fintek F81532/F81534
usbcore: registered new interface driver ftdi_sio
usbserial: USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver garmin_gps
usbserial: USB Serial support registered for Garmin GPS usb/tty
usbcore: registered new interface driver ipaq
usbserial: USB Serial support registered for PocketPC PDA
usbcore: registered new interface driver ipw
usbserial: USB Serial support registered for IPWireless converter
usbcore: registered new interface driver ir_usb
usbserial: USB Serial support registered for IR Dongle
usbcore: registered new interface driver iuu_phoenix
usbserial: USB Serial support registered for iuu_phoenix
usbcore: registered new interface driver keyspan
usbserial: USB Serial support registered for Keyspan - (without firmware)
usbserial: USB Serial support registered for Keyspan 1 port adapter
usbserial: USB Serial support registered for Keyspan 2 port adapter
usbserial: USB Serial support registered for Keyspan 4 port adapter
usbcore: registered new interface driver keyspan_pda
usbserial: USB Serial support registered for Keyspan PDA
usbserial: USB Serial support registered for Keyspan PDA - (prerenumeration)
usbcore: registered new interface driver kl5kusb105
usbserial: USB Serial support registered for KL5KUSB105D / PalmConnect
usbcore: registered new interface driver kobil_sct
usbserial: USB Serial support registered for KOBIL USB smart card terminal
usbcore: registered new interface driver mct_u232
usbserial: USB Serial support registered for MCT U232
usbcore: registered new interface driver metro_usb
usbserial: USB Serial support registered for Metrologic USB to Serial
usbcore: registered new interface driver mos7720
usbserial: USB Serial support registered for Moschip 2 port adapter
usbcore: registered new interface driver mos7840
usbserial: USB Serial support registered for Moschip 7840/7820 USB Serial Driver
usbcore: registered new interface driver mxuport
usbserial: USB Serial support registered for MOXA UPort
usbcore: registered new interface driver navman
usbserial: USB Serial support registered for navman
usbcore: registered new interface driver omninet
usbserial: USB Serial support registered for ZyXEL - omni.net usb
usbcore: registered new interface driver opticon
usbserial: USB Serial support registered for opticon
usbcore: registered new interface driver option
usbserial: USB Serial support registered for GSM modem (1-port)
usbcore: registered new interface driver oti6858
usbserial: USB Serial support registered for oti6858
usbcore: registered new interface driver pl2303
usbserial: USB Serial support registered for pl2303
usbcore: registered new interface driver qcaux
usbserial: USB Serial support registered for qcaux
usbcore: registered new interface driver qcserial
usbserial: USB Serial support registered for Qualcomm USB modem
usbcore: registered new interface driver quatech2
usbserial: USB Serial support registered for Quatech 2nd gen USB to Serial Driver
usbcore: registered new interface driver safe_serial
usbserial: USB Serial support registered for safe_serial
usbcore: registered new interface driver sierra
usbserial: USB Serial support registered for Sierra USB modem
usbcore: registered new interface driver usb_serial_simple
usbserial: USB Serial support registered for carelink
usbserial: USB Serial support registered for zio
usbserial: USB Serial support registered for funsoft
usbserial: USB Serial support registered for flashloader
usbserial: USB Serial support registered for google
usbserial: USB Serial support registered for libtransistor
usbserial: USB Serial support registered for vivopay
usbserial: USB Serial support registered for moto_modem
usbserial: USB Serial support registered for motorola_tetra
usbserial: USB Serial support registered for novatel_gps
usbserial: USB Serial support registered for hp4x
usbserial: USB Serial support registered for suunto
usbserial: USB Serial support registered for siemens_mpi
usbcore: registered new interface driver spcp8x5
usbserial: USB Serial support registered for SPCP8x5
usbcore: registered new interface driver ssu100
usbserial: USB Serial support registered for Quatech SSU-100 USB to Serial Driver
usbcore: registered new interface driver symbolserial
usbserial: USB Serial support registered for symbol
usbcore: registered new interface driver ti_usb_3410_5052
usbserial: USB Serial support registered for TI USB 3410 1 port adapter
usbserial: USB Serial support registered for TI USB 5052 2 port adapter
usbcore: registered new interface driver upd78f0730
usbserial: USB Serial support registered for upd78f0730
usbcore: registered new interface driver visor
usbserial: USB Serial support registered for Handspring Visor / Palm OS
usbserial: USB Serial support registered for Sony Clie 5.0
usbserial: USB Serial support registered for Sony Clie 3.5
usbcore: registered new interface driver wishbone_serial
usbserial: USB Serial support registered for wishbone_serial
usbcore: registered new interface driver whiteheat
usbserial: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
usbserial: USB Serial support registered for Connect Tech - WhiteHEAT
usbcore: registered new interface driver xr_serial
usbserial: USB Serial support registered for xr_serial
usbcore: registered new interface driver xsens_mt
usbserial: USB Serial support registered for xsens_mt
usbcore: registered new interface driver adutux
usbcore: registered new interface driver appledisplay
usbcore: registered new interface driver cypress_cy7c63
usbcore: registered new interface driver cytherm
usbcore: registered new interface driver emi26 - firmware loader
usbcore: registered new interface driver emi62 - firmware loader
ftdi_elan: driver ftdi-elan
usbcore: registered new interface driver ftdi-elan
usbcore: registered new interface driver idmouse
usbcore: registered new interface driver iowarrior
usbcore: registered new interface driver isight_firmware
usbcore: registered new interface driver usblcd
usbcore: registered new interface driver ldusb
usbcore: registered new interface driver legousbtower
usbcore: registered new interface driver usbtest
usbcore: registered new interface driver usb_ehset_test
usbcore: registered new interface driver trancevibrator
usbcore: registered new interface driver uss720
uss720: USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
uss720: NOTE: this is a special purpose driver to allow nonstandard
uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
uss720: If you just want to connect to a printer, use usblp instead
usbcore: registered new interface driver usbsevseg
usbcore: registered new interface driver yurex
usbcore: registered new interface driver chaoskey
usbcore: registered new interface driver sisusb
usbcore: registered new interface driver lvs
usbcore: registered new interface driver cxacru
usbcore: registered new interface driver speedtch
usbcore: registered new interface driver ueagle-atm
xusbatm: malformed module parameters
dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.0: Dummy host controller
dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus number 1
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: Dummy host controller
usb usb1: Manufacturer: Linux 5.13.0-syzkaller dummy_hcd
usb usb1: SerialNumber: dummy_hcd.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 1 port detected
dummy_hcd dummy_hcd.1: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.1: Dummy host controller
dummy_hcd dummy_hcd.1: new USB bus registered, assigned bus number 2
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: Dummy host controller
usb usb2: Manufacturer: Linux 5.13.0-syzkaller dummy_hcd
usb usb2: SerialNumber: dummy_hcd.1
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 1 port detected
dummy_hcd dummy_hcd.2: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.2: Dummy host controller
dummy_hcd dummy_hcd.2: new USB bus registered, assigned bus number 3
usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: Dummy host controller
usb usb3: Manufacturer: Linux 5.13.0-syzkaller dummy_hcd
usb usb3: SerialNumber: dummy_hcd.2
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 1 port detected
dummy_hcd dummy_hcd.3: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.3: Dummy host controller
dummy_hcd dummy_hcd.3: new USB bus registered, assigned bus number 4
usb usb4: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: Dummy host controller
usb usb4: Manufacturer: Linux 5.13.0-syzkaller dummy_hcd
usb usb4: SerialNumber: dummy_hcd.3
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 1 port detected
dummy_hcd dummy_hcd.4: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.4: Dummy host controller
dummy_hcd dummy_hcd.4: new USB bus registered, assigned bus number 5
usb usb5: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: Dummy host controller
usb usb5: Manufacturer: Linux 5.13.0-syzkaller dummy_hcd
usb usb5: SerialNumber: dummy_hcd.4
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 1 port detected
dummy_hcd dummy_hcd.5: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.5: Dummy host controller
dummy_hcd dummy_hcd.5: new USB bus registered, assigned bus number 6
usb usb6: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: Dummy host controller
usb usb6: Manufacturer: Linux 5.13.0-syzkaller dummy_hcd
usb usb6: SerialNumber: dummy_hcd.5
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 1 port detected
dummy_hcd dummy_hcd.6: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.6: Dummy host controller
dummy_hcd dummy_hcd.6: new USB bus registered, assigned bus number 7
usb usb7: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: Dummy host controller
usb usb7: Manufacturer: Linux 5.13.0-syzkaller dummy_hcd
usb usb7: SerialNumber: dummy_hcd.6
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 1 port detected
dummy_hcd dummy_hcd.7: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.7: Dummy host controller
dummy_hcd dummy_hcd.7: new USB bus registered, assigned bus number 8
usb usb8: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: Dummy host controller
usb usb8: Manufacturer: Linux 5.13.0-syzkaller dummy_hcd
usb usb8: SerialNumber: dummy_hcd.7
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 1 port detected
gadgetfs: USB Gadget filesystem, version 24 Aug 2004
vhci_hcd vhci_hcd.0: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.0: new USB bus registered, assigned bus number 9
vhci_hcd: created sysfs vhci_hcd.0
usb usb9: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb9: Product: USB/IP Virtual Host Controller
usb usb9: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb9: SerialNumber: vhci_hcd.0
hub 9-0:1.0: USB hub found
hub 9-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.0: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.0: new USB bus registered, assigned bus number 10
usb usb10: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb10: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb10: Product: USB/IP Virtual Host Controller
usb usb10: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb10: SerialNumber: vhci_hcd.0
hub 10-0:1.0: USB hub found
hub 10-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.1: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.1: new USB bus registered, assigned bus number 11
usb usb11: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb11: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb11: Product: USB/IP Virtual Host Controller
usb usb11: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb11: SerialNumber: vhci_hcd.1
hub 11-0:1.0: USB hub found
hub 11-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.1: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.1: new USB bus registered, assigned bus number 12
usb usb12: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb12: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb12: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb12: Product: USB/IP Virtual Host Controller
usb usb12: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb12: SerialNumber: vhci_hcd.1
hub 12-0:1.0: USB hub found
hub 12-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.2: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.2: new USB bus registered, assigned bus number 13
usb usb13: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb13: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb13: Product: USB/IP Virtual Host Controller
usb usb13: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb13: SerialNumber: vhci_hcd.2
hub 13-0:1.0: USB hub found
hub 13-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.2: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.2: new USB bus registered, assigned bus number 14
usb usb14: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb14: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb14: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb14: Product: USB/IP Virtual Host Controller
usb usb14: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb14: SerialNumber: vhci_hcd.2
hub 14-0:1.0: USB hub found
hub 14-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.3: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.3: new USB bus registered, assigned bus number 15
usb usb15: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb15: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb15: Product: USB/IP Virtual Host Controller
usb usb15: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb15: SerialNumber: vhci_hcd.3
hub 15-0:1.0: USB hub found
hub 15-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.3: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.3: new USB bus registered, assigned bus number 16
usb usb16: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb16: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb16: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb16: Product: USB/IP Virtual Host Controller
usb usb16: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb16: SerialNumber: vhci_hcd.3
hub 16-0:1.0: USB hub found
hub 16-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.4: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.4: new USB bus registered, assigned bus number 17
usb usb17: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb17: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb17: Product: USB/IP Virtual Host Controller
usb usb17: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb17: SerialNumber: vhci_hcd.4
hub 17-0:1.0: USB hub found
hub 17-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.4: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.4: new USB bus registered, assigned bus number 18
usb usb18: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb18: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb18: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb18: Product: USB/IP Virtual Host Controller
usb usb18: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb18: SerialNumber: vhci_hcd.4
hub 18-0:1.0: USB hub found
hub 18-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.5: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.5: new USB bus registered, assigned bus number 19
usb usb19: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb19: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb19: Product: USB/IP Virtual Host Controller
usb usb19: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb19: SerialNumber: vhci_hcd.5
hub 19-0:1.0: USB hub found
hub 19-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.5: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.5: new USB bus registered, assigned bus number 20
usb usb20: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb20: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb20: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb20: Product: USB/IP Virtual Host Controller
usb usb20: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb20: SerialNumber: vhci_hcd.5
hub 20-0:1.0: USB hub found
hub 20-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.6: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.6: new USB bus registered, assigned bus number 21
usb usb21: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb21: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb21: Product: USB/IP Virtual Host Controller
usb usb21: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb21: SerialNumber: vhci_hcd.6
hub 21-0:1.0: USB hub found
hub 21-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.6: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.6: new USB bus registered, assigned bus number 22
usb usb22: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb22: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb22: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb22: Product: USB/IP Virtual Host Controller
usb usb22: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb22: SerialNumber: vhci_hcd.6
hub 22-0:1.0: USB hub found
hub 22-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.7: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.7: new USB bus registered, assigned bus number 23
usb usb23: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb23: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb23: Product: USB/IP Virtual Host Controller
usb usb23: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb23: SerialNumber: vhci_hcd.7
hub 23-0:1.0: USB hub found
hub 23-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.7: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.7: new USB bus registered, assigned bus number 24
usb usb24: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb24: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb24: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb24: Product: USB/IP Virtual Host Controller
usb usb24: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb24: SerialNumber: vhci_hcd.7
hub 24-0:1.0: USB hub found
hub 24-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.8: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.8: new USB bus registered, assigned bus number 25
usb usb25: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb25: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb25: Product: USB/IP Virtual Host Controller
usb usb25: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb25: SerialNumber: vhci_hcd.8
hub 25-0:1.0: USB hub found
hub 25-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.8: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.8: new USB bus registered, assigned bus number 26
usb usb26: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb26: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb26: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb26: Product: USB/IP Virtual Host Controller
usb usb26: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb26: SerialNumber: vhci_hcd.8
hub 26-0:1.0: USB hub found
hub 26-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.9: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.9: new USB bus registered, assigned bus number 27
usb usb27: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb27: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb27: Product: USB/IP Virtual Host Controller
usb usb27: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb27: SerialNumber: vhci_hcd.9
hub 27-0:1.0: USB hub found
hub 27-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.9: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.9: new USB bus registered, assigned bus number 28
usb usb28: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb28: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb28: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb28: Product: USB/IP Virtual Host Controller
usb usb28: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb28: SerialNumber: vhci_hcd.9
hub 28-0:1.0: USB hub found
hub 28-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.10: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.10: new USB bus registered, assigned bus number 29
usb usb29: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb29: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb29: Product: USB/IP Virtual Host Controller
usb usb29: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb29: SerialNumber: vhci_hcd.10
hub 29-0:1.0: USB hub found
hub 29-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.10: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.10: new USB bus registered, assigned bus number 30
usb usb30: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb30: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb30: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb30: Product: USB/IP Virtual Host Controller
usb usb30: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb30: SerialNumber: vhci_hcd.10
hub 30-0:1.0: USB hub found
hub 30-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.11: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.11: new USB bus registered, assigned bus number 31
usb usb31: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb31: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb31: Product: USB/IP Virtual Host Controller
usb usb31: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb31: SerialNumber: vhci_hcd.11
hub 31-0:1.0: USB hub found
hub 31-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.11: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.11: new USB bus registered, assigned bus number 32
usb usb32: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb32: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb32: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb32: Product: USB/IP Virtual Host Controller
usb usb32: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb32: SerialNumber: vhci_hcd.11
hub 32-0:1.0: USB hub found
hub 32-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.12: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.12: new USB bus registered, assigned bus number 33
usb usb33: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb33: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb33: Product: USB/IP Virtual Host Controller
usb usb33: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb33: SerialNumber: vhci_hcd.12
hub 33-0:1.0: USB hub found
hub 33-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.12: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.12: new USB bus registered, assigned bus number 34
usb usb34: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb34: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb34: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb34: Product: USB/IP Virtual Host Controller
usb usb34: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb34: SerialNumber: vhci_hcd.12
hub 34-0:1.0: USB hub found
hub 34-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.13: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.13: new USB bus registered, assigned bus number 35
usb usb35: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb35: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb35: Product: USB/IP Virtual Host Controller
usb usb35: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb35: SerialNumber: vhci_hcd.13
hub 35-0:1.0: USB hub found
hub 35-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.13: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.13: new USB bus registered, assigned bus number 36
usb usb36: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb36: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb36: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb36: Product: USB/IP Virtual Host Controller
usb usb36: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb36: SerialNumber: vhci_hcd.13
hub 36-0:1.0: USB hub found
hub 36-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.14: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.14: new USB bus registered, assigned bus number 37
usb usb37: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb37: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb37: Product: USB/IP Virtual Host Controller
usb usb37: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb37: SerialNumber: vhci_hcd.14
hub 37-0:1.0: USB hub found
hub 37-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.14: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.14: new USB bus registered, assigned bus number 38
usb usb38: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb38: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb38: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb38: Product: USB/IP Virtual Host Controller
usb usb38: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb38: SerialNumber: vhci_hcd.14
hub 38-0:1.0: USB hub found
hub 38-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.15: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.15: new USB bus registered, assigned bus number 39
usb usb39: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.13
usb usb39: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb39: Product: USB/IP Virtual Host Controller
usb usb39: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb39: SerialNumber: vhci_hcd.15
hub 39-0:1.0: USB hub found
hub 39-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.15: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.15: new USB bus registered, assigned bus number 40
usb usb40: We don't know the algorithms for LPM for this host, disabling LPM.
usb usb40: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.13
usb usb40: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb40: Product: USB/IP Virtual Host Controller
usb usb40: Manufacturer: Linux 5.13.0-syzkaller vhci_hcd
usb usb40: SerialNumber: vhci_hcd.15
hub 40-0:1.0: USB hub found
hub 40-0:1.0: 8 ports detected
usbcore: registered new device driver usbip-host
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
i8042: Warning: Keylock active
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
usbcore: registered new interface driver appletouch
usbcore: registered new interface driver bcm5974
usbcore: registered new interface driver synaptics_usb
usbcore: registered new interface driver iforce
usbcore: registered new interface driver xpad
usbcore: registered new interface driver usb_acecad
usbcore: registered new interface driver aiptek
usbcore: registered new interface driver hanwang
usbcore: registered new interface driver kbtab
usbcore: registered new interface driver pegasus_notetaker
usbcore: registered new interface driver usbtouchscreen
usbcore: registered new interface driver sur40
usbcore: registered new interface driver ati_remote2
cm109: Keymap for Komunikate KIP1000 phone loaded
usbcore: registered new interface driver cm109
cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
usbcore: registered new interface driver ims_pcu
usbcore: registered new interface driver keyspan_remote
usbcore: registered new interface driver powermate
usbcore: registered new interface driver yealink
rtc_cmos 00:00: RTC can wake from S4
rtc_cmos 00:00: registered as rtc0
rtc_cmos 00:00: alarms up to one day, 114 bytes nvram
i2c /dev entries driver
usbcore: registered new interface driver i2c-diolan-u2c
usbcore: registered new interface driver RobotFuzz Open Source InterFace, OSIF
usbcore: registered new interface driver i2c-tiny-usb
usbcore: registered new interface driver ati_remote
usbcore: registered new interface driver imon
usbcore: registered new interface driver mceusb
usbcore: registered new interface driver redrat3
usbcore: registered new interface driver streamzap
usbcore: registered new interface driver igorplugusb
usbcore: registered new interface driver iguanair
usbcore: registered new interface driver ttusbir
b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded successfully
usbcore: registered new interface driver ttusb-dec
usbcore: registered new interface driver ttusb
usbcore: registered new interface driver dvb_usb_vp7045
usbcore: registered new interface driver dvb_usb_vp702x
usbcore: registered new interface driver dvb_usb_gp8psk
usbcore: registered new interface driver dvb_usb_dtt200u
usbcore: registered new interface driver dvb_usb_a800
usbcore: registered new interface driver dvb_usb_dibusb_mb
usbcore: registered new interface driver dvb_usb_dibusb_mc
usbcore: registered new interface driver dvb_usb_nova_t_usb2
usbcore: registered new interface driver dvb_usb_umt_010
usbcore: registered new interface driver dvb_usb_m920x
usbcore: registered new interface driver dvb_usb_digitv
usbcore: registered new interface driver dvb_usb_cxusb
usbcore: registered new interface driver dvb_usb_ttusb2
usbcore: registered new interface driver dvb_usb_dib0700
usbcore: registered new interface driver opera1
usbcore: registered new interface driver dvb_usb_af9005
usbcore: registered new interface driver pctv452e
usbcore: registered new interface driver dw2102
usbcore: registered new interface driver dvb_usb_dtv5100
usbcore: registered new interface driver cinergyT2
usbcore: registered new interface driver dvb_usb_az6027
usbcore: registered new interface driver dvb_usb_technisat_usb2
usbcore: registered new interface driver dvb_usb_af9015
usbcore: registered new interface driver dvb_usb_af9035
usbcore: registered new interface driver dvb_usb_anysee
usbcore: registered new interface driver dvb_usb_au6610
usbcore: registered new interface driver dvb_usb_az6007
usbcore: registered new interface driver dvb_usb_ce6230
usbcore: registered new interface driver dvb_usb_ec168
usbcore: registered new interface driver dvb_usb_lmedm04
usbcore: registered new interface driver dvb_usb_gl861
usbcore: registered new interface driver dvb_usb_mxl111sf
usbcore: registered new interface driver dvb_usb_rtl28xxu
usbcore: registered new interface driver dvb_usb_dvbsky
usbcore: registered new interface driver zd1301
usbcore: registered new interface driver smsusb
usbcore: registered new interface driver b2c2_flexcop_usb
usbcore: registered new interface driver zr364xx
usbcore: registered new interface driver stkwebcam
usbcore: registered new interface driver s2255
usbcore: registered new interface driver uvcvideo
gspca_main: v2.14.0 registered
usbcore: registered new interface driver benq
usbcore: registered new interface driver conex
usbcore: registered new interface driver cpia1
usbcore: registered new interface driver dtcs033
usbcore: registered new interface driver etoms
usbcore: registered new interface driver finepix
usbcore: registered new interface driver jeilinj
usbcore: registered new interface driver jl2005bcd
usbcore: registered new interface driver kinect
usbcore: registered new interface driver konica
usbcore: registered new interface driver mars
usbcore: registered new interface driver mr97310a
usbcore: registered new interface driver nw80x
usbcore: registered new interface driver ov519
usbcore: registered new interface driver ov534
usbcore: registered new interface driver ov534_9
usbcore: registered new interface driver pac207
usbcore: registered new interface driver gspca_pac7302
usbcore: registered new interface driver pac7311
usbcore: registered new interface driver se401
usbcore: registered new interface driver sn9c2028
usbcore: registered new interface driver gspca_sn9c20x
usbcore: registered new interface driver sonixb
usbcore: registered new interface driver sonixj
usbcore: registered new interface driver spca500
usbcore: registered new interface driver spca501
usbcore: registered new interface driver spca505
usbcore: registered new interface driver spca506
usbcore: registered new interface driver spca508
usbcore: registered new interface driver spca561
usbcore: registered new interface driver spca1528
usbcore: registered new interface driver sq905
usbcore: registered new interface driver sq905c
usbcore: registered new interface driver sq930x
usbcore: registered new interface driver sunplus
usbcore: registered new interface driver stk014
usbcore: registered new interface driver stk1135
usbcore: registered new interface driver stv0680
usbcore: registered new interface driver t613
usbcore: registered new interface driver gspca_topro
usbcore: registered new interface driver touptek
usbcore: registered new interface driver tv8532
usbcore: registered new interface driver vc032x
usbcore: registered new interface driver vicam
usbcore: registered new interface driver xirlink-cit
usbcore: registered new interface driver gspca_zc3xx
usbcore: registered new interface driver ALi m5602
usbcore: registered new interface driver STV06xx
usbcore: registered new interface driver gspca_gl860
usbcore: registered new interface driver Philips webcam
usbcore: registered new interface driver airspy
usbcore: registered new interface driver hackrf
usbcore: registered new interface driver msi2500
cpia2: V4L-Driver for Vision CPiA2 based cameras v3.0.1
usbcore: registered new interface driver cpia2
au0828: au0828 driver loaded
usbcore: registered new interface driver au0828
usbcore: registered new interface driver hdpvr
usbcore: registered new interface driver pvrusb2
pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner
pvrusb2: Debug mask is 31 (0x1f)
usbcore: registered new interface driver stk1160
usbcore: registered new interface driver cx231xx
usbcore: registered new interface driver tm6000
usbcore: registered new interface driver em28xx
em28xx: Registered (Em28xx v4l2 Extension) extension
em28xx: Registered (Em28xx Audio Extension) extension
em28xx: Registered (Em28xx dvb Extension) extension
em28xx: Registered (Em28xx Input Extension) extension
usbcore: registered new interface driver usbtv
usbcore: registered new interface driver go7007
usbcore: registered new interface driver go7007-loader
usbcore: registered new interface driver Abilis Systems as10x usb driver
vivid-000: using single planar format API
vivid-000: CEC adapter cec0 registered for HDMI input 0
vivid-000: V4L2 capture device registered as video3
vivid-000: CEC adapter cec1 registered for HDMI output 0
vivid-000: V4L2 output device registered as video4
vivid-000: V4L2 capture device registered as vbi0, supports raw and sliced VBI
vivid-000: V4L2 output device registered as vbi1, supports raw and sliced VBI
vivid-000: V4L2 capture device registered as swradio0
vivid-000: V4L2 receiver device registered as radio0
vivid-000: V4L2 transmitter device registered as radio1
vivid-000: V4L2 metadata capture device registered as video5
vivid-000: V4L2 metadata output device registered as video6
vivid-000: V4L2 touch capture device registered as v4l-touch0
vivid-001: using multiplanar format API
vivid-001: CEC adapter cec2 registered for HDMI input 0
vivid-001: V4L2 capture device registered as video7
vivid-001: CEC adapter cec3 registered for HDMI output 0
vivid-001: V4L2 output device registered as video8
vivid-001: V4L2 capture device registered as vbi2, supports raw and sliced VBI
vivid-001: V4L2 output device registered as vbi3, supports raw and sliced VBI
vivid-001: V4L2 capture device registered as swradio1
vivid-001: V4L2 receiver device registered as radio2
vivid-001: V4L2 transmitter device registered as radio3
vivid-001: V4L2 metadata capture device registered as video9
vivid-001: V4L2 metadata output device registered as video10
vivid-001: V4L2 touch capture device registered as v4l-touch1
vivid-002: using single planar format API
vivid-002: CEC adapter cec4 registered for HDMI input 0
vivid-002: V4L2 capture device registered as video11
vivid-002: CEC adapter cec5 registered for HDMI output 0
vivid-002: V4L2 output device registered as video12
vivid-002: V4L2 capture device registered as vbi4, supports raw and sliced VBI
vivid-002: V4L2 output device registered as vbi5, supports raw and sliced VBI
vivid-002: V4L2 capture device registered as swradio2
vivid-002: V4L2 receiver device registered as radio4
vivid-002: V4L2 transmitter device registered as radio5
vivid-002: V4L2 metadata capture device registered as video13
vivid-002: V4L2 metadata output device registered as video14
vivid-002: V4L2 touch capture device registered as v4l-touch2
vivid-003: using multiplanar format API
vivid-003: CEC adapter cec6 registered for HDMI input 0
vivid-003: V4L2 capture device registered as video15
vivid-003: CEC adapter cec7 registered for HDMI output 0
vivid-003: V4L2 output device registered as video16
vivid-003: V4L2 capture device registered as vbi6, supports raw and sliced VBI
vivid-003: V4L2 output device registered as vbi7, supports raw and sliced VBI
vivid-003: V4L2 capture device registered as swradio3
vivid-003: V4L2 receiver device registered as radio6
vivid-003: V4L2 transmitter device registered as radio7
vivid-003: V4L2 metadata capture device registered as video17
vivid-003: V4L2 metadata output device registered as video18
vivid-003: V4L2 touch capture device registered as v4l-touch3
vivid-004: using single planar format API
vivid-004: CEC adapter cec8 registered for HDMI input 0
vivid-004: V4L2 capture device registered as video19
vivid-004: CEC adapter cec9 registered for HDMI output 0
vivid-004: V4L2 output device registered as video20
vivid-004: V4L2 capture device registered as vbi8, supports raw and sliced VBI
vivid-004: V4L2 output device registered as vbi9, supports raw and sliced VBI
vivid-004: V4L2 capture device registered as swradio4
vivid-004: V4L2 receiver device registered as radio8
vivid-004: V4L2 transmitter device registered as radio9
vivid-004: V4L2 metadata capture device registered as video21
vivid-004: V4L2 metadata output device registered as video22
vivid-004: V4L2 touch capture device registered as v4l-touch4
vivid-005: using multiplanar format API
vivid-005: CEC adapter cec10 registered for HDMI input 0
vivid-005: V4L2 capture device registered as video23
vivid-005: CEC adapter cec11 registered for HDMI output 0
vivid-005: V4L2 output device registered as video24
vivid-005: V4L2 capture device registered as vbi10, supports raw and sliced VBI
vivid-005: V4L2 output device registered as vbi11, supports raw and sliced VBI
vivid-005: V4L2 capture device registered as swradio5
vivid-005: V4L2 receiver device registered as radio10
vivid-005: V4L2 transmitter device registered as radio11
vivid-005: V4L2 metadata capture device registered as video25
vivid-005: V4L2 metadata output device registered as video26
vivid-005: V4L2 touch capture device registered as v4l-touch5
vivid-006: using single planar format API
vivid-006: CEC adapter cec12 registered for HDMI input 0
vivid-006: V4L2 capture device registered as video27
vivid-006: CEC adapter cec13 registered for HDMI output 0
vivid-006: V4L2 output device registered as video28
vivid-006: V4L2 capture device registered as vbi12, supports raw and sliced VBI
vivid-006: V4L2 output device registered as vbi13, supports raw and sliced VBI
vivid-006: V4L2 capture device registered as swradio6
vivid-006: V4L2 receiver device registered as radio12
vivid-006: V4L2 transmitter device registered as radio13
vivid-006: V4L2 metadata capture device registered as video29
vivid-006: V4L2 metadata output device registered as video30
vivid-006: V4L2 touch capture device registered as v4l-touch6
vivid-007: using multiplanar format API
vivid-007: CEC adapter cec14 registered for HDMI input 0
vivid-007: V4L2 capture device registered as video31
vivid-007: CEC adapter cec15 registered for HDMI output 0
vivid-007: V4L2 output device registered as video32
vivid-007: V4L2 capture device registered as vbi14, supports raw and sliced VBI
vivid-007: V4L2 output device registered as vbi15, supports raw and sliced VBI
vivid-007: V4L2 capture device registered as swradio7
vivid-007: V4L2 receiver device registered as radio14
vivid-007: V4L2 transmitter device registered as radio15
vivid-007: V4L2 metadata capture device registered as video33
vivid-007: V4L2 metadata output device registered as video34
vivid-007: V4L2 touch capture device registered as v4l-touch7
vivid-008: using single planar format API
vivid-008: CEC adapter cec16 registered for HDMI input 0
vivid-008: V4L2 capture device registered as video35
vivid-008: CEC adapter cec17 registered for HDMI output 0
vivid-008: V4L2 output device registered as video36
vivid-008: V4L2 capture device registered as vbi16, supports raw and sliced VBI
vivid-008: V4L2 output device registered as vbi17, supports raw and sliced VBI
vivid-008: V4L2 capture device registered as swradio8
vivid-008: V4L2 receiver device registered as radio16
vivid-008: V4L2 transmitter device registered as radio17
vivid-008: V4L2 metadata capture device registered as video37
vivid-008: V4L2 metadata output device registered as video38
vivid-008: V4L2 touch capture device registered as v4l-touch8
vivid-009: using multiplanar format API
vivid-009: CEC adapter cec18 registered for HDMI input 0
vivid-009: V4L2 capture device registered as video39
vivid-009: CEC adapter cec19 registered for HDMI output 0
vivid-009: V4L2 output device registered as video40
vivid-009: V4L2 capture device registered as vbi18, supports raw and sliced VBI
vivid-009: V4L2 output device registered as vbi19, supports raw and sliced VBI
vivid-009: V4L2 capture device registered as swradio9
vivid-009: V4L2 receiver device registered as radio18
vivid-009: V4L2 transmitter device registered as radio19
vivid-009: V4L2 metadata capture device registered as video41
vivid-009: V4L2 metadata output device registered as video42
vivid-009: V4L2 touch capture device registered as v4l-touch9
vivid-010: using single planar format API
vivid-010: CEC adapter cec20 registered for HDMI input 0
vivid-010: V4L2 capture device registered as video43
vivid-010: CEC adapter cec21 registered for HDMI output 0
vivid-010: V4L2 output device registered as video44
vivid-010: V4L2 capture device registered as vbi20, supports raw and sliced VBI
vivid-010: V4L2 output device registered as vbi21, supports raw and sliced VBI
vivid-010: V4L2 capture device registered as swradio10
vivid-010: V4L2 receiver device registered as radio20
vivid-010: V4L2 transmitter device registered as radio21
vivid-010: V4L2 metadata capture device registered as video45
vivid-010: V4L2 metadata output device registered as video46
vivid-010: V4L2 touch capture device registered as v4l-touch10
vivid-011: using multiplanar format API
vivid-011: CEC adapter cec22 registered for HDMI input 0
vivid-011: V4L2 capture device registered as video47
vivid-011: CEC adapter cec23 registered for HDMI output 0
vivid-011: V4L2 output device registered as video48
vivid-011: V4L2 capture device registered as vbi22, supports raw and sliced VBI
vivid-011: V4L2 output device registered as vbi23, supports raw and sliced VBI
vivid-011: V4L2 capture device registered as swradio11
vivid-011: V4L2 receiver device registered as radio22
vivid-011: V4L2 transmitter device registered as radio23
vivid-011: V4L2 metadata capture device registered as video49
vivid-011: V4L2 metadata output device registered as video50
vivid-011: V4L2 touch capture device registered as v4l-touch11
vivid-012: using single planar format API
vivid-012: CEC adapter cec24 registered for HDMI input 0
vivid-012: V4L2 capture device registered as video51
vivid-012: CEC adapter cec25 registered for HDMI output 0
vivid-012: V4L2 output device registered as video52
vivid-012: V4L2 capture device registered as vbi24, supports raw and sliced VBI
vivid-012: V4L2 output device registered as vbi25, supports raw and sliced VBI
vivid-012: V4L2 capture device registered as swradio12
vivid-012: V4L2 receiver device registered as radio24
vivid-012: V4L2 transmitter device registered as radio25
vivid-012: V4L2 metadata capture device registered as video53
vivid-012: V4L2 metadata output device registered as video54
vivid-012: V4L2 touch capture device registered as v4l-touch12
vivid-013: using multiplanar format API
vivid-013: CEC adapter cec26 registered for HDMI input 0
vivid-013: V4L2 capture device registered as video55
vivid-013: CEC adapter cec27 registered for HDMI output 0
vivid-013: V4L2 output device registered as video56
vivid-013: V4L2 capture device registered as vbi26, supports raw and sliced VBI
vivid-013: V4L2 output device registered as vbi27, supports raw and sliced VBI
vivid-013: V4L2 capture device registered as swradio13
vivid-013: V4L2 rec

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
