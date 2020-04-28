Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77281BB959
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 10:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgD1I5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 04:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726475AbgD1I5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 04:57:44 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52C5C03C1AD
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 01:57:43 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id q7so8895891qkf.3
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 01:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yl3axPvtXdAkXYNiqzMTKTSrkFNwk3aMYCMRlmIFyMA=;
        b=LaIrbDBDq700prgDFSB+7u1/YDKurjUzIkNvxXAuWinMfA4gxzCoeige/BZWRbupWT
         wDHT6tCbw3SrM/5EGdwoSz7T0U0NKmaYYuhYO56kP7fI35UMcoTHQ3Xcwm8MSASkey6A
         8JzkGA+PG8QcVChROoODU3pgUMwrdNli9KsZ5rDbLHV4QR7tIDvt4E6WCp5HDJ1glDVy
         upVcoJHkxwZU9ia9/d/qWxhbXjUoAUF20T2F4ynerCnIR36j2Y1FQbaSRJUHNeMgI3a7
         85JNVeuhnsOpkblIR63+7cSbtH9amXC6yHYMGoMwt0f5L240jjgox5ATuE9Ec8BcXjK0
         CUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yl3axPvtXdAkXYNiqzMTKTSrkFNwk3aMYCMRlmIFyMA=;
        b=PEjQk8SWMdp4XSuUQs4U88aVC3j1spNu1a8GpK9LQWhcNpSlXzJYRR+/hoIfMJP9/5
         xRWiY277KsBgg8x+YZNJZcfWqiR1Zcogs89na3MX5d0Qjs30U2DXBKJSi4qtRZSD1OoF
         EEder8Alwns6OqwHNpHdQmWQqYEtUdTdkKBtsPwsJm7EZHu9kMNC3CQse6ziwr+kGf8d
         SSvrWYZcRmb6XxQOt4Sp6G98ZfnJim7ZzNayy/YLp2SsyD8ByqFxMrH2z/hn6/wPbjIi
         hk1HAux/Ie3T1d30y3wEAM+IH66P+S7Q80wFXrCegQhkkxuTVDL9NmgiOTHM6ygmrGX7
         bLYA==
X-Gm-Message-State: AGi0PuaeUw045hrY+M5DbiKhucKv6rJZVV1iWj2KPt7PDG1OqzVNTWUE
        ET46x/vTLA6Kb+CH6iVt/NYY9CAPzN9alh6TU2ohyA==
X-Google-Smtp-Source: APiQypJLgZdz8Hk1kWc8ATBNJW/kENsf+J81bTwhUrVfiQEBdNU8CB2h2U57Q+uRbFGnire0FklfZYs82dZEG27+Nkk=
X-Received: by 2002:a05:620a:307:: with SMTP id s7mr23355364qkm.407.1588064261312;
 Tue, 28 Apr 2020 01:57:41 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000df9a9805a455e07b@google.com>
In-Reply-To: <000000000000df9a9805a455e07b@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 28 Apr 2020 10:57:29 +0200
Message-ID: <CACT4Y+YnjK+kq0pfb5fe-q1bqe2T1jq_mvKHf--Z80Z3wkyK1Q@mail.gmail.com>
Subject: Re: linux-next boot error: WARNING: suspicious RCU usage in ipmr_get_table
To:     syzbot <syzbot+1519f497f2f9f08183c6@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020, 10:47 syzbot
<syzbot+1519f497f2f9f08183c6@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    0fd02a5d Add linux-next specific files for 20200428
> git tree:       linux-next

+linux-next for boot breakage

