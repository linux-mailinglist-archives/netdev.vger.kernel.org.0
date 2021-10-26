Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7F743ACF4
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 09:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhJZHPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 03:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235349AbhJZHPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 03:15:30 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9F5C061225
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 00:12:59 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r2so13216374pgl.10
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 00:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:to:cc:subject:date:content-transfer-encoding
         :mime-version;
        bh=ezlvCMgH5PtgL+1nmxPkdTqZTgskHmTqbepsXqz/qt4=;
        b=ZFXN6HAafHoaEdvcWumSpEsczo+FudL0hlTAz9Bk60OrapfQuOpqBk1+ryQnnOq7v3
         1W9aj8GLsxLGvMZWQAT5uDwPWMU4kVZfYBYWQrKrhb3E/qywvAaBBxd4w++/Vc3dcMmY
         WJSeJgzXjryvqiiOpmLfBbOLKyoQix5TxdldTDZmvnzHtT6bTKfizR83Z27oE50w7oE7
         BQVE5XfpyRXzWxKx8i+Xr70+Cg5wmuAZxMWDJHmaeK/e3Eq53XmdF3sTmKbV503iksRb
         8OZJ1LnERSLIEXbLLK3lajqVN4BXgu21cnqTf+aMIoSAGQe/WebLUYGETmisGH9Eostx
         XcFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:to:cc:subject:date
         :content-transfer-encoding:mime-version;
        bh=ezlvCMgH5PtgL+1nmxPkdTqZTgskHmTqbepsXqz/qt4=;
        b=QUE+1yCoJvKzcuRP47J6Tup5Xx7BHsQIlu5utGrPyqq8Sx/AJAHxE6nQ/JAeJBffCp
         +phgTmnMYm2xzhGpKMk1N1l70czAohQjZh3sszI2GfJgUN7Pi0vYYgHaw/ZeA9/Vw0qY
         srxa2vfEOi5720tlyM2G8+YYmr/y0S+iyoTI6fVR4K5OAZWQJMwyccwbA+6n7mP3ncZS
         zXqk6OrE0wjRB3qPgDqtQdp1Sg6+TXwoKMaRaasj7nkcdY17+PPtpt9Php9EguMAXD5Y
         SBga3QBXUBagbeeqxJCNLBeUXtNzJWnoYBtAB9ycXrlguc+sZkxZn0RGhhohh/aVa43K
         hIyA==
X-Gm-Message-State: AOAM531Yx31L34xCM+VoPIpydd9aax66/btuBOayBEONpLXDzRyG/BaG
        aLb2YPM2vfG0WDWqjv0iJg==
X-Google-Smtp-Source: ABdhPJzNB3Hzf80y0FYGITpcwbOGdxmeDf0k00YsucRKP6qP+FSfZuRdGiHh8hQdGq7ngSbjP7zoKQ==
X-Received: by 2002:a05:6a00:1709:b0:44d:faf3:ef2d with SMTP id h9-20020a056a00170900b0044dfaf3ef2dmr23814368pfc.43.1635232378451;
        Tue, 26 Oct 2021 00:12:58 -0700 (PDT)
Received: from localhost ([114.201.226.241])
        by smtp.gmail.com with ESMTPSA id me3sm6544748pjb.3.2021.10.26.00.12.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 00:12:58 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed
Message-Id: <1635231849296.1489250046.441294000@gmail.com>
From:   Janghyub Seo <jhyub06@gmail.com>
To:     nic_swsd@realtek.com, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2] r8169:  Add device 10ec:8162 to driver r8169
Date:   Tue, 26 Oct 2021 07:12:42 +0000
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
v2: rebased on top of 
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/

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
---
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

