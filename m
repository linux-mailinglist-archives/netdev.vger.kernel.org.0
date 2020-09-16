Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A223626CE70
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgIPWNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:13:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39534 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgIPWNW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 18:13:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kIfft-00EzI2-S0; Thu, 17 Sep 2020 00:13:13 +0200
Date:   Thu, 17 Sep 2020 00:13:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dp83869: Add ability to advertise
 Fiber connection
Message-ID: <20200916221313.GI3526428@lunn.ch>
References: <20200915181708.25842-1-dmurphy@ti.com>
 <20200915181708.25842-3-dmurphy@ti.com>
 <20200915201718.GD3526428@lunn.ch>
 <4b297d8a-b4da-0e19-a5fb-6dda89ca4148@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b297d8a-b4da-0e19-a5fb-6dda89ca4148@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 03:54:34PM -0500, Dan Murphy wrote:
> Andrew
> 
> On 9/15/20 3:17 PM, Andrew Lunn wrote:
> > > +		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
> > > +				 phydev->supported);
> > > +		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
> > > +				 phydev->supported);
> > > +
> > > +		/* Auto neg is not supported in 100base FX mode */
> > Hi Dan
> > 
> > If it does not support auto neg, how do you decide to do half duplex?
> > I don't see any code here which allows the user to configure it.
> 
> Ethtool has the provisions to set the duplex and speed right?.

What i'm getting at is you say you support
ETHTOOL_LINK_MODE_100baseFX_Full_BIT &
ETHTOOL_LINK_MODE_100baseFX_Half_BIT. If there is no auto neg in FX
mode, i'm questioning how these two different modes code be used? I'm
guessing the PHY defaults to ETHTOOL_LINK_MODE_100baseFX_Full_BIT? How
does the user set it to ETHTOOL_LINK_MODE_100baseFX_Half_BIT?

> The only call back I see which is valid is config_aneg which would still
> require a user space tool to set the needed link modes.

Correct. Maybe all you need to do is point me at the code in the
driver which actually sets the PHY into half duplex in FX mode when
the user asks for it. Is it just clearing BMCR_FULLDPLX?

    Andrew
 
