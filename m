Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53CB559EAB1
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 20:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiHWSLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 14:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbiHWSL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 14:11:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D54D53D0A
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 09:23:14 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oQWg7-00009i-3P; Tue, 23 Aug 2022 18:22:59 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oQWg5-0004cc-Dq; Tue, 23 Aug 2022 18:22:57 +0200
Date:   Tue, 23 Aug 2022 18:22:57 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
Subject: Re: [PATCH net-next v1 1/7] dt-bindings: net: pse-dt: add bindings
 for generic PSE controller
Message-ID: <20220823162257.GO10138@pengutronix.de>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-2-o.rempel@pengutronix.de>
 <20220822184112.GA113650-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220822184112.GA113650-robh@kernel.org>
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

On Mon, Aug 22, 2022 at 01:41:12PM -0500, Rob Herring wrote:
> On Fri, Aug 19, 2022 at 02:01:03PM +0200, Oleksij Rempel wrote:
> > Add binding for generic Ethernet PSE controller.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  .../bindings/net/pse-pd/generic-pse.yaml      | 40 +++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml b/Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml
> > new file mode 100644
> > index 0000000000000..64f91efa79a56
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml
> > @@ -0,0 +1,40 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/pse-pd/generic-pse.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Generic Power Sourcing Equipment
> > +
> > +maintainers:
> > +  - Oleksij Rempel <o.rempel@pengutronix.de>
> > +
> > +description: |
> > +  Generic PSE controller. The device must be referenced by the PHY node
> > +  to control power injection to the Ethernet cable.
> 
> Isn't this separate from the PHY other than you need to associate 
> supplies with ethernet ports?
> 
> Is there a controller here? Or it is just a regulator consumer 
> associated with an ethernet port?

Current version has only regulator. It will be extended with IEEE 802.3
specific power source classification information, wich will be overkill for the
regulator framework. I can add it to the v2 version.

> > +properties:
> > +  compatible:
> > +    const: ieee802.3-podl-pse-generic
> 
> Is this for 802.3bu only (which is where PoDL comes from) or all the 
> flavors? If all, do they need to be distinguished?

yes. ieee802.3 defines type and class with different enumeration and
meanings for PSE and PoDL PSE. 

So far we have two different modes:
 - 802.3bu (PoDL PSE). Has own types and classes
 - 802.3af  is extended by 802.3at, and the extended by 802.3bt
   all of them are named as PSE and has own types and classes as well.

I worry more about the fact is some one will implement HW supporting both
modes. IMO, it is possible to take usual ethernet PHY, configure to
10Bit half-duplex and run over single pair. In this case it is possible
to use only PoDL PSE mode.

In this case I need single generic compatible but different properties
to describe supported PSE and PoDL PSE modes.

> 'generic' is redundant.

ok

> > +
> > +  '#pse-cells':
> 
> What's this for? You don't have a consumer.

the consumer is PHY.

> > +    const: 0
> > +
> > +  ieee802.3-podl-pse-supply:
> 
> Seems a bit long

ok. Reduce it to pse-supply ?

> > +    description: |
> 
> Don't need '|' if no formatting to maintain.

ok

> > +      Power supply for the PSE controller
> > +
> > +additionalProperties: false
> > +
> > +required:
> > +  - compatible
> > +  - '#pse-cells'
> > +  - ieee802.3-podl-pse-supply
> > +
> > +examples:
> > +  - |
> > +    ethernet-pse-1 {
> > +      compatible = "ieee802.3-podl-pse-generic";
> > +      ieee802.3-podl-pse-supply = <&reg_t1l1>;
> > +      #pse-cells = <0>;
> > +    };
> > -- 
> > 2.30.2
> > 
> > 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
