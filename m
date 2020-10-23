Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63B2296C76
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 12:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461872AbgJWKEH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Oct 2020 06:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S461861AbgJWKEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 06:04:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5112FC0613D2
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 03:04:07 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVtvU-00033m-HF; Fri, 23 Oct 2020 12:04:00 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kVtvT-0007We-V1; Fri, 23 Oct 2020 12:03:59 +0200
Date:   Fri, 23 Oct 2020 12:03:59 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v1] net: phy: remove spaces
Message-ID: <20201023100359.35gkxmqet5cm7jlc@pengutronix.de>
References: <20201023095709.6544-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201023095709.6544-1-o.rempel@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:00:57 up 343 days,  1:19, 382 users,  load average: 0.05, 0.03,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the noise, i'll reset v2 with proper commit message.

On Fri, Oct 23, 2020 at 11:57:09AM +0200, Oleksij Rempel wrote:
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/phy-core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 8d333d3084ed..635be83962b6 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -120,10 +120,10 @@ static const struct phy_setting settings[] = {
>  	PHY_SETTING( 100000, FULL, 100000baseDR_Full		),
>  	PHY_SETTING( 100000, FULL, 100000baseSR_Full		),
>  	/* 56G */
> -	PHY_SETTING(  56000, FULL,  56000baseCR4_Full	  	),
> -	PHY_SETTING(  56000, FULL,  56000baseKR4_Full	  	),
> -	PHY_SETTING(  56000, FULL,  56000baseLR4_Full	  	),
> -	PHY_SETTING(  56000, FULL,  56000baseSR4_Full	  	),
> +	PHY_SETTING(  56000, FULL,  56000baseCR4_Full		),
> +	PHY_SETTING(  56000, FULL,  56000baseKR4_Full		),
> +	PHY_SETTING(  56000, FULL,  56000baseLR4_Full		),
> +	PHY_SETTING(  56000, FULL,  56000baseSR4_Full		),
>  	/* 50G */
>  	PHY_SETTING(  50000, FULL,  50000baseCR2_Full		),
>  	PHY_SETTING(  50000, FULL,  50000baseKR2_Full		),
> -- 
> 2.28.0
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
