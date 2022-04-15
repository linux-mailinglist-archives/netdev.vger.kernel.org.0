Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFC7502B9A
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 16:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353340AbiDOOTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 10:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245043AbiDOOTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 10:19:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DDF47078;
        Fri, 15 Apr 2022 07:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=kg3aqaRv6MCfX3nzMOw2BLbNJaihZsS6crAkCHS5bCE=; b=Ez
        M6g040LekDC/A6oXc4IR73vgy89lAtnY3HiQbExVJsFGndMhTAY8yvX7QDMoRM40py+Se95geiLzY
        no6QroyeebBiR4uugyUuEumFgEtPxQxn/9wjNZ20LMrgRmFzjNIGT7PQiuWVEpY0bde5WnHSfB/fp
        UeQmOpDdUBpV3KE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nfMkg-00Fyjv-O6; Fri, 15 Apr 2022 16:16:46 +0200
Date:   Fri, 15 Apr 2022 16:16:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
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
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/12] ARM: dts: r9a06g032: describe MII
 converter
Message-ID: <Yll+Tpnwo5410B9H@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-10-clement.leger@bootlin.com>
 <YlismVi8y3Vf6PZ0@lunn.ch>
 <20220415102453.1b5b3f77@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220415102453.1b5b3f77@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 10:24:53AM +0200, Clément Léger wrote:
> Le Fri, 15 Apr 2022 01:22:01 +0200,
> Andrew Lunn <andrew@lunn.ch> a écrit :
> 
> > On Thu, Apr 14, 2022 at 02:22:47PM +0200, Clément Léger wrote:
> > > Add the MII converter node which describes the MII converter that is
> > > present on the RZ/N1 SoC.  
> > 
> > Do you have a board which actually uses this? I just noticed that
> > renesas,miic-cfg-mode is missing, it is a required property, but maybe
> > the board .dts file provides it?
> > 
> >     Andrew
> 
> Hi Andrew, yes, I have a board that defines and use that.

Great. Do you plan to mainline it? It is always nice to see a user.

> The
> renesas,miic-cfg-mode actually configures the muxes that are present on
> the SoC. They allows to mux the various ethernet components (Sercos
> Controller, HSR Controller, Ethercat, GMAC1, RTOS-GMAC).
> All these muxes are actually controller by a single register
> CONVCTRL_MODE. You can actually see the muxes that are present in the
> manual [1] at Section 8 and the CONVCTRL_MODE possible values are listed
> on page 180.
> 
> This seems to be something that is board dependent because the muxing
> controls the MII converter outputs which depends on the board layout.

Does it also mux the MDIO lines as well?

We might want to consider the name 'mux'. Linux already has the
concept of a mux, e.g. an MDIO mux, and i2c mux etc. These muxes have
one master device, which with the aid of the mux you can connect to
multiple busses. And at runtime you flip the mux as needed to access
the devices on the multiple slave busses. For MDIO you typically see
this when you have multiple Ethernet switch, each has its own slave
MDIO bus, and you use the mux to connect the single SOC MDIO bus
master to the various slave busses as needed to perform a bus
transaction. I2C is similar, you can have multiple SFPs, either with
there own IC2 bus, connected via a mux to a single I2C bus controller
on the SoC.

I've not looked at the data sheet yet, but it sounds like it operates
in a different way, so we might want to avoid 'mux'.

> I'm open to any modification for this setup which does not really fit
> any abstraction that I may have seen.
> 
> [1]
> https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-group-users-manual-system-introduction-multiplexing-electrical-and

O.K, looking at figure 8.1.

What the user wants to express is something like:

Connect MI_CONV5 to SECOS PORTA
Connect MI_CONV4 to ETHCAT PORTB
Connect MI_CONV3 to SWITCH PORTC
Connect MI_CONV2 to SWITCH PORTD

plus maybe

Connect SWITCH PORTIN to RTOS

So i guess i would express the DT bindings like this, 5 values, and
let the driver then try to figure out the value you need to put in the
register, or return -EINVAL. For DT bindings we try to avoid magic
values which get written into registers. We prefer a higher level
description, and then let the driver figure out how to actually
implement that.

	  Andrew
