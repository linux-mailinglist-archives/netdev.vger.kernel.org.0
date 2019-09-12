Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59919B13D9
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 19:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbfILRlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 13:41:46 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32842 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfILRlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 13:41:45 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so16451873pfl.0
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 10:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CWoNSvJtrsk1J/rWRyTgcog6/ImZtE2X4AtHFmaopnk=;
        b=V1vXoQts3q66pVprchZVsEyMmsw0YcwhEElZ0TQiVRfcJC0zEhxN6j4dW/Vkc6OpQL
         SHr97bDFcDpxZDY3MUXyaz7CK4nWwdYz85r/TYobxm7/oOGY4hLHVoMiFnH/roCatv9i
         aoXBLXGe/ZFog3bSBKXyV9yoN0S+uiUqZ4atcAdfx6+xYFCKtT/YTXrCSugioCYL6vqv
         JttumqcFUB967bqB0mx4uq7VWZ9QnTLbtX53aqQSND2PQokMck7FwD1G/R3eVZRM6I8+
         MVXMVdYibixl0Pl9NyUYLSjwTTCdHUAff+pkCCB076pmj5U640NxblqWuPSAlg/glnAL
         jtpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=CWoNSvJtrsk1J/rWRyTgcog6/ImZtE2X4AtHFmaopnk=;
        b=kBgyXWhDwRAlC3S9X70FZqiYpchrpJRV26lhmpUOPvA54Gu2+mn7jhAg6BGTQ/bTnB
         iroyWsx6oKFu7pm7xnq809vG5BUqTasiRLdqfQ5R7qcf4X0WBY05mnSZuRy16eP9U4iO
         WY4+Ul4OOORPA6Jw0o+WN9vlHMb9BhM9/EE6hQVPbJOyP3b3EFolzfyp2oiVSwWcZlcf
         u0aB0e9+h1axGJCIpnJYF/88kMDmDNYyBxO0aje6hoTvWoR7qpK4gqxWlDyIruDgeeo3
         YIYL0JAMFxshbOO/9Qf9vCj/LRp3Kxf8vZmxUEX1CMPbH9QpnKdvzR+HHTk149Rct60z
         hDjg==
X-Gm-Message-State: APjAAAVnqKt1EkeejZrKm0cEuBTWJ3zme+rJ2nHOSXdhV6hWPby28yOb
        n2c6AitH2Wuqjg9kR3Xr7Os=
X-Google-Smtp-Source: APXvYqyvZir7fvko0FTrf6VDaW3WbR6JfRxl4mzYAH+3uilHhenqDPAunqxnNq0eO4C3XyHV4TXdgA==
X-Received: by 2002:a62:e209:: with SMTP id a9mr39835524pfi.164.1568310103960;
        Thu, 12 Sep 2019 10:41:43 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k95sm525061pje.10.2019.09.12.10.41.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 10:41:43 -0700 (PDT)
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
To:     Robert Beckett <bob.beckett@collabora.com>,
        Ido Schimmel <idosch@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <545d6473-848f-3194-02a6-011b7c89a2ca@gmail.com>
 <20190911112134.GA20574@splinter>
 <3f50ee51ec04a2d683a5338a68607824a3f45711.camel@collabora.com>
 <20190912090339.GA16311@splinter>
 <68676250-17df-b0bb-521a-64877f198647@gmail.com>
 <4943d80defe5458701311a0da03bf44d2a61baac.camel@collabora.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <f19c4586-9d5b-8133-b659-fda51fb5c3b4@gmail.com>
