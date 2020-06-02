Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A881EC38C
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 22:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgFBUPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 16:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgFBUPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 16:15:42 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690E4C08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 13:15:41 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s10so81884pgm.0
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 13:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=9bGHNhRPovkZRMQ8MSdj78jqn5mvP6PDwPX3BGtciAc=;
        b=tgrhzaYLYWJTgOIhYOl+alBzBh7PoUks7wfF97HOpm25BBfSGIJYZPxtDqZqeKEua4
         MmNVNGWBHoWgIEs5xHDcUTBywUk/l/WlmaGL+rHwOu1+HBOyZG7thbi+0czzuefg6Vk0
         A/mFyAd1yuIWQaQ6h//vmOsxtn3hdjeOAcbIw2ZZ+PDcY6gjHQk1jaygveFxhjhNBEPF
         figLB6ICBdB2P/za6/97Bo+trSkbq61UPHZZxGW1bTFyD+lzwpOFJ4V72fq8XcW/R/3Y
         x/k5IYRNzK869sQPqSBggzCTYRGnl4/p+1+pTdRmKxQji9+KicV15GxIy1X9hzdSo5DI
         rTVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=9bGHNhRPovkZRMQ8MSdj78jqn5mvP6PDwPX3BGtciAc=;
        b=ngw570XuG47smNQJnew+hYyVlk744s4fHDIe+H2otUJq95cbBpYKyP6bXaVD8usZCU
         ZiZlgMHvh07fpJ1YDGpXhVatBqqn/yqMzfw/7M5W3uOIeXeF1+DMDhm61db8eSg5EjQ6
         ihYwVCqvVqxX51oYgX7Q9UP8E6ShUZSYWR9H176tA+Y7+Mj40ptvNZYIEZagKK3w0cHD
         nXOgsTg3gH4cLqDQR2P3/nM4jsaqGVHHY+Yc0JmmDE/7CZ2X8/lmX0sY+XgTQGfbFsM2
         iCDqtYTwE9SbBCTl0E+I0UIC+ke0zu+FAFgqEwzczR9L78urjxQWd9Ul/yQkhrrROxdR
         73Lg==
X-Gm-Message-State: AOAM532i25XK6zvT20XusgZGSc9BV/Le2IkL5/a6jZfo/DJqZpATd1vV
        JwbqIp++ry7CJUBl646Ss/v8n5IW/QU=
X-Google-Smtp-Source: ABdhPJzHvnERy3DATavxwmXh/e86kVXKqvzCD/H84z3PCOPrwMLpiAZkrtkaTTMfYJUogBWnGQQivA==
X-Received: by 2002:a63:cf17:: with SMTP id j23mr25481614pgg.373.1591128940319;
        Tue, 02 Jun 2020 13:15:40 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n24sm3059527pjt.47.2020.06.02.13.15.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 13:15:40 -0700 (PDT)
Date:   Tue, 2 Jun 2020 13:15:31 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 208033] New: r8169 wake-on-lan (WOL) works only after a
 manual suspend/resume cycle
Message-ID: <20200602131531.70ce7815@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 02 Jun 2020 19:12:51 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 208033] New: r8169 wake-on-lan (WOL) works only after a manual suspend/resume cycle


https://bugzilla.kernel.org/show_bug.cgi?id=208033

            Bug ID: 208033
           Summary: r8169 wake-on-lan (WOL) works only after a manual
                    suspend/resume cycle
           Product: Networking
           Version: 2.5
    Kernel Version: 5.6.15
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: jackdroido@gmail.com
        Regression: No

Hi !

I have a weird problem with wake-on-lan on my Realtek card.

After turning wake-on-lan flag on (using either ethtool or NetworkManager), to
make the PC responsive to wol packets I have to first suspend and wakeup it
once manually (hitting any key or power button).

After this maneuver, I can wakeup via magic packet from all subsequent suspend
transitions AND also from the first shutdown. Then I have to repeat the manual
suspend/resume cycle to make it work again.

A similar problem was mentioned at
https://forums.centos.org/viewtopic.php?t=71861, but the proposed solution
(forcing autonegotiation on) didn't work for me.

