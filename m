Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD84569346
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 22:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiGFUZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 16:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbiGFUZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 16:25:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1471D2AE13
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 13:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+52E+897hAC2yZGYmow7KzbKd9/5gHAo6CPMam//ys8=; b=q298a3vttxqTHLlptz8A64hgsG
        HNFlMBaLw35ZQPBB4mZrZMpEUkcn+HueFDAtHxUZuP+Db2omve3HUjGv336GMO+T6HazzNfgFe/pA
        yI4vwPYaASMFgVPJTUbKngcwCIojrc0n63/V+sjicJcBOC7tNG4diNphdlUgxwIVIf5Wiz3vNJNHT
        TSrTkOhVwcZgdae9GYhBqHelQm3LHKxJXSjMVvH/1m5Rko8vvwmgG3VB7oklgVPSHzh9xEpjoyyjw
        gTv4pt9KPTVCTxQ0aM+GoRbmnj4oyinvsTzPAQSNE/ukCz8f6Qyxq6tzLmLKlVJPI357PXXiFtloj
        w2L2Ec6g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33210)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o9BZx-000387-FO; Wed, 06 Jul 2022 21:24:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o9BZr-0004cc-Kg; Wed, 06 Jul 2022 21:24:51 +0100
Date:   Wed, 6 Jul 2022 21:24:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH RFC net-next v2 0/5] net: dsa: always use phylink
Message-ID: <YsXvk/GlFtswFyvk@shell.armlinux.org.uk>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <7fe6b661-06b9-96dd-e064-1db23a9eaae7@gmail.com>
 <20220706101459.tahby2xpm3e7okjz@skbuf>
 <d65824fc-a139-0430-5550-481dd202ad34@gmail.com>
 <4ec0461c-0000-ff8c-4368-5d68d70b894e@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ec0461c-0000-ff8c-4368-5d68d70b894e@hauke-m.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 09:05:22PM +0200, Hauke Mehrtens wrote:
> On 7/6/22 18:27, Florian Fainelli wrote:
> > On 7/6/22 03:14, Vladimir Oltean wrote:
> > > Hi Florian,
> > > 
> > > On Tue, Jul 05, 2022 at 09:42:33AM -0700, Florian Fainelli wrote:
> > > > On 7/5/22 02:46, Russell King (Oracle) wrote:
> > > > > A new revision of the series which incorporates changes that Marek
> > > > > suggested. Specifically, the changes are:
> > > > > 
> > > > > 1. Patch 2 - use the phylink_get_caps method in mv88e6xxx to get the
> > > > >      default interface rather than re-using port_max_speed_mode()
> > > > > 
> > > > > 2. Patch 4 - if no default interface is provided, use the supported
> > > > >      interface mask to search for the first interface that gives the
> > > > >      fastest speed.
> > > > > 
> > > > > 3. Patch 5 - now also removes the port_max_speed_mode() method
> > > > 
> > > > This was tested with bcm_sf2.c and b53_srab.b and did not cause
> > > > regressions,
> > > > however we do have a 'fixed-link' property for the CPU port
> > > > (always have had
> > > > one), so there was no regression expected.
> > > 
> > > What about arch/arm/boot/dts/bcm47189-tenda-ac9.dts?
> > 
> > You found one of the devices that I do not have access to and did not
> > test, thanks. We do expect to run the port at 2GBits/sec on these
> > devices however there is no "official" way to advertise that a port can
> > run at 2Gbits/sec, as this is not even a "sanctioned" speed. I do have a
> > similar device however, so let me run some more tests, we won't see a
> > regression however since we do not use the NATP accelerator which would
> > be the reason to run the port at 2Gbits/sec.
> 
> I will try this change on some devices with the lantiq gswip driver at the
> weekend.
> 
> On the SoC supported by the lantiq gswip driver the switch is integrated in
> the SoC and there is a internal link with more than 1GBit/s connecting the
> switch to the rest of the system. I think it is also around 2GBit/s. We can
> not configure the interface speed or many other interface settings for the
> link between the switch and the CPU. How should the device tree ideally look
> for this setup?

I think this falls into Andrew's "don't specify anything" category,
which means that we should default to the maximum speed for the
port - which is in this case quite clearly fixed at whatever the
internal link actually is.

From the get_caps() function, the fastest speed apparently supported is
1Gbps. I'm guessing the CPU port is one of ports 2..5 on xrx200 and
1..5 on xrx300 - in which case, PHY_INTERFACE_MODE_INTERNAL is likely
to be selected, which seems appropriate given what you've said above.
(PHY_INTERFACE_MODE_INTERNAL will be the first interface type found
that will give the highest speed as it permits any speed given in the
mac_capabilities.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
