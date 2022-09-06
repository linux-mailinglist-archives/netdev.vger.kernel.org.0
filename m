Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF1D5AE20A
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbiIFILR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238975AbiIFIKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:10:55 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20EAF5B2;
        Tue,  6 Sep 2022 01:10:51 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 3EA2F21BD;
        Tue,  6 Sep 2022 10:10:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1662451850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qABwqikMuQitEu6esSylH2N0N3Qkg35n+zuX5vLw3g0=;
        b=qzK3W0w4Msm+to+uKMY78Q/1n5pb5rmJO38r3deI+cziXJajrCrUnKy5estnHANS0XJGAR
        cajRe+JmHkHzUH3CIQ4pUVJqGzPYIqwuOL3cna1tNFrDOmFymUnY1U80UGB4bSTeZtopl1
        CKOBd5bkeI12yp3R3kjlfXdTxDC8BcsbEeoPU4G5jprSqsexoJ4HKQQqA0jzsaCs8FYLUd
        rLPsfCqJ+Eib8DCuGmAbncF4UjcklfUqKRUFtNpE4W6J4ZzJhvNkuDhNWJLxEMAqqChBbH
        c0qVBQl55DzkVlOO7/uKcMOttUpD48ejrai3TbrcnEDN2NTtfl6QS3Vt92zKcw==
MIME-Version: 1.0
Date:   Tue, 06 Sep 2022 10:10:50 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH devicetree] arm64: dts: ls1028a-rdb: add more ethernet
 aliases
In-Reply-To: <20220905235413.6nfqi6vsp7iv32q3@skbuf>
References: <20220905212458.1549179-1-vladimir.oltean@nxp.com>
 <d00682d7e7aec2f979236338e7b3a688@walle.cc>
 <20220905235413.6nfqi6vsp7iv32q3@skbuf>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <0c1b726c6791cc97f9ba15f923264630@walle.cc>
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

