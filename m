Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B6B29206C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 00:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbgJRWIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 18:08:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33872 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbgJRWIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 18:08:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUGqd-002NwM-Id; Mon, 19 Oct 2020 00:08:15 +0200
Date:   Mon, 19 Oct 2020 00:08:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6097
Message-ID: <20201018220815.GK456889@lunn.ch>
References: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
 <20201013021858.20530-3-chris.packham@alliedtelesis.co.nz>
 <20201018161624.GD456889@lunn.ch>
 <b3d1d071-3bce-84f4-e9d5-f32a41c432bd@alliedtelesis.co.nz>
 <20201018202539.GJ456889@lunn.ch>
 <2e1f1ca4-b5d5-ebc8-99bf-9ad74f461d26@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e1f1ca4-b5d5-ebc8-99bf-9ad74f461d26@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 09:15:52PM +0000, Chris Packham wrote:
> 
> On 19/10/20 9:25 am, Andrew Lunn wrote:
> >> I assume you're talking about the PHY Control Register 0 bit 11. If so
> >> that's for the internal PHYs on ports 0-7. Ports 8, 9 and 10 don't have
> >> PHYs.
> > Hi Chris
> >
> > I have a datasheet for the 6122/6121, from some corner of the web,
> > Part 3 of 3, Gigabit PHYs and SERDES.
> >
> > http://www.image.micros.com.pl/_dane_techniczne_auto/ui88e6122b2lkj1i0.pdf
> >
> > Section 5 of this document talks
> > about the SERDES registers. Register 0 is Control, register 1 is
> > Status - Fiber, register 2 and 3 are the usual ID, 4 is auto-net
> > advertisement etc.
> >
> > Where these registers appear in the address space is not clear from
> > this document. It is normally in document part 2 of 3, which my
> > searching of the web did not find.
> >
> > 	  Andrew
> 
> I have got the 88E6122 datasheet(s) and can see the SERDES registers 
> you're talking about (I think they're in the same register space as the 
> built-in PHYs). It looks like the 88E6097 is different in that there are 
> no SERDES registers exposed (at least not in a documented way). Looking 
> at the 88E6185 it's the same as the 88E6097.

Hi Chris

I find it odd there are no SERDES registers.  Can you poke around the
register space and look for ID registers? See if there are any with
Marvells OUI, but different to the chip ID found in the port
registers?

> So how do you want to move this series forward? I can test it on the 
> 88E6097 (and have restricted it to just that chip for now), I'm pretty 
> sure it'll work on the 88E6185. I doubt it'll work on the 88E6122 but 
> maybe it would with a different serdes_power function (or even the 
> mv88e6352_serdes_power() as you suggested).

Make your best guess for what you cannot test.

     Andrew
