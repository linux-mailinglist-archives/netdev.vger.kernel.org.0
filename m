Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C49D291FCE
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 22:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgJRUZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 16:25:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33806 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgJRUZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 16:25:59 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUFFL-002MxD-Qg; Sun, 18 Oct 2020 22:25:39 +0200
Date:   Sun, 18 Oct 2020 22:25:39 +0200
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
Message-ID: <20201018202539.GJ456889@lunn.ch>
References: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
 <20201013021858.20530-3-chris.packham@alliedtelesis.co.nz>
 <20201018161624.GD456889@lunn.ch>
 <b3d1d071-3bce-84f4-e9d5-f32a41c432bd@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3d1d071-3bce-84f4-e9d5-f32a41c432bd@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I assume you're talking about the PHY Control Register 0 bit 11. If so 
> that's for the internal PHYs on ports 0-7. Ports 8, 9 and 10 don't have 
> PHYs.

Hi Chris

I have a datasheet for the 6122/6121, from some corner of the web,
Part 3 of 3, Gigabit PHYs and SERDES.

http://www.image.micros.com.pl/_dane_techniczne_auto/ui88e6122b2lkj1i0.pdf

Section 5 of this document talks
about the SERDES registers. Register 0 is Control, register 1 is
Status - Fiber, register 2 and 3 are the usual ID, 4 is auto-net
advertisement etc.

Where these registers appear in the address space is not clear from
this document. It is normally in document part 2 of 3, which my
searching of the web did not find.

	  Andrew

