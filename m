Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4024F435A
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382878AbiDEUE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454149AbiDEP56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:57:58 -0400
X-Greylist: delayed 560 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Apr 2022 08:03:20 PDT
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD44169B0D
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 08:03:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 76C639C02A9;
        Tue,  5 Apr 2022 10:53:58 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id UaydEvA-ZPlg; Tue,  5 Apr 2022 10:53:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id E66609C02C7;
        Tue,  5 Apr 2022 10:53:57 -0400 (EDT)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Hw-FWC8dZu6w; Tue,  5 Apr 2022 10:53:57 -0400 (EDT)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id BDE4C9C02A9;
        Tue,  5 Apr 2022 10:53:57 -0400 (EDT)
Date:   Tue, 5 Apr 2022 10:53:57 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     Prasanna VengateshanVaradharajan 
        <Prasanna.VengateshanVaradharajan@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        hkallweit1 <hkallweit1@gmail.com>, UNGLinuxDriver@microchip.com
Message-ID: <899950262.754511.1649170437739.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <5a13e486f5eb8c15ae536bde714be873aa22aeb9.camel@microchip.com>
References: <20220207174532.362781-1-enguerrand.de-ribaucourt@savoirfairelinux.com> <20220207174532.362781-2-enguerrand.de-ribaucourt@savoirfairelinux.com> <YgGrNWeq6A7Rw3zG@lunn.ch> <2044096516.560385.1644309521228.JavaMail.zimbra@savoirfairelinux.com> <YgJshWvkCQLoGuNX@lunn.ch> <42ea108673200b3076d1b4f8d1fcb221b42d8e32.camel@microchip.com> <5a13e486f5eb8c15ae536bde714be873aa22aeb9.camel@microchip.com>
Subject: Re: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch
 PHY support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.15_GA_4203 (ZimbraWebClient - FF97 (Linux)/8.8.15_GA_4232)
Thread-Topic: micrel: add Microchip KSZ 9897 Switch PHY support
Thread-Index: AQHYHO267iebaZNvCk2PCKSscj7+r6yM7FiAgAACbwBBGDZNrQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Original Message -----
> From: "Prasanna VengateshanVaradharajan" <Prasanna.VengateshanVaradharajan@microchip.com>
> To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>, "Andrew Lunn" <andrew@lunn.ch>
> Cc: "linux" <linux@armlinux.org.uk>, "netdev" <netdev@vger.kernel.org>, "hkallweit1" <hkallweit1@gmail.com>,
> UNGLinuxDriver@microchip.com
> Sent: Thursday, February 10, 2022 4:38:59 PM
> Subject: Re: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897 Switch PHY support

> On Thu, 2022-02-10 at 21:00 +0530, Prasanna Vengateshan wrote:
> > On Tue, 2022-02-08 at 14:13 +0100, Andrew Lunn wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> > > content is safe

> > > On Tue, Feb 08, 2022 at 03:38:41AM -0500, Enguerrand de Ribaucourt wrote:
> > > > ----- Original Message -----
> > > > > From: "Andrew Lunn" <andrew@lunn.ch>
> > > > > To: "Enguerrand de Ribaucourt" <
> > > > > enguerrand.de-ribaucourt@savoirfairelinux.com>
> > > > > Cc: "netdev" <netdev@vger.kernel.org>, "hkallweit1"
> > > > > <hkallweit1@gmail.com>, "linux" <linux@armlinux.org.uk>
> > > > > Sent: Tuesday, February 8, 2022 12:28:53 AM
> > > > > Subject: Re: [PATCH v2 1/2] net: phy: micrel: add Microchip KSZ 9897
> > > > > Switch PHY support

> > > > > > + /* KSZ8081A3/KSZ8091R1 PHY and KSZ9897 switch share the same
> > > > > > + * exact PHY ID. However, they can be told apart by the default value
> > > > > > + * of the LED mode. It is 0 for the PHY, and 1 for the switch.
> > > > > > + */
> > > > > > + ret &= (MICREL_KSZ8081_CTRL2_LED_MODE0 |
> > > > > > MICREL_KSZ8081_CTRL2_LED_MODE1);
> > > > > > + if (!ksz_8081)
> > > > > > + return ret;
> > > > > > + else
> > > > > > + return !ret;

> > > > > What exactly does MICREL_KSZ8081_CTRL2_LED_MODE0 and
> > > > > MICREL_KSZ8081_CTRL2_LED_MODE1 mean? We have to be careful in that
> > > > > there could be use cases which actually wants to configure the
> > > > > LEDs. There have been recent discussions for two other PHYs recently
> > > > > where the bootloader is configuring the LEDs, to something other than
> > > > > their default value.

> > > > Those registers configure the LED Mode according to the KSZ8081 datasheet:
> > > > [00] = LED1: Speed LED0: Link/Activity
> > > > [01] = LED1: Activity LED0: Link
> > > > [10], [11] = Reserved
> > > > default value is [00].

> > > > Indeed, if the bootloader changes them, we would match the wrong
> > > > device. However, I closely examined all the registers, and there is no
> > > > read-only bit that we can use to differentiate both models. The
> > > > LED mode bits are the only ones that have a different default value on the
> > > > KSZ8081: [00] and the KSZ9897: [01]. Also, the RMII registers are not
> > > > documented in the KSZ9897 datasheet so that value is not guaranteed to
> > > > be [01] even though that's what I observed.

> > > > Do you think we should find another way to match KSZ8081 and KSZ9897?
> > > > The good news is that I'm now confident about the phy_id emitted by
> > > > both models.

> > > Lets try asking Prasanna Vengateshan, who is working on other
> > > Microchip switches and PHYs at Microchip.

> > > Andrew

> > I have already forwarded to the team who worked on the KSZ9897 PHY and added
> > here (part of UNGLinuxDriver).

> > Prasanna V

> Added right email id..

Hello Prasanna,

Have you had any luck contacting the people working on the KSZ9897
PHY? As stated with more details in my previous emails, the RMII phy interface of
the KSZ9897 seems to share the same phy_id as the KSZ8081. However, a different
ksphy_driver struct must be used for the KSZ9897 PHY to work.

Thanks,
Enguerrand
