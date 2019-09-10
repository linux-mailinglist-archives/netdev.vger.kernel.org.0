Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3255AF313
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 00:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfIJWxg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Sep 2019 18:53:36 -0400
Received: from 2098.x.rootbsd.net ([208.79.82.66]:34608 "EHLO pilot.trilug.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfIJWxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 18:53:36 -0400
Received: by pilot.trilug.org (Postfix, from userid 8)
        id 3EEA2169755; Tue, 10 Sep 2019 18:53:35 -0400 (EDT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on pilot.trilug.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable version=3.3.2
Received: from michaelmarley.com (cpe-2606-A000-BFC0-90-509-B1D3-C76D-19C7.dyn6.twc.com [IPv6:2606:a000:bfc0:90:509:b1d3:c76d:19c7])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pilot.trilug.org (Postfix) with ESMTPSA id E1FF5169748;
        Tue, 10 Sep 2019 18:53:32 -0400 (EDT)
Received: from michaelmarley.com (localhost [127.0.0.1])
        by michaelmarley.com (Postfix) with ESMTP id 015CF18012D;
        Tue, 10 Sep 2019 18:53:30 -0400 (EDT)
Received: from mamarley-desktop.lan ([fdda:5f29:421b:3:9174:925b:42b3:3bd7])
        by michaelmarley.com with ESMTPSA
        id yS0nO2opeF2vJQEAnAHMIA
        (envelope-from <michael@michaelmarley.com>); Tue, 10 Sep 2019 18:53:30 -0400
Subject: Re: ixgbe: driver drops packets routed from an IPSec interface with a
 "bad sa_idx" error
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        steffen.klassert@secunet.com
References: <10ba81d178d4ade76741c1a6e1672056@michaelmarley.com>
 <4caa4fb7-9963-99ab-318f-d8ada4f19205@pensando.io>
 <fb63dec226170199e9b0fd1b356d2314@michaelmarley.com>
 <90dd9f8c-57fa-14c7-5d09-207b84ec3292@pensando.io>
From:   Michael Marley <michael@michaelmarley.com>
Openpgp: preference=signencrypt
Autocrypt: addr=michael@michaelmarley.com; prefer-encrypt=mutual; keydata=
 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 Ol2t
Message-ID: <6ab15854-154a-2c7c-b429-7ba6dfe785ae@michaelmarley.com>
Date:   Tue, 10 Sep 2019 18:53:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <90dd9f8c-57fa-14c7-5d09-207b84ec3292@pensando.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/10/19 5:43 PM, Shannon Nelson wrote:

> On 9/9/19 11:45 AM, Michael Marley wrote:
>> On 2019-09-09 14:21, Shannon Nelson wrote:
>>> On 9/6/19 11:13 AM, Michael Marley wrote:
>>>> (This is also reported at
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=204551, but it was
>>>> recommended that I send it to this list as well.)
>>>>
>>>> I have a put together a router that routes traffic from several
>>>> local subnets from a switch attached to an i82599ES card through an
>>>> IPSec VPN interface set up with StrongSwan. (The VPN is running on
>>>> an unrelated second interface with a different driver.)  Traffic
>>>> from the local interfaces to the VPN works as it should and
>>>> eventually makes it through the VPN server and out to the
>>>> Internet.  The return traffic makes it back to the router and
>>>> tcpdump shows it leaving by the i82599, but the traffic never
>>>> actually makes it onto the wire and I instead get one of
>>>>
>>>> enp1s0: ixgbe_ipsec_tx: bad sa_idx=64512 handle=0
>>>>
>>>> for each packet that should be transmitted.  (The sa_idx and handle
>>>> values are always the same.)
>>>>
>>>> I realized this was probably related to ixgbe's IPSec offloading
>>>> feature, so I tried with the motherboard's integrated e1000e device
>>>> and didn't have the problem.  I tried using ethtool to disable all
>>>> the IPSec-related offloads (tx-esp-segmentation, esp-hw-offload,
>>>> esp-tx-csum-hw-offload), but the problem persisted.  I then tried
>>>> recompiling the kernel with CONFIG_IXGBE_IPSEC=n and that worked
>>>> around the problem.
>>>>
>>>> I was also able to find another instance of the same problem
>>>> reported in Debian at
>>>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=930443. That
>>>> person seems to be having exactly the same issue as me, down to the
>>>> sa_idx and handle values being the same.
>>>>
>>>> If there are any more details I can provide to make this easier to
>>>> track down, please let me know.
>>>>
>>>> Thanks,
>>>>
>>>> Michael Marley
>>>
>>> Hi Michael,
>>>
>>> Thanks for pointing this out.  The issue this error message is
>>> complaining about is that the handle given to the driver is a bad
>>> value.  The handle is what helps the driver find the right encryption
>>> information, and in this case is an index into an array, one array for
>>> Rx and one for Tx, each of which have up to 1024 entries.  In order to
>>> encode them into a single value, 1024 is added to the Tx values to
>>> make the handle, and 1024 is subtracted to use the handle later.  Note
>>> that the bad sa_idx is 64512, which happens to also be -1024; if the
>>> Tx handle given to ixgbe for xmit is 0, we subtract 1024 from that and
>>> get this bad sa_idx value.
>>>
>>> That handle is supposed to be an opaque value only used by the
>>> driver.  It looks to me like either (a) the driver is not setting up
>>> the handle correctly when the SA is first set up, or (b) something in
>>> the upper levels of the ipsec code is clearing the handle value. We
>>> would need to know more about all the bits in your SA set up to have a
>>> better idea what parts of the ipsec code are being exercised when this
>>> problem happens.
>>>
>>> I currently don't have access to a good ixgbe setup on which to
>>> test/debug this, and I haven't been paying much attention lately to
>>> what's happening in the upper ipsec layers, so my help will be
>>> somewhat limited.  I'm hoping the the Intel folks can add a little
>>> help, so I've copied Jeff Kirsher on this (they'll probably point back
>>> to me since I wrote this chunk :-) ).  I've also copied Stephen
>>> Klassert for his ipsec thoughts.
>>>
>>> In the meantime, can you give more details on the exact ipsec rules
>>> that are used here, and are there any error messages coming from ixgbe
>>> regarding the ipsec rule setup that might help us identify what's
>>> happening?
>>>
>>> Thanks,
>>> sln
>>
>> Hi Shannon,
>>
>> Thanks for your response!  I apologize, I am a bit of a newbie to
>> IPSec myself, so I'm not 100% sure what is the best way to provide
>> the information you need, but here is the (slightly-redacted) output
>> of swanctl --list-sas first from the server and then from the client:
>>
>> <servername>: #24, ESTABLISHED, IKEv2, 3cb75c180ee5dc68_i
>> cc7dae551b603bb7_r*
>>   local  '<serverip>' @ <serverip>[4500]
>>   remote '<clientip>' @ <clientip>[4500]
>>   AES_GCM_16-256/PRF_HMAC_SHA2_512/ECP_384
>>   established 174180s ago
>>   <servername>: #110, reqid 12, INSTALLED, TUNNEL-in-UDP,
>> ESP:AES_GCM_16-256/ECP_384
>>     installed 469s ago
>>     in  c51a0f11 (-|0x00000064), 1548864 bytes, 19575 packets, 6s ago
>>     out c3bd9741 (-|0x00000064), 23618807 bytes, 22865 packets,    
>> 7s ago
>>     local  0.0.0.0/0 ::/0
>>     remote 0.0.0.0/0 ::/0
>>
>> <clientname>: #1, ESTABLISHED, IKEv2, 3cb75c180ee5dc68_i*
>> cc7dae551b603bb7_r
>>   local  '<clientip>' @ <clientip>[4500]
>>   remote '<serverip>' @ <serverip>[4500]
>>   AES_GCM_16-256/PRF_HMAC_SHA2_512/ECP_384
>>   established 174013s ago
>>   <clientname>: #54, reqid 1, INSTALLED, TUNNEL-in-UDP,
>> ESP:AES_GCM_16-256/ECP_384
>>     installed 303s ago, rekeying in 2979s, expires in 3657s
>>     in  c3bd9741 (-|0x00000064), 23178523 bytes, 20725 packets,    
>> 0s ago
>>     out c51a0f11 (-|0x00000064), 1429124 bytes, 17719 packets, 0s ago
>>     local  0.0.0.0/0 ::/0
>>     remote 0.0.0.0/0 ::/0
>>
>> It might also be worth mentioning that I am using an xfrm interface
>> to do "regular" routing rather than the policy-based routing that
>> StrongSwan/IPSec normally uses. If there is anything else that would
>> help more, I would be happy to provide it.
>>
>> Just to be clear though, I'm not trying to run IPSec on the ixgbe
>> interface at all.  The ixgbe adapter is being used to connect the
>> router to the switch on the LAN side of the network.  IPSec is
>> running on the WAN interface without any hardware acceleration
>> (besides AES-NI).  The problem occurs when a computer on the LAN
>> tries to access the WAN.  The outgoing packets work as expected and
>> the incoming packets are routed back out through the ixgbe device
>> toward the LAN client, but the driver drops the packets with the
>> sa_idx error.
>>
>> I hope this helps.
>>
>> Thanks,
>>
>> Michael
>
> I'm not familiar with StrongSwan and its configurations, but I'm
> guessing that if you didn't expressly enable it, perhaps StrongSwan
> enabled the ipsec offload capability.  I would suggest turning it off
> to at least get you passed the immediate issue.  If there isn't an
> obvious configuration knob in StrongSwan, perhaps you can at least use
> ethtool to disable the offload, which should be off be default anyway.
>
> You can check it with "ethtool -k ethX | grep esp-hw-offload" and see
> if it is set.  You can disable it with "ethtool -K ethX esp-hw-offload
> off"
>
> Meanwhile, can you please send the output of the following commands:
> uname -a
> ip xfrm s
> ip xfrm p
> dmesg | grep ixgbe
>
> And any other /var/log/syslog or /var/log/messages that look
> suspicious and might give any more insight to what's happening.
>
> Thanks,
> sln
>
StrongSwan has hardware offload disabled by default, and I didn't enable
it explicitly.  I also already tried turning off all those switches with
ethtool and it has no effect.  This doesn't surprise me though, because
as I said, I don't actually have the IPSec connection running over the
ixgbe device.  The IPSec connection runs over another network adapter
that doesn't support IPSec offload at all.  The problem comes when
traffic received over the IPSec interface is then routed back out
(unencrypted) through the ixgbe device into the local network.

