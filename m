Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CC66529C0
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 00:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbiLTXUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 18:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLTXUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 18:20:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4952C19C2A;
        Tue, 20 Dec 2022 15:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jP1SznLk4QqKOeAQ29Z+yBmKm0jVtejwu0lLKovrjPA=; b=XGouaF1h0RrR6vGj9PvB5XiU7W
        x5g6chWr2bEk11CMq0ahuXCdEj8jA67u2lcjac0mKV7FAehvY/TWE2uDraiax+Oi2UGIvjghWGTwp
        J76YUFli/0j0LNbbTBHCJCi8FqoxilvDX2l8c/bFH3DQL7rNOlYQjdKnONLl5lR5M5Qs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7luK-00089h-By; Wed, 21 Dec 2022 00:20:24 +0100
Date:   Wed, 21 Dec 2022 00:20:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh@kernel.org>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
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
Message-ID: <Y6JDOFmcEQ3FjFKq@lunn.ch>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-12-ansuelsmth@gmail.com>
 <20221220173958.GA784285-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220173958.GA784285-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 11:39:58AM -0600, Rob Herring wrote:
> On Thu, Dec 15, 2022 at 12:54:38AM +0100, Christian Marangi wrote:
> > Add LEDs definition example for qca8k using the offload trigger as the
> > default trigger and add all the supported offload triggers by the
> > switch.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  .../devicetree/bindings/net/dsa/qca8k.yaml    | 24 +++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > index 978162df51f7..4090cf65c41c 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> > @@ -65,6 +65,8 @@ properties:
> >                   internal mdio access is used.
> >                   With the legacy mapping the reg corresponding to the internal
> >                   mdio is the switch reg with an offset of -1.
> > +                 Each phy have at least 3 LEDs connected and can be declared
> > +                 using the standard LEDs structure.
> >  
> >  patternProperties:
> >    "^(ethernet-)?ports$":
> > @@ -202,6 +204,7 @@ examples:
> >      };
> >    - |
> >      #include <dt-bindings/gpio/gpio.h>
> > +    #include <dt-bindings/leds/common.h>
> >  
> >      mdio {
> >          #address-cells = <1>;
> > @@ -284,6 +287,27 @@ examples:
> >  
> >                  internal_phy_port1: ethernet-phy@0 {
> >                      reg = <0>;
> > +
> > +                    leds {
> > +                        #address-cells = <1>;
> > +                        #size-cells = <0>;
> > +
> > +                        led@0 {
> > +                            reg = <0>;
> > +                            color = <LED_COLOR_ID_WHITE>;
> > +                            function = LED_FUNCTION_LAN;
> > +                            function-enumerator = <1>;
> > +                            linux,default-trigger = "netdev";
> 
> 'function' should replace this. Don't encourage more users. 
> 
> Also, 'netdev' is not documented which leaves me wondering why there's 
> no warning? Either this patch didn't apply or there's a problem in the 
> schema that's not checking this node.

It is probably the usual limitation that the tools require a
compatible, where as the kernel does not.

> > +                        };
> > +
> > +                        led@1 {
> > +                            reg = <1>;
> > +                            color = <LED_COLOR_ID_AMBER>;
> > +                            function = LED_FUNCTION_LAN;
> > +                            function-enumerator = <1>;
> 
> Typo? These are supposed to be unique. Can't you use 'reg' in your case?

reg in this context is the address of the PHY on the MDIO bus. This is
an Ethernet switch, so has many PHYs, each with its own address.

   Andrew
