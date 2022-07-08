Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7473E56C21B
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239886AbiGHVsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 17:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238649AbiGHVsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 17:48:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44120904F8;
        Fri,  8 Jul 2022 14:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Qo27y2OwczVgFAsOrEcozkCpXl4FnjAEl1Br4ebHmCA=; b=sD8FJIdCrkptzT1q6CEd9km9oQ
        AtSbAZMT2uCHaH0P6UgyFP1qDLXT/mVX1vwhlT4Kwus3pCQEU379okFgv6nZ9OPzmzXxjDDohdmuT
        TjZC/s7tXNyE5K/yndPoR+mxuerT1xz+EPvyU1HH5qfUq1Bbc7keFjLPya5VoVdENCXEEaw03GvYM
        wduLtSsb4J2HUPy7DJzCt4SDGKpdX2US9g0VCJsbq2xn5XYB5nM6je1NbLydOzuYBKYweyxdFf6h9
        3U8hgOKnpwPv7ihyrJ5NWeNoqS572Yu/SLubV2q8wkgDsWh3U8ItQo2b/i7VxTh5Z0MQHjScrlPaE
        a8tlvK+w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33258)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o9vq7-0005ba-1K; Fri, 08 Jul 2022 22:48:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o9vq4-0006XM-8C; Fri, 08 Jul 2022 22:48:40 +0100
Date:   Fri, 8 Jul 2022 22:48:40 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Subject: Re: [PATCH net-next] net: marvell: prestera: add phylink support
Message-ID: <YsimODfLM3mu/KZM@shell.armlinux.org.uk>
References: <20220708170635.13190-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708170635.13190-1-oleksandr.mazur@plvision.eu>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 08:06:34PM +0300, Oleksandr Mazur wrote:
> For SFP port prestera driver will use kernel
> phylink infrastucture to configure port mode based on
> the module that has beed inserted
> 
> Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

First question which applies to everything in this patch is - why make
phylink conditional for this driver?

> +#ifdef CONFIG_PHYLINK
> +static void
> +prestera_port_mac_state_cache_read(struct prestera_port *port,
> +				   struct prestera_port_mac_state *state)
> +{
> +	read_lock(&port->state_mac_lock);
> +	*state = port->state_mac;
> +	read_unlock(&port->state_mac_lock);
> +}
> +
> +static void
> +prestera_port_mac_state_cache_write(struct prestera_port *port,
> +				    struct prestera_port_mac_state *state)
> +{
> +	write_lock(&port->state_mac_lock);
> +	port->state_mac = *state;
> +	write_unlock(&port->state_mac_lock);
> +}
> +
> +static void prestera_mac_pcs_get_state(struct phylink_config *config,
> +				       struct phylink_link_state *state)
> +{
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct prestera_port *port = netdev_priv(ndev);
> +	struct prestera_port_mac_state smac;
> +
> +	prestera_port_mac_state_cache_read(port, &smac);
> +
> +	if (smac.valid) {
> +		state->link = smac.oper;
> +		state->pause = 0;
> +		/* AN is completed, when port is up */
> +		state->an_complete = smac.oper ? port->autoneg : false;
> +		state->speed = smac.speed;
> +		state->duplex = smac.duplex;
>  	} else {
> -		port->cfg_phy.admin = false;
> -		err = prestera_hw_port_phy_mode_set(port, false, port->autoneg,
> -						    port->cfg_phy.mode,
> -						    port->adver_link_modes,
> -						    port->cfg_phy.mdix);
> +		state->link = false;
> +		state->pause = 0;
> +		state->an_complete = false;
> +		state->speed = SPEED_UNKNOWN;
> +		state->duplex = DUPLEX_UNKNOWN;
> +	}
> +}

This function is obsolete, please delete it.

> +
> +static void prestera_mac_config(struct phylink_config *config,
> +				unsigned int an_mode,
> +				const struct phylink_link_state *state)
> +{
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct prestera_port *port = netdev_priv(ndev);
> +	struct prestera_port_mac_config cfg_mac;
> +
> +	prestera_port_cfg_mac_read(port, &cfg_mac);
> +	cfg_mac.admin = true;
> +	cfg_mac.mode = PRESTERA_MAC_MODE_MAX;
> +	cfg_mac.inband = false;
> +	cfg_mac.speed = 0;
> +	cfg_mac.duplex = DUPLEX_UNKNOWN;
> +	cfg_mac.fec = PRESTERA_PORT_FEC_OFF;
> +
> +	/* See sfp_select_interface... fIt */
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_10GBASER:
> +		cfg_mac.mode = PRESTERA_MAC_MODE_SR_LR;
> +		cfg_mac.speed = SPEED_10000;
> +		if (state->speed == SPEED_1000) {
> +			cfg_mac.mode = PRESTERA_MAC_MODE_1000BASE_X;
> +		} else if (state->speed == SPEED_2500) {
> +			cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;
> +			cfg_mac.inband = true;
> +			cfg_mac.speed = SPEED_2500;
> +			cfg_mac.duplex = DUPLEX_FULL;
> +		}

No no no no no no no. state->speed is _not_ defined here, as is stated
in the documentation. You can not test it here; the results are
meaningless. Also this looks really odd. If the interface is
10000base-R, then why are you switching the MAC mode to 1000base-X
or SGMII?

> +		break;
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +	case PHY_INTERFACE_MODE_SGMII:
> +		/* But it seems to be not supported in HW */
> +		cfg_mac.mode = PRESTERA_MAC_MODE_SGMII;

SGMII mode for 2500base-X ?

> +		cfg_mac.inband = true;
> +		cfg_mac.speed = SPEED_2500;
> +		cfg_mac.duplex = DUPLEX_FULL;
> +		break;
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		cfg_mac.mode = PRESTERA_MAC_MODE_1000BASE_X;
> +		cfg_mac.inband = state->an_enabled;
> +		cfg_mac.speed = SPEED_1000;
> +		cfg_mac.duplex = DUPLEX_UNKNOWN;
> +		break;
> +	default:
> +		cfg_mac.mode = PRESTERA_MAC_MODE_1000BASE_X;
> +	}
> +
> +	prestera_port_cfg_mac_write(port, &cfg_mac);
> +}
> +
> +int prestera_mac_finish(struct phylink_config *config, unsigned int mode,
> +			phy_interface_t iface)
> +{
> +	return 0;
> +}

