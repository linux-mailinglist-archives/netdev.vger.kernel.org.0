Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15DE010CFE2
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 00:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfK1XCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 18:02:02 -0500
Received: from mail-il1-f208.google.com ([209.85.166.208]:44991 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfK1XCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 18:02:02 -0500
Received: by mail-il1-f208.google.com with SMTP id h4so5077135ilh.11
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 15:02:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xvYUtR4txBcR+DWtwklA/ynxv/Ck2/THcSa58Wm+zJk=;
        b=GPOusSyegKBYc7UOvRBSEcMpkPVWQxv+VTwY6lfF1pVc/0qG5cIFnwp6v3VdsUgzYW
         qIE8K6KT1yrffmydWzTM7GdwrbR9S34mt0mk/EFzhQ6iLaeaB+T73fCamQQQJvW1Bloe
         UAllABIhCBubsHBkxtHpqvmr8vuvPur+PYmgdxzoZt/xFPHqFavjSUEJxMp8aSa6K5Hy
         GcyCkyiR/iTA/FshisAwWyY3+yGQprlg9SWX7ieH1EQv9UOxpiSIG4wh2xCWU3wCeJ3I
         OgS1Toryl2OJKL6TrFnbjS+4jjddOWGujBMGqiapd4fRC5cI8wnFQGtkyY6mizYi0Omt
         SgzA==
X-Gm-Message-State: APjAAAXmZUSRhi7+QXdYMXVmwc1GLGjV4E3Fya8JLm2aE+QVBbnlSr0w
        pDMZdC7emJHZAJnuGxgb84/UlzS2IxFTS/ltgPozJFAGxhTH
X-Google-Smtp-Source: APXvYqxsppbhXpZiH+4watPJicGCJZKIRZoK57sZemOhlON8DdH0HCJgKL6Zj+3rRSxWKX/HRsGUNZBpFCqlf60CsTwLun7ri6v3
MIME-Version: 1.0
X-Received: by 2002:a5d:9452:: with SMTP id x18mr31646363ior.22.1574982120989;
 Thu, 28 Nov 2019 15:02:00 -0800 (PST)
Date:   Thu, 28 Nov 2019 15:02:00 -0800
In-Reply-To: <20191128180040.GE29518@localhost>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d970d50598701923@google.com>
Subject: Re: WARNING: ODEBUG bug in rsi_probe
From:   syzbot <syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com>
To:     amitkarwar@gmail.com, andreyknvl@google.com, davem@davemloft.net,
        johan@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        siva8118@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but build/boot failed:

7.079268] usbcore: registered new interface driver sunplus
[   17.080920] usbcore: registered new interface driver stk014
[   17.082771] usbcore: registered new interface driver stk1135
[   17.084642] usbcore: registered new interface driver stv0680
[   17.086433] usbcore: registered new interface driver t613
[   17.088256] usbcore: registered new interface driver gspca_topro
[   17.090143] usbcore: registered new interface driver touptek
[   17.091854] usbcore: registered new interface driver tv8532
[   17.093570] usbcore: registered new interface driver vc032x
[   17.095328] usbcore: registered new interface driver vicam
[   17.097267] usbcore: registered new interface driver xirlink-cit
[   17.099455] usbcore: registered new interface driver gspca_zc3xx
[   17.101119] usbcore: registered new interface driver ALi m5602
[   17.102910] usbcore: registered new interface driver STV06xx
[   17.104675] usbcore: registered new interface driver gspca_gl860
[   17.106471] usbcore: registered new interface driver Philips webcam
[   17.108306] usbcore: registered new interface driver airspy
[   17.109945] usbcore: registered new interface driver hackrf
[   17.111609] usbcore: registered new interface driver msi2500
[   17.113257] cpia2: V4L-Driver for Vision CPiA2 based cameras v3.0.1
[   17.115764] usbcore: registered new interface driver cpia2
[   17.117340] au0828: au0828 driver loaded
[   17.121297] usbcore: registered new interface driver au0828
[   17.123153] usbcore: registered new interface driver hdpvr
[   17.126149] usbcore: registered new interface driver pvrusb2
[   17.128147] pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2  
Encoder/Tuner
[   17.130340] pvrusb2: Debug mask is 31 (0x1f)
[   17.132015] usbcore: registered new interface driver usbvision
[   17.132664] input: ImExPS/2 Generic Explorer Mouse as  
/devices/platform/i8042/serio1/input/input8
[   17.133637] USBVision USB Video Device Driver for Linux : 0.9.11
[   17.134008] usbcore: registered new interface driver stk1160
[   17.140074] usbcore: registered new interface driver cx231xx
[   17.142056] usbcore: registered new interface driver tm6000
[   17.144211] usbcore: registered new interface driver em28xx
[   17.146024] em28xx: Registered (Em28xx v4l2 Extension) extension
[   17.147792] em28xx: Registered (Em28xx Audio Extension) extension
[   17.149521] em28xx: Registered (Em28xx dvb Extension) extension
[   17.151245] em28xx: Registered (Em28xx Input Extension) extension
[   17.153276] usbcore: registered new interface driver usbtv
[   17.155246] usbcore: registered new interface driver Abilis Systems  
as10x usb driver
[   17.157899] smssdio: Siano SMS1xxx SDIO driver
[   17.159173] smssdio: Copyright Pierre Ossman
[   17.160941] usbcore: registered new interface driver radioshark
[   17.162776] usbcore: registered new interface driver radioshark2
[   17.164838] usbcore: registered new interface driver dsbr100
[   17.166823] usbcore: registered new interface driver radio-si470x
[   17.168965] usbcore: registered new interface driver radio-mr800
[   17.171460] usbcore: registered new interface driver radio-keene
[   17.173618] usbcore: registered new interface driver radio-ma901
[   17.175549] usbcore: registered new interface driver radio-raremono
[   17.177513] pps_ldisc: PPS line discipline registered
[   17.178985] pps_parport: parallel port PPS client
[   17.181262] Driver for 1-wire Dallas network protocol.
[   17.183111] usbcore: registered new interface driver DS9490R
[   17.185167] w1_f0d_init()
[   17.188107] applesmc: supported laptop not found!
[   17.189432] applesmc: driver init failed (ret=-19)!
[   17.196126] pc87360: PC8736x not detected, module not inserted
[   17.200018] intel_powerclamp: CPU does not support MWAIT
[   17.202620] usbcore: registered new interface driver pcwd_usb
[   17.204243] acquirewdt: WDT driver for Acquire single board computer  
initialising
[   17.206868] acquirewdt: I/O address 0x0043 already in use
[   17.208431] acquirewdt: probe of acquirewdt failed with error -5
[   17.210486] advantechwdt: WDT driver for Advantech single board computer  
initialising
[   17.213912] advantechwdt: initialized. timeout=60 sec (nowayout=0)
[   17.215828] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[   17.217397] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   17.219629] eurotechwdt: can't misc_register on minor=130
[   17.221394] ib700wdt: WDT driver for IB700 single board computer  
initialising
[   17.223892] ib700wdt: START method I/O 443 is not available
[   17.225542] ib700wdt: probe of ib700wdt failed with error -5
[   17.227430] wafer5823wdt: WDT driver for Wafer 5823 single board  
computer initialising
[   17.229585] wafer5823wdt: I/O address 0x0443 already in use
[   17.231433] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   17.232961] iTCO_vendor_support: vendor-support=0
[   17.234277] it87_wdt: no device
[   17.235303] sc1200wdt: build 20020303
[   17.236483] sc1200wdt: io parameter must be specified
[   17.237991] pc87413_wdt: Version 1.1 at io 0x2E
[   17.239334] pc87413_wdt: cannot register miscdev on minor=130 (err=-16)
[   17.241174] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   17.243122] sbc60xxwdt: I/O address 0x0443 already in use
[   17.244581] cpu5wdt: misc_register failed
[   17.245758] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1  
initialising...
[   17.249098] smsc37b787_wdt: Unable to register miscdev on minor 130
[   17.251996] w83877f_wdt: I/O address 0x0443 already in use
[   17.253586] w83977f_wdt: driver v1.00
[   17.254539] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
[   17.256137] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   17.257968] machzwd: no ZF-Logic found
[   17.259106] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
[   17.262166] watchdog: Software Watchdog: cannot register miscdev on  
minor=130 (err=-16).
[   17.264399] watchdog: Software Watchdog: a legacy watchdog module is  
probably present.
[   17.267385] softdog: initialized. soft_noboot=0 soft_margin=60 sec  
soft_panic=0 (nowayout=0)
[   17.272050] device-mapper: uevent: version 1.0.3
[   17.275001] device-mapper: ioctl: 4.41.0-ioctl (2019-09-16) initialised:  
dm-devel@redhat.com
[   17.279301] device-mapper: multipath round-robin: version 1.2.0 loaded
[   17.281193] device-mapper: multipath queue-length: version 0.2.0 loaded
[   17.282975] device-mapper: multipath service-time: version 0.3.0 loaded
[   17.286083] device-mapper: dm-log-userspace: version 1.3.0 loaded
[   17.287619] device-mapper: raid: Loading target version 1.14.0
[   17.290659] Bluetooth: HCI UART driver ver 2.3
[   17.291878] Bluetooth: HCI UART protocol H4 registered
[   17.293411] Bluetooth: HCI UART protocol BCSP registered
[   17.294975] Bluetooth: HCI UART protocol LL registered
[   17.296708] Bluetooth: HCI UART protocol ATH3K registered
[   17.298379] Bluetooth: HCI UART protocol Three-wire (H5) registered
[   17.300396] Bluetooth: HCI UART protocol Intel registered
[   17.302159] Bluetooth: HCI UART protocol Broadcom registered
[   17.303911] Bluetooth: HCI UART protocol QCA registered
[   17.305593] Bluetooth: HCI UART protocol AG6XX registered
[   17.307228] Bluetooth: HCI UART protocol Marvell registered
[   17.309052] usbcore: registered new interface driver bcm203x
[   17.311027] usbcore: registered new interface driver bpa10x
[   17.312814] usbcore: registered new interface driver bfusb
[   17.314672] usbcore: registered new interface driver btusb
[   17.316402] usbcore: registered new interface driver ath3k
[   17.318927] CAPI 2.0 started up with major 68 (middleware)
[   17.320482] Modular ISDN core version 1.1.29
[   17.322339] NET: Registered protocol family 34
[   17.323643] DSP module 2.0
[   17.324438] mISDN_dsp: DSP clocks every 80 samples. This equals 1  
jiffies.
[   17.334220] mISDN: Layer-1-over-IP driver Rev. 2.00
[   17.336183] 0 virtual devices registered
[   17.337904] mISDN: HFC-multi driver 2.03
[   17.339345] usbcore: registered new interface driver HFC-S_USB
[   17.341097] AVM Fritz PCI driver Rev. 2.3
[   17.342450] Sedlbauer Speedfax+ Driver Rev. 2.0
[   17.343962] Infineon ISDN Driver Rev. 1.0
[   17.345131] Winbond W6692 PCI driver Rev. 2.0
[   17.346524] mISDNipac module version 2.0
[   17.347566] mISDN: ISAR driver Rev. 2.1
[   17.349541] EDAC sbridge:  Ver: 1.1.2
[   17.351872] intel_pstate: CPU model not supported
[   17.353915] sdhci: Secure Digital Host Controller Interface driver
[   17.355724] sdhci: Copyright(c) Pierre Ossman
[   17.357323] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   17.359040] wbsd: Copyright(c) Pierre Ossman
[   17.360684] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[   17.362148] usbcore: registered new interface driver vub300
[   17.366360] usbcore: registered new interface driver ushc
[   17.369616] leds_apu: No PC Engines APUv1 board detected. For APUv2,3  
support, enable CONFIG_PCENGINES_APU2
[   17.372753] leds_ss4200: no LED devices found
[   17.374549] ledtrig-cpu: registered to indicate activity on CPUs
[   17.382118] i40e: Registered client i40iw
[   17.384544] usnic_verbs: Cisco VIC (USNIC) Verbs Driver v1.0.3 (December  
19, 2013)
[   17.386865] usnic_verbs:usnic_uiom_init:563:
[   17.386869] IOMMU required but not present or enabled.  USNIC QPs will  
not function w/o enabling IOMMU
[   17.390995] usnic_verbs:usnic_ib_init:667:
[   17.390998] Unable to initialize umem with err -1
[   17.394880] qedr: discovered and registered 0 RDMA funcs
[   17.397724] iscsi: registered transport (iser)
[   17.400399] No iBFT detected.
[   17.401890] ccp_crypto: Cannot load: there are no available CCPs
[   17.409584] hidraw: raw HID events driver (C) Jiri Kosina
[   17.415367] hv_vmbus: registering driver hid_hyperv
[   17.425431] usbcore: registered new interface driver usbhid
[   17.427040] usbhid: USB HID core driver
[   17.430482] NET: Registered protocol family 40
[   17.432484] usbcore: registered new interface driver prism2_usb
[   17.434248] comedi: version 0.7.76 - http://www.comedi.org
[   17.442331] usbcore: registered new interface driver dt9812
[   17.444169] usbcore: registered new interface driver ni6501
[   17.446148] usbcore: registered new interface driver usbdux
[   17.447821] usbcore: registered new interface driver usbduxfast
[   17.449661] usbcore: registered new interface driver usbduxsigma
[   17.451602] usbcore: registered new interface driver vmk80xx
[   17.460590] usbcore: registered new interface driver r8712u
[   17.462869] input: Speakup as /devices/virtual/input/input9
[   17.465528] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[   17.467656] speakup 3.1.6: initialized
[   17.468822] synth name on entry is: (null)
[   17.470500] b1pci: revision 1.1.2.2
[   17.471706] b1: revision 1.1.2.2
[   17.472722] b1dma: revision 1.1.2.3
[   17.473758] b1pci: revision 1.1.2.2
[   17.475796] t1pci: revision 1.1.2.2
[   17.477072] c4: revision 1.1.2.2
[   17.478002] gigaset: Driver for Gigaset 307x
[   17.479352] gigaset: Kernel CAPI interface
[   17.480985] usbcore: registered new interface driver usb_gigaset
[   17.482767] usb_gigaset: USB Driver for Gigaset 307x using M105
[   17.484982] usbcore: registered new interface driver bas_gigaset
[   17.486787] bas_gigaset: USB Driver for Gigaset 307x
[   17.488981] usbcore: registered new interface driver hwa-rc
[   17.490728] usbcore: registered new interface driver i1480-dfu-usb
[   17.493128] usbcore: registered new interface driver wusb-cbaf
[   17.495368] usbcore: registered new interface driver hwa-hc
[   17.497672] asus_wmi: ASUS WMI generic driver loaded
[   17.499645] asus_wmi: ASUS Management GUID not found
[   17.502241] asus_wmi: ASUS Management GUID not found
[   17.506389] compal_laptop: Motherboard not recognized (You could try the  
module's force-parameter)
[   17.508909] dell_smbios: Unable to run on non-Dell system
[   17.510506] dell_wmi_aio: No known WMI GUID found
[   17.512351] acer_wmi: Acer Laptop ACPI-WMI Extras
[   17.513629] acer_wmi: No or unsupported WMI interface, unable to load
[   17.515490] acerhdf: Acer Aspire One Fan driver, v.0.7.0
[   17.522065] acerhdf: unknown (unsupported) BIOS version Google/Google  
Compute Engine/Google, please report, aborting!
[   17.525535] hdaps: supported laptop not found!
[   17.526759] hdaps: driver init failed (ret=-19)!
[   17.528573] fujitsu_laptop: driver 0.6.0 successfully loaded
[   17.530289] fujitsu_tablet: Unknown (using defaults)
[   17.531884] msi_wmi: This machine doesn't have neither MSI-hotkeys nor  
backlight through WMI
[   17.534629] topstar_laptop: ACPI extras driver loaded
[   17.537353] intel_oaktrail: Platform not recognized (You could try the  
module's force-parameter)
[   17.537625] alienware_wmi: alienware-wmi: No known WMI GUID found
[   17.543489] hv_utils: Registering HyperV Utility Driver
[   17.545092] hv_vmbus: registering driver hv_utils
[   17.546443] hv_vmbus: registering driver hv_balloon
[   17.551626] ------------[ cut here ]------------
[   17.552980] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[   17.553021] WARNING: CPU: 1 PID: 1 at kernel/locking/mutex.c:938  
__mutex_lock+0xb6f/0x1390
[   17.556664] Kernel panic - not syncing: panic_on_warn set ...
[   17.558350] CPU: 1 PID: 1 Comm: swapper/0 Not tainted  
5.4.0-rc6-syzkaller-00224-gda06441bb485f-dirty #0
[   17.560767] Hardware name: Google Google Compute Engine/Google Compute  
Engine, BIOS Google 01/01/2011
[   17.560773] Call Trace:
[   17.560773]  dump_stack+0xe8/0x16e
[   17.560773]  ? __mutex_lock+0xb40/0x1390
[   17.560773]  panic+0x2b5/0x708
[   17.560773]  ? add_taint.cold+0x16/0x16
[   17.560773]  ? __probe_kernel_read+0x18d/0x1d0
[   17.560773]  ? __warn.cold+0x14/0x32
[   17.560773]  ? __warn+0xda/0x1d0
[   17.560773]  ? __mutex_lock+0xb6f/0x1390
[   17.560773]  __warn.cold+0x2f/0x32
[   17.560773]  ? trace_hardirqs_on+0x55/0x1e0
[   17.560773]  ? __mutex_lock+0xb6f/0x1390
[   17.560773]  report_bug+0x27b/0x2f0
[   17.560773]  do_error_trap+0x12f/0x1f0
[   17.560773]  ? __mutex_lock+0xb6f/0x1390
[   17.560773]  do_invalid_op+0x37/0x40
[   17.560773]  ? __mutex_lock+0xb6f/0x1390
[   17.560773]  invalid_op+0x23/0x30
[   17.560773] RIP: 0010:__mutex_lock+0xb6f/0x1390
[   17.560773] Code: d2 0f 85 eb 07 00 00 44 8b 05 3d 93 c9 05 45 85 c0 0f  
85 d1 f5 ff ff 48 c7 c6 60 0d b0 8e 48 c7 c7 60 0b b0 8e e8 0b 5f f1 f2  
<0f> 0b e9 b7 f5 ff ff 48 c7 c0 20 57 07 97 48 c1 e8 03 42 0f b6 14
[   17.560773] RSP: 0000:ffff8880a82efc50 EFLAGS: 00010286
[   17.560773] RAX: 0000000000000000 RBX: 0000000000000000 RCX:  
0000000000000000
[   17.560773] RDX: 0000000000000000 RSI: ffffffff815d6282 RDI:  
ffffed101505df7c
[   17.560773] RBP: ffff8880a82efdd0 R08: ffff88821ba93180 R09:  
fffffbfff237a511
[   17.560773] R10: fffffbfff237a510 R11: ffffffff91bd2883 R12:  
0000000000000000
[   17.560773] R13: dffffc0000000000 R14: ffffffff97c3e740 R15:  
ffffffff962e2098
[   17.560773]  ? vprintk_func+0x82/0x118
[   17.560773]  ? initcall_blacklisted+0x15a/0x1d0
[   17.560773]  ? intel_th_msu_buffer_register+0x6a/0x210
[   17.560773]  ? fs_reclaim_release.part.0+0x5/0x20
[   17.560773]  ? mutex_trylock+0x2d0/0x2d0
[   17.560773]  ? rcu_read_lock_sched_held+0xa1/0xe0
[   17.560773]  ? rcu_read_lock_bh_held+0xc0/0xc0
[   17.560773]  ? __kasan_kmalloc.constprop.0+0xbf/0xd0
[   17.560773]  ? kasan_unpoison_shadow+0x30/0x40
[   17.560773]  ? intel_th_pti_lpp_init+0x67/0x67
[   17.560773]  ? intel_th_msu_buffer_register+0x6a/0x210
[   17.560773]  intel_th_msu_buffer_register+0x6a/0x210
[   17.560773]  ? intel_th_pti_lpp_init+0x67/0x67
[   17.560773]  do_one_initcall+0xf7/0x629
[   17.560773]  ? perf_trace_initcall_level+0x3e0/0x3e0
[   17.560773]  ? rcu_read_lock_sched_held+0xa1/0xe0
[   17.560773]  ? rcu_read_lock_bh_held+0xc0/0xc0
[   17.560773]  ? test_bit+0x2b/0x40
[   17.560773]  kernel_init_freeable+0x4d5/0x5c2
[   17.560773]  ? rest_init+0x376/0x376
[   17.560773]  kernel_init+0x12/0x1ca
[   17.560773]  ret_from_fork+0x3a/0x50
[   17.560773] Kernel Offset: disabled
[   17.560773] Rebooting in 86400 seconds..


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=128b98eae00000


Tested on:

commit:         da06441b usb: gadget: add raw-gadget interface
git tree:       https://github.com/google/kasan.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=6936f12530d77205
dashboard link: https://syzkaller.appspot.com/bug?extid=1d1597a5aa3679c65b9f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13d54536e00000

