Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB0C60E124
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiJZMsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJZMsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:48:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCB9E8C42;
        Wed, 26 Oct 2022 05:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8KIIctAa0VqNOSQ/2ZbNb/5Sjk32KtswvNRHKfRZHe8=; b=k4U0wbAzgdk0ibRqzdOrNyT5ks
        GY0QL65LsETSsuMMjMZ1mA45Y/vRqzSUSz77zT+WpXS8KmwT8mddef2EuvCro6OnzjxekiAlEro3M
        evU1A61xB5wh1d4nJuQWrTNwCaou0XAmMM8C3nwZyvmoE/8ZsUVZh9XmOCqmktF6A1XljPGBErHtz
        McVaF+xWBq25wpNctc4HENh72+4LsBtod98Ppb1lv1RApYH3seMvj6XqSbJjaHmbDkTP5/E6Lp+0a
        sq411EGaG5VIFNMBWJXlBpQM400dstEgepBOrlgLoeSzEPGiDCrBNAow4O0MiBVn8net0ZjukS3yC
        UtezbUgQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34960)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1onfp5-0005bZ-5S; Wed, 26 Oct 2022 13:47:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1onfp2-0000cY-Jm; Wed, 26 Oct 2022 13:47:52 +0100
Date:   Wed, 26 Oct 2022 13:47:52 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Sean Anderson <seanga2@gmail.com>, davem@davemloft.net,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/5] net: pcs: add new PCS driver for altera
 TSE PCS
Message-ID: <Y1kseONzzimgWQP3@shell.armlinux.org.uk>
References: <20220901143543.416977-1-maxime.chevallier@bootlin.com>
 <20220901143543.416977-4-maxime.chevallier@bootlin.com>
 <68b3dfbf-9bab-2554-254e-bffd280ba97e@gmail.com>
 <20221026113711.2b740c7a@pc-8.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026113711.2b740c7a@pc-8.home>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 11:37:11AM +0200, Maxime Chevallier wrote:
> Hello Sean,
> 
> On Sun, 9 Oct 2022 01:38:15 -0400
> Sean Anderson <seanga2@gmail.com> wrote:
> 
> 
> > > +#define   SGMII_PCS_LINK_TIMER_REG(x)		(0x12 + (x))  
> > 
> > Not used.
> 
> Right, I'll remove that in a followup patch
> 
> > > +#define SGMII_PCS_LINK_TIMER_1	0x13
> > > +#define SGMII_PCS_IF_MODE	0x14
> > > +#define   PCS_IF_MODE_SGMII_ENA		BIT(0)
> > > +#define   PCS_IF_MODE_USE_SGMII_AN	BIT(1)
> > > +#define   PCS_IF_MODE_SGMI_SPEED_MASK	GENMASK(3, 2)
> > > +#define   PCS_IF_MODE_SGMI_SPEED_10	(0 << 2)
> > > +#define   PCS_IF_MODE_SGMI_SPEED_100	(1 << 2)
> > > +#define   PCS_IF_MODE_SGMI_SPEED_1000	(2 << 2)  
> > 
> > You can use FIELD_PREP if you're so inclined. I assume SGMI is from
> > the datasheet.
> 
> Will do ! thanks :)
> 
> > > +#define   PCS_IF_MODE_SGMI_HALF_DUPLEX	BIT(4)
> > > +#define   PCS_IF_MODE_SGMI_PHY_ANi	BIT(5)

The definitions up to here look very similar to pcs-lynx.c when it comes
to 1000base-X and SGMII. I wonder whether regmap can help here to
abstract the register access differences and then maybe code can be
shared.

What value is in registers 2 and 3 (the ID registers) for this PCS?

On the link timer value setting, I have a patch to add a phylink helper
which returns the link timer in nanoseconds. May be a good idea if we
get that queued up so drivers can make use of it rather than hard-coding
a register value everywhere.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
