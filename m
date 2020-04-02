Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A726919C056
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 13:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387939AbgDBLmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 07:42:14 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38387 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgDBLmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 07:42:13 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jJyEY-0001jv-7O; Thu, 02 Apr 2020 13:42:06 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jJyES-0005T9-L6; Thu, 02 Apr 2020 13:42:00 +0200
Date:   Thu, 2 Apr 2020 13:42:00 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Herber <christian.herber@nxp.com>,
        Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add support for NXP
 TJA11xx
Message-ID: <20200402114200.GA15570@pengutronix.de>
References: <AM0PR04MB70413A974A2152D27CAADFAC86F00@AM0PR04MB7041.eurprd04.prod.outlook.com>
 <20200323151423.GA32387@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200323151423.GA32387@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:37:53 up 204 days, 25 min, 468 users,  load average: 3.36, 6.87,
 10.61
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 04:14:23PM +0100, Andrew Lunn wrote:
> > Yes, it is one device with two address. This is if you call the entire IC a device. If you look at it from a PHY perspective, it is two devices with 1 address.
> > If you just look at it as a single device, it gets difficult to add PHY specific properties in the future, e.g. master/slave selection.
> 
> > In my opinion its important to have some kind of container for the
> > entire IC, but likewise for the individual PHYs.
> 
> Yes, we need some sort of representation of two devices.
> 
> Logically, the two PHYs are on the same MDIO bus, so you could have
> two nodes on the main bus.
> 
> Or you consider the secondary PHY as being on an internal MDIO bus
> which is transparently bridged to the main bus. This is what was
> proposed in the last patchset.
> 
> Because this bridge is transparent, the rest of the PHY/MDIO framework
> has no idea about it. So i prefer that we keep with two PHY nodes on
> the main bus. But i still think we need the master PHY to register the
> secondary PHY, due to the missing PHY ID, and the other constrains
> like resets which the master PHY has to handle.

Yes, this is the way how current patches are implemented.

Should dt-binding documentation and PHY changes go via David's tree
upstream?  If nobody has strong opinion against it, @David can you
please take them.

Regards,
Oleksij & Marc
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
