Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E91543A4B3
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbhJYUab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbhJYUaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:30:30 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4049C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 13:28:07 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id z14so13858870wrg.6
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 13:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CrseSsIN3gGcmGh1Bkj0VTH8TDZ98/KEmc7OElVs92g=;
        b=bchZwvvZGJrvJz0P1i/WdXlfkpPvvg9AqV6W1GIvFYVjgLG/ceU0zNgJrRyj+xFr0c
         VWR/bL30/xlDEZ4okLKFO8XSfk2LLd+1beZaMjAdbmpCgl5On+vyF/6pu0SAR9kH61F5
         9jfiCQOnM9LGx6qhOof6AE/M4/4eRkP0R3kzH1ehhp3jYgtm/kGeAX0bLagddNPkA/f2
         pWjgOqvxyFy6XStzgif5Y/laBvYtNALiw1KU4xt6YNob4uqmhZ2hpKcyajoz1f3qIF6R
         eqVQF8YOsAmd7I6HUHFhRN8DAo2X33ToujWbhTefd/pxeZ1rK1vZ0ZA3aOQQx17VUtFS
         8NSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CrseSsIN3gGcmGh1Bkj0VTH8TDZ98/KEmc7OElVs92g=;
        b=vTbSlFEXpgU4SKRZxIUIWDtndX+eOSrRVh7dWiYoDBrYzqd9n7Q6C9rKGvSJbujJFk
         mUqwZur6DX48FH7k480grmkhGqli9UdgKJ344495y0XdwiuHpuY2ll7IlL3M7Zljn9sW
         Z/vmpFmSU9ADjyZDLzCc6mKurSP3tui6O88ado2zjPJdFSbSNrhOgXK0pC6D8s0Ws1NS
         JKe6nLMKK9bzlGJExWXzaDwXzsxF7M72lcKHcl7G1YUeopcoJKB0LP7sEIoGgOtX0kZk
         OfGwni1//wjfSsXZzUDAwHy9o0bWIiKQcAzN6jxtwpHGtOjUyzrD+02VcVn+H/4iH1pU
         mjFA==
X-Gm-Message-State: AOAM532c+w2KEIpBYK5ZOSF9JWFf7me1AOrVivtG7e/aqBZq7/R5lJwT
        Dw1/3t8upJPlmhSjE23yPsVwLVigig4=
X-Google-Smtp-Source: ABdhPJxpL7OBcZTEsujt2jcQv8yABJH0J8Z4F+kVBhXPNUK157uwMhypfsxIJPOLuDok0S5lrt3NIw==
X-Received: by 2002:a05:6000:128f:: with SMTP id f15mr26176773wrx.143.1635193686581;
        Mon, 25 Oct 2021 13:28:06 -0700 (PDT)
Received: from ?IPV6:2003:ea:8f1a:f00:f8b4:d976:9fed:ad5b? (p200300ea8f1a0f00f8b4d9769fedad5b.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:f8b4:d976:9fed:ad5b])
        by smtp.googlemail.com with ESMTPSA id f20sm19993940wmq.38.2021.10.25.13.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 13:28:04 -0700 (PDT)
Message-ID: <ab517ec9-4930-474f-eb7e-34548afd5aaa@gmail.com>
Date:   Mon, 25 Oct 2021 22:27:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] r8169: Add device 10ec:8162 to driver r8169
Content-Language: en-US
To:     Janghyub Seo <jhyub06@gmail.com>, nic_swsd@realtek.com
Cc:     netdev@vger.kernel.org
References: <1635173498973.1185636578.3510859947@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <1635173498973.1185636578.3510859947@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.10.2021 16:55, Janghyub Seo wrote:
> 
> This patch makes the driver r8169 pick up device Realtek Semiconductor Co.
> , Ltd. Device [10ec:8162].
> 

Interesting that still new PCI ID's are assigned. Can you post the output
of dmesg | grep r8169 ? I'd be interested to know which chip version this is.
What kind of system is this? 


