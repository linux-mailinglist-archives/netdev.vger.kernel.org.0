Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D126E3AEB36
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 16:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhFUO3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 10:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhFUO3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 10:29:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65925C061574;
        Mon, 21 Jun 2021 07:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+FLy97mYiZUhpCmnjYrs9sM1itPFoTYvaxLbjIGV0Vo=; b=ra6UFsNTyawCbvwUOQ4AmcVjY
        ZUEnTXHRmXzkEE3aIfpcLE3COwLKLFVy2ZBqsybs9U7dwlMCYflbJgWW/jdbfGAnL8sY0b7mXq3MZ
        +GBGwc8815KLbSQP17ex7rB5Fm/Fndju7fS64XbZErWb36BvqDelQtDONcKy2VAK4Gmtw5i0dV8lo
        7IRdiAgloL0DaeTeI3OVatJPcBHqIScdDl+1efRNgJpR4KGtFouyAvjteszHpTs26L0BdgBUGHQZT
        za8H9bdN+7EOovuOrhR3/1xW3Vs5/HFiXHQMl12MNd34Lq61deVnGb2GJzBi34taHIDpdXnjPtDWi
        aLw7i5Yww==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45226)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lvKsh-0004FE-NN; Mon, 21 Jun 2021 15:26:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lvKse-0002xR-Iz; Mon, 21 Jun 2021 15:26:28 +0100
Date:   Mon, 21 Jun 2021 15:26:28 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Simon Horman <simon.horman@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v4 03/10] net: sparx5: add hostmode with phylink
 support
Message-ID: <20210621142628.GM22278@shell.armlinux.org.uk>
References: <20210615085034.1262457-1-steen.hegelund@microchip.com>
 <20210615085034.1262457-4-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615085034.1262457-4-steen.hegelund@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 10:50:27AM +0200, Steen Hegelund wrote:
> This patch adds netdevs and phylink support for the ports in the switch.
> It also adds register based injection and extraction for these ports.
> 
> Frame DMA support for injection and extraction will be added in a later
> series.
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>

Hi,

While looking at this patch, I found sparx5_destroy_netdev() which seems
to be unreferenced - it may be referenced in a future patch. However,
this means that while sparx5_create_port() creates the phylink
structure, there is nothing in this patch that cleans it up.

I'm puzzled by the call to phylink_disconnect_phy() in
sparx5_destroy_netdev() too - surely if we get to the point of tearing
down stuff that we've created at initialisation, the interface had
better be down?

> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
> new file mode 100644
> index 000000000000..c17a3502645a
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
> @@ -0,0 +1,185 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/* Microchip Sparx5 Switch driver
> + *
> + * Copyright (c) 2021 Microchip Technology Inc. and its subsidiaries.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/phylink.h>
> +#include <linux/device.h>
> +#include <linux/netdevice.h>
> +#include <linux/sfp.h>
> +
> +#include "sparx5_main_regs.h"
> +#include "sparx5_main.h"
> +
> +static void sparx5_phylink_validate(struct phylink_config *config,
> +				    unsigned long *supported,
> +				    struct phylink_link_state *state)
> +{
> +	struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	phylink_set(mask, Autoneg);
> +	phylink_set_port_modes(mask);
> +	phylink_set(mask, Pause);
> +	phylink_set(mask, Asym_Pause);
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_5GBASER:
> +	case PHY_INTERFACE_MODE_10GBASER:
> +	case PHY_INTERFACE_MODE_25GBASER:
> +	case PHY_INTERFACE_MODE_NA:
> +		if (port->conf.bandwidth == SPEED_5000)
> +			phylink_set(mask, 5000baseT_Full);
> +		if (port->conf.bandwidth == SPEED_10000) {
> +			phylink_set(mask, 5000baseT_Full);
> +			phylink_set(mask, 10000baseT_Full);
> +			phylink_set(mask, 10000baseCR_Full);
> +			phylink_set(mask, 10000baseSR_Full);
> +			phylink_set(mask, 10000baseLR_Full);
> +			phylink_set(mask, 10000baseLRM_Full);
> +			phylink_set(mask, 10000baseER_Full);
> +		}
> +		if (port->conf.bandwidth == SPEED_25000) {
> +			phylink_set(mask, 5000baseT_Full);
> +			phylink_set(mask, 10000baseT_Full);
> +			phylink_set(mask, 10000baseCR_Full);
> +			phylink_set(mask, 10000baseSR_Full);
> +			phylink_set(mask, 10000baseLR_Full);
> +			phylink_set(mask, 10000baseLRM_Full);
> +			phylink_set(mask, 10000baseER_Full);
> +			phylink_set(mask, 25000baseCR_Full);
> +			phylink_set(mask, 25000baseSR_Full);
> +		}

I really need to fix phylink so we shouldn't be lying about which
speeds are supported over a 10GBASER link... but that's something
for the future.

> +static bool port_conf_has_changed(struct sparx5_port_config *a, struct sparx5_port_config *b)
> +{
> +	if (a->speed != b->speed ||
> +	    a->portmode != b->portmode ||
> +	    a->autoneg != b->autoneg ||
> +	    a->pause != b->pause ||
> +	    a->power_down != b->power_down ||
> +	    a->media != b->media)
> +		return true;
> +	return false;
> +}

Should this be positioned somewhere else rather than in the middle of
the sparx5 phylink functions (top of file maybe?)

> +static void sparx5_phylink_mac_config(struct phylink_config *config,
> +				      unsigned int mode,
> +				      const struct phylink_link_state *state)
> +{
> +	struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
> +
> +	port->conf.autoneg = state->an_enabled;
> +	port->conf.pause = state->pause;

What are you doing with state->pause? It looks to me like you're using
both of these to carry configuration to pcs_config?

Generally, an_enabled can be pulled out of the advertising mask, it
should always reflect ETHTOOL_LINK_MODE_Autoneg_BIT. The "pause"
interpretation of the pause bits here are somewhat hardware specific.
It depends whether the MAC automatically receives state information
from the PCS or not. If the hardware does, then MLO_PAUSE_AN indicates
whether that should be permitted or not.

Otherwise, the advertising mask in pcs_config() indicates which pause
modes should be advertised, and the tx_pause/rx_pause in the
*_link_up() indicates what should actually be set.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