The PC is a Gigabyte NUC-like barebone:
https://www.gigabyte.com/Mini-PcBarebone/GB-BLCE-4105R-rev-10. BIOS is
up-to-date and doesn't show any "obvious" wol settings.

Here's some infos (just ask me if more are needed):

# dmesg | grep XID
[    5.738979] r8169 0000:02:00.0 eth0: RTL8168h/8111h, b4:2e:99:78:73:cf, XID
541, IRQ 126

# lspci -k
(...)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411
PCI Express Gigabit Ethernet Controller (rev 15)
        Subsystem: Gigabyte Technology Co., Ltd Onboard Ethernet
        Kernel driver in use: r8169
        Kernel modules: r8169

# lspci -vvv
(...)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411
PCI Express Gigabit Ethernet Controller (rev 15)
        Subsystem: Gigabyte Technology Co., Ltd Onboard Ethernet
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: I/O ports at e000 [size=256]
        Region 2: Memory at a1104000 (64-bit, non-prefetchable) [size=4K]
        Region 4: Memory at a1100000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v2) Endpoint, MSI 01
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns,
L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
SlotPowerLimit 10.000W
                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr+
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
Latency L0s unlimited, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s (ok), Width x1 (ok)
                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+,
NROPrPrP-, LTR+
                         10BitTagComp-, 10BitTagReq-, OBFF Via message/WAKE#,
ExtFmt-, EETLPPrefix-
                         EmergencyPowerReduction Not Supported,
EmergencyPowerReductionInit-
                         FRS-, TPHComp-, ExtTPHComp-
                         AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+,
OBFF Disabled
                         AtomicOpsCtl: ReqEn-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [b0] MSI-X: Enable+ Count=4 Masked-
                Vector table: BAR=4 offset=00000000
                PBA: BAR=4 offset=00000800
        Capabilities: [100 v2] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
AdvNonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
AdvNonFatalErr+
                AERCap: First Error Pointer: 00, ECRCGenCap+ ECRCGenEn-
ECRCChkCap+ ECRCChkEn-
                        MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                HeaderLog: 00000000 00000000 00000000 00000000
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
        Capabilities: [170 v1] Latency Tolerance Reporting
                Max snoop latency: 3145728ns
                Max no snoop latency: 3145728ns
        Capabilities: [178 v1] L1 PM Substates
                L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+
L1_PM_Substates+
                          PortCommonModeRestoreTime=150us
PortTPowerOnTime=150us
                L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
                           T_CommonMode=0us LTR1.2_Threshold=0ns
                L1SubCtl2: T_PwrOn=10us
        Kernel driver in use: r8169
        Kernel modules: r8169

# ethtool enp2s0
Settings for enp2s0:
        Supported ports: [ TP    MII ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  Not reported
        Link partner advertised pause frame use: No
        Link partner advertised auto-negotiation: No
        Link partner advertised FEC modes: No
        Speed: 100Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: MII
        PHYAD: 0
        Transceiver: external
        Supports Wake-on: pumbg
        Wake-on: g
        Current message level: 0x00000033 (51)
                               drv probe ifdown ifup
        Link detected: yes

# cat /proc/acpi/wakeup 
Device  S-state   Status   Sysfs node
SIO1      S3    *disabled  pnp:00:00
HDAS      S3    *disabled  pci:0000:00:0e.0
PRT0      S4    *disabled  no-bus:dev1.0
PRT1      S4    *disabled  no-bus:dev2.0
XHC       S4    *enabled   pci:0000:00:15.0
XDCI      S4    *disabled
RP01      S4    *disabled
PXSX      S4    *disabled
RP02      S4    *disabled
PXSX      S4    *disabled
RP03      S4    *enabled   pci:0000:00:13.0
PXSX      S4    *disabled  pci:0000:01:00.0
RP04      S4    *disabled
PXSX      S4    *disabled
RP05      S4    *enabled   pci:0000:00:13.2
PXSX      S4    *enabled   pci:0000:02:00.0
RP06      S4    *disabled
PXSX      S4    *disabled
CNVW      S4    *disabled

-- 
You are receiving this mail because:
You are the assignee for the bug.