Date:   Thu, 12 Sep 2019 10:41:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4943d80defe5458701311a0da03bf44d2a61baac.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/19 9:46 AM, Robert Beckett wrote:
> On Thu, 2019-09-12 at 09:25 -0700, Florian Fainelli wrote:
>> On 9/12/19 2:03 AM, Ido Schimmel wrote:
>>> On Wed, Sep 11, 2019 at 12:49:03PM +0100, Robert Beckett wrote:
>>>> On Wed, 2019-09-11 at 11:21 +0000, Ido Schimmel wrote:
>>>>> On Tue, Sep 10, 2019 at 09:49:46AM -0700, Florian Fainelli
>>>>> wrote:
>>>>>> +Ido, Jiri,
>>>>>>
>>>>>> On 9/10/19 8:41 AM, Robert Beckett wrote:
>>>>>>> This patch-set adds support for some features of the
>>>>>>> Marvell
>>>>>>> switch
>>>>>>> chips that can be used to handle packet storms.
>>>>>>>
>>>>>>> The rationale for this was a setup that requires the
>>>>>>> ability to
>>>>>>> receive
>>>>>>> traffic from one port, while a packet storm is occuring on
>>>>>>> another port
>>>>>>> (via an external switch with a deliberate loop). This is
>>>>>>> needed
>>>>>>> to
>>>>>>> ensure vital data delivery from a specific port, while
>>>>>>> mitigating
>>>>>>> any
>>>>>>> loops or DoS that a user may introduce on another port
>>>>>>> (can't
>>>>>>> guarantee
>>>>>>> sensible users).
>>>>>>
>>>>>> The use case is reasonable, but the implementation is not
>>>>>> really.
>>>>>> You
>>>>>> are using Device Tree which is meant to describe hardware as
>>>>>> a
>>>>>> policy
>>>>>> holder for setting up queue priorities and likewise for queue
>>>>>> scheduling.
>>>>>>
>>>>>> The tool that should be used for that purpose is tc and
>>>>>> possibly an
>>>>>> appropriately offloaded queue scheduler in order to map the
>>>>>> desired
>>>>>> scheduling class to what the hardware supports.
>>>>>>
>>>>>> Jiri, Ido, how do you guys support this with mlxsw?
>>>>>
>>>>> Hi Florian,
>>>>>
>>>>> Are you referring to policing traffic towards the CPU using a
>>>>> policer
>>>>> on
>>>>> the egress of the CPU port? At least that's what I understand
>>>>> from
>>>>> the
>>>>> description of patch 6 below.
>>>>>
>>>>> If so, mlxsw sets policers for different traffic types during
>>>>> its
>>>>> initialization sequence. These policers are not exposed to the
>>>>> user
>>>>> nor
>>>>> configurable. While the default settings are good for most
>>>>> users, we
>>>>> do
>>>>> want to allow users to change these and expose current
>>>>> settings.
>>>>>
>>>>> I agree that tc seems like the right choice, but the question
>>>>> is
>>>>> where
>>>>> are we going to install the filters?
>>>>>
>>>>
>>>> Before I go too far down the rabbit hole of tc traffic shaping,
>>>> maybe
>>>> it would be good to explain in more detail the problem I am
>>>> trying to
>>>> solve.
>>>>
>>>> We have a setup as follows:
>>>>
>>>> Marvell 88E6240 switch chip, accepting traffic from 4 ports. Port
>>>> 1
>>>> (P1) is critical priority, no dropped packets allowed, all others
>>>> can
>>>> be best effort.
>>>>
>>>> CPU port of swtich chip is connected via phy to phy of intel i210
>>>> (igb
>>>> driver).
>>>>
>>>> i210 is connected via pcie switch to imx6.
>>>>
>>>> When too many small packets attempt to be delivered to CPU port
>>>> (e.g.
>>>> during broadcast flood) we saw dropped packets.
>>>>
>>>> The packets were being received by i210 in to rx descriptor
>>>> buffer
>>>> fine, but the CPU could not keep up with the load. We saw
>>>> rx_fifo_errors increasing rapidly and ksoftirqd at ~100% CPU.
>>>>
>>>>
>>>> With this in mind, I am wondering whether any amount of tc
>>>> traffic
>>>> shaping would help? Would tc shaping require that the packet
>>>> reception
>>>> manages to keep up before it can enact its policies? Does the
>>>> infrastructure have accelerator offload hooks to be able to apply
>>>> it
>>>> via HW? I dont see how it would be able to inspect the packets to
>>>> apply
>>>> filtering if they were dropped due to rx descriptor exhaustion.
>>>> (please
>>>> bear with me with the basic questions, I am not familiar with
>>>> this part
>>>> of the stack).
>>>>
>>>> Assuming that tc is still the way to go, after a brief look in to
>>>> the
>>>> man pages and the documentation at largc.org, it seems like it
>>>> would
>>>> need to use the ingress qdisc, with some sort of system to
>>>> segregate
>>>> and priortise based on ingress port. Is this possible?
>>>
>>> Hi Robert,
>>>
>>> As I see it, you have two problems here:
>>>
>>> 1. Classification: Based on ingress port in your case
>>>
>>> 2. Scheduling: How to schedule between the different transmission
>>> queues
>>>
>>> Where the port from which the packets should egress is the CPU
>>> port,
>>> before they cross the PCI towards the imx6.
>>>
>>> Both of these issues can be solved by tc. The main problem is that
>>> today
>>> we do not have a netdev to represent the CPU port and therefore
>>> can't
>>> use existing infra like tc. I believe we need to create one.
>>> Besides
>>> scheduling, we can also use it to permit/deny certain traffic from
>>> reaching the CPU and perform policing.
>>
>> We do not necessarily have to create a CPU netdev, we can overlay
>> netdev
>> operations onto the DSA master interface (fec in that case), and
>> whenever you configure the DSA master interface, we also call back
>> into
>> the switch side for the CPU port. This is not necessarily the
>> cleanest
>> way to do things, but that is how we support ethtool operations (and
>> some netdev operations incidentally), and it works
> 
> After reading up on tc, I am not sure how this would work given the
> semantics of the tool currently.
> 
> My initial thought was to model the switch's 4 output queues using an
> mqprio qdisc for the CPU port, and then use either iptables's classify
> module on the input ports to set which queue it egresses from on the
> CPU port, or use vlan tagging with id 0 and priority set. (with the
> many detail of how to implement them still left to discover).
> 
> However, it looks like the mqprio qdisc could only be used for egress,
> so without a netdev representing the CPU port, I dont know how it could
> be used.

