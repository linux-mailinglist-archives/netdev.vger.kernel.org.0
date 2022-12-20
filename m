Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71207652369
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 16:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiLTPDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 10:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbiLTPDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 10:03:04 -0500
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69118B6E
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 07:02:59 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 64CBE9C08B5;
        Tue, 20 Dec 2022 10:02:57 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id R68cp0FWUWW3; Tue, 20 Dec 2022 10:02:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id BD2809C08BA;
        Tue, 20 Dec 2022 10:02:56 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com BD2809C08BA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1671548576; bh=N069hIUKR9+LPD8r5eCPrDASFh+SBqcOjod6EOfj9ec=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=G4s9q/p4pe2yAaxuGZbuWheJ2Y6SaSWdi8Z19F+JLbGUEnlHLxra6ewZ/UDNonnzn
         J15UhywXUG3tMn5J60TZBjHXCT6riEcd5HcE3bwIIt/XAYYHnx/P6nLbDvpFUJMXoE
         BozeLj8+Z+KyI35jB/mRYBlH0GMoOhEgrTCJ3jJWYoGiPPqjoLKaRkMQGtmEAT+X2M
         ZtEwM4PETga0vKZoQNuQ9YH+csYNlh/Vq3E00tM/dPBWFJeZ6a9/u7a3jlrql+eOcN
         mnSQYP8e2SPdSyBUGxo49fQW4nYwac4El/uvPjhrVKKgOS81/E61GfqxkRUfb3tvdf
         rzZZ0T7EV/RPA==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CSakpillc6io; Tue, 20 Dec 2022 10:02:56 -0500 (EST)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 91CE39C08B5;
        Tue, 20 Dec 2022 10:02:56 -0500 (EST)
Date:   Tue, 20 Dec 2022 10:02:56 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        woojung huh <woojung.huh@microchip.com>,
        davem <davem@davemloft.net>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <1721908413.470634.1671548576554.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <7ac42bd4-3088-5bd5-dcfc-c1e74466abb5@gmail.com>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com> <20221220131921.806365-2-enguerrand.de-ribaucourt@savoirfairelinux.com> <7ac42bd4-3088-5bd5-dcfc-c1e74466abb5@gmail.com>
Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
 phy_disable_interrupts()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.15_GA_4481 (ZimbraWebClient - FF107 (Linux)/8.8.15_GA_4481)
Thread-Topic: add EXPORT_SYMBOL to phy_disable_interrupts()
Thread-Index: BhkIgmF++xn3tJ7yW4FptRdtRLL8oQ==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: "Heiner Kallweit" <hkallweit1@gmail.com>
> To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>,
> "netdev" <netdev@vger.kernel.org>
> Cc: "Paolo Abeni" <pabeni@redhat.com>, "woojung huh"
> <woojung.huh@microchip.com>, "davem" <davem@davemloft.net>, "UNGLinuxDriver"
> <UNGLinuxDriver@microchip.com>, "Andrew Lunn" <andrew@lunn.ch>, "Russell King -
> ARM Linux" <linux@armlinux.org.uk>
> Sent: Tuesday, December 20, 2022 3:40:15 PM
> Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
> phy_disable_interrupts()

> On 20.12.2022 14:19, Enguerrand de Ribaucourt wrote:
> > It seems EXPORT_SYMBOL was forgotten when phy_disable_interrupts() was
> > made non static. For consistency with the other exported functions in
> > this file, EXPORT_SYMBOL should be used.

> No, it wasn't forgotten. It's intentional. The function is supposed to
> be used within phylib only.

> None of the phylib maintainers was on the addressee list of your patch.
> Seems you didn't check with get_maintainers.pl.

> You should explain your use case to the phylib maintainers. Maybe lan78xx
> uses phylib in a wrong way, maybe an extension to phylib is needed.
> Best start with explaining why lan78xx_link_status_change() needs to
> fiddle with the PHY interrupt. It would help be helpful to understand
> what "chip" refers to in the comment. The MAC, or the PHY?
> Does the lan78xx code assume that a specific PHY is used, and the
> functionality would actually belong to the respective PHY driver?

Thank you for your swift reply,

The requirement to toggle the PHY interrupt in lan78xx_link_status_change() (the
LAN7801 MAC driver) comes from a workaround by the original author which resets
the fixed speed in the PHY when the Ethernet cable is swapped. According to his
message, the link could not be correctly setup without this workaround.

Unfortunately, I don't have the cables to test the code without the workaround
and it's description doesn't explain what problem happens more precisely.

The PHY the original author used is a LAN8835. The workaround code directly
modified the interrupt configuration registers of this LAN8835 PHY within
lan78xx_link_status_change(). This caused problems if a different PHY was used
because the register at this address did not correspond to the interrupts
configuration. As suggested by the lan78xx.c maintainer, a generic function
should be used instead to toggle the interrupts of the PHY. However, it seems
that maybe the MAC driver shouldn't meddle with the PHY's interrupts according
to you. Would you consider this use case a valid one?

Enguerrand

> > Fixes: 3dd4ef1bdbac ("net: phy: make phy_disable_interrupts() non-static")
>> Signed-off-by: Enguerrand de Ribaucourt
> > <enguerrand.de-ribaucourt@savoirfairelinux.com>
> > ---
> > drivers/net/phy/phy.c | 1 +
> > 1 file changed, 1 insertion(+)

> > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > index e5b6cb1a77f9..33250da76466 100644
> > --- a/drivers/net/phy/phy.c
> > +++ b/drivers/net/phy/phy.c
> > @@ -992,6 +992,7 @@ int phy_disable_interrupts(struct phy_device *phydev)
> > /* Disable PHY interrupts */
> > return phy_config_interrupt(phydev, PHY_INTERRUPT_DISABLED);
> > }
> > +EXPORT_SYMBOL(phy_disable_interrupts);

> > /**
> > * phy_interrupt - PHY interrupt handler