> console output: https://syzkaller.appspot.com/x/log.txt?x=1696e5d8100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9748c3e397b4529
> dashboard link: https://syzkaller.appspot.com/bug?extid=1519f497f2f9f08183c6
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+1519f497f2f9f08183c6@syzkaller.appspotmail.com
>
> SCSI subsystem initialized
> ACPI: bus type USB registered
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> mc: Linux media interface: v0.10
> videodev: Linux video capture interface: v2.00
> pps_core: LinuxPPS API ver. 1 registered
> pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> PTP clock support registered
> EDAC MC: Ver: 3.0.0
> Advanced Linux Sound Architecture Driver Initialized.
> PCI: Using ACPI for IRQ routing
> Bluetooth: Core ver 2.22
> NET: Registered protocol family 31
> Bluetooth: HCI device and connection manager initialized
> Bluetooth: HCI socket layer initialized
> Bluetooth: L2CAP socket layer initialized
> Bluetooth: SCO socket layer initialized
> NET: Registered protocol family 8
> NET: Registered protocol family 20
> NetLabel: Initializing
> NetLabel:  domain hash size = 128
> NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
> NetLabel:  unlabeled traffic allowed by default
> nfc: nfc_init: NFC Core ver 0.1
> NET: Registered protocol family 39
> clocksource: Switched to clocksource kvm-clock
> VFS: Disk quotas dquot_6.6.0
> VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> FS-Cache: Loaded
> CacheFiles: Loaded
> TOMOYO: 2.6.0
> Mandatory Access Control activated.
> AppArmor: AppArmor Filesystem Enabled
> pnp: PnP ACPI init
> pnp: PnP ACPI: found 7 devices
> clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
> pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
> pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
> pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
> pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfffff window]
> NET: Registered protocol family 2
> tcp_listen_portaddr_hash hash table entries: 4096 (order: 6, 327680 bytes, vmalloc)
> TCP established hash table entries: 65536 (order: 7, 524288 bytes, vmalloc)
> TCP bind hash table entries: 65536 (order: 10, 4718592 bytes, vmalloc)
> TCP: Hash tables configured (established 65536 bind 65536)
> UDP hash table entries: 4096 (order: 7, 655360 bytes, vmalloc)
> UDP-Lite hash table entries: 4096 (order: 7, 655360 bytes, vmalloc)
> =============================
> WARNING: suspicious RCU usage
> 5.7.0-rc3-next-20200428-syzkaller #0 Not tainted
> -----------------------------
> net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by swapper/0/1:
>  #0: ffffffff8a5a6330 (pernet_ops_rwsem){+.+.}-{3:3}, at: register_pernet_subsys+0x16/0x40 net/core/net_namespace.c:1257
>
> stack backtrace:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.7.0-rc3-next-20200428-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  ipmr_get_table+0x130/0x160 net/ipv4/ipmr.c:136
>  ipmr_new_table net/ipv4/ipmr.c:403 [inline]
>  ipmr_rules_init net/ipv4/ipmr.c:248 [inline]
>  ipmr_net_init+0x133/0x430 net/ipv4/ipmr.c:3089
>  ops_init+0xaf/0x420 net/core/net_namespace.c:151
>  __register_pernet_operations net/core/net_namespace.c:1140 [inline]
>  register_pernet_operations+0x346/0x840 net/core/net_namespace.c:1217
>  register_pernet_subsys+0x25/0x40 net/core/net_namespace.c:1258
>  ip_mr_init+0x36/0x168 net/ipv4/ipmr.c:3140
>  inet_init+0x298/0x424 net/ipv4/af_inet.c:2005
>  do_one_initcall+0x10a/0x7d0 init/main.c:1159
>  do_initcall_level init/main.c:1232 [inline]
>  do_initcalls init/main.c:1248 [inline]
>  do_basic_setup init/main.c:1268 [inline]
>  kernel_init_freeable+0x501/0x5ae init/main.c:1454
>  kernel_init+0xd/0x1bb init/main.c:1359
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
> NET: Registered protocol family 1
> RPC: Registered named UNIX socket transport module.
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> NET: Registered protocol family 44
> pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> PCI: CLS 0 bytes, default 64
> PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> software IO TLB: mapped [mem 0xaa600000-0xae600000] (64MB)
> RAPL PMU: API unit is 2^-32 Joules, 0 fixed counters, 10737418240 ms ovfl timer
> kvm: already loaded the other module
> clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x212735223b2, max_idle_ns: 440795277976 ns
> clocksource: Switched to clocksource tsc
> mce: Machine check injector initialized
> check: Scanning for low memory corruption every 60 seconds
> Initialise system trusted keyrings
> workingset: timestamp_bits=40 max_order=21 bucket_order=0
> zbud: loaded
> DLM installed
> squashfs: version 4.0 (2009/01/31) Phillip Lougher
> FS-Cache: Netfs 'nfs' registered for caching
> NFS: Registering the id_resolver key type
> Key type id_resolver registered
> Key type id_legacy registered
> nfs4filelayout_init: NFSv4 File Layout Driver Registering...
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> FS-Cache: Netfs 'cifs' registered for caching
> Key type cifs.spnego registered
> Key type cifs.idmap registered
> ntfs: driver 2.1.32 [Flags: R/W].
> fuse: init (API version 7.31)
> JFS: nTxBlock = 8192, nTxLock = 65536
> SGI XFS with ACLs, security attributes, realtime, quota, no debug enabled
> 9p: Installing v9fs 9p2000 file system support
> FS-Cache: Netfs '9p' registered for caching
> ocfs2: Registered cluster interface o2cb
> ocfs2: Registered cluster interface user
> OCFS2 User DLM kernel interface loaded
> gfs2: GFS2 installed
> FS-Cache: Netfs 'ceph' registered for caching
> ceph: loaded (mds proto 32)
> NET: Registered protocol family 38
> async_tx: api initialized (async)
> Key type asymmetric registered
> Asymmetric key parser 'x509' registered
> Asymmetric key parser 'pkcs8' registered
> Key type pkcs7_test registered
> Asymmetric key parser 'tpm_parser' registered
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 243)
> io scheduler mq-deadline registered
> io scheduler kyber registered
> io scheduler bfq registered
> hgafb: HGA card not detected.
> hgafb: probe of hgafb.0 failed with error -22
> usbcore: registered new interface driver udlfb
> uvesafb: failed to execute /sbin/v86d
> uvesafb: make sure that the v86d helper is installed and executable
> uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
> uvesafb: vbe_init() failed with -22
> uvesafb: probe of uvesafb.0 failed with error -22
> vga16fb: mapped to 0x000000002f252cfb
> Console: switching to colour frame buffer device 80x30
> fb0: VGA16 VGA frame buffer device
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> ACPI: Power Button [PWRF]
> input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
> ACPI: Sleep Button [SLPF]
> ioatdma: Intel(R) QuickData Technology Driver 5.00
> PCI Interrupt Link [LNKC] enabled at IRQ 11
> virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
> PCI Interrupt Link [LNKD] enabled at IRQ 10
> virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
> PCI Interrupt Link [LNKA] enabled at IRQ 10
> virtio-pci 0000:00:05.0: virtio_pci: leaving for legacy driver
> N_HDLC line discipline registered with maxframe=4096
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
> 00:05: ttyS2 at I/O 0x3e8 (irq = 6, base_baud = 115200) is a 16550A
> 00:06: ttyS3 at I/O 0x2e8 (irq = 7, base_baud = 115200) is a 16550A
> Cyclades driver 2.6
> Initializing Nozomi driver 2.1d
> RocketPort device driver module, version 2.09, 12-June-2003
> No rocketport ports found; unloading driver
> Non-volatile memory driver v1.3
> Linux agpgart interface v0.103
> [drm] Initialized vgem 1.0.0 20120112 for vgem on minor 0
> [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [drm] Initialized vkms 1.0.0 20180514 for vkms on minor 1
> usbcore: registered new interface driver udl
> brd: module loaded
> loop: module loaded
> zram: Added device: zram0
> null_blk: module loaded
> nfcsim 0.2 initialized
> Loading iSCSI transport class v2.0-870.
> scsi host0: Virtio SCSI HBA
> st: Version 20160209, fixed bufsize 32768, s/g segs 256
> slram: not enough parameters.
> ftl_cs: FTL header not found.
> wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
> wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
> MACsec IEEE 802.1AE
> tun: Universal TUN/TAP device driver, 1.6
> vcan: Virtual CAN interface driver
> vxcan: Virtual CAN Tunnel driver
> slcan: serial line CAN interface driver
> slcan: 10 dynamic interface channels.
> CAN device driver interface
> e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> e100: Copyright(c) 1999-2006 Intel Corporation
> e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
> e1000: Copyright (c) 1999-2006 Intel Corporation.
> e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
> e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> mkiss: AX.25 Multikiss, Hans Albas PE1AYX
> AX.25: 6pack driver, Revision: 0.3.0
> AX.25: bpqether driver version 004
> PPP generic driver version 2.4.2
> PPP BSD Compression module registered
> PPP Deflate Compression module registered
> PPP MPPE Compression module registered
> NET: Registered protocol family 24
> PPTP driver version 0.8.5
> SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
> CSLIP: code copyright 1989 Regents of the University of California.
> SLIP linefill/keepalive option.
> hdlc: HDLC support module revision 1.22
> x25_asy: X.25 async: version 0.00 ALPHA (dynamic channels, max=256)
> DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
> LAPB Ethernet driver version 0.02
> usbcore: registered new interface driver rndis_wlan
> mac80211_hwsim: initializing netlink
> fakelb driver is marked as deprecated, please use mac802154_hwsim!
> ieee802154fakelb ieee802154fakelb: added 2 fake ieee802154 hardware devices
> mac802154_hwsim mac802154_hwsim: Added 2 mac802154 hwsim hardware radios
> VMware vmxnet3 virtual NIC driver - version 1.4.17.0-k-NAPI
> pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
> usbcore: registered new interface driver pegasus
> usbcore: registered new interface driver rtl8150
> usbcore: registered new interface driver r8152
> usbcore: registered new interface driver asix
> usbcore: registered new interface driver ax88179_178a
> usbcore: registered new interface driver cdc_ether
> usbcore: registered new interface driver dm9601
> usbcore: registered new interface driver smsc75xx
> usbcore: registered new interface driver smsc95xx
> usbcore: registered new interface driver net1080
> usbcore: registered new interface driver rndis_host
> usbcore: registered new interface driver cdc_subset
> usbcore: registered new interface driver zaurus
> usbcore: registered new interface driver MOSCHIP usb-ethernet driver
> usbcore: registered new interface driver cdc_ncm
> usbcore: registered new interface driver cdc_mbim
> VFIO - User Level meta-driver version: 0.3
> aoe: AoE v85 initialised.
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> ehci-pci: EHCI PCI platform driver
> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> ohci-pci: OHCI PCI platform driver
> uhci_hcd: USB Universal Host Controller Interface driver
> usbcore: registered new interface driver cdc_acm
> cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
> usbcore: registered new interface driver usblp
> usbcore: registered new interface driver cdc_wdm
> usbcore: registered new interface driver uas
> usbcore: registered new interface driver usb-storage
> usbcore: registered new interface driver ums-realtek
> usbcore: registered new interface driver usbserial_generic
> usbserial: USB Serial support registered for generic
> usbcore: registered new interface driver ch341
> usbserial: USB Serial support registered for ch341-uart
> usbcore: registered new interface driver cp210x
> usbserial: USB Serial support registered for cp210x
> usbcore: registered new interface driver ftdi_sio
> usbserial: USB Serial support registered for FTDI USB Serial Device
> usbcore: registered new interface driver keyspan
> usbserial: USB Serial support registered for Keyspan - (without firmware)
> usbserial: USB Serial support registered for Keyspan 1 port adapter
> usbserial: USB Serial support registered for Keyspan 2 port adapter
> usbserial: USB Serial support registered for Keyspan 4 port adapter
> usbcore: registered new interface driver option
> usbserial: USB Serial support registered for GSM modem (1-port)
> usbcore: registered new interface driver oti6858
> usbserial: USB Serial support registered for oti6858
> usbcore: registered new interface driver pl2303
> usbserial: USB Serial support registered for pl2303
> usbcore: registered new interface driver qcserial
> usbserial: USB Serial support registered for Qualcomm USB modem
> usbcore: registered new interface driver sierra
> usbserial: USB Serial support registered for Sierra USB modem
> usbcore: registered new interface driver usb_serial_simple
> usbserial: USB Serial support registered for carelink
> usbserial: USB Serial support registered for zio
> usbserial: USB Serial support registered for funsoft
> usbserial: USB Serial support registered for flashloader
> usbserial: USB Serial support registered for google
> usbserial: USB Serial support registered for libtransistor
> usbserial: USB Serial support registered for vivopay
> usbserial: USB Serial support registered for moto_modem
> usbserial: USB Serial support registered for motorola_tetra
> usbserial: USB Serial support registered for novatel_gps
> usbserial: USB Serial support registered for hp4x
> usbserial: USB Serial support registered for suunto
> usbserial: USB Serial support registered for siemens_mpi
> dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 May 2005
> dummy_hcd dummy_hcd.0: Dummy host controller
> dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus number 1
> usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb1: Product: Dummy host controller
> usb usb1: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller dummy_hcd
> usb usb1: SerialNumber: dummy_hcd.0
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 1 port detected
> dummy_hcd dummy_hcd.1: USB Host+Gadget Emulator, driver 02 May 2005
> dummy_hcd dummy_hcd.1: Dummy host controller
> dummy_hcd dummy_hcd.1: new USB bus registered, assigned bus number 2
> usb usb2: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb2: Product: Dummy host controller
> usb usb2: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller dummy_hcd
> usb usb2: SerialNumber: dummy_hcd.1
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 1 port detected
> dummy_hcd dummy_hcd.2: USB Host+Gadget Emulator, driver 02 May 2005
> dummy_hcd dummy_hcd.2: Dummy host controller
> dummy_hcd dummy_hcd.2: new USB bus registered, assigned bus number 3
> usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb3: Product: Dummy host controller
> usb usb3: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller dummy_hcd
> usb usb3: SerialNumber: dummy_hcd.2
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 1 port detected
> dummy_hcd dummy_hcd.3: USB Host+Gadget Emulator, driver 02 May 2005
> dummy_hcd dummy_hcd.3: Dummy host controller
> dummy_hcd dummy_hcd.3: new USB bus registered, assigned bus number 4
> usb usb4: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb4: Product: Dummy host controller
> usb usb4: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller dummy_hcd
> usb usb4: SerialNumber: dummy_hcd.3
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 1 port detected
> dummy_hcd dummy_hcd.4: USB Host+Gadget Emulator, driver 02 May 2005
> dummy_hcd dummy_hcd.4: Dummy host controller
> dummy_hcd dummy_hcd.4: new USB bus registered, assigned bus number 5
> usb usb5: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb5: Product: Dummy host controller
> usb usb5: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller dummy_hcd
> usb usb5: SerialNumber: dummy_hcd.4
> hub 5-0:1.0: USB hub found
> hub 5-0:1.0: 1 port detected
> dummy_hcd dummy_hcd.5: USB Host+Gadget Emulator, driver 02 May 2005
> dummy_hcd dummy_hcd.5: Dummy host controller
> dummy_hcd dummy_hcd.5: new USB bus registered, assigned bus number 6
> usb usb6: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb6: Product: Dummy host controller
> usb usb6: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller dummy_hcd
> usb usb6: SerialNumber: dummy_hcd.5
> hub 6-0:1.0: USB hub found
> hub 6-0:1.0: 1 port detected
> dummy_hcd dummy_hcd.6: USB Host+Gadget Emulator, driver 02 May 2005
> dummy_hcd dummy_hcd.6: Dummy host controller
> dummy_hcd dummy_hcd.6: new USB bus registered, assigned bus number 7
> usb usb7: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb7: Product: Dummy host controller
> usb usb7: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller dummy_hcd
> usb usb7: SerialNumber: dummy_hcd.6
> hub 7-0:1.0: USB hub found
> hub 7-0:1.0: 1 port detected
> dummy_hcd dummy_hcd.7: USB Host+Gadget Emulator, driver 02 May 2005
> dummy_hcd dummy_hcd.7: Dummy host controller
> dummy_hcd dummy_hcd.7: new USB bus registered, assigned bus number 8
> usb usb8: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb8: Product: Dummy host controller
> usb usb8: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller dummy_hcd
> usb usb8: SerialNumber: dummy_hcd.7
> hub 8-0:1.0: USB hub found
> hub 8-0:1.0: 1 port detected
> using random self ethernet address
> using random host ethernet address
> Mass Storage Function, version: 2009/09/11
> LUN: removable file: (no medium)
> no file given for LUN0
> printk: console [ttyGS0] disabled
> g_multi dummy_udc.0: failed to start g_multi: -22
> vhci_hcd vhci_hcd.0: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.0: new USB bus registered, assigned bus number 9
> vhci_hcd: created sysfs vhci_hcd.0
> usb usb9: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb9: Product: USB/IP Virtual Host Controller
> usb usb9: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb9: SerialNumber: vhci_hcd.0
> hub 9-0:1.0: USB hub found
> hub 9-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.0: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.0: new USB bus registered, assigned bus number 10
> usb usb10: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb10: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb10: Product: USB/IP Virtual Host Controller
> usb usb10: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb10: SerialNumber: vhci_hcd.0
> hub 10-0:1.0: USB hub found
> hub 10-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.1: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.1: new USB bus registered, assigned bus number 11
> usb usb11: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb11: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb11: Product: USB/IP Virtual Host Controller
> usb usb11: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb11: SerialNumber: vhci_hcd.1
> hub 11-0:1.0: USB hub found
> hub 11-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.1: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.1: new USB bus registered, assigned bus number 12
> usb usb12: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb12: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb12: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb12: Product: USB/IP Virtual Host Controller
> usb usb12: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb12: SerialNumber: vhci_hcd.1
> hub 12-0:1.0: USB hub found
> hub 12-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.2: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.2: new USB bus registered, assigned bus number 13
> usb usb13: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb13: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb13: Product: USB/IP Virtual Host Controller
> usb usb13: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb13: SerialNumber: vhci_hcd.2
> hub 13-0:1.0: USB hub found
> hub 13-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.2: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.2: new USB bus registered, assigned bus number 14
> usb usb14: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb14: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb14: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb14: Product: USB/IP Virtual Host Controller
> usb usb14: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb14: SerialNumber: vhci_hcd.2
> hub 14-0:1.0: USB hub found
> hub 14-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.3: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.3: new USB bus registered, assigned bus number 15
> usb usb15: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb15: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb15: Product: USB/IP Virtual Host Controller
> usb usb15: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb15: SerialNumber: vhci_hcd.3
> hub 15-0:1.0: USB hub found
> hub 15-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.3: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.3: new USB bus registered, assigned bus number 16
> usb usb16: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb16: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb16: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb16: Product: USB/IP Virtual Host Controller
> usb usb16: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb16: SerialNumber: vhci_hcd.3
> hub 16-0:1.0: USB hub found
> hub 16-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.4: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.4: new USB bus registered, assigned bus number 17
> usb usb17: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb17: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb17: Product: USB/IP Virtual Host Controller
> usb usb17: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb17: SerialNumber: vhci_hcd.4
> hub 17-0:1.0: USB hub found
> hub 17-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.4: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.4: new USB bus registered, assigned bus number 18
> usb usb18: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb18: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb18: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb18: Product: USB/IP Virtual Host Controller
> usb usb18: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb18: SerialNumber: vhci_hcd.4
> hub 18-0:1.0: USB hub found
> hub 18-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.5: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.5: new USB bus registered, assigned bus number 19
> usb usb19: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb19: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb19: Product: USB/IP Virtual Host Controller
> usb usb19: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb19: SerialNumber: vhci_hcd.5
> hub 19-0:1.0: USB hub found
> hub 19-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.5: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.5: new USB bus registered, assigned bus number 20
> usb usb20: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb20: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb20: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb20: Product: USB/IP Virtual Host Controller
> usb usb20: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb20: SerialNumber: vhci_hcd.5
> hub 20-0:1.0: USB hub found
> hub 20-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.6: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.6: new USB bus registered, assigned bus number 21
> usb usb21: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb21: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb21: Product: USB/IP Virtual Host Controller
> usb usb21: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb21: SerialNumber: vhci_hcd.6
> hub 21-0:1.0: USB hub found
> hub 21-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.6: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.6: new USB bus registered, assigned bus number 22
> usb usb22: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb22: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb22: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb22: Product: USB/IP Virtual Host Controller
> usb usb22: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb22: SerialNumber: vhci_hcd.6
> hub 22-0:1.0: USB hub found
> hub 22-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.7: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.7: new USB bus registered, assigned bus number 23
> usb usb23: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb23: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb23: Product: USB/IP Virtual Host Controller
> usb usb23: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb23: SerialNumber: vhci_hcd.7
> hub 23-0:1.0: USB hub found
> hub 23-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.7: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.7: new USB bus registered, assigned bus number 24
> usb usb24: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb24: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb24: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb24: Product: USB/IP Virtual Host Controller
> usb usb24: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb24: SerialNumber: vhci_hcd.7
> hub 24-0:1.0: USB hub found
> hub 24-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.8: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.8: new USB bus registered, assigned bus number 25
> usb usb25: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb25: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb25: Product: USB/IP Virtual Host Controller
> usb usb25: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb25: SerialNumber: vhci_hcd.8
> hub 25-0:1.0: USB hub found
> hub 25-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.8: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.8: new USB bus registered, assigned bus number 26
> usb usb26: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb26: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb26: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb26: Product: USB/IP Virtual Host Controller
> usb usb26: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb26: SerialNumber: vhci_hcd.8
> hub 26-0:1.0: USB hub found
> hub 26-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.9: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.9: new USB bus registered, assigned bus number 27
> usb usb27: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb27: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb27: Product: USB/IP Virtual Host Controller
> usb usb27: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb27: SerialNumber: vhci_hcd.9
> hub 27-0:1.0: USB hub found
> hub 27-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.9: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.9: new USB bus registered, assigned bus number 28
> usb usb28: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb28: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb28: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb28: Product: USB/IP Virtual Host Controller
> usb usb28: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb28: SerialNumber: vhci_hcd.9
> hub 28-0:1.0: USB hub found
> hub 28-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.10: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.10: new USB bus registered, assigned bus number 29
> usb usb29: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb29: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb29: Product: USB/IP Virtual Host Controller
> usb usb29: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb29: SerialNumber: vhci_hcd.10
> hub 29-0:1.0: USB hub found
> hub 29-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.10: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.10: new USB bus registered, assigned bus number 30
> usb usb30: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb30: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb30: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb30: Product: USB/IP Virtual Host Controller
> usb usb30: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb30: SerialNumber: vhci_hcd.10
> hub 30-0:1.0: USB hub found
> hub 30-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.11: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.11: new USB bus registered, assigned bus number 31
> usb usb31: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb31: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb31: Product: USB/IP Virtual Host Controller
> usb usb31: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb31: SerialNumber: vhci_hcd.11
> hub 31-0:1.0: USB hub found
> hub 31-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.11: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.11: new USB bus registered, assigned bus number 32
> usb usb32: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb32: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb32: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb32: Product: USB/IP Virtual Host Controller
> usb usb32: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb32: SerialNumber: vhci_hcd.11
> hub 32-0:1.0: USB hub found
> hub 32-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.12: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.12: new USB bus registered, assigned bus number 33
> usb usb33: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb33: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb33: Product: USB/IP Virtual Host Controller
> usb usb33: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb33: SerialNumber: vhci_hcd.12
> hub 33-0:1.0: USB hub found
> hub 33-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.12: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.12: new USB bus registered, assigned bus number 34
> usb usb34: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb34: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb34: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb34: Product: USB/IP Virtual Host Controller
> usb usb34: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb34: SerialNumber: vhci_hcd.12
> hub 34-0:1.0: USB hub found
> hub 34-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.13: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.13: new USB bus registered, assigned bus number 35
> usb usb35: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb35: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb35: Product: USB/IP Virtual Host Controller
> usb usb35: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb35: SerialNumber: vhci_hcd.13
> hub 35-0:1.0: USB hub found
> hub 35-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.13: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.13: new USB bus registered, assigned bus number 36
> usb usb36: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb36: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb36: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb36: Product: USB/IP Virtual Host Controller
> usb usb36: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb36: SerialNumber: vhci_hcd.13
> hub 36-0:1.0: USB hub found
> hub 36-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.14: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.14: new USB bus registered, assigned bus number 37
> usb usb37: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb37: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb37: Product: USB/IP Virtual Host Controller
> usb usb37: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb37: SerialNumber: vhci_hcd.14
> hub 37-0:1.0: USB hub found
> hub 37-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.14: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.14: new USB bus registered, assigned bus number 38
> usb usb38: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb38: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb38: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb38: Product: USB/IP Virtual Host Controller
> usb usb38: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb38: SerialNumber: vhci_hcd.14
> hub 38-0:1.0: USB hub found
> hub 38-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.15: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.15: new USB bus registered, assigned bus number 39
> usb usb39: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.07
> usb usb39: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb39: Product: USB/IP Virtual Host Controller
> usb usb39: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb39: SerialNumber: vhci_hcd.15
> hub 39-0:1.0: USB hub found
> hub 39-0:1.0: 8 ports detected
> vhci_hcd vhci_hcd.15: USB/IP Virtual Host Controller
> vhci_hcd vhci_hcd.15: new USB bus registered, assigned bus number 40
> usb usb40: We don't know the algorithms for LPM for this host, disabling LPM.
> usb usb40: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.07
> usb usb40: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb40: Product: USB/IP Virtual Host Controller
> usb usb40: Manufacturer: Linux 5.7.0-rc3-next-20200428-syzkaller vhci_hcd
> usb usb40: SerialNumber: vhci_hcd.15
> hub 40-0:1.0: USB hub found
> hub 40-0:1.0: 8 ports detected
> usbcore: registered new device driver usbip-host
> i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> i8042: Warning: Keylock active
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mousedev: PS/2 mouse device common for all mice
> rtc_cmos 00:00: RTC can wake from S4
> rtc_cmos 00:00: registered as rtc0
> rtc_cmos 00:00: alarms up to one day, 114 bytes nvram
> i2c /dev entries driver
> piix4_smbus 0000:00:01.3: SMBus base address uninitialized - upgrade BIOS or use force_addr=0xaddr
> usbcore: registered new interface driver RobotFuzz Open Source InterFace, OSIF
> usbcore: registered new interface driver i2c-tiny-usb
> IR NEC protocol handler initialized
> IR RC5(x/sz) protocol handler initialized
> IR RC6 protocol handler initialized
> IR JVC protocol handler initialized
> IR Sony protocol handler initialized
> IR SANYO protocol handler initialized
> IR Sharp protocol handler initialized
> IR MCE Keyboard/mouse protocol handler initialized
> IR XMP protocol handler initialized
> usbcore: registered new interface driver uvcvideo
> USB Video Class driver (1.1.1)
> gspca_main: v2.14.0 registered
> vivid-000: using single planar format API
> vivid-000: CEC adapter cec0 registered for HDMI input 0
> vivid-000: V4L2 capture device registered as video3
> vivid-000: CEC adapter cec1 registered for HDMI output 0
> vivid-000: V4L2 output device registered as video4
> vivid-000: V4L2 capture device registered as vbi0, supports raw and sliced VBI
> vivid-000: V4L2 output device registered as vbi1, supports raw and sliced VBI
> vivid-000: V4L2 capture device registered as swradio0
> vivid-000: V4L2 receiver device registered as radio0
> vivid-000: V4L2 transmitter device registered as radio1
> vivid-000: V4L2 metadata capture device registered as video5
> vivid-000: V4L2 metadata output device registered as video6
> vivid-000: V4L2 touch capture device registered as v4l-touch0
> vivid-001: using multiplanar format API
> vivid-001: CEC adapter cec2 registered for HDMI input 0
> vivid-001: V4L2 capture device registered as video7
> vivid-001: CEC adapter cec3 registered for HDMI output 0
> vivid-001: V4L2 output device registered as video8
> vivid-001: V4L2 capture device registered as vbi2, supports raw and sliced VBI
> vivid-001: V4L2 output device registered as vbi3, supports raw and sliced VBI
> vivid-001: V4L2 capture device registered as swradio1
> vivid-001: V4L2 receiver device registered as radio2
> vivid-001: V4L2 transmitter device registered as radio3
> vivid-001: V4L2 metadata capture device registered as video9
> vivid-001: V4L2 metadata output device registered as video10
> vivid-001: V4L2 touch capture device registered as v4l-touch1
> vivid-002: using single planar format API
> vivid-002: CEC adapter cec4 registered for HDMI input 0
> vivid-002: V4L2 capture device registered as video11
> vivid-002: CEC adapter cec5 registered for HDMI output 0
> vivid-002: V4L2 output device registered as video12
> vivid-002: V4L2 capture device registered as vbi4, supports raw and sliced VBI
> vivid-002: V4L2 output device registered as vbi5, supports raw and sliced VBI
> vivid-002: V4L2 capture device registered as swradio2
> vivid-002: V4L2 receiver device registered as radio4
> vivid-002: V4L2 transmitter device registered as radio5
> vivid-002: V4L2 metadata capture device registered as video13
> vivid-002: V4L2 metadata output device registered as video14
> vivid-002: V4L2 touch capture device registered as v4l-touch2
> vivid-003: using multiplanar format API
> vivid-003: CEC adapter cec6 registered for HDMI input 0
> vivid-003: V4L2 capture device registered as video15
> vivid-003: CEC adapter cec7 registered for HDMI output 0
> vivid-003: V4L2 output device registered as video16
> vivid-003: V4L2 capture device registered as vbi6, supports raw and sliced VBI
> vivid-003: V4L2 output device registered as vbi7, supports raw and sliced VBI
> vivid-003: V4L2 capture device registered as swradio3
> vivid-003: V4L2 receiver device registered as radio6
> vivid-003: V4L2 transmitter device registered as radio7
> vivid-003: V4L2 metadata capture device registered as video17
> vivid-003: V4L2 metadata output device registered as video18
> vivid-003: V4L2 touch capture device registered as v4l-touch3
> vivid-004: using single planar format API
> vivid-004: CEC adapter cec8 registered for HDMI input 0
> vivid-004: V4L2 capture device registered as video19
> vivid-004: CEC adapter cec9 registered for HDMI output 0
> vivid-004: V4L2 output device registered as video20
> vivid-004: V4L2 capture device registered as vbi8, supports raw and sliced VBI
> vivid-004: V4L2 output device registered as vbi9, supports raw and sliced VBI
> vivid-004: V4L2 capture device registered as swradio4
> vivid-004: V4L2 receiver device registered as radio8
> vivid-004: V4L2 transmitter device registered as radio9
> vivid-004: V4L2 metadata capture device registered as video21
> vivid-004: V4L2 metadata output device registered as video22
> vivid-004: V4L2 touch capture device registered as v4l-touch4
> vivid-005: using multiplanar format API
> vivid-005: CEC adapter cec10 registered for HDMI input 0
> vivid-005: V4L2 capture device registered as video23
> vivid-005: CEC adapter cec11 registered for HDMI output 0
> vivid-005: V4L2 output device registered as video24
> vivid-005: V4L2 capture device registered as vbi10, supports raw and sliced VBI
> vivid-005: V4L2 output device registered as vbi11, supports raw and sliced VBI
> vivid-005: V4L2 capture device registered as swradio5
> vivid-005: V4L2 receiver device registered as radio10
> vivid-005: V4L2 transmitter device registered as radio11
> vivid-005: V4L2 metadata capture device registered as video25
> vivid-005: V4L2 metadata output device registered as video26
> vivid-005: V4L2 touch capture device registered as v4l-touch5
> vivid-006: using single planar format API
> vivid-006: CEC adapter cec12 registered for HDMI input 0
> vivid-006: V4L2 capture device registered as video27
> vivid-006: CEC adapter cec13 registered for HDMI output 0
> vivid-006: V4L2 output device registered as video28
> vivid-006: V4L2 capture device registered as vbi12, supports raw and sliced VBI
> vivid-006: V4L2 output device registered as vbi13, supports raw and sliced VBI
> vivid-006: V4L2 capture device registered as swradio6
> vivid-006: V4L2 receiver device registered as radio12
> vivid-006: V4L2 transmitter device registered as radio13
> vivid-006: V4L2 metadata capture device registered as video29
> vivid-006: V4L2 metadata output device registered as video30
> vivid-006: V4L2 touch capture device registered as v4l-touch6
> vivid-007: using multiplanar format API
> vivid-007: CEC adapter cec14 registered for HDMI input 0
> vivid-007: V4L2 capture device registered as video31
> vivid-007: CEC adapter cec15 registered for HDMI output 0
> vivid-007: V4L2 output device registered as video32
> vivid-007: V4L2 capture device registered as vbi14, supports raw and sliced VBI
> vivid-007: V4L2 output device registered as vbi15, supports raw and sliced VBI
> vivid-007: V4L2 capture device registered as swradio7
> vivid-007: V4L2 receiver device registered as radio14
> vivid-007: V4L2 transmitter device registered as radio15
> vivid-007: V4L2 metadata capture device registered as video33
> vivid-007: V4L2 metadata output device registered as video34
> vivid-007: V4L2 touch capture device registered as v4l-touch7
> vivid-008: using single planar format API
> vivid-008: CEC adapter cec16 registered for HDMI input 0
> vivid-008: V4L2 capture device registered as video35
> vivid-008: CEC adapter cec17 registered for HDMI output 0
> vivid-008: V4L2 output device registered as video36
> vivid-008: V4L2 capture device registered as vbi16, supports raw and sliced VBI
> vivid-008: V4L2 output device registered as vbi17, supports raw and sliced VBI
> vivid-008: V4L2 capture device registered as swradio8
> vivid-008: V4L2 receiver device registered as radio16
> vivid-008: V4L2 transmitter device registered as radio17
> vivid-008: V4L2 metadata capture device registered as video37
> vivid-008: V4L2 metadata output device registered as video38
> vivid-008: V4L2 touch capture device registered as v4l-touch8
> vivid-009: using multiplanar format API
> vivid-009: CEC adapter cec18 registered for HDMI input 0
> vivid-009: V4L2 capture device registered as video39
> vivid-009: CEC adapter cec19 registered for HDMI output 0
> vivid-009: V4L2 output device registered as video40
> vivid-009: V4L2 capture device registered as vbi18, supports raw and sliced VBI
> vivid-009: V4L2 output device registered as vbi19, supports raw and sliced VBI
> vivid-009: V4L2 capture device registered as swradio9
> vivid-009: V4L2 receiver device registered as radio18
> vivid-009: V4L2 transmitter device registered as radio19
> vivid-009: V4L2 metadata capture device registered as video41
> vivid-009: V4L2 metadata output device registered as video42
> vivid-009: V4L2 touch capture device registered as v4l-touch9
> vivid-010: using single planar format API
> vivid-010: CEC adapter cec20 registered for HDMI input 0
> vivid-010: V4L2 capture device registered as video43
> vivid-010: CEC adapter cec21 registered for HDMI output 0
> vivid-010: V4L2 output device registered as video44
> vivid-010: V4L2 capture device registered as vbi20, supports raw and sliced VBI
> vivid-010: V4L2 output device registered as vbi21, supports raw and sliced VBI
> vivid-010: V4L2 capture device registered as swradio10
> vivid-010: V4L2 receiver device registered as radio20
> vivid-010: V4L2 transmitter device registered as radio21
> vivid-010: V4L2 metadata capture device registered as video45
> vivid-010: V4L2 metadata output device registered as video46
> vivid-010: V4L2 touch capture device registered as v4l-touch10
> vivid-011: using multiplanar format API
> vivid-011: CEC adapter cec22 registered for HDMI input 0
> vivid-011: V4L2 capture device registered as video47
> vivid-011: CEC adapter cec23 registered for HDMI output 0
> vivid-011: V4L2 output device registered as video48
> vivid-011: V4L2 capture device registered as vbi22, supports raw and sliced VBI
> vivid-011: V4L2 output device registered as vbi23, supports raw and sliced VBI
> vivid-011: V4L2 capture device registered as swradio11
> vivid-011: V4L2 receiver device registered as radio22
> vivid-011: V4L2 transmitter device registered as radio23
> vivid-011: V4L2 metadata capture device registered as video49
> vivid-011: V4L2 metadata output device registered as video50
> vivid-011: V4L2 touch capture device registered as v4l-touch11
> vivid-012: using single planar format API
> vivid-012: CEC adapter cec24 registered for HDMI input 0
> vivid-012: V4L2 capture device registered as video51
> vivid-012: CEC adapter cec25 registered for HDMI output 0
> vivid-012: V4L2 output device registered as video52
> vivid-012: V4L2 capture device registered as vbi24, supports raw and sliced VBI
> vivid-012: V4L2 output device registered as vbi25, supports raw and sliced VBI
> vivid-012: V4L2 capture device registered as swradio12
> vivid-012: V4L2 receiver device registered as radio24
> vivid-012: V4L2 transmitter device registered as radio25
> vivid-012: V4L2 metadata capture device registered as video53
> vivid-012: V4L2 metadata output device registered as video54
> vivid-012: V4L2 touch capture device registered as v4l-touch12
> vivid-013: using multiplanar format API
> vivid-013: CEC adapter cec26 registered for HDMI input 0
> vivid-013: V4L2 capture device registered as video55
> vivid-013: CEC adapter cec27 registered for HDMI output 0
> vivid-013: V4L2 output device registered as video56
> vivid-013: V4L2 capture device registered as vbi26, supports raw and sliced VBI
> vivid-013: V4L2 output device registered as vbi27, supports raw and sliced VBI
> vivid-013: V4L2 capture device registered as swradio13
> vivid-013: V4L2 receiver device registered as radio26
> vivid-013: V4L2 transmitter device registered as radio27
> vivid-013: V4L2 metadata capture device registered as video57
> vivid-013: V4L2 metadata output device registered as video58
> vivid-013: V4L2 touch capture device registered as v4l-touch13
> vivid-014: using single planar format API
> vivid-014: CEC adapter cec28 registered for HDMI input 0
> vivid-014: V4L2 capture device registered as video59
> vivid-014: CEC adapter cec29 registered for HDMI output 0
> vivid-014: V4L2 output device registered as video60
> vivid-014: V4L2 capture device registered as vbi28, supports raw and sliced VBI
> vivid-014: V4L2 output device registered as vbi29, supports raw and sliced VBI
> vivid-014: V4L2 capture device registered as swradio14
> vivid-014: V4L2 receiver device registered as radio28
> vivid-014: V4L2 transmitter device registered as radio29
> vivid-014: V4L2 metadata capture device registered as video61
> vivid-014: V4L2 metadata output device registered as video62
> vivid-014: V4L2 touch capture device registered as v4l-touch14
> vivid-015: using multiplanar format API
> vivid-015: CEC adapter cec30 registered for HDMI input 0
> vivid-015: V4L2 capture device registered as video63
> vivid-015: CEC adapter cec31 registered for HDMI output 0
> vivid-015: V4L2 output device registered as video64
> vivid-015: V4L2 capture device registered as vbi30, supports raw and sliced VBI
> vivid-015: V4L2 output device registered as vbi31, supports raw and sliced VBI
> vivid-015: V4L2 capture device registered as swradio15
> vivid-015: V4L2 receiver device registered as radio30
> vivid-015: V4L2 transmitter device registered as radio31
> vivid-015: V4L2 metadata capture device registered as video65
> vivid-015: V4L2 metadata output device registered as video66
> vivid-015: V4L2 touch capture device registered as v4l-touch15
> vim2m vim2m.0: Device registered as /dev/video67
> vicodec vicodec.0: Device 'stateful-encoder' registered as /dev/video68
> vicodec vicodec.0: Device 'stateful-decoder' registered as /dev/video69
> vicodec vicodec.0: Device 'stateless-decoder' registered as /dev/video70
> iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> iTCO_vendor_support: vendor-support=0
> device-mapper: uevent: version 1.0.3
> device-mapper: ioctl: 4.42.0-ioctl (2020-02-27) initialised: dm-devel@redhat.com
> device-mapper: multipath round-robin: version 1.2.0 loaded
> device-mapper: multipath queue-length: version 0.2.0 loaded
> device-mapper: multipath service-time: version 0.3.0 loaded
> device-mapper: raid: Loading target version 1.15.1
> Bluetooth: HCI UART driver ver 2.3
> Bluetooth: HCI UART protocol H4 registered
> Bluetooth: HCI UART protocol BCSP registered
> Bluetooth: HCI UART protocol LL registered
> Bluetooth: HCI UART protocol Three-wire (H5) registered
> Bluetooth: HCI UART protocol QCA registered
> Bluetooth: HCI UART protocol AG6XX registered
> Bluetooth: HCI UART protocol Marvell registered
> usbcore: registered new interface driver bfusb
> usbcore: registered new interface driver btusb
> CAPI 2.0 started up with major 68 (middleware)
> Modular ISDN core version 1.1.29
> NET: Registered protocol family 34
> DSP module 2.0
> mISDN_dsp: DSP clocks every 80 samples. This equals 1 jiffies.
> mISDN: Layer-1-over-IP driver Rev. 2.00
> 0 virtual devices registered
> intel_pstate: CPU model not supported
> usnic_verbs: Cisco VIC (USNIC) Verbs Driver v1.0.3 (December 19, 2013)
> usnic_verbs:usnic_uiom_init:563:
> IOMMU required but not present or enabled.  USNIC QPs will not function w/o enabling IOMMU
> usnic_verbs:usnic_ib_init:667:
> Unable to initialize umem with err -1
> iscsi: registered transport (iser)
> SoftiWARP attached
> Driver 'framebuffer' was unable to register with bus_type 'coreboot' because the bus was not initialized.
> Driver 'memconsole' was unable to register with bus_type 'coreboot' because the bus was not initialized.
> Driver 'vpd' was unable to register with bus_type 'coreboot' because the bus was not initialized.
> hid: raw HID events driver (C) Jiri Kosina
> usbcore: registered new interface driver usbhid
> usbhid: USB HID core driver
> ashmem: initialized
> usbcore: registered new interface driver snd-usb-audio
> drop_monitor: Initializing network drop monitor service
> NET: Registered protocol family 26
> GACT probability on
> Mirror/redirect action on
> Simple TC action Loaded
> netem: version 1.3
> u32 classifier
>     Performance counters on
>     input device check on
>     Actions configured
> nf_conntrack_irc: failed to register helpers
> nf_conntrack_sane: failed to register helpers
> nf_conntrack_sip: failed to register helpers
> xt_time: kernel timezone is -0000
> IPVS: Registered protocols (TCP, UDP, SCTP, AH, ESP)
> IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
> IPVS: ipvs loaded.
> IPVS: [rr] scheduler registered.
> IPVS: [wrr] scheduler registered.
> IPVS: [lc] scheduler registered.
> IPVS: [wlc] scheduler registered.
> IPVS: [fo] scheduler registered.
> IPVS: [ovf] scheduler registered.
> IPVS: [lblc] scheduler registered.
> IPVS: [lblcr] scheduler registered.
> IPVS: [dh] scheduler registered.
> IPVS: [sh] scheduler registered.
> IPVS: [mh] scheduler registered.
> IPVS: [sed] scheduler registered.
> IPVS: [nq] scheduler registered.
> IPVS: ftp: loaded support on port[0] = 21
> IPVS: [sip] pe registered.
> ipip: IPv4 and MPLS over IPv4 tunneling driver
> gre: GRE over IPv4 demultiplexor driver
> ip_gre: GRE over IPv4 tunneling driver
> IPv4 over IPsec tunneling driver
> ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
> Initializing XFRM netlink socket
> IPsec XFRM device driver
> NET: Registered protocol family 10
>
> =============================
> WARNING: suspicious RCU usage
> 5.7.0-rc3-next-20200428-syzkaller #0 Not tainted
> -----------------------------
> net/ipv6/ip6mr.c:124 RCU-list traversed in non-reader section!!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by swapper/0/1:
>  #0: ffffffff8a5a6330 (pernet_ops_rwsem){+.+.}-{3:3}, at: register_pernet_subsys+0x16/0x40 net/core/net_namespace.c:1257
>
> stack backtrace:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.7.0-rc3-next-20200428-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  ip6mr_get_table+0x153/0x180 net/ipv6/ip6mr.c:124
>  ip6mr_new_table+0x1b/0x70 net/ipv6/ip6mr.c:382
>  ip6mr_rules_init net/ipv6/ip6mr.c:236 [inline]
>  ip6mr_net_init+0x133/0x3f0 net/ipv6/ip6mr.c:1310
>  ops_init+0xaf/0x420 net/core/net_namespace.c:151
>  __register_pernet_operations net/core/net_namespace.c:1140 [inline]
>  register_pernet_operations+0x346/0x840 net/core/net_namespace.c:1217
>  register_pernet_subsys+0x25/0x40 net/core/net_namespace.c:1258
>  ip6_mr_init+0x49/0x152 net/ipv6/ip6mr.c:1363
>  inet6_init+0x1d7/0x6dc net/ipv6/af_inet6.c:1032
>  do_one_initcall+0x10a/0x7d0 init/main.c:1159
>  do_initcall_level init/main.c:1232 [inline]
>  do_initcalls init/main.c:1248 [inline]
>  do_basic_setup init/main.c:1268 [inline]
>  kernel_init_freeable+0x501/0x5ae init/main.c:1454
>  kernel_init+0xd/0x1bb init/main.c:1359
>  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
> Segment Routing with IPv6
> mip6: Mobile IPv6
> sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
> ip6_gre: GRE over IPv6 tunneling driver
> NET: Registered protocol family 17
> NET: Registered protocol family 15
> Bridge firewalling registered
> NET: Registered protocol family 9
> X25: Linux Version 0.2
> NET: Registered protocol family 6
> NET: Registered protocol family 11
> NET: Registered protocol family 3
> can: controller area network core (rev 20170425 abi 9)
> NET: Registered protocol family 29
> can: raw protocol (rev 20170425)
> can: broadcast manager protocol (rev 20170425 t)
> can: netlink gateway (rev 20190810) max_hops=1
> can: SAE J1939
> Bluetooth: RFCOMM TTY layer initialized
> Bluetooth: RFCOMM socket layer initialized
> Bluetooth: RFCOMM ver 1.11
> Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> Bluetooth: BNEP filters: protocol multicast
> Bluetooth: BNEP socket layer initialized
> Bluetooth: CMTP (CAPI Emulation) ver 1.0
> Bluetooth: CMTP socket layer initialized
> Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> Bluetooth: HIDP socket layer initialized
> RPC: Registered rdma transport module.
> RPC: Registered rdma backchannel transport module.
> NET: Registered protocol family 33
> Key type rxrpc registered
> Key type rxrpc_s registered
> NET: Registered protocol family 41
> lec:lane_module_init: lec.c: initialized
> mpoa:atm_mpoa_init: mpc.c: initialized
> l2tp_core: L2TP core driver, V2.0
> l2tp_ppp: PPPoL2TP kernel driver, V2.0
> l2tp_ip: L2TP IP encapsulation support (L2TPv3)
> l2tp_netlink: L2TP netlink interface
> l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
> l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
> NET: Registered protocol family 35
> 8021q: 802.1Q VLAN Support v1.8
> DCCP: Activated CCID 2 (TCP-like)
> DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
> sctp: Hash tables configured (bind 32/56)
> NET: Registered protocol family 21
> Registered RDS/infiniband transport
> Registered RDS/tcp transport
> tipc: Activated (version 2.0.0)
> NET: Registered protocol family 30
> tipc: Started in single node mode
> NET: Registered protocol family 43
> 9pnet: Installing 9P2000 support
> NET: Registered protocol family 37
> NET: Registered protocol family 36
> Key type dns_resolver registered
> Key type ceph registered
> libceph: loaded (mon/osd proto 15/24)
> batman_adv: B.A.T.M.A.N. advanced 2020.2 (compatibility version 15) loaded
> openvswitch: Open vSwitch switching datapath
> NET: Registered protocol family 40
> mpls_gso: MPLS GSO support
> IPI shorthand broadcast: enabled
> AVX2 version of gcm_enc/dec engaged.
> AES CTR mode by8 optimization enabled
> sched_clock: Marking stable (17444721508, 31811971)->(17487974339, -11440860)
> registered taskstats version 1
> Loading compiled-in X.509 certificates
> Loaded X.509 cert 'Build time autogenerated kernel key: 8b22f477d966bfa6cf9a482acbda6ca1892a4acc'
> zswap: loaded using pool lzo/zbud
> debug_vm_pgtable: debug_vm_pgtable: Validating architecture page table helpers
> Key type ._fscrypt registered
> Key type .fscrypt registered
> Key type fscrypt-provisioning registered
> kAFS: Red Hat AFS client v0.1 registering.
> FS-Cache: Netfs 'afs' registered for caching
> Btrfs loaded, crc32c=crc32c-intel
> Key type big_key registered
> Key type encrypted registered
> AppArmor: AppArmor sha1 policy hashing enabled
> ima: No TPM chip found, activating TPM-bypass!
> ima: Allocated hash algorithm: sha256
> ima: No architecture policies found
> evm: Initialising EVM extended attributes:
> evm: security.selinux
> evm: security.SMACK64
> evm: security.SMACK64EXEC
> evm: security.SMACK64TRANSMUTE
> evm: security.SMACK64MMAP
> evm: security.apparmor
> evm: security.ima
> evm: security.capability
> evm: HMAC attrs: 0x1
> PM:   Magic number: 0:864:473
> printk: console [netcon0] enabled
> netconsole: network logging started
> gtp: GTP module loaded (pdp ctx size 104 bytes)
> rdma_rxe: loaded
> cfg80211: Loading compiled-in X.509 certificates for regulatory database
> cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> ALSA device list:
>   #0: Dummy 1
>   #1: Loopback 1
>   #2: Virtual MIDI Card 1
> md: Waiting for all devices to be available before autodetect
> md: If you don't use raid, use raid=noautodetect
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
> VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
> devtmpfs: mounted
> Freeing unused kernel image (initmem) memory: 2776K
> Kernel memory protection disabled.
> Run /sbin/init as init process
> random: systemd: uninitialized urandom read (16 bytes read)
> random: systemd: uninitialized urandom read (16 bytes read)
> random: systemd: uninitialized urandom read (16 bytes read)
> systemd[1]: systemd 232 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
> systemd[1]: Detected virtualization kvm.
> systemd[1]: Detected architecture x86-64.
> systemd[1]: Set hostname to <syzkaller>.
> systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
> systemd[1]: Reached target Remote File Systems.
> systemd[1]: Listening on Syslog Socket.
> systemd[1]: Listening on Journal Socket.
> systemd[1]: Listening on udev Kernel Socket.
>
> =============================
> WARNING: suspicious RCU usage
> 5.7.0-rc3-next-20200428-syzkaller #0 Not tainted
> -----------------------------
> security/integrity/evm/evm_main.c:231 RCU-list traversed in non-reader section!!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 1
> 2 locks held by systemd/1:
>  #0: ffff888098dfa450 (sb_writers#8){.+.+}-{0:0}, at: sb_start_write include/linux/fs.h:1659 [inline]
>  #0: ffff888098dfa450 (sb_writers#8){.+.+}-{0:0}, at: mnt_want_write+0x3a/0xb0 fs/namespace.c:354
>  #1: ffff8880988e8310 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: inode_lock include/linux/fs.h:799 [inline]
>  #1: ffff8880988e8310 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: vfs_setxattr+0x92/0xf0 fs/xattr.c:219
>
> stack backtrace:
> CPU: 0 PID: 1 Comm: systemd Not tainted 5.7.0-rc3-next-20200428-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  evm_protected_xattr+0x1c2/0x210 security/integrity/evm/evm_main.c:231
>  evm_protect_xattr.isra.0+0xb6/0x3d0 security/integrity/evm/evm_main.c:318
>  evm_inode_setxattr+0xc4/0xf0 security/integrity/evm/evm_main.c:387
>  security_inode_setxattr+0x18f/0x200 security/security.c:1297
>  vfs_setxattr+0xa7/0xf0 fs/xattr.c:220
>  setxattr+0x23d/0x330 fs/xattr.c:451
>  path_setxattr+0x170/0x190 fs/xattr.c:470
>  __do_sys_setxattr fs/xattr.c:485 [inline]
>  __se_sys_setxattr fs/xattr.c:481 [inline]
>  __x64_sys_setxattr+0xc0/0x160 fs/xattr.c:481
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x7fe46005e67a
> Code: 48 8b 0d 21 18 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 bc 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ee 17 2b 00 f7 d8 64 89 01 48
> RSP: 002b:00007fffef423568 EFLAGS: 00000246 ORIG_RAX: 00000000000000bc
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe46005e67a
> RDX: 00007fffef4235e0 RSI: 0000556ea53ddf9b RDI: 0000556ea6766760
> RBP: 0000556ea53ddf9b R08: 0000000000000000 R09: 0000000000000030
> R10: 0000000000000020 R11: 0000000000000246 R12: 00007fffef4235e0
> R13: 0000000000000020 R14: 0000000000000000 R15: 0000556ea6751700
>
> =============================
> WARNING: suspicious RCU usage
> 5.7.0-rc3-next-20200428-syzkaller #0 Not tainted
> -----------------------------
> security/device_cgroup.c:357 RCU-list traversed in non-reader section!!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 1
> 4 locks held by systemd/1:
>  #0: ffff8880984f6450 (sb_writers#8){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2910 [inline]
>  #0: ffff8880984f6450 (sb_writers#8){.+.+}-{0:0}, at: vfs_write+0x4cf/0x5d0 fs/read_write.c:558
>  #1: ffff8880a93c4888 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write+0x1b8/0x490 fs/kernfs/file.c:306
>  #2: ffff888096d1f4d0 (kn->active#47){++++}-{0:0}, at: kernfs_fop_write+0x1db/0x490 fs/kernfs/file.c:307
>  #3: ffffffff89e5de48 (devcgroup_mutex){+.+.}-{3:3}, at: devcgroup_access_write+0x93/0x12a7 security/device_cgroup.c:762
>
> stack backtrace:
> CPU: 1 PID: 1 Comm: systemd Not tainted 5.7.0-rc3-next-20200428-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>  match_exception_partial+0x2ee/0x340 security/device_cgroup.c:357
>  verify_new_ex+0x176/0x3a0 security/device_cgroup.c:414
>  parent_has_perm security/device_cgroup.c:456 [inline]
>  devcgroup_update_access security/device_cgroup.c:731 [inline]
>  devcgroup_access_write+0xaf5/0x12a7 security/device_cgroup.c:763
>  cgroup_file_write+0x20d/0x710 kernel/cgroup/cgroup.c:3704
>  kernfs_fop_write+0x268/0x490 fs/kernfs/file.c:315
>  __vfs_write+0x76/0x100 fs/read_write.c:495
>  vfs_write+0x268/0x5d0 fs/read_write.c:559
>  ksys_write+0x12d/0x250 fs/read_write.c:612
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x7fe460052970
> Code: 73 01 c3 48 8b 0d 28 d5 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 99 2d 2c 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 7e 9b 01 00 48 89 04 24
> RSP: 002b:00007fffef423128 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 000000000000000a RCX: 00007fe460052970
> RDX: 000000000000000a RSI: 0000556ea6787c30 RDI: 0000000000000027
> RBP: 0000556ea6787c30 R08: 0000556ea67af200 R09: 00007fe461a88500
> R10: 0000000000000073 R11: 0000000000000246 R12: 000000000000000a
> R13: 0000000000000001 R14: 0000556ea67af120 R15: 000000000000000a
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000df9a9805a455e07b%40google.com.
