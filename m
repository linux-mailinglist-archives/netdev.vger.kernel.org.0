Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0503B1B5CB0
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 15:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgDWNh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 09:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726224AbgDWNhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 09:37:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8C7C08E934
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 06:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WORkHuIcTQYBYtRwNiuWR70OyEKMd/LAzk7uaajjPDw=; b=VlFworbwlhLRYbC+FAlfwsp4L
        fAYgEOEkrYj4TLsNdcDTVINDtSh2vjmqig4h8qAS3QFjpkdZ8KSNBIoNlKTuy/UfvNG7zAoUjmr1t
        0nd3dKhTKoSJSPDgvfP/ew34rCw0hmasRGmbm3OJLsHFCiAvGw+SziYv2KY3yhhL/w98aGg+vn/US
        BNunzit7coWIeACCil0lUNCRfHuDZ/RZQyppGeuFjHZRG73Mc011Hp5JfzrjPfAgN9pt1CMW5RN/C
        BOuEYZEdmNE8EYhxHbVPmqoC+cbWx8r8U+ZiD9GKHx4PMor13sASod9ViDME9ojUmokImgiFRBHqq
        sI95WByUg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50116)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jRc30-0006YO-NE; Thu, 23 Apr 2020 14:37:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jRc2y-0000jb-7L; Thu, 23 Apr 2020 14:37:44 +0100
Date:   Thu, 23 Apr 2020 14:37:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH net v3 1/2] net: phy: marvell10g: disable temperature
 sensor on 2110
Message-ID: <20200423133744.GR25745@shell.armlinux.org.uk>
References: <99771ceabb63b6a6a7d112197f639084f11e4aa4.1587618482.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99771ceabb63b6a6a7d112197f639084f11e4aa4.1587618482.git.baruch@tkos.co.il>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 08:08:01AM +0300, Baruch Siach wrote:
> The 88E2110 temperature sensor is in a different location than 88X3310,
> and it has no enable/disable option.
> 
> Fixes: 62d01535474b61 ("net: phy: marvell10g: add support for the 88x2110 PHY")
> Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---

Shouldn't this series have a covering message?

In any case:

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

> v3: No change
> 
> v2: No change
> ---
>  drivers/net/phy/marvell10g.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index 95e3f4644aeb..69530a84450f 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -169,6 +169,9 @@ static int mv3310_hwmon_config(struct phy_device *phydev, bool enable)
>  	u16 val;
>  	int ret;
>  
> +	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)
> +		return 0;
> +
>  	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP,
>  			    MV_V2_TEMP_UNKNOWN);
>  	if (ret < 0)
> @@ -193,6 +196,9 @@ static int mv3310_hwmon_probe(struct phy_device *phydev)
>  	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
>  	int i, j, ret;
>  
> +	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)
> +		return 0;
> +
>  	priv->hwmon_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
>  	if (!priv->hwmon_name)
>  		return -ENODEV;
> -- 
> 2.26.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
