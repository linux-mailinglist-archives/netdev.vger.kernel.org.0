Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8314EC8F0
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348461AbiC3P6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241644AbiC3P6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:58:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D96143493;
        Wed, 30 Mar 2022 08:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QVeN0auyUiJb+oPCLrhnqYApa9hLfR51AifRS96qyh8=; b=z0M5RGNg0QaNm7qNLwTvSeAEr9
        /ORNy7ohb5E6SKwIQplVtUNHEPuQWmrTinhBWFKoL4oHRlSzOlx4kL4+JquNM5RjqaNKfHkwd0vXn
        YKo32xIGmn7I7HVUFMdJ6fQ2TQxGa7z86wj1ZDY/C/1TdrCAZCkTG36OdwnXvACc1htRft0Gf+sie
        E78nywZnnttlchz2Ag0pL3QnyEu8G5RI4l0QBpSKPTEALACMLdmYRKhpAtKRq+hkxuCd3G+Fh8B/Z
        N/2eh5ucj1k2roGIutOdHvaDgv36VUI/OYKUScXgGXSeDnvtchdNVrHrlo2uaG5nscuqTnLF3bSJ/
        HbBDjGvw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58008)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nZagM-0003P4-If; Wed, 30 Mar 2022 16:56:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nZagK-0006jQ-J4; Wed, 30 Mar 2022 16:56:24 +0100
Date:   Wed, 30 Mar 2022 16:56:24 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Message-ID: <YkR9qNGhF2ufXmFg@shell.armlinux.org.uk>
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
 <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
 <20220315190733.lal7c2xkaez6fz2v@skbuf>
 <deed2e82-0d93-38d9-f7a2-4137fa0180e6@canonical.com>
 <20220316101854.imevzoqk6oashrgg@skbuf>
 <b45dabe9-e8b6-4061-1356-4e5e6406591b@canonical.com>
 <YkR9NKec1YR7VGOy@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkR9NKec1YR7VGOy@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usefully, Krzysztof Kozlowski's email bounces for me.

On Wed, Mar 30, 2022 at 04:54:28PM +0100, Russell King (Oracle) wrote:
> On Wed, Mar 16, 2022 at 01:04:21PM +0100, Krzysztof Kozlowski wrote:
> > On 16/03/2022 11:18, Ioana Ciornei wrote:
> > >>>
> > >>> It's related since it shows a generic usage pattern of the sfp node.
> > >>> I wouldn't just remove it since it's just adds context to the example
> > >>> not doing any harm.
> > >>
> > >> Usage (consumer) is not related to these bindings. The bindings for this
> > >> phy/mac should show the usage of sfp, but not the provider bindings.
> > >>
> > >> The bindings of each clock provider do not contain examples for clock
> > >> consumer. Same for regulator, pinctrl, power domains, interconnect and
> > >> every other component. It would be a lot of code duplication to include
> > >> consumers in each provider. Instead, we out the example of consumer in
> > >> the consumer bindings.
> > >>
> > >> The harm is - duplicated code and one more example which can be done
> > >> wrong (like here node name not conforming to DT spec).
> > > 
> > > I suppose you refer to "sfp-eth3" which you suggested here to be just
> > > "sfp". 
> > 
> > I refer now to "cps_emac3" which uses specific name instead of generic
> > and underscore instead of hyphen (although underscore is actually listed
> > as allowed in DT spec, dtc will complain about it).
> > 
> > >In an example, that's totally acceptable but on boards there can
> > > be multiple SFPs which would mean that there would be multiple sfp
> > > nodes. We have to discern somehow between them. Adding a unit name would
> > > not be optimal since there is no "reg" property to go with it.
> > 
> > The common practice is adding a numbering suffix.
> > 
> > > 
> > > So "sfp-eth3" or variants I think are necessary even though not
> > > conforming to the DT spec.
> > > 
> > >>
> > >> If you insist to keep it, please share why these bindings are special,
> > >> different than all other bindings I mentioned above.
> > > 
> > > If it's that unheard of to have a somewhat complete example why are
> > > there multiple dtschema files submitted even by yourself with this same
> > > setup?
> > 
> > I am also learning and I wished many of my mistakes of early DT bindings
> > conversion were spotted. Especially my early bindings... but even now I
> > keep making mistakes. Human thing. :)
> > 
> > I converted quite a lot of bindings, so can you point to such examples
> > of my schema which includes consumer example in a provider bindings? If
> > you find such, please send a patch removing trivial code.
> > 
> > 
> > > As an example for a consumer device being listed in the provider yaml
> > > file is 'gpio-pca95xx.yaml'
> > 
> > Indeed, this is trivial and useless code which I kept from conversion,
> > should be removed.
> > 
> > >
> >  and for the reverse (provider described in
> > > the consumer) I can list 'samsung,s5pv210-clock.yaml',
> > > 'samsung,exynos5260-clock.yaml' etc.
> > 
> > These are different. This is an example how to model the input clock to
> > the device being described in the bindings. This is not an example how
> > to use the clock provider, like you created here. The input clock
> > sometimes is defined in Exynos clock controller, sometimes outside. The
> > example there shows the second case - when it has to come outside. It's
> > not showing the usage of clocks provided by this device, but I agree
> > that it also might be trivial and obvious. If you think it is obvious,
> > feel free to comment/send a patch.
> 
> Why is whether something is an input or output relevant? One can quite
> rightly argue that SFPs are both input and output. :)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
