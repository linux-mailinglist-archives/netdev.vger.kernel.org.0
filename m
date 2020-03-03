Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD24E1779EF
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgCCPHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:07:44 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47865 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbgCCPHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:07:44 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id AF8AE6000B;
        Tue,  3 Mar 2020 15:07:41 +0000 (UTC)
Date:   Tue, 3 Mar 2020 16:07:41 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: phy: marvell10g: add energy detect
 power down tunable
Message-ID: <20200303150741.GC3179@kwain>
References: <20200303144259.GM25745@shell.armlinux.org.uk>
 <E1j98mA-00057r-U8@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1j98mA-00057r-U8@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, Mar 03, 2020 at 02:44:02PM +0000, Russell King wrote:
>  drivers/net/phy/marvell10g.c | 111 ++++++++++++++++++++++++++++++++++-
>  
> +static int mv3310_maybe_reset(struct phy_device *phydev, u32 unit, bool reset)
> +{
> +	int retries, val, err;
> +
> +	if (!reset)
> +		return 0;

You could also call mv3310_maybe_reset after testing the 'reset'
condition, that would make it easier to read the code.

>  static struct phy_driver mv3310_drivers[] = {
>  	{
>  		.phy_id		= MARVELL_PHY_ID_88X3310,
> @@ -580,13 +684,14 @@ static struct phy_driver mv3310_drivers[] = {
>  		.name		= "mv88x3310",
>  		.get_features	= mv3310_get_features,
>  		.soft_reset	= genphy_no_soft_reset,
> -		.config_init	= mv3310_config_init,

Having a quick look at the code, it seems this is a leftover and you
don't actually want to remove config_init for the 3310.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
