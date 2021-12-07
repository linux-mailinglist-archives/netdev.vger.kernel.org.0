Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FF046C70D
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239045AbhLGWFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhLGWFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 17:05:16 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11459C061574;
        Tue,  7 Dec 2021 14:01:45 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id 133so466747wme.0;
        Tue, 07 Dec 2021 14:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=j5TwbpXibLHCYBffakcvi/rXEMnmliT65okyPAA9qRM=;
        b=niGU/GbOos1lcR0o/BDXQ2t1hjOAb8M3MQ+2LpAQQ/fkGBs+NmdsOCDODB5k5AE0q+
         UEXPtXUgUxpfsUwEYZev6f3ztPIjjCFO/pNolYF2BNX7gluVvlGHlwOhh446y8gGFEVX
         ZjXj/lK17ZNAHbgrh8stNL74hxg9YsvFNb4vuzMgZi6fNGhe6VIycKi4BGOyHNr6a8c7
         97OQkKcNEzqKLruPXiiCRWY8NzlROZ/FlwBYPSOLxgJxQcRwOkt02E8hGBeoT+Z1r0N6
         IaJSI1boozEnFdoXIz+FOiZxoYh1oZEMK9fugWc51Qpgkokp6F70S1HFf2ACTPE0UXQB
         q97g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=j5TwbpXibLHCYBffakcvi/rXEMnmliT65okyPAA9qRM=;
        b=FarpK5Niy4QE3mlfxN+KmlDO0+IwVMCJDKlO1MpWRS8K5AW+NFP3bM7JpVNzxcd4Bv
         3s6E9Fqp5rPt5ufhL9SdVUvnIZtC16sJ+owiLHSdWzI6tf8OXQyOQv7hkQDTSlJWoUWr
         Cb/6sCtFzdFc1dhOCSQYuLZcqsjgEvMvaIkt+jVmIDmypq/IXd4SZFZBQIXHyYDmQr8v
         DXdath+dn5yb+lPFRlxgb1J6h67FAhuGtxZ/N153UFsnYC+Nq0scP4nyBbMSbNyD7P/A
         gbU2FUYjejxTsnNii5kIZjrZ+tLAbxGfjRYyt050Ve/oqUfuTLMd0L1etga4df2baVHR
         SLFw==
X-Gm-Message-State: AOAM532X82Oa67XudX7ljqo8WxAXvmGz1+GAQaJKbz0XYAkGrW5Gv+H8
        R8YHdEtZX0clu3BL6oOYxpPK8XvbVfg=
X-Google-Smtp-Source: ABdhPJywGn4rMWL4EY9LPrg9vVHNHHlNYCXYLNSbgJe9x/CgisorkFQSahEJjy1gqTHzOqZcOMHGBg==
X-Received: by 2002:a1c:1903:: with SMTP id 3mr10435183wmz.89.1638914503411;
        Tue, 07 Dec 2021 14:01:43 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id p2sm4166661wmq.23.2021.12.07.14.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 14:01:43 -0800 (PST)
Message-ID: <61afd9c7.1c69fb81.70084.5209@mx.google.com>
X-Google-Original-Message-ID: <Ya/ZqP8SazOWPxfN@Ansuel-xps.>
Date:   Tue, 7 Dec 2021 23:01:12 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya96pwC1KKZDO9et@lunn.ch>
 <77203cb2-ba90-ff01-5940-2e9b599f648f@gmail.com>
 <20211207211018.cljhqkjyyychisl5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207211018.cljhqkjyyychisl5@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 11:10:18PM +0200, Vladimir Oltean wrote:
