Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBDB263158
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbgIIQJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:09:01 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:48146 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730777AbgIIQIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:08:40 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 089G8Y5R094144;
        Wed, 9 Sep 2020 11:08:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599667714;
        bh=Oh/qY4BatZ4K2GK5HL1C9iBef+ECXb4Lrh5utolQhFw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=qLwFL2JCG7TeBANL0tfjU5iGLUzUlpDaGanb+aUFg434HwxiKL2FhIgMP8T1WVF8k
         T6WQX7XCh5RL9hivlRWfM1Qwuy1yqroSFSVHFPKcvRVxApVj/vNNe8PIhUaRf6RmNi
         shWshJOt0Y6g/HW7/21Qt92ajgmbGppKR2uL+IqQ=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 089G8YID047218;
        Wed, 9 Sep 2020 11:08:34 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 9 Sep
 2020 11:08:34 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 9 Sep 2020 11:08:34 -0500
Received: from [10.250.73.77] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 089G8WjD010664;
        Wed, 9 Sep 2020 11:08:33 -0500
Subject: Re: [PATCH net-next 0/1] Support for VLAN interface over HSR/PRP
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20200901195415.4840-1-m-karicheri2@ti.com>
 <d93fbc54-1721-ebec-39ca-dc8b45e6e534@ti.com>
 <15bbf7d2-627b-1d52-f130-5bae7b7889de@ti.com>
 <CA+FuTSeri93irC9eaQqrFrY2++d0zJ4-F0YAfCXfX6XVVqU6Pw@mail.gmail.com>
 <bf8a22c2-0ebe-7a52-2e79-7dde72d444ba@ti.com>
 <CA+FuTSeE_O_XozfnzDED_S4of-NwtRCN+oWr=O3JPpByfCz3Vg@mail.gmail.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <e125917f-45fb-380b-61b1-ab7395a703a4@ti.com>
Date:   Wed, 9 Sep 2020 12:08:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSeE_O_XozfnzDED_S4of-NwtRCN+oWr=O3JPpByfCz3Vg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

