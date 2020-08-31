Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49C9257B19
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 16:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgHaOL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 10:11:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34218 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbgHaOLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 10:11:25 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kCkWn-00CeUt-Fi; Mon, 31 Aug 2020 16:11:21 +0200
Date:   Mon, 31 Aug 2020 16:11:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        zhengdejin5@gmail.com, richard.leitner@skidata.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 5/5] net: phy: smsc: LAN8710/LAN8720: remove
 PHY_RST_AFTER_CLK_EN flag
Message-ID: <20200831141121.GF2403519@lunn.ch>
References: <20200831134836.20189-1-m.felsch@pengutronix.de>
 <20200831134836.20189-6-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831134836.20189-6-m.felsch@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 03:48:36PM +0200, Marco Felsch wrote:
> Don't reset the phy without respect to the phy-state-machine because
> this breaks the phy IRQ mode. We can archive the same behaviour if the
> refclk in is specified.
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  drivers/net/phy/smsc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index b98a7845681f..67adf11ef958 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -337,7 +337,6 @@ static struct phy_driver smsc_phy_driver[] = {
>  	.name		= "SMSC LAN8710/LAN8720",
>  
>  	/* PHY_BASIC_FEATURES */
> -	.flags		= PHY_RST_AFTER_CLK_EN,
>  
>  	.probe		= smsc_phy_probe,

Hi Marco

There are two PHYs using PHY_RST_AFTER_CLK_EN. What about the other
one?

	Andrew