No need to implement this if its doing nothing.

> +
> +static void prestera_mac_an_restart(struct phylink_config *config)
> +{
> +	/* No need to restart autoneg as it is always with the same parameters,
> +	 * because e.g. as for 1000baseX FC isn't supported. And for 1000baseT
> +	 * autoneg provided by external tranciever
> +	 */
> +}

This function is obsolete, please delete it.

> +
> +static void prestera_mac_link_down(struct phylink_config *config,
> +				   unsigned int mode, phy_interface_t interface)
> +{
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct prestera_port *port = netdev_priv(ndev);
> +	struct prestera_port_mac_state state_mac;
> +
> +	/* Invalidate. Parameters will update on next link event. */
> +	memset(&state_mac, 0, sizeof(state_mac));
> +	state_mac.valid = false;
> +	prestera_port_mac_state_cache_write(port, &state_mac);
> +}
> +
> +static void prestera_mac_link_up(struct phylink_config *config,
> +				 struct phy_device *phy,
> +				 unsigned int mode, phy_interface_t interface,
> +				 int speed, int duplex,
> +				 bool tx_pause, bool rx_pause)
> +{

This is the place that you get to learn about the link speed etc.

> +}
> +
> +static struct phylink_pcs *prestera_mac_select_pcs(struct phylink_config *config,
> +						   phy_interface_t interface)
> +{
> +	struct net_device *dev = to_net_dev(config->dev);
> +	struct prestera_port *port = netdev_priv(dev);
> +
> +	return &port->phylink_pcs;
> +}
> +
> +static void prestera_pcs_get_state(struct phylink_pcs *pcs,
> +				   struct phylink_link_state *state)
> +{
> +	struct prestera_port *port = container_of(pcs, struct prestera_port,
> +						  phylink_pcs);
> +	struct prestera_port_mac_state smac;
> +
> +	prestera_port_mac_state_cache_read(port, &smac);
> +
> +	if (smac.valid) {
> +		state->link = smac.oper;
> +		state->pause = 0;
> +		/* AN is completed, when port is up */
> +		state->an_complete = smac.oper ? port->autoneg : false;
> +		state->speed = smac.speed;
> +		state->duplex = smac.duplex;
> +	} else {
> +		state->link = false;

This isn't a boolean, it's a 1-bit field, so "state->link = 0;" is
appropriate here.

> +		state->pause = 0;

This will be set by phylink appropriately, there's no need to set
it if there is no link.

> +		state->an_complete = false;

an_complete is a 1-bit field as well, and is set to 0.

> +		state->speed = SPEED_UNKNOWN;
> +		state->duplex = DUPLEX_UNKNOWN;

These will be set to UNKNOWN if AN is disabled, otherwise to the
configured speed. There's no need to set these.

> +	}
> +}
> +
> +static int prestera_pcs_config(struct phylink_pcs *pcs,
> +			       unsigned int mode,
> +			       phy_interface_t interface,
> +			       const unsigned long *advertising,
> +			       bool permit_pause_to_mac)
> +{
> +	return 0;
> +}
> +
> +void prestera_pcs_an_restart(struct phylink_pcs *pcs)
> +{
> +}
> +
> +static const struct phylink_mac_ops prestera_mac_ops = {
> +	.validate = phylink_generic_validate,
> +	.mac_select_pcs = prestera_mac_select_pcs,
> +	.mac_pcs_get_state = prestera_mac_pcs_get_state,

Obsolete method.

> +	.mac_config = prestera_mac_config,
> +	.mac_finish = prestera_mac_finish,
> +	.mac_an_restart = prestera_mac_an_restart,

Obsolete method.

> +	.mac_link_down = prestera_mac_link_down,
> +	.mac_link_up = prestera_mac_link_up,
> +};

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
