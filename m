Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6A24820FC
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 01:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240932AbhLaA21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 19:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhLaA20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 19:28:26 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E185C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 16:28:26 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id j21so103534655edt.9
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 16:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J/QOWSwymh9x6Pc0I82xNfd4AAYcas7Hw3OKeAYZvFQ=;
        b=MXVvBL/o/qebl1Q82xYM6bhlZGt/jU3RHg7FmDUz2K+BIyHeHHmt8h1IuIqwHP58Zf
         UMK5uHx7dJppIlhnQGjx9EzQu59CUW+s+ZThEyBvuMcO60O/ERccvJiFRqD9tg/c5hju
         M2PHKLiiK16FQByd8r2kPwWtF9bYGa7oC/jWzIdMPz1wBlFDyYzz5+IQX8YaZSdGKDJI
         ft1rHvtLp2jHyb6r6KsBJGfkOebQdjR3u00YSWgBcNOPR+szzpB54oVoqZKsI6T8oDPg
         cde89JZ9ZnYu3Q/C1yrMQ6grrjjWyXnxnnnnS2k+F8IpUDlRNbnHwE+0FmFtxLH6a2TO
         2l9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J/QOWSwymh9x6Pc0I82xNfd4AAYcas7Hw3OKeAYZvFQ=;
        b=GwlUoCY9udWoz8jDCxTh4AYcU7r/0bzuQdQYha8j1nV/Vj/Vp4JARS6QwZT6XuaFiN
         GAH9MFdxHL5MdOMeftQMYMuyO95whWD2S8pZ62oZplVGbapU2RXWf7Y+BDjcEES3wb7D
         VRvBJD1MMdlY4Lh8nb/+LEKu9kGRNXdnoyPpiiJuBzpqGZkbVnfvRz8UAK0hJ2GMAV0S
         4AhWCMUSkenhr9qWwuPwuVkxwBqTmgeKFhBWQM1RN2/S+ZecHvVik81iNf2Kx9yTvcOk
         ZR0QNXsKXp0/aKxDqVFPC9hsTwzUh2FuLbKKEXVq9GfCIGiZuXPvMfonR4bX7r0tXZFT
         lQOg==
X-Gm-Message-State: AOAM53103x8YBFSTzKySrfMiLTj6dwvlOBy57G0psQ3F7VuxphpaE6Ja
        qHxdk332CqJU71AknesMEHA=
X-Google-Smtp-Source: ABdhPJzzQc30+9S0vUnkYZxPg+hp+SnePeNFllNMF9ojZYS0gHUlo6GRipTa1OUAq4Gz6eb3IAYZcg==
X-Received: by 2002:a17:907:7d8b:: with SMTP id oz11mr26248549ejc.12.1640910504520;
        Thu, 30 Dec 2021 16:28:24 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id z26sm9885881edr.11.2021.12.30.16.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 16:28:24 -0800 (PST)
Date:   Fri, 31 Dec 2021 02:28:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: packets trickling out of STP-blocked ports
Message-ID: <20211231002823.de3ugpurq3fv343b@skbuf>
References: <20211230230740.GA1510894@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230230740.GA1510894@euler>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Thu, Dec 30, 2021 at 03:07:40PM -0800, Colin Foster wrote:
> After running this, the STP blocks swp3, and swp1/2 are forwarding.
>
> Periodically I see messages saying that swp2 is receiving packets with
> own address as source address.
>
> I can confirm that via ethtool that TX packets are increasing on swp3. I
> believe I captured the event via tshark. A 4 minute capture showed three
> non-STP packets on swp2. All three of these packets are ICMPv6 Router
> Solicitation packets.
>
> I would expect no packets at all to egress swp3. Is this an issue that
> is unique to me and my in-development configuration? Or is this an issue
> with all Ocelot / Felix devices?

I don't remember noticing these (or maybe I did and I forgot), but
reasoning about it, it's a pretty logical consequence of some of the
design decisions that were made.

One would think that when a network interface is under a bridge, it is
unavailable for direct IP termination by itself - you do the IP
termination through the br0 interface. But that isn't really enforced
anywhere - it's just that the bridge breaks IP termination by default on
its individual member ports by stealing all their traffic with its RX handler.
That RX handler can be taught what to steal and what not to steal using
netfilter ebtables rules. With some carefully designed rules, you could
still have some IP termination through the individual bridge ports.

