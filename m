Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CEC4ED7CE
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 12:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbiCaKfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 06:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbiCaKfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 06:35:22 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2D360AAC
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 03:33:32 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id j15so47105771eje.9
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 03:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SwdrAsctWCHEz+RHJrjPcU6Mo/Sahn+tHHY0em4Qh6U=;
        b=PoEVk6ljjWDWy4eWyOUgYT+ghierixy1xTZLEKbm/JkrUhAnhyAS+iuRLL+YHb9V/P
         w9i5lZQiRXCXnbTy7O2EWBYw8aK89WhRNPeJykZGl0eVJIMOKiEVVhB5zLwv4Stq14j7
         BC65BgLit+Vf4IxPM80BkEqLdSXJFCjmW87U5+aqjE7jR1grcuqPZMHs2CE0Euabklb6
         E2yeCgaAiraeuhuow5kCLwICjkd3zbULNDP/ftRfYCwfBNO5aF4P/8GzGYAUUMjTbM3F
         /N2hSinTZWmPFHPb88flfVhQ2T8qRkJvC6xeQfOFhJ3N29RfZLlUJf15gUHMJRafVcmj
         TBqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SwdrAsctWCHEz+RHJrjPcU6Mo/Sahn+tHHY0em4Qh6U=;
        b=s5mwBOuq7jYH/cp7e0cwSBu2rVdTABxixwOsDwI8MNIFlwBylHAFDtlOtRj/UCkfqk
         RD45hB5JfkTiVLBxQ42cX+V20Oa95vT3tq+lsoTX5kTO7Eu4zFH+UstA1iyGkno+7+Qf
         FaplloeTClU148UF1NUsegd3jy64vp++iqxKm9ydzbqy0NKLvQ0SmUyPKm6pggOhciiG
         RYOr5XZSi2q3J+44EyI8IdTp4o7NYBcvKHt23qzwebd8wPk0qvHdryhzaTT0DZfLwsl8
         mWsuRTTzldjurkqa3h3+7u43lcdWtCdzyk0kYqLtO2G8hfUdrS1/7Oi4HdjoVdvRnZlC
         WwSA==
X-Gm-Message-State: AOAM5312kQFd4Z5YEpcfT6ZOyhHF5jIbL96FAtyKiddUf4wa92vYh/w3
        hl7BRbA9G5brpYsg3UkzgLJl6Q==
X-Google-Smtp-Source: ABdhPJxDOxt2l3HNQ2gJmuW8T8ulbPbJh7THegXZQrKSVoEVe7KObzJhpNMxM+H7IDkvhKod0UxL6w==
X-Received: by 2002:a17:906:6a1e:b0:6e0:5c27:a184 with SMTP id qw30-20020a1709066a1e00b006e05c27a184mr4447360ejc.355.1648722810635;
        Thu, 31 Mar 2022 03:33:30 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id bs7-20020a056402304700b004197e5d2350sm10625392edb.54.2022.03.31.03.33.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 03:33:30 -0700 (PDT)
Message-ID: <cf713c75-718e-6705-fc9d-6844372348d2@blackwall.org>
Date:   Thu, 31 Mar 2022 13:33:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v2] veth: Support bonding events
Content-Language: en-US
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
References: <20220329114052.237572-1-wintera@linux.ibm.com>
 <20220329175421.4a6325d9@kernel.org>
 <d2e45c4a-ed34-10d3-58cd-01b1c19bd004@blackwall.org>
 <c1ec0612-063b-dbfa-e10a-986786178c93@linux.ibm.com>
 <20220330085154.34440715@kernel.org>
 <c512e765-f411-9305-013b-471a07e7f3ff@blackwall.org>
 <20220330101256.53f6ef48@kernel.org> <2600.1648667758@famine>
 <fa420a98-fb7b-a56b-7e13-2fa55b6ff6a9@linux.ibm.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <fa420a98-fb7b-a56b-7e13-2fa55b6ff6a9@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/03/2022 12:59, Alexandra Winter wrote:
