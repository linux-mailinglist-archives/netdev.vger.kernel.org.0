Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2217D3A4562
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 17:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhFKPcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 11:32:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59458 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231502AbhFKPcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 11:32:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oZMxwc0jXAan6/tK8t4uBz949ykG5b4D8iHZWxs5eQs=; b=ltclcZIij5Xss1EX9OzX7Gvzbe
        a3fKCgtcgUO4LhBEAi2QXsvU3WCBcyGzcQ7J4FyNp89DHf6VLTEp5XINN1OAtflG/2+PwRHsl6oms
        604lwSLzm/TFP1bWV0FGKn4EBJa6Q7/L4lvQFIhhJAjrEkzdqy3mpeHzyVCBUFVKvCiE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrj6t-008sC4-Kl; Fri, 11 Jun 2021 17:30:15 +0200
Date:   Fri, 11 Jun 2021 17:30:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com,
        Wenpeng Liang <liangwenpeng@huawei.com>
Subject: Re: [PATCH net-next 5/8] net: phy: fixed space alignment issues
Message-ID: <YMOBh/lpHCSMsTPt@lunn.ch>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-6-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623393419-2521-6-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  (MII_DM9161_INTR_DPLX_MASK | MII_DM9161_INTR_SPD_MASK \
> - | MII_DM9161_INTR_LINK_MASK | MII_DM9161_INTR_MASK)
> +	| MII_DM9161_INTR_LINK_MASK | MII_DM9161_INTR_MASK)

The convention is to put the | at the end of the line. So

  (MII_DM9161_INTR_DPLX_MASK | MII_DM9161_INTR_SPD_MASK | \
   MII_DM9161_INTR_LINK_MASK | MII_DM9161_INTR_MASK)


