Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C0468021A
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 23:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbjA2WCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 17:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235341AbjA2WCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 17:02:36 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7B51BD8;
        Sun, 29 Jan 2023 14:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=2VZqotSR2lcZ3Dqkc+ZPLDnCbVMn7GmMbsJnsslN+nA=; b=QG
        Mef1rPPK4SyrXTuHq3+GPkt5WTiWRS13HdWbmvwL9QoPD43ZWNXw5N9nCiKx1VWDptux1FNnaoqjJ
        PbWlhmo+zcFqlzWY+GR54vFg4EfZTNa9PVMP6/h6q0BgRM4Ko+DzeHYo/3utp7e6Glk8+r8CDuqKq
        aRI9TgjG5RoSRPo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pMFkd-003WUU-Os; Sun, 29 Jan 2023 23:02:15 +0100
Date:   Sun, 29 Jan 2023 23:02:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sander Vanheule <sander@svanheule.net>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 11/11] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
Message-ID: <Y9bs53a9zyqEU9Xw@lunn.ch>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-12-ansuelsmth@gmail.com>
 <20221220173958.GA784285-robh@kernel.org>
 <Y6JDOFmcEQ3FjFKq@lunn.ch>
 <Y6JkXnp0/lF4p0N1@lunn.ch>
 <63a30221.050a0220.16e5f.653a@mx.google.com>
 <c609a7f865ab48f858adafdd9c1014dda8ec82d6.camel@svanheule.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c609a7f865ab48f858adafdd9c1014dda8ec82d6.camel@svanheule.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > This is an example of the dt implemented on a real device.
> > 
> >                 mdio {
> >                         #address-cells = <1>;
> >                         #size-cells = <0>;
> > 
> >                         phy_port1: phy@0 {
> >                                 reg = <0>;
> > 
> >                                 leds {
> >                                         #address-cells = <1>;
> >                                         #size-cells = <0>;
> [...]
> >                                 };
> >                         };
> [...]
> >                 };
> > 
> > In the following implementation. Each port have 2 leds attached (out of
> > 3) one white and one amber. The driver parse the reg and calculate the
> > offset to set the correct option with the regs by also checking the phy
> > number.
> 
> With switch silicon allowing user control of the LEDs, vendors can (and will)
> use the switch's LED peripheral to drive other LEDs (or worse). E.g. on a Cisco
> SG220-26 switch, using a Realtek RTL8382 SoC, the LEDs associated with some
> unused switch ports are used to display a global device status. My concern here
> is that one would have to specify switch ports, that aren't connected to
> anything, just to describe those non-ethernet LEDs.

Note that the binding is adding properties to the PHY nodes, not the
switch port nodes. Is this how the RTL8382 works? Marvell Switches
have LED registers which are not in the PHY register space.

But the point is, the PHYs will probe if listed. They don't have to
have a MAC pointing to them with a phandle. So the phydev will exist,
and that should be enough to get the LED class device registered. If
there is basic on/off support, that should be enough for you to attach
the Morse code panic trigger, the heartbeat handler, or any other LED
trigger.

	Andrew
