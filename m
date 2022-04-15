Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57347502720
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 10:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348523AbiDOIz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 04:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiDOIzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 04:55:25 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8814B644D;
        Fri, 15 Apr 2022 01:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6RJ/VwGJTUKSN4pEDxbLWHdkQvJ3lWAEWFoDyQeUEzY=; b=0h+2I4Mp2CKd9ThVYlQmFspKuM
        EhcO/UJG+h5+jVA8X7gRiiqEibxwSptVfDVrf8sZb4wt5xLVfB42duZd8yFG0yMFHBmoU0W5cmJWB
        yjA2uW9YarvyUuf8ZREIT4pb50/oZFJ70XqI8r+DsmO5i80cTCwzEP/IQhCKmmQXI3dDSnRvB1O5P
        K4+DluIrkyWN0VURAQvURZaHO8ak3Omw/tIhkP1bzLs+3TdWw3n6uVOpJSgRbTgDHXooqGLLD7g3p
        kDGU9IN7/s5RHSRWkEzHFoF7q1JeAPX1XJNLNCqI8dNMZJEuvZybbyHaXS4xJ4DHR39X1588Sbb6n
        cDrYiZ5g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58272)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nfHh1-0005SZ-66; Fri, 15 Apr 2022 09:52:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nfHgx-00057u-IP; Fri, 15 Apr 2022 09:52:35 +0100
Date:   Fri, 15 Apr 2022 09:52:35 +0100
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
Message-ID: <YlkyU7jRAi5037up@shell.armlinux.org.uk>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-7-clement.leger@bootlin.com>
 <YlgbUiXzHa0UNRK+@shell.armlinux.org.uk>
 <20220415104029.5e52080b@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220415104029.5e52080b@fixe.home>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 10:40:29AM +0200, Clément Léger wrote:
> Le Thu, 14 Apr 2022 14:02:10 +0100,
> "Russell King (Oracle)" <linux@armlinux.org.uk> a écrit :
> 
> > On Thu, Apr 14, 2022 at 02:22:44PM +0200, Clément Léger wrote:
> > > Add Renesas RZ/N1 advanced 5 port switch driver. This switch handles 5
> > > ports including 1 CPU management port. A MDIO bus is also exposed by
> > > this switch and allows to communicate with PHYs connected to the ports.
> > > Each switch port (except for the CPU management ports) are connected to
> > > the MII converter.
> > > 
> > > This driver include basic bridging support, more support will be added
> > > later (vlan, etc).  
> > 
> > This patch looks to me like it needs to be updated...
> 
> Hi Russell,
> 
> When you say so, do you expect the VLAN support to be included ?

I was referring to the use of .phylink_validate rather than
.phylink_get_caps - all but one DSA driver have been recently updated
to use the latter, and the former should now only be used in
exceptional circumstances.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
