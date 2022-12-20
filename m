Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8BD065248F
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 17:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbiLTQWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 11:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbiLTQWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 11:22:06 -0500
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2FA1AD87
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 08:22:03 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id A5DD49C08BF;
        Tue, 20 Dec 2022 11:22:02 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id n3erLLeromzg; Tue, 20 Dec 2022 11:22:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id B99F89C08C6;
        Tue, 20 Dec 2022 11:22:01 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com B99F89C08C6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1671553321; bh=+tqtDyiRqMQdxrCuEpQqZyTB7/NCFsBV672nlzL3N5U=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=GtcGMFx2Uo4SV4ZZX1u/kai28GayiPHLYzkzSIvxriePnjKdYpRL+j7enSTiJBvkF
         i1RNPvwsQw0u4bnIdElcLUSgh7xx5OU/k3Inv0PvInOtjvUuDrUhbp8Go8OTe465t+
         p7cWEHlFeeqB4sK75R03DsgW/TfoDbZ7Is6ItT/6oJ9sBHRB26Kg1ZCVGMAS6gDDmW
         mo49PGjcE2zYxTVo2Ix2i0fYXJKAfGY9KSmhL0huz7WXvfB6g64SLkkoUI1XJcDRC0
         w26AkGi1aCrKOMlpzOivd4/gLi8uXu02uZm78hltc6t3BSy1kjMrdWhJ0/oR3k3ck2
         UMbNKX1DuniZA==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id c6IXEWRud7v4; Tue, 20 Dec 2022 11:22:01 -0500 (EST)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 928F69C08B9;
        Tue, 20 Dec 2022 11:22:01 -0500 (EST)
Date:   Tue, 20 Dec 2022 11:22:01 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        woojung huh <woojung.huh@microchip.com>,
        davem <davem@davemloft.net>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>
Message-ID: <1201721565.475609.1671553321565.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <Y6HfK7bnkL2uyp3m@shell.armlinux.org.uk>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com> <20221220131921.806365-2-enguerrand.de-ribaucourt@savoirfairelinux.com> <7ac42bd4-3088-5bd5-dcfc-c1e74466abb5@gmail.com> <1721908413.470634.1671548576554.JavaMail.zimbra@savoirfairelinux.com> <Y6HfK7bnkL2uyp3m@shell.armlinux.org.uk>
Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
 phy_disable_interrupts()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.15_GA_4481 (ZimbraWebClient - FF107 (Linux)/8.8.15_GA_4481)
Thread-Topic: add EXPORT_SYMBOL to phy_disable_interrupts()
Thread-Index: PbYsfUAVu4k4vJpy5CrjHK9frJivsQ==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Original Message -----
> From: "Russell King (Oracle)" <linux@armlinux.org.uk>
> To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>
> Cc: "Heiner Kallweit" <hkallweit1@gmail.com>, "netdev" <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>,
> "woojung huh" <woojung.huh@microchip.com>, "davem" <davem@davemloft.net>, "UNGLinuxDriver"
> <UNGLinuxDriver@microchip.com>, "Andrew Lunn" <andrew@lunn.ch>
> Sent: Tuesday, December 20, 2022 5:13:31 PM
> Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to phy_disable_interrupts()

> Hi,

> On Tue, Dec 20, 2022 at 10:02:56AM -0500, Enguerrand de Ribaucourt wrote:
> > > From: "Heiner Kallweit" <hkallweit1@gmail.com>
> > > To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>,
> > > "netdev" <netdev@vger.kernel.org>
> > > Cc: "Paolo Abeni" <pabeni@redhat.com>, "woojung huh"
> > > <woojung.huh@microchip.com>, "davem" <davem@davemloft.net>, "UNGLinuxDriver"
> > > <UNGLinuxDriver@microchip.com>, "Andrew Lunn" <andrew@lunn.ch>, "Russell King -
> > > ARM Linux" <linux@armlinux.org.uk>
> > > Sent: Tuesday, December 20, 2022 3:40:15 PM
> > > Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
> > > phy_disable_interrupts()

> > > On 20.12.2022 14:19, Enguerrand de Ribaucourt wrote:
> > > > It seems EXPORT_SYMBOL was forgotten when phy_disable_interrupts() was
> > > > made non static. For consistency with the other exported functions in
> > > > this file, EXPORT_SYMBOL should be used.

> > > No, it wasn't forgotten. It's intentional. The function is supposed to
> > > be used within phylib only.

> > > None of the phylib maintainers was on the addressee list of your patch.
> > > Seems you didn't check with get_maintainers.pl.

> > > You should explain your use case to the phylib maintainers. Maybe lan78xx
> > > uses phylib in a wrong way, maybe an extension to phylib is needed.
> > > Best start with explaining why lan78xx_link_status_change() needs to
> > > fiddle with the PHY interrupt. It would help be helpful to understand
> > > what "chip" refers to in the comment. The MAC, or the PHY?
> > > Does the lan78xx code assume that a specific PHY is used, and the
> > > functionality would actually belong to the respective PHY driver?

> > Thank you for your swift reply,

> > The requirement to toggle the PHY interrupt in lan78xx_link_status_change() (the
> > LAN7801 MAC driver) comes from a workaround by the original author which resets
> > the fixed speed in the PHY when the Ethernet cable is swapped. According to his
> > message, the link could not be correctly setup without this workaround.

> > Unfortunately, I don't have the cables to test the code without the workaround
> > and it's description doesn't explain what problem happens more precisely.

> > The PHY the original author used is a LAN8835. The workaround code directly
> > modified the interrupt configuration registers of this LAN8835 PHY within
> > lan78xx_link_status_change(). This caused problems if a different PHY was used
> > because the register at this address did not correspond to the interrupts
> > configuration. As suggested by the lan78xx.c maintainer, a generic function
> > should be used instead to toggle the interrupts of the PHY. However, it seems
> > that maybe the MAC driver shouldn't meddle with the PHY's interrupts according
> > to you. Would you consider this use case a valid one?

> This sounds to me like you're just trying to get a workaround merged
> upstream using a different approach, but you can't actually test to
> see whether it does work or not. Would that be a fair assessment?

> Do you know anyone who would be able to test? If not, I would suggest
> not trying to upstream code for a workaround that can't be tested as
> working.

Hi,

I definitely agree with you that the workaround code can't be moved from
lan78xx.c to microchip.c without testing. Unfortunately, I don't know
who to contact to test on the hardware.

In the meantime, I suggest removing the workaround from lan78xx.c since
it is not compatible with most of the PHYs users of lan78xx.c could use.
Some previous messages on the mailing list attests to it.
My Patch v1 could also do it, since it keeps the workaround but limits
it with the phy_id.

Regards,
Enguerrand

> Thanks.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
