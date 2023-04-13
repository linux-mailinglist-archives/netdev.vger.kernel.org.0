Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6AF6E0F2A
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjDMNtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjDMNtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:49:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452A7183;
        Thu, 13 Apr 2023 06:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oAjc4p31qBTYB2X3O2xXYDletpffUIGgohb4G3UUKDE=; b=IqCggXgNajROaakNuU4mv+92TM
        dAtpI153Gn/L8YUMBBBAxOIVlpgTZmswWmZ1sSMaXRM7257aXfi5WrRZaOaCoGOuXXuncoCX7rTua
        jEwTtlqxp4bWiw+oX+PsWL0JBCx+6inlBGLVGmO9dNLdHo955b76gzbaikgv+NpJcFuY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmxJs-00ABvw-LA; Thu, 13 Apr 2023 15:49:00 +0200
Date:   Thu, 13 Apr 2023 15:49:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Rob Herring <robh@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 12/16] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
Message-ID: <05cf9959-ff47-45b4-97a5-dd73042373fe@lunn.ch>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-13-ansuelsmth@gmail.com>
 <20230406141018.GA2956156-robh@kernel.org>
 <6438051c.050a0220.d7db1.e1f7@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6438051c.050a0220.d7db1.e1f7@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >  examples:
> > >    - |
> > >      #include <dt-bindings/gpio/gpio.h>
> > > +    #include <dt-bindings/leds/common.h>
> > >  
> > >      mdio {
> > >          #address-cells = <1>;
> > > @@ -226,6 +229,27 @@ examples:
> > >                      label = "lan1";
> > >                      phy-mode = "internal";
> > >                      phy-handle = <&internal_phy_port1>;
> > > +
> > > +                    leds {
> > > +                        #address-cells = <1>;
> > > +                        #size-cells = <0>;
> > > +
> > > +                        led@0 {
> > > +                            reg = <0>;
> > > +                            color = <LED_COLOR_ID_WHITE>;
> > > +                            function = LED_FUNCTION_LAN;
> > > +                            function-enumerator = <1>;
> > > +                            default-state = "keep";
> > > +                        };
> > > +
> > > +                        led@1 {
> > > +                            reg = <1>;
> > > +                            color = <LED_COLOR_ID_AMBER>;
> > > +                            function = LED_FUNCTION_LAN;
> > > +                            function-enumerator = <1>;
> > 
> > Isn't function-enumerator supposed to be unique within a given 
> > 'function'?
> >
> 
> In the following example the output would be:
> - amber:lan-1
> - white:lan-1
> 
> So in theory it's unique for the same color and function. Is it
> acceptable? Seems sane that there may be multiple color for the same
> function (and enum)

But what does the -1 actually mean?

At Pavel's request, i documented 'good' names for these LEDs. I
suggested that if there are multiple LEDs for one MAC/PHY, you use
something like 'left' or 'right' to indicate their position on the
RJ45 socket. That has a clear meaning.

     Andrew
