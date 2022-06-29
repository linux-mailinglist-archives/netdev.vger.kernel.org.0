Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998B555FC1C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiF2Je4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiF2Jez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:34:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9383B037
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FnVMalTUeoK5NYDPcJD2pQwPBID5bcHUMECiiKgpzDc=; b=ZG29/l86CiXjrqTr2ipqeRsP1G
        aa55dDEKNASFaNRo6wWPPA9DpBVetuCyPO7DZSh2R3eUJqnsGekbthqj2g2ocoZnMlp/EySXnZD/K
        6iqyUWPTtHMFXPXSv7heax1a7CV8mtw+sclSEDnN1HXu9c3RtGRMCmPFPVRTN5Z3br55Eul3Ec7U4
        48OMlof6o0jGU8vrSCo1C7XTUPvHUL/d+AGf81FC4RwpMWHdxJzziqYvsFuwEwXKvbLdlXIqfTSXy
        LMNBjkDP4JdbPnLYYUqmWm8Dg7V2lF1z0fKdYM6WkV16dHaNxUJzFvWpUGzq4/n3I7y3InYwugHUt
        KVfXyXRg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33084)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o6U5h-0002kp-Ux; Wed, 29 Jun 2022 10:34:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o6U5c-0005jm-5C; Wed, 29 Jun 2022 10:34:28 +0100
Date:   Wed, 29 Jun 2022 10:34:28 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
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
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH RFC net-next 0/4] net: dsa: always use phylink
Message-ID: <YrwcpDbmnYpfJuYM@shell.armlinux.org.uk>
References: <YrWi5oBFn7vR15BH@shell.armlinux.org.uk>
 <YrtvoRhUK+4BneYC@shell.armlinux.org.uk>
 <Yrv8snvIChmoNPwh@lunn.ch>
 <20220629112750.4e0ae994@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220629112750.4e0ae994@thinkpad>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 11:27:50AM +0200, Marek Behún wrote:
> On Wed, 29 Jun 2022 09:18:10 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > > I should point out that if a DSA port can be programmed in software to
> > > support both SGMII and 1000baseX, this will end up selecting SGMII
> > > irrespective of what the hardware was wire-strapped to and how it was
> > > initially configured. Do we believe that would be acceptable?  
> > 
> > I'm pretty sure the devel b board has 1000BaseX DSA links between its
> > two switches. Since both should end up SGMII that should be O.K.
> > 
> > Where we potentially have issues is 1000BaseX to the CPU. This is not
> > an issue for the Vybrid based boards, since they are fast Ethernet
> > only, but there are some boards with an IMX6 with 1G ethernet. I guess
> > they currently use 1000BaseX, and the CPU side of the link probably
> > has a fixed-link with phy-mode = 1000BaseX. So we might have an issue
> > there.
> 
> If one side of the link (e.g. only the CPU eth interface) has 1000base-x
> specified in device-tree explicitly, the code should keep it at
> 1000base-x for the DSA CPU port...

So does that mean that, if we don't find a phy-mode property in the cpu
port node, we should chase the ethernet property and check there? This
seems to be adding functionality that wasn't there before.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
