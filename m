Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7406E455DDF
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhKROXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbhKROXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 09:23:44 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CF9C0FD238;
        Thu, 18 Nov 2021 06:20:43 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x15so27795104edv.1;
        Thu, 18 Nov 2021 06:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=J3cGlN2KXuV9opgm+aB2NzNfTAZSU0XmtFn6B7EFXis=;
        b=FU/dWTe9sueJLnDLmMZUXxbHPEWBCHYWWzKosVmq+MDhnKLy7UipNSk3K3TulD4B1N
         ebEhjdO0S+J53DLXuN1DyvetbWSUbDGJnnC5sUzckw7HZxU4XQd+1lUhoZEv4Aqn052c
         +67xppxqY4Cl4oRHpyjHU+uuZBxB6D2d/Wke/uexldTM6oQIdYkdlVZstKTuhrxlpjup
         ZlZbusXm0xn66/soK48bs5YitCXDs/9EnYZxAYO1lZSCK7Te/LL0myMi8grUPHlDDwBt
         vztlTK0NhFX+Yz4ED6C3LVDRXHfbsEXSb1D3zDpS3/zgaUymDqoWJy892GeElDZVQUTG
         SE4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=J3cGlN2KXuV9opgm+aB2NzNfTAZSU0XmtFn6B7EFXis=;
        b=dVf5khHylWu6SL49IMKvh5A36ZQG4d57AD0YJqFUPJ22FSiYTYlR1sGzaY8UtjyWTD
         V4u7c8Oz/dIpSblS2OR3A5YWLLEAL4sndRs1DqaSVYg3vsfGIaOjb+gAU1v6xIbW/Pey
         xXICsUleNjhkCKKBJCOh+QhIIZ3vDkxgsjaZw+P9e6PkOJ7M0j1hBJQBV+3m0yK+mAif
         r1MbeCewJGaGubriK9U7pdI2oipb4Sot8Y8UQeLTcJewM+rHvqjetAruF/T1sah2kQJ7
         2fF0AhpP928dpNkigiw7uUIDaNeO5hyyJSs6JxhpIZf4ZzqVtnc5F+XUrprduKfS2u6P
         kQ/w==
X-Gm-Message-State: AOAM532MUwsPtazP3Y66zqXm+NKcADjlVYNU7jFm9ATK9y3ZF1dVO5oS
        9E5zGt7IDPneTxvhWHGv57NyTAzdch8=
X-Google-Smtp-Source: ABdhPJwzrKj3RiUS7+Ps+3jyCuqQpkrbYwzlw6aFePObg0vEOz2r0EQFyXMPLaDgUcvXlrXMXAOt/w==
X-Received: by 2002:a05:6402:270d:: with SMTP id y13mr12190449edd.362.1637245241465;
        Thu, 18 Nov 2021 06:20:41 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id b11sm1886501ede.62.2021.11.18.06.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 06:20:41 -0800 (PST)
Date:   Thu, 18 Nov 2021 16:20:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net: phy: marvell10g: select host interface
 configuration
Message-ID: <20211118142039.uocgddbpplwwsfdk@skbuf>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-9-kabel@kernel.org>
 <20211118120334.jjujutp5cnjgwjq2@skbuf>
 <YZZTinTgX3SPWIZM@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZZTinTgX3SPWIZM@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 01:22:18PM +0000, Russell King (Oracle) wrote:
> On Thu, Nov 18, 2021 at 02:03:34PM +0200, Vladimir Oltean wrote:
> > On Wed, Nov 17, 2021 at 11:50:50PM +0100, Marek Behún wrote:
> > > +static int mv3310_select_mactype(unsigned long *interfaces)
> > > +{
> > > +	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
> > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > > +		 test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > > +		 test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > > +		 test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces))
> > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> > > +	else
> > > +		return -1;
> > > +}
> > > +
> > 
> > I would like to understand this heuristic better. Both its purpose and
> > its implementation.
> > 
> > It says:
> > (a) If the intersection between interface modes supported by the MAC and
> >     the PHY contains USXGMII, then use USXGMII as a MACTYPE
> > (b) Otherwise, if the intersection contains both 10GBaseR and SGMII, then
> >     use 10GBaseR as MACTYPE
> > (...)
> > (c) Otherwise, if the intersection contains just 10GBaseR (no SGMII), then
> >     use 10GBaseR with rate matching as MACTYPE
> > (...)
> > (d) Otherwise, if the intersection contains just SGMII (no 10GBaseR), then
> >     use 10GBaseR as MACTYPE (no rate matching).
> 
> What is likely confusing you is a misinterpretation of the constant.
> MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER actually means the PHY will
> choose between 10GBASE-R, 5GBASE-R, 2500BASE-X, and SGMII depending
> on the speed negotiated by the media. In this setting, the PHY
> dictates which interface mode will be used.
> 
> I could have named "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER" as
> "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_5GBASER_2500BASEX_SGMII_AUTONEG_ON".
> Similar with "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_NO_SGMII_AN", which
> would be
> "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_5GBASER_2500BASEX_SGMII_AUTONEG_OFF".
> And "MV_V2_3310_PORT_CTRL_MACTYPE_XAUI" would be
> "MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_5GBASER_2500BASEX_SGMII_AUTONEG_ON".
> 
> Clearly using such long identifiers would have been rediculous,
> especially the second one at 74 characters.

