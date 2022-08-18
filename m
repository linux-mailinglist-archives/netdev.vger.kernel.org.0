Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D97FF598789
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245577AbiHRPdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235303AbiHRPdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:33:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265971402F
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1zN4PVGV0RF+M9DEP7j6ZTDsXwMvSrGEz0vkDJIno4Y=; b=zY9x/sxmS8e36n6L1Z3O5qYi8h
        AZikXuim8baEFTHfKFG/9V+8MVQFIrVD15ixVQz+G6qCdoVvqSrkZB6us4a7qmSmvLnL3f0MiAqk4
        qHNyrQwoyUqgwV2PQUAxMmj0EapV2Hwbcz2V1xC5hGFIuzs9dBs9suHCZ4f8zpRJsjIwYoIdmc8/L
        O3mU8ShsPc4WuReLZ24UCdd7HU4PfkaapuFO5YLkcjr6CMtDVAt2LiVCCoj+b7aBnzZT6/3OqeESy
        oSERy4MGI6s8YV5ndaX2zdqOeXWNxioPbVhAHOMpGLJfqcPCGiQOUTjMi5zwLgqJ4wfNqO5xjw1Fm
        neyCtnqQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33842)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oOhW9-0006pr-33; Thu, 18 Aug 2022 16:33:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oOhW4-0006vt-Dq; Thu, 18 Aug 2022 16:33:04 +0100
Date:   Thu, 18 Aug 2022 16:33:04 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Craig McQueen <craig@mcqueen.id.au>
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Message-ID: <Yv5bsEpICDSuJUgs@shell.armlinux.org.uk>
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
 <Yv5XL4KTLxukVhck@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv5XL4KTLxukVhck@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 05:13:51PM +0200, Andrew Lunn wrote:
> > It is important to note that phy_device_create() initializes
> > dev->interface = PHY_INTERFACE_MODE_GMII, and so, when we use
> > phylink_create(PHY_INTERFACE_MODE_NA), no one will override this, and we
> > will end up with a PHY_INTERFACE_MODE_GMII interface inherited from the
> > PHY.
> 
> Is this actually a bug?
> 
> With pure phylib, you should call one of the connect functions, which
> underneath calls phy_attach_direct() which has a phy_interface_t. So
> the default in practice does not matter.
> 
> > All this means that in order to maintain compatibility with device tree
> > blobs where the phy-mode property is missing, we need to allow the
> > "gmii" phy-mode and treat it as "internal".
> 
> of_get_phy_mode() returns PHY_INTERFACE_MODE_NA if the property is
> missing, which also suggests this is a bug.
> 
> I wonder if we have any ports which actually rely on
> PHY_INTERFACE_MODE_GMII?

Loads now. Florian contributed the code to phylink that detects when
DSA initialises phylink with PHY_INTERFACE_MODE_NA, and then looks at
phy->interface _before_ calling phy_attach_direct() - and this is how
we end up with PHY_INTERFACE_MODE_GMII.

See:

commit 4904b6ea1f9dbf47107f50b1c502a22d0160712d
Author: Florian Fainelli <f.fainelli@gmail.com>
Date:   Tue Dec 12 16:00:26 2017 -0800

    net: phy: phylink: Use PHY device interface if N/A

    We may not always be able to resolve a correct phy_interface_t value before
    actually connecting to the PHY device, when that happens, just have
    phylink_connect_phy() utilize what the PHY device/driver provided.

    Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

submitted for 4.16-rc1. DSA then used this in:

commit aab9c4067d2389d0adfc9c53806437df7b0fe3d5
Author: Florian Fainelli <f.fainelli@gmail.com>
Date:   Thu May 10 13:17:36 2018 -0700

    net: dsa: Plug in PHYLINK support
...

for 4.18-rc1 to connect to its PHYs:

static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr)
{
        struct dsa_port *dp = dsa_slave_to_port(slave_dev);
        struct dsa_switch *ds = dp->ds;

        slave_dev->phydev = mdiobus_get_phy(ds->slave_mii_bus, addr);
        if (!slave_dev->phydev) {
                netdev_err(slave_dev, "no phy at %d\n", addr);
                return -ENODEV;
        }

        return phylink_connect_phy(dp->pl, slave_dev->phydev);
}
...
        ret = phylink_of_phy_connect(dp->pl, port_dn, phy_flags);
        if (ret == -ENODEV) {
                /* We could not connect to a designated PHY or SFP, so use the
                 * switch internal MDIO bus instead
                 */
                ret = dsa_slave_phy_connect(slave_dev, dp->index);
                if (ret) {
                        netdev_err(slave_dev,
                                   "failed to connect to port %d: %d\n",
                                   dp->index, ret);
                        phylink_destroy(dp->pl);
                        return ret;
                }
        }

which will be used when there is no phy-handle property.

I extended the change in 4904b6ea1f9dbf47107f50b1c502a22d0160712d to also
apply to fwnode setups in:

commit a18e6521a7d95dae8c65b5b0ef6bbe624fbe808c
Author: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Date:   Fri Nov 19 16:28:06 2021 +0000

    net: phylink: handle NA interface mode in phylink_fwnode_phy_connect()

because we were ending up with DSA drivers using PHY_INTERFACE_MODE_NA
inside phylink, and phylink has always special-cased that and drivers
have taken it to mean "give me all interface modes that are supported"
which is not what DSA should be using. It also gives a uniform and
understandable behaviour from phylink for DSA, rather than having
phylink behave one way (where no phy-mode and no phy-handle are
specified) but in a completely different way when phy-handle without
phy-mode is specified. It seemed to be the sensible thing to do, and
Florian agreed at the time.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
