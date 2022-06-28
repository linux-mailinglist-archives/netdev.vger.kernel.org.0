Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B5855EA2D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbiF1Qq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiF1QpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:45:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC12FE7;
        Tue, 28 Jun 2022 09:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2/M/g5u5jwnlXk0l7tYRn4YYZxyECZLA2UT2UxDh/rE=; b=vXjUkTHoKF9wG+0zPAswh9DSOb
        RsQSXx7BoC5v/xQ14v1zMPvDwiKVB9Sv2pxEc+XWcncKgq0Z/HT8WubPMvV1qsxccdXwoaTvj3S7Z
        NDXkr5OwavFOhntxOrMQE/BVQyD2h3QjHfMa5DIjvskJ5PHebKiMdjxEjgcs/JcMgj2jjBF6Cqefd
        U04OBrXPApVGa3j0spj3ivPGv0+APH8fmUzv54/WWnTL1eDLSBkw3GFSMTttu5+ELD+HxNI/iBadG
        e8axuok8t2CWG2iEnpAavMQR1vXUTjvpcsPBfiz+jk3khYCvd1qw7iBrOq/WNmg1KuMTd3a5KWtnc
        9yB/LKPw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33068)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o6EIu-0001r6-9p; Tue, 28 Jun 2022 17:43:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o6EIk-00052x-LT; Tue, 28 Jun 2022 17:42:58 +0100
Date:   Tue, 28 Jun 2022 17:42:58 +0100
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
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v9 05/16] net: pcs: add Renesas MII converter
 driver
Message-ID: <YrsvkqBbzUvTYOeI@shell.armlinux.org.uk>
References: <20220624144001.95518-1-clement.leger@bootlin.com>
 <20220624144001.95518-6-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220624144001.95518-6-clement.leger@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 04:39:50PM +0200, Clément Léger wrote:
> Add a PCS driver for the MII converter that is present on the Renesas
> RZ/N1 SoC. This MII converter is reponsible for converting MII to
> RMII/RGMII or act as a MII pass-trough. Exposing it as a PCS allows to
> reuse it in both the switch driver and the stmmac driver. Currently,
> this driver only allows the PCS to be used by the dual Cortex-A7
> subsystem since the register locking system is not used.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Looks good to me, thanks.

The only issue I haven't brought up is:

> +static int miic_config(struct phylink_pcs *pcs, unsigned int mode,
> +		       phy_interface_t interface,
> +		       const unsigned long *advertising, bool permit)
> +{
> +	struct miic_port *miic_port = phylink_pcs_to_miic_port(pcs);
> +	struct miic *miic = miic_port->miic;
> +	int port = miic_port->port;
> +	u32 speed, conv_mode, val;
> +
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_RMII:
> +		conv_mode = CONV_MODE_RMII;
> +		speed = CONV_MODE_100MBPS;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +		conv_mode = CONV_MODE_RGMII;
> +		speed = CONV_MODE_1000MBPS;
> +		break;
> +	case PHY_INTERFACE_MODE_MII:
> +		conv_mode = CONV_MODE_MII;
> +		/* When in MII mode, speed should be set to 0 (which is actually
> +		 * CONV_MODE_10MBPS)
> +		 */
> +		speed = CONV_MODE_10MBPS;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	val = FIELD_PREP(MIIC_CONVCTRL_CONV_MODE, conv_mode) |
> +	      FIELD_PREP(MIIC_CONVCTRL_CONV_SPEED, speed);
> +
> +	miic_reg_rmw(miic, MIIC_CONVCTRL(port),
> +		     MIIC_CONVCTRL_CONV_MODE | MIIC_CONVCTRL_CONV_SPEED, val);
> +	miic_converter_enable(miic_port->miic, miic_port->port, 1);
> +
> +	return 0;
> +}

the stting of the speed here. As this function can be called as a result
of ethtool setting the configuration while the link is up, this could
have disasterous effects on the link. This will only happen if there is
no PHY present and we aren't using fixed-link mode.

Therefore, I'm willing to get this pass, but I think it would be better
if the speed was only updated if the interface setting is actually
being changed. So:

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
