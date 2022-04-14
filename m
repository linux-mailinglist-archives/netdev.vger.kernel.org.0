Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE580500E4C
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 15:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243073AbiDNNEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 09:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbiDNNEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 09:04:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2075F8EB67;
        Thu, 14 Apr 2022 06:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=se7TDjKdD4lTbs4/EAs3EJoTc89hcEiop1DKf6IJ6Ts=; b=O24dwONDjdolTVYJL/Mivk0Css
        Nam3xqr0eUKo8jnldPTeolq4WDbIxlwcwk2ZvbLTynj3gOn8SRkPyuY2xpVFiHkisvZqLR6e96TpZ
        iROwj/LKQwBHC+aUkXGrfIYm2lRQ1wWUaWwIv6ZKyGAxPzDmVgqgNjupkad6z4uXeYQ+RsbNqcIIm
        h1guXKEYNI1lRPmhu/Z0AWZDKKi6Ky88Hddzh0K6yR2quLxW5i3GKNrTf3tCc/TuH9ngsHT9zhOZS
        vCdRX3d6WVkPGIi1Zd3sAHCMe6ZCla7x6BJrtBvNBOijo3EeHFWRnOOun6b/wu+WU2f1XxP8ZASRL
        FDEipquA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58262)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nez70-0004Zy-SF; Thu, 14 Apr 2022 14:02:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nez6w-0004KB-Vf; Thu, 14 Apr 2022 14:02:10 +0100
Date:   Thu, 14 Apr 2022 14:02:10 +0100
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
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Laurent Gonzales <laurent.gonzales@non.se.com>,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <YlgbUiXzHa0UNRK+@shell.armlinux.org.uk>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-7-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414122250.158113-7-clement.leger@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 02:22:44PM +0200, Clément Léger wrote:
> Add Renesas RZ/N1 advanced 5 port switch driver. This switch handles 5
> ports including 1 CPU management port. A MDIO bus is also exposed by
> this switch and allows to communicate with PHYs connected to the ports.
> Each switch port (except for the CPU management ports) are connected to
> the MII converter.
> 
> This driver include basic bridging support, more support will be added
> later (vlan, etc).

This patch looks to me like it needs to be updated...

> +static void a5psw_phylink_validate(struct dsa_switch *ds, int port,
> +				   unsigned long *supported,
> +				   struct phylink_link_state *state)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0 };
> +
> +	phylink_set_port_modes(mask);
> +
> +	phylink_set(mask, Autoneg);
> +	phylink_set(mask, Pause);
> +	phylink_set(mask, Asym_Pause);
> +
> +	phylink_set(mask, 1000baseT_Full);
> +	if (!dsa_is_cpu_port(ds, port)) {
> +		phylink_set(mask, 10baseT_Half);
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Half);
> +		phylink_set(mask, 100baseT_Full);
> +	}

If the port supports e.g. RGMII (as it does via the media converter)
then it also supports 1000baseX modes as well - because a PHY attached
to the RGMII port can convert to 1000baseX.

> +
> +	linkmode_and(supported, supported, mask);
> +	linkmode_and(state->advertising, state->advertising, mask);
> +}

This basically means "I support every phy_interface_t mode that has ever
been implemented" which surely is not what you want. I doubt from the
above that you support 10GBASE-KR for example.

Please instead implement the .phylink_get_caps DSA switch interface, and
fill in the config->supported_interfaces for all interface modes that
the port supports (that including the media converter as well) and the
config->mac_capabilities members.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
