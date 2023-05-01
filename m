Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977D76F2BCA
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 02:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbjEAAG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 20:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjEAAGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 20:06:51 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E7C1A5;
        Sun, 30 Apr 2023 17:06:43 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id A290A6017C;
        Mon,  1 May 2023 02:06:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682899600; bh=NyEg2EarIlOTy/w9Q2hnXf0PPTW1l2lQ29jBtEUZHMg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kZHy5VzrhbpLfpNnZJfQeJ6qOxU0Q6f/ic1F8mr1MA4BZXtAXrr3NAgHwZzuBqVLC
         YBFfSLcHJ3ZAx5JRU9nIC8scMGFPkjtz2xNAjQhZ+GE1QJi7hcixeiNFb+lgxOSF3q
         iIpVJQj8uDD/30LpebSKfrgmxK5uQbjLF2oaYzR8yJWIkLRZ4UAY3QN/7vqK+rew63
         KXowEfkCm7vrUsPRb90CdSXRjmGowCD35W7ReuvtQtAk0OnfAOKMUOdKUYKxE5F/d3
         NZREAccKGBIA/cQVl84D6GkM9DbEdLsiWo6kK4PI61/ITgvcZDqWxid8lAj8nkyqM8
         RUKUM+9aoksJA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HOLqOgSgMfLV; Mon,  1 May 2023 02:06:35 +0200 (CEST)
Received: from [192.168.1.4] (unknown [77.237.113.62])
        by domac.alu.hr (Postfix) with ESMTPSA id 3A39A60177;
        Mon,  1 May 2023 02:06:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1682899595; bh=NyEg2EarIlOTy/w9Q2hnXf0PPTW1l2lQ29jBtEUZHMg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=04S/Ai2Mx1B2wGLIhcmOqAOiI6h7q1ZNpdRkbknH3imGOCPb+bzrcRJo7no61IafT
         04Xr8gFe5rrr0R1n+XbZdPaoF2UAS8pXlbrCLnuhpEPmTQDNspTUDW/nGIUR8qzKvL
         2br3rcTT5kvqYmkMtPJv1fwK1GaiKmJucvNCq3Apem8v1wegNd5sHkoc8wlmHe87rM
         Pea2MiIsd2pHbzri4d279idaLV8IXis1wulrpyGNrDhgqq21z8e/lHdZfXhfoQkg/C
         YRvmsCc3qHcPrQcTdkvmZ3FD3WDy856Y9jtRBS+VA3FfISeZWFEdbUsCTCSWXceyd3
         frjt1kCeI41+A==
Content-Type: multipart/mixed; boundary="------------CoiMGBWzuGmhy00b87g5FQid"
Message-ID: <c4c5aec7-d7d9-2e1e-3dd5-d0c2433a5601@alu.unizg.hr>
Date:   Mon, 1 May 2023 02:06:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [WITHDRAW PATCH v1 1/1] net: r8169: fix the pci setup so the
 Realtek RTL8111/8168/8411 ethernet speeds up
Content-Language: en-US, hr
To:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     nic_swsd@realtek.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230425114455.22706-1-mirsad.todorovac@alu.unizg.hr>
 <27163cae-abe6-452a-573f-48a2223468c0@alu.unizg.hr>
 <45015448-de41-df32-b4fe-9fce49689b24@gmail.com>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <45015448-de41-df32-b4fe-9fce49689b24@gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------CoiMGBWzuGmhy00b87g5FQid
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 01. 05. 2023. 00:49, Heiner Kallweit wrote:
> On 30.04.2023 01:09, Mirsad Goran Todorovac wrote:
>> On 25. 04. 2023. 13:44, Mirsad Goran Todorovac wrote:
>>> It was noticed that Ookla Speedtest had shown only 250 Mbps download and
>>> 310 Mbps upload where Windows 10 on the same box showed 440/310 Mbps, which
>>> is the link capacity.
>>>
>>> This article: https://www.phoronix.com/news/Intel-i219-LM-Linux-60p-Fix
>>> inspired to check our speeds. (Previously I used to think it was a network
>>> congestion, or reduction on our ISP, but now each time Windows 10 downlink
>>> speed is 440 compared to 250 Mbps in Linuxes Linux is performing at 60% of
>>> the speed.)
>>>
>>> The latest 6.3 kernel shows 95% speed up with this patch as compared to the
>>> same commit without it:
>>>
>>> ::::::::::::::
>>> speedtest/6.3.0-00436-g173ea743bf7a-dirty-1
>>> ::::::::::::::
>>> [marvin@pc-mtodorov ~]$ speedtest -s 41437
>>>
>>>    Speedtest by Ookla
>>>
>>>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>>>          ISP: Croatian Academic and Research Network
>>> Idle Latency:     1.53 ms   (jitter: 0.15ms, low: 1.30ms, high: 1.71ms)
>>>     Download:   225.13 Mbps (data used: 199.3 MB)
>>>                   1.65 ms   (jitter: 20.15ms, low: 0.81ms, high: 418.27ms)
>>>       Upload:   350.00 Mbps (data used: 157.9 MB)
>>>                   3.35 ms   (jitter: 19.46ms, low: 1.61ms, high: 474.55ms)
>>>  Packet Loss:     0.0%
>>>   Result URL: https://www.speedtest.net/result/c/a0084fd8-c275-4019-899a-a1590e49a34b
>>> [marvin@pc-mtodorov ~]$ speedtest -s 41437
>>>
>>>    Speedtest by Ookla
>>>
>>>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>>>          ISP: Croatian Academic and Research Network
>>> Idle Latency:     1.54 ms   (jitter: 0.28ms, low: 1.17ms, high: 1.64ms)
>>>     Download:   222.88 Mbps (data used: 207.9 MB)
>>>                  10.23 ms   (jitter: 31.76ms, low: 0.75ms, high: 353.79ms)
>>>       Upload:   349.91 Mbps (data used: 157.7 MB)
>>>                   3.27 ms   (jitter: 13.05ms, low: 1.67ms, high: 236.76ms)
>>>  Packet Loss:     0.0%
>>>   Result URL: https://www.speedtest.net/result/c/f4c663ba-830d-44c6-8033-ce3b3b818c42
>>> [marvin@pc-mtodorov ~]$
>>> ::::::::::::::
>>> speedtest/6.3.0-r8169-00437-g323fe5352af6-dirty-2
>>> ::::::::::::::
>>> [marvin@pc-mtodorov ~]$ speedtest -s 41437
>>>
>>>    Speedtest by Ookla
>>>
>>>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>>>          ISP: Croatian Academic and Research Network
>>> Idle Latency:     0.84 ms   (jitter: 0.05ms, low: 0.82ms, high: 0.93ms)
>>>     Download:   432.37 Mbps (data used: 360.5 MB)
>>>                 142.43 ms   (jitter: 76.45ms, low: 1.02ms, high: 1105.19ms)
>>>       Upload:   346.29 Mbps (data used: 164.6 MB)
>>>                   7.72 ms   (jitter: 29.80ms, low: 0.92ms, high: 283.48ms)
>>>  Packet Loss:    12.8%
>>>   Result URL: https://www.speedtest.net/result/c/e473359e-c37e-4f29-aa9f-4b008210cf7c
>>> [marvin@pc-mtodorov ~]$ speedtest -s 41437
>>>
>>>    Speedtest by Ookla
>>>
>>>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>>>          ISP: Croatian Academic and Research Network
>>> Idle Latency:     0.82 ms   (jitter: 0.16ms, low: 0.75ms, high: 1.05ms)
>>>     Download:   440.97 Mbps (data used: 427.5 MB)
>>>                  72.50 ms   (jitter: 52.89ms, low: 0.91ms, high: 865.08ms)
>>>       Upload:   342.75 Mbps (data used: 166.6 MB)
>>>                   3.26 ms   (jitter: 22.93ms, low: 1.07ms, high: 239.41ms)
>>>  Packet Loss:    13.4%
>>>   Result URL: https://www.speedtest.net/result/c/f393e149-38d4-4a34-acc4-5cf81ff13708
>>>
>>> 440 Mbps is the speed achieved in Windows 10, and Linux 6.3 with
>>> the patch, while 225 Mbps without this patch is running at 51% of
>>> the nominal speed with the same hardware and Linux kernel commit.
>>>
>>> Cc: David S. Miller <davem@davemloft.net>
>>> Cc: Eric Dumazet <edumazet@google.com>
>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>> Cc: Paolo Abeni <pabeni@redhat.com>
>>> Cc: nic_swsd@realtek.com
>>> Cc: netdev@vger.kernel.org
>>> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1671958#c60
>>> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
>>> Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>>> ---
>>>  drivers/net/ethernet/realtek/r8169_main.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>> index 45147a1016be..b8a04301d130 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -3239,6 +3239,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
>>>  	r8168_mac_ocp_write(tp, 0xc094, 0x0000);
>>>  	r8168_mac_ocp_write(tp, 0xc09e, 0x0000);
>>>  
>>> +	pci_disable_link_state(tp->pci_dev, PCIE_LINK_STATE_CLKPM);
>>>  	rtl_hw_aspm_clkreq_enable(tp, true);
>>>  }
>>>  
>>
>> After some additional research, I came to the obvious realisation, reading more
>> thoroughly the discussion at the link - that the above patch did not work for
>> all Realtek RTL819x cards back then.
>>
>> My version, the RTL8168h/8111h indeed works 95% faster on the 6.3 Linux kernel,
>> but I cannot speak for the people with the power management problems and
>> battery life issues ... and the concerns explained here: https://github.com/KastB/r8169
>>
>> [root@pc-mtodorov marvin]# dmesg | grep RTL
>> [    7.304130] r8169 0000:01:00.0 eth0: RTL8168h/8111h, f4:93:9f:f0:a5:f5, XID 541, IRQ 123
>>
>> Currently there seem to be  at least 43 revisions of the RTL816x cards and firmware,
>> and I really cannot test on all of them.
>>
>> I will test the other Heiner's experimental patch, but it seems to disable ASPM completely,
>> while for my Lenovo desktop with RTL8168h/8111h disabling CLKPM alone.
>>
>> However, further homework revealed that the kernel patch is unnecessary, as the same
>> effect can be achieved in runtime by the sysfs parm introduced with THIS PATCH:
>> https://patchwork.kernel.org/project/linux-pci/patch/b1c83f8a-9bf6-eac5-82d0-cf5b90128fbf@gmail.com/
>> which was solved 3 1/2 years ago, but the default on my AlmaLinux 8.7 and Lenovo desktop
>> box 10TX000VCR was the 53% of the link capacity and speed.
>>
>> (I don't know if the card would operate with 220 Mbps on a Gigabit link, it was
>> not tested.)
>>
>> [marvin@pc-mtodorov ~]$ speedtest -s 41437
>>
>>    Speedtest by Ookla
>>
>>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>>          ISP: Croatian Academic and Research Network
>> Idle Latency:     1.44 ms   (jitter: 0.23ms, low: 1.20ms, high: 1.65ms)
>>     Download:   220.62 Mbps (data used: 214.2 MB)                                                   
>>                  22.01 ms   (jitter: 36.04ms, low: 0.84ms, high: 817.47ms)
>>       Upload:   346.86 Mbps (data used: 169.1 MB)                                                   
>>                   3.32 ms   (jitter: 12.12ms, low: 0.87ms, high: 221.69ms)
>>  Packet Loss:     0.6%
>>   Result URL: https://www.speedtest.net/result/c/20c546e7-0b8f-4a2e-a669-a597bb5aee36
>> [marvin@pc-mtodorov ~]$ sudo bash
>> [sudo] password for marvin: 
>> [root@pc-mtodorov marvin]# cat /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/link/clkpm
>> 1
>> [root@pc-mtodorov marvin]# echo 0 > /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/link/clkpm
>> [root@pc-mtodorov marvin]# cat /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/link/clkpm
>> 0
>> [root@pc-mtodorov marvin]# speedtest -s 41437
>>
>>    Speedtest by Ookla
>>
>>       Server: A1 Hrvatska d.o.o. - Zagreb (id: 41437)
>>          ISP: Croatian Academic and Research Network
>> Idle Latency:     0.85 ms   (jitter: 0.06ms, low: 0.78ms, high: 0.92ms)
>>     Download:   431.13 Mbps (data used: 341.0 MB)                                                   
>>                 157.40 ms   (jitter: 68.09ms, low: 0.88ms, high: 823.19ms)
>>       Upload:   351.36 Mbps (data used: 158.3 MB)                                                   
>>                   2.88 ms   (jitter: 6.24ms, low: 1.41ms, high: 209.74ms)
>>  Packet Loss:    13.4%
>>   Result URL: https://www.speedtest.net/result/c/ff695466-3ac7-405e-8cae-0a85c2c3d5cd
>> [root@pc-mtodorov marvin]# 
>>
>> The clkpm setting can be reversed back to 1, causing the RTL speed to drop again.
>>
>> So, the patch is withdrawn as unnecessary, even when the majority of RTL8168h/8111h
>> and possibly other Realtek Gigabit cards will by default run at sub-Gigabit speeds.
>>
> 
> RTL8168h doesn't need the CLKPM quirk in general. E.g. my test system runs fine w/o it
> at 950Mbps. Seems that ASPM is broken on your system.
> Alternatively you can test with latest linux-next, it disables ASPM during NAPI poll.

My system is basically a Lenovo minitower desktop with a SSD SATA disk.
Nothing peculiar. Please find attached lshw.txt and lspci -vv, if that could
help.

ASPM is reported as OK for all PCI devices (PCI-E root and RTL8198h). I guess
for a desktop ASPM is not all that critical.

All my RFC PATCH actually disabled CLKPM, however the lack of intel made me
recompile rather than do the runtime switching off. Kernel docs are unfortunately
around 2010 on PCI Express. :-(

I think that the problem might be in our Mikrotik RB2011 UiAS-RM which still
has Fast Ethernet ports and must be 15 years old and most likely doesn't support
CLKPM so odd things happen ...

But Windows 10 default is faster as I said, and I can't tell how many Linux
users will figure out to turn off CLKPM via sysfs ...

I saw that you had regressions with the fix I proposed (which is in fact
almost entirely based on your patch and applied to the different file as
the code was somewhat reorganised). I can simply run it at boot in a unit or
from cron, but sort of feel that the most sensible setting should be the default.

I wasn't lucky with finding RTL8168h specs, so I guess I can only keep my fingers
crossed for your zero copy and io_uring implementation of r8169.

We are really out of luck, but RTL is so ubiquitous and I think higher powers
would appreciate this driver debugged. ;-)

Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

"I see something approaching fast ... Will it be friends with me?"

--------------CoiMGBWzuGmhy00b87g5FQid
Content-Type: text/plain; charset=UTF-8; name="lspci-vv-lenovo.txt"
Content-Disposition: attachment; filename="lspci-vv-lenovo.txt"
Content-Transfer-Encoding: base64

