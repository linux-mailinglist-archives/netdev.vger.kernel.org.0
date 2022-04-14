Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F02500E14
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243602AbiDNMv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243600AbiDNMvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:51:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0C9F1A;
        Thu, 14 Apr 2022 05:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zZwQuxnMgCZNediijEyYQkwJHjFub/8sm9BuaSGMJOE=; b=oyIlAJZqcvdTWOLga7GM8LecyS
        oTJeMXrlROnC3xAMJe9m6th4+lQ73TWD2M0GcZiqgvfWow51fbs41kaT8LNgfIs/F5G5M0OnW/eis
        r6c4jDWamm4BCh/y+MuAgaxv8M0Kdlh1YIe10mZ5EhG1MRKWRVptWXjM3EEe+T0YnINQD7ClVdn86
        OCr3YmAHGTRn+oQC/1ICmuPgYOJ1JYzct5BnBZ0KEj+BhX3OKT7zAUAOrPgk+5wwsgq85J2KVpGye
        E/7+jU1NyE9r1YqfyFhwPPAv/mcVL7o6m5m/iR22J3DX81BX2lZGBEh6ZV2qQ2XQPwnff2GrWQL0n
        tihW+1RQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58260)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1neyuN-0004Yi-Ha; Thu, 14 Apr 2022 13:49:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1neyuK-0004K1-RO; Thu, 14 Apr 2022 13:49:08 +0100
Date:   Thu, 14 Apr 2022 13:49:08 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 04/12] net: pcs: add Renesas MII converter driver
Message-ID: <YlgYRGVuHQCwp7FQ@shell.armlinux.org.uk>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-5-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414122250.158113-5-clement.leger@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 02:22:42PM +0200, Clément Léger wrote:
> Add PCS driver for the MII converter that is present on Renesas RZ/N1
> SoC. This MII converter is reponsible of converting MII to RMII/RGMII
> or act as a MII passtrough. Exposing it as a PCS allows to reuse it
> in both the switch driver and the stmmac driver. Currently, this driver
> only allows the PCS to be used by the dual Cortex-A7 subsystem since
> the register locking system is not used.

Hi,

> +#define MIIC_CONVCTRL_CONV_MODE		GENMASK(4, 0)
> +#define CONV_MODE_MII			0
> +#define CONV_MODE_RMII			BIT(2)
> +#define CONV_MODE_RGMII			BIT(3)
> +#define CONV_MODE_10MBPS		0
> +#define CONV_MODE_100MBPS		BIT(0)
> +#define CONV_MODE_1000MBPS		BIT(1)

Is this really a single 4-bit wide field? It looks like two 2-bit fields
to me.

> +#define phylink_pcs_to_miic_port(pcs) container_of((pcs), struct miic_port, pcs)

I prefer a helper function to a preprocessor macro for that, but I'm not
going to insist on that point.

> +static void miic_link_up(struct phylink_pcs *pcs, unsigned int mode,
> +			 phy_interface_t interface, int speed, int duplex)
> +{
> +	struct miic_port *miic_port = phylink_pcs_to_miic_port(pcs);
> +	struct miic *miic = miic_port->miic;
> +	int port = miic_port->port;
> +	u32 val = 0;
> +
> +	if (duplex == DUPLEX_FULL)
> +		val |= MIIC_CONVCTRL_FULLD;
> +
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_RMII:
> +		val |= CONV_MODE_RMII;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII:
> +		val |= CONV_MODE_RGMII;
> +		break;
> +	case PHY_INTERFACE_MODE_MII:
> +		val |= CONV_MODE_MII;
> +		break;
> +	default:
> +		dev_err(miic->dev, "Unsupported interface %s\n",
> +			phy_modes(interface));
> +		return;
> +	}

Why are you re-decoding the interface mode? The interface mode won't
change as a result of a call to link-up. Changing the interface mode
is a major configuration event that will always see a call to your
miic_config() function first.

