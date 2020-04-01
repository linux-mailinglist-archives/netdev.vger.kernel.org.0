Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28EA219B49B
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 19:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732307AbgDARSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 13:18:13 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60556 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbgDARSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 13:18:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pO60vM3lpUeaQgdjLjnsu19Yae3+toam0LF12vfn/pQ=; b=NR5IMmGLlT/tSbBz6nUV9G6au
        i0nTRoOb/xOx8pY+vvJT8u0K8H7+mzQOh0hKG4rONPcoT+kgj7AwyR6aqNef24RruNMk974G3ssPa
        qmLYstpsxoUQoBt/2LbuQnUMLKJHGnFmqrrtmHhf5vX8eDvaAXSJTk2hZOIwFStNRS7FTzGlZqgiJ
        o44AejSrhGOGI0WlEvJF6URXMOfnvFt2AM4cMEGLrhtjgpFci+bbfPcbpr0bGB+e8v+f3t2iVx0ts
        aB3SLBgSzdF2hL2MpCI4gyxQroS3IG+RLcIXiIdlf1Y5xqzl5EDsdNwBdScCwSm/gQD4tC9mhhf0g
        C7ON0AG+Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:60904)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jJgzy-000764-ND; Wed, 01 Apr 2020 18:17:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jJgzs-0000s7-1D; Wed, 01 Apr 2020 18:17:48 +0100
Date:   Wed, 1 Apr 2020 18:17:48 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        kernel@pengutronix.de, Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH] net: phy: at803x: fix clock sink configuration on
 ATH8030 and ATH8035
Message-ID: <20200401171747.GW25745@shell.armlinux.org.uk>
References: <20200401095732.23197-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401095732.23197-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 11:57:32AM +0200, Oleksij Rempel wrote:
> The masks in priv->clk_25m_reg and priv->clk_25m_mask are one-bits-set
> for the values that comprise the fields, not zero-bits-set.
> 
> This patch fixes the clock frequency configuration for ATH8030 and
> ATH8035 Atheros PHYs by removing the erroneous "~".
> 
> To reproduce this bug, configure the PHY  with the device tree binding
> "qca,clk-out-frequency" and remove the machine specific PHY fixups.
> 
> Fixes: 2f664823a47021 ("net: phy: at803x: add device tree binding")
> Reported-by: Russell King <linux@armlinux.org.uk>

Please replace this with:

Reported-by: Russell King <rmk+kernel@armlinux.org.uk>

> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
Tested-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> ---
>  drivers/net/phy/at803x.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 481cf48c9b9e4..31f731e6df720 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -425,8 +425,8 @@ static int at803x_parse_dt(struct phy_device *phydev)
>  		 */
>  		if (at803x_match_phy_id(phydev, ATH8030_PHY_ID) ||
>  		    at803x_match_phy_id(phydev, ATH8035_PHY_ID)) {
> -			priv->clk_25m_reg &= ~AT8035_CLK_OUT_MASK;
> -			priv->clk_25m_mask &= ~AT8035_CLK_OUT_MASK;
> +			priv->clk_25m_reg &= AT8035_CLK_OUT_MASK;
> +			priv->clk_25m_mask &= AT8035_CLK_OUT_MASK;
>  		}
>  	}
>  
> -- 
> 2.26.0.rc2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
