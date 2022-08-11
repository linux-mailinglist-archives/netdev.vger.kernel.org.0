Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F4B59008E
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbiHKPou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235890AbiHKPo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:44:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9897B97D74;
        Thu, 11 Aug 2022 08:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=c9jy1FRoWDsKM8RjpmwsY2VJ+BYnw6ep0EpYoANfAJw=; b=YBAcWpulO9c6x5CEL4s3LeKI9Y
        IJdtgdOtg//j6T7rZSL8tkHXqdwcMu4HkYZvzhgFLNKO3iXsD3RSg3eRmlc3omGnkWLNbuaSfKg+A
        rjx55IsQtJGh+O6MBNYVoPB9zxsT/7lDEmPwD5XvvbRi+4QD/m10FST1LL3BC17EMBMm4Hy4gb7CF
        TSTltq4kHj7qCtUKJ2XRyVHEZb3ng9MWMsL5ityCzIPROMEmZnDjAK7MrF3WA67nmWKWMbDItGZtr
        XliOd0oAxdljJdEt81w+04vbnMrSjOlDsqKYEyK9eUQjUPlqHjtdHDAXsu1Z9tgR9rb8tRaoG1Hkt
        pe7ul6UQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33750)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oMAGf-0007v3-E9; Thu, 11 Aug 2022 16:38:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oMAGV-0008VW-Gp; Thu, 11 Aug 2022 16:38:31 +0100
Date:   Thu, 11 Aug 2022 16:38:31 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>, olteanv@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Jose.Abreu@synopsys.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 028/105] net: make xpcs_do_config to accept
 advertising for pcs-xpcs and sja1105
Message-ID: <YvUid/JRA4s/S9Cr@shell.armlinux.org.uk>
References: <20220811152851.1520029-1-sashal@kernel.org>
 <20220811152851.1520029-28-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811152851.1520029-28-sashal@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Why are the stable kernels picking up this development commit? I don't
see you picking up the commits that actually make use of this new
parameter.

Maybe stable folk can tell me which of the rules listed in
Documentation/process/stable-kernel-rules.rst that this patch conforms
with that makes it eligable for stable kernels. Thanks.

Russell.

On Thu, Aug 11, 2022 at 11:27:12AM -0400, Sasha Levin wrote:
> From: Ong Boon Leong <boon.leong.ong@intel.com>
> 
> [ Upstream commit fa9c562f9735d24c3253747eb21f3f0c0f6de48e ]
> 
> xpcs_config() has 'advertising' input that is required for C37 1000BASE-X
> AN in later patch series. So, we prepare xpcs_do_config() for it.
> 
> For sja1105, xpcs_do_config() is used for xpcs configuration without
> depending on advertising input, so set to NULL.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
>  drivers/net/pcs/pcs-xpcs.c             | 6 +++---
>  include/linux/pcs/pcs-xpcs.h           | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index 698c7d1fb45c..b03d0d0c3dbf 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -2330,7 +2330,7 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
>  		else
>  			mode = MLO_AN_PHY;
>  
> -		rc = xpcs_do_config(xpcs, priv->phy_mode[i], mode);
> +		rc = xpcs_do_config(xpcs, priv->phy_mode[i], mode, NULL);
>  		if (rc < 0)
>  			goto out;
>  
> diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> index d25fbb9caeba..b17908a0b27c 100644
> --- a/drivers/net/pcs/pcs-xpcs.c
> +++ b/drivers/net/pcs/pcs-xpcs.c
> @@ -795,7 +795,7 @@ static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
>  }
>  
>  int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
> -		   unsigned int mode)
> +		   unsigned int mode, const unsigned long *advertising)
>  {
>  	const struct xpcs_compat *compat;
>  	int ret;
> @@ -843,7 +843,7 @@ static int xpcs_config(struct phylink_pcs *pcs, unsigned int mode,
>  {
>  	struct dw_xpcs *xpcs = phylink_pcs_to_xpcs(pcs);
>  
> -	return xpcs_do_config(xpcs, interface, mode);
> +	return xpcs_do_config(xpcs, interface, mode, advertising);
>  }
>  
>  static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
> @@ -864,7 +864,7 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
>  
>  		state->link = 0;
>  
> -		return xpcs_do_config(xpcs, state->interface, MLO_AN_INBAND);
> +		return xpcs_do_config(xpcs, state->interface, MLO_AN_INBAND, NULL);
>  	}
>  
>  	if (state->an_enabled && xpcs_aneg_done_c73(xpcs, state, compat)) {
> diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
> index 266eb26fb029..37eb97cc2283 100644
> --- a/include/linux/pcs/pcs-xpcs.h
> +++ b/include/linux/pcs/pcs-xpcs.h
> @@ -30,7 +30,7 @@ int xpcs_get_an_mode(struct dw_xpcs *xpcs, phy_interface_t interface);
>  void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
>  		  phy_interface_t interface, int speed, int duplex);
>  int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
> -		   unsigned int mode);
> +		   unsigned int mode, const unsigned long *advertising);
>  void xpcs_get_interfaces(struct dw_xpcs *xpcs, unsigned long *interfaces);
>  int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
>  		    int enable);
> -- 
> 2.35.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