True, but at least there could be a comment above each definition.
There's no size limit to that.

> > First of all, what is MACTYPE exactly? And what is the purpose of
> > changing it? What would happen if this configuration remained fixed, as
> > it were?
> 
> The PHY defines the MAC interface mode depending on the MACTYPE
> setting selected and the results of the media side negotiation.
> 
> I think the above answers your remaining questions.

Ok, so going back to case (d). You said that the full name would be
MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_5GBASER_2500BASEX_SGMII_AUTONEG_ON.
This means that when the only interface mode supported by the host would
be SGMII, the PHY's MACTYPE is still configured to use 2500basex,
5gbaser, 10gbaser for the higher link speeds. Clearly this won't work.
But on the other hand, the phylink validate method will remove
2500baseT, 5000baseT, 1000baseT from the advertising mask of the PHY, so
the system will never end up operating at those speeds, so it should be fine.



The reason why I'm looking at these patches is to see whether they would
bring something useful to Aquantia PHYs. These come with firmware on a
flash that is customized by Aquantia themselves based on the specifications
of a single board. These PHYs have an ability which is very similar to
what I'm seeing here, which is to select, for each negotiated link speed
on the media side, the SERDES protocol to use on the system side. This
is pre-programmed by the firmware, but could be fixed up by the
operating system if done carefully.

The way Layerscape boards use Aquantia PHYs is to always select the
"rate matching" option and keep the SERDES protocol fixed, just
configure the mini MAC inside the PHY to emit PAUSE frames towards the
system to keep the data rate under control. We would be using these PHYs
with the generic C45 driver, which would be mostly enough except for
lack of PHY interrupts, because the firmware already configures
everything.

But on the other hand it gets a bit tiring, especially for PHYs on riser
cards, to have to change firmware in order to test a different SERDES
protocol, so we were experimenting with some changes in the PHY driver
that would basically keep the firmware image fixed, and just fix up the
configuration it made, and do things like "use 2500base-x for the
2500base-T speed, and sgmii for 1000base-T/100base-TX". The ability for
a PHY to work on a board where its firmware image wasn't specifically
designed for it comes in handy sometimes.

I was reluctant to submit any changes to the Aquantia PHY driver because
we don't really have any guarantees that we wouldn't break any system
that uses it. I do know that there are users who do expect SERDES
protocol changes currently, because I do see that aqr107_read_status()
checks for a possibly modified phydev->interface. But without the
ability of knowing what SERDES protocols does the system-side support,
it is pretty difficult to modify the SERDES protocol used for a certain
link speed without breaking something.

I see that this patch set basically introduces the phydev->host_interfaces
bitmap which is an attempt to find the answer to that question. But when
will we know enough about phydev->host_interfaces in order to safely
make decisions in the PHY driver based on it? phylink sets it, phylib does not.
And many Aquantia systems use the generic PHY driver, as mentioned.
Additionally, there are old device trees at play here, which only define
the initial SERDES protocol. Would we be changing the behavior for those,
in that we would be configuring the PHY to keep the SERDES protocol
fixed whereas it would have dynamically changed before?

Another question is what to do if there are multiple ways of
establishing a system-side link. For example 1000 Mbps can be achieved
either through SGMII, or USXGMII with symbol replication, or 2500base-x
with flow control, or 10GBaseR with flow control. And I want to test
them all. What would I need to do to change the SERDES protocol from one
value to the other? Changing the phy-mode array in the device tree would
be one option, but that may not always be possible.
