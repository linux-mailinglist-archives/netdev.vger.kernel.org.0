Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35F9103B0
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 03:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfEABXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 21:23:21 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40458 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfEABXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 21:23:21 -0400
Received: by mail-qt1-f196.google.com with SMTP id y49so12946013qta.7
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 18:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=o9Uh4eqpzo31M/nD7QgLqjvJrp8muiIgNpQoNpAXvNU=;
        b=dBSHabVMVPMm3BUZwWxEHQ3t0mylDOoC9pmANvNmiaRNGBO53TRl9ZBImdUldA8H6/
         6JbJlWOa3kd/qlO7sig2srZYiYO/sopSOhpee8Kw0ZSlnh9jHhh3oCuoObsU6WJemb/V
         SovJQtN79MfXQZKUUxLUAwyvJWo7DV6+yRpLeLw9Wecmc9iKCZBWECQiRTBopQKkNKYV
         MbNeCd3p4257wYkgZNQhWwMNTyW/RUaRRc1NcurO2wZYA+8sZcppmN+f4VrFFaLjwph1
         /sLHWIRuHRoSFd8gK0jssDSJRfIoI1EAA3pEa92WLcBEnGqyp8IarN7+0No7fx0APHJq
         Gtvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=o9Uh4eqpzo31M/nD7QgLqjvJrp8muiIgNpQoNpAXvNU=;
        b=eKppowxILBucRB2WN5D6ai7eHtW/1fcfWeti82sQ7RxawSc7UOiUyHDbpKgmu8NAR1
         vgiswVBTl1subkD6Oih8AYyqbCc3FaICojLKH5f3MBA+A4Q4lkBoPgNqJNSn7lUMg8kN
         WT0y3e3EV4vepg4KSIw6qXBQ7IToigpVPkGMgQuWwGa6vgj+nNMwy8dfY3CHot2dXatL
         +axvCFeCRDz0RjBh+KrxB8tpkQBLvMDm2XKFT6aa3hJayflpkT/sf+ALHyZbeDd+VNgL
         +chYd589TAlrTm6qdfTbKWHwZnRR53b/NCVgQZuDLzYqt/yhecoaFHQG/tXhiz0wNoyu
         unIA==
X-Gm-Message-State: APjAAAUXPO/9OpbGTbNgrJdqeb8v0VNBd6DuvcNzo09kDys5Mte7qYou
        xHvPf6yA0gpEcQPjkTLKBAcKyw==
X-Google-Smtp-Source: APXvYqzr6nF0Zn30otpIYsGwwaP/qD9CxXCTbBf5FXTSMoImxZFKxIsRxhU9V1fMrtRTDRNLgMDuKw==
X-Received: by 2002:aed:20c3:: with SMTP id 61mr56999949qtb.356.1556673799800;
        Tue, 30 Apr 2019 18:23:19 -0700 (PDT)
