Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FBE5205DE
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 22:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiEIUch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 16:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiEIUb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 16:31:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA88D5A;
        Mon,  9 May 2022 13:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=obE3GvP5MiFalr+zUuFTsVYAipwQCABa5LeNZRhk2iw=; b=hyHleL2qGRNzf/f0LIaT4+nAG0
        7ldV8Th5xj9XD3zKxtMqCjfCZP2P548K9Exfs7scwOVT0ZO9/3RK9VKgXfcFNU6WMvqJt39n9f/rE
        A5Jccm7RiR00kZn9xF6tW/7+VAqZVW+gfhAj6r5bor8oNoU2pl7RfV50UHpDpKF2C3R+C91DoeIge
        Avvgcyb5d7MGKgcrfgZacnrnxMQB7dTTw3xRD0IcAP1H0l/I2RB1n2hlhAtWeKcdxM3WSrGeWweiy
        OrgEmgnYUArHP0/C0B2f1z9ccASxFScvthsYLfDqH5+vOixi6KccN7kUPSPBpRKklhGB/i4CE3muW
        VjWMN+tA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60654)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1no9rt-0003i3-Uw; Mon, 09 May 2022 21:20:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1no9rq-0005Oe-CL; Mon, 09 May 2022 21:20:30 +0100
Date:   Mon, 9 May 2022 21:20:30 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 04/12] net: pcs: add Renesas MII converter
 driver
Message-ID: <Ynl3jpuJFqXLscvE@shell.armlinux.org.uk>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
 <20220509131900.7840-5-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220509131900.7840-5-clement.leger@bootlin.com>
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

On Mon, May 09, 2022 at 03:18:52PM +0200, Clément Léger wrote:
> +#define MIIC_PRCMD			0x0
> +#define MIIC_ESID_CODE			0x4
> +
> +#define MIIC_MODCTRL			0x20
> +#define MIIC_MODCTRL_SW_MODE		GENMASK(4, 0)
> +
> +#define MIIC_CONVCTRL(port)		(0x100 + (port) * 4)
> +
> +#define MIIC_CONVCTRL_CONV_SPEED	GENMASK(1, 0)
> +#define CONV_MODE_10MBPS		0
> +#define CONV_MODE_100MBPS		BIT(0)
> +#define CONV_MODE_1000MBPS		BIT(1)

I think this is an inappropriate use of the BIT() macro. BIT() should be
used for single bit rather than for field values.

You seem to have a two bit field in bits 1 and 0 of a register, which
has the values of:
0 - 10MBPS
1 - 100MBPS
2 - 1GBPS

I'd guess 3 is listed as "undefined", "do not use" or something similar?

> +
> +#define MIIC_CONVCTRL_CONV_MODE		GENMASK(3, 2)
> +#define CONV_MODE_MII			0
> +#define CONV_MODE_RMII			BIT(0)
> +#define CONV_MODE_RGMII			BIT(1)

This looks similar. a 2-bit field in bits 3 and 2 taking values:
0 - MII
1 - RMII
2 - RGMII

...

> +static int miic_config(struct phylink_pcs *pcs, unsigned int mode,
> +		       phy_interface_t interface,
> +		       const unsigned long *advertising, bool permit)
> +{
> +	u32 speed = CONV_MODE_10MBPS, conv_mode = CONV_MODE_MII, val;
> +	struct miic_port *miic_port = phylink_pcs_to_miic_port(pcs);
> +	struct miic *miic = miic_port->miic;
> +	int port = miic_port->port;
> +
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_RMII:
> +		conv_mode = CONV_MODE_RMII;
> +		speed = CONV_MODE_100MBPS;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII:
> +		conv_mode = CONV_MODE_RGMII;
> +		speed = CONV_MODE_1000MBPS;
> +		break;
> +	case PHY_INTERFACE_MODE_MII:

I'm not sure why you need to initialise "speed" and "conv_mode" above
when you could set them here.

Thanks. 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
