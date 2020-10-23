Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C1529782E
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 22:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756030AbgJWUYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 16:24:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42324 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S376076AbgJWUYd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 16:24:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kW3br-003Ami-1t; Fri, 23 Oct 2020 22:24:23 +0200
Date:   Fri, 23 Oct 2020 22:24:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>, linux-can@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/6] net: phy: add CAN interface mode
Message-ID: <20201023202423.GD752111@lunn.ch>
References: <20201023105626.6534-1-o.rempel@pengutronix.de>
 <20201023105626.6534-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023105626.6534-4-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 12:56:23PM +0200, Oleksij Rempel wrote:
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/phy.c | 2 ++
>  include/linux/phy.h   | 3 +++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 35525a671400..4fb355df3e61 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -324,6 +324,8 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
>  	cmd->base.master_slave_state = phydev->master_slave_state;
>  	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
>  		cmd->base.port = PORT_BNC;
> +	else if (phydev->interface == PHY_INTERFACE_MODE_CAN)
> +		cmd->base.port = PORT_OTHER;
>  	else
>  		cmd->base.port = PORT_MII;

There is nothing stopping you from adding CAN specific PORT_ types.

      Andrew