> On Tue, 29 Mar 2022 13:40:52 +0200 Alexandra Winter wrote:
>> Bonding drivers generate specific events during failover that trigger
>> switch updates.  When a veth device is attached to a bridge with a
>> bond interface, we want external switches to learn about the veth
>> devices as well.
>>
>> Example:
>>
>> 	| veth_a2   |  veth_b2  |  veth_c2 |
>> 	------o-----------o----------o------
>> 	       \	  |	    /
>> 		o	  o	   o
>> 	      veth_a1  veth_b1  veth_c1
>> 	      -------------------------
>> 	      |        bridge         |
>> 	      -------------------------
>> 			bond0
>> 			/  \
>> 		     eth0  eth1
>>
>> In case of failover from eth0 to eth1, the netdev_notifier needs to be
>> propagated, so e.g. veth_a2 can re-announce its MAC address to the
>> external hardware attached to eth1.
> 
> On 30.03.22 21:15, Jay Vosburgh wrote:
>> Jakub Kicinski <kuba@kernel.org> wrote:
>>
>>> On Wed, 30 Mar 2022 19:16:42 +0300 Nikolay Aleksandrov wrote:
>>>>> Maybe opt-out? But assuming the event is only generated on
>>>>> active/backup switch over - when would it be okay to ignore
>>>>> the notification?
>>>>
>>>> Let me just clarify, so I'm sure I've not misunderstood you. Do you mean opt-out as in
>>>> make it default on? IMO that would be a problem, large scale setups would suddenly
>>>> start propagating it to upper devices which would cause a lot of unnecessary bcast.
>>>> I meant enable it only if needed, and only on specific ports (second part is not
>>>> necessary, could be global, I think it's ok either way). I don't think any setup
>>>> which has many upper vlans/macvlans would ever enable this.
>>>
>>> That may be. I don't have a good understanding of scenarios in which
>>> GARP is required and where it's not :) Goes without saying but the
>>> default should follow the more common scenario.
>>
>> 	At least from the bonding failover persective, the GARP is
>> needed when there's a visible topology change (so peers learn the new
>> path), a change in MAC address, or both.  I don't think it's possible to
>> determine from bonding which topology changes are visible, so any
>> failover gets a GARP.  The original intent as best I recall was to cover
>> IP addresses configured on the bond itself or on VLANs above the bond.
>>
>> 	If I understand the original problem description correctly, the
>> bonding failover causes the connectivity issue because the network
>> segments beyond the bond interfaces don't share forwarding information
>> (i.e., they are completely independent).  The peer (end station or
>> switch) at the far end of those network segments (where they converge)
>> is unable to directly see that the "to bond eth0" port went down, and
>> has no way to know that anything is awry, and thus won't find the new
>> path until an ARP or forwarding entry for "veth_a2" (from the original
>> diagram) times out at the peer out in the network.
>>
>>>>>> My concern was about the Hangbin's alternative proposal to notify all
>>>>>> bridge ports. I hope in my porposal I was able to avoid infinite loops.  
>>>>>
>>>>> Possibly I'm confused as to where the notification for bridge master
>>>>> gets sent..  
>>>>
>>>> IIUC it bypasses the bridge and sends a notify peers for the veth peer so it would
>>>> generate a grat arp (inetdev_event -> NETDEV_NOTIFY_PEERS).
>>>
>>> Ack, I was basically repeating the question of where does 
>>> the notification with dev == br get generated.
>>>
>>> There is a protection in this patch to make sure the other 
>>> end of the veth is not plugged into a bridge (i.e. is not
>>> a bridge port) but there can be a macvlan on top of that
>>> veth that is part of a bridge, so IIUC that check is either
>>> insufficient or unnecessary.
>>
>> 	I'm a bit concerned this is becoming a interface plumbing
>> topology change whack-a-mole.
>>
>> 	In the above, what if the veth is plugged into a bridge, and
>> there's a end station on that bridge?  If it's bridges all the way down,
>> where does the need for some kind of TCN mechanism stop?
>>
>> 	Or instead of a veth it's an physical network hop (perhaps a
>> tunnel; something through which notifiers do not propagate) to another
>> host with another bridge, then what?
>>
>> 	-J
>>
>> ---
>> 	-Jay Vosburgh, jay.vosburgh@canonical.com
> 
> I see 3 technologies that are used for network virtualization in combination with bond for redundancy
> (and I may miss some):
> (1) MACVTAP/MACVLAN over bond:
> MACVLAN propagates notifiers from bond to endpoints (same as VLAN)
> (drivers/net/macvlan.c:
> 	case NETDEV_NOTIFY_PEERS:
> 	case NETDEV_BONDING_FAILOVER:
> 	case NETDEV_RESEND_IGMP:
> 		/* Propagate to all vlans */
> 		list_for_each_entry(vlan, &port->vlans, list)
> 			call_netdevice_notifiers(event, vlan->dev);
> 	})
> (2) OpenVSwitch:
> OVS seems to have its own bond implementation, but sends out reverse Arp on active-backup failover
> (3) User defined bridge over bond:
> propagates notifiers to the bridge device itself, but not to the devices attached to bridge ports.
> (net/bridge/br.c:
> 	case NETDEV_RESEND_IGMP:
> 		/* Propagate to master device */
> 		call_netdevice_notifiers(event, br->dev);)
> 
> Active-backup may not be the best bonding mode, but it is a simple way to achieve redundancy and I've seen it being used.
> I don't see a usecase for MACVLAN over bridge over bond (?)

