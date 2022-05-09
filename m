Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EE55201E2
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238782AbiEIQHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238783AbiEIQHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:07:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3391024D597;
        Mon,  9 May 2022 09:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=2KEf0T4CWmhmQoo31/SJzrrqOdQJI02kJMyMKQSb7lQ=; b=R4
        09Do7jt6UfVkMNteQRzXOmQs/aJIanozNpVoC7ZXWqQUxuNjFbRTZrnqsTAaHj5WKLpV0dtm5YGpn
        coZVSugG5VlQoOmd0fvXfjV+UBk9i+uJaKrnKuKTXxdKnf+XMBghDklpfv9/PNiieVfEZ95nC8XSw
        thCx7Q0+WbcuCoU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1no5qZ-001y6d-Me; Mon, 09 May 2022 18:02:55 +0200
Date:   Mon, 9 May 2022 18:02:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     alexandre.torgue@foss.st.com, broonie@kernel.org,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, joabreu@synopsys.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        lgirdwood@gmail.com, linux@armlinux.org.uk, pabeni@redhat.com,
        peppe.cavallaro@st.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 3/6] dt-bindings: net: Add documentation for phy-supply
Message-ID: <Ynk7L07VH/RFVzl6@lunn.ch>
References: <20220509074857.195302-1-clabbe@baylibre.com>
 <20220509074857.195302-4-clabbe@baylibre.com>
 <YnkGV8DyTlCuT92R@lunn.ch>
 <YnkWl+xYCX8r9DE7@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YnkWl+xYCX8r9DE7@Red>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 03:26:47PM +0200, LABBE Corentin wrote:
> Le Mon, May 09, 2022 at 02:17:27PM +0200, Andrew Lunn a écrit :
> > On Mon, May 09, 2022 at 07:48:54AM +0000, Corentin Labbe wrote:
> > > Add entries for the 2 new phy-supply and phy-io-supply.
> > > 
> > > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > > ---
> > >  .../devicetree/bindings/net/ethernet-phy.yaml          | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > > index ed1415a4381f..2a6b45ddf010 100644
> > > --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > > +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > > @@ -153,6 +153,16 @@ properties:
> > >        used. The absence of this property indicates the muxers
> > >        should be configured so that the external PHY is used.
> > >  
> > > +  phy-supply:
> > > +    description:
> > > +      Phandle to a regulator that provides power to the PHY. This
> > > +      regulator will be managed during the PHY power on/off sequence.
> > > +
> > > +  phy-io-supply:
> > > +    description:
> > > +      Phandle to a regulator that provides power to the PHY. This
> > > +      regulator will be managed during the PHY power on/off sequence.
> > 
> > If you need two differently named regulators, you need to make it clear
> > how they differ. My _guess_ would be, you only need the io variant in
> > order to talk to the PHY registers. However, to talk to a link
> > partner, you need the other one enabled as well. Which means handling
> > that regulator probably should be in the PHY driver, so it is enabled
> > only when the interface is configured up.
> > 
> 
> If I enable only the IO one, stmmac fail to reset, so both are needed to be up.
> I tried also to keep the "phy" one handled by stmmac (by removing patch 2), this lead to the PHY to not be found by MDIO scan.
> Proably because stmmac enable the "phy" before the "phy-io".
> 
> For the difference between the 2, according to my basic read (I am bad a it) of the shematic
> https://linux-sunxi.org/images/5/50/OrangePi_3_Schematics_v1.5.pdf
> phy-io(ephy-vdd25) seems to (at least) power MDIO bus.

So there is nothing in the data sheet of the RTL8211E to suggest you
can uses these different power supplies independently. The naming
'phy-io-supply' is very specific to RTL8211E, but you are defining a
generic binding here. I don't know the regulator binding, it is
possible to make phy-supply a list?

	 Andrew