> +
> +	/* No speed in MII through-mode */
> +	if (interface != PHY_INTERFACE_MODE_MII) {
> +		switch (speed) {
> +		case SPEED_1000:
> +			val |= CONV_MODE_1000MBPS;
> +			break;
> +		case SPEED_100:
> +			val |= CONV_MODE_100MBPS;
> +			break;
> +		case SPEED_10:
> +			val |= CONV_MODE_10MBPS;
> +			break;
> +		case SPEED_UNKNOWN:
> +			pr_err("Invalid speed\n");
> +			/* Silently don't do anything */
> +			return;

You shouldn't need to consider SPEED_UNKNOWN - if that's something we
really want to print a warning for, that should be done by phylink and
not by drivers.

> +		default:
> +			dev_err(miic->dev, "Invalid PCS speed %d\n", speed);
> +			return;
> +		}
> +	}
> +
> +	miic_reg_rmw(miic, MIIC_CONVCTRL(port),
> +		     (MIIC_CONVCTRL_CONV_MODE | MIIC_CONVCTRL_FULLD), val);
> +}
> +
> +static bool miic_mode_supported(phy_interface_t interface)
> +{
> +	return (interface == PHY_INTERFACE_MODE_RGMII ||
> +		interface == PHY_INTERFACE_MODE_RMII ||
> +		interface == PHY_INTERFACE_MODE_MII);
> +}
> +
> +static int miic_validate(struct phylink_pcs *pcs, unsigned long *supported,
> +			 const struct phylink_link_state *state)
> +{
> +	struct miic_port *miic_port = phylink_pcs_to_miic_port(pcs);
> +	struct miic *miic = miic_port->miic;
> +
> +	if (state->interface != PHY_INTERFACE_MODE_NA &&

PHY_INTERFACE_MODE_NA is no longer a "thing" with phylink with PCS
support, you no longer need to test for it.

> +	    !miic_mode_supported(state->interface)) {
> +		dev_err(miic->dev, "phy mode %s is unsupported on port %d\n",
> +			phy_modes(state->interface), miic_port->port);

Please don't print an error if the interface mode is not supported.

> +		linkmode_zero(supported);

There is no need to zero the support mask if you return an error.

> +		return -EOPNOTSUPP;

From the method documentation:

 * Returns -EINVAL if the interface mode/autoneg mode is not supported.
 * Returns non-zero positive if the link state can be supported.

Also, really, the MAC layer should ensure that the PCS isn't used for
interface modes that it doesn't support. I might introduce a bitmap of
interface modes for PCS later if there's a benefit to doing so.

> +	}
> +
> +	return 0;
> +}
> +
> +static const struct phylink_pcs_ops miic_phylink_ops = {
> +	.pcs_config = miic_config,
> +	.pcs_link_up = miic_link_up,
> +	.pcs_validate = miic_validate,

I'd prefer to have them in the order that they are in the structure.

> +};
> +
> +struct phylink_pcs *miic_create(struct device_node *np)
> +{
> +	struct platform_device *pdev;
> +	struct miic_port *miic_port;
> +	struct device_node *pcs_np;
> +	u32 port;
> +
> +	if (of_property_read_u32(np, "reg", &port))
> +		return ERR_PTR(-EINVAL);
> +
> +	if (port >= MIIC_MAX_NR_PORTS)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* The PCS pdev is attached to the parent node */
> +	pcs_np = of_get_parent(np);
> +	if (!pcs_np)
> +		return ERR_PTR(-EINVAL);
> +
> +	pdev = of_find_device_by_node(pcs_np);
> +	if (!pdev || !platform_get_drvdata(pdev))
> +		return ERR_PTR(-EPROBE_DEFER);

It would be a good idea to have a comment in the probe function to say
that this relies on platform_set_drvdata() being the very last thing
after a point where initialisation is complete and we won't fail.

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