If you're talking about this particular case (network virtualization) - sure. But macvlans over bridges
are heavily used in Cumulus Linux and large scale setups. For example VRRP is implemented using macvlan
devices. Any notification that propagates to the bridge and reaches these would cause a storm of broadcasts
being sent down which would not scale and is extremely undesirable in general.

> The external HW network does not need to be updated about the instances that are conencted via tunnel,
> so I don't see an issue there.
> 
> I had this idea how to solve the failover issue it for veth pairs attached to the user defined bridge.
> Does this need to be configurable? How? Per veth pair?

That is not what I meant (if you were referring to my comment), I meant if it gets implemented in the
bridge and it starts propagating the notify peers notifier - that _must_ be configurable.

> 
> Of course a more general solution how bridge over bond could handle notifications, would be great,
> but I'm running out of ideas. So I thought I'd address veth first.
> Your help and ideas are highly appreciated, thank you.

I'm curious why it must be done in the kernel altogether? This can obviously be solved in user-space
by sending grat arps towards flapped por for fdbs on other ports (e.g. veths) based on a netlink notification.
In fact based on your description propagating NETDEV_NOTIFY_PEERS to bridge ports wouldn't help
because in that case the remote peer veth will not generate a grat arp. The notification will
get propagated only to local veth (bridge port), or the bridge itself depending on implementation.

So from bridge perspective, if you decide to pursue a kernel solution, I think you'll need
a new bridge port option which acts on NOTIFY_PEERS and generates a grat arp for all fdbs
on the port where it is enabled to the port which generated the NOTIFY_PEERS. Note that is
also fragile as I'm sure some stacked device config would not work, so I want to re-iterate
how much easier it is to solve it in user-space which has better visibility and you can
change much faster to accommodate new use cases.

To illustrate: bond
                   \ 
                    bridge
                   /
               veth0
                 |
               veth1

When bond generates NOTIFY_PEERS, and you have this new option enabled on veth0 then
the bridge should generate grat arps for all fdbs on veth0 towards bond so the new
path would learn them. Note that is very dangerous as veth1 can generate thousands
of fdbs and you can potentially DDoS the whole network, so again I'd advise to do
this in user-space where you can better control it.

W.r.t to this patch, I think it will also work and will cause a single grat arp which
is ok. Just need to make sure loops are not possible, for example I think you can loop
your implementation by the following config (untested theory):
bond
    \
     bridge 
   \          \
veth2.10       veth0 - veth1
      \                \
       \                veth1.10 (vlan)
        \                \
         \                bridge2
          \              /
           veth2 - veth3


1. bond generates NOTIFY_PEERS
2. bridge propagates to veth1 (through veth0 port)
3. veth1 propagates to its vlan (veth1.10)
4. bridge2 sees veth1.10 NOTIFY_PEERS and propagates to veth2 (through veth3 port)
5. veth2 propagates to its vlan (veth2.10)
6. veth2.10 propagates it back to bridge
<loop>

I'm sure similar setup, and maybe even simpler, can be constructed with other devices
which can propagate or generate NOTIFY_PEERS.

Cheers,
 Nik






