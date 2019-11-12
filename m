Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93BDCF9339
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfKLOvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:51:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36074 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbfKLOu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 09:50:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MdO8IrDo0V2nICpGDkF61n2bFV7gKeYNL4A6C+BnRIs=; b=uAn4oWKZIeMF8Zb+73VRISTr9P
        9OHIEinLYoEXy9XnBos3oGnZLaO/xsPBbxc0u6otYdEeo+NqOayuIWLj9am6mByiTDIxMKbg1mMHN
        2Q4kUJLEJMtOJKZw+bFaqfdqzr9RePt8MzUZUGfjd6qCuxHbpejXtTdQ1bfaJnFTK4oU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUXVO-00022N-Or; Tue, 12 Nov 2019 15:50:54 +0100
Date:   Tue, 12 Nov 2019 15:50:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 10/12] net: dsa: vitesse: move vsc73xx driver to
 a separate folder
Message-ID: <20191112145054.GG10875@lunn.ch>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-11-olteanv@gmail.com>
 <20191112130947.GE3572@piout.net>
 <CA+h21hqYynoGwfd=g3rZFgYSKNxsv8PXstD+6btopykweEi1dw@mail.gmail.com>
 <20191112143346.3pzshxapotwdbzpg@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112143346.3pzshxapotwdbzpg@lx-anielsen.microsemi.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > As there are no commonalities between the vsc73xx and felix drivers,
> > > shouldn't you simply leave that one out and have felix in the existing
> > > microchip folder?
> > >
> > 
> > I don't have a strong preference, although where I come from, all new
> > NXP networking drivers are still labeled as "freescale" even though
> > there is no code reuse. There are even less commonalities with
> > Microchip (ex-Micrel, if I am not mistaken) KSZ switches than with the
> > old vsc73xx. I'll let the ex-Vitesse people decide.
> I'm on the same page as Alexandre here.

Leaving them where they are makes maintenance easier. Fixes are easier
to backport if things don't move around.

> I think we should leave vsc73xx where it is already, and put the felix driver in
> the drivers/net/ethernet/mscc/ folder where ocelot is already.

Currently, all DSA drivers are in drivers/net/dsa. We do occasionally
make changes over all DSA drivers at once, so it is nice they are all
together. So i would prefer the DSA part of Felix is also there. But
the core can be in drivers/net/ethernet/mscc/.

    Andrew