Am 2022-09-06 01:54, schrieb Vladimir Oltean:
> On Tue, Sep 06, 2022 at 12:17:29AM +0200, Michael Walle wrote:
>> First, let me say, I'm fine with this patch. But I'm not sure,
>> how many MAC addresses are actually reserved on your
>> RDB/QDS boards?
> 
> AFAIK, the Reference Design Boards are sold with an unprogrammed I2C
> EEPROM, but with a sticker containing 5 MAC addresses on the bottom of
> the board. It doesn't have a clear correspondence between MAC addresses
> and their intended use, although I suspect that one MAC address is
> intended for each RJ45 port (although that isn't how I use them).
> 
> For the QIXIS Development Boards, I have no clue, it's probably even
> nonsensical to talk about MAC address reservations since there is just
> one onboard Ethernet port (RGMII) and the rest is routed via SERDES to
> PCIe slots, to pluggable riser cards, from which Linux/U-Boot don't 
> bother
> too much to read back any info, even though I can't exclude something
> like an EEPROM may be available on those cards too. In any case, I 
> think
> QDS boards don't leave the lab, so it doesn't matter too much.
> 
> The way I use the MAC addresses from the sticker of my RDBs, on a day 
> to
> day basis, is:
> 
> ethaddr (eno0) - #1
> eth1addr (eno2) - #2
> eth2addr (swp0) - #2
> eth3addr (swp1) - #2
> eth4addr (swp2) - #2
> eth5addr (swp3) - #2

Ah, I never thought of handing out the same MAC address.

> And now I'm adding these new env variables:
> 
> eth6addr (swp4) - #2
> eth7addr (swp5) - #2
> eth8addr (eno3) - #3
> 
> So I still have 2 more unique MAC addresses to burn through.
> 
>> I guess, they being evaluation boards you don't care? ;)
> 
> I do care a bit, but not that much.
> 
>> On the Kontron sl28 boards we reserve just 8 and that is
>> already a lot for a board with max 6 out facing ports. 4 of
>> these ports used to be a switch, so in theory it should work
> 
> /used/ to be a switch? What happened to them? Details? Or you mean
> "4 ports are used as a switch"?

I shouldn't probably write mails right before going to sleep.
Yes it should read "the 4 ports (swp0..swp3) are usually configured
to as a switch."

>> with 3 MAC addresses, right?
> 
> Which 3 MAC addresses would those be? Not sure I'm following. enetc #0,
> enetc #1, enetc #2? That could work, multiple DSA user ports can share
> the same MAC address (inherited from the DSA master or not) and things
> would work just fine unless you connect them to each other.

enetc #0, #1 and swp0. As you mentioned, swp1..3 should inherit the
address from swp0 then if swp0 is added as the first device, right?

So why would enetc#2 (or #3) need a non-random mac address? I must
be missing something here.

>> Or even just 2 if there is no need to terminate any traffic on the
>> switch interfaces.
> 
> And here, which 2? enetc #0 and enetc #1?

Yes. The switch would just be a dumb ethernet switch.

>> Anyway, do we really need so many addresses?
> 
> idk, who's "we" and what does "need" mean? (serious questions)

We as in the users of the ls1028a SoC. And as I said, I thought
of *unique* MAC addresses.

> I'm not sure I can give you any answer to this question. As an engineer
> working with the kernel, I need to roll the LS1028A Ethernet around on
> all its sides. The Linux RDB/QDS support will inevitably reflect what 
> we
> need to test. Everybody else will have a fixed configuration, and the
> user reviews will vary from 'internet works! 5 stars!' to 'internet
> doesn't work! 1 star!'.
> 
> To offer that quality of service for all front-facing ports, you don't
> need much. I know of a 12 port industrial switch that entered 
> production
> with 1 MAC address, the "termination" address. It's fine, when it's
> marketed as a switch, people come to expect that and don't wonder too 
> much.
> 
>> What are the configurations here? For what is the address of the
>> internal ports used?
> 
> By internal ports you mean swp4/swp5, or eno2/eno3?

eno2/eno3.

> If eno2/eno3, then a
> configuration where having MAC addresses on these interfaces is useful
> to me is running some of the kselftests on the LS1028A-RDB, which does
> not have enough external enetc ports for 2 loopback pairs, so I do
> this, thereby having 1 external loopback through a cable, and 1 
> internal
> loopback in the SoC:
> 
> ./psfp.sh eno0 swp0 swp4 eno2
> https://github.com/torvalds/linux/blob/master/tools/testing/selftests/drivers/net/ocelot/psfp.sh
> 
> Speaking of kselftests, it actually doesn't matter that much what the
> MAC addresses *are*, since we don't enter any network, just loop back
> traffic. In fact we have an environment variable STABLE_MAC_ADDRS, 
> which
> when set, configures the ports to use some predetermined MAC addresses.
> 
> There are other configurations where it is useful for eno2 to see DSA
> untagged traffic. These are downstream 802.1CB (where this hardware can
> offload redundant streams in the forwarding plane, but not in the
> termination plane, so we use eno2 as forwarding plane, for 
> termination),

I'm not that familiar with 802.1CB. Is this MAC address visible outside
of the switch or can it be a random one?

> DPDK on eno2 (which mainline Linux doesn't care about), and vfio-pci +
> QEMU, where DSA switch control still belongs to the Linux host, but the
> guest has 'internet'.

For me, all of that is kind of a trade off. If you want to use
virtual interfaces, you might need to borrow a MAC address from
one of the switch ports (where you have 3 unique addresses left
if you combine all 4 ports to one bridge).

>> Let's say we are in the "port extender mode" and use the
>> second internal port as an actual switch port, that would
>> then be:
>> 2x external enetc
>> 1x internal enetc
>> 4x external switch ports in port extender mode
>> 
>> Which makes 7 addresses. The internal enetc port doesn't
>> really make sense in a port extender mode, because there
>> is no switching going on.
> 
> It can make sense. You can run ptp4l -i eno2, and ptp4l -i swp4, as
> separate processes, and you can get high quality synchronization 
> between
> /dev/ptp0 (enetc) and /dev/ptp1 (felix) over internal Ethernet (there
> isn't any other mechanism in the SoC to keep them in sync if that is
> needed for some use case like a boundary_clock_jbod between eno0 + eno1
> + swp0-swp3).

Ok, could make sense.

>> So uhm, 6 addresses are the maximum?
> 
> No, the maximum is given by the number of ports, PFs and VFs. But 
> that's
> a high number. It's the theoretical maximum. Then there's the practical
> maximum, which is given by what kind of embedded system is built with 
> it.
> I think that the more general-purpose the system is, the more garden
> variety the networking use cases will be. I also think it would be very
> absurd for everybody to reserve a number of MAC addresses equal to the
> number of possibilities in which the LS1028A can expose IP termination
> points, if they're likely to never need them.

I think we are on the same track here. I was ignoring any VFs for now.
So I guess, what I'm still missing here is why enet#2 and enet#3 (or
even swp4 and swp5) would need a non-random MAC address. Except from
your example above. Considering the usecase where swp0..3 is one bridge
with eno2 and eno3 being the CPU ports. Then I'd only need a unique
MAC address for eno0, eno1 and swp0, correct?

-michael

>> This is the MAC address distribution for now on the
>> sl28 boards:
>> https://lore.kernel.org/linux-devicetree/20220901221857.2600340-19-michael@walle.cc/
>> 
>> Please tell me if I'm missing something here.
> 
> My 2 cents, if you don't need anything special like in-SoC PTP, 
> 802.1CB,
> virtualization, and don't habitually connect ports of the same ports to
> each other or do some other sorts of redundant networking without 
> VLANs,
> then there isn't too much wrong with one MAC address per RJ45 port, but
> best discuss with those who are actually marketing the devices.

