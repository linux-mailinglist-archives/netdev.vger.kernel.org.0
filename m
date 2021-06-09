Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD163A20AE
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhFIX0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:26:30 -0400
Received: from mga12.intel.com ([192.55.52.136]:55247 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhFIX03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 19:26:29 -0400
IronPort-SDR: 6HpdVh9E5ZKVALH12gUQGOdstkZmMLyigxK6o3SlzpbmrRZzg5Vc1qxizuOzua5ygms4xH0dsH
 wCpPUYOa8lBQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="184881136"
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="184881136"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 16:24:31 -0700
IronPort-SDR: Xlgi0XtmMkUsNi8AukI0Cf34BXKT0Q7BtrB8dza4cBG7E+W22tlB3k9D1iYxi0xsQ35VL30uCH
 eRvCXnEYDuPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="470034494"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jun 2021 16:24:31 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 3E2305802A4;
        Wed,  9 Jun 2021 16:24:27 -0700 (PDT)
Date:   Thu, 10 Jun 2021 07:24:24 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 03/13] net: stmmac: reduce indentation when
 calling stmmac_xpcs_setup
Message-ID: <20210609232424.GB8706@linux.intel.com>
References: <20210609184155.921662-1-olteanv@gmail.com>
 <20210609184155.921662-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609184155.921662-4-olteanv@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 09:41:45PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There is no reason to embed an if within an if, we can just logically
> AND the two conditions.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 1c881ec8cd04..372673f9af30 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -7002,12 +7002,10 @@ int stmmac_dvr_probe(struct device *device,
>  	if (priv->plat->speed_mode_2500)
>  		priv->plat->speed_mode_2500(ndev, priv->plat->bsp_priv);
>  
> -	if (priv->plat->mdio_bus_data) {
> -		if (priv->plat->mdio_bus_data->has_xpcs) {
> -			ret = stmmac_xpcs_setup(priv->mii);
> -			if (ret)
> -				goto error_xpcs_setup;
> -		}
> +	if (priv->plat->mdio_bus_data && priv->plat->mdio_bus_data->has_xpcs) {
> +		ret = stmmac_xpcs_setup(priv->mii);
> +		if (ret)
> +			goto error_xpcs_setup;
>  	}
>  
>  	ret = stmmac_phy_setup(priv);
> -- 
> 2.25.1
> 