> Signed-off-by: Janghyub Seo <jhyub06@gmail.com>
> Suggested-by: Rushab Shah <rushabshah32@gmail.com>
> ---
> Below is result of `lspci -nnvv` on my machine, with the following patch applied:
> 
> 03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. Device [10ec:8162] (rev 05)
>         Subsystem: ASUSTeK Computer Inc. Device [1043:208f]
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 57
>         IOMMU group: 12
>         Region 0: I/O ports at d000 [size=256]
>         Region 2: Memory at fc700000 (64-bit, non-prefetchable) [size=64K]
>         Region 4: Memory at fc710000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: [40] Power Management version 3
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
>                 Address: 0000000000000000  Data: 0000
>                 Masking: 00000000  Pending: 00000000
>         Capabilities: [70] Express (v2) Endpoint, MSI 01
>                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 75.000W
>                 DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 256 bytes, MaxReadReq 4096 bytes
>                 DevSta: CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr+ TransPend-
>                 LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s unlimited, L1 <64us
>                         ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
>                 LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
>                         ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 5GT/s (ok), Width x1 (ok)
>                         TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ NROPrPrP- LTR+
>                          10BitTagComp- 10BitTagReq- OBFF Via message/WAKE#, ExtFmt- EETLPPrefix-
>                          EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
>                          FRS- TPHComp+ ExtTPHComp-
>                          AtomicOpsCap: 32bit- 64bit- 128bitCAS-
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- LTR- OBFF Disabled,
>                          AtomicOpsCtl: ReqEn-
>                 LnkCap2: Supported Link Speeds: 2.5-5GT/s, Crosslink- Retimer- 2Retimers- DRS-
>                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>                          Compliance De-emphasis: -6dB
>                 LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete- EqualizationPhase1-
>                          EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
>                          Retimer- 2Retimers- CrosslinkRes: unsupported
>         Capabilities: [b0] MSI-X: Enable+ Count=32 Masked-
>                 Vector table: BAR=4 offset=00000000
>                 PBA: BAR=4 offset=00000800
>         Capabilities: [d0] Vital Product Data
> pcilib: sysfs_read_vpd: read failed: Input/output error
>                 Not readable
>         Capabilities: [100 v2] Advanced Error Reporting
>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
>                 AERCap: First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
>                         MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
>                 HeaderLog: 00000000 00000000 00000000 00000000
>         Capabilities: [148 v1] Virtual Channel
>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                 Arb:    Fixed- WRR32- WRR64- WRR128-
>                 Ctrl:   ArbSelect=Fixed
>                 Status: InProgress-
>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>                         Status: NegoPending- InProgress-
>         Capabilities: [168 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
>         Capabilities: [178 v1] Transaction Processing Hints
>                 No steering table available
>         Capabilities: [204 v1] Latency Tolerance Reporting
>                 Max snoop latency: 0ns
>                 Max no snoop latency: 0ns
>         Capabilities: [20c v1] L1 PM Substates
>                 L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
>                           PortCommonModeRestoreTime=150us PortTPowerOnTime=150us
>                 L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
>                            T_CommonMode=0us LTR1.2_Threshold=0ns
>                 L1SubCtl2: T_PwrOn=10us
>         Capabilities: [21c v1] Vendor Specific Information: ID=0002 Rev=4 Len=100 <?>
>         Kernel driver in use: r8169
>         Kernel modules: r8169
> 
> Below is result of `lspci -nnvv` on suggester Rushab Shah's machine, without the following patch applied but after running `echo 10ec 8162 > /sys/bus/pci/drivers/r8169/new_id`:
> 
> 03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. Device [10ec:8162] (rev 05)
>     Subsystem: ASUSTeK Computer Inc. Device [1043:208f]
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>     Latency: 0, Cache Line Size: 64 bytes
>     Interrupt: pin A routed to IRQ 78
>     IOMMU group: 11
>     Region 0: I/O ports at d000 [size=256]
>     Region 2: Memory at fc700000 (64-bit, non-prefetchable) [size=64K]
>     Region 4: Memory at fc710000 (64-bit, non-prefetchable) [size=16K]
>     Capabilities: [40] Power Management version 3
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
>         Address: 0000000000000000  Data: 0000
>         Masking: 00000000  Pending: 00000000
>     Capabilities: [70] Express (v2) Endpoint, MSI 01
>         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
>             ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 75.000W
>         DevCtl:    CorrErr- NonFatalErr- FatalErr- UnsupReq-
>             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>             MaxPayload 256 bytes, MaxReadReq 4096 bytes
>         DevSta:    CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
>         LnkCap:    Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s unlimited, L1 <64us
>             ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
>         LnkCtl:    ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
>             ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>         LnkSta:    Speed 5GT/s (ok), Width x1 (ok)
>             TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>         DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ NROPrPrP- LTR+
>              10BitTagComp- 10BitTagReq- OBFF Via message/WAKE#, ExtFmt- EETLPPrefix-
>              EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
>              FRS- TPHComp+ ExtTPHComp-
>              AtomicOpsCap: 32bit- 64bit- 128bitCAS-
>         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- LTR- OBFF Disabled,
>              AtomicOpsCtl: ReqEn-
>         LnkCap2: Supported Link Speeds: 2.5-5GT/s, Crosslink- Retimer- 2Retimers- DRS-
>         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
>              Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>              Compliance De-emphasis: -6dB
>         LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete- EqualizationPhase1-
>              EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
>              Retimer- 2Retimers- CrosslinkRes: unsupported
>     Capabilities: [b0] MSI-X: Enable+ Count=32 Masked-
>         Vector table: BAR=4 offset=00000000
>         PBA: BAR=4 offset=00000800
>     Capabilities: [d0] Vital Product Data
>         Not readable
>     Capabilities: [100 v2] Advanced Error Reporting
>         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>         UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
>         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
>         AERCap:    First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
>             MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
>         HeaderLog: 00000000 00000000 00000000 00000000
>     Capabilities: [148 v1] Virtual Channel
>         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
>         Arb:    Fixed- WRR32- WRR64- WRR128-
>         Ctrl:    ArbSelect=Fixed
>         Status:    InProgress-
>         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>             Status:    NegoPending- InProgress-
>     Capabilities: [168 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
>     Capabilities: [178 v1] Transaction Processing Hints
>         No steering table available
>     Capabilities: [204 v1] Latency Tolerance Reporting
>         Max snoop latency: 0ns
>         Max no snoop latency: 0ns
>     Capabilities: [20c v1] L1 PM Substates
>         L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
>               PortCommonModeRestoreTime=150us PortTPowerOnTime=150us
>         L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
>                T_CommonMode=0us LTR1.2_Threshold=0ns
>         L1SubCtl2: T_PwrOn=10us
>     Capabilities: [21c v1] Vendor Specific Information: ID=0002 Rev=4 Len=100 <?>
>     Kernel driver in use: r8169
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 46a6ff9a782d..2918947dd57c 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -157,6 +157,7 @@ static const struct pci_device_id rtl8169_pci_tbl[] = {
>      { PCI_VDEVICE(REALTEK,    0x8129) },
>      { PCI_VDEVICE(REALTEK,    0x8136), RTL_CFG_NO_GBIT },
>      { PCI_VDEVICE(REALTEK,    0x8161) },
> +    { PCI_VDEVICE(REALTEK,    0x8162) },
>      { PCI_VDEVICE(REALTEK,    0x8167) },
>      { PCI_VDEVICE(REALTEK,    0x8168) },
>      { PCI_VDEVICE(NCUBE,    0x8168) },

