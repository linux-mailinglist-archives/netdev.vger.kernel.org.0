Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FAF32173D
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhBVMop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:44:45 -0500
Received: from regular1.263xmail.com ([211.150.70.202]:46326 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhBVMnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 07:43:35 -0500
Received: from localhost (unknown [192.168.167.224])
        by regular1.263xmail.com (Postfix) with ESMTP id 8FFEC6DF;
        Mon, 22 Feb 2021 20:37:11 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from [10.20.32.136] (unknown [61.183.83.60])
        by smtp.263.net (postfix) whith ESMTP id P17592T140304516622080S1613997418087359_;
        Mon, 22 Feb 2021 20:37:11 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <7279b217e2a45cb39a118c7eabfb8cd2>
X-RL-SENDER: chenhaoa@uniontech.com
X-SENDER: chenhaoa@uniontech.com
X-LOGIN-NAME: chenhaoa@uniontech.com
X-FST-TO: zhanjun@uniontech.com
X-SENDER-IP: 61.183.83.60
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
Subject: Re: [PATCH] rtw88: 8822ce: fix wifi disconnect after S3/S4 on HONOR
 laptop
To:     Pkshih <pkshih@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        Timlee <timlee@realtek.com>, "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        zhanjun@uniontech.com
References: <20210220084602.22386-1-chenhaoa@uniontech.com>
 <878s7jjeeh.fsf@codeaurora.org>
 <1323517535.1654941.1613976259730.JavaMail.xmail@bj-wm-cp-15>
 <874ki4k1ej.fsf@codeaurora.org> <1613992840.2331.8.camel@realtek.com>
From:   Hao Chen <chenhaoa@uniontech.com>
Message-ID: <4ab0ff2e-4f56-6f16-4e67-26f19de92a14@uniontech.com>
Date:   Mon, 22 Feb 2021 20:36:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1613992840.2331.8.camel@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi:

I have tried setting module parameter disable_aspm=1, but it's not useful.

 >The cpu info is follow:

uos@uos-PC:~$ lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
Address sizes:       48 bits physical, 48 bits virtual
CPU(s):              6
On-line CPU(s) list: 0-5
Thread(s) per core:  1
Core(s) per socket:  6
Socket(s):           1
NUMA node(s):        1
Vendor ID:           AuthenticAMD
CPU family:          23
Model:               96
Model name:          AMD Ryzen 5 4500U with Radeon Graphics
Stepping:            1
CPU MHz:             2375.000
CPU max MHz:         2375.0000
CPU min MHz:         1400.0000
BogoMIPS:            4740.81
Virtualization:      AMD-V
L1d cache:           32K
L1i cache:           32K
L2 cache:            512K
L3 cache:            4096K
NUMA node0 CPU(s):   0-5
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr 
pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit 
wdt tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
cat_l3 cdp_l3 hw_pstate ssbd mba ibrs ibpb stibp vmmcall fsgsbase bmi1 
avx2 smep bmi2 cqm rdt_a rdseed adx smap clflushopt clwb sha_ni xsaveopt 
xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local 
clzero irperf xsaveerptr rdpru wbnoinvd arat npt lbrv svm_lock nrip_save 
tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold 
avic v_vmsave_vmload vgif umip rdpid overflow_recov succor smca


 >The pci bridge info is follow:

uos@uos-PC:~$ sudo lspci -vvv -s 00:01.0
00:01.0 PCI bridge: Intel Corporation 6th-9th Gen Core Processor PCIe 
Controller (x16) (rev 05) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 121
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
         I/O behind bridge: 00003000-00003fff
         Memory behind bridge: a0200000-a02fffff
         Prefetchable memory behind bridge: 
00000000b0000000-00000000bfffffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [88] Subsystem: ASRock Incorporation Xeon E3-1200 
v5/E3-1500 v5/6th Gen Core Processor PCIe Controller (x16)
         Capabilities: [80] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                 Address: fee00258  Data: 0000
         Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0
                         ExtTag- RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 256 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #2, Speed 8GT/s, Width x16, ASPM L0s L1, 
Exit Latency L0s <256ns, L1 <8us
                         ClockPM- Surprise- LLActRep- BwNot+ ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk+ 
DLActive- BWMgmt+ ABWMgmt+
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug- Surprise-
                         Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet+ LinkState-
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR+, OBFF Via WAKE# ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR+, OBFF Via WAKE# ARIFwd-
                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete+, EqualizationPhase1+
                          EqualizationPhase2+, EqualizationPhase3+, 
LinkEqualizationRequest-
         Capabilities: [100 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                         Status: NegoPending- InProgress-
         Capabilities: [140 v1] Root Complex Link
                 Desc:   PortNumber=02 ComponentID=01 EltType=Config
                 Link0:  Desc:   TargetPort=00 TargetComponent=01 
AssocRCRB- LinkType=MemMapped LinkValid+
                         Addr:   00000000fed19000
         Capabilities: [d94 v1] #19
         Kernel driver in use: pcieport


在 2021/2/22 下午7:20, Pkshih 写道:
> On Mon, 2021-02-22 at 09:27 +0200, Kalle Valo wrote:
>> 陈浩 <chenhaoa@uniontech.com> writes:
>>
>>> By git blame command, I know that the assignment of .driver.pm =
>>> RTW_PM_OPS
>>>
>>> was in commit 44bc17f7f5b3b("rtw88: support wowlan feature for
>>> 8822c"),
>>>
>>> and another commit 7dc7c41607d19("avoid unused function warnings")
>>>
>>> pointed out rtw_pci_resume() and rtw_pci_suspend() are not used at
>>> all.
>>>
>>> So I think it's safe to remove them.
>>>
> I think ".driver.pm = &rtw_pm_ops" is a switch to enable wowlan feature.
> That means that wowlan doesn't work without this declaration.
>
>>> Currently, I find that the rtl8822ce wifi chip and the pci bridge of
>>> it are not linked by pci
>>>
>>> after wake up by `lspci` command.
>>>
>>> when I set `pcie_aspm.policy=performance ` in the GRUB. The machine
>>> sleep and
>>>
>>> wake up normal.So I think when this ops is assignmented,the sleep and
>>> wake up procedure
>>>
>>> may cause pci device not linked.
> Please try setting module parameter disable_aspm=1 with pci.ko.
>
> Could I know what the CPU and pci bridge chipset are used by HONOR laptop?
>
>> Please don't use HTML, our lists automatically drop all HTML email.
>>