>  #define MII_DM9161_INTR_CHANGE	\
>  	(MII_DM9161_INTR_DPLX_CHANGE | \
>  	 MII_DM9161_INTR_SPD_CHANGE | \
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 2870c33..c8d8ef8 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -84,98 +84,98 @@ EXPORT_SYMBOL_GPL(phy_duplex_to_str);


>  
>  static const struct phy_setting settings[] = {
>  	/* 400G */
> -	PHY_SETTING( 400000, FULL, 400000baseCR8_Full		),
> -	PHY_SETTING( 400000, FULL, 400000baseKR8_Full		),
> -	PHY_SETTING( 400000, FULL, 400000baseLR8_ER8_FR8_Full	),
> -	PHY_SETTING( 400000, FULL, 400000baseDR8_Full		),
> -	PHY_SETTING( 400000, FULL, 400000baseSR8_Full		),
> -	PHY_SETTING( 400000, FULL, 400000baseCR4_Full		),
> -	PHY_SETTING( 400000, FULL, 400000baseKR4_Full		),
> -	PHY_SETTING( 400000, FULL, 400000baseLR4_ER4_FR4_Full	),
> -	PHY_SETTING( 400000, FULL, 400000baseDR4_Full		),
> -	PHY_SETTING( 400000, FULL, 400000baseSR4_Full		),
> +	PHY_SETTING(400000, FULL, 400000baseCR8_Full),
> +	PHY_SETTING(400000, FULL, 400000baseKR8_Full),
> +	PHY_SETTING(400000, FULL, 400000baseLR8_ER8_FR8_Full),
> +	PHY_SETTING(400000, FULL, 400000baseDR8_Full),
> +	PHY_SETTING(400000, FULL, 400000baseSR8_Full),
> +	PHY_SETTING(400000, FULL, 400000baseCR4_Full),
> +	PHY_SETTING(400000, FULL, 400000baseKR4_Full),
> +	PHY_SETTING(400000, FULL, 400000baseLR4_ER4_FR4_Full),
> +	PHY_SETTING(400000, FULL, 400000baseDR4_Full),
> +	PHY_SETTING(400000, FULL, 400000baseSR4_Full),
>  	/* 200G */
> -	PHY_SETTING( 200000, FULL, 200000baseCR4_Full		),
> -	PHY_SETTING( 200000, FULL, 200000baseKR4_Full		),
> -	PHY_SETTING( 200000, FULL, 200000baseLR4_ER4_FR4_Full	),
> -	PHY_SETTING( 200000, FULL, 200000baseDR4_Full		),
> -	PHY_SETTING( 200000, FULL, 200000baseSR4_Full		),
> -	PHY_SETTING( 200000, FULL, 200000baseCR2_Full		),
> -	PHY_SETTING( 200000, FULL, 200000baseKR2_Full		),
> -	PHY_SETTING( 200000, FULL, 200000baseLR2_ER2_FR2_Full	),
> -	PHY_SETTING( 200000, FULL, 200000baseDR2_Full		),
> -	PHY_SETTING( 200000, FULL, 200000baseSR2_Full		),
> +	PHY_SETTING(200000, FULL, 200000baseCR4_Full),
> +	PHY_SETTING(200000, FULL, 200000baseKR4_Full),
> +	PHY_SETTING(200000, FULL, 200000baseLR4_ER4_FR4_Full),
> +	PHY_SETTING(200000, FULL, 200000baseDR4_Full),
> +	PHY_SETTING(200000, FULL, 200000baseSR4_Full),
> +	PHY_SETTING(200000, FULL, 200000baseCR2_Full),
> +	PHY_SETTING(200000, FULL, 200000baseKR2_Full),
> +	PHY_SETTING(200000, FULL, 200000baseLR2_ER2_FR2_Full),
> +	PHY_SETTING(200000, FULL, 200000baseDR2_Full),
> +	PHY_SETTING(200000, FULL, 200000baseSR2_Full),
>  	/* 100G */
> -	PHY_SETTING( 100000, FULL, 100000baseCR4_Full		),
> -	PHY_SETTING( 100000, FULL, 100000baseKR4_Full		),
> -	PHY_SETTING( 100000, FULL, 100000baseLR4_ER4_Full	),
> -	PHY_SETTING( 100000, FULL, 100000baseSR4_Full		),
> -	PHY_SETTING( 100000, FULL, 100000baseCR2_Full		),
> -	PHY_SETTING( 100000, FULL, 100000baseKR2_Full		),
> -	PHY_SETTING( 100000, FULL, 100000baseLR2_ER2_FR2_Full	),
> -	PHY_SETTING( 100000, FULL, 100000baseDR2_Full		),
> -	PHY_SETTING( 100000, FULL, 100000baseSR2_Full		),
> -	PHY_SETTING( 100000, FULL, 100000baseCR_Full		),
> -	PHY_SETTING( 100000, FULL, 100000baseKR_Full		),
> -	PHY_SETTING( 100000, FULL, 100000baseLR_ER_FR_Full	),
> -	PHY_SETTING( 100000, FULL, 100000baseDR_Full		),
> -	PHY_SETTING( 100000, FULL, 100000baseSR_Full		),
> +	PHY_SETTING(100000, FULL, 100000baseCR4_Full),
> +	PHY_SETTING(100000, FULL, 100000baseKR4_Full),
> +	PHY_SETTING(100000, FULL, 100000baseLR4_ER4_Full),
> +	PHY_SETTING(100000, FULL, 100000baseSR4_Full),
> +	PHY_SETTING(100000, FULL, 100000baseCR2_Full),
> +	PHY_SETTING(100000, FULL, 100000baseKR2_Full),
> +	PHY_SETTING(100000, FULL, 100000baseLR2_ER2_FR2_Full),
> +	PHY_SETTING(100000, FULL, 100000baseDR2_Full),
> +	PHY_SETTING(100000, FULL, 100000baseSR2_Full),
> +	PHY_SETTING(100000, FULL, 100000baseCR_Full),
> +	PHY_SETTING(100000, FULL, 100000baseKR_Full),
> +	PHY_SETTING(100000, FULL, 100000baseLR_ER_FR_Full),
> +	PHY_SETTING(100000, FULL, 100000baseDR_Full),
> +	PHY_SETTING(100000, FULL, 100000baseSR_Full),
>  	/* 56G */
> -	PHY_SETTING(  56000, FULL,  56000baseCR4_Full	  	),
> -	PHY_SETTING(  56000, FULL,  56000baseKR4_Full	  	),
> -	PHY_SETTING(  56000, FULL,  56000baseLR4_Full	  	),
> -	PHY_SETTING(  56000, FULL,  56000baseSR4_Full	  	),
> +	PHY_SETTING(56000, FULL, 56000baseCR4_Full),
> +	PHY_SETTING(56000, FULL, 56000baseKR4_Full),
> +	PHY_SETTING(56000, FULL, 56000baseLR4_Full),
> +	PHY_SETTING(56000, FULL, 56000baseSR4_Full),
>  	/* 50G */
> -	PHY_SETTING(  50000, FULL,  50000baseCR2_Full		),
> -	PHY_SETTING(  50000, FULL,  50000baseKR2_Full		),
> -	PHY_SETTING(  50000, FULL,  50000baseSR2_Full		),
> -	PHY_SETTING(  50000, FULL,  50000baseCR_Full		),
> -	PHY_SETTING(  50000, FULL,  50000baseKR_Full		),
> -	PHY_SETTING(  50000, FULL,  50000baseLR_ER_FR_Full	),
> -	PHY_SETTING(  50000, FULL,  50000baseDR_Full		),
> -	PHY_SETTING(  50000, FULL,  50000baseSR_Full		),
> +	PHY_SETTING(50000, FULL, 50000baseCR2_Full),
> +	PHY_SETTING(50000, FULL, 50000baseKR2_Full),
> +	PHY_SETTING(50000, FULL, 50000baseSR2_Full),
> +	PHY_SETTING(50000, FULL, 50000baseCR_Full),
> +	PHY_SETTING(50000, FULL, 50000baseKR_Full),
> +	PHY_SETTING(50000, FULL, 50000baseLR_ER_FR_Full),
> +	PHY_SETTING(50000, FULL, 50000baseDR_Full),
> +	PHY_SETTING(50000, FULL, 50000baseSR_Full),
>  	/* 40G */
> -	PHY_SETTING(  40000, FULL,  40000baseCR4_Full		),
> -	PHY_SETTING(  40000, FULL,  40000baseKR4_Full		),
> -	PHY_SETTING(  40000, FULL,  40000baseLR4_Full		),
> -	PHY_SETTING(  40000, FULL,  40000baseSR4_Full		),
> +	PHY_SETTING(40000, FULL, 40000baseCR4_Full),
> +	PHY_SETTING(40000, FULL, 40000baseKR4_Full),
> +	PHY_SETTING(40000, FULL, 40000baseLR4_Full),
> +	PHY_SETTING(40000, FULL, 40000baseSR4_Full),
>  	/* 25G */
> -	PHY_SETTING(  25000, FULL,  25000baseCR_Full		),
> -	PHY_SETTING(  25000, FULL,  25000baseKR_Full		),
> -	PHY_SETTING(  25000, FULL,  25000baseSR_Full		),
> +	PHY_SETTING(25000, FULL, 25000baseCR_Full),
> +	PHY_SETTING(25000, FULL, 25000baseKR_Full),
> +	PHY_SETTING(25000, FULL, 25000baseSR_Full),
>  	/* 20G */
> -	PHY_SETTING(  20000, FULL,  20000baseKR2_Full		),
> -	PHY_SETTING(  20000, FULL,  20000baseMLD2_Full		),
> +	PHY_SETTING(20000, FULL, 20000baseKR2_Full),
> +	PHY_SETTING(20000, FULL, 20000baseMLD2_Full),
>  	/* 10G */
> -	PHY_SETTING(  10000, FULL,  10000baseCR_Full		),
> -	PHY_SETTING(  10000, FULL,  10000baseER_Full		),
> -	PHY_SETTING(  10000, FULL,  10000baseKR_Full		),
> -	PHY_SETTING(  10000, FULL,  10000baseKX4_Full		),
> -	PHY_SETTING(  10000, FULL,  10000baseLR_Full		),
> -	PHY_SETTING(  10000, FULL,  10000baseLRM_Full		),
> -	PHY_SETTING(  10000, FULL,  10000baseR_FEC		),
> -	PHY_SETTING(  10000, FULL,  10000baseSR_Full		),
> -	PHY_SETTING(  10000, FULL,  10000baseT_Full		),
> +	PHY_SETTING(10000, FULL, 10000baseCR_Full),
> +	PHY_SETTING(10000, FULL, 10000baseER_Full),
> +	PHY_SETTING(10000, FULL, 10000baseKR_Full),
> +	PHY_SETTING(10000, FULL, 10000baseKX4_Full),
> +	PHY_SETTING(10000, FULL, 10000baseLR_Full),
> +	PHY_SETTING(10000, FULL, 10000baseLRM_Full),
> +	PHY_SETTING(10000, FULL, 10000baseR_FEC),
> +	PHY_SETTING(10000, FULL, 10000baseSR_Full),
> +	PHY_SETTING(10000, FULL, 10000baseT_Full),
>  	/* 5G */
> -	PHY_SETTING(   5000, FULL,   5000baseT_Full		),
> +	PHY_SETTING(5000, FULL, 5000baseT_Full),
>  	/* 2.5G */
> -	PHY_SETTING(   2500, FULL,   2500baseT_Full		),
> -	PHY_SETTING(   2500, FULL,   2500baseX_Full		),
> +	PHY_SETTING(2500, FULL, 2500baseT_Full),
> +	PHY_SETTING(2500, FULL, 2500baseX_Full),
>  	/* 1G */
> -	PHY_SETTING(   1000, FULL,   1000baseKX_Full		),
> -	PHY_SETTING(   1000, FULL,   1000baseT_Full		),
> -	PHY_SETTING(   1000, HALF,   1000baseT_Half		),
> -	PHY_SETTING(   1000, FULL,   1000baseT1_Full		),
> -	PHY_SETTING(   1000, FULL,   1000baseX_Full		),
> +	PHY_SETTING(1000, FULL, 1000baseKX_Full),
> +	PHY_SETTING(1000, FULL, 1000baseT_Full),
> +	PHY_SETTING(1000, HALF, 1000baseT_Half),
> +	PHY_SETTING(1000, FULL, 1000baseT1_Full),
> +	PHY_SETTING(1000, FULL, 1000baseX_Full),
>  	/* 100M */
> -	PHY_SETTING(    100, FULL,    100baseT_Full		),
> -	PHY_SETTING(    100, FULL,    100baseT1_Full		),
> -	PHY_SETTING(    100, HALF,    100baseT_Half		),
> -	PHY_SETTING(    100, HALF,    100baseFX_Half		),
> -	PHY_SETTING(    100, FULL,    100baseFX_Full		),
> +	PHY_SETTING(100, FULL, 100baseT_Full),
> +	PHY_SETTING(100, FULL, 100baseT1_Full),
> +	PHY_SETTING(100, HALF, 100baseT_Half),
> +	PHY_SETTING(100, HALF, 100baseFX_Half),
> +	PHY_SETTING(100, FULL, 100baseFX_Full),
>  	/* 10M */
> -	PHY_SETTING(     10, FULL,     10baseT_Full		),
> -	PHY_SETTING(     10, HALF,     10baseT_Half		),
> +	PHY_SETTING(10, FULL, 10baseT_Full),
> +	PHY_SETTING(10, HALF, 10baseT_Half),

Please do not change this. It is a deliberate design decision to add
these spaces here.

      Andrew