Received: from ovpn-121-162.rdu2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id i9sm4449073qte.72.2019.04.30.18.23.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 18:23:18 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
Subject: mlx5_core failed to load with 5.1.0-rc7-next-20190430+
To:     kliteyn@mellanox.com
Cc:     ozsh@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux kernel <linux-kernel@vger.kernel.org>
Message-ID: <bab2ed8b-70dc-4a00-6c68-06a2df6ccb62@lca.pw>
Date:   Tue, 30 Apr 2019 21:23:17 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reverted the commit b169e64a2444 ("net/mlx5: Geneve, Add flow table capabilities
for Geneve decap with TLV options") fixed the problem below during boot ends up
without networking.

[   92.471247] mlx5_core 0000:0b:00.0: mlx5_cmd_check:744:(pid 13):
CREATE_EQ(0x301) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x8fef)
[   92.484824] mlx5_core 0000:0b:00.0: create_async_eqs:572:(pid 13): failed to
create async EQ -22
[   92.603279] mlx5_core 0000:0b:00.0: mlx5_eq_table_create:1007:(pid 13):
Failed to create async EQs
[   92.630541] mlx5_core 0000:0b:00.0: mlx5_load:1053:(pid 13): Failed to create EQs
[   94.866908] mlx5_core 0000:0b:00.0: init_one:1329:(pid 13): mlx5_load_one
failed with error code -22
[   94.879657] mlx5_core: probe of 0000:0b:00.0 failed with error -22
[   94.887784] mlx5_core 0000:0b:00.1: Adding to iommu group 2
[   95.017012] mlx5_core 0000:0b:00.1: firmware version: 14.21.1000
[   95.023090] mlx5_core 0000:0b:00.1: 63.008 Gb/s available PCIe bandwidth (8
GT/s x8 link)
[   96.155792] mlx5_core 0000:0b:00.1: mlx5_cmd_check:744:(pid 13):
CREATE_EQ(0x301) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x8fef)
[   96.169220] mlx5_core 0000:0b:00.1: create_async_eqs:572:(pid 13): failed to
create async EQ -22
[   96.199340] mlx5_core 0000:0b:00.1: mlx5_eq_table_create:1007:(pid 13):
Failed to create async EQs
[   96.224004] mlx5_core 0000:0b:00.1: mlx5_load:1053:(pid 13): Failed to create EQs
[   97.681695] mlx5_core 0000:0b:00.1: init_one:1329:(pid 13): mlx5_load_one
failed with error code -22
[   97.692749] mlx5_core: probe of 0000:0b:00.1 failed with error -22

# lspci -vvv
...
0b:00.0 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
	Subsystem: Hewlett Packard Enterprise Device 028a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	NUMA node: 0
	Region 0: Memory at 10000000000 (64-bit, prefetchable) [size=32M]
	Expansion ROM at 43000000 [disabled] [size=1M]
	Capabilities: [60] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 8GT/s, Width x8, ASPM not supported
			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not Supported
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
			 AtomicOpsCtl: ReqEn-
		LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+,
EqualizationPhase1+
			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
	Capabilities: [48] Vital Product Data
		End
	Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [c0] Vendor Specific Information: Len=18 <?>
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 04, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [150 v1] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 1
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [180 v1] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy+
		IOVSta:	Migration-
		Initial VFs: 8, Total VFs: 8, Number of VFs: 0, Function Dependency Link: 00
		VF offset: 2, stride: 1, Device ID: 1016
		Supported Page Size: 000007ff, System Page Size: 00000001
		Region 0: Memory at 0000010004800000 (64-bit, prefetchable)
		VF Migration: offset: 00000000, BIR: 0
	Capabilities: [1c0 v1] #19
	Capabilities: [230 v1] Access Control Services
		ACSCap:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl-
DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl-
DirectTrans-
	Kernel driver in use: mlx5_core
	Kernel modules: mlx5_core

0b:00.1 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
	Subsystem: Hewlett Packard Enterprise Device 028a
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 24
	NUMA node: 0
	Region 0: Memory at 10002000000 (64-bit, prefetchable) [size=32M]
	Expansion ROM at 43100000 [disabled] [size=1M]
	Capabilities: [60] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 8GT/s, Width x8, ASPM not supported
			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not Supported
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
			 AtomicOpsCtl: ReqEn-
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [48] Vital Product Data
		End
	Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [c0] Vendor Specific Information: Len=18 <?>
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 04, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [150 v1] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 0
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [180 v1] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy-
		IOVSta:	Migration-
		Initial VFs: 8, Total VFs: 8, Number of VFs: 0, Function Dependency Link: 00
		VF offset: 9, stride: 1, Device ID: 1016
		Supported Page Size: 000007ff, System Page Size: 00000001
		Region 0: Memory at 0000010004000000 (64-bit, prefetchable)
		VF Migration: offset: 00000000, BIR: 0
	Capabilities: [230 v1] Access Control Services
		ACSCap:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl-
DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl-
DirectTrans-
	Kernel driver in use: mlx5_core
	Kernel modules: mlx5_core
