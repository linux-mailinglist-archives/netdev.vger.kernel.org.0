Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69F336B340
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 14:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbhDZMjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 08:39:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41012 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhDZMjp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 08:39:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lb0Vr-001AJL-Mj; Mon, 26 Apr 2021 14:38:55 +0200
Date:   Mon, 26 Apr 2021 14:38:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v6 08/10] net: dsa: microchip: Add Microchip
 KSZ8863 SMI based driver support
Message-ID: <YIa0X2CfYBokmMIY@lunn.ch>
References: <20210423080218.26526-1-o.rempel@pengutronix.de>
 <20210423080218.26526-9-o.rempel@pengutronix.de>
 <YIRAwY+5yLJf1+CH@lunn.ch>
 <20210426122540.xzanhcel7gv4dfsh@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426122540.xzanhcel7gv4dfsh@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static const struct of_device_id ksz8863_dt_ids[] = {
> > > +	{ .compatible = "microchip,ksz8863" },
> > > +	{ .compatible = "microchip,ksz8873" },
> > > +	{ },
> > > +};
> > 
> > Is there code somewhere which verifies that what has been found really
> > does match what is in device tree? We don't want errors in the device
> > tree to be ignored.
> > 
> >      Andrew
> 
> Hm, it makes sense. But it is not regression of this patches, is it OK
> to mainline it separately?

Yes, but please don't forget it. Without verification, DT writers will
get it wrong. And then it becomes useless because you have to assume
it is wrong. Otherwise you break backwards compatibility.

   Andrew
