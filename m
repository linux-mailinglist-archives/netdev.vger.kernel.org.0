Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C7C439966
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhJYO6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbhJYO6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 10:58:22 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90DFC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:55:59 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id z11so180936plg.8
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:to:cc:subject:date:content-transfer-encoding
         :mime-version;
        bh=SMHS3X+GQwxi/OJYDcV0dxjayDc0qUU5XWO1xlXvpPY=;
        b=Pf98uherNlpmbpFyU8DTzwiA0D/+yridEX2clEp9imhJddhGSaEe0hBru2mokCvWtW
         Dds0YU22H2s1OsrmROeeDA8kFVHf5hExysiamWvepi6O13p2xEGuQMgtn4zL7L7I86Kd
         x1Y12CDfhfe7gGzK6b4iWAXWm2q51+sC0ly05rg+/TdCCRIW86NtnGiApHBcuDZtMkRA
         IanyLyI2SUFACczSDkbSJ/iSVihdJhpew+FLsIS51cosVTwLedcvNJS4xuFRmQzVNhCb
         emuv95POlupyZbK5sZ8XRDQFjKeiF9TfO+SmU8UnhviAR/7cWGP7Oj9FcUcdFH4RhYdr
         C/aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:to:cc:subject:date
         :content-transfer-encoding:mime-version;
        bh=SMHS3X+GQwxi/OJYDcV0dxjayDc0qUU5XWO1xlXvpPY=;
        b=q0ggkxcRx763r14Olvb+xHfkKbVHB3AVpvSMP1nZ3uAyU20PSeYOWQbE1INS5yx2hZ
         pucaMlwrCY0XPdhBR46DqF4m+2GcyslmNYdLx7YfjMGA/4lGlJU+B9/gZh8VsoGREYya
         xyXr/yhPOnIv0/i6yQB/9LC7Inbn0NTOaMwTFofd0th0zEBlpGF0GseyysI0l3LJySGF
         DyYse8fJIjCJQ34xCM0+4O+d3qYMLtt96GhyuCk5fzZ5ndVC3rLkXV+vGHuYuiIs2n4a
         bDggXlJCM+5m7A66H2kRnnRqcX93PIY5G5nnsltaUWjSLzls3eeuuY2IIvE9alPzf9gO
         iofw==
X-Gm-Message-State: AOAM533EAxF7iqYwyeM5Ol5/0niubHis/z0EbR0UynRlgM6UbSRLfybG
        ZyXgQH54Cj38sAk5N2H9w+H68FpMZViE
X-Google-Smtp-Source: ABdhPJxOIg5RXALu5HJ517SfFjgfHP7lO43Ir53gS3hS8qxUHDpoonGcKe+9SFfW81JFMO755zSOhw==
X-Received: by 2002:a17:90a:e505:: with SMTP id t5mr11275580pjy.33.1635173759301;
        Mon, 25 Oct 2021 07:55:59 -0700 (PDT)
Received: from localhost ([114.201.226.241])
        by smtp.gmail.com with ESMTPSA id u23sm22153177pfg.162.2021.10.25.07.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 07:55:58 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed
Message-Id: <1635173498973.1185636578.3510859947@gmail.com>
From:   Janghyub Seo <jhyub06@gmail.com>
To:     nic_swsd@realtek.com, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH] r8169: Add device 10ec:8162 to driver r8169
Date:   Mon, 25 Oct 2021 14:55:43 +0000
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch makes the driver r8169 pick up device Realtek Semiconductor Co.
, Ltd. Device [10ec:8162].

Signed-off-by: Janghyub Seo <jhyub06@gmail.com>
Suggested-by: Rushab Shah <rushabshah32@gmail.com>
---
Below is result of `lspci -nnvv` on my machine, with the following patch 
applied:

03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. Device 
[10ec:8162] (rev 05)
         Subsystem: ASUSTeK Computer Inc. Device [1043:208f]
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 57
         IOMMU group: 12
         Region 0: I/O ports at d000 [size=256]
         Region 2: Memory at fc700000 (64-bit, non-prefetchable) [size=64K]
         Region 4: Memory at fc710000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: [40] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
                 Address: 0000000000000000  Data: 0000
                 Masking: 00000000  Pending: 00000000
         Capabilities: [70] Express (v2) Endpoint, MSI 01
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <64us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- 
SlotPowerLimit 75.000W
                 DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 256 bytes, MaxReadReq 4096 bytes
                 DevSta: CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr+ 
TransPend-
                 LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Exit 
Latency L0s unlimited, L1 <64us
                         ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
                         ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 5GT/s (ok), Width x1 (ok)
                         TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ 
NROPrPrP- LTR+
                          10BitTagComp- 10BitTagReq- OBFF Via 
message/WAKE#, ExtFmt- EETLPPrefix-
                          EmergencyPowerReduction Not Supported, 
