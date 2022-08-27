Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537BA5A3847
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 17:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiH0PMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 11:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiH0PMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 11:12:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47091B79C
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 08:12:49 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRxTw-0000AE-Gf; Sat, 27 Aug 2022 17:12:20 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRxTt-00010K-Ml; Sat, 27 Aug 2022 17:12:17 +0200
Date:   Sat, 27 Aug 2022 17:12:17 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 1/7] dt-bindings: net: pse-dt: add bindings
 for generic PSE controller
Message-ID: <20220827151217.GG2116@pengutronix.de>
References: <20220825130211.3730461-1-o.rempel@pengutronix.de>
 <20220825130211.3730461-2-o.rempel@pengutronix.de>
 <Ywf3Z+1VFy/2+P78@lunn.ch>
 <20220826074940.GC2116@pengutronix.de>
 <Ywou0na2zy3cLJG+@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ywou0na2zy3cLJG+@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 27, 2022 at 04:48:50PM +0200, Andrew Lunn wrote:
> On Fri, Aug 26, 2022 at 09:49:40AM +0200, Oleksij Rempel wrote:
> > On Fri, Aug 26, 2022 at 12:27:51AM +0200, Andrew Lunn wrote:
> > > > +  ieee802.3-pairs:
> > > > +    $ref: /schemas/types.yaml#/definitions/int8-array
> > > > +    description: Array of number of twisted-pairs capable to deliver power.
> > > > +      Since not all circuits are able to support all pair variants, the array of
> > > > +      supported variants should be specified.
> > > > +      Note - single twisted-pair PSE is formally know as PoDL PSE.
> > > > +    items:
> > > > +      enum: [1, 2, 4]
> > > 
> > > It is not clear to me what you are describing here. It looks like the
> > > number of pairs? That does not seem like a hardware property. The
> > > controller itself should be able to tell you how many pairs it can
> > > feed.
> > > 
> > > A hardware property would be which pairs of the socket are connected
> > > to a PSE and so can be used to deliver power.
> > 
> > Good point, this will be needed as well. But not right now.
> 
> That is another point. You are adding properties which no driver
> actually uses. That is unusual.
> 
> I think i would rename your current driver to regulator. That is all
> it is, and it only needs one property, the regulator itself. Its yaml
> description should only have the regulator, and nothing else.
> 
> When other drivers start to be added, we can think about each property
> they add, and decided if they are generic, or specific to a
> driver/board. Generic properties we can add to one shared .yaml file,
> device/board specific properties get added to that drivers .yaml
> 
> > > But i'm not sure how
> > > that would be useful to know. I suppose a controller capable of
> > > powering 4 pair, but connected to a socket only wired to supply 2, can
> > > then disable 2 pairs?
> > 
> > Not only. Here are following reasons:
> > - not all boards use a controller in form of IC. Some boards are the
> >   controller. So, there is no other place to describe, what kind of
> >   controller this board is. For example - currently there are no known
> >   ICs to support PoDL (ieee802.3-pairs == 1), early adopters are
> >   implementing it by using MOSFETs coupled with ADCs and some extra
> >   logic on CPU side:
> >   https://www.ti.com/lit/an/snla395/snla395.pdf
> > - not all ICs provide a way for advanced communication (I2C, SPI, MDIO).
> >   Some of them will provide only bootstrapping and some pin status
> >   feedback:
> >   https://www.analog.com/media/en/technical-documentation/data-sheets/4279fa.pdf
> > - Even if we are able to communicate with the IC, there are still board
> >   specific limitations.
> 
> I expect each of these will provide some sort of driver. It could be
> board specific, or it could be MCU specific if the same MCU is used
> multiple times and each implementation looks the same to Linux. I
> suppose there could even be a library which implements SCCP via a
> bit-banging GPIO line, and it has a binding for the two GPIO?
> 
> And if there is no communication at all with it, you cannot represent
> it in Linux, so you don't need to worry about it.
> 
> Each driver should come with its own .yaml file, and we should review
> it, and decided are the properties common or not.
> 
> > I hope we can agree that some property is need to tell what kind of PSE
> > specification is used by this node.
> > 
> > The next challenge is to name it. We have following options:
> > 1. PoE, PoE+, PoE++, 4PPoE, PoDL
> > 2. 802.3af, 802.3at, 802.bt, 802.3bu, 802.3cg
> > 3. Physical property of this specifications
> > 
> > Option 1 is mostly using marketing names, except of PoDL. This names are
> > not used in the ieee 802.3-2018 specification. Systematic research of
> > this marketing names would give following results:
> > - PoE is about delivering power over two twisted pairs and is related to
> >   802.3af and 802.3at specs.
> > - PoE+ is about delivering power over two twisted pairs and is related
> >   only to 802.3at.
> > - PoE++ is the same as 4PPoE or power over four twisted pairs and is related
> >   to 802.3bt.
> > - PoDL is related to 802.3bu and 802.3cg. Which is power over one
> >   twisted pair
> > 
> > All of this names combine different properties: number of twisted pairs
> > used to deliver power, maximal supported power by the system and
> > recommendation for digital interface to communicate with the PSE
> > controller (MDIO registers). Since system I currently use do not follow
> > all of this recommendations, it is needed to describe them separately.
> > 
> > Option 2 is interesting only for archaeological investigation. Final
> > snapshots of 802.3 specification do not provide mapping of extensions to
> > actual parts of the spec. I assume, no software developer will be able
> > to properly set the devicetree property by using specification extension
> > names.
> > 
> > Option 3 provide exact physical property of implementation by using same
> > wording provided by the  802.3-2018 spec. This option is easy to verify
> > by reviewing the board schematics and it is easy to understand without
> > doing historical analysis of 802.3 spec.
> 
> I would go for option 3. We want well defined concepts, and
> specifications provide that.
> 
> > > > +
> > > > +  ieee802.3-pse-type:
> > > > +    $ref: /schemas/types.yaml#/definitions/uint8
> > > > +    minimum: 1
> > > > +    maximum: 2
> > > > +    description: PSE Type. Describes classification- and class-capabilities.
> > > > +      Not compatible with PoDL PSE Type.
> > > > +      Type 1 - provides a Class 0, 1, 2, or 3 signature during Physical Layer
> > > > +      classification.
> > > > +      Type 2 - provides a Class 4 signature during Physical Layer
> > > > +      classification, understands 2-Event classification, and is capable of
> > > > +      Data Link Layer classification.
> > > 
> > > Again, the controller should know what class it can support. Why do we
> > > need to specify it?  What could make sense is we want to limit the
> > > controller to a specific type? 
> > 
> > If we are using existing controller - yes. But this binding is designed for the
> > system where no special PSE IC is used.
> 
> I would expect a discreet implementation to also have a driver. The
> specific discreet implementation should have a compatible, and a yaml
> file describing whatever properties it needs. And since the driver is
> specific to the discreet implementation, it should know what it can do
> in terms of PSE Type, etc.
> 
> If the same discrete implementation is used on multiple boards, and
> there are board specific limitations, then we need properties to limit
> what it can do. Maybe those limits are then described in the shared
> .yaml file, since limits like this probably are generic.
> 
> In general, i expect we will end up with two classes of properties:
> 
> Hardware controls: I2C bus address, SPI address, gpios for bit banging
> SCCP, GPIOs for turning power on/off and sensing etc.
> 
> Board specific limitations: Max class, Max current, max Type etc.

Ok, so current plan is:
- rename this driver and binding to pse-regulator
- i will integrate the "ieee802.3-pairs" property, since this driver
  need to know which field it need to fill in the ethtool response (PSE
  vs PoDL PSE)
- compatible will be "ieee802.3-pse-regulator"

Correct?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