Hardware isn't carved out according to your expectation that no packets
should egress a blocked port, either. Switches in general, and Ocelot in
particular, have a way to send "control" packets that bypass the
analyzer block and STP state (the bridging service, basically) and are
sent towards a precise set of destination ports. This is done by setting
the BYPASS bit from the injection frame header. Currently, Linux sends
"control" packets to the switch all the time, and that is fine, because
although those packets have the ability to go where they don't belong,
the OS (the bridge driver) is supposed to know that, and just not send
packets there. As a side note, there was some work to allow switch
drivers to send "data" packets to the switch, and these correspond to
traffic that originates from a bridge device, but I am just mentioning
this to clarify that it is irrelevant for the purpose of the discussion here.

Even considering an Intel card with no bridging offload at all, if you
put it in the same situation (eth0 under br0, and eth0 is blocked), you
can still put an IP address on eth0 and ping away just fine (you won't
get back the reply as mentioned above, but that's separate really).
Nobody will prevent packets from eth0 from being sent, since the bridge
driver code path isn't invoked on TX unless the socket is bound to br0.

The key point is that the direct xmit data path through swp3, as well as
the data path br0 -> swp3, both exist, in hardware and in software. And
while in hardware they're a bit more clearly separated (in IEEE 802.1Q
there's even a block diagram to clarify that both exist), in software
they're entangled in a bit of a mess, and there are parts of the network
stack and of user space that aren't aware that swp3 is under a bridge,
so IPv6 Router Solicitation messages being sent through swp3 shouldn't
be much of a surprise.



With that out of the way.

Traditionally, DSA has made a design decision that all switch ports
inherit the single MAC address of the DSA master. IOW, if you have 1 DSA
master and 4 switch ports, you have 5 interfaces in the system with the
same MAC address. It was like this for a long time, and relatively
recently, Xiaofei Shen added the ability for individual DSA interfaces
to have their own MAC address stored in the device tree.

As an argument in favor of the status quo, Florian explained that:

| By default, DSA switch need to come up in a configuration where all
| ports (except CPU/management) must be strictly separate from every other
| port such that we can achieve what a standalone Ethernet NIC would do.
| This works because all ports are isolated from one another, so there is
| no cross talk and so having the same MAC address (the one from the CPU)
| on the DSA slave network devices just works, each port is a separate
| broadcast domain.
| 
| Once you start bridging one or ore ports, the bridge root port will have
| a MAC address, most likely the one the CPU/management Ethernet MAC, but
| similarly, this is not an issue and that's exactly how a software bridge
| would work as well.

https://patchwork.kernel.org/project/linux-arm-msm/patch/20190222125815.12866-1-vkoul@kernel.org/

Although yes, that does make some level of sense, it kind of omits the
fact that two DSA ports can be used for communication in loopback too
(either through a direct cable, or through an externally switched network).
In that case, having a MAC SA != MAC DA in the Ethernet packets is kind
of important (I found that out while trying to compose some selftests
for DSA).


If my intuition is correct, you are using the default configuration
where all DSA interfaces have the MAC address inherited from the DSA
master. Corrolary, swp2 and swp3 have the same MAC address.

swp3 is a bridged port, and a blocked port at that, but not all parts of
the network stack know that. So from time to time, you get these IPv6
Router Solicitation messages. They could be anything else, in fact.

swp2 is a bridged port, and in the forwarding state. So packets it
receives are eligible for learning.

When br0 receives a packet via swp2 that originated from swp3, it just
complains: "hey, learning the route for this packet's MAC SA to go
towards swp2 would mean that I would no longer terminate packets with
this MAC DA locally, which is kinda weird, since that MAC address is
also marked as non-forwarded." Which is fair.


So IMHO, this behavior is neither good nor bad, it is just the way it is,
nothing to worry about if that's what concerns you. To prove or disprove
what I said you could try to configure individual MAC addresses and see
whether that fixes the problem.

> (side note - if there's a place where a parser for Ocelot NPI traffic is
> hidden, that might eventually save me a lot of debugging in Lua)

Nope, there isn't, although it would certainly be great if you could
teach tcpdump about it, similar to what Vivien has done for Marvell:
https://github.com/the-tcpdump-group/tcpdump/blob/master/print-dsa.c

I've wanted to do that for a long time, but I've had lots of other
priorities, and it's tricky for various reasons (there isn't exactly a
single on-the-wire format, but it depends on whether you configure the
NPI port to have no prefix, a short prefix or a long prefix; this
configuration is independent for the RX and TX directions; currently we
use short prefix on RX and TX, but in older kernels we used to use no
prefix on TX, and long prefix on RX on some older kernels, all while the
tagging protocol was still "ocelot"; I'm not sure whether the presence
or absence of a prefix, and what kind, can be deduced by looking at the
packet alone).
