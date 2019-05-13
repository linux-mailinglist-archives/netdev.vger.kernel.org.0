Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35A51BEE2
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 22:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfEMU6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 16:58:08 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:50197 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfEMU6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 16:58:07 -0400
Received: by mail-io1-f72.google.com with SMTP id t7so10790614iod.17
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 13:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8FT53rgyGg5gVZTjVRGlE1PW0QSMTx3+9FcWF+KtWEE=;
        b=s8B8FcruvCIvCH+emw4LEEfIkADSEO8jgqOtnIRhEhovqbAlBevX7k1wk4fUnbwdkP
         olEINlMoNbY0sA9varaAINBjWFFCcvbY70h/NMMYF46sVOzNra/X1/rI1zeFKmTryVMz
         W181Vorn5L0pUgoOBWldBuknFNeownjm4qFoO9U1srYEOM3slTEJT/HCjmj08TKdPjPm
         asT7QXw1ISCulF2ADi/+64nR1kpOR0LTHjWSGQyBZJlpvfcKvlJxNwiw+tAZx2avTYxz
         hERtxTrnYqkCpHFrzFwkDfu8Nw+0ZjCpz+Z8ZLBpwxNJyCI1xqNqFuBbJtFnSmGsOWve
         8HvQ==
X-Gm-Message-State: APjAAAUnHXorrEg5jldS88TBuPeiOMe2N978VmyS/2rNxXQvrYxrEXy6
        IjzI6Y6bv8e0wb7x0PdGZP1Goz8m5FRZT2HTpMOAvpan6mle
X-Google-Smtp-Source: APXvYqxNHLc9pmNKOBWQqgiDbWARyKZ1/ALIv1rzJy0iTPbaFq7ptMY6XBm5NFQv8ajEVtmb2E0apA9NjphbxAua+R1iH/YZQU75
MIME-Version: 1.0
X-Received: by 2002:a5d:899a:: with SMTP id m26mr367889iol.268.1557781087045;
 Mon, 13 May 2019 13:58:07 -0700 (PDT)
Date:   Mon, 13 May 2019 13:58:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000054d5650588cb2c27@google.com>
Subject: bpf-next boot error: WARNING: workqueue cpumask: online intersect >
 possible intersect
From:   syzbot <syzbot+9e532f90f6ca82f39854@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    80f23212 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=129cb09ca00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=62ac41ed59f810ed
dashboard link: https://syzkaller.appspot.com/bug?extid=9e532f90f6ca82f39854
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9e532f90f6ca82f39854@syzkaller.appspotmail.com

smpboot: CPU0: Intel(R) Xeon(R) CPU @ 2.30GHz (family: 0x6, model: 0x3f,  
stepping: 0x0)
Performance Events: unsupported p6 CPU model 63 no PMU driver, software  
events only.
rcu: Hierarchical SRCU implementation.
NMI watchdog: Perf NMI watchdog permanently disabled
smp: Bringing up secondary CPUs ...
x86: Booting SMP configuration:
.... node  #0, CPUs:      #1
smp: Brought up 2 nodes, 2 CPUs
smpboot: Max logical packages: 1
smpboot: Total of 2 processors activated (9200.00 BogoMIPS)
devtmpfs: initialized
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns:  
19112604462750000 ns
futex hash table entries: 512 (order: 4, 65536 bytes)
xor: automatically using best checksumming function   avx
PM: RTC time: 18:40:55, date: 2019-05-13
NET: Registered protocol family 16
audit: initializing netlink subsys (disabled)
cpuidle: using governor menu
ACPI: bus type PCI registered
dca service started, version 1.12.1
PCI: Using configuration type 1 for base access
WARNING: workqueue cpumask: online intersect > possible intersect
HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
cryptd: max_cpu_qlen set to 1000
raid6: avx2x4   gen() 11967 MB/s
raid6: avx2x4   xor()  6567 MB/s
raid6: avx2x2   gen()  6083 MB/s
raid6: avx2x2   xor()  3848 MB/s
raid6: avx2x1   gen()   938 MB/s
raid6: avx2x1   xor()  2067 MB/s
raid6: sse2x4   gen()  6232 MB/s
raid6: sse2x4   xor()  3350 MB/s
raid6: sse2x2   gen()  3820 MB/s
raid6: sse2x2   xor()  1916 MB/s
raid6: sse2x1   gen()   688 MB/s
raid6: sse2x1   xor()  1011 MB/s
raid6: using algorithm avx2x4 gen() 11967 MB/s
raid6: .... xor() 6567 MB/s, rmw enabled
raid6: using avx2x2 recovery algorithm
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Added _OSI(Linux-Dell-Video)
ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
ACPI: 2 ACPI AML tables successfully acquired and loaded
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and  
report a bug
ACPI: Enabled 16 GPEs in block 00 to 0F
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended  
PCI configuration space under this bridge.
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff window]
pci_bus 0000:00: root bus resource [bus 00-ff]
pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
vgaarb: loaded
SCSI subsystem initialized
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
media: Linux media interface: v0.10
videodev: Linux video capture interface: v2.00
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti  
<giometti@linux.it>
PTP clock support registered
EDAC MC: Ver: 3.0.0
Advanced Linux Sound Architecture Driver Initialized.
PCI: Using ACPI for IRQ routing
Bluetooth: Core ver 2.22
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
NET: Registered protocol family 8
NET: Registered protocol family 20
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
NetLabel:  unlabeled traffic allowed by default
nfc: nfc_init: NFC Core ver 0.1
NET: Registered protocol family 39
clocksource: Switched to clocksource kvm-clock
VFS: Disk quotas dquot_6.6.0
VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
FS-Cache: Loaded
*** VALIDATE hugetlbfs ***
CacheFiles: Loaded
TOMOYO: 2.6.0
Profile 0 (used by '<kernel>') is not defined.
Userland tools for TOMOYO 2.6 must be installed and policy must be  
initialized.
Please see https://tomoyo.osdn.jp/2.6/ for more information.


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
