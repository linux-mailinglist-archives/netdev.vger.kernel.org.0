Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981E952DA24
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 18:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241470AbiESQZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 12:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbiESQZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 12:25:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B91EC1EE2;
        Thu, 19 May 2022 09:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CQwUBWNsvvBzsepcIInv96GZu+Y9Fs9IrqHVo2LozcE=; b=RcW2hhpjCtUnjbATXRZWe4Y0iY
        zARJGjGheRQAFvQECwXaNd9qLFbA+J4TWfPaC7vrpOINDjYwCSljBvnL8BM7v0uSWHfPC1W9Xcsk/
        55rUl/iYy3kHnvLiJqeqBXP0tMb1e+clQhz0CxNNpjzb6BeD0R8ZpooJzgPoJ+bfxceLc/x3BPc1j
        toMV7QWUr2h619mN24cQks+fY39q3hmP0SrN5HQEOZTiSx8tBXV/GXx2NLZ1rVm16E3y24HwXCxu1
        ouvkRN1O2OXMvU9zsgPS0B/VEyrxvODHka8iUPHMxkCCBmU+Nr+Me+gleKv1jha807NwnYLUy6Akn
        0Cr+j6Vg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60778)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nrixc-0004FA-F2; Thu, 19 May 2022 17:25:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nrixa-0006hk-Ks; Thu, 19 May 2022 17:25:10 +0100
Date:   Thu, 19 May 2022 17:25:10 +0100
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
Subject: Re: [PATCH net-next v5 05/13] net: pcs: add Renesas MII converter
 driver
Message-ID: <YoZvZj9sQL2GZAI3@shell.armlinux.org.uk>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
 <20220519153107.696864-6-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220519153107.696864-6-clement.leger@bootlin.com>
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

On Thu, May 19, 2022 at 05:30:59PM +0200, Clément Léger wrote:
> Add a PCS driver for the MII converter that is present on the Renesas
> RZ/N1 SoC. This MII converter is reponsible for converting MII to
> RMII/RGMII or act as a MII pass-trough. Exposing it as a PCS allows to
> reuse it in both the switch driver and the stmmac driver. Currently,
> this driver only allows the PCS to be used by the dual Cortex-A7
> subsystem since the register locking system is not used.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Looks much better now, thanks. Only one thing I've spotted is:

> +static int miic_validate(struct phylink_pcs *pcs, unsigned long *supported,
> +			 const struct phylink_link_state *state)
> +{
> +	if (state->interface == PHY_INTERFACE_MODE_RGMII ||
> +	    state->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    state->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
> +	    state->interface == PHY_INTERFACE_MODE_RGMII_RXID ||

The above could use:

	if (phy_interface_mode_is_rgmii(state->interface) ||

Also, as a request to unbind this driver would be disasterous to users,
I think you should set ".suppress_bind_attrs = true" to prevent the
sysfs bind/unbind facility being available. This doesn't completely
solve the problem.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
