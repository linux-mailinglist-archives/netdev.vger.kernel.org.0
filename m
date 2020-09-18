Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D6A270608
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgIRULa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:11:30 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:29279 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgIRULa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:11:30 -0400
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id A7018240002;
        Fri, 18 Sep 2020 20:11:27 +0000 (UTC)
Date:   Fri, 18 Sep 2020 22:11:27 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net-next 05/11] net: dsa: seville: remove unused defines
 for the mdio controller
Message-ID: <20200918201127.GA3616@piout.net>
References: <20200918105753.3473725-1-olteanv@gmail.com>
 <20200918105753.3473725-6-olteanv@gmail.com>
 <20200918154645.GG9675@piout.net>
 <20200918155426.rb6mz72npul5m4fc@skbuf>
 <20200918173719.GH9675@piout.net>
 <20200918185146.5322qugrmapyv7oo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918185146.5322qugrmapyv7oo@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 21:59:50+0300, Vladimir Oltean wrote:
> On Fri, Sep 18, 2020 at 07:37:19PM +0200, Alexandre Belloni wrote:
> > On 18/09/2020 18:54:42+0300, Vladimir Oltean wrote:
> > > On Fri, Sep 18, 2020 at 05:46:45PM +0200, Alexandre Belloni wrote:
> > > > On 18/09/2020 13:57:47+0300, Vladimir Oltean wrote:
> > > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > >
> > > > > Some definitions were likely copied from
> > > > > drivers/net/mdio/mdio-mscc-miim.c.
> > > > >
> > > > > They are not necessary, remove them.
> > > >
> > > > Seeing that the mdio controller is probably the same, couldn't
> > > > mdio-mscc-miim be reused?
> > >
> > > Yeah, it probably can, but for 75 lines of code, is it worth it to
> > > butcher mdio-mscc-miim too? I'm not sure at what level that reuse should
> > > be. Should we pass it our regmap? mdio-mscc-miim doesn't use regmap.
> >
> > It may be worth it, I'm going to add DSA support for ocelot over SPI. So
> > to abstract the bus, it is probably worth moving to regmap.
> 
> Wow, that's interesting, tell me more. For traffic, will you be using
> an NPI port, or some other configuration?
> 

Yes, the plan is to use SPI for configuration and an NPI port for
traffic. The internal MIPS CPU will be disabled. If I'm not mistaken,
this is what is done for vsc73xx.

> And as for reusing mdio-mscc-miim, I think I'll look into that as a
> separate set of patches.
> 

No worries, I can also take care of that. Or maybe you are right and it
doesn't make sense to do it.
