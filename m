Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A901B3716E2
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 16:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhECOqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 10:46:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50984 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229905AbhECOqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 10:46:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ldZog-002Iy9-No; Mon, 03 May 2021 16:44:58 +0200
Date:   Mon, 3 May 2021 16:44:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v2 02/17] net: mdio: ipq8064: switch to
 write/readl function
Message-ID: <YJAMavCyVxYERJPK@lunn.ch>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
 <20210502230710.30676-2-ansuelsmth@gmail.com>
 <YI/xXuWbq7npocCS@lunn.ch>
 <YJAHj/IWZLEZeDmL@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJAHj/IWZLEZeDmL@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 04:24:15PM +0200, Ansuel Smith wrote:
> On Mon, May 03, 2021 at 02:49:34PM +0200, Andrew Lunn wrote:
> > On Mon, May 03, 2021 at 01:06:54AM +0200, Ansuel Smith wrote:
> > > Use readl/writel function instead of regmap function to make sure no
> > > value is cached and align to other similar mdio driver.
> > 
> > regmap is O.K. to use, so long as you tell it not to cache. Look at
> > how to use volatile in regmap.
> > 
> > You might be able to follow what lan9303_mdio.c is doing.
> > 
> >     Andrew
> 
> Was thinking more about the overhead of using regmap instead of plain
> writel. Or is it minimal?

It is likely other parts of the system are using regmap. So it will
not be adding much overhead.

    Andrew