EmergencyPowerReductionInit-
                          FRS- TPHComp+ ExtTPHComp-
                          AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- 
LTR- OBFF Disabled,
                          AtomicOpsCtl: ReqEn-
                 LnkCap2: Supported Link Speeds: 2.5-5GT/s, Crosslink- 
Retimer- 2Retimers- DRS-
                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete- EqualizationPhase1-
                          EqualizationPhase2- EqualizationPhase3- 
LinkEqualizationRequest-
                          Retimer- 2Retimers- CrosslinkRes: unsupported
         Capabilities: [b0] MSI-X: Enable+ Count=32 Masked-
                 Vector table: BAR=4 offset=00000000
                 PBA: BAR=4 offset=00000800
         Capabilities: [d0] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Input/output error
                 Not readable
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
                         MultHdrRecCap- MultHdrRecEn- TLPPfxPres- 
HdrLogCap-
                 HeaderLog: 00000000 00000000 00000000 00000000
         Capabilities: [148 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
         Capabilities: [168 v1] Device Serial Number 
01-00-00-00-68-4c-e0-00
         Capabilities: [178 v1] Transaction Processing Hints
                 No steering table available
         Capabilities: [204 v1] Latency Tolerance Reporting
                 Max snoop latency: 0ns
                 Max no snoop latency: 0ns
         Capabilities: [20c v1] L1 PM Substates
                 L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ 
L1_PM_Substates+
                           PortCommonModeRestoreTime=150us 
PortTPowerOnTime=150us
                 L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
                            T_CommonMode=0us LTR1.2_Threshold=0ns
                 L1SubCtl2: T_PwrOn=10us
         Capabilities: [21c v1] Vendor Specific Information: ID=0002 Rev=4 
Len=100 <?>
         Kernel driver in use: r8169
         Kernel modules: r8169

Below is result of `lspci -nnvv` on suggester Rushab Shah's machine, 
without the following patch applied but after running `echo 10ec 8162 > 
/sys/bus/pci/drivers/r8169/new_id`:

03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. Device 
[10ec:8162] (rev 05)
	Subsystem: ASUSTeK Computer Inc. Device [1043:208f]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 78
	IOMMU group: 11
	Region 0: I/O ports at d000 [size=256]
	Region 2: Memory at fc700000 (64-bit, non-prefetchable) [size=64K]
	Region 4: Memory at fc710000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] Express (v2) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 75.000W
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 256 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s 
unlimited, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s (ok), Width x1 (ok)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ NROPrPrP- LTR+
			 10BitTagComp- 10BitTagReq- OBFF Via message/WAKE#, ExtFmt- EETLPPrefix-
			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
			 FRS- TPHComp+ ExtTPHComp-
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- LTR- OBFF 
Disabled,
			 AtomicOpsCtl: ReqEn-
		LnkCap2: Supported Link Speeds: 2.5-5GT/s, Crosslink- Retimer- 2Retimers- 
DRS-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete- 
EqualizationPhase1-
			 EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
			 Retimer- 2Retimers- CrosslinkRes: unsupported
	Capabilities: [b0] MSI-X: Enable+ Count=32 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [d0] Vital Product Data
		Not readable
	Capabilities: [100 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- 
ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- 
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ 
ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ 
ECRCChkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [148 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [168 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
	Capabilities: [178 v1] Transaction Processing Hints
		No steering table available
	Capabilities: [204 v1] Latency Tolerance Reporting
		Max snoop latency: 0ns
		Max no snoop latency: 0ns
	Capabilities: [20c v1] L1 PM Substates
		L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ 
L1_PM_Substates+
			  PortCommonModeRestoreTime=150us PortTPowerOnTime=150us
		L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
			   T_CommonMode=0us LTR1.2_Threshold=0ns
		L1SubCtl2: T_PwrOn=10us
	Capabilities: [21c v1] Vendor Specific Information: ID=0002 Rev=4 Len=100 
<?>
	Kernel driver in use: r8169

  drivers/net/ethernet/realtek/r8169_main.c | 1 +
  1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c 
b/drivers/net/ethernet/realtek/r8169_main.c
index 46a6ff9a782d..2918947dd57c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -157,6 +157,7 @@ static const struct pci_device_id rtl8169_pci_tbl[] = {
  	{ PCI_VDEVICE(REALTEK,	0x8129) },
  	{ PCI_VDEVICE(REALTEK,	0x8136), RTL_CFG_NO_GBIT },
  	{ PCI_VDEVICE(REALTEK,	0x8161) },
+	{ PCI_VDEVICE(REALTEK,	0x8162) },
  	{ PCI_VDEVICE(REALTEK,	0x8167) },
  	{ PCI_VDEVICE(REALTEK,	0x8168) },
  	{ PCI_VDEVICE(NCUBE,	0x8168) },
-- 
2.33.1