> On Tue, Dec 07, 2021 at 10:49:43AM -0800, Florian Fainelli wrote:
> > On 12/7/21 7:15 AM, Andrew Lunn wrote:
> > > On Tue, Dec 07, 2021 at 03:59:36PM +0100, Ansuel Smith wrote:
> > >> Hi, this is still WIP and currently has some problem but I would love if
> > >> someone can give this a superficial review and answer to some problem
> > >> with this.
> > >>
> > >> The main reason for this is that we notice some routing problem in the
> > >> switch and it seems assisted learning is needed. Considering mdio is
> > >> quite slow due to the indirect write using this Ethernet alternative way
> > >> seems to be quicker.
> > >>
> > >> The qca8k switch supports a special way to pass mdio read/write request
> > >> using specially crafted Ethernet packet.
> > > 
> > > Oh! Cool! Marvell has this as well, and i suspect a few others. It is
> > > something i've wanted to work on for a long long time, but never had
> > > the opportunity.
> > > 
> > > This also means that, even if you are focusing on qca8k, please try to
> > > think what could be generic, and what should specific to the
> > > qca8k. The idea of sending an Ethernet frame and sometime later
> > > receiving a reply should be generic and usable for other DSA
> > > drivers. The contents of those frames needs to be driver specific.
> > > How we hook this into MDIO might also be generic, maybe.
> > > 
> > > I will look at your questions later, but soon.
> > 
> > There was a priori attempt from Vivien to add support for mv88e6xxx over
> > RMU frames:
> > 
> > https://www.mail-archive.com/netdev@vger.kernel.org/msg298317.html
> > 
> > This gets interesting because the switch's control path moves from MDIO
> > to Ethernet and there is not really an "ethernet bus" though we could
> > certainly come up with one. We have mdio-i2c, so maybe we should have
> > mdio-ethernet?
> 
> This raises interesting questions. I see two distinct cases:
> 
> 1. "dual I/O": the switch probes initially over a standard bus (MDIO,
>    SPI, I2C) then at some point transitions towards I/O through the
>    tagger.  This would be the case when there is some preparation work
>    to be done (maybe the CPU port needs to be brought up, maybe there is
>    a firmware to be uploaded to the switch's embedded microcontroller
>    such that the expected remote management protocol is supported, etc).
>    It would also be the case when multiple CPU ports are supported (and
>    changing between CPU ports), because we could end up bringing a
>    certain CPU port down, and the register I/O would need to be
>    temporarily done over MDIO before bringing the other CPU port up.
> 
> 2. "single I/O": the switch needs no such configuration, and in this
>     case, it could in principle probe over an "Ethernet bus" rather than
>     a standard bus as mentioned above.
> 
> I don't know which case is going to be more common, honestly. The
> difference between the two is that the former would work using the
> existing infrastructure (bus types) we have today, whereas the latter
> would (maybe) need an "Ethernet bus" as mentioned by Vivien and Florian.
>

Considering this is very specific for qca8k (it does use very not
standard Ethernet packet) and we have only another switch that more or
less supports this, I honestly think we should think about the dual I/0.
qca8k for example require to be setup first with mdio (as it does
require some bit to enable header mode, the tagger way to comunicate
ethernet mdio type packet) and generally the cpu port has to be
configured for the phy mode. We can't assume a bootloader correctly
setup the cpu port and the switch being able to receive packet so I
think a fallback is always necessary.

> I'm not completely convinced, though. The argument for an "Ethernet bus"
> seems to be that any Ethernet controller may need to set up such a
> thing, independently of being a DSA master. In Vivien's link, an example
> is given where we have "Control path via port 1, Data path via port port 3".
> But I don't know, this separation seems pretty artificial and ultimately
> boils down to configuration. Like it or not, in that particular example,
> both ports 1 and 3 are CPU ports, and both eth1 and eth0 are DSA masters.
> The fact that they are used asymmetrically should pretty much not matter.
> 
> I think a fair simplifying assumption is that switch management
> protocols will never be spoken through interfaces that aren't DSA
> masters (because being a DSA master _implies_ having a physical link to
> a DSA switch). And if we have this simplifying factor, we could consider
> moving dsa_tree_setup_master() somewhere earlier in the DSA probe path,
> and just make "type 2" / "single I/O" switches be platform devices, with
> a more-or-less empty probe function (just calls dsa_register_switch),
> and do their hardware init in ->setup, which is _after_
> dsa_tree_setup_master and therefore after the tagging protocol has bound
> to the DSA switch tree and is prepared to handle I/O. So no bus really
> needed.
> 
> Although I have to point this out. An "Ethernet bus" would be one of the
> most unreliable buses out there. Consider that the user may run "ip link
> set eth0 down" at any given time. What do you do, as a switch driver on
> an Ethernet bus, when your DSA master goes down? Postpone all your I/O?
> Error out on I/O? Unbind?

With something like an Ethernet bus only (no dual I/O) the operation
should just be rejected to prevent this kind of stuff. (return EBUSY error?)

> 
> Even moreso, there are currently code paths in DSA that can only be done
> while the DSA master is down (changing the tagging protocol comes to
> mind). So does this mean that those code paths are simply not available
> when the I/O is over Ethernet? Or does it mean that Ethernet cannot be
> the sole I/O method of any switch driver, due to it being unreliable?
> And if the latter, this is yet another argument against "Ethernet as bus".
> A bus is basically only there for probing purposes, but if you need to
> have a primary I/O method beside Ethernet, you already have a bus and
> don't need another.

As I said up, a ""stable"" I/O method must be present and the fast path
should be used only if available. About this I'm thinking if we should
create an helper and let dsa decide when a method can be used instead of
another one. A dsa driver will then use these helper function and mimic
the standard read/write/update_bits thing (but this would be very specific
and used only for Ethernet mdio and probably not correct)

-- 
	Ansuel