Here is the rest of the data for which you asked:

michael@soapstone:~$ uname -a
Linux soapstone 5.3.0-10-generic #11-Ubuntu SMP Mon Sep 9 15:12:17 UTC
2019 x86_64 x86_64 x86_64 GNU/Linux
michael@soapstone:~$ sudo ip xfrm s
src <srcip> dst <dstip>
        proto esp spi 0xcf6f90d3 reqid 1 mode tunnel
        replay-window 0 flag af-unspec
        aead rfc4106(gcm(aes))
0x254c6298b27ad65f61387c39e060698db777a335081d145ca6706d65b6be95770d2622b4
128
        encap type espinudp sport 4500 dport 4500 addr 0.0.0.0
        anti-replay context: seq 0x0, oseq 0xaaac, bitmap 0x00000000
        if_id 0x64
src <dstip> dst <srcip>
        proto esp spi 0xc6e02140 reqid 1 mode tunnel
        replay-window 32 flag af-unspec
        aead rfc4106(gcm(aes))
0x05473bd76e1b7268b54825b019d19c13a360193bc9aa20137204ea566409356da47fc7d7
128
        encap type espinudp sport 4500 dport 4500 addr 0.0.0.0
        anti-replay context: seq 0xab11, oseq 0x0, bitmap 0xffffffff
        if_id 0x64
