Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3D92AFFE9
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 07:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgKLGzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 01:55:44 -0500
Received: from mout.gmx.net ([212.227.15.18]:40969 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgKLGzm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 01:55:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1605164125;
        bh=y49ULZDC8ekYC0NWLM8KMJaXtHKHpiLksdrX2M8615k=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=fQYJSKdw9teQdR/2YKdz4n/qOBkCpbsESX0ocaaGzbb6H5D0NnZW/gFI5BNpphfzm
         5Zj6eVWd9JvZ35cT+MRRBjV0bkEWUiYMwfcl/vfT7zA5DkbwMsyUjrawsraroxGSSk
         VcQwQpD/dnADrhZJU3GkWgksTcxf+DSodmh0QKjc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from zbook-opensuse.wgnetz.xx ([95.117.191.163]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MGhuK-1kZH270mh8-00DpeM; Thu, 12 Nov 2020 07:55:25 +0100
From:   Christian Eggers <ceggers@gmx.de>
To:     thunderbolt-software@lists.01.org
Cc:     Christian Kellner <christian@kellner.me>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Gil Fine <gil.fine@intel.com>, netdev@vger.kernel.org
Subject: thunderbolt: How to disconnect without physically unplugging
Date:   Thu, 12 Nov 2020 07:55:23 +0100
Message-ID: <12647082.uLZWGnKmhe@zbook-opensuse.wgnetz.xx>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:vjmg49eF4MB9/A6ZmIs3d9cfxCN7KzRR0PnM3C7wdvY/1sh3Ie4
 sfKY1mk8GlKDmOnzdfQr9g8+NN95l90KHyedAFzQHudc/V3ixYJiH+yKZuANSZulYJlowgi
 cnSNg7m36uChxtghwA2SQQhSvWLso+SBRVvyCDLIwZOwimDeidab2EQ5tWCXOaQ8+EOKQWL
 z4vxzkSunO7VIRY0c4upg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5t8+xIJr8bQ=:nDUV1vKquWHJALqZqETiR+
 MKv3UeOATD1S5G8st4ZOxEazEy0cmX5HjZYT93hjM1+on0kIcvHZZAeBlyoWAeMKsjIEs+Kg3
 SA5prffit+94LGQI6b/v4q9MRUWeYo0EROX1J8/XextGX80pD6IacZ1WOxMudrOkwKHbmVQKj
 6utcbQxN8u7qU20tjj+kWGFUujm7I9zr/mQrVKxnrCewGLIa4xaJ1SJkKo3CyxPlDKUuEKozD
 osfQmTrtsiUUbYPjIFPGFWBQVt2Hq6znGRMFdu1FYia9H37JkhZE0TjjlTCAaRo9CuHkKWaZ2
 wpIBYiebPzw8OG/PSLbvqYM8qqwyMxQjIbajMZfHrnxigDfTecURlE97tWeXETds1YBd76Vz1
 3u/aF1mwSfouOVhP255KtFBRREh6ocV7iWRdSC61VzCTBNaqxdywhXW2zr0stF1fdO6oblV6h
 W+Sol7x4X3N035grY+X16sCQR5pet6yWFHpyqjQaymwcsn9BrC7LSgAi3FWpFtlMa1SL+8bO0
 SYz5GpHHBwDyGgGugkIFy4EnredTXnmkdLYUotcqBgvhpgeKMi9Gy5rjTsBeiGkBmWbkt3PxK
 kTyEOQz4E/qKiJ3PFZPmcOL7uOftV/Cfb7g4876HiamDFdG234o1MjkVILYv1eyJFCAk7L8a9
 V2XBbzsgUSFeTtgIPkXY6fezbI2vECevw0MZYOgHbLOH9/+oUxr1ig27aXVcIoyMbx6S0tqGl
 3Nio8JVCw4Ke4WwsKwLvxpeUs5hzd1S0ouC0i7ZHZhitxP8UGfXcqWpbTCV+A8fR1iAru23Ml
 jqT5gLNgTGVt9QKO/6Lh5XAUHhYGavLwDPFRpPc1KS3Qz0yLuOe3cZFcDlNECE38wzoo3VTne
 22YO+YfCaqWqOX+1thJg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

sorry for asking "user" questions directly to developers. But I didn't fin=
d a
better place for asking.

I own a "hp zbook thunderbolt 3 dock". This docking station has 2 thunderb=
olt
connectors, the first (primary?) is connected to my personal laptop and th=
e
other port I use for my company's laptop for working at home. It seems tha=
t
only one laptop at a time can access the dock peripherals (display port,
ethernet, usb) at a time.

Unfortunately there is no button for selecting the "active" port (like on =
a KVM
switch), so the only way for switching between the two laptops is pulling =
the
cable every time (unplugging the "active" laptop for a short period lets t=
he
dock automatically switch to the "inactive" laptop).

Is there a possibility to do this "short disconnect" in software (either
- by raising an "unplug" sequence to to the thunderbolt itself, or
- by temporarily removing the thunderbolt controller from the PCI bus)?

My concern is that pulling the cables multiple times a day would wear out =
the
connectors quickly and render my hardware unusable. Additionally I see not=
 much
value having two connectors on the dock when I have to manually plug cable=
s
anyway (although the dock may offer the ability to establish a "thunderbol=
t
networking connection" between both laptops).

regards
Christian

# lspci
00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen =
Core Processor Host Bridge/DRAM Registers (rev 07)
00:02.0 VGA compatible controller: Intel Corporation HD Graphics 530 (rev =
06)
00:04.0 Signal processing controller: Intel Corporation Xeon E3-1200 v5/E3=
-1500 v5/6th Gen Core Processor Thermal Subsystem (rev 07)
00:14.0 USB controller: Intel Corporation 100 Series/C230 Series Chipset F=
amily USB 3.0 xHCI Controller (rev 31)
00:14.2 Signal processing controller: Intel Corporation 100 Series/C230 Se=
ries Chipset Family Thermal Subsystem (rev 31)
00:15.0 Signal processing controller: Intel Corporation 100 Series/C230 Se=
ries Chipset Family Serial IO I2C Controller #0 (rev 31)
00:16.0 Communication controller: Intel Corporation 100 Series/C230 Series=
 Chipset Family MEI Controller #1 (rev 31)
00:17.0 SATA controller: Intel Corporation Q170/Q150/B150/H170/H110/Z170/C=
M236 Chipset SATA Controller [AHCI Mode] (rev 31)
00:1b.0 PCI bridge: Intel Corporation 100 Series/C230 Series Chipset Famil=
y PCI Express Root Port #17 (rev f1)
00:1c.0 PCI bridge: Intel Corporation 100 Series/C230 Series Chipset Famil=
y PCI Express Root Port #1 (rev f1)
00:1c.1 PCI bridge: Intel Corporation 100 Series/C230 Series Chipset Famil=
y PCI Express Root Port #2 (rev f1)
00:1c.4 PCI bridge: Intel Corporation 100 Series/C230 Series Chipset Famil=
y PCI Express Root Port #5 (rev f1)
00:1d.0 PCI bridge: Intel Corporation 100 Series/C230 Series Chipset Famil=
y PCI Express Root Port #9 (rev f1)
00:1f.0 ISA bridge: Intel Corporation CM236 Chipset LPC/eSPI Controller (r=
ev 31)
00:1f.2 Memory controller: Intel Corporation 100 Series/C230 Series Chipse=
t Family Power Management Controller (rev 31)
00:1f.3 Audio device: Intel Corporation 100 Series/C230 Series Chipset Fam=
ily HD Audio Controller (rev 31)
00:1f.4 SMBus: Intel Corporation 100 Series/C230 Series Chipset Family SMB=
us (rev 31)
00:1f.6 Ethernet controller: Intel Corporation Ethernet Connection (2) I21=
9-LM (rev 31)
01:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SS=
D Controller SM961/PM961
02:00.0 Network controller: Intel Corporation Wireless 8260 (rev 3a)
03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS525A P=
CI Express Card Reader (rev 01)
04:00.0 PCI bridge: Intel Corporation DSL6540 Thunderbolt 3 Bridge [Alpine=
 Ridge 4C 2015]
05:00.0 PCI bridge: Intel Corporation DSL6540 Thunderbolt 3 Bridge [Alpine=
 Ridge 4C 2015]
05:01.0 PCI bridge: Intel Corporation DSL6540 Thunderbolt 3 Bridge [Alpine=
 Ridge 4C 2015]
05:02.0 PCI bridge: Intel Corporation DSL6540 Thunderbolt 3 Bridge [Alpine=
 Ridge 4C 2015]
05:04.0 PCI bridge: Intel Corporation DSL6540 Thunderbolt 3 Bridge [Alpine=
 Ridge 4C 2015]
06:00.0 System peripheral: Intel Corporation DSL6540 Thunderbolt 3 NHI [Al=
pine Ridge 4C 2015]
3b:00.0 PCI bridge: Intel Corporation DSL6540 Thunderbolt 3 Bridge [Alpine=
 Ridge 4C 2015]
3c:00.0 PCI bridge: Intel Corporation DSL6540 Thunderbolt 3 Bridge [Alpine=
 Ridge 4C 2015]
3c:01.0 PCI bridge: Intel Corporation DSL6540 Thunderbolt 3 Bridge [Alpine=
 Ridge 4C 2015]
3c:02.0 PCI bridge: Intel Corporation DSL6540 Thunderbolt 3 Bridge [Alpine=
 Ridge 4C 2015]
3c:03.0 PCI bridge: Intel Corporation DSL6540 Thunderbolt 3 Bridge [Alpine=
 Ridge 4C 2015]
3c:04.0 PCI bridge: Intel Corporation DSL6540 Thunderbolt 3 Bridge [Alpine=
 Ridge 4C 2015]
3d:00.0 USB controller: ASMedia Technology Inc. ASM1042A USB 3.0 Host Cont=
roller
3e:00.0 Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme BCM5=
7762 Gigabit Ethernet PCIe (rev 01)
6f:00.0 Non-Volatile memory controller: Toshiba Corporation NVMe Controlle=
r (rev 01)

# lspci -t -v
-[0000:00]-+-00.0  Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Co=
re Processor Host Bridge/DRAM Registers
           +-02.0  Intel Corporation HD Graphics 530
           +-04.0  Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Co=
re Processor Thermal Subsystem
           +-14.0  Intel Corporation 100 Series/C230 Series Chipset Family=
 USB 3.0 xHCI Controller
           +-14.2  Intel Corporation 100 Series/C230 Series Chipset Family=
 Thermal Subsystem
           +-15.0  Intel Corporation 100 Series/C230 Series Chipset Family=
 Serial IO I2C Controller #0
           +-16.0  Intel Corporation 100 Series/C230 Series Chipset Family=
 MEI Controller #1
           +-17.0  Intel Corporation Q170/Q150/B150/H170/H110/Z170/CM236 C=
hipset SATA Controller [AHCI Mode]
           +-1b.0-[01]----00.0  Samsung Electronics Co Ltd NVMe SSD Contro=
ller SM961/PM961
           +-1c.0-[02]----00.0  Intel Corporation Wireless 8260
           +-1c.1-[03]----00.0  Realtek Semiconductor Co., Ltd. RTS525A PC=
I Express Card Reader
           +-1c.4-[04-6e]----00.0-[05-6e]--+-00.0-[06]----00.0  Intel Corp=
oration DSL6540 Thunderbolt 3 NHI [Alpine Ridge 4C 2015]
           |                               +-01.0-[07-39]--
           |                               +-02.0-[3a]--
           |                               \-04.0-[3b-6e]----00.0-[3c-6e]-=
-+-00.0-[3d]----00.0  ASMedia Technology Inc. ASM1042A USB 3.0 Host Contro=
ller
           |                                                              =
 +-01.0-[3e]----00.0  Broadcom Inc. and subsidiaries NetXtreme BCM57762 Gi=
gabit Ethernet PCIe
           |                                                              =
 +-02.0-[3f]--
           |                                                              =
 +-03.0-[40]--
           |                                                              =
 \-04.0-[41-6e]--
           +-1d.0-[6f]----00.0  Toshiba Corporation NVMe Controller
           +-1f.0  Intel Corporation CM236 Chipset LPC/eSPI Controller
           +-1f.2  Intel Corporation 100 Series/C230 Series Chipset Family=
 Power Management Controller
           +-1f.3  Intel Corporation 100 Series/C230 Series Chipset Family=
 HD Audio Controller
           +-1f.4  Intel Corporation 100 Series/C230 Series Chipset Family=
 SMBus
           \-1f.6  Intel Corporation Ethernet Connection (2) I219-LM