On 9/8/20 1:51 PM, Willem de Bruijn wrote:
> On Tue, Sep 8, 2020 at 6:55 PM Murali Karicheri <m-karicheri2@ti.com> wrote:
>>
>> Hi Willem,
>>
>> On 9/4/20 11:52 AM, Willem de Bruijn wrote:
>>> On Thu, Sep 3, 2020 at 12:30 AM Murali Karicheri <m-karicheri2@ti.com> wrote:
>>>>
>>>> All,
>>>>
>>>> On 9/2/20 12:14 PM, Murali Karicheri wrote:
>>>>> All,
>>>>>
>>>>> On 9/1/20 3:54 PM, Murali Karicheri wrote:
>>>>>> This series add support for creating VLAN interface over HSR or
>>>>>> PRP interface. Typically industrial networks uses VLAN in
>>>>>> deployment and this capability is needed to support these
>>>>>> networks.
>>>>>>
>>>>>> This is tested using two TI AM572x IDK boards connected back
>>>>>> to back over CPSW  ports (eth0 and eth1).
>>>>>>
>>>>>> Following is the setup
>>>>>>
>>>>>>                    Physical Setup
>>>>>>                    ++++++++++++++
>>>>>>     _______________    (CPSW)     _______________
>>>>>>     |              |----eth0-----|               |
>>>>>>     |TI AM572x IDK1|             | TI AM572x IDK2|
>>>>>>     |______________|----eth1-----|_______________|
>>>>>>
>>>>>>
>>>>>>                    Network Topolgy
>>>>>>                    +++++++++++++++
>>>>>>
>>>>>>                           TI AM571x IDK  TI AM572x IDK
>>>>>>
>>>>>> 192.168.100.10                 CPSW ports                 192.168.100.20
>>>>>>                 IDK-1                                        IDK-2
>>>>>> hsr0/prp0.100--| 192.168.2.10  |--eth0--| 192.168.2.20 |--hsr0/prp0.100
>>>>>>                   |----hsr0/prp0--|        |---hsr0/prp0--|
>>>>>> hsr0/prp0.101--|               |--eth1--|              |--hsr0/prp0/101
>>>>>>
>>>>>> 192.168.101.10                                            192.168.101.20
>>>>>>
>>>>>> Following tests:-
>>>>>>     - create hsr or prp interface and ping the interface IP address
>>>>>>       and verify ping is successful.
>>>>>>     - Create 2 VLANs over hsr or prp interface on both IDKs (VID 100 and
>>>>>>       101). Ping between the IP address of the VLAN interfaces
>>>>>>     - Do iperf UDP traffic test with server on one IDK and client on the
>>>>>>       other. Do this using 100 and 101 subnet IP addresses
>>>>>>     - Dump /proc/net/vlan/{hsr|prp}0.100 and verify frames are transmitted
>>>>>>       and received at these interfaces.
>>>>>>     - Delete the vlan and hsr/prp interface and verify interfaces are
>>>>>>       removed cleanly.
>>>>>>
>>>>>> Logs for IDK-1 at https://pastebin.ubuntu.com/p/NxF83yZFDX/
>>>>>> Logs for IDK-2 at https://pastebin.ubuntu.com/p/YBXBcsPgVK/
>>>>>>
>>>>>> Murali Karicheri (1):
>>>>>>      net: hsr/prp: add vlan support
>>>>>>
>>>>>>     net/hsr/hsr_device.c  |  4 ----
>>>>>>     net/hsr/hsr_forward.c | 16 +++++++++++++---
>>>>>>     2 files changed, 13 insertions(+), 7 deletions(-)
>>>>>>
>>>>> I am not sure if the packet flow is right for this?
>>>>>
>>>>> VLAN over HSR frame format is like this.
>>>>>
>>>>> <Start of Frame><VLAN tag><HSR Tag><IP><CRC>
>>>>>
>>>>> My ifconfig stats shows both hsr and hsr0.100 interfaces receiving
>>>>> frames.
>>>>>
>>>>> So I did a WARN_ON() in HSR driver before frame is forwarded to upper
>>>>> layer.
>>>>>
>>>>> a0868495local@uda0868495:~/Projects/upstream-kernel$ git diff
>>>>> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
>>>>> index de21df30b0d9..545a3cd8c71b 100644
>>>>> --- a/net/hsr/hsr_forward.c
>>>>> +++ b/net/hsr/hsr_forward.c
>>>>> @@ -415,9 +415,11 @@ static void hsr_forward_do(struct hsr_frame_info
>>>>> *frame)
>>>>>                    }
>>>>>
>>>>>                    skb->dev = port->dev;
>>>>> -               if (port->type == HSR_PT_MASTER)
>>>>> +               if (port->type == HSR_PT_MASTER) {
>>>>> +                       if (skb_vlan_tag_present(skb))
>>>>> +                               WARN_ON(1);
>>>>>                            hsr_deliver_master(skb, port->dev,
>>>>> frame->node_src);
>>>>> -               else
>>>>> +               } else
>>>>>                            hsr_xmit(skb, port, frame);
>>>>>            }
>>>>>     }
>>>>>
>>>>> And I get the trace shown below.
>>>>>
>>>>> [  275.125431] WARNING: CPU: 0 PID: 0 at net/hsr/hsr_forward.c:420
>>>>> hsr_forward_skb+0x460/0x564
>>>>> [  275.133822] Modules linked in: snd_soc_omap_hdmi snd_soc_ti_sdma
>>>>> snd_soc_core snd_pcm_dmaengine snd_pcm snd_time4
>>>>> [  275.199705] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W
>>>>> 5.9.0-rc1-00658-g473e463812c2-dirty #8
>>>>> [  275.209573] Hardware name: Generic DRA74X (Flattened Device Tree)
>>>>> [  275.215703] [<c011177c>] (unwind_backtrace) from [<c010b6f0>]
>>>>> (show_stack+0x10/0x14)
>>>>> [  275.223487] [<c010b6f0>] (show_stack) from [<c055690c>]
>>>>> (dump_stack+0xc4/0xe4)
>>>>> [  275.230747] [<c055690c>] (dump_stack) from [<c01386ac>]
>>>>> (__warn+0xc0/0xf4)
>>>>> [  275.237656] [<c01386ac>] (__warn) from [<c0138a3c>]
>>>>> (warn_slowpath_fmt+0x58/0xb8)
>>>>> [  275.245177] [<c0138a3c>] (warn_slowpath_fmt) from [<c09564bc>]
>>>>> (hsr_forward_skb+0x460/0x564)
>>>>> [  275.253657] [<c09564bc>] (hsr_forward_skb) from [<c0955534>]
>>>>> (hsr_handle_frame+0x15c/0x190)
>>>>> [  275.262047] [<c0955534>] (hsr_handle_frame) from [<c07c6704>]
>>>>> (__netif_receive_skb_core+0x23c/0xc88)
>>>>> [  275.271223] [<c07c6704>] (__netif_receive_skb_core) from [<c07c7180>]
>>>>> (__netif_receive_skb_one_core+0x30/0x74)
>>>>> [  275.281266] [<c07c7180>] (__netif_receive_skb_one_core) from
>>>>> [<c07c72a4>] (netif_receive_skb+0x50/0x1c4)
>>>>> [  275.290793] [<c07c72a4>] (netif_receive_skb) from [<c071a55c>]
>>>>> (cpsw_rx_handler+0x230/0x308)
>>>>> [  275.299272] [<c071a55c>] (cpsw_rx_handler) from [<c0715ee8>]
>>>>> (__cpdma_chan_process+0xf4/0x188)
>>>>> [  275.307925] [<c0715ee8>] (__cpdma_chan_process) from [<c0717294>]
>>>>> (cpdma_chan_process+0x3c/0x5c)
>>>>> [  275.316754] [<c0717294>] (cpdma_chan_process) from [<c071dd14>]
>>>>> (cpsw_rx_mq_poll+0x44/0x98)
>>>>> [  275.325145] [<c071dd14>] (cpsw_rx_mq_poll) from [<c07c8ae0>]
>>>>> (net_rx_action+0xf0/0x400)
>>>>> [  275.333185] [<c07c8ae0>] (net_rx_action) from [<c0101370>]
>>>>> (__do_softirq+0xf0/0x3ac)
>>>>> [  275.340965] [<c0101370>] (__do_softirq) from [<c013f5ec>]
>>>>> (irq_exit+0xa8/0xe4)
>>>>> [  275.348224] [<c013f5ec>] (irq_exit) from [<c0199344>]
>>>>> (__handle_domain_irq+0x6c/0xe0)
>>>>> [  275.356093] [<c0199344>] (__handle_domain_irq) from [<c056f8fc>]
>>>>> (gic_handle_irq+0x4c/0xa8)
>>>>> [  275.364481] [<c056f8fc>] (gic_handle_irq) from [<c0100b6c>]
>>>>> (__irq_svc+0x6c/0x90)
>>>>> [  275.371996] Exception stack(0xc0e01f18 to 0xc0e01f60)
>>>>>
>>>>> Shouldn't it show vlan_do_receive() ?
>>>>>
>>>>>        if (skb_vlan_tag_present(skb)) {
>>>>>            if (pt_prev) {
>>>>>                ret = deliver_skb(skb, pt_prev, orig_dev);
>>>>>                pt_prev = NULL;
>>>>>            }
>>>>>            if (vlan_do_receive(&skb))
>>>>>                goto another_round;
>>>>>            else if (unlikely(!skb))
>>>>>                goto out;
>>>>>        }
>>>>>
>>>>> Thanks
>>>>>
>>>>
>>>> I did an ftrace today and I find vlan_do_receive() is called for the
>>>> incoming frames before passing SKB to hsr_handle_frame(). If someone
>>>> can review this, it will help. Thanks.
>>>>
>>>> https://pastebin.ubuntu.com/p/CbRzXjwjR5/
>>>
>>> hsr_handle_frame is an rx_handler called after
>>> __netif_receive_skb_core called vlan_do_receive and jumped back to
>>> another_round.
>>
>> Yes. hsr_handle_frame() is a rx_handler() after the above code that
>> does vlan_do_receive(). The ftrace shows vlan_do_receive() is called
>> followed by call to hsr_handle_frame(). From ifconfig I can see both
>> hsr and vlan interface stats increments by same count. So I assume,
>> vlan_do_receive() is called initially and it removes the tag, update
>> stats and then return true and go for another round. Do you think that
>> is the case?
> 
> That was my understanding.
> 
>> vlan_do_receive() calls vlan_find_dev(skb->dev, vlan_proto, vlan_id)
>> to retrieve the real netdevice (real device). However VLAN device is
>> attached to hsr device (real device), but SKB will have HSR slave
>> Ethernet netdevice (in our case it is cpsw device) and vlan_find_dev()
>> would have failed since there is no vlan_info in cpsw netdev struct. So
>> below code  in vlan_do_receive() should have failed and return false.
>>
>>          vlan_dev = vlan_find_dev(skb->dev, vlan_proto, vlan_id);
>>          if (!vlan_dev)
>>                  return false;
>>
>> So how does it goes for another_round ? May be vlan_find_dev is
>> finding the hsr netdevice?
> 
> It's good to answer this through code inspection and/or
> instrumentation. I do not have the answer immediately either.
> 
> There certainly is prior art in having vlan with an rx_handler,
> judging from the netif_is_macvlan_port(vlan_dev) and
> netif_is_bridge_port(vlan_dev) helpers in vlan_do_receive.
>> I am not an expert and so the question. Probably I can put a
>> traceprintk() to confirm this, but if someone can clarify this
>> it will be great. But for that, I will spin v2 with the above comments
>> addressed as in my reply and post.
> 
> Please don't send a patch before we understand this part.
> 
Sure! That is on my TODO. Will confirm this before sending next
revision of the patch.
-- 
Murali Karicheri
Texas Instruments