michael@soapstone:~$ sudo ip xfrm p
src ::/0 dst ::/0
        dir out priority 399999
        tmpl src <srcip> dst <dstip>
                proto esp spi 0xcf6f90d3 reqid 1 mode tunnel
        if_id 0x64
src 0.0.0.0/0 dst 0.0.0.0/0
        dir out priority 399999
        tmpl src <srcip> dst <dstip>
                proto esp spi 0xcf6f90d3 reqid 1 mode tunnel
        if_id 0x64
src ::/0 dst ::/0
        dir fwd priority 399999
        tmpl src <dstip> dst <srcip>
                proto esp reqid 1 mode tunnel
        if_id 0x64
src ::/0 dst ::/0
        dir in priority 399999
        tmpl src <dstip> dst <srcip>
                proto esp reqid 1 mode tunnel
        if_id 0x64
src 0.0.0.0/0 dst 0.0.0.0/0
        dir fwd priority 399999
        tmpl src <dstip> dst <srcip>
                proto esp reqid 1 mode tunnel
        if_id 0x64
src 0.0.0.0/0 dst 0.0.0.0/0
        dir in priority 399999
        tmpl src <dstip> dst <srcip>
                proto esp reqid 1 mode tunnel
        if_id 0x64
src 0.0.0.0/0 dst 0.0.0.0/0
        socket in priority 0
src 0.0.0.0/0 dst 0.0.0.0/0
        socket out priority 0
src 0.0.0.0/0 dst 0.0.0.0/0
        socket in priority 0
src 0.0.0.0/0 dst 0.0.0.0/0
        socket out priority 0
src ::/0 dst ::/0
        socket in priority 0
src ::/0 dst ::/0
        socket out priority 0
src ::/0 dst ::/0
        socket in priority 0
src ::/0 dst ::/0
        socket out priority 0
michael@soapstone:~$ dmesg | grep -i ixgbe
[    0.780400] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver -
version 5.1.0-k
[    0.781606] ixgbe: Copyright (c) 1999-2016 Intel Corporation.
[    0.954093] ixgbe 0000:01:00.0: Multiqueue Enabled: Rx Queue count =
8, Tx Queue count = 8 XDP Queue count = 0
[    0.955081] ixgbe 0000:01:00.0: 32.000 Gb/s available PCIe bandwidth
(5 GT/s x8 link)
[    0.955860] ixgbe 0000:01:00.0: MAC: 2, PHY: 14, SFP+: 3, PBA No: Unknown
[    0.956519] ixgbe 0000:01:00.0: 00:1b:21:c0:00:1e
[    0.958079] ixgbe 0000:01:00.0: Intel(R) 10 Gigabit Network Connection
[    0.958884] libphy: ixgbe-mdio: probed
[    0.960220] ixgbe 0000:01:00.0 enp1s0: renamed from eth0
[    2.788208] ixgbe 0000:01:00.0: registered PHC device on enp1s0
[    2.966290] ixgbe 0000:01:00.0 enp1s0: detected SFP+: 3
[    3.110132] ixgbe 0000:01:00.0 enp1s0: NIC Link is Up 10 Gbps, Flow
Control: RX/TX

Thanks,

Michael