If you are looking at mapping your DSA master/CPU port egress queues to
actual switch egress queues, you can look at what bcm_sf2.c and
bcmsysport.c do and read the commit messages that introduced the mapping
functionality for background on why this was done. In a nutshell, the
hardware has the ability to back pressure the Ethernet MAC behind the
CPU port in order to automatically rate limit the egress out of the
switch. So for instance, if your CPU tries to send 1Gb/sec of traffic to
a port that is linked to a link partner at 100Mbits/sec, there is out of
band information between the switch and the Ethernet DMA of the CPU port
to pace the TX completion interrupt rate to match 100Mbits/sec.

This is going to be different for you here obviously because the
hardware has not been specifically designed for that, so you do need to
rely on more standard constructs, like actual egress QoS on both ends.

> 
> Another thing I thought of using was just to use iptable's TOS module
> to set the minimal delay bit and rely on default behaviours, but Ive
> yet to find anything in the Marvell manual that indicates it could set
> that bit on all frames entering a port.
> 
> Another option might be to use vlans with their priority bits being
> used to steer to output queues, but I really dont want to introduce
> more virtual interfaces in to the setup, and I cant see how to
> configure an enforce default vlan tag with id 0 and priority bits set
> via linux userland tools.
> 
> 
> It does look like tc would be quite nice for configuring the egress
> rate limiting assuming we a netdev to target with the rate controls of
> the qdisc.
> 
> 
> So far, this seems like I am trying to shoe horn this stuff in to tc.
> It seems like tc is meant to configure how the ip stack  configures
> flow within the stack, whereas in a switch chip, the packets go nowhere
> near the CPUs kernel ip stack. I cant help thinking that it would be
> good have a specific utility for configuring switches that operates on
> the port level for manage flow within the chip, or maybe simple sysfs
> attributes to set the ports priority.

I am not looking at tc the same way you are doing, tc is just the tool
to configure all QoS/ingress/egress related operations on a network
device. Whether that network device can offload some of the TC
operations or not is where things get interesting.

TC has ingress filtering support, which is what you could use for
offloading broadcast storms, I would imagine that the following should
be possible to be offloaded (this is not a working command but you get
the idea):

tc qdisc add dev sw0p0 handle ffff: ingress
tc filter add dev sw0p0 parent ffff: protocol ip prio 1 u32 match ether
src 0xfffffffffffff police rate 100k burst 10k skip_sw

something along those lines is how I would implement ingress rate
limiting leveraging what the switch could do. This might mean adding
support for offloading specific TC filters, Jiri and Ido can certainly
suggest a cleverer way of achieving that same functionality.
-- 
Florian
