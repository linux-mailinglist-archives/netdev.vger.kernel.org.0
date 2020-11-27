Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB2A2C681D
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 15:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730991AbgK0Opy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 09:45:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52832 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729913AbgK0Opy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 09:45:54 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kif0L-0098tu-U4; Fri, 27 Nov 2020 15:45:45 +0100
Date:   Fri, 27 Nov 2020 15:45:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH v1] net: phy: micrel: fix interrupt handling
Message-ID: <20201127144545.GO2073444@lunn.ch>
References: <20201127123621.31234-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127123621.31234-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 01:36:21PM +0100, Oleksij Rempel wrote:
> After migration to the shared interrupt support, the KSZ8031 PHY with
> enabled interrupt support was not able to notify about link status
> change.
> 
> Fixes: 59ca4e58b917 ("net: phy: micrel: implement generic .handle_interrupt() callback")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

I took a quick look at all the other patches like this. I did not spot
any other missing the !

    Andrew
