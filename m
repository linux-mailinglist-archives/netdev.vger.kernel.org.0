Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B955AFFB7
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiIGI4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIGI4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:56:40 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380EC9E888;
        Wed,  7 Sep 2022 01:56:39 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id A9F392215;
        Wed,  7 Sep 2022 10:56:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1662540997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WEWTZxlFI1rLCwhn1L/c+AQV/SD54aBbcxjLZOuB7gA=;
        b=hviVkIhkoXjZLmrUc7X+KVtsBHnJAd+Bj6Nz/wERqLMyg4Ci3T62CD8TyeTOesKXilsDlO
        ME/T9dAy+J8PawhESydtClMHzZsd0XDq1iiAhW0Zs7jzA8vlI5jmi/pevWgRocCS/4vvU7
        f1qJ2dCQiFPWS594UV2FfA8UGg1Joxf5zbpjeNEq/flJEn3UtMs8PZBjXnWSlKY7lxWKPu
        dajP/bD7Qn89fqr4NXXUWhxEdRKGsMbUGWhgbaZv6drCYVzhGep3W4+1w33VBjUjHanIDS
        cVmnCHy0FHCum8V2ob1HOKny4jHeEhxkWJYZ7Pi9GP740sZ8++kkNB30FwErHQ==
MIME-Version: 1.0
Date:   Wed, 07 Sep 2022 10:56:37 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH devicetree] arm64: dts: ls1028a-rdb: add more ethernet
 aliases
In-Reply-To: <20220906100525.mhjomm6f2y4lr3lw@skbuf>
References: <20220905212458.1549179-1-vladimir.oltean@nxp.com>
 <d00682d7e7aec2f979236338e7b3a688@walle.cc>
 <20220905235413.6nfqi6vsp7iv32q3@skbuf>
 <0c1b726c6791cc97f9ba15f923264630@walle.cc>
 <20220906100525.mhjomm6f2y4lr3lw@skbuf>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <eaa92fcc134df14714f9d14635e551a1@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-09-06 12:05, schrieb Vladimir Oltean:
> On Tue, Sep 06, 2022 at 10:10:50AM +0200, Michael Walle wrote:
>> > > with 3 MAC addresses, right?
>> >
>> > Which 3 MAC addresses would those be? Not sure I'm following. enetc #0,
>> > enetc #1, enetc #2? That could work, multiple DSA user ports can share
>> > the same MAC address (inherited from the DSA master or not) and things
>> > would work just fine unless you connect them to each other.
>> 
>> enetc #0, #1 and swp0. As you mentioned, swp1..3 should inherit the
>> address from swp0 then if swp0 is added as the first device, right?
>> 
>> So why would enetc#2 (or #3) need a non-random mac address? I must
>> be missing something here.
> 
> I didn't say that swp1..3 inherit the MAC address from swp0. I said 
> that
> the DSA user ports can inherit the MAC address from the DSA master 
> (eno2
> or eno3). See dsa_slave_create():
> 
> 	if (!is_zero_ether_addr(port->mac)) // device tree
> 		eth_hw_addr_set(slave_dev, port->mac);
> 	else
> 		eth_hw_addr_inherit(slave_dev, master);
> 
> The DSA user ports (swp0-swp3) can also share the same MAC address 
> which
> is not inherited from the DSA master (eno2), but this can only be
> achieved through static configuration (such as manually setting the 
> same
> mac-address in the device tree).

Right. I need to jog my memory on the whole briding stuff again. Sorry,
I mixed that up with the bridge using the lowest MAC as its id. I.e.
it looked like br0 inherited the address from the interface which
was added to it first.

