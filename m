Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFDA7160A96
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 07:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgBQGh1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Feb 2020 01:37:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34896 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgBQGh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 01:37:26 -0500
Received: from mail-pl1-f200.google.com ([209.85.214.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1j3a1z-0001sj-So
        for netdev@vger.kernel.org; Mon, 17 Feb 2020 06:37:24 +0000
Received: by mail-pl1-f200.google.com with SMTP id c19so7683929plz.19
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 22:37:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=tAk3INhHUK59yBkHZybzY+Qa6XsfWJlVzY5l6vwO+aM=;
        b=V5ywM1hl5iRKxy9QmP2xgaLHCZiABnB/ScfQi0UcJ3Y5ky0WdKGNlJKYCvZ2CVgPAA
         NHB5KiT7BkuqD2aL6xIqpPlxS8VO+rZXmp8cfJQ+En7H2HLQ6vsojnW5xhnkBdjXJI7v
         QpS85g0kb6fyIzUM2SG4WptW6/Ja4AkP7YV9CHIwueGDDcuxj6KUhpMURFQx2istW96N
         TCJQavg0cMXVy+xREduQZrXiK2IlBOUNKvm02KCqNQVooEOajdrGiYLhGHSodBy3dxNl
         GF79EySEC+ntONNCbT93FJ+f6fXRlg2LYHUIBOFbTeaFOMz9TGg/H9/kvn57gXkCi1Xm
         VRAA==
X-Gm-Message-State: APjAAAVwWr+7Oydnmxf36yX2ge3BuI6jujslwqJNHOiBwF6ZYFd4kVTv
        B0QhoZm7ajl56+K2tJl0W0rYcSISvmwUoYtRDaz6iIQxJT6PpdXKbhJ8giCmZX7YO0d8wDYJd0c
        njsB3zLatKWBD7DnI0iZ9D4KE/0dC3PY8gw==
X-Received: by 2002:a17:902:6ac7:: with SMTP id i7mr14426665plt.66.1581921437371;
        Sun, 16 Feb 2020 22:37:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqzOQEu3TVJqKPSTHj2tAp7xw9aFrLgAoVVjjp7zDmq+NodZQaxFJXH992l9Thk9abTpqpEAFQ==
X-Received: by 2002:a17:902:6ac7:: with SMTP id i7mr14426635plt.66.1581921436864;
        Sun, 16 Feb 2020 22:37:16 -0800 (PST)
Received: from [10.101.46.91] (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id 144sm15515830pfc.45.2020.02.16.22.37.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Feb 2020 22:37:16 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: SFP+ support for 8168fp/8117
From:   Kai Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <995bddbc4f9d48cbb3a289a7e9799f15@realtek.com>
Date:   Mon, 17 Feb 2020 14:37:13 +0800
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <12EA7285-06D7-44D3-B033-4F52A06123CC@canonical.com>
References: <2D8F5FFE-3EC3-480B-9D15-23CACE5556DF@canonical.com>
 <20200102152143.GB1397@lunn.ch>
 <DC28A43E-4F1A-40B6-84B0-3E79215527C9@canonical.com>
 <c148fefc-fd56-26a8-9f9b-fbefbaf25050@gmail.com>
 <02F7CBDE-B877-481C-A5AF-2F4CBF830A2C@canonical.com>
 <80E9C881-91C8-4F29-B9CE-652F9EE0B018@canonical.com>
 <995bddbc4f9d48cbb3a289a7e9799f15@realtek.com>
To:     Hau <hau@realtek.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 14, 2020, at 5:07 PM, Hau <hau@realtek.com> wrote:
> 
>> Chun-Hao,
>> 
>>> On Jan 3, 2020, at 12:53, Kai-Heng Feng <kai.heng.feng@canonical.com>
>> wrote:
>>> 
>>> 
>>> 
>>>> On Jan 3, 2020, at 05:24, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>> 
>>>> On 02.01.2020 17:46, Kai-Heng Feng wrote:
>>>>> Hi Andrew,
>>>>> 
>>>>>> On Jan 2, 2020, at 23:21, Andrew Lunn <andrew@lunn.ch> wrote:
>>>>>> 
>>>>>> On Thu, Jan 02, 2020 at 02:59:42PM +0800, Kai Heng Feng wrote:
>>>>>>> Hi Heiner,
>>>>>>> 
>>>>>>> There's an 8168fp/8117 chip has SFP+ port instead of RJ45, the phy
>> device ID matches "Generic FE-GE Realtek PHY" nevertheless.
>>>>>>> The problems is that, since it uses SFP+, both BMCR and BMSR read
>> are always zero, so Realtek phylib never knows if the link is up.
>>>>>>> 
>>>>>>> However, the old method to read through MMIO correctly shows the
>> link is up:
>>>>>>> static unsigned int rtl8169_xmii_link_ok(struct rtl8169_private
>>>>>>> *tp) {
>>>>>>>    return RTL_R8(tp, PHYstatus) & LinkStatus; }
>>>>>>> 
>>>>>>> Few ideas here:
>>>>>>> - Add a link state callback for phylib like phylink's
>> phylink_fixed_state_cb(). However there's no guarantee that other parts of
>> this chip works.
>>>>>>> - Add SFP+ support for this chip. However the phy device matches to
>> "Generic FE-GE Realtek PHY" which may complicate things.
>>>>>>> 
>>>>>>> Any advice will be welcome.
>>>>>> 
>>>>>> Hi Kai
>>>>>> 
>>>>>> Is the i2c bus accessible?
>>>>> 
>>>>> I don't think so. It seems to be a regular Realtek 8168 device with generic
>> PCI ID [10ec:8168].
>>>>> 
>>>>>> Is there any documentation or example code?
>>>>> 
>>>>> Unfortunately no.
>>>>> 
>>>>>> 
>>>>>> In order to correctly support SFP+ cages, we need access to the i2c
>>>>>> bus to determine what sort of module has been inserted. It would
>>>>>> also be good to have access to LOS, transmitter disable, etc, from
>>>>>> the SFP cage.
>>>>> 
>>>>> Seems like we need Realtek to provide more information to support this
>> chip with SFP+.
>>>>> 
>>>> Indeed it would be good to have some more details how this chip
>>>> handles SFP+, therefore I add Hau to the discussion.
>>>> 
>>>> As I see it the PHY registers are simply dummies on this chip. Or
>>>> does this chip support both, PHY and SFP+? Hopefully SFP presence can
>>>> be autodetected, we could skip the complete PHY handling in this
>>>> case. Interesting would be which parts of the SFP interface are exposed
>> how via (proprietary) registers.
>>>> Recently the STMMAC driver was converted from phylib to phylink,
>>>> maybe we have to do the same with r8169 one fine day. But w/o more
>>>> details this is just speculation, much appreciated would be
>>>> documentation from Realtek about the
>>>> SFP+ interface.
>>>> 
>>>> Kai, which hardware/board are we talking about?
>>> 
>>> It's a regular Intel PC.
>>> 
>>> The ethernet is function 1 of the PCI device, function 0 isn't bound to any
>> driver:
>>> 02:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
>>> Device [10ec:816e] (rev 1a)
>>> 02:00.1 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
>>> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168]
>>> (rev 22)
>> 
>> Would it be possible to share some info on SFP support?
> Hi Kai-Heng,
> 
> Could you use r8168 to dump hardware info with following command.
> cat /proc/net/r8168/ethx/*
> 
> I want to make sure which chip you use and try to add support it in r8168/r8169.


Dump Driver Variable
Variable	Value
----------	-----
MODULENAME	r8168
driver version	8.048.00-NAPI
chipset	31
chipset_name	RTL8168FP/8111FP
mtu	1500
NUM_RX_DESC	0x400
cur_rx	0x0
dirty_rx	0x0
NUM_TX_DESC	0x400
cur_tx	0x0
dirty_tx	0x0
rx_buf_sz	0x5f3
esd_flag	0x0
pci_cfg_is_read	0x1
rtl8168_rx_config	0xcf00
cp_cmd	0x20e1
intr_mask	0x115
timer_intr_mask	0x4000
wol_enabled	0x1
wol_opts	0x20
efuse_ver	0x3
eeprom_type	0x0
autoneg	0x1
duplex	0x1
speed	1000
advertising	0x3f
eeprom_len	0x0
cur_page	0x0
bios_setting	0x0
features	0x2
org_pci_offset_99	0x0
org_pci_offset_180	0xf
issue_offset_99_event	0x0
org_pci_offset_80	0x42
org_pci_offset_81	0x1
use_timer_interrrupt	0x1
HwIcVerUnknown	0x0
NotWrRamCodeToMicroP	0x0
NotWrMcuPatchCode	0x0
HwHasWrRamCodeToMicroP	0x0
sw_ram_code_ver	0x3
hw_ram_code_ver	0x0
rtk_enable_diag	0x0
ShortPacketSwChecksum	0x0
UseSwPaddingShortPkt	0x0
RequireAdcBiasPatch	0x0
AdcBiasPatchIoffset	0x0
RequireAdjustUpsTxLinkPulseTiming	0x0
SwrCnt1msIni	0x0
HwSuppNowIsOobVer	0x1
HwFiberModeVer	0x0
HwFiberStat	0x0
HwSwitchMdiToFiber	0x0
NicCustLedValue	0xca9
RequiredSecLanDonglePatch	0x0
HwSuppDashVer	0x3
DASH	0x1
dash_printer_enabled	0x0
HwSuppKCPOffloadVer	0x0
speed_mode	0x3e8
duplex_mode	0x1
autoneg_mode	0x1
advertising_mode	0x3f
aspm	0x1
s5wol	0x1
s5_keep_curr_mac	0x0
eee_enable	0x0
hwoptimize	0x0
proc_init_num	0x2
s0_magic_packet	0x0
HwSuppMagicPktVer	0x2
HwSuppCheckPhyDisableModeVer	0x3
HwPkgDet	0x6
HwSuppGigaForceMode	0x1
random_mac	0x0
org_mac_addr	54:b2:03:86:1b:40
perm_addr	54:b2:03:86:1b:40
dev_addr	54:b2:03:86:1b:40


Dump Ethernet PHY

Offset	Value
------	-----
 
####################page 0##################
 
0x00:	1040 7989 001c c800 0de1 0000 0064 2001 
0x08:	0000 0200 0000 0000 0000 0000 0000 2000 

Dump Extended Registers

Offset	Value
------	-----
 
0x00:	00000000 00000000 00000000 00000000 
0x10:	00000000 00000000 00000000 00000000 
0x20:	00000000 00000000 00000000 00000000 
0x30:	00000000 00000000 00000000 00000000 
0x40:	00000000 00000000 00000000 00000000 
0x50:	00000000 00000000 00000000 00000000 
0x60:	00000000 00000000 00000000 00000000 
0x70:	00000000 00000000 00000000 00000000 
0x80:	00000000 00000000 00000000 00000000 
0x90:	00000000 00000000 00000000 00000000 
0xa0:	00000000 00000000 00000000 00000000 
0xb0:	00000000 00000000 00000000 00000000 
0xc0:	00000000 00000000 00080002 0000002f 
0xd0:	0000005f 00001f92 00000000 001e0021 
0xe0:	8603b254 0000401b 00100006 00000200 
0xf0:	b2540000 401b8603 00000000 00000000 

Dump PCIE PHY

Offset	Value
------	-----
 
0x00:	a800 7a58 3cee 2e46 10f0 0004 0000 2600 
0x08:	6443 3318 0cc3 60b0 11e1 0400 3713 9c20 
0x10:	000c 4c00 fc01 0c81 de01 0000 0000 0000 
0x18:	0000 fd01 0312 0ea1 0000 0000 24eb 

Dump PCI Registers

Offset	Value
------	-----
 
0x000:	816810ec 00100407 02000022 00800010 
0x010:	0000d001 00000000 a1108004 00000000 
0x020:	a1100004 00000000 00000000 03441854 
0x030:	00000000 00000040 00000000 000001ff 
0x040:	ffc35001 00000008 00000000 00000000 
0x050:	00817005 fee01004 00000000 00004024 
0x060:	00000000 00000000 00000000 00000000 
0x070:	0202b010 05908ce0 001b5110 00477c12 
0x080:	10120142 00000000 00000000 00000000 
0x090:	00000000 000c181f 00000000 00000006 
0x0a0:	00010000 00000000 00000000 00000000 
0x0b0:	00030011 00000004 00000804 00000000 
0x0c0:	00000000 00000000 00000000 00000000 
0x0d0:	00000003 00000000 00000000 00000000 
0x0e0:	00000000 00000000 00000000 00000000 
0x0f0:	00000000 00000000 00000000 00000000 
0x110:	00002081 
0x70c:	27ffff01 

Dump MAC Registers
Offset	Value
------	-----

0x00:	54 b2 03 86 1b 40 00 00 00 00 00 00 80 00 00 00 
0x10:	00 00 6f 79 01 00 00 00 a9 0c 06 00 00 00 00 00 
0x20:	00 80 99 76 01 00 00 00 00 00 00 00 00 00 00 00 
0x30:	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
0x40:	80 0f a0 57 0e cf 02 00 00 00 00 00 00 00 00 00 
0x50:	10 00 cf 9c 60 11 03 04 00 00 00 00 00 00 00 00 
0x60:	00 00 00 00 00 00 00 01 70 f1 01 80 91 00 80 f0 
0x70:	00 00 00 00 fc f0 00 bf 07 00 00 00 00 00 67 1e 
0x80:	eb 24 1e 80 00 00 00 00 00 00 00 00 00 00 00 00 
0x90:	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
0xa0:	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
0xb0:	00 00 00 00 00 00 00 00 00 20 0f d2 00 00 00 00 
0xc0:	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
0xd0:	e1 00 00 32 ac 00 01 00 00 00 f3 05 40 7f b1 00 
0xe0:	e1 20 51 5f 00 c0 99 76 01 00 00 00 3f 00 00 00 
0xf0:	00 80 40 00 00 00 00 00 ff ff ff ff 00 00 00 00 

Dump Tally Counter
Statistics	Value
----------	-----
tx_packets	0
rx_packets	0
tx_errors	0
rx_missed	0
align_errors	0
tx_one_collision	0
tx_multi_collision	0
rx_unicast	0
rx_broadcast	0
rx_multicast	0
tx_aborted	0
tx_underun	0


> 
> Hau
>> 
>> Kai-Heng
>> 
>>> 
>>> Kai-Heng
>>> 
>>>> 
>>>>> Kai-Heng
>>>>> 
>>>>>> 
>>>>>> Andrew
>>>>> 
>>>> Heiner
>>> 
>> 
>> 
>> ------Please consider the environment before printing this e-mail.

