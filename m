Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B8D59E787
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245104AbiHWQiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244966AbiHWQhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:37:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D97BA99F3
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 07:44:56 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oQV8x-0004ge-UB; Tue, 23 Aug 2022 16:44:39 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oQV8v-0007MC-At; Tue, 23 Aug 2022 16:44:37 +0200
Date:   Tue, 23 Aug 2022 16:44:37 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH net-next v1 2/7] dt-bindings: net: phy: add PoDL PSE
 property
Message-ID: <20220823144437.GN10138@pengutronix.de>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-3-o.rempel@pengutronix.de>
 <20220822184534.GB113650-robh@kernel.org>
 <YwPaV2Frj+b++8hZ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YwPaV2Frj+b++8hZ@lunn.ch>
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

On Mon, Aug 22, 2022 at 09:34:47PM +0200, Andrew Lunn wrote:
> On Mon, Aug 22, 2022 at 01:45:34PM -0500, Rob Herring wrote:
> > On Fri, Aug 19, 2022 at 02:01:04PM +0200, Oleksij Rempel wrote:
> > > Add property to reference node representing a PoDL Power Sourcing Equipment.
> > > 
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > ---
> > >  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > > index ed1415a4381f2..49c74e177c788 100644
> > > --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > > +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > > @@ -144,6 +144,12 @@ properties:
> > >        Mark the corresponding energy efficient ethernet mode as
> > >        broken and request the ethernet to stop advertising it.
> > >  
> > > +  ieee802.3-podl-pse:
> > > +    $ref: /schemas/types.yaml#/definitions/phandle
> > > +    description:
> > > +      Specifies a reference to a node representing a Power over Data Lines
> > > +      Power Sourcing Equipment.
> > 
> > Ah, here is the consumer.
> > 
> > Why do you anything more than just a -supply property here for the 
> > PoE/PoDL supply? The only reason I see is you happen to want a separate 
> > driver for this and a separate node happens to be a convenient way to 
> > instantiate drivers in Linux. Convince me otherwise.
> 
> The regulator binding provides a lot of very useful properties, which
> look to do a good job describing the regulator part of a PoE/PeDL
> supplier side. What however is missing is the communication part, the
> power provider and the power consumer communicate with each other, via
> a serial protocol. They negotiate the supply of power, a sleep mode
> where power is reduced, but not removed, etc.
> 
> So a Power Sourcing Equipment driver is very likely to have a
> regulator embedded in it, but its more than a regulator.

@Rob, is it enough to convince?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
