Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE664EC8D4
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348439AbiC3PyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348435AbiC3PyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:54:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB435F05;
        Wed, 30 Mar 2022 08:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hd8x5G07xQ6ejO1HbwR6Z4Sgu/awmPVUcKqcl+J397Q=; b=icUZb7jOfqScFtLHisZo1u8nQi
        IyGsMhSg8hqv7hH/VLRozz6sLInYpvKLpg5/lNDgoiqSxI4A6tXPkeT6xfYcbu8UXYN3g2K3sPmX6
        Tz4X3DhjQvcd+iEKC3o3Oz4RMR2UqpygEkryD2DNaZvqKhv0wqo0Wph+lPGAyPLBji8zGHG75N62f
        fzNsr+MRCLeFGB/2/+sBMqOx6pR7aM86ph8XzfIl2Nb5yzx9tE0TwUcyHEudD6maIhDmpzP4sCx8R
        hWE4aAaT28R1S0ywAcbURawADVQsDH4KfpWkhk0jrhBYoj4JwLFTNY85ck9aMIJz5LXpAVeCmds1R
        Z/+TP6jA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58004)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nZacQ-0003O8-6S; Wed, 30 Mar 2022 16:52:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nZacP-0006jB-1w; Wed, 30 Mar 2022 16:52:21 +0100
Date:   Wed, 30 Mar 2022 16:52:21 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Message-ID: <YkR8tTWabfTRLarB@shell.armlinux.org.uk>
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
 <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
 <20220315190733.lal7c2xkaez6fz2v@skbuf>
 <deed2e82-0d93-38d9-f7a2-4137fa0180e6@canonical.com>
 <20220316101854.imevzoqk6oashrgg@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316101854.imevzoqk6oashrgg@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 10:18:55AM +0000, Ioana Ciornei wrote:
> On Wed, Mar 16, 2022 at 09:23:45AM +0100, Krzysztof Kozlowski wrote:
> > On 15/03/2022 20:07, Ioana Ciornei wrote:
> > > On Tue, Mar 15, 2022 at 07:21:59PM +0100, Krzysztof Kozlowski wrote:
> > >> On 15/03/2022 13:33, Ioana Ciornei wrote:
> > >>> Convert the sff,sfp.txt bindings to the DT schema format.
> > >>>
> > >>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > >>> ---
> > > 
> > > (..)
> > > 
> > >>> +maintainers:
> > >>> +  - Russell King <linux@armlinux.org.uk>
> > >>> +
> > >>> +properties:
> > >>> +  compatible:
> > >>> +    enum:
> > >>> +      - sff,sfp  # for SFP modules
> > >>> +      - sff,sff  # for soldered down SFF modules
> > >>> +
> > >>> +  i2c-bus:
> > >>
> > >> Thanks for the conversion.
> > >>
> > >> You need here a type because this does not look like standard property.
> > > 
> > > Ok.
> > > 
> > >>
> > >>> +    description:
> > >>> +      phandle of an I2C bus controller for the SFP two wire serial
> > >>> +
> > >>> +  maximum-power-milliwatt:
> > >>> +    maxItems: 1
> > >>> +    description:
> > >>> +      Maximum module power consumption Specifies the maximum power consumption
> > >>> +      allowable by a module in the slot, in milli-Watts. Presently, modules can
> > >>> +      be up to 1W, 1.5W or 2W.
> > >>> +
> > >>> +patternProperties:
> > >>> +  "mod-def0-gpio(s)?":
> > >>
> > >> This should be just "mod-def0-gpios", no need for pattern. The same in
> > >> all other places.
> > >>
> > > 
> > > The GPIO subsystem accepts both suffixes: "gpio" and "gpios", see
> > > gpio_suffixes[]. If I just use "mod-def0-gpios" multiple DT files will
> > > fail the check because they are using the "gpio" suffix.
> > > 
> > > Why isn't this pattern acceptable?
> > 
> > Because original bindings required gpios, so DTS are wrong, and the
> > pattern makes it difficult to grep and read such simple property.
> > 
> > The DTSes which do not follow bindings should be corrected.
> > 
> 
> Russell, do you have any thoughts on this?
> I am asking this because you were the one that added the "-gpios" suffix
> in the dtbinding and the "-gpio" usage in the DT files so I wouldn't
> want this to diverge from your thinking.
> 
> Do you have a preference?

SFP support predated (in my tree) the deprecation of the -gpio suffix,
and despite the SFP binding doc being sent for review, it didn't get
reviewed so the issue was never picked up.

My understanding is that GPIO will continue to accept either -gpio or
-gpios for ever, so there shouldn't be any issue here - so converting
all instances of -gpio to -gpios should be doable without issue.

> If it's that unheard of to have a somewhat complete example why are
> there multiple dtschema files submitted even by yourself with this same
> setup?
> As an example for a consumer device being listed in the provider yaml
> file is 'gpio-pca95xx.yaml' and for the reverse (provider described in
> the consumer) I can list 'samsung,s5pv210-clock.yaml',
> 'samsung,exynos5260-clock.yaml' etc.

My feels are it _is_ useful to show the consumer side in examples.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
