Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B4C16A884
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 15:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgBXOh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 09:37:58 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:46029 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgBXOh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 09:37:58 -0500
X-Originating-IP: 86.202.111.97
Received: from localhost (lfbn-lyo-1-16-97.w86-202.abo.wanadoo.fr [86.202.111.97])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 06CB7C0008;
        Mon, 24 Feb 2020 14:37:54 +0000 (UTC)
Date:   Mon, 24 Feb 2020 15:37:53 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [CFT 6/8] net: macb: use resolved link config in mac_link_up()
Message-ID: <20200224143753.GA3640@piout.net>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <E1j3k85-00072l-RK@rmk-PC.armlinux.org.uk>
 <20200219143036.GB3390@piout.net>
 <20200220101828.GV25745@shell.armlinux.org.uk>
 <20200224131520.GM18808@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224131520.GM18808@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/02/2020 13:15:20+0000, Russell King - ARM Linux admin wrote:
> On Thu, Feb 20, 2020 at 10:18:28AM +0000, Russell King - ARM Linux admin wrote:
> > On Wed, Feb 19, 2020 at 03:30:36PM +0100, Alexandre Belloni wrote:
> > > Hi,
> > > 
> > > On 17/02/2020 17:24:21+0000, Russell King wrote:
> > > > Convert the macb ethernet driver to use the finalised link
> > > > parameters in mac_link_up() rather than the parameters in mac_config().
> > > > 
> > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > > ---
> > > >  drivers/net/ethernet/cadence/macb.h      |  1 -
> > > >  drivers/net/ethernet/cadence/macb_main.c | 46 ++++++++++++++----------
> > > >  2 files changed, 27 insertions(+), 20 deletions(-)
> > > > 
> > > 
> > > I did test the series after rebasing on top of the at91rm9200 fix.
> 
> Okay, I've updated my series, which will appear in my "phy" branch
> later today.  However, what would you like me to do with the authorship
> on the updated patch (I haven't yet checked what the differences were),
> and can I add a tested-by to patch 1 for you?  I'll wait until you've
> replied before pushing it out.
> 

I don't mind you keeping the authorship. You can add the tested-by on
patch 1 and this one. Note that I've tested all three of the atmel
revisions of the IP.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