MDA6MDAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gOHRoIEdlbiBDb3JlIFBy
b2Nlc3NvciBIb3N0IEJyaWRnZS9EUkFNIFJlZ2lzdGVycyAocmV2IDA3KQoJRGV2aWNlTmFt
ZTogT25ib2FyZCAtIE90aGVyCglTdWJzeXN0ZW06IExlbm92byBEZXZpY2UgMzE0MAoJQ29u
dHJvbDogSS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9v
cC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czog
Q2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQt
IDxUQWJvcnQtIDxNQWJvcnQrID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAKCUNh
cGFiaWxpdGllczogW2UwXSBWZW5kb3IgU3BlY2lmaWMgSW5mb3JtYXRpb246IExlbj0xMCA8
Pz4KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBza2xfdW5jb3JlCglLZXJuZWwgbW9kdWxlczog
aWUzMTIwMF9lZGFjCgowMDowMi4wIFZHQSBjb21wYXRpYmxlIGNvbnRyb2xsZXI6IEludGVs
IENvcnBvcmF0aW9uIENvZmZlZUxha2UtUyBHVDIgW1VIRCBHcmFwaGljcyA2MzBdIChwcm9n
LWlmIDAwIFtWR0EgY29udHJvbGxlcl0pCglEZXZpY2VOYW1lOiBPbmJvYXJkIC0gVmlkZW8K
CVN1YnN5c3RlbTogTGVub3ZvIERldmljZSAzMTQwCglDb250cm9sOiBJL08rIE1lbSsgQnVz
TWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5n
LSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZh
c3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0g
PlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBi
eXRlcwoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDEyNAoJUmVnaW9uIDA6IE1l
bW9yeSBhdCBhMDAwMDAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0xNk1d
CglSZWdpb24gMjogTWVtb3J5IGF0IDkwMDAwMDAwICg2NC1iaXQsIHByZWZldGNoYWJsZSkg
W3NpemU9MjU2TV0KCVJlZ2lvbiA0OiBJL08gcG9ydHMgYXQgNDAwMCBbc2l6ZT02NF0KCUV4
cGFuc2lvbiBST00gYXQgMDAwYzAwMDAgW3ZpcnR1YWxdIFtkaXNhYmxlZF0gW3NpemU9MTI4
S10KCUNhcGFiaWxpdGllczogWzQwXSBWZW5kb3IgU3BlY2lmaWMgSW5mb3JtYXRpb246IExl
bj0wYyA8Pz4KCUNhcGFiaWxpdGllczogWzcwXSBFeHByZXNzICh2MikgUm9vdCBDb21wbGV4
IEludGVncmF0ZWQgRW5kcG9pbnQsIE1TSSAwMAoJCURldkNhcDoJTWF4UGF5bG9hZCAxMjgg
Ynl0ZXMsIFBoYW50RnVuYyAwCgkJCUV4dFRhZy0gUkJFKyBGTFJlc2V0KwoJCURldkN0bDoJ
Q29yckVyci0gTm9uRmF0YWxFcnItIEZhdGFsRXJyLSBVbnN1cFJlcS0KCQkJUmx4ZE9yZC0g
RXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0gRkxSZXNldC0KCQkJTWF4UGF5
bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5dGVzCgkJRGV2U3RhOglDb3JyRXJy
LSBOb25GYXRhbEVyci0gRmF0YWxFcnItIFVuc3VwUmVxLSBBdXhQd3ItIFRyYW5zUGVuZC0K
CQlEZXZDYXAyOiBDb21wbGV0aW9uIFRpbWVvdXQ6IE5vdCBTdXBwb3J0ZWQsIFRpbWVvdXRE
aXMtIE5ST1ByUHJQLSBMVFItCgkJCSAxMEJpdFRhZ0NvbXAtIDEwQml0VGFnUmVxLSBPQkZG
IE5vdCBTdXBwb3J0ZWQsIEV4dEZtdC0gRUVUTFBQcmVmaXgtCgkJCSBFbWVyZ2VuY3lQb3dl
clJlZHVjdGlvbiBOb3QgU3VwcG9ydGVkLCBFbWVyZ2VuY3lQb3dlclJlZHVjdGlvbkluaXQt
CgkJCSBGUlMtCgkJCSBBdG9taWNPcHNDYXA6IDMyYml0LSA2NGJpdC0gMTI4Yml0Q0FTLQoJ
CURldkN0bDI6IENvbXBsZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBUaW1lb3V0RGlz
LSBMVFItIE9CRkYgRGlzYWJsZWQsCgkJCSBBdG9taWNPcHNDdGw6IFJlcUVuLQoJQ2FwYWJp
bGl0aWVzOiBbYWNdIE1TSTogRW5hYmxlKyBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0LQoJ
CUFkZHJlc3M6IGZlZTA4MDA0ICBEYXRhOiAwMDIzCglDYXBhYmlsaXRpZXM6IFtkMF0gUG93
ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xrLSBEU0krIEQxLSBEMi0g
QXV4Q3VycmVudD0wbUEgUE1FKEQwLSxEMS0sRDItLEQzaG90LSxEM2NvbGQtKQoJCVN0YXR1
czogRDMgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2Fw
YWJpbGl0aWVzOiBbMTAwIHYxXSBQcm9jZXNzIEFkZHJlc3MgU3BhY2UgSUQgKFBBU0lEKQoJ
CVBBU0lEQ2FwOiBFeGVjLSBQcml2LSwgTWF4IFBBU0lEIFdpZHRoOiAxNAoJCVBBU0lEQ3Rs
OiBFbmFibGUtIEV4ZWMtIFByaXYtCglDYXBhYmlsaXRpZXM6IFsyMDAgdjFdIEFkZHJlc3Mg
VHJhbnNsYXRpb24gU2VydmljZSAoQVRTKQoJCUFUU0NhcDoJSW52YWxpZGF0ZSBRdWV1ZSBE
ZXB0aDogMDAKCQlBVFNDdGw6CUVuYWJsZS0sIFNtYWxsZXN0IFRyYW5zbGF0aW9uIFVuaXQ6
IDAwCglDYXBhYmlsaXRpZXM6IFszMDAgdjFdIFBhZ2UgUmVxdWVzdCBJbnRlcmZhY2UgKFBS
SSkKCQlQUklDdGw6IEVuYWJsZS0gUmVzZXQtCgkJUFJJU3RhOiBSRi0gVVBSR0ktIFN0b3Bw
ZWQrCgkJUGFnZSBSZXF1ZXN0IENhcGFjaXR5OiAwMDAwODAwMCwgUGFnZSBSZXF1ZXN0IEFs
bG9jYXRpb246IDAwMDAwMDAwCglLZXJuZWwgZHJpdmVyIGluIHVzZTogaTkxNQoJS2VybmVs
IG1vZHVsZXM6IGk5MTUKCjAwOjA4LjAgU3lzdGVtIHBlcmlwaGVyYWw6IEludGVsIENvcnBv
cmF0aW9uIFhlb24gRTMtMTIwMCB2NS92NiAvIEUzLTE1MDAgdjUgLyA2dGgvN3RoLzh0aCBH
ZW4gQ29yZSBQcm9jZXNzb3IgR2F1c3NpYW4gTWl4dHVyZSBNb2RlbAoJRGV2aWNlTmFtZTog
T25ib2FyZCAtIE90aGVyCglTdWJzeXN0ZW06IExlbm92byBEZXZpY2UgMzE0MAoJQ29udHJv
bDogSS9PLSBNZW0tIEJ1c01hc3Rlci0gU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0g
UGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2Fw
KyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxU
QWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUludGVycnVwdDogcGluIEEg
cm91dGVkIHRvIElSUSAxMQoJUmVnaW9uIDA6IE1lbW9yeSBhdCBhMTIyMTAwMCAoNjQtYml0
LCBub24tcHJlZmV0Y2hhYmxlKSBbZGlzYWJsZWRdIFtzaXplPTRLXQoJQ2FwYWJpbGl0aWVz
OiBbOTBdIE1TSTogRW5hYmxlLSBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0LQoJCUFkZHJl
c3M6IDAwMDAwMDAwICBEYXRhOiAwMDAwCglDYXBhYmlsaXRpZXM6IFtkY10gUG93ZXIgTWFu
YWdlbWVudCB2ZXJzaW9uIDIKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3Vy
cmVudD0wbUEgUE1FKEQwLSxEMS0sRDItLEQzaG90LSxEM2NvbGQtKQoJCVN0YXR1czogRDAg
Tm9Tb2Z0UnN0LSBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0
aWVzOiBbZjBdIFBDSSBBZHZhbmNlZCBGZWF0dXJlcwoJCUFGQ2FwOiBUUCsgRkxSKwoJCUFG
Q3RybDogRkxSLQoJCUFGU3RhdHVzOiBUUC0KCjAwOjEyLjAgU2lnbmFsIHByb2Nlc3Npbmcg
Y29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gQ2Fubm9uIExha2UgUENIIFRoZXJtYWwg
Q29udHJvbGxlciAocmV2IDEwKQoJRGV2aWNlTmFtZTogT25ib2FyZCAtIE90aGVyCglTdWJz
eXN0ZW06IExlbm92byBEZXZpY2UgMzE0MAoJQ29udHJvbDogSS9PLSBNZW0rIEJ1c01hc3Rl
ci0gU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VS
Ui0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJC
LSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJS
LSA8UEVSUi0gSU5UeC0KCUludGVycnVwdDogcGluIEEgcm91dGVkIHRvIElSUSAxNgoJUmVn
aW9uIDA6IE1lbW9yeSBhdCBhMTIyMDAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBb
c2l6ZT00S10KCUNhcGFiaWxpdGllczogWzUwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24g
MwoJCUZsYWdzOiBQTUVDbGstIERTSSsgRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAt
LEQxLSxEMi0sRDNob3QtLEQzY29sZC0pCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QrIFBNRS1F
bmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs4MF0gTVNJOiBF
bmFibGUtIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQtCgkJQWRkcmVzczogMDAwMDAwMDAg
IERhdGE6IDAwMDAKCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBpbnRlbF9wY2hfdGhlcm1hbAoJ
S2VybmVsIG1vZHVsZXM6IGludGVsX3BjaF90aGVybWFsCgowMDoxNC4wIFVTQiBjb250cm9s
bGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiBDYW5ub24gTGFrZSBQQ0ggVVNCIDMuMSB4SENJIEhv
c3QgQ29udHJvbGxlciAocmV2IDEwKSAocHJvZy1pZiAzMCBbWEhDSV0pCglEZXZpY2VOYW1l
OiBPbmJvYXJkIC0gT3RoZXIKCVN1YnN5c3RlbTogTGVub3ZvIERldmljZSAzMTQwCglDb250
cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29w
LSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBD
YXArIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0
LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJ
bnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTIxCglSZWdpb24gMDogTWVtb3J5IGF0
IGExMjAwMDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTY0S10KCUNhcGFi
aWxpdGllczogWzcwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVD
bGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTM3NW1BIFBNRShEMC0sRDEtLEQyLSxEM2hv
dCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdCsgUE1FLUVuYWJsZS0gRFNlbD0w
IERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9
MS84IE1hc2thYmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMGZlZTEwMDA0ICBEYXRh
OiAwMDIxCglDYXBhYmlsaXRpZXM6IFs5MF0gVmVuZG9yIFNwZWNpZmljIEluZm9ybWF0aW9u
OiBMZW49MTQgPD8+CglLZXJuZWwgZHJpdmVyIGluIHVzZTogeGhjaV9oY2QKCjAwOjE0LjIg
UkFNIG1lbW9yeTogSW50ZWwgQ29ycG9yYXRpb24gQ2Fubm9uIExha2UgUENIIFNoYXJlZCBT
UkFNIChyZXYgMTApCglEZXZpY2VOYW1lOiBPbmJvYXJkIC0gT3RoZXIKCVN1YnN5c3RlbTog
TGVub3ZvIERldmljZSAzMTQwCglDb250cm9sOiBJL08tIE1lbS0gQnVzTWFzdGVyLSBTcGVj
Q3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0
QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVy
ci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJS
LSBJTlR4LQoJUmVnaW9uIDA6IE1lbW9yeSBhdCBhMTIxNjAwMCAoNjQtYml0LCBub24tcHJl
ZmV0Y2hhYmxlKSBbZGlzYWJsZWRdIFtzaXplPThLXQoJUmVnaW9uIDI6IE1lbW9yeSBhdCBh
MTIxZjAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbZGlzYWJsZWRdIFtzaXplPTRL
XQoJQ2FwYWJpbGl0aWVzOiBbODBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJRmxh
Z3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDEtLEQy
LSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIE5vU29mdFJzdCsgUE1FLUVuYWJsZS0g
RFNlbD0wIERTY2FsZT0wIFBNRS0KCjAwOjE1LjAgU2VyaWFsIGJ1cyBjb250cm9sbGVyOiBJ
bnRlbCBDb3Jwb3JhdGlvbiBDYW5ub24gTGFrZSBQQ0ggU2VyaWFsIElPIEkyQyBDb250cm9s
bGVyICMwIChyZXYgMTApCglEZXZpY2VOYW1lOiBPbmJvYXJkIC0gT3RoZXIKCVN1YnN5c3Rl
bTogTGVub3ZvIERldmljZSAzMTQwCglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBT
cGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBG
YXN0QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBh
ckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQ
RVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRlcwoJSW50
ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDE2CglSZWdpb24gMDogTWVtb3J5IGF0IGEx
MjE5MDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFt2aXJ0dWFsXSBbc2l6ZT00S10K
CUNhcGFiaWxpdGllczogWzgwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMwoJCUZsYWdz
OiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0s
RDNob3QtLEQzY29sZC0pCgkJU3RhdHVzOiBEMyBOb1NvZnRSc3QrIFBNRS1FbmFibGUtIERT
ZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs5MF0gVmVuZG9yIFNwZWNpZmlj
IEluZm9ybWF0aW9uOiBMZW49MTQgPD8+CglLZXJuZWwgZHJpdmVyIGluIHVzZTogaW50ZWwt
bHBzcwoJS2VybmVsIG1vZHVsZXM6IGludGVsX2xwc3NfcGNpCgowMDoxNS4xIFNlcmlhbCBi
dXMgY29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gQ2Fubm9uIExha2UgUENIIFNlcmlh
bCBJTyBJMkMgQ29udHJvbGxlciAjMSAocmV2IDEwKQoJRGV2aWNlTmFtZTogT25ib2FyZCAt
IE90aGVyCglTdWJzeXN0ZW06IExlbm92byBEZXZpY2UgMzE0MAoJQ29udHJvbDogSS9PLSBN
ZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBT
dGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0g
VURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxN
QWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6
ZTogNjQgYnl0ZXMKCUludGVycnVwdDogcGluIEIgcm91dGVkIHRvIElSUSAxNwoJUmVnaW9u
IDA6IE1lbW9yeSBhdCBhMTIxZDAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbdmly
dHVhbF0gW3NpemU9NEtdCglDYXBhYmlsaXRpZXM6IFs4MF0gUG93ZXIgTWFuYWdlbWVudCB2
ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEg
UE1FKEQwLSxEMS0sRDItLEQzaG90LSxEM2NvbGQtKQoJCVN0YXR1czogRDMgTm9Tb2Z0UnN0
KyBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbOTBd
IFZlbmRvciBTcGVjaWZpYyBJbmZvcm1hdGlvbjogTGVuPTE0IDw/PgoJS2VybmVsIGRyaXZl
ciBpbiB1c2U6IGludGVsLWxwc3MKCUtlcm5lbCBtb2R1bGVzOiBpbnRlbF9scHNzX3BjaQoK
MDA6MTYuMCBDb21tdW5pY2F0aW9uIGNvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIENh
bm5vbiBMYWtlIFBDSCBIRUNJIENvbnRyb2xsZXIgKHJldiAxMCkKCURldmljZU5hbWU6IE9u
Ym9hcmQgLSBPdGhlcgoJU3Vic3lzdGVtOiBMZW5vdm8gRGV2aWNlIDMxNDAKCUNvbnRyb2w6
IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBh
ckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENhcCsg
NjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFi
b3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1
cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTI1CglSZWdpb24gMDogTWVtb3J5IGF0IGExMjFj
MDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTRLXQoJQ2FwYWJpbGl0aWVz
OiBbNTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJ
LSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDEtLEQyLSxEM2hvdCssRDNjb2xk
LSkKCQlTdGF0dXM6IEQwIE5vU29mdFJzdCsgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0w
IFBNRS0KCUNhcGFiaWxpdGllczogWzhjXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2th
YmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMGZlZTAxMDA0ICBEYXRhOiAwMDIyCglD
YXBhYmlsaXRpZXM6IFthNF0gVmVuZG9yIFNwZWNpZmljIEluZm9ybWF0aW9uOiBMZW49MTQg
PD8+CglLZXJuZWwgZHJpdmVyIGluIHVzZTogbWVpX21lCglLZXJuZWwgbW9kdWxlczogbWVp
X21lCgowMDoxNy4wIFNBVEEgY29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gQ2Fubm9u
IExha2UgUENIIFNBVEEgQUhDSSBDb250cm9sbGVyIChyZXYgMTApIChwcm9nLWlmIDAxIFtB
SENJIDEuMF0pCglEZXZpY2VOYW1lOiBPbmJvYXJkIC0gU0FUQQoJU3Vic3lzdGVtOiBMZW5v
dm8gRGV2aWNlIDMxNDAKCUNvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNs
ZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkIt
IERpc0lOVHgrCglTdGF0dXM6IENhcCsgNjZNSHorIFVERi0gRmFzdEIyQisgUGFyRXJyLSBE
RVZTRUw9bWVkaXVtID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0g
SU5UeC0KCUxhdGVuY3k6IDAKCUludGVycnVwdDogcGluIEEgcm91dGVkIHRvIElSUSAxMjIK
CVJlZ2lvbiAwOiBNZW1vcnkgYXQgYTEyMTQwMDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJs
ZSkgW3NpemU9OEtdCglSZWdpb24gMTogTWVtb3J5IGF0IGExMjFiMDAwICgzMi1iaXQsIG5v
bi1wcmVmZXRjaGFibGUpIFtzaXplPTI1Nl0KCVJlZ2lvbiAyOiBJL08gcG9ydHMgYXQgNDA5
MCBbc2l6ZT04XQoJUmVnaW9uIDM6IEkvTyBwb3J0cyBhdCA0MDgwIFtzaXplPTRdCglSZWdp
b24gNDogSS9PIHBvcnRzIGF0IDQwNjAgW3NpemU9MzJdCglSZWdpb24gNTogTWVtb3J5IGF0
IGExMjFhMDAwICgzMi1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTJLXQoJQ2FwYWJp
bGl0aWVzOiBbODBdIE1TSTogRW5hYmxlKyBDb3VudD0xLzEgTWFza2FibGUtIDY0Yml0LQoJ
CUFkZHJlc3M6IGZlZTAyMDA0ICBEYXRhOiAwMDIzCglDYXBhYmlsaXRpZXM6IFs3MF0gUG93
ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0g
QXV4Q3VycmVudD0wbUEgUE1FKEQwLSxEMS0sRDItLEQzaG90KyxEM2NvbGQtKQoJCVN0YXR1
czogRDAgTm9Tb2Z0UnN0KyBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2Fw
YWJpbGl0aWVzOiBbYThdIFNBVEEgSEJBIHYxLjAgQkFSNCBPZmZzZXQ9MDAwMDAwMDQKCUtl
cm5lbCBkcml2ZXIgaW4gdXNlOiBhaGNpCglLZXJuZWwgbW9kdWxlczogYWhjaQoKMDA6MWMu
MCBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiBDYW5ub24gTGFrZSBQQ0ggUENJIEV4
cHJlc3MgUm9vdCBQb3J0ICM3IChyZXYgZjApIChwcm9nLWlmIDAwIFtOb3JtYWwgZGVjb2Rl
XSkKCUNvbnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0g
VkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglT
dGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+
VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5
OiAwLCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglJbnRlcnJ1cHQ6IHBpbiBDIHJvdXRl
ZCB0byBJUlEgMTIwCglCdXM6IHByaW1hcnk9MDAsIHNlY29uZGFyeT0wMSwgc3Vib3JkaW5h
dGU9MDEsIHNlYy1sYXRlbmN5PTAKCUkvTyBiZWhpbmQgYnJpZGdlOiAwMDAwMzAwMC0wMDAw
M2ZmZiBbc2l6ZT00S10KCU1lbW9yeSBiZWhpbmQgYnJpZGdlOiBhMTEwMDAwMC1hMTFmZmZm
ZiBbc2l6ZT0xTV0KCVByZWZldGNoYWJsZSBtZW1vcnkgYmVoaW5kIGJyaWRnZTogW2Rpc2Fi
bGVkXQoJU2Vjb25kYXJ5IHN0YXR1czogNjZNSHotIEZhc3RCMkItIFBhckVyci0gREVWU0VM
PWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPFNFUlItIDxQRVJSLQoJQnJpZGdl
Q3RsOiBQYXJpdHktIFNFUlIrIE5vSVNBLSBWR0EtIFZHQTE2KyBNQWJvcnQtID5SZXNldC0g
RmFzdEIyQi0KCQlQcmlEaXNjVG1yLSBTZWNEaXNjVG1yLSBEaXNjVG1yU3RhdC0gRGlzY1Rt
clNFUlJFbi0KCUNhcGFiaWxpdGllczogWzQwXSBFeHByZXNzICh2MikgUm9vdCBQb3J0IChT
bG90KyksIE1TSSAwMAoJCURldkNhcDoJTWF4UGF5bG9hZCAyNTYgYnl0ZXMsIFBoYW50RnVu
YyAwCgkJCUV4dFRhZy0gUkJFKwoJCURldkN0bDoJQ29yckVycisgTm9uRmF0YWxFcnIrIEZh
dGFsRXJyKyBVbnN1cFJlcSsKCQkJUmx4ZE9yZC0gRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3
ci0gTm9Tbm9vcC0KCQkJTWF4UGF5bG9hZCAxMjggYnl0ZXMsIE1heFJlYWRSZXEgMTI4IGJ5
dGVzCgkJRGV2U3RhOglDb3JyRXJyLSBOb25GYXRhbEVyci0gRmF0YWxFcnItIFVuc3VwUmVx
LSBBdXhQd3IrIFRyYW5zUGVuZC0KCQlMbmtDYXA6CVBvcnQgIzcsIFNwZWVkIDhHVC9zLCBX
aWR0aCB4MSwgQVNQTSBMMHMgTDEsIEV4aXQgTGF0ZW5jeSBMMHMgPDF1cywgTDEgPDE2dXMK
CQkJQ2xvY2tQTS0gU3VycHJpc2UtIExMQWN0UmVwKyBCd05vdCsgQVNQTU9wdENvbXArCgkJ
TG5rQ3RsOglBU1BNIEwxIEVuYWJsZWQ7IFJDQiA2NCBieXRlcywgRGlzYWJsZWQtIENvbW1D
bGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0K
CQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MgKGRvd25ncmFkZWQpLCBXaWR0aCB4MSAob2spCgkJ
CVRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExBY3RpdmUrIEJXTWdtdCsgQUJXTWdtdC0KCQlT
bHRDYXA6CUF0dG5CdG4tIFB3ckN0cmwtIE1STC0gQXR0bkluZC0gUHdySW5kLSBIb3RQbHVn
LSBTdXJwcmlzZS0KCQkJU2xvdCAjMTAsIFBvd2VyTGltaXQgMTAuMDAwVzsgSW50ZXJsb2Nr
LSBOb0NvbXBsKwoJCVNsdEN0bDoJRW5hYmxlOiBBdHRuQnRuLSBQd3JGbHQtIE1STC0gUHJl
c0RldC0gQ21kQ3BsdC0gSFBJcnEtIExpbmtDaGctCgkJCUNvbnRyb2w6IEF0dG5JbmQgVW5r
bm93biwgUHdySW5kIFVua25vd24sIFBvd2VyLSBJbnRlcmxvY2stCgkJU2x0U3RhOglTdGF0
dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENtZENwbHQtIFByZXNEZXQrIEludGVybG9j
ay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0LSBMaW5rU3RhdGUrCgkJUm9vdENhcDogQ1JT
VmlzaWJsZS0KCQlSb290Q3RsOiBFcnJDb3JyZWN0YWJsZS0gRXJyTm9uLUZhdGFsLSBFcnJG
YXRhbC0gUE1FSW50RW5hKyBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6IFBNRSBSZXFJRCAwMDAw
LCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxldGlvbiBUaW1lb3V0
OiBSYW5nZSBBQkMsIFRpbWVvdXREaXMrIE5ST1ByUHJQLSBMVFIrCgkJCSAxMEJpdFRhZ0Nv
bXAtIDEwQml0VGFnUmVxLSBPQkZGIE5vdCBTdXBwb3J0ZWQsIEV4dEZtdC0gRUVUTFBQcmVm
aXgtCgkJCSBFbWVyZ2VuY3lQb3dlclJlZHVjdGlvbiBOb3QgU3VwcG9ydGVkLCBFbWVyZ2Vu
Y3lQb3dlclJlZHVjdGlvbkluaXQtCgkJCSBGUlMtIExOIFN5c3RlbSBDTFMgTm90IFN1cHBv
cnRlZCwgVFBIQ29tcC0gRXh0VFBIQ29tcC0gQVJJRndkKwoJCQkgQXRvbWljT3BzQ2FwOiBS
b3V0aW5nLSAzMmJpdC0gNjRiaXQtIDEyOGJpdENBUy0KCQlEZXZDdGwyOiBDb21wbGV0aW9u
IFRpbWVvdXQ6IDUwdXMgdG8gNTBtcywgVGltZW91dERpcy0gTFRSKyBPQkZGIERpc2FibGVk
LCBBUklGd2QtCgkJCSBBdG9taWNPcHNDdGw6IFJlcUVuLSBFZ3Jlc3NCbGNrLQoJCUxua0Nh
cDI6IFN1cHBvcnRlZCBMaW5rIFNwZWVkczogMi41LThHVC9zLCBDcm9zc2xpbmstIFJldGlt
ZXItIDJSZXRpbWVycy0gRFJTLQoJCUxua0N0bDI6IFRhcmdldCBMaW5rIFNwZWVkOiA4R1Qv
cywgRW50ZXJDb21wbGlhbmNlLSBTcGVlZERpcy0KCQkJIFRyYW5zbWl0IE1hcmdpbjogTm9y
bWFsIE9wZXJhdGluZyBSYW5nZSwgRW50ZXJNb2RpZmllZENvbXBsaWFuY2UtIENvbXBsaWFu
Y2VTT1MtCgkJCSBDb21wbGlhbmNlIERlLWVtcGhhc2lzOiAtNmRCCgkJTG5rU3RhMjogQ3Vy
cmVudCBEZS1lbXBoYXNpcyBMZXZlbDogLTMuNWRCLCBFcXVhbGl6YXRpb25Db21wbGV0ZS0g
RXF1YWxpemF0aW9uUGhhc2UxLQoJCQkgRXF1YWxpemF0aW9uUGhhc2UyLSBFcXVhbGl6YXRp
b25QaGFzZTMtIExpbmtFcXVhbGl6YXRpb25SZXF1ZXN0LQoJCQkgUmV0aW1lci0gMlJldGlt
ZXJzLSBDcm9zc2xpbmtSZXM6IHVuc3VwcG9ydGVkCglDYXBhYmlsaXRpZXM6IFs4MF0gTVNJ
OiBFbmFibGUrIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQtCgkJQWRkcmVzczogZmVlMDIw
MDQgIERhdGE6IDAwMjEKCUNhcGFiaWxpdGllczogWzkwXSBTdWJzeXN0ZW06IExlbm92byBE
ZXZpY2UgMzE0MAoJQ2FwYWJpbGl0aWVzOiBbYTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lv
biAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShE
MCssRDEtLEQyLSxEM2hvdCssRDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0gUE1F
LUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzEwMCB2MV0g
QWR2YW5jZWQgRXJyb3IgUmVwb3J0aW5nCgkJVUVTdGE6CURMUC0gU0RFUy0gVExQLSBGQ1At
IENtcGx0VE8tIENtcGx0QWJydC0gVW54Q21wbHQtIFJ4T0YtIE1hbGZUTFAtIEVDUkMtIFVu
c3VwUmVxLSBBQ1NWaW9sLQoJCVVFTXNrOglETFAtIFNERVMtIFRMUC0gRkNQLSBDbXBsdFRP
LSBDbXBsdEFicnQtIFVueENtcGx0KyBSeE9GLSBNYWxmVExQLSBFQ1JDLSBVbnN1cFJlcS0g
QUNTVmlvbC0KCQlVRVN2cnQ6CURMUCsgU0RFUy0gVExQLSBGQ1AtIENtcGx0VE8tIENtcGx0
QWJydC0gVW54Q21wbHQtIFJ4T0YrIE1hbGZUTFArIEVDUkMtIFVuc3VwUmVxLSBBQ1NWaW9s
LQoJCUNFU3RhOglSeEVyci0gQmFkVExQLSBCYWRETExQLSBSb2xsb3Zlci0gVGltZW91dC0g
QWR2Tm9uRmF0YWxFcnItCgkJQ0VNc2s6CVJ4RXJyLSBCYWRUTFAtIEJhZERMTFAtIFJvbGxv
dmVyLSBUaW1lb3V0LSBBZHZOb25GYXRhbEVyci0KCQlBRVJDYXA6CUZpcnN0IEVycm9yIFBv
aW50ZXI6IDAwLCBFQ1JDR2VuQ2FwLSBFQ1JDR2VuRW4tIEVDUkNDaGtDYXAtIEVDUkNDaGtF
bi0KCQkJTXVsdEhkclJlY0NhcC0gTXVsdEhkclJlY0VuLSBUTFBQZnhQcmVzLSBIZHJMb2dD
YXAtCgkJSGVhZGVyTG9nOiAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMAoJ
CVJvb3RDbWQ6IENFUnB0RW4rIE5GRVJwdEVuKyBGRVJwdEVuKwoJCVJvb3RTdGE6IENFUmN2
ZC0gTXVsdENFUmN2ZC0gVUVSY3ZkLSBNdWx0VUVSY3ZkLQoJCQkgRmlyc3RGYXRhbC0gTm9u
RmF0YWxNc2ctIEZhdGFsTXNnLSBJbnRNc2cgMAoJCUVycm9yU3JjOiBFUlJfQ09SOiAwMTAw
IEVSUl9GQVRBTC9OT05GQVRBTDogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbMTQwIHYxXSBBY2Nl
c3MgQ29udHJvbCBTZXJ2aWNlcwoJCUFDU0NhcDoJU3JjVmFsaWQrIFRyYW5zQmxrKyBSZXFS
ZWRpcisgQ21wbHRSZWRpcisgVXBzdHJlYW1Gd2QtIEVncmVzc0N0cmwtIERpcmVjdFRyYW5z
LQoJCUFDU0N0bDoJU3JjVmFsaWQtIFRyYW5zQmxrLSBSZXFSZWRpci0gQ21wbHRSZWRpci0g
VXBzdHJlYW1Gd2QtIEVncmVzc0N0cmwtIERpcmVjdFRyYW5zLQoJQ2FwYWJpbGl0aWVzOiBb
MTUwIHYxXSBQcmVjaXNpb24gVGltZSBNZWFzdXJlbWVudAoJCVBUTUNhcDogUmVxdWVzdGVy
Oi0gUmVzcG9uZGVyOisgUm9vdDorCgkJUFRNQ2xvY2tHcmFudWxhcml0eTogNG5zCgkJUFRN
Q29udHJvbDogRW5hYmxlZDorIFJvb3RTZWxlY3RlZDorCgkJUFRNRWZmZWN0aXZlR3JhbnVs
YXJpdHk6IFVua25vd24KCUNhcGFiaWxpdGllczogWzIyMCB2MV0gU2Vjb25kYXJ5IFBDSSBF
eHByZXNzCgkJTG5rQ3RsMzogTG5rRXF1SW50cnJ1cHRFbi0gUGVyZm9ybUVxdS0KCQlMYW5l
RXJyU3RhdDogMAoJQ2FwYWJpbGl0aWVzOiBbMjUwIHYxXSBEb3duc3RyZWFtIFBvcnQgQ29u
dGFpbm1lbnQKCQlEcGNDYXA6CUlOVCBNc2cgIzAsIFJQRXh0KyBQb2lzb25lZFRMUCsgU3dU
cmlnZ2VyKyBSUCBQSU8gTG9nIDQsIERMX0FjdGl2ZUVycisKCQlEcGNDdGw6CVRyaWdnZXI6
MSBDbXBsLSBJTlQrIEVyckNvci0gUG9pc29uZWRUTFAtIFN3VHJpZ2dlci0gRExfQWN0aXZl
RXJyLQoJCURwY1N0YToJVHJpZ2dlci0gUmVhc29uOjAwIElOVC0gUlBCdXN5LSBUcmlnZ2Vy
RXh0OjAwIFJQIFBJTyBFcnJQdHI6MWYKCQlTb3VyY2U6CTAwMDAKCUtlcm5lbCBkcml2ZXIg
aW4gdXNlOiBwY2llcG9ydAoKMDA6MWUuMCBDb21tdW5pY2F0aW9uIGNvbnRyb2xsZXI6IElu
dGVsIENvcnBvcmF0aW9uIENhbm5vbiBMYWtlIFBDSCBTZXJpYWwgSU8gVUFSVCBIb3N0IENv
bnRyb2xsZXIgKHJldiAxMCkKCURldmljZU5hbWU6IE9uYm9hcmQgLSBPdGhlcgoJU3Vic3lz
dGVtOiBMZW5vdm8gRGV2aWNlIDMxNDAKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIr
IFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlIt
IEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0g
UGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0g
PFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglJ
bnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMjAKCVJlZ2lvbiAwOiBNZW1vcnkgYXQg
YTEyMWUwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3ZpcnR1YWxdIFtzaXplPTRL
XQoJQ2FwYWJpbGl0aWVzOiBbODBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJRmxh
Z3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDEtLEQy
LSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQzIE5vU29mdFJzdCsgUE1FLUVuYWJsZS0g
RFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzkwXSBWZW5kb3IgU3BlY2lm
aWMgSW5mb3JtYXRpb246IExlbj0xNCA8Pz4KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBpbnRl
bC1scHNzCglLZXJuZWwgbW9kdWxlczogaW50ZWxfbHBzc19wY2kKCjAwOjFmLjAgSVNBIGJy
aWRnZTogSW50ZWwgQ29ycG9yYXRpb24gRGV2aWNlIGEzMDggKHJldiAxMCkKCURldmljZU5h
bWU6IE9uYm9hcmQgLSBPdGhlcgoJU3Vic3lzdGVtOiBMZW5vdm8gRGV2aWNlIDMxNDAKCUNv
bnRyb2w6IEkvTysgTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25v
b3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6
IENhcC0gNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9bWVkaXVtID5UQWJv
cnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAK
CjAwOjFmLjMgQXVkaW8gZGV2aWNlOiBJbnRlbCBDb3Jwb3JhdGlvbiBDYW5ub24gTGFrZSBQ
Q0ggY0FWUyAocmV2IDEwKQoJRGV2aWNlTmFtZTogT25ib2FyZCAtIFNvdW5kCglTdWJzeXN0
ZW06IExlbm92byBEZXZpY2UgMzE0MAoJQ29udHJvbDogSS9PLSBNZW0rIEJ1c01hc3Rlcisg
U3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0g
RmFzdEIyQi0gRGlzSU5UeCsKCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQ
YXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8
UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDMyLCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglJ
bnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTI2CglSZWdpb24gMDogTWVtb3J5IGF0
IGExMjEwMDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTE2S10KCVJlZ2lv
biA0OiBNZW1vcnkgYXQgYTEwMDAwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3Np
emU9MU1dCglDYXBhYmlsaXRpZXM6IHBjaWxpYjogc3lzZnNfcmVhZF92cGQ6IHJlYWQgZmFp
bGVkOiBObyBzdWNoIGRldmljZQpbNTBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAzCgkJ
RmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9NTVtQSBQTUUoRDAtLEQx
LSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QrIFBNRS1FbmFi
bGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs4MF0gVmVuZG9yIFNw
ZWNpZmljIEluZm9ybWF0aW9uOiBMZW49MTQgPD8+CglDYXBhYmlsaXRpZXM6IFs2MF0gTVNJ
OiBFbmFibGUrIENvdW50PTEvMSBNYXNrYWJsZS0gNjRiaXQrCgkJQWRkcmVzczogMDAwMDAw
MDBmZWUwODAwNCAgRGF0YTogMDAyMgoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHNuZF9oZGFf
aW50ZWwKCUtlcm5lbCBtb2R1bGVzOiBzbmRfaGRhX2ludGVsCgowMDoxZi40IFNNQnVzOiBJ
bnRlbCBDb3Jwb3JhdGlvbiBDYW5ub24gTGFrZSBQQ0ggU01CdXMgQ29udHJvbGxlciAocmV2
IDEwKQoJRGV2aWNlTmFtZTogT25ib2FyZCAtIE90aGVyCglTdWJzeXN0ZW06IExlbm92byBE
ZXZpY2UgMzE0MAoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3Rlci0gU3BlY0N5Y2xlLSBN
ZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlz
SU5UeC0KCVN0YXR1czogQ2FwLSA2Nk1Iei0gVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNF
TD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4
LQoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDE2CglSZWdpb24gMDogTWVtb3J5
IGF0IGExMjE4MDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTI1Nl0KCVJl
Z2lvbiA0OiBJL08gcG9ydHMgYXQgZWZhMCBbc2l6ZT0zMl0KCUtlcm5lbCBkcml2ZXIgaW4g
dXNlOiBpODAxX3NtYnVzCglLZXJuZWwgbW9kdWxlczogaTJjX2k4MDEKCjAwOjFmLjUgU2Vy
aWFsIGJ1cyBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiBDYW5ub24gTGFrZSBQQ0gg
U1BJIENvbnRyb2xsZXIgKHJldiAxMCkKCURldmljZU5hbWU6IE9uYm9hcmQgLSBPdGhlcgoJ
U3Vic3lzdGVtOiBMZW5vdm8gRGV2aWNlIDMxNDAKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNN
YXN0ZXItIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmct
IFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENhcC0gNjZNSHotIFVERi0gRmFz
dEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+
U0VSUi0gPFBFUlItIElOVHgtCglSZWdpb24gMDogTWVtb3J5IGF0IGZlMDEwMDAwICgzMi1i
aXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTRLXQoKMDE6MDAuMCBFdGhlcm5ldCBjb250
cm9sbGVyOiBSZWFsdGVrIFNlbWljb25kdWN0b3IgQ28uLCBMdGQuIFJUTDgxMTEvODE2OC84
NDExIFBDSSBFeHByZXNzIEdpZ2FiaXQgRXRoZXJuZXQgQ29udHJvbGxlciAocmV2IDE1KQoJ
U3Vic3lzdGVtOiBMZW5vdm8gRGV2aWNlIDMxNDAKCUNvbnRyb2w6IEkvTysgTWVtKyBCdXNN
YXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmct
IFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFz
dEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+
U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5
dGVzCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTgKCVJlZ2lvbiAwOiBJL08g
cG9ydHMgYXQgMzAwMCBbc2l6ZT0yNTZdCglSZWdpb24gMjogTWVtb3J5IGF0IGExMTA0MDAw
ICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTRLXQoJUmVnaW9uIDQ6IE1lbW9y
eSBhdCBhMTEwMDAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0xNktdCglD
YXBhYmlsaXRpZXM6IFs0MF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDMKCQlGbGFnczog
UE1FQ2xrLSBEU0ktIEQxKyBEMisgQXV4Q3VycmVudD0zNzVtQSBQTUUoRDArLEQxKyxEMiss
RDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QrIFBNRS1FbmFibGUtIERT
ZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs1MF0gTVNJOiBFbmFibGUtIENv
dW50PTEvMSBNYXNrYWJsZS0gNjRiaXQrCgkJQWRkcmVzczogMDAwMDAwMDAwMDAwMDAwMCAg
RGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbNzBdIEV4cHJlc3MgKHYyKSBFbmRwb2ludCwg
TVNJIDAxCgkJRGV2Q2FwOglNYXhQYXlsb2FkIDEyOCBieXRlcywgUGhhbnRGdW5jIDAsIExh
dGVuY3kgTDBzIDw1MTJucywgTDEgPDY0dXMKCQkJRXh0VGFnLSBBdHRuQnRuLSBBdHRuSW5k
LSBQd3JJbmQtIFJCRSsgRkxSZXNldC0gU2xvdFBvd2VyTGltaXQgMTAuMDAwVwoJCURldkN0
bDoJQ29yckVycisgTm9uRmF0YWxFcnIrIEZhdGFsRXJyKyBVbnN1cFJlcSsKCQkJUmx4ZE9y
ZCsgRXh0VGFnLSBQaGFudEZ1bmMtIEF1eFB3ci0gTm9Tbm9vcC0KCQkJTWF4UGF5bG9hZCAx
MjggYnl0ZXMsIE1heFJlYWRSZXEgNDA5NiBieXRlcwoJCURldlN0YToJQ29yckVyci0gTm9u
RmF0YWxFcnItIEZhdGFsRXJyLSBVbnN1cFJlcS0gQXV4UHdyKyBUcmFuc1BlbmQtCgkJTG5r
Q2FwOglQb3J0ICMwLCBTcGVlZCAyLjVHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMHMgTDEsIEV4
aXQgTGF0ZW5jeSBMMHMgdW5saW1pdGVkLCBMMSA8NjR1cwoJCQlDbG9ja1BNKyBTdXJwcmlz
ZS0gTExBY3RSZXAtIEJ3Tm90LSBBU1BNT3B0Q29tcCsKCQlMbmtDdGw6CUFTUE0gTDEgRW5h
YmxlZDsgUkNCIDY0IGJ5dGVzLCBEaXNhYmxlZC0gQ29tbUNsaysKCQkJRXh0U3luY2gtIENs
b2NrUE0tIEF1dFdpZERpcy0gQldJbnQtIEF1dEJXSW50LQoJCUxua1N0YToJU3BlZWQgMi41
R1QvcyAob2spLCBXaWR0aCB4MSAob2spCgkJCVRyRXJyLSBUcmFpbi0gU2xvdENsaysgRExB
Y3RpdmUtIEJXTWdtdC0gQUJXTWdtdC0KCQlEZXZDYXAyOiBDb21wbGV0aW9uIFRpbWVvdXQ6
IFJhbmdlIEFCQ0QsIFRpbWVvdXREaXMrIE5ST1ByUHJQLSBMVFIrCgkJCSAxMEJpdFRhZ0Nv
bXAtIDEwQml0VGFnUmVxLSBPQkZGIFZpYSBtZXNzYWdlL1dBS0UjLCBFeHRGbXQtIEVFVExQ
UHJlZml4LQoJCQkgRW1lcmdlbmN5UG93ZXJSZWR1Y3Rpb24gTm90IFN1cHBvcnRlZCwgRW1l
cmdlbmN5UG93ZXJSZWR1Y3Rpb25Jbml0LQoJCQkgRlJTLSBUUEhDb21wLSBFeHRUUEhDb21w
LQoJCQkgQXRvbWljT3BzQ2FwOiAzMmJpdC0gNjRiaXQtIDEyOGJpdENBUy0KCQlEZXZDdGwy
OiBDb21wbGV0aW9uIFRpbWVvdXQ6IDUwdXMgdG8gNTBtcywgVGltZW91dERpcy0gTFRSKyBP
QkZGIERpc2FibGVkLAoJCQkgQXRvbWljT3BzQ3RsOiBSZXFFbi0KCQlMbmtDYXAyOiBTdXBw
b3J0ZWQgTGluayBTcGVlZHM6IDIuNUdUL3MsIENyb3NzbGluay0gUmV0aW1lci0gMlJldGlt
ZXJzLSBEUlMtCgkJTG5rQ3RsMjogVGFyZ2V0IExpbmsgU3BlZWQ6IDIuNUdUL3MsIEVudGVy
Q29tcGxpYW5jZS0gU3BlZWREaXMtCgkJCSBUcmFuc21pdCBNYXJnaW46IE5vcm1hbCBPcGVy
YXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlhbmNlLSBDb21wbGlhbmNlU09TLQoJ
CQkgQ29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJCUxua1N0YTI6IEN1cnJlbnQgRGUt
ZW1waGFzaXMgTGV2ZWw6IC02ZEIsIEVxdWFsaXphdGlvbkNvbXBsZXRlLSBFcXVhbGl6YXRp
b25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFzZTItIEVxdWFsaXphdGlvblBoYXNlMy0g
TGlua0VxdWFsaXphdGlvblJlcXVlc3QtCgkJCSBSZXRpbWVyLSAyUmV0aW1lcnMtIENyb3Nz
bGlua1JlczogdW5zdXBwb3J0ZWQKCUNhcGFiaWxpdGllczogW2IwXSBNU0ktWDogRW5hYmxl
KyBDb3VudD00IE1hc2tlZC0KCQlWZWN0b3IgdGFibGU6IEJBUj00IG9mZnNldD0wMDAwMDAw
MAoJCVBCQTogQkFSPTQgb2Zmc2V0PTAwMDAwODAwCglDYXBhYmlsaXRpZXM6IFtkMF0gVml0
YWwgUHJvZHVjdCBEYXRhCgkJTm90IHJlYWRhYmxlCglDYXBhYmlsaXRpZXM6IFsxMDAgdjJd
IEFkdmFuY2VkIEVycm9yIFJlcG9ydGluZwoJCVVFU3RhOglETFAtIFNERVMtIFRMUC0gRkNQ
LSBDbXBsdFRPLSBDbXBsdEFicnQtIFVueENtcGx0LSBSeE9GLSBNYWxmVExQLSBFQ1JDLSBV
bnN1cFJlcS0gQUNTVmlvbC0KCQlVRU1zazoJRExQLSBTREVTLSBUTFAtIEZDUC0gQ21wbHRU
Ty0gQ21wbHRBYnJ0LSBVbnhDbXBsdC0gUnhPRi0gTWFsZlRMUC0gRUNSQy0gVW5zdXBSZXEr
IEFDU1Zpb2wtCgkJVUVTdnJ0OglETFArIFNERVMrIFRMUC0gRkNQKyBDbXBsdFRPLSBDbXBs
dEFicnQtIFVueENtcGx0LSBSeE9GKyBNYWxmVExQKyBFQ1JDLSBVbnN1cFJlcS0gQUNTVmlv
bC0KCQlDRVN0YToJUnhFcnItIEJhZFRMUC0gQmFkRExMUC0gUm9sbG92ZXItIFRpbWVvdXQt
IEFkdk5vbkZhdGFsRXJyLQoJCUNFTXNrOglSeEVyci0gQmFkVExQLSBCYWRETExQLSBSb2xs
b3Zlci0gVGltZW91dC0gQWR2Tm9uRmF0YWxFcnItCgkJQUVSQ2FwOglGaXJzdCBFcnJvciBQ
b2ludGVyOiAwMCwgRUNSQ0dlbkNhcCsgRUNSQ0dlbkVuLSBFQ1JDQ2hrQ2FwKyBFQ1JDQ2hr
RW4tCgkJCU11bHRIZHJSZWNDYXAtIE11bHRIZHJSZWNFbi0gVExQUGZ4UHJlcy0gSGRyTG9n
Q2FwLQoJCUhlYWRlckxvZzogMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAK
CUNhcGFiaWxpdGllczogWzE0MCB2MV0gVmlydHVhbCBDaGFubmVsCgkJQ2FwczoJTFBFVkM9
MCBSZWZDbGs9MTAwbnMgUEFURW50cnlCaXRzPTEKCQlBcmI6CUZpeGVkLSBXUlIzMi0gV1JS
NjQtIFdSUjEyOC0KCQlDdHJsOglBcmJTZWxlY3Q9Rml4ZWQKCQlTdGF0dXM6CUluUHJvZ3Jl
c3MtCgkJVkMwOglDYXBzOglQQVRPZmZzZXQ9MDAgTWF4VGltZVNsb3RzPTEgUmVqU25vb3BU
cmFucy0KCQkJQXJiOglGaXhlZC0gV1JSMzItIFdSUjY0LSBXUlIxMjgtIFRXUlIxMjgtIFdS
UjI1Ni0KCQkJQ3RybDoJRW5hYmxlKyBJRD0wIEFyYlNlbGVjdD1GaXhlZCBUQy9WQz1mZgoJ
CQlTdGF0dXM6CU5lZ29QZW5kaW5nLSBJblByb2dyZXNzLQoJQ2FwYWJpbGl0aWVzOiBbMTYw
IHYxXSBEZXZpY2UgU2VyaWFsIE51bWJlciAwMS0wMC0wMC0wMC02OC00Yy1lMC0wMAoJQ2Fw
YWJpbGl0aWVzOiBbMTcwIHYxXSBMYXRlbmN5IFRvbGVyYW5jZSBSZXBvcnRpbmcKCQlNYXgg
c25vb3AgbGF0ZW5jeTogMzE0NTcyOG5zCgkJTWF4IG5vIHNub29wIGxhdGVuY3k6IDMxNDU3
MjhucwoJQ2FwYWJpbGl0aWVzOiBbMTc4IHYxXSBMMSBQTSBTdWJzdGF0ZXMKCQlMMVN1YkNh
cDogUENJLVBNX0wxLjIrIFBDSS1QTV9MMS4xKyBBU1BNX0wxLjIrIEFTUE1fTDEuMSsgTDFf
UE1fU3Vic3RhdGVzKwoJCQkgIFBvcnRDb21tb25Nb2RlUmVzdG9yZVRpbWU9MTUwdXMgUG9y
dFRQb3dlck9uVGltZT0xNTB1cwoJCUwxU3ViQ3RsMTogUENJLVBNX0wxLjItIFBDSS1QTV9M
MS4xLSBBU1BNX0wxLjItIEFTUE1fTDEuMS0KCQkJICAgVF9Db21tb25Nb2RlPTB1cyBMVFIx
LjJfVGhyZXNob2xkPTgxOTIwbnMKCQlMMVN1YkN0bDI6IFRfUHdyT249MTUwdXMKCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiByODE2OQoJS2VybmVsIG1vZHVsZXM6IHI4MTY5Cgo=
--------------CoiMGBWzuGmhy00b87g5FQid
Content-Type: text/plain; charset=UTF-8; name="lshw-pc-lenovo.txt"
Content-Disposition: attachment; filename="lshw-pc-lenovo.txt"
Content-Transfer-Encoding: base64