>> > If eno2/eno3, then a
>> > configuration where having MAC addresses on these interfaces is useful
>> > to me is running some of the kselftests on the LS1028A-RDB, which does
>> > not have enough external enetc ports for 2 loopback pairs, so I do
>> > this, thereby having 1 external loopback through a cable, and 1 internal
>> > loopback in the SoC:
>> >
>> > ./psfp.sh eno0 swp0 swp4 eno2
>> > https://github.com/torvalds/linux/blob/master/tools/testing/selftests/drivers/net/ocelot/psfp.sh
>> >
>> > Speaking of kselftests, it actually doesn't matter that much what the
>> > MAC addresses *are*, since we don't enter any network, just loop back
>> > traffic. In fact we have an environment variable STABLE_MAC_ADDRS, which
>> > when set, configures the ports to use some predetermined MAC addresses.
>> >
>> > There are other configurations where it is useful for eno2 to see DSA
>> > untagged traffic. These are downstream 802.1CB (where this hardware can
>> > offload redundant streams in the forwarding plane, but not in the
>> > termination plane, so we use eno2 as forwarding plane, for termination),
>> 
>> I'm not that familiar with 802.1CB. Is this MAC address visible 
>> outside
>> of the switch or can it be a random one?
> 
> The MAC address of eno2 is visible outside the switch, onto the 
> network.
> Take this 802.1CB ring network for example:
> https://github.com/vladimiroltean/isochron/blob/master/frer/8021cb.sh
> 
> Every board has 2 redundant ports in the ring, and every board can ping
> every other board through the redundant ring, through an IP termination
> point (eno2). Except that the switch does not support 
> inserting/stripping
> 802.1CB redundancy headers for locally terminated traffic, or 
> splitting/
> eliminating duplicate streams for locally terminated traffic.
> 
> So we configure the switch to consider the internal swp4 as a user 
> port,
> and effectively set it up for the forwarding plane, in a bridge with
> swp0 and swp1. It's now as if each eno2 used for termination is
> connected to a switch that's physically separate from the LS1028A, 
> which
> handles the redundant forwarding. Except it's not physically separate,
> it's part of the same SoC, and its DSA master is eno3. All in all, it
> requires a bit of a split brain syndrome to work with it. This is in
> fact one of the key things blocking 802.1CB upstreaming for us, as a
> side note - we don't have a very good proposal for modeling a generic
> software data path for this.
> 
> You can see more details here if you care enough:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210928114451.24956-1-xiaoliang.yang_1@nxp.com/
> 
>> > DPDK on eno2 (which mainline Linux doesn't care about), and vfio-pci +
>> > QEMU, where DSA switch control still belongs to the Linux host, but the
>> > guest has 'internet'.
>> 
>> For me, all of that is kind of a trade off. If you want to use
>> virtual interfaces, you might need to borrow a MAC address from
>> one of the switch ports (where you have 3 unique addresses left
>> if you combine all 4 ports to one bridge).
> 
> I didn't say virtual interfaces in this case, I said vfio-pci which is 
> a
> way to do PCI direct assignment to a guest OS, which sees the whole
> 0000:00:00.2 PF corresponding to eno2.

Yes of course. I need to find a good compromise for the MAC assignments.
And running virtualization on our board might be a use case, but I
don't know how common that one is. So for now, I'm ignoring it.

> By the way, the internal enetc ports eno2 and eno3 don't have VFs since
> SR-IOV is a bit of a complicated topic when DSA-tagged traffic is
> expected (you don't want a guest OS to see DSA tags in packets, it
> doesn't know what to do with them). But this is one of the main reasons
> we have 2 internal ports btw. You configure eno3 as a DSA master, you
> leave swp4 as a user port, so now eno2 sees DSA untagged traffic and 
> you
> can do direct assignment to whomever.
> 
>> > > So uhm, 6 addresses are the maximum?
>> >
>> > No, the maximum is given by the number of ports, PFs and VFs. But that's
>> > a high number. It's the theoretical maximum. Then there's the practical
>> > maximum, which is given by what kind of embedded system is built with
>> > it.
>> > I think that the more general-purpose the system is, the more garden
>> > variety the networking use cases will be. I also think it would be very
>> > absurd for everybody to reserve a number of MAC addresses equal to the
>> > number of possibilities in which the LS1028A can expose IP termination
>> > points, if they're likely to never need them.
>> 
>> I think we are on the same track here. I was ignoring any VFs for now.
>> So I guess, what I'm still missing here is why enet#2 and enet#3 (or
>> even swp4 and swp5) would need a non-random MAC address. Except from
>> your example above. Considering the usecase where swp0..3 is one 
>> bridge
>> with eno2 and eno3 being the CPU ports. Then I'd only need a unique
>> MAC address for eno0, eno1 and swp0, correct?
> 
> Don't say "unique MAC address for swp0", since swp0's MAC address is 
> not
> unique, you probably mean to say "a MAC address which will be shared by
> swp0-swp3".

That I actually don't understand. I have the following addresses after
booting:

# ip link
..
4: gbe0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP 
group default qlen 1000
     link/ether 00:a0:a5:5c:6b:62 brd ff:ff:ff:ff:ff:ff
     inet 172.16.1.2/24 scope global gbe0
        valid_lft forever preferred_lft forever
     inet6 fe80::2a0:a5ff:fe5c:6b62/64 scope link
        valid_lft forever preferred_lft forever
5: gbe1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group 
default qlen 1000
     link/ether 00:a0:a5:5c:6b:63 brd ff:ff:ff:ff:ff:ff
6: eno2: <BROADCAST,MULTICAST> mtu 1504 qdisc noop state DOWN group 
default qlen 1000
     link/ether 8e:6c:20:8a:ab:52 brd ff:ff:ff:ff:ff:ff
7: eno3: <BROADCAST,MULTICAST> mtu 1504 qdisc noop state DOWN group 
default qlen 1000
     link/ether c6:fd:b1:88:3c:36 brd ff:ff:ff:ff:ff:ff
8: swp0@eno2: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state 
DOWN group default qlen 1000
     link/ether 00:a0:a5:5c:6b:66 brd ff:ff:ff:ff:ff:ff
9: swp1@eno2: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state 
DOWN group default qlen 1000
     link/ether 00:a0:a5:5c:6b:67 brd ff:ff:ff:ff:ff:ff
10: swp2@eno2: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state 
DOWN group default qlen 1000
     link/ether 00:a0:a5:5c:6b:68 brd ff:ff:ff:ff:ff:ff
11: swp3@eno2: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state 
DOWN group default qlen 1000
     link/ether 00:a0:a5:5c:6b:69 brd ff:ff:ff:ff:ff:ff

gbe0 is eno0 and gbe1 is eno1. So in my case they are unique.

When adding all the ports to a bridge, the bridge gets the lowest MAC.

# ip link add name br0 type bridge
# ip link set swp0 master br0
# ip link set swp1 master br0
# ip link set swp2 master br0
# ip link set swp3 master br0

12: br0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode 
DEFAULT group default qlen 1000
     link/ether 00:a0:a5:5c:6b:66 brd ff:ff:ff:ff:ff:ff

Is that what you mean with "a MAC address which will be shared by
swp0-swp3"?

> I think I've answered why eno2/eno3 could need a stable MAC address -
> for the case when they aren't used as DSA masters (through the switch
> termination plane) but as interfaces unaware of the switch connected to
> them (through the switch forwarding plane).

Yes thanks for the explanation!

-michael
