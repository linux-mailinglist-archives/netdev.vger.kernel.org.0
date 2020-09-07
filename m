Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6F926026D
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbgIGRZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729583AbgIGNWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 09:22:31 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44792C061574;
        Mon,  7 Sep 2020 06:21:13 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g4so12836534edk.0;
        Mon, 07 Sep 2020 06:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iblI3l/A3N9uapFrVsraod4LpexgkASbLVXO0EuF+qM=;
        b=JHvy0XH5e+VWE+X0gCEfss9ZWjxdMtQatWoB2ZPxrIhYw65vfnhUNqTdcVF3zm84de
         pMd6TNQAPDvM9oen4v7Swd1FskVvWARVBTQ7h1mjH+hlk0x1EveLDMXfhPlrABuW8Y29
         o7eG+vWAAIYUcHAxZcgbVD4/57tpEa5yYscPTvTqGEjRGTkvEdtPfWBI4UPPV9YKSkAi
         9srOPdY+BFcFj6IGGCJ0jYrMHdgYH3LqLvFE/veuC4ESqM/ucZlsNQVshCZ/POfM8lHz
         oe6NvGzIwQbItWomuZO1rDJSTjqJepVYNlHHQMISdhh+w9H2qAwVkzaV7x2vezScumN+
         s6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iblI3l/A3N9uapFrVsraod4LpexgkASbLVXO0EuF+qM=;
        b=IgJpyD2FiarAY0MNdka3r9VOl8ZjGs9plX+XXFm4f4DmtN5HjS6Rn8YEnKwHgfywBP
         7lBbrlkrXOMXJJg/Eei1noKuMw4NhTtsmzs+gQX/lQvzydhOSfDuwSq2SM9/vjONIG4b
         zL81B9HBp6IVhViYqDAWU7c+gpmgVh+TBeREGjbUYKms/2yMesLZyj36/XgUo7JlUT7B
         9cFpwAIi270z49axeHmfeoq2QBGPsQ/DSqXKKk/ttPzkR+buvxzFdeF4crwQOYSOmQ1u
         71yvDgSWKAVatS/2foyDHjY7b3TIOWxwRLErHcx5K/M1NXN6TBigUPyfQ4Pfj8ocUs84
         F6wA==
X-Gm-Message-State: AOAM5333T5MJqWsoe1cG21awjMXNtbJo4xh4L77s7ghx9m3PSY4mbsL2
        K5wkl1JPM2epedH/JvpBueA=
X-Google-Smtp-Source: ABdhPJzSsti/UlHJt2xsGh4lrdGkqi4/I/ENq0sQo6yK/XwaiJLRv+tcMCdw2/LYLN+aAHKcgM7n5g==
X-Received: by 2002:a05:6402:12d1:: with SMTP id k17mr21232834edx.323.1599484871894;
        Mon, 07 Sep 2020 06:21:11 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id y14sm15263157eje.10.2020.09.07.06.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 06:21:11 -0700 (PDT)
Date:   Mon, 7 Sep 2020 16:21:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v5 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek
 switches
Message-ID: <20200907132109.234ha7xst37dtqcj@skbuf>
References: <20200904062739.3540-1-kurt@linutronix.de>
 <20200904062739.3540-3-kurt@linutronix.de>
 <20200905204235.f6b5til4sc3hoglr@skbuf>
 <875z8qazq2.fsf@kurt>
 <20200907104821.kvu7bxvzwazzg7cv@skbuf>
 <87eendah1c.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eendah1c.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 02:49:03PM +0200, Kurt Kanzenbach wrote:
> On Mon Sep 07 2020, Vladimir Oltean wrote:
> > On Mon, Sep 07, 2020 at 08:05:25AM +0200, Kurt Kanzenbach wrote:
> >> Well, that depends on whether hellcreek_vlan_add() is called for
> >> creating that vlan interfaces. In general: As soon as both ports are
> >> members of the same vlan that traffic is switched.
> >
> > That's indeed what I would expect.
> > Not only that, but with your pvid-based setup, you only ensure port
> > separation for untagged traffic anyway.
>
> Why? Tagged traffic is dropped unless the vlan is configured somehow. By
> default, I've configured vlan 2 and 3 to reflect the port separation for
> DSA. At reset the ports aren't members of any vlan.
>