cGMtbXRvZG9yb3Yuc2xhdmEuYWx1LmhyCiAgICBkZXNjcmlwdGlvbjogRGVza3RvcCBDb21w
dXRlcgogICAgcHJvZHVjdDogMTBUWDAwMFZDUiAoTEVOT1ZPX01UXzEwVFhfQlVfTGVub3Zv
X0ZNX1Y1MzBTLTA3SUNCKQogICAgdmVuZG9yOiBMRU5PVk8KICAgIHZlcnNpb246IFY1MzBT
LTA3SUNCCiAgICBzZXJpYWw6IFlMMDA0Q0RDCiAgICB3aWR0aDogNjQgYml0cwogICAgY2Fw
YWJpbGl0aWVzOiBzbWJpb3MtMy4yLjEgZG1pLTMuMi4xIHNtcCB2c3lzY2FsbDMyCiAgICBj
b25maWd1cmF0aW9uOiBhZG1pbmlzdHJhdG9yX3Bhc3N3b3JkPWRpc2FibGVkIGJvb3Q9bm9y
bWFsIGNoYXNzaXM9ZGVza3RvcCBmYW1pbHk9VjUzMFMtMDdJQ0Iga2V5Ym9hcmRfcGFzc3dv
cmQ9ZW5hYmxlZCBwb3dlci1vbl9wYXNzd29yZD1kaXNhYmxlZCBza3U9TEVOT1ZPX01UXzEw
VFhfQlVfTGVub3ZvX0ZNX1Y1MzBTLTA3SUNCIHV1aWQ9NGZiOTNhMDAtYmIzNS0xMWU4LWJi
MGEtNTk1OTllMGEyZTAwCiAgKi1jb3JlCiAgICAgICBkZXNjcmlwdGlvbjogTW90aGVyYm9h
cmQKICAgICAgIHByb2R1Y3Q6IDMxNDAKICAgICAgIHZlbmRvcjogTEVOT1ZPCiAgICAgICBw
aHlzaWNhbCBpZDogMAogICAgICAgdmVyc2lvbjogU0RLMEo0MDY5NyBXSU4gMzMwNTE0ODIw
NDcwOAogICAgICAgc2xvdDogRGVmYXVsdCBzdHJpbmcKICAgICAqLWZpcm13YXJlCiAgICAg
ICAgICBkZXNjcmlwdGlvbjogQklPUwogICAgICAgICAgdmVuZG9yOiBMRU5PVk8KICAgICAg
ICAgIHBoeXNpY2FsIGlkOiAwCiAgICAgICAgICB2ZXJzaW9uOiBNMjJLVDQ5QQogICAgICAg
ICAgZGF0ZTogMTEvMTAvMjAyMgogICAgICAgICAgc2l6ZTogNjRLaUIKICAgICAgICAgIGNh
cGFjaXR5OiAxNk1pQgogICAgICAgICAgY2FwYWJpbGl0aWVzOiBwY2kgdXBncmFkZSBzaGFk
b3dpbmcgY2Rib290IGJvb3RzZWxlY3Qgc29ja2V0ZWRyb20gZWRkIGludDEzZmxvcHB5MTIw
MCBpbnQxM2Zsb3BweTcyMCBpbnQxM2Zsb3BweTI4ODAgaW50NXByaW50c2NyZWVuIGludDlr
ZXlib2FyZCBpbnQxNHNlcmlhbCBpbnQxN3ByaW50ZXIgYWNwaSB1c2IgYmlvc2Jvb3RzcGVj
aWZpY2F0aW9uIHVlZmkKICAgICAqLW1lbW9yeQogICAgICAgICAgZGVzY3JpcHRpb246IFN5
c3RlbSBNZW1vcnkKICAgICAgICAgIHBoeXNpY2FsIGlkOiAzYgogICAgICAgICAgc2xvdDog
U3lzdGVtIGJvYXJkIG9yIG1vdGhlcmJvYXJkCiAgICAgICAgICBzaXplOiAxNkdpQgogICAg
ICAgICotYmFuazowCiAgICAgICAgICAgICBkZXNjcmlwdGlvbjogRElNTSBERFI0IFN5bmNo
cm9ub3VzIDI2NjYgTUh6ICgwLjQgbnMpCiAgICAgICAgICAgICBwcm9kdWN0OiBSTVVBNTEx
ME1FNzhIQUYtMjY2NgogICAgICAgICAgICAgdmVuZG9yOiBGdWppdHN1CiAgICAgICAgICAg
ICBwaHlzaWNhbCBpZDogMAogICAgICAgICAgICAgc2VyaWFsOiAxNDkwM0M3QwogICAgICAg
ICAgICAgc2xvdDogQ2hhbm5lbEEtRElNTTEKICAgICAgICAgICAgIHNpemU6IDhHaUIKICAg
ICAgICAgICAgIHdpZHRoOiA2NCBiaXRzCiAgICAgICAgICAgICBjbG9jazogMjY2Nk1IeiAo
MC40bnMpCiAgICAgICAgKi1iYW5rOjEKICAgICAgICAgICAgIGRlc2NyaXB0aW9uOiBESU1N
IEREUjQgU3luY2hyb25vdXMgMjY2NiBNSHogKDAuNCBucykKICAgICAgICAgICAgIHByb2R1
Y3Q6IEpNMjY2NkhMQi04RwogICAgICAgICAgICAgdmVuZG9yOiBUcmFuc2NlbmQKICAgICAg
ICAgICAgIHBoeXNpY2FsIGlkOiAxCiAgICAgICAgICAgICBzZXJpYWw6IDAwMDAyODE0CiAg
ICAgICAgICAgICBzbG90OiBDaGFubmVsQi1ESU1NMgogICAgICAgICAgICAgc2l6ZTogOEdp
QgogICAgICAgICAgICAgd2lkdGg6IDY0IGJpdHMKICAgICAgICAgICAgIGNsb2NrOiAyNjY2
TUh6ICgwLjRucykKICAgICAqLWNhY2hlOjAKICAgICAgICAgIGRlc2NyaXB0aW9uOiBMMSBj
YWNoZQogICAgICAgICAgcGh5c2ljYWwgaWQ6IDQ2CiAgICAgICAgICBzbG90OiBMMSBDYWNo
ZQogICAgICAgICAgc2l6ZTogMzg0S2lCCiAgICAgICAgICBjYXBhY2l0eTogMzg0S2lCCiAg
ICAgICAgICBjYXBhYmlsaXRpZXM6IHN5bmNocm9ub3VzIGludGVybmFsIHdyaXRlLWJhY2sg
dW5pZmllZAogICAgICAgICAgY29uZmlndXJhdGlvbjogbGV2ZWw9MQogICAgICotY2FjaGU6
MQogICAgICAgICAgZGVzY3JpcHRpb246IEwyIGNhY2hlCiAgICAgICAgICBwaHlzaWNhbCBp
ZDogNDcKICAgICAgICAgIHNsb3Q6IEwyIENhY2hlCiAgICAgICAgICBzaXplOiAxNTM2S2lC
CiAgICAgICAgICBjYXBhY2l0eTogMTUzNktpQgogICAgICAgICAgY2FwYWJpbGl0aWVzOiBz
eW5jaHJvbm91cyBpbnRlcm5hbCB3cml0ZS1iYWNrIHVuaWZpZWQKICAgICAgICAgIGNvbmZp
Z3VyYXRpb246IGxldmVsPTIKICAgICAqLWNhY2hlOjIKICAgICAgICAgIGRlc2NyaXB0aW9u
OiBMMyBjYWNoZQogICAgICAgICAgcGh5c2ljYWwgaWQ6IDQ4CiAgICAgICAgICBzbG90OiBM
MyBDYWNoZQogICAgICAgICAgc2l6ZTogOU1pQgogICAgICAgICAgY2FwYWNpdHk6IDlNaUIK
ICAgICAgICAgIGNhcGFiaWxpdGllczogc3luY2hyb25vdXMgaW50ZXJuYWwgd3JpdGUtYmFj
ayB1bmlmaWVkCiAgICAgICAgICBjb25maWd1cmF0aW9uOiBsZXZlbD0zCiAgICAgKi1jcHUK
ICAgICAgICAgIGRlc2NyaXB0aW9uOiBDUFUKICAgICAgICAgIHByb2R1Y3Q6IEludGVsKFIp
IENvcmUoVE0pIGk1LTg0MDAgQ1BVIEAgMi44MEdIegogICAgICAgICAgdmVuZG9yOiBJbnRl
bCBDb3JwLgogICAgICAgICAgcGh5c2ljYWwgaWQ6IDQ5CiAgICAgICAgICBidXMgaW5mbzog
Y3B1QDAKICAgICAgICAgIHZlcnNpb246IDYuMTU4LjEwCiAgICAgICAgICBzZXJpYWw6IFRv
IEJlIEZpbGxlZCBCeSBPLkUuTS4KICAgICAgICAgIHNsb3Q6IFUzRTEKICAgICAgICAgIHNp
emU6IDM4OTlNSHoKICAgICAgICAgIGNhcGFjaXR5OiA0MDA1TUh6CiAgICAgICAgICB3aWR0
aDogNjQgYml0cwogICAgICAgICAgY2xvY2s6IDEwME1IegogICAgICAgICAgY2FwYWJpbGl0
aWVzOiBsbSBmcHUgZnB1X2V4Y2VwdGlvbiB3cCB2bWUgZGUgcHNlIHRzYyBtc3IgcGFlIG1j
ZSBjeDggYXBpYyBzZXAgbXRyciBwZ2UgbWNhIGNtb3YgcGF0IHBzZTM2IGNsZmx1c2ggZHRz
IGFjcGkgbW14IGZ4c3Igc3NlIHNzZTIgc3MgaHQgdG0gcGJlIHN5c2NhbGwgbnggcGRwZTFn
YiByZHRzY3AgeDg2LTY0IGNvbnN0YW50X3RzYyBhcnQgYXJjaF9wZXJmbW9uIHBlYnMgYnRz
IHJlcF9nb29kIG5vcGwgeHRvcG9sb2d5IG5vbnN0b3BfdHNjIGNwdWlkIGFwZXJmbXBlcmYg
cG5pIHBjbG11bHFkcSBkdGVzNjQgbW9uaXRvciBkc19jcGwgdm14IGVzdCB0bTIgc3NzZTMg
c2RiZyBmbWEgY3gxNiB4dHByIHBkY20gcGNpZCBzc2U0XzEgc3NlNF8yIHgyYXBpYyBtb3Zi
ZSBwb3BjbnQgdHNjX2RlYWRsaW5lX3RpbWVyIGFlcyB4c2F2ZSBhdnggZjE2YyByZHJhbmQg
bGFoZl9sbSBhYm0gM2Rub3dwcmVmZXRjaCBjcHVpZF9mYXVsdCBlcGIgaW52cGNpZF9zaW5n
bGUgcHRpIHNzYmQgaWJycyBpYnBiIHN0aWJwIHRwcl9zaGFkb3cgdm5taSBmbGV4cHJpb3Jp
dHkgZXB0IHZwaWQgZXB0X2FkIGZzZ3NiYXNlIHRzY19hZGp1c3QgYm1pMSBhdngyIHNtZXAg
Ym1pMiBlcm1zIGludnBjaWQgbXB4IHJkc2VlZCBhZHggc21hcCBjbGZsdXNob3B0IGludGVs
X3B0IHhzYXZlb3B0IHhzYXZlYyB4Z2V0YnYxIHhzYXZlcyBkdGhlcm0gaWRhIGFyYXQgcGxu
IHB0cyBod3AgaHdwX25vdGlmeSBod3BfYWN0X3dpbmRvdyBod3BfZXBwIG1kX2NsZWFyIGZs
dXNoX2wxZCBhcmNoX2NhcGFiaWxpdGllcyBjcHVmcmVxCiAgICAgICAgICBjb25maWd1cmF0
aW9uOiBjb3Jlcz02IGVuYWJsZWRjb3Jlcz02IG1pY3JvY29kZT0yNDAgdGhyZWFkcz02CiAg
ICAgKi1wY2kKICAgICAgICAgIGRlc2NyaXB0aW9uOiBIb3N0IGJyaWRnZQogICAgICAgICAg
cHJvZHVjdDogOHRoIEdlbiBDb3JlIFByb2Nlc3NvciBIb3N0IEJyaWRnZS9EUkFNIFJlZ2lz
dGVycwogICAgICAgICAgdmVuZG9yOiBJbnRlbCBDb3Jwb3JhdGlvbgogICAgICAgICAgcGh5
c2ljYWwgaWQ6IDEwMAogICAgICAgICAgYnVzIGluZm86IHBjaUAwMDAwOjAwOjAwLjAKICAg
ICAgICAgIHZlcnNpb246IDA3CiAgICAgICAgICB3aWR0aDogMzIgYml0cwogICAgICAgICAg
Y2xvY2s6IDMzTUh6CiAgICAgICAgICBjb25maWd1cmF0aW9uOiBkcml2ZXI9c2tsX3VuY29y
ZQogICAgICAgICAgcmVzb3VyY2VzOiBpcnE6MAogICAgICAgICotZGlzcGxheQogICAgICAg
ICAgICAgZGVzY3JpcHRpb246IFZHQSBjb21wYXRpYmxlIGNvbnRyb2xsZXIKICAgICAgICAg
ICAgIHByb2R1Y3Q6IENvZmZlZUxha2UtUyBHVDIgW1VIRCBHcmFwaGljcyA2MzBdCiAgICAg
ICAgICAgICB2ZW5kb3I6IEludGVsIENvcnBvcmF0aW9uCiAgICAgICAgICAgICBwaHlzaWNh
bCBpZDogMgogICAgICAgICAgICAgYnVzIGluZm86IHBjaUAwMDAwOjAwOjAyLjAKICAgICAg
ICAgICAgIHZlcnNpb246IDAwCiAgICAgICAgICAgICB3aWR0aDogNjQgYml0cwogICAgICAg
ICAgICAgY2xvY2s6IDMzTUh6CiAgICAgICAgICAgICBjYXBhYmlsaXRpZXM6IHBjaWV4cHJl
c3MgbXNpIHBtIHZnYV9jb250cm9sbGVyIGJ1c19tYXN0ZXIgY2FwX2xpc3Qgcm9tCiAgICAg
ICAgICAgICBjb25maWd1cmF0aW9uOiBkcml2ZXI9aTkxNSBsYXRlbmN5PTAKICAgICAgICAg
ICAgIHJlc291cmNlczogaXJxOjEyNCBtZW1vcnk6YTAwMDAwMDAtYTBmZmZmZmYgbWVtb3J5
OjkwMDAwMDAwLTlmZmZmZmZmIGlvcG9ydDo0MDAwKHNpemU9NjQpIG1lbW9yeTpjMDAwMC1k
ZmZmZgogICAgICAgICotZ2VuZXJpYzowIFVOQ0xBSU1FRAogICAgICAgICAgICAgZGVzY3Jp
cHRpb246IFN5c3RlbSBwZXJpcGhlcmFsCiAgICAgICAgICAgICBwcm9kdWN0OiBYZW9uIEUz
LTEyMDAgdjUvdjYgLyBFMy0xNTAwIHY1IC8gNnRoLzd0aC84dGggR2VuIENvcmUgUHJvY2Vz
c29yIEdhdXNzaWFuIE1peHR1cmUgTW9kZWwKICAgICAgICAgICAgIHZlbmRvcjogSW50ZWwg
Q29ycG9yYXRpb24KICAgICAgICAgICAgIHBoeXNpY2FsIGlkOiA4CiAgICAgICAgICAgICBi
dXMgaW5mbzogcGNpQDAwMDA6MDA6MDguMAogICAgICAgICAgICAgdmVyc2lvbjogMDAKICAg
ICAgICAgICAgIHdpZHRoOiA2NCBiaXRzCiAgICAgICAgICAgICBjbG9jazogMzNNSHoKICAg
ICAgICAgICAgIGNhcGFiaWxpdGllczogbXNpIHBtIGNhcF9saXN0CiAgICAgICAgICAgICBj
b25maWd1cmF0aW9uOiBsYXRlbmN5PTAKICAgICAgICAgICAgIHJlc291cmNlczogbWVtb3J5
OmExMjIxMDAwLWExMjIxZmZmCiAgICAgICAgKi1nZW5lcmljOjEKICAgICAgICAgICAgIGRl
c2NyaXB0aW9uOiBTaWduYWwgcHJvY2Vzc2luZyBjb250cm9sbGVyCiAgICAgICAgICAgICBw
cm9kdWN0OiBDYW5ub24gTGFrZSBQQ0ggVGhlcm1hbCBDb250cm9sbGVyCiAgICAgICAgICAg
ICB2ZW5kb3I6IEludGVsIENvcnBvcmF0aW9uCiAgICAgICAgICAgICBwaHlzaWNhbCBpZDog
MTIKICAgICAgICAgICAgIGJ1cyBpbmZvOiBwY2lAMDAwMDowMDoxMi4wCiAgICAgICAgICAg
ICB2ZXJzaW9uOiAxMAogICAgICAgICAgICAgd2lkdGg6IDY0IGJpdHMKICAgICAgICAgICAg
IGNsb2NrOiAzM01IegogICAgICAgICAgICAgY2FwYWJpbGl0aWVzOiBwbSBtc2kgY2FwX2xp
c3QKICAgICAgICAgICAgIGNvbmZpZ3VyYXRpb246IGRyaXZlcj1pbnRlbF9wY2hfdGhlcm1h
bCBsYXRlbmN5PTAKICAgICAgICAgICAgIHJlc291cmNlczogaXJxOjE2IG1lbW9yeTphMTIy
MDAwMC1hMTIyMGZmZgogICAgICAgICotdXNiCiAgICAgICAgICAgICBkZXNjcmlwdGlvbjog
VVNCIGNvbnRyb2xsZXIKICAgICAgICAgICAgIHByb2R1Y3Q6IENhbm5vbiBMYWtlIFBDSCBV
U0IgMy4xIHhIQ0kgSG9zdCBDb250cm9sbGVyCiAgICAgICAgICAgICB2ZW5kb3I6IEludGVs
IENvcnBvcmF0aW9uCiAgICAgICAgICAgICBwaHlzaWNhbCBpZDogMTQKICAgICAgICAgICAg
IGJ1cyBpbmZvOiBwY2lAMDAwMDowMDoxNC4wCiAgICAgICAgICAgICB2ZXJzaW9uOiAxMAog
ICAgICAgICAgICAgd2lkdGg6IDY0IGJpdHMKICAgICAgICAgICAgIGNsb2NrOiAzM01Iegog
ICAgICAgICAgICAgY2FwYWJpbGl0aWVzOiBwbSBtc2kgeGhjaSBidXNfbWFzdGVyIGNhcF9s
aXN0CiAgICAgICAgICAgICBjb25maWd1cmF0aW9uOiBkcml2ZXI9eGhjaV9oY2QgbGF0ZW5j
eT0wCiAgICAgICAgICAgICByZXNvdXJjZXM6IGlycToxMjEgbWVtb3J5OmExMjAwMDAwLWEx
MjBmZmZmCiAgICAgICAgICAgKi11c2Job3N0OjAKICAgICAgICAgICAgICAgIHByb2R1Y3Q6
IHhIQ0kgSG9zdCBDb250cm9sbGVyCiAgICAgICAgICAgICAgICB2ZW5kb3I6IExpbnV4IDYu
My4wLW5vdHBtLXR4LTAwNDM2LWcxNzNlYTc0M2JmN2EtZGlydHkgeGhjaS1oY2QKICAgICAg
ICAgICAgICAgIHBoeXNpY2FsIGlkOiAwCiAgICAgICAgICAgICAgICBidXMgaW5mbzogdXNi
QDEKICAgICAgICAgICAgICAgIGxvZ2ljYWwgbmFtZTogdXNiMQogICAgICAgICAgICAgICAg
dmVyc2lvbjogNi4wMwogICAgICAgICAgICAgICAgY2FwYWJpbGl0aWVzOiB1c2ItMi4wMAog
ICAgICAgICAgICAgICAgY29uZmlndXJhdGlvbjogZHJpdmVyPWh1YiBzbG90cz0xNiBzcGVl
ZD00ODBNYml0L3MKICAgICAgICAgICAgICAqLXVzYjowCiAgICAgICAgICAgICAgICAgICBk
ZXNjcmlwdGlvbjogS2V5Ym9hcmQKICAgICAgICAgICAgICAgICAgIHByb2R1Y3Q6IExlbm92
byBMZW5vdm8gQ2FsbGlvcGUgVVNCIEtleWJvYXJkIENvbnN1bWVyIENvbnRyb2wKICAgICAg
ICAgICAgICAgICAgIHZlbmRvcjogTGVub3ZvCiAgICAgICAgICAgICAgICAgICBwaHlzaWNh
bCBpZDogMQogICAgICAgICAgICAgICAgICAgYnVzIGluZm86IHVzYkAxOjEKICAgICAgICAg
ICAgICAgICAgIGxvZ2ljYWwgbmFtZTogaW5wdXQzCiAgICAgICAgICAgICAgICAgICBsb2dp
Y2FsIG5hbWU6IC9kZXYvaW5wdXQvZXZlbnQzCiAgICAgICAgICAgICAgICAgICBsb2dpY2Fs
IG5hbWU6IGlucHV0Mzo6Y2Fwc2xvY2sKICAgICAgICAgICAgICAgICAgIGxvZ2ljYWwgbmFt
ZTogaW5wdXQzOjpudW1sb2NrCiAgICAgICAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6IGlu
cHV0Mzo6c2Nyb2xsbG9jawogICAgICAgICAgICAgICAgICAgbG9naWNhbCBuYW1lOiBpbnB1
dDQKICAgICAgICAgICAgICAgICAgIGxvZ2ljYWwgbmFtZTogL2Rldi9pbnB1dC9ldmVudDQK
ICAgICAgICAgICAgICAgICAgIGxvZ2ljYWwgbmFtZTogaW5wdXQ1CiAgICAgICAgICAgICAg
ICAgICBsb2dpY2FsIG5hbWU6IC9kZXYvaW5wdXQvZXZlbnQ1CiAgICAgICAgICAgICAgICAg
ICBsb2dpY2FsIG5hbWU6IC9kZXYvaW5wdXQvanMwCiAgICAgICAgICAgICAgICAgICB2ZXJz
aW9uOiAyLjE4CiAgICAgICAgICAgICAgICAgICBjYXBhYmlsaXRpZXM6IHVzYi0yLjAwIHVz
YgogICAgICAgICAgICAgICAgICAgY29uZmlndXJhdGlvbjogZHJpdmVyPXVzYmhpZCBtYXhw
b3dlcj0xMDBtQSBzcGVlZD0yTWJpdC9zCiAgICAgICAgICAgICAgKi11c2I6MQogICAgICAg
ICAgICAgICAgICAgZGVzY3JpcHRpb246IE1vdXNlCiAgICAgICAgICAgICAgICAgICBwcm9k
dWN0OiBQaXhBcnQgbGVub3ZvIFVTQiBPcHRpY2FsIE1vdXNlCiAgICAgICAgICAgICAgICAg
ICB2ZW5kb3I6IFBpeEFydAogICAgICAgICAgICAgICAgICAgcGh5c2ljYWwgaWQ6IDIKICAg
ICAgICAgICAgICAgICAgIGJ1cyBpbmZvOiB1c2JAMToyCiAgICAgICAgICAgICAgICAgICBs
b2dpY2FsIG5hbWU6IGlucHV0NgogICAgICAgICAgICAgICAgICAgbG9naWNhbCBuYW1lOiAv
ZGV2L2lucHV0L2V2ZW50NgogICAgICAgICAgICAgICAgICAgbG9naWNhbCBuYW1lOiAvZGV2
L2lucHV0L21vdXNlMAogICAgICAgICAgICAgICAgICAgdmVyc2lvbjogMS4wMAogICAgICAg
ICAgICAgICAgICAgY2FwYWJpbGl0aWVzOiB1c2ItMi4wMCB1c2IKICAgICAgICAgICAgICAg
ICAgIGNvbmZpZ3VyYXRpb246IGRyaXZlcj11c2JoaWQgbWF4cG93ZXI9MTAwbUEgc3BlZWQ9
Mk1iaXQvcwogICAgICAgICAgICAgICotdXNiOjIKICAgICAgICAgICAgICAgICAgIGRlc2Ny
aXB0aW9uOiBNTUMgSG9zdAogICAgICAgICAgICAgICAgICAgcHJvZHVjdDogVVNCMi4wLUNS
VwogICAgICAgICAgICAgICAgICAgdmVuZG9yOiBHZW5lcmljCiAgICAgICAgICAgICAgICAg
ICBwaHlzaWNhbCBpZDogNgogICAgICAgICAgICAgICAgICAgYnVzIGluZm86IHVzYkAxOjYK
ICAgICAgICAgICAgICAgICAgIGxvZ2ljYWwgbmFtZTogbW1jMAogICAgICAgICAgICAgICAg
ICAgdmVyc2lvbjogMzkuNjAKICAgICAgICAgICAgICAgICAgIHNlcmlhbDogMjAxMDAyMDEz
OTYwMDAwMDAKICAgICAgICAgICAgICAgICAgIGNhcGFiaWxpdGllczogdXNiLTIuMDAKICAg
ICAgICAgICAgICAgICAgIGNvbmZpZ3VyYXRpb246IGRyaXZlcj1ydHN4X3VzYiBtYXhwb3dl
cj01MDBtQSBzcGVlZD00ODBNYml0L3MKICAgICAgICAgICAqLXVzYmhvc3Q6MQogICAgICAg
ICAgICAgICAgcHJvZHVjdDogeEhDSSBIb3N0IENvbnRyb2xsZXIKICAgICAgICAgICAgICAg
IHZlbmRvcjogTGludXggNi4zLjAtbm90cG0tdHgtMDA0MzYtZzE3M2VhNzQzYmY3YS1kaXJ0
eSB4aGNpLWhjZAogICAgICAgICAgICAgICAgcGh5c2ljYWwgaWQ6IDEKICAgICAgICAgICAg
ICAgIGJ1cyBpbmZvOiB1c2JAMgogICAgICAgICAgICAgICAgbG9naWNhbCBuYW1lOiB1c2Iy
CiAgICAgICAgICAgICAgICB2ZXJzaW9uOiA2LjAzCiAgICAgICAgICAgICAgICBjYXBhYmls
aXRpZXM6IHVzYi0zLjEwCiAgICAgICAgICAgICAgICBjb25maWd1cmF0aW9uOiBkcml2ZXI9
aHViIHNsb3RzPTYgc3BlZWQ9MTAwMDBNYml0L3MKICAgICAgICAqLW1lbW9yeSBVTkNMQUlN
RUQKICAgICAgICAgICAgIGRlc2NyaXB0aW9uOiBSQU0gbWVtb3J5CiAgICAgICAgICAgICBw
cm9kdWN0OiBDYW5ub24gTGFrZSBQQ0ggU2hhcmVkIFNSQU0KICAgICAgICAgICAgIHZlbmRv
cjogSW50ZWwgQ29ycG9yYXRpb24KICAgICAgICAgICAgIHBoeXNpY2FsIGlkOiAxNC4yCiAg
ICAgICAgICAgICBidXMgaW5mbzogcGNpQDAwMDA6MDA6MTQuMgogICAgICAgICAgICAgdmVy
c2lvbjogMTAKICAgICAgICAgICAgIHdpZHRoOiA2NCBiaXRzCiAgICAgICAgICAgICBjbG9j
azogMzNNSHogKDMwLjNucykKICAgICAgICAgICAgIGNhcGFiaWxpdGllczogcG0gY2FwX2xp
c3QKICAgICAgICAgICAgIGNvbmZpZ3VyYXRpb246IGxhdGVuY3k9MAogICAgICAgICAgICAg
cmVzb3VyY2VzOiBtZW1vcnk6YTEyMTYwMDAtYTEyMTdmZmYgbWVtb3J5OmExMjFmMDAwLWEx
MjFmZmZmCiAgICAgICAgKi1zZXJpYWw6MAogICAgICAgICAgICAgZGVzY3JpcHRpb246IFNl
cmlhbCBidXMgY29udHJvbGxlcgogICAgICAgICAgICAgcHJvZHVjdDogQ2Fubm9uIExha2Ug
UENIIFNlcmlhbCBJTyBJMkMgQ29udHJvbGxlciAjMAogICAgICAgICAgICAgdmVuZG9yOiBJ
bnRlbCBDb3Jwb3JhdGlvbgogICAgICAgICAgICAgcGh5c2ljYWwgaWQ6IDE1CiAgICAgICAg
ICAgICBidXMgaW5mbzogcGNpQDAwMDA6MDA6MTUuMAogICAgICAgICAgICAgdmVyc2lvbjog
MTAKICAgICAgICAgICAgIHdpZHRoOiA2NCBiaXRzCiAgICAgICAgICAgICBjbG9jazogMzNN
SHoKICAgICAgICAgICAgIGNhcGFiaWxpdGllczogcG0gYnVzX21hc3RlciBjYXBfbGlzdAog
ICAgICAgICAgICAgY29uZmlndXJhdGlvbjogZHJpdmVyPWludGVsLWxwc3MgbGF0ZW5jeT0w
CiAgICAgICAgICAgICByZXNvdXJjZXM6IGlycToxNiBtZW1vcnk6YTEyMTkwMDAtYTEyMTlm
ZmYKICAgICAgICAqLXNlcmlhbDoxCiAgICAgICAgICAgICBkZXNjcmlwdGlvbjogU2VyaWFs
IGJ1cyBjb250cm9sbGVyCiAgICAgICAgICAgICBwcm9kdWN0OiBDYW5ub24gTGFrZSBQQ0gg
U2VyaWFsIElPIEkyQyBDb250cm9sbGVyICMxCiAgICAgICAgICAgICB2ZW5kb3I6IEludGVs
IENvcnBvcmF0aW9uCiAgICAgICAgICAgICBwaHlzaWNhbCBpZDogMTUuMQogICAgICAgICAg
ICAgYnVzIGluZm86IHBjaUAwMDAwOjAwOjE1LjEKICAgICAgICAgICAgIHZlcnNpb246IDEw
CiAgICAgICAgICAgICB3aWR0aDogNjQgYml0cwogICAgICAgICAgICAgY2xvY2s6IDMzTUh6
CiAgICAgICAgICAgICBjYXBhYmlsaXRpZXM6IHBtIGJ1c19tYXN0ZXIgY2FwX2xpc3QKICAg
ICAgICAgICAgIGNvbmZpZ3VyYXRpb246IGRyaXZlcj1pbnRlbC1scHNzIGxhdGVuY3k9MAog
ICAgICAgICAgICAgcmVzb3VyY2VzOiBpcnE6MTcgbWVtb3J5OmExMjFkMDAwLWExMjFkZmZm
CiAgICAgICAgKi1jb21tdW5pY2F0aW9uOjAKICAgICAgICAgICAgIGRlc2NyaXB0aW9uOiBD
b21tdW5pY2F0aW9uIGNvbnRyb2xsZXIKICAgICAgICAgICAgIHByb2R1Y3Q6IENhbm5vbiBM
YWtlIFBDSCBIRUNJIENvbnRyb2xsZXIKICAgICAgICAgICAgIHZlbmRvcjogSW50ZWwgQ29y
cG9yYXRpb24KICAgICAgICAgICAgIHBoeXNpY2FsIGlkOiAxNgogICAgICAgICAgICAgYnVz
IGluZm86IHBjaUAwMDAwOjAwOjE2LjAKICAgICAgICAgICAgIHZlcnNpb246IDEwCiAgICAg
ICAgICAgICB3aWR0aDogNjQgYml0cwogICAgICAgICAgICAgY2xvY2s6IDMzTUh6CiAgICAg
ICAgICAgICBjYXBhYmlsaXRpZXM6IHBtIG1zaSBidXNfbWFzdGVyIGNhcF9saXN0CiAgICAg
ICAgICAgICBjb25maWd1cmF0aW9uOiBkcml2ZXI9bWVpX21lIGxhdGVuY3k9MAogICAgICAg
ICAgICAgcmVzb3VyY2VzOiBpcnE6MTI1IG1lbW9yeTphMTIxYzAwMC1hMTIxY2ZmZgogICAg
ICAgICotc2F0YQogICAgICAgICAgICAgZGVzY3JpcHRpb246IFNBVEEgY29udHJvbGxlcgog
ICAgICAgICAgICAgcHJvZHVjdDogQ2Fubm9uIExha2UgUENIIFNBVEEgQUhDSSBDb250cm9s
bGVyCiAgICAgICAgICAgICB2ZW5kb3I6IEludGVsIENvcnBvcmF0aW9uCiAgICAgICAgICAg
ICBwaHlzaWNhbCBpZDogMTcKICAgICAgICAgICAgIGJ1cyBpbmZvOiBwY2lAMDAwMDowMDox
Ny4wCiAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6IHNjc2kwCiAgICAgICAgICAgICBsb2dp
Y2FsIG5hbWU6IHNjc2kxCiAgICAgICAgICAgICB2ZXJzaW9uOiAxMAogICAgICAgICAgICAg
d2lkdGg6IDMyIGJpdHMKICAgICAgICAgICAgIGNsb2NrOiA2Nk1IegogICAgICAgICAgICAg
Y2FwYWJpbGl0aWVzOiBzYXRhIG1zaSBwbSBhaGNpXzEuMCBidXNfbWFzdGVyIGNhcF9saXN0
IGVtdWxhdGVkCiAgICAgICAgICAgICBjb25maWd1cmF0aW9uOiBkcml2ZXI9YWhjaSBsYXRl
bmN5PTAKICAgICAgICAgICAgIHJlc291cmNlczogaXJxOjEyMiBtZW1vcnk6YTEyMTQwMDAt
YTEyMTVmZmYgbWVtb3J5OmExMjFiMDAwLWExMjFiMGZmIGlvcG9ydDo0MDkwKHNpemU9OCkg
aW9wb3J0OjQwODAoc2l6ZT00KSBpb3BvcnQ6NDA2MChzaXplPTMyKSBtZW1vcnk6YTEyMWEw
MDAtYTEyMWE3ZmYKICAgICAgICAgICAqLWRpc2sKICAgICAgICAgICAgICAgIGRlc2NyaXB0
aW9uOiBBVEEgRGlzawogICAgICAgICAgICAgICAgcHJvZHVjdDogV0RDICBXRFM1MDBHMkIw
QQogICAgICAgICAgICAgICAgdmVuZG9yOiBXZXN0ZXJuIERpZ2l0YWwKICAgICAgICAgICAg
ICAgIHBoeXNpY2FsIGlkOiAwCiAgICAgICAgICAgICAgICBidXMgaW5mbzogc2NzaUAwOjAu
MC4wCiAgICAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6IC9kZXYvc2RhCiAgICAgICAgICAg
ICAgICB2ZXJzaW9uOiAyMFdECiAgICAgICAgICAgICAgICBzZXJpYWw6IDIxMjUxVjgwMDc0
MAogICAgICAgICAgICAgICAgc2l6ZTogNDY1R2lCICg1MDBHQikKICAgICAgICAgICAgICAg
IGNhcGFiaWxpdGllczogZ3B0LTEuMDAgcGFydGl0aW9uZWQgcGFydGl0aW9uZWQ6Z3B0CiAg
ICAgICAgICAgICAgICBjb25maWd1cmF0aW9uOiBhbnNpdmVyc2lvbj01IGd1aWQ9MzM3NDIw
ZjMtZmJkOC00MzdkLWFiOWMtMWE1ZjVmMTRjMWQxIGxvZ2ljYWxzZWN0b3JzaXplPTUxMiBz
ZWN0b3JzaXplPTUxMgogICAgICAgICAgICAgICotdm9sdW1lOjAKICAgICAgICAgICAgICAg
ICAgIGRlc2NyaXB0aW9uOiByZXNlcnZlZCBwYXJ0aXRpb24KICAgICAgICAgICAgICAgICAg
IHZlbmRvcjogV2luZG93cwogICAgICAgICAgICAgICAgICAgcGh5c2ljYWwgaWQ6IDEKICAg
ICAgICAgICAgICAgICAgIGJ1cyBpbmZvOiBzY3NpQDA6MC4wLjAsMQogICAgICAgICAgICAg
ICAgICAgbG9naWNhbCBuYW1lOiAvZGV2L3NkYTEKICAgICAgICAgICAgICAgICAgIHNlcmlh
bDogOWU1Mzc3NWItMGFhMS00Yjk3LTkzZGEtMGU0ZTE1MzFkNzU1CiAgICAgICAgICAgICAg
ICAgICBjYXBhY2l0eTogMTVNaUIKICAgICAgICAgICAgICAgICAgIGNhcGFiaWxpdGllczog
bm9mcwogICAgICAgICAgICAgICAgICAgY29uZmlndXJhdGlvbjogbmFtZT1NaWNyb3NvZnQg
cmVzZXJ2ZWQgcGFydGl0aW9uCiAgICAgICAgICAgICAgKi12b2x1bWU6MQogICAgICAgICAg
ICAgICAgICAgZGVzY3JpcHRpb246IFdpbmRvd3MgTlRGUyB2b2x1bWUKICAgICAgICAgICAg
ICAgICAgIHZlbmRvcjogV2luZG93cwogICAgICAgICAgICAgICAgICAgcGh5c2ljYWwgaWQ6
IDIKICAgICAgICAgICAgICAgICAgIGJ1cyBpbmZvOiBzY3NpQDA6MC4wLjAsMgogICAgICAg
ICAgICAgICAgICAgbG9naWNhbCBuYW1lOiAvZGV2L3NkYTIKICAgICAgICAgICAgICAgICAg
IGxvZ2ljYWwgbmFtZTogL21udC93aW4KICAgICAgICAgICAgICAgICAgIHZlcnNpb246IDMu
MQogICAgICAgICAgICAgICAgICAgc2VyaWFsOiBlNDBjOTIxOC1lZjhjLTRlNDYtOTQ3ZS0y
ZjFjMTliNjVhZTMKICAgICAgICAgICAgICAgICAgIHNpemU6IDI5MkdpQgogICAgICAgICAg
ICAgICAgICAgY2FwYWNpdHk6IDI5MkdpQgogICAgICAgICAgICAgICAgICAgY2FwYWJpbGl0
aWVzOiBudGZzIGluaXRpYWxpemVkCiAgICAgICAgICAgICAgICAgICBjb25maWd1cmF0aW9u
OiBjbHVzdGVyc2l6ZT00MDk2IGNyZWF0ZWQ9MjAyMS0wOS0zMCAxNjoyNDo0MSBmaWxlc3lz
dGVtPW50ZnMgbGFiZWw9TmV3IFZvbHVtZSBtb3VudC5mc3R5cGU9ZnVzZWJsayBtb3VudC5v
cHRpb25zPXJ3LHJlbGF0aW1lLHVzZXJfaWQ9MCxncm91cF9pZD0wLGFsbG93X290aGVyLGJs
a3NpemU9NDA5NiBuYW1lPUJhc2ljIGRhdGEgcGFydGl0aW9uIHN0YXRlPW1vdW50ZWQKICAg
ICAgICAgICAgICAqLXZvbHVtZToyCiAgICAgICAgICAgICAgICAgICBkZXNjcmlwdGlvbjog
V2luZG93cyBOVEZTIHZvbHVtZQogICAgICAgICAgICAgICAgICAgdmVuZG9yOiBXaW5kb3dz
CiAgICAgICAgICAgICAgICAgICBwaHlzaWNhbCBpZDogMwogICAgICAgICAgICAgICAgICAg
YnVzIGluZm86IHNjc2lAMDowLjAuMCwzCiAgICAgICAgICAgICAgICAgICBsb2dpY2FsIG5h
bWU6IC9kZXYvc2RhMwogICAgICAgICAgICAgICAgICAgdmVyc2lvbjogMy4xCiAgICAgICAg
ICAgICAgICAgICBzZXJpYWw6IDI4ZmYtMzg0OQogICAgICAgICAgICAgICAgICAgc2l6ZTog
NDg4TWlCCiAgICAgICAgICAgICAgICAgICBjYXBhY2l0eTogNTA3TWlCCiAgICAgICAgICAg
ICAgICAgICBjYXBhYmlsaXRpZXM6IGJvb3QgcHJlY2lvdXMgbnRmcyBpbml0aWFsaXplZAog
ICAgICAgICAgICAgICAgICAgY29uZmlndXJhdGlvbjogY2x1c3RlcnNpemU9NDA5NiBjcmVh
dGVkPTIwMjEtMTAtMjAgMTA6NTM6NDggZmlsZXN5c3RlbT1udGZzIHN0YXRlPWNsZWFuCiAg
ICAgICAgICAgICAgKi12b2x1bWU6MwogICAgICAgICAgICAgICAgICAgZGVzY3JpcHRpb246
IFdpbmRvd3MgRkFUIHZvbHVtZQogICAgICAgICAgICAgICAgICAgdmVuZG9yOiBNU0RPUzUu
MAogICAgICAgICAgICAgICAgICAgcGh5c2ljYWwgaWQ6IDQKICAgICAgICAgICAgICAgICAg
IGJ1cyBpbmZvOiBzY3NpQDA6MC4wLjAsNAogICAgICAgICAgICAgICAgICAgbG9naWNhbCBu
YW1lOiAvZGV2L3NkYTQKICAgICAgICAgICAgICAgICAgIGxvZ2ljYWwgbmFtZTogL2Jvb3Qv
ZWZpCiAgICAgICAgICAgICAgICAgICB2ZXJzaW9uOiBGQVQzMgogICAgICAgICAgICAgICAg
ICAgc2VyaWFsOiAxNjFhLTQxODcKICAgICAgICAgICAgICAgICAgIHNpemU6IDgwTWlCCiAg
ICAgICAgICAgICAgICAgICBjYXBhY2l0eTogOTlNaUIKICAgICAgICAgICAgICAgICAgIGNh
cGFiaWxpdGllczogYm9vdCBmYXQgaW5pdGlhbGl6ZWQKICAgICAgICAgICAgICAgICAgIGNv
bmZpZ3VyYXRpb246IEZBVHM9MiBmaWxlc3lzdGVtPWZhdCBtb3VudC5mc3R5cGU9dmZhdCBt
b3VudC5vcHRpb25zPXJ3LHJlbGF0aW1lLGZtYXNrPTAwNzcsZG1hc2s9MDA3Nyxjb2RlcGFn
ZT00MzcsaW9jaGFyc2V0PWlzbzg4NTktMSxzaG9ydG5hbWU9d2lubnQsZXJyb3JzPXJlbW91
bnQtcm8gbmFtZT1FRkkgU3lzdGVtIFBhcnRpdGlvbiBzdGF0ZT1tb3VudGVkCiAgICAgICAg
ICAgICAgKi12b2x1bWU6NAogICAgICAgICAgICAgICAgICAgZGVzY3JpcHRpb246IEVGSSBw
YXJ0aXRpb24KICAgICAgICAgICAgICAgICAgIHBoeXNpY2FsIGlkOiA1CiAgICAgICAgICAg
ICAgICAgICBidXMgaW5mbzogc2NzaUAwOjAuMC4wLDUKICAgICAgICAgICAgICAgICAgIGxv
Z2ljYWwgbmFtZTogL2Rldi9zZGE1CiAgICAgICAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6
IC9ib290CiAgICAgICAgICAgICAgICAgICBzZXJpYWw6IDIxNTkxOWU3LWJiYTItNDIyZi1i
MjM5LWNlNDgxNGM2NWMxMgogICAgICAgICAgICAgICAgICAgY2FwYWNpdHk6IDEwMjNNaUIK
ICAgICAgICAgICAgICAgICAgIGNvbmZpZ3VyYXRpb246IG1vdW50LmZzdHlwZT14ZnMgbW91
bnQub3B0aW9ucz1ydyxyZWxhdGltZSxhdHRyMixpbm9kZTY0LGxvZ2J1ZnM9OCxsb2dic2l6
ZT0zMmssbm9xdW90YSBzdGF0ZT1tb3VudGVkCiAgICAgICAgICAgICAgKi12b2x1bWU6NQog
ICAgICAgICAgICAgICAgICAgZGVzY3JpcHRpb246IExWTSBQaHlzaWNhbCBWb2x1bWUKICAg
ICAgICAgICAgICAgICAgIHZlbmRvcjogTGludXgKICAgICAgICAgICAgICAgICAgIHBoeXNp
Y2FsIGlkOiA2CiAgICAgICAgICAgICAgICAgICBidXMgaW5mbzogc2NzaUAwOjAuMC4wLDYK
ICAgICAgICAgICAgICAgICAgIGxvZ2ljYWwgbmFtZTogL2Rldi9zZGE2CiAgICAgICAgICAg
ICAgICAgICBzZXJpYWw6IDVtZ3NPTy1sWDllLXdWOXItR1BjcC0xVkJ4LVVKcHgtM3VXTGRl
CiAgICAgICAgICAgICAgICAgICBzaXplOiAxNzBHaUIKICAgICAgICAgICAgICAgICAgIGNh
cGFiaWxpdGllczogbXVsdGkgbHZtMgogICAgICAgICAgICotY2Ryb20KICAgICAgICAgICAg
ICAgIGRlc2NyaXB0aW9uOiBEVkQtUkFNIHdyaXRlcgogICAgICAgICAgICAgICAgcHJvZHVj
dDogRFZEUkFNIEdVRTBOCiAgICAgICAgICAgICAgICB2ZW5kb3I6IEhMLURULVNUCiAgICAg
ICAgICAgICAgICBwaHlzaWNhbCBpZDogMQogICAgICAgICAgICAgICAgYnVzIGluZm86IHNj
c2lAMTowLjAuMAogICAgICAgICAgICAgICAgbG9naWNhbCBuYW1lOiAvZGV2L2Nkcm9tCiAg
ICAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6IC9kZXYvc3IwCiAgICAgICAgICAgICAgICB2
ZXJzaW9uOiBULjAyCiAgICAgICAgICAgICAgICBjYXBhYmlsaXRpZXM6IHJlbW92YWJsZSBh
dWRpbyBjZC1yIGNkLXJ3IGR2ZCBkdmQtciBkdmQtcmFtCiAgICAgICAgICAgICAgICBjb25m
aWd1cmF0aW9uOiBhbnNpdmVyc2lvbj01IHN0YXR1cz1ub2Rpc2MKICAgICAgICAqLXBjaQog
ICAgICAgICAgICAgZGVzY3JpcHRpb246IFBDSSBicmlkZ2UKICAgICAgICAgICAgIHByb2R1
Y3Q6IENhbm5vbiBMYWtlIFBDSCBQQ0kgRXhwcmVzcyBSb290IFBvcnQgIzcKICAgICAgICAg
ICAgIHZlbmRvcjogSW50ZWwgQ29ycG9yYXRpb24KICAgICAgICAgICAgIHBoeXNpY2FsIGlk
OiAxYwogICAgICAgICAgICAgYnVzIGluZm86IHBjaUAwMDAwOjAwOjFjLjAKICAgICAgICAg
ICAgIHZlcnNpb246IGYwCiAgICAgICAgICAgICB3aWR0aDogMzIgYml0cwogICAgICAgICAg
ICAgY2xvY2s6IDMzTUh6CiAgICAgICAgICAgICBjYXBhYmlsaXRpZXM6IHBjaSBwY2lleHBy
ZXNzIG1zaSBwbSBub3JtYWxfZGVjb2RlIGJ1c19tYXN0ZXIgY2FwX2xpc3QKICAgICAgICAg
ICAgIGNvbmZpZ3VyYXRpb246IGRyaXZlcj1wY2llcG9ydAogICAgICAgICAgICAgcmVzb3Vy
Y2VzOiBpcnE6MTIwIGlvcG9ydDozMDAwKHNpemU9NDA5NikgbWVtb3J5OmExMTAwMDAwLWEx
MWZmZmZmCiAgICAgICAgICAgKi1uZXR3b3JrCiAgICAgICAgICAgICAgICBkZXNjcmlwdGlv
bjogRXRoZXJuZXQgaW50ZXJmYWNlCiAgICAgICAgICAgICAgICBwcm9kdWN0OiBSVEw4MTEx
LzgxNjgvODQxMSBQQ0kgRXhwcmVzcyBHaWdhYml0IEV0aGVybmV0IENvbnRyb2xsZXIKICAg
ICAgICAgICAgICAgIHZlbmRvcjogUmVhbHRlayBTZW1pY29uZHVjdG9yIENvLiwgTHRkLgog
ICAgICAgICAgICAgICAgcGh5c2ljYWwgaWQ6IDAKICAgICAgICAgICAgICAgIGJ1cyBpbmZv
OiBwY2lAMDAwMDowMTowMC4wCiAgICAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6IGVucDFz
MAogICAgICAgICAgICAgICAgdmVyc2lvbjogMTUKICAgICAgICAgICAgICAgIHNlcmlhbDog
ZjQ6OTM6OWY6ZjA6YTU6ZjUKICAgICAgICAgICAgICAgIHNpemU6IDFHYml0L3MKICAgICAg
ICAgICAgICAgIGNhcGFjaXR5OiAxR2JpdC9zCiAgICAgICAgICAgICAgICB3aWR0aDogNjQg
Yml0cwogICAgICAgICAgICAgICAgY2xvY2s6IDMzTUh6CiAgICAgICAgICAgICAgICBjYXBh
YmlsaXRpZXM6IHBtIG1zaSBwY2lleHByZXNzIG1zaXggdnBkIGJ1c19tYXN0ZXIgY2FwX2xp
c3QgZXRoZXJuZXQgcGh5c2ljYWwgdHAgbWlpIDEwYnQgMTBidC1mZCAxMDBidCAxMDBidC1m
ZCAxMDAwYnQtZmQgYXV0b25lZ290aWF0aW9uCiAgICAgICAgICAgICAgICBjb25maWd1cmF0
aW9uOiBhdXRvbmVnb3RpYXRpb249b24gYnJvYWRjYXN0PXllcyBkcml2ZXI9cjgxNjkgZHJp
dmVydmVyc2lvbj02LjMuMC1ub3RwbS10eC0wMDQzNi1nMTczZWE3NDNiIGR1cGxleD1mdWxs
IGZpcm13YXJlPXJ0bDgxNjhoLTJfMC4wLjIgMDIvMjYvMTUgaXA9MTkzLjE5OC4xODYuMjAw
IGxhdGVuY3k9MCBsaW5rPXllcyBtdWx0aWNhc3Q9eWVzIHBvcnQ9dHdpc3RlZCBwYWlyIHNw
ZWVkPTFHYml0L3MKICAgICAgICAgICAgICAgIHJlc291cmNlczogaXJxOjE4IGlvcG9ydDoz
MDAwKHNpemU9MjU2KSBtZW1vcnk6YTExMDQwMDAtYTExMDRmZmYgbWVtb3J5OmExMTAwMDAw
LWExMTAzZmZmCiAgICAgICAgKi1jb21tdW5pY2F0aW9uOjEKICAgICAgICAgICAgIGRlc2Ny
aXB0aW9uOiBDb21tdW5pY2F0aW9uIGNvbnRyb2xsZXIKICAgICAgICAgICAgIHByb2R1Y3Q6
IENhbm5vbiBMYWtlIFBDSCBTZXJpYWwgSU8gVUFSVCBIb3N0IENvbnRyb2xsZXIKICAgICAg
ICAgICAgIHZlbmRvcjogSW50ZWwgQ29ycG9yYXRpb24KICAgICAgICAgICAgIHBoeXNpY2Fs
IGlkOiAxZQogICAgICAgICAgICAgYnVzIGluZm86IHBjaUAwMDAwOjAwOjFlLjAKICAgICAg
ICAgICAgIHZlcnNpb246IDEwCiAgICAgICAgICAgICB3aWR0aDogNjQgYml0cwogICAgICAg
ICAgICAgY2xvY2s6IDMzTUh6CiAgICAgICAgICAgICBjYXBhYmlsaXRpZXM6IHBtIGJ1c19t
YXN0ZXIgY2FwX2xpc3QKICAgICAgICAgICAgIGNvbmZpZ3VyYXRpb246IGRyaXZlcj1pbnRl
bC1scHNzIGxhdGVuY3k9MAogICAgICAgICAgICAgcmVzb3VyY2VzOiBpcnE6MjAgbWVtb3J5
OmExMjFlMDAwLWExMjFlZmZmCiAgICAgICAgKi1pc2EKICAgICAgICAgICAgIGRlc2NyaXB0
aW9uOiBJU0EgYnJpZGdlCiAgICAgICAgICAgICBwcm9kdWN0OiBJbnRlbCBDb3Jwb3JhdGlv
bgogICAgICAgICAgICAgdmVuZG9yOiBJbnRlbCBDb3Jwb3JhdGlvbgogICAgICAgICAgICAg
cGh5c2ljYWwgaWQ6IDFmCiAgICAgICAgICAgICBidXMgaW5mbzogcGNpQDAwMDA6MDA6MWYu
MAogICAgICAgICAgICAgdmVyc2lvbjogMTAKICAgICAgICAgICAgIHdpZHRoOiAzMiBiaXRz
CiAgICAgICAgICAgICBjbG9jazogMzNNSHoKICAgICAgICAgICAgIGNhcGFiaWxpdGllczog
aXNhIGJ1c19tYXN0ZXIKICAgICAgICAgICAgIGNvbmZpZ3VyYXRpb246IGxhdGVuY3k9MAog
ICAgICAgICAgICotcG5wMDA6MDAKICAgICAgICAgICAgICAgIHByb2R1Y3Q6IFBuUCBkZXZp
Y2UgUE5QMGMwMgogICAgICAgICAgICAgICAgcGh5c2ljYWwgaWQ6IDAKICAgICAgICAgICAg
ICAgIGNhcGFiaWxpdGllczogcG5wCiAgICAgICAgICAgICAgICBjb25maWd1cmF0aW9uOiBk
cml2ZXI9c3lzdGVtCiAgICAgICAgICAgKi1wbnAwMDowMQogICAgICAgICAgICAgICAgcHJv
ZHVjdDogUG5QIGRldmljZSBQTlAwYzAyCiAgICAgICAgICAgICAgICBwaHlzaWNhbCBpZDog
MQogICAgICAgICAgICAgICAgY2FwYWJpbGl0aWVzOiBwbnAKICAgICAgICAgICAgICAgIGNv
bmZpZ3VyYXRpb246IGRyaXZlcj1zeXN0ZW0KICAgICAgICAgICAqLXBucDAwOjAyCiAgICAg
ICAgICAgICAgICBwcm9kdWN0OiBQblAgZGV2aWNlIFBOUDA1MDEKICAgICAgICAgICAgICAg
IHBoeXNpY2FsIGlkOiAyCiAgICAgICAgICAgICAgICBjYXBhYmlsaXRpZXM6IHBucAogICAg
ICAgICAgICAgICAgY29uZmlndXJhdGlvbjogZHJpdmVyPXNlcmlhbAogICAgICAgICAgICot
cG5wMDA6MDMKICAgICAgICAgICAgICAgIHByb2R1Y3Q6IFBuUCBkZXZpY2UgUE5QMGMwMgog
ICAgICAgICAgICAgICAgcGh5c2ljYWwgaWQ6IDMKICAgICAgICAgICAgICAgIGNhcGFiaWxp
dGllczogcG5wCiAgICAgICAgICAgICAgICBjb25maWd1cmF0aW9uOiBkcml2ZXI9c3lzdGVt
CiAgICAgICAgICAgKi1wbnAwMDowNAogICAgICAgICAgICAgICAgcHJvZHVjdDogUG5QIGRl
dmljZSBJTlQzZjBkCiAgICAgICAgICAgICAgICB2ZW5kb3I6IEludGVycGhhc2UgQ29ycG9y
YXRpb24KICAgICAgICAgICAgICAgIHBoeXNpY2FsIGlkOiA0CiAgICAgICAgICAgICAgICBj
YXBhYmlsaXRpZXM6IHBucAogICAgICAgICAgICAgICAgY29uZmlndXJhdGlvbjogZHJpdmVy
PXN5c3RlbQogICAgICAgICAgICotcG5wMDA6MDUKICAgICAgICAgICAgICAgIHByb2R1Y3Q6
IFBuUCBkZXZpY2UgUE5QMGMwMgogICAgICAgICAgICAgICAgcGh5c2ljYWwgaWQ6IDUKICAg
ICAgICAgICAgICAgIGNhcGFiaWxpdGllczogcG5wCiAgICAgICAgICAgICAgICBjb25maWd1
cmF0aW9uOiBkcml2ZXI9c3lzdGVtCiAgICAgICAgICAgKi1wbnAwMDowNgogICAgICAgICAg
ICAgICAgcHJvZHVjdDogUG5QIGRldmljZSBQTlAwYzAyCiAgICAgICAgICAgICAgICBwaHlz
aWNhbCBpZDogNgogICAgICAgICAgICAgICAgY2FwYWJpbGl0aWVzOiBwbnAKICAgICAgICAg
ICAgICAgIGNvbmZpZ3VyYXRpb246IGRyaXZlcj1zeXN0ZW0KICAgICAgICAgICAqLXBucDAw
OjA3CiAgICAgICAgICAgICAgICBwcm9kdWN0OiBQblAgZGV2aWNlIFBOUDBjMDIKICAgICAg
ICAgICAgICAgIHBoeXNpY2FsIGlkOiA3CiAgICAgICAgICAgICAgICBjYXBhYmlsaXRpZXM6
IHBucAogICAgICAgICAgICAgICAgY29uZmlndXJhdGlvbjogZHJpdmVyPXN5c3RlbQogICAg
ICAgICAgICotcG5wMDA6MDgKICAgICAgICAgICAgICAgIHByb2R1Y3Q6IFBuUCBkZXZpY2Ug
UE5QMGMwMgogICAgICAgICAgICAgICAgcGh5c2ljYWwgaWQ6IDgKICAgICAgICAgICAgICAg
IGNhcGFiaWxpdGllczogcG5wCiAgICAgICAgICAgICAgICBjb25maWd1cmF0aW9uOiBkcml2
ZXI9c3lzdGVtCiAgICAgICAgKi1tdWx0aW1lZGlhCiAgICAgICAgICAgICBkZXNjcmlwdGlv
bjogQXVkaW8gZGV2aWNlCiAgICAgICAgICAgICBwcm9kdWN0OiBDYW5ub24gTGFrZSBQQ0gg
Y0FWUwogICAgICAgICAgICAgdmVuZG9yOiBJbnRlbCBDb3Jwb3JhdGlvbgogICAgICAgICAg
ICAgcGh5c2ljYWwgaWQ6IDFmLjMKICAgICAgICAgICAgIGJ1cyBpbmZvOiBwY2lAMDAwMDow
MDoxZi4zCiAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6IGNhcmQwCiAgICAgICAgICAgICBs
b2dpY2FsIG5hbWU6IC9kZXYvc25kL2NvbnRyb2xDMAogICAgICAgICAgICAgbG9naWNhbCBu
YW1lOiAvZGV2L3NuZC9od0MwRDAKICAgICAgICAgICAgIGxvZ2ljYWwgbmFtZTogL2Rldi9z
bmQvaHdDMEQyCiAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6IC9kZXYvc25kL3BjbUMwRDBj
CiAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6IC9kZXYvc25kL3BjbUMwRDBwCiAgICAgICAg
ICAgICBsb2dpY2FsIG5hbWU6IC9kZXYvc25kL3BjbUMwRDNwCiAgICAgICAgICAgICBsb2dp
Y2FsIG5hbWU6IC9kZXYvc25kL3BjbUMwRDdwCiAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6
IC9kZXYvc25kL3BjbUMwRDhwCiAgICAgICAgICAgICB2ZXJzaW9uOiAxMAogICAgICAgICAg
ICAgd2lkdGg6IDY0IGJpdHMKICAgICAgICAgICAgIGNsb2NrOiAzM01IegogICAgICAgICAg
ICAgY2FwYWJpbGl0aWVzOiBwbSBtc2kgYnVzX21hc3RlciBjYXBfbGlzdAogICAgICAgICAg
ICAgY29uZmlndXJhdGlvbjogZHJpdmVyPXNuZF9oZGFfaW50ZWwgbGF0ZW5jeT0zMgogICAg
ICAgICAgICAgcmVzb3VyY2VzOiBpcnE6MTI2IG1lbW9yeTphMTIxMDAwMC1hMTIxM2ZmZiBt
ZW1vcnk6YTEwMDAwMDAtYTEwZmZmZmYKICAgICAgICAgICAqLWlucHV0OjAKICAgICAgICAg
ICAgICAgIHByb2R1Y3Q6IEhEQSBJbnRlbCBQQ0ggRnJvbnQgTWljCiAgICAgICAgICAgICAg
ICBwaHlzaWNhbCBpZDogMAogICAgICAgICAgICAgICAgbG9naWNhbCBuYW1lOiBpbnB1dDEw
CiAgICAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6IC9kZXYvaW5wdXQvZXZlbnQxMAogICAg
ICAgICAgICotaW5wdXQ6MQogICAgICAgICAgICAgICAgcHJvZHVjdDogSERBIEludGVsIFBD
SCBMaW5lIE91dAogICAgICAgICAgICAgICAgcGh5c2ljYWwgaWQ6IDEKICAgICAgICAgICAg
ICAgIGxvZ2ljYWwgbmFtZTogaW5wdXQxMQogICAgICAgICAgICAgICAgbG9naWNhbCBuYW1l
OiAvZGV2L2lucHV0L2V2ZW50MTEKICAgICAgICAgICAqLWlucHV0OjIKICAgICAgICAgICAg
ICAgIHByb2R1Y3Q6IEhEQSBJbnRlbCBQQ0ggRnJvbnQgSGVhZHBob25lCiAgICAgICAgICAg
ICAgICBwaHlzaWNhbCBpZDogMgogICAgICAgICAgICAgICAgbG9naWNhbCBuYW1lOiBpbnB1
dDEyCiAgICAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6IC9kZXYvaW5wdXQvZXZlbnQxMgog
ICAgICAgICAgICotaW5wdXQ6MwogICAgICAgICAgICAgICAgcHJvZHVjdDogSERBIEludGVs
IFBDSCBIRE1JL0RQLHBjbT0zCiAgICAgICAgICAgICAgICBwaHlzaWNhbCBpZDogMwogICAg
ICAgICAgICAgICAgbG9naWNhbCBuYW1lOiBpbnB1dDEzCiAgICAgICAgICAgICAgICBsb2dp
Y2FsIG5hbWU6IC9kZXYvaW5wdXQvZXZlbnQxMwogICAgICAgICAgICotaW5wdXQ6NAogICAg
ICAgICAgICAgICAgcHJvZHVjdDogSERBIEludGVsIFBDSCBIRE1JL0RQLHBjbT03CiAgICAg
ICAgICAgICAgICBwaHlzaWNhbCBpZDogNAogICAgICAgICAgICAgICAgbG9naWNhbCBuYW1l
OiBpbnB1dDE0CiAgICAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6IC9kZXYvaW5wdXQvZXZl
bnQxNAogICAgICAgICAgICotaW5wdXQ6NQogICAgICAgICAgICAgICAgcHJvZHVjdDogSERB
IEludGVsIFBDSCBIRE1JL0RQLHBjbT04CiAgICAgICAgICAgICAgICBwaHlzaWNhbCBpZDog
NQogICAgICAgICAgICAgICAgbG9naWNhbCBuYW1lOiBpbnB1dDE1CiAgICAgICAgICAgICAg
ICBsb2dpY2FsIG5hbWU6IC9kZXYvaW5wdXQvZXZlbnQxNQogICAgICAgICAgICotaW5wdXQ6
NgogICAgICAgICAgICAgICAgcHJvZHVjdDogSERBIEludGVsIFBDSCBNaWMKICAgICAgICAg
ICAgICAgIHBoeXNpY2FsIGlkOiA2CiAgICAgICAgICAgICAgICBsb2dpY2FsIG5hbWU6IGlu
cHV0OQogICAgICAgICAgICAgICAgbG9naWNhbCBuYW1lOiAvZGV2L2lucHV0L2V2ZW50OQog
ICAgICAgICotc2VyaWFsOjIKICAgICAgICAgICAgIGRlc2NyaXB0aW9uOiBTTUJ1cwogICAg
ICAgICAgICAgcHJvZHVjdDogQ2Fubm9uIExha2UgUENIIFNNQnVzIENvbnRyb2xsZXIKICAg
ICAgICAgICAgIHZlbmRvcjogSW50ZWwgQ29ycG9yYXRpb24KICAgICAgICAgICAgIHBoeXNp
Y2FsIGlkOiAxZi40CiAgICAgICAgICAgICBidXMgaW5mbzogcGNpQDAwMDA6MDA6MWYuNAog
ICAgICAgICAgICAgdmVyc2lvbjogMTAKICAgICAgICAgICAgIHdpZHRoOiA2NCBiaXRzCiAg
ICAgICAgICAgICBjbG9jazogMzNNSHoKICAgICAgICAgICAgIGNvbmZpZ3VyYXRpb246IGRy
aXZlcj1pODAxX3NtYnVzIGxhdGVuY3k9MAogICAgICAgICAgICAgcmVzb3VyY2VzOiBpcnE6
MTYgbWVtb3J5OmExMjE4MDAwLWExMjE4MGZmIGlvcG9ydDplZmEwKHNpemU9MzIpCiAgICAg
ICAgKi1zZXJpYWw6MyBVTkNMQUlNRUQKICAgICAgICAgICAgIGRlc2NyaXB0aW9uOiBTZXJp
YWwgYnVzIGNvbnRyb2xsZXIKICAgICAgICAgICAgIHByb2R1Y3Q6IENhbm5vbiBMYWtlIFBD
SCBTUEkgQ29udHJvbGxlcgogICAgICAgICAgICAgdmVuZG9yOiBJbnRlbCBDb3Jwb3JhdGlv
bgogICAgICAgICAgICAgcGh5c2ljYWwgaWQ6IDFmLjUKICAgICAgICAgICAgIGJ1cyBpbmZv
OiBwY2lAMDAwMDowMDoxZi41CiAgICAgICAgICAgICB2ZXJzaW9uOiAxMAogICAgICAgICAg
ICAgd2lkdGg6IDMyIGJpdHMKICAgICAgICAgICAgIGNsb2NrOiAzM01IegogICAgICAgICAg
ICAgY29uZmlndXJhdGlvbjogbGF0ZW5jeT0wCiAgICAgICAgICAgICByZXNvdXJjZXM6IG1l
bW9yeTpmZTAxMDAwMC1mZTAxMGZmZgogICotcG93ZXIgVU5DTEFJTUVECiAgICAgICBkZXNj
cmlwdGlvbjogVG8gQmUgRmlsbGVkIEJ5IE8uRS5NLgogICAgICAgcHJvZHVjdDogVG8gQmUg
RmlsbGVkIEJ5IE8uRS5NLgogICAgICAgdmVuZG9yOiBUbyBCZSBGaWxsZWQgQnkgTy5FLk0u
CiAgICAgICBwaHlzaWNhbCBpZDogMQogICAgICAgdmVyc2lvbjogVG8gQmUgRmlsbGVkIEJ5
IE8uRS5NLgogICAgICAgc2VyaWFsOiBUbyBCZSBGaWxsZWQgQnkgTy5FLk0uCiAgICAgICBj
YXBhY2l0eTogMzI3NjhtV2gKICAqLWlucHV0OjAKICAgICAgIHByb2R1Y3Q6IFNsZWVwIEJ1
dHRvbgogICAgICAgcGh5c2ljYWwgaWQ6IDIKICAgICAgIGxvZ2ljYWwgbmFtZTogaW5wdXQw
CiAgICAgICBsb2dpY2FsIG5hbWU6IC9kZXYvaW5wdXQvZXZlbnQwCiAgICAgICBjYXBhYmls
aXRpZXM6IHBsYXRmb3JtCiAgKi1pbnB1dDoxCiAgICAgICBwcm9kdWN0OiBQb3dlciBCdXR0
b24KICAgICAgIHBoeXNpY2FsIGlkOiAzCiAgICAgICBsb2dpY2FsIG5hbWU6IGlucHV0MQog
ICAgICAgbG9naWNhbCBuYW1lOiAvZGV2L2lucHV0L2V2ZW50MQogICAgICAgY2FwYWJpbGl0
aWVzOiBwbGF0Zm9ybQogICotaW5wdXQ6MgogICAgICAgcHJvZHVjdDogUG93ZXIgQnV0dG9u
CiAgICAgICBwaHlzaWNhbCBpZDogNAogICAgICAgbG9naWNhbCBuYW1lOiBpbnB1dDIKICAg
ICAgIGxvZ2ljYWwgbmFtZTogL2Rldi9pbnB1dC9ldmVudDIKICAgICAgIGNhcGFiaWxpdGll
czogcGxhdGZvcm0KICAqLWlucHV0OjMKICAgICAgIHByb2R1Y3Q6IFZpZGVvIEJ1cwogICAg
ICAgcGh5c2ljYWwgaWQ6IDUKICAgICAgIGxvZ2ljYWwgbmFtZTogaW5wdXQ3CiAgICAgICBs
b2dpY2FsIG5hbWU6IC9kZXYvaW5wdXQvZXZlbnQ3CiAgICAgICBjYXBhYmlsaXRpZXM6IHBs
YXRmb3JtCiAgKi1pbnB1dDo0CiAgICAgICBwcm9kdWN0OiBQQyBTcGVha2VyCiAgICAgICBw
aHlzaWNhbCBpZDogNgogICAgICAgbG9naWNhbCBuYW1lOiBpbnB1dDgKICAgICAgIGxvZ2lj
YWwgbmFtZTogL2Rldi9pbnB1dC9ldmVudDgKICAgICAgIGNhcGFiaWxpdGllczogaXNhCg==


--------------CoiMGBWzuGmhy00b87g5FQid--
