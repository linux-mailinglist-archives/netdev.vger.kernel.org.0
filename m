Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFCFD592CC0
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241666AbiHOJUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 05:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241267AbiHOJUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 05:20:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3567222A2;
        Mon, 15 Aug 2022 02:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qCyz2ar8wIO0jnhd0FJSdqr3cK2p0Nehzl1i+J9pSbI=; b=tbb5hqrCr/LfK0sDqVCdsKFwkD
        ZL9r2f2XHI+LNPtQbOvg/Ys7lG30BKI1HgXOY7CneC4Z3ezpqbXuq62RuMhlYlHsNbzKZmNR4gbfe
        86kV9d3RcFwpkHUW0eZj8sN72rbAwNsW0BbpdT98D7EuYgsrp0e/++zWC8mDJRiRFwDoO35q7CqeR
        sf/cTuSAuLdcEX21X0VaV5d1C+Y+PkC3eekswUNA3OBOYW3pG3RBz/JT2QUhdW5X6T2FHwlQmyN3T
        vI/LhCvBnCL/wZosMDWuaPoO+o1Dsm8GzF/VPFy4YCayrqUnq29DFZKo7+kWNNrNSefI+S2aIL0PM
        8AjxQ3Jg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33794)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oNWGI-0002nI-U5; Mon, 15 Aug 2022 10:19:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oNWGF-0003jh-4P; Mon, 15 Aug 2022 10:19:51 +0100
Date:   Mon, 15 Aug 2022 10:19:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Message-ID: <YvoPt4h8m1fnVb6O@shell.armlinux.org.uk>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com>
 <0cd22a17-3171-b572-65fb-e9d3def60133@linaro.org>
 <DB9PR04MB81060AF4890DEA9E2378940288679@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <14cf568e-d7ee-886e-5122-69b2e58b8717@linaro.org>
 <DB9PR04MB8106851412412A65DF0A6F5388689@DB9PR04MB8106.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB9PR04MB8106851412412A65DF0A6F5388689@DB9PR04MB8106.eurprd04.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 08:51:32AM +0000, Wei Fang wrote:
> 
> 
> > -----Original Message-----
> > From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Sent: 2022年8月12日 19:26
> > To: Wei Fang <wei.fang@nxp.com>; andrew@lunn.ch; hkallweit1@gmail.com;
> > linux@armlinux.org.uk; davem@davemloft.net; edumazet@google.com;
> > kuba@kernel.org; pabeni@redhat.com; robh+dt@kernel.org;
> > krzysztof.kozlowski+dt@linaro.org; f.fainelli@gmail.com;
> > netdev@vger.kernel.org; devicetree@vger.kernel.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH net 1/2] dt: ar803x: Document disable-hibernation
> > property
> > 
> > On 12/08/2022 12:02, Wei Fang wrote:
> > >
> > >
> > >> -----Original Message-----
> > >> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > >> Sent: 2022年8月12日 15:28
> > >> To: Wei Fang <wei.fang@nxp.com>; andrew@lunn.ch;
> > >> hkallweit1@gmail.com; linux@armlinux.org.uk; davem@davemloft.net;
> > >> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> > >> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> > >> f.fainelli@gmail.com; netdev@vger.kernel.org;
> > >> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org
> > >> Subject: Re: [PATCH net 1/2] dt: ar803x: Document disable-hibernation
> > >> property
> > >>
> > >> On 12/08/2022 17:50, wei.fang@nxp.com wrote:
> > >>> From: Wei Fang <wei.fang@nxp.com>
> > >>>
> > >>
> > >> Please use subject prefix matching subsystem.
> > >>
> > > Ok, I'll add the subject prefix.
> > >
> > >>> The hibernation mode of Atheros AR803x PHYs is default enabled.
> > >>> When the cable is unplugged, the PHY will enter hibernation mode and
> > >>> the PHY clock does down. For some MACs, it needs the clock to
> > >>> support it's logic. For instance, stmmac needs the PHY inputs clock
> > >>> is present for software reset completion. Therefore, It is
> > >>> reasonable to add a DT property to disable hibernation mode.
> > >>>
> > >>> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> > >>> ---
> > >>>  Documentation/devicetree/bindings/net/qca,ar803x.yaml | 6 ++++++
> > >>>  1 file changed, 6 insertions(+)
> > >>>
> > >>> diff --git a/Documentation/devicetree/bindings/net/qca,ar803x.yaml
> > >>> b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
> > >>> index b3d4013b7ca6..d08431d79b83 100644
> > >>> --- a/Documentation/devicetree/bindings/net/qca,ar803x.yaml
> > >>> +++ b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
> > >>> @@ -40,6 +40,12 @@ properties:
> > >>>        Only supported on the AR8031.
> > >>>      type: boolean
> > >>>
> > >>> +  qca,disable-hibernation:
> > >>> +    description: |
> > >>> +    If set, the PHY will not enter hibernation mode when the cable is
> > >>> +    unplugged.
> > >>
> > >> Wrong indentation. Did you test the bindings?
> > >>
> > > Sorry, I just checked the patch and forgot to check the dt-bindings.
> > >
> > >> Unfortunately the property describes driver behavior not hardware, so
> > >> it is not suitable for DT. Instead describe the hardware
> > >> characteristics/features/bugs/constraints. Not driver behavior. Both
> > >> in property name and property description.
> > >>
> > > Thanks for your review and feedback. Actually, the hibernation mode is a
> > feature of hardware, I will modify the property name and description to be
> > more in line with the requirements of the DT property.
> > 
> > hibernation is a feature, but 'disable-hibernation' is not. DTS describes the
> > hardware, not policy or driver bejhvior. Why disabling hibernation is a property
> > of hardware? How you described, it's not, therefore either property is not for
> > DT or it has to be phrased correctly to describe the hardware.
> > 
> Sorry, I'm a little confused. Hibernation mode is a feature of PHY hardware, the
> mode defaults to be enabled. We can configure it enabled or not through the
> register which the PHY provided. Now some MACs need the PHY clocks always
> output a valid clock so that MACs can operate correctly. And I add the property
> to disable hibernation mode to avoid this case. And I noticed that there are 
> some similar properties existed in the qca,ar803x,yaml, such as
> "qca,disable-smarteee" and "qca,keep-pll-enabled". So why can't I use the
> "qca,disable-hibernation" property? How should I do? 

To me, your proposal is entirely reasonable and in keeping with DT's
mandate, which is to describe not only how the hardware is connected
but also how the hardware needs to be configured to inter-operate. I
don't see any need for you to change your proposed property.

It is, as you point out above, no different from these other
properties that configure the PHY's internal settings.

I think Krzysztof is confusing the term "hibernation" with the system
level action, and believing that this property has something to do
with preventing the driver doing something when the system enters
that state. I can't fathom any other explanation.

Maybe changing the description of the property would help:

+  qca,disable-hibernation:
+    description: |
+      Configure the PHY to disable hardware hibernation power saving
+      mode, which is entered when the cable is disconnected.
+    type: boolean

Also, I'd suggest also fixing up the patch description to stress that
this is a hardware feature:

"The hardware hibernation mode of Atheros AR803x PHYs is defaults to
being enabled at hardware reset. When the cable is unplugged, the PHY
will enter hibernation mode after a delay and the PHY clock output to
the MAC can be stopped to save power.

"However, some MACs need this clock for proper functioning of their
logic. For instance, stmmac needs the PHY clock for software reset to
complete.

"Therefore, add a DT property to configure the PHY to disable this
hardware hibernation mode."

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
