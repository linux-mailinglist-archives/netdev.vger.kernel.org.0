Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E733A20C4
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhFIXat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:30:49 -0400
Received: from mga05.intel.com ([192.55.52.43]:4795 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhFIXaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 19:30:46 -0400
IronPort-SDR: qNIrkD6Q9HSzoGgDzJPOkLYj5cbnqAuT47YiZrbYIo+Q8z5Ccn/68sZhR2reslir5dgZ1EZdpi
 YGV0NmjhYa+A==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="290822356"
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="290822356"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 16:28:50 -0700
IronPort-SDR: Eq+S4FXQslvh8RwuEX/RoTyAlOVApfsuXAL6VSOxe9M+e4Zh+bhAY+NGgMfSiRQ7F4PRpvcbrL
 +kNPy0ygXaeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="441002693"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 09 Jun 2021 16:28:50 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 688045802A4;
        Wed,  9 Jun 2021 16:28:46 -0700 (PDT)
Date:   Thu, 10 Jun 2021 07:28:43 +0800
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
Subject: Re: [PATCH net-next 02/13] net: stmmac: reverse Christmas tree
 notation in stmmac_xpcs_setup
Message-ID: <20210609232843.GC8706@linux.intel.com>
References: <20210609184155.921662-1-olteanv@gmail.com>
 <20210609184155.921662-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609184155.921662-3-olteanv@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 09:41:44PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Reorder the variable declarations in descending line length order,
> according to the networking coding style.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> index 3b3033b20b1d..a5d150c5f3d8 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> @@ -399,11 +399,11 @@ int stmmac_mdio_reset(struct mii_bus *bus)
>  
>  int stmmac_xpcs_setup(struct mii_bus *bus)
>  {
> -	int mode, addr;
>  	struct net_device *ndev = bus->priv;
> -	struct dw_xpcs *xpcs;
> -	struct stmmac_priv *priv;
>  	struct mdio_device *mdiodev;
> +	struct stmmac_priv *priv;
> +	struct dw_xpcs *xpcs;
> +	int mode, addr;
>  
>  	priv = netdev_priv(ndev);
>  	mode = priv->plat->phy_interface;
> -- 
> 2.25.1
> 
