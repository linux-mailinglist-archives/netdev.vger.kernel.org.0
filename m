Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3511A270372
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgIRRhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:37:23 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:53595 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRRhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 13:37:23 -0400
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 26DA3100004;
        Fri, 18 Sep 2020 17:37:20 +0000 (UTC)
Date:   Fri, 18 Sep 2020 19:37:19 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net-next 05/11] net: dsa: seville: remove unused defines
 for the mdio controller
Message-ID: <20200918173719.GH9675@piout.net>
References: <20200918105753.3473725-1-olteanv@gmail.com>
 <20200918105753.3473725-6-olteanv@gmail.com>
 <20200918154645.GG9675@piout.net>
 <20200918155426.rb6mz72npul5m4fc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918155426.rb6mz72npul5m4fc@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 18:54:42+0300, Vladimir Oltean wrote:
> On Fri, Sep 18, 2020 at 05:46:45PM +0200, Alexandre Belloni wrote:
> > On 18/09/2020 13:57:47+0300, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > Some definitions were likely copied from
> > > drivers/net/mdio/mdio-mscc-miim.c.
> > >
> > > They are not necessary, remove them.
> >
> > Seeing that the mdio controller is probably the same, couldn't
> > mdio-mscc-miim be reused?
> 
> Yeah, it probably can, but for 75 lines of code, is it worth it to
> butcher mdio-mscc-miim too? I'm not sure at what level that reuse should
> be. Should we pass it our regmap? mdio-mscc-miim doesn't use regmap.

It may be worth it, I'm going to add DSA support for ocelot over SPI. So
to abstract the bus, it is probably worth moving to regmap.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
