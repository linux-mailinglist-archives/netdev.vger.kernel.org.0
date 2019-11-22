Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C54A1079DF
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKVVNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:13:13 -0500
Received: from mail-ed1-f47.google.com ([209.85.208.47]:39875 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVVNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 16:13:12 -0500
Received: by mail-ed1-f47.google.com with SMTP id n26so7224430edw.6
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 13:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aQd+kf9RxjV+s7nFIj1cBhFE/S5ZU7UYAG32s3ExHbw=;
        b=r2wMfHrSPj/oHMzRrA3F6xujp6BKO6rmPaBl+4d6GPvpR67VktOOfD0kYbKemgzOiz
         SWXOGZSCJCdkzSwl9m6104NFjKVKQ1aTyi4waZctTfTX3PasDNp4/MMHG8EduUOXcnxE
         BCXgHAyr+byfr6hxQl3GwZkPmZi7pTkIBKPCpYROWqhs9S5J6USM8+85dzr1ZfNTobJ2
         uGkudnwY7FTBgAFMO6K/xE7GZ8LyIOPXbI8sGfoKWZs2lPgJHjxJgqT3NuhNBbmD4Gpv
         /Pvmmk+OPp6VTx/V0jDS/tp/IEayYWcbADe4YXdgYHRa5Rmxk29V8QVocJKMasqIJvjg
         5Lgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aQd+kf9RxjV+s7nFIj1cBhFE/S5ZU7UYAG32s3ExHbw=;
        b=X5CBh+xoadvU4GrerVhs6hObhgoma1RRtI3xu3wYvjSiSTh5242m14TINXjk+GMjYa
         oAGnXinGGsnOq9+Iszexlq875sTkjaEcE0ZZaTtaOUouo+0l5YlmtVxMsYAR6415Red5
         YjEQCEVZxsvc+8M9GD2cXORfAkrvROSOxfzMObfOv668Con4Q20hGoNzyPag/rEAicQ5
         +DL26cjCR9foEV4vllVQsNG5AVJT5CTIPKVy6+lWUT49hRacgdtxsAhvWtFscyyDCXdG
         fBzVmYoyYl1lGkO9t5PC2J2EEuHYuJEwSTjEXhh2I1BIK0KaBD7/+zgyvc6JsylYFdQF
         w9ug==
X-Gm-Message-State: APjAAAVMg+4uzn80ulpnFvLwjPdmyY4aPDMnxHASysV8QbW45hz/ZBQA
        I2olV6igXb68kEUvSBhv+46HRqwhGyvrTdurxeI=
X-Google-Smtp-Source: APXvYqyL6IG333uPwKAzEAZ4PougD37buxDOv6oj3j3bg+i00RITjRgsFIT2Pp+hVV6ek7AS9aXMOEBG13JLiW5iWuw=
X-Received: by 2002:a50:91c4:: with SMTP id h4mr3746699eda.36.1574457189381;
 Fri, 22 Nov 2019 13:13:09 -0800 (PST)
MIME-Version: 1.0
References: <7b6fc87b-b6d8-21e6-bd8d-74c72b3d63a7@nxp.com> <20191122150932.GC6602@lunn.ch>
 <a6f797cf-956e-90d9-0bb3-11e752b8a818@nxp.com> <20191122174229.GG6602@lunn.ch>
 <69281eea-6fca-e35c-2d62-167b31361908@nxp.com>
In-Reply-To: <69281eea-6fca-e35c-2d62-167b31361908@nxp.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 22 Nov 2019 23:12:58 +0200
Message-ID: <CA+h21ho-mPcFj=VLm6Er4gSq2yyZBFyE9z3r3B+k4W3ay+Kb3g@mail.gmail.com>
Subject: Re: binding for scanning a MDIO bus
To:     Alexandru Marginean <alexandru.marginean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 at 22:43, Alexandru Marginean
<alexandru.marginean@nxp.com> wrote:
>
> On 11/22/2019 6:42 PM, Andrew Lunn wrote:
> >>> Hi Alexandru
> >>>
> >>> You often see the bus registered using mdiobus_register(). That then
> >>> means a scan is performed and all phys on the bus found. The MAC
> >>> driver then uses phy_find_first() to find the first PHY on the bus.
> >>> The danger here is that the hardware design changes, somebody adds a
> >>> second PHY, and it all stops working in interesting and confusing
> >>> ways.
> >>>
> >>> Would this work for you?
> >>>
> >>>         Andrew
> >>>
> >>
> >> How does the MAC get a reference to the mdio bus though, is there some
> >> way to describe this relationship in the DT?  I did say that Eth and
> >> mdio are associated and they are, but not in the way Eth would just know
> >> without looking in the DT what mdio that is.
> >
> > What i described is generally used for PCIe card, USB dongles,
> > etc. The MAC driver is the one registering the MDIO bus, so it has
> > what it needs. Such hardware is also pretty much guaranteed to only
> > have one PHY on the bus, so phy_find_first() is less dangerous.
>
> I get that, it's clear how it works if it's all part of the same device,
> but that's not applicable to our QDS boards.  These are pretty much the
> opposite of the PCIe cards and dongles.  They are designed to support as
> many combinations as possible of interfaces, protocols PHYs and so on.
> What I'm trying to do is to have the infrastructure in place so that
> users of these boards don't have to rebuild both U-Boot and Linux binary
> to get an Ethernet interface running with a different PHY card.
>
> >> Mdio buses of slots/cards are defined in DT under the mdio mux.  The mux
> >> itself is accessed over I2C and its parent-mdio is a stand-alone device
> >> that is not associated with a specific Ethernet device.  And on top of
> >> that, based on serdes configuration, some Eth interfaces may end up on a
> >> different slot and for that I want to apply a DT overlay to set the
> >> proper Eth/mdio association.
> >>
> >> Current code allows me to do something like this, as seen by Linux on boot:
> >> / {
> >> ....
> >>      mdio-mux {
> >>              /* slot 1 */
> >>              mdio@4 {
> >>                      slot1_phy0: phy {
> >>                              /* 'reg' missing on purpose */
> >>                      };
> >>              };
> >>      };
> >> ....
> >> };
> >>
> >> &enetc_port0 {
> >>      phy-handle = <&slot1_phy0>;
> >>      phy-mode = "sgmii";
> >> };
> >>
> >> But the binding does not allow this, 'reg' is a required property of
> >> phys.  Is this kind of DT structure acceptable even if it's not
> >> compliant to the binding?  Assuming it's fine, any thoughts on making
> >> this official in the binding?  If it's not, are there alternative
> >> options for such a set-up?
> >
> > In principle, this is O.K. The code seems to support it, even if the
> > binding does not give it as an option. It get messy when you have
> > multiple PHYs on the bus though. And if you are using DT, you are
> > supposed to know what the hardware is. Since you don't seems to know
> > what your hardware is, you are going to spam your kernel logs with
> >
> >                          /* be noisy to encourage people to set reg property */
> >                          dev_info(&mdio->dev, "scan phy %pOFn at address %i\n",
> >                                   child, addr);
> >
> > which i agree with. >
> >        Andrew
> >
>
> Yeah, specifically on these QDS boards we're using DT and we can't
> practically tell kernel up front what PHY is going to be present.  I
> noticed the messages, having some verbosity caused by PHY scanning is
> fine.  It's definitely causing much less pain than editing DTs to
> describe what card is plugged in in which slot.  Ironically these cards
> physically look like PCIe cards, although they are not.
>
> OK, I'll go with PHY nodes with missing 'reg' properties.
>
> Thanks!
> Alex

Hi Alex,

Let's say there is a QSGMII PHY on such a riser card. There is a
single SerDes lane but on the card there is a PHY chip that acts as 4
PHYs in the same package. Each MAC needs to talk to its own PHY
(separate addresses) in the package. How would your proposed bindings
identify which MAC needs to talk to which PHY to get its correct link
status?

Thanks,
-Vladimir