Wait, so what is the out-of-reset state of "ptcfg & HR_PTCFG_INGRESSFLT"?
If it is filtering by default (and even if it isn't, but you can make
it), then I suppose you can keep it like that, and try to model your
ports something like this:

- force "ethtool -k swpN | grep rx-vlan-filter" to return "on (fixed)".
- enforce a check that in standalone mode, you can't have an 8021q upper
  interface with the same VLAN ID on more than 1 port at the same time.
  This will be the only way in which you can terminate VLAN traffic on
  standalone ports.

If you do this, I think you should be compliant with the stack.

> We could also skip the initial VLAN configuration completely. At the end
> of the day it's a TSN switch and the user will setup the vlan
> configuration anyway.
>

Hmm, a driver is supposed to be use case agnostic.
I know people who are using a 5-port TSN switch (not this one) as a
1-port SGMII-to-RMII electrical adapter, with some hardware-accelerated
shaping.
I think it would be good if you could maintain a sane mode of operation
in standalone mode, it tends to come in as useful at times.

> > I don't think you even need to call hellcreek_vlan_add() for VID 100
> > to be switched between ports, because your .port_vlan_filtering
> > callback does not in fact disable VLAN awareness, it just configures
> > the ports to not drop unknown VLANs. So, arguably, VLAN classification
> > is still performed. An untagged packet is classified to the PVID, a
> > tagged packet is classified to the VID in the packet. So tagged
> > packets bypass the separation.
> >
> > So, I think that's not ok. I think the only proper way to solve this is
> > to inform the IP designers that VLANs are no substitute for a port
> > forwarding matrix (a lookup table that answers the question "can port i
> > forward to port j"). Switch ports that are individually addressable by
> > the network stack are a fundamental assumption of the switchdev
> > framework.
>
> As I said before, there is no port forwarding matrix. There are only
> vlans and the fdb. There's also a global flag for setting vlan unaware
> mode and a port option for vlan tag required. That's it. I guess, we
> have to deal with it somehow.
>

Yes, understood. But it's quite a strange omission.

> >
> >> > I remember asking in Message-ID: <20200716082935.snokd33kn52ixk5h@skbuf>
> >> > whether it would be possible for you to set
> >> > ds->configure_vlan_while_not_filtering = true during hellcreek_setup.
> >> > Did anything unexpected happen while trying that?
> >>
> >> No, that comment got lost.
> >>
> >> So looking at the flag: Does it mean the driver can receive vlan
> >> configurations when a bridge without vlan filtering is used? That might
> >> be problematic as this driver uses vlans for the port separation by
> >> default. This is undone when vlan filtering is set to 1 meaning vlan
> >> configurations can be received without any problems.
> >
> > Yes.
> > Generally speaking, the old DSA behavior is something that we're trying
> > to get rid of, once all drivers set the option to true. So a new driver
> > should not rely on it even if it needs something like that.
>
> OK. when a new driver should set the flag, then I'll set it. So, all
> vlan requests programming requests should be "buffered" and executed
> when vlan filtering is enabled? What is it good for?

It is good for correct functionality of the hardware, I don't get the
question? If your driver makes private use of VLAN tags beyond what the
upper layers ask for, then it should keep track of them. DSA has, in the
past, ignored VLAN switchdev operations from the bridge when not in
vlan_filtering mode, for unknown reasons. This is known to break some
command sequences (see below), so the consensus at the time was to stop
doing that, and introduce this temporary compatibility flag.

Some tests to make sure you're passing are:

1. Statically creating an 802.1Q bridge:

ip link add br0 type bridge vlan_filtering 1
ip link set swp1 master br0
ip link set swp2 master br0

2. Dynamically turning an 802.1D bridge into an 802.1Q bridge:

ip link add br0 type bridge
ip link set swp1 master br0
ip link set swp2 master br0
ip link set br0 type bridge vlan_filtering 1
# at this moment in time, if you don't have
# configure_vlan_while_not_filtering = true, then the VLAN tables of
# swp1 and swp2 will be missing the default_pvid (by default 1) of br0.

Thanks,
-Vladimir
