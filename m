Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC3F121983
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLPSzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:55:43 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43534 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfLPSzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:55:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=D5nXa1E0/6ZK/Oj+7SvDu7WJ/3H14Kydu6+EOrBcmLU=; b=jp7iN0m7Ga7qfwxE7qJmI8Yjs
        TJxqYe9A5t8mMiVSVdzLlOp71/999ub9/hWuyvCUXL1gxymXebRBtrY/1sN1Tdt+eEcFTu4NaLHaG
        kUiuCEulA2c+CjqEvFw9I5FtZXJmFFdjg0ZJgWjUot+GEg4dN3qcYqfQLVGlu0XpJZndHDUUvhPwi
        yUZcjlGsMumqlTw29B9YYqntoLtncpLJEvVFVZIPNb/D7NooX/CNUf0VhjXU6PcuffgO2oYD4ccZm
        d1q0WGq4IorCy3qzbMfdG/z7nJLOqSE62kFmHPjMr7RHHhCCLZvVKfxufEv7Si+j1x6D8OFk3qp00
        pHzxMncEg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:42230)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1igvWp-00012Y-QC; Mon, 16 Dec 2019 18:55:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1igvWk-0002d1-9B; Mon, 16 Dec 2019 18:55:30 +0000
Date:   Mon, 16 Dec 2019 18:55:30 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, olteanv@gmail.com,
        jakub.kicinski@netronome.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: Make PHYLINK related function static
 again
Message-ID: <20191216185530.GN25745@shell.armlinux.org.uk>
References: <20191216183248.16309-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216183248.16309-1-f.fainelli@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 10:32:47AM -0800, Florian Fainelli wrote:
> Commit 77373d49de22 ("net: dsa: Move the phylink driver calls into
> port.c") moved and exported a bunch of symbols, but they are not used
> outside of net/dsa/port.c at the moment, so no reason to export them.
> 
> Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> ---
>  net/dsa/dsa_priv.h | 16 ----------------
>  net/dsa/port.c     | 38 ++++++++++++++++----------------------
>  2 files changed, 16 insertions(+), 38 deletions(-)
> 
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 2dd86d9bcda9..09ea2fd78c74 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -150,22 +150,6 @@ int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags);
>  int dsa_port_vid_del(struct dsa_port *dp, u16 vid);
>  int dsa_port_link_register_of(struct dsa_port *dp);
>  void dsa_port_link_unregister_of(struct dsa_port *dp);
> -void dsa_port_phylink_validate(struct phylink_config *config,
> -			       unsigned long *supported,
> -			       struct phylink_link_state *state);
> -void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
> -					struct phylink_link_state *state);
> -void dsa_port_phylink_mac_config(struct phylink_config *config,
> -				 unsigned int mode,
> -				 const struct phylink_link_state *state);
> -void dsa_port_phylink_mac_an_restart(struct phylink_config *config);
> -void dsa_port_phylink_mac_link_down(struct phylink_config *config,
> -				    unsigned int mode,
> -				    phy_interface_t interface);
> -void dsa_port_phylink_mac_link_up(struct phylink_config *config,
> -				  unsigned int mode,
> -				  phy_interface_t interface,
> -				  struct phy_device *phydev);
>  extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
>  
>  /* slave.c */
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 46ac9ba21987..ffb5601f7ed6 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -415,9 +415,9 @@ static struct phy_device *dsa_port_get_phy_device(struct dsa_port *dp)
>  	return phydev;
>  }
>  
> -void dsa_port_phylink_validate(struct phylink_config *config,
> -			       unsigned long *supported,
> -			       struct phylink_link_state *state)
> +static void dsa_port_phylink_validate(struct phylink_config *config,
> +				      unsigned long *supported,
> +				      struct phylink_link_state *state)
>  {
>  	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
>  	struct dsa_switch *ds = dp->ds;
> @@ -427,10 +427,9 @@ void dsa_port_phylink_validate(struct phylink_config *config,
>  
>  	ds->ops->phylink_validate(ds, dp->index, supported, state);
>  }
> -EXPORT_SYMBOL_GPL(dsa_port_phylink_validate);
>  
> -void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
> -					struct phylink_link_state *state)
> +static void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
> +					       struct phylink_link_state *state)
>  {
>  	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
>  	struct dsa_switch *ds = dp->ds;
> @@ -444,11 +443,10 @@ void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
>  	if (ds->ops->phylink_mac_link_state(ds, dp->index, state) < 0)
>  		state->link = 0;
>  }
> -EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_pcs_get_state);
>  
> -void dsa_port_phylink_mac_config(struct phylink_config *config,
> -				 unsigned int mode,
> -				 const struct phylink_link_state *state)
> +static void dsa_port_phylink_mac_config(struct phylink_config *config,
> +					unsigned int mode,
> +					const struct phylink_link_state *state)
>  {
>  	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
>  	struct dsa_switch *ds = dp->ds;
> @@ -458,9 +456,8 @@ void dsa_port_phylink_mac_config(struct phylink_config *config,
>  
>  	ds->ops->phylink_mac_config(ds, dp->index, mode, state);
>  }
> -EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_config);
>  
> -void dsa_port_phylink_mac_an_restart(struct phylink_config *config)
> +static void dsa_port_phylink_mac_an_restart(struct phylink_config *config)
>  {
>  	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
>  	struct dsa_switch *ds = dp->ds;
> @@ -470,11 +467,10 @@ void dsa_port_phylink_mac_an_restart(struct phylink_config *config)
>  
>  	ds->ops->phylink_mac_an_restart(ds, dp->index);
>  }
> -EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_an_restart);
>  
> -void dsa_port_phylink_mac_link_down(struct phylink_config *config,
> -				    unsigned int mode,
> -				    phy_interface_t interface)
> +static void dsa_port_phylink_mac_link_down(struct phylink_config *config,
> +					   unsigned int mode,
> +					   phy_interface_t interface)
>  {
>  	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
>  	struct phy_device *phydev = NULL;
> @@ -491,12 +487,11 @@ void dsa_port_phylink_mac_link_down(struct phylink_config *config,
>  
>  	ds->ops->phylink_mac_link_down(ds, dp->index, mode, interface);
>  }
> -EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_link_down);
>  
> -void dsa_port_phylink_mac_link_up(struct phylink_config *config,
> -				  unsigned int mode,
> -				  phy_interface_t interface,
> -				  struct phy_device *phydev)
> +static void dsa_port_phylink_mac_link_up(struct phylink_config *config,
> +					 unsigned int mode,
> +					 phy_interface_t interface,
> +					 struct phy_device *phydev)
>  {
>  	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
>  	struct dsa_switch *ds = dp->ds;
> @@ -509,7 +504,6 @@ void dsa_port_phylink_mac_link_up(struct phylink_config *config,
>  
>  	ds->ops->phylink_mac_link_up(ds, dp->index, mode, interface, phydev);
>  }
> -EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_link_up);
>  
>  const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
>  	.validate = dsa_port_phylink_validate,
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
