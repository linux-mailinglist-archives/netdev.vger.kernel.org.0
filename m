Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507A3455F16
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhKRPMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 10:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbhKRPMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 10:12:55 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E34C06173E;
        Thu, 18 Nov 2021 07:09:54 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z5so28487180edd.3;
        Thu, 18 Nov 2021 07:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=j4q5VMvwQq+uVbNt00M3aFr+gaNuJqIbrELgpLMVPi8=;
        b=mWvI+IfwPfwqy5v/1DaKdD1W40CtfNndZHMPbI03CWGGEiy4Y4M/XJcek4z1Mg1J6f
         stB/EY9ZnADNYrfky6J+ZUy+4iWqZ4cPL1MNQj/NPAi619jQLcu/mmVTuu51M8rMf5+N
         LxbshVLv1bE5TidSnVvzQ2zodlh/rVGJoBOJep3VULC/2cMiLmsxzdzqNNVP5NxgTwuu
         JOGvlhrTvxv1AOpBAy2+ZmRb79MwGdSvpf36dvvn/6dWLyXkbyClzuJIK1jX1SP/D5IV
         zdlbe7gbTT7kB4C/G00JHkEtotsfGVKAVyR9mAfPvDQ2EF+VVStNb2PG+k2CHL0UgZXp
         iiHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=j4q5VMvwQq+uVbNt00M3aFr+gaNuJqIbrELgpLMVPi8=;
        b=s+n7DbeBuYNYwHCyPrr8Nc1EA5GTkNaVfajXngA5sS12RJwBKvp18qVyU89Yw+h2ON
         rrGq9/ALxpaJWqlXBBmmOnET/UOhxO3FR2Rm1DIpzf6jZ/jZHn/hQRphNHyc9+JD8TW+
         1yGRar/KQvbUSu4FWjExeypoEjBZL08xyA2LbnIzZQ5MX67z3pxtC6UTMZVqU7nHlwWD
         tMAK/LWiAO2UhMEmqJVhfqFe+QdGUkWrg0+1GWLIhqMg0f+clDI4tj9IBCETmYcFTBgh
         nakPiuHku6hTf6VlPGaUd8OBQjle6s3BL/sjYXqbUjdgCWR1Y3rplSBKZtKt1pzR9yDt
         hxlQ==
X-Gm-Message-State: AOAM533OXrBEGctQhwwz2XJIJ5XRc1QmS/JLc0Hjh8lRLOcBR+zaQ6P/
        26ThNSUs/y6sG6D1mmzGmXE=
X-Google-Smtp-Source: ABdhPJyr29tdEKV7T3K7GMo1CLQ+dSmgzsDl44XW4f/9mHTtyh8izZs75AWnfNfKP2g8/HIVF8nt9w==
X-Received: by 2002:a17:906:9b96:: with SMTP id dd22mr34577967ejc.422.1637248193147;
        Thu, 18 Nov 2021 07:09:53 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id d3sm55523edx.79.2021.11.18.07.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 07:09:52 -0800 (PST)
Date:   Thu, 18 Nov 2021 17:09:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net: phy: marvell10g: select host interface
 configuration
Message-ID: <20211118150951.jzwl5jickilxbfhy@skbuf>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-9-kabel@kernel.org>
 <20211118120334.jjujutp5cnjgwjq2@skbuf>
 <YZZTinTgX3SPWIZM@shell.armlinux.org.uk>
 <20211118142039.uocgddbpplwwsfdk@skbuf>
 <YZZnkEn76a3Q0hAY@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZZnkEn76a3Q0hAY@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 02:47:44PM +0000, Russell King (Oracle) wrote:
> On Thu, Nov 18, 2021 at 04:20:39PM +0200, Vladimir Oltean wrote:
> > On Thu, Nov 18, 2021 at 01:22:18PM +0000, Russell King (Oracle) wrote:
> > > On Thu, Nov 18, 2021 at 02:03:34PM +0200, Vladimir Oltean wrote:
> > > > On Wed, Nov 17, 2021 at 11:50:50PM +0100, Marek Behún wrote:
> > > > > +static int mv3310_select_mactype(unsigned long *interfaces)
> > > > > +{
> > > > > +	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
> > > > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII;
> > > > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > > > > +		 test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > > > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> > > > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > > > > +		 test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > > > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI;
> > > > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > > > > +		 test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > > > > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI;
> > > > > +	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > > > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
> > > > > +	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > > > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH;
> > > > > +	else if (test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > > > > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH;
> > > > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces))
> > > > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> > > > > +	else
> > > > > +		return -1;
> > > > > +}
> > > > > +
> > > > 
> > > > I would like to understand this heuristic better. Both its purpose and
> > > > its implementation.
> > > > 
> > > > It says:
> > > > (a) If the intersection between interface modes supported by the MAC and
> > > >     the PHY contains USXGMII, then use USXGMII as a MACTYPE
> > > > (b) Otherwise, if the intersection contains both 10GBaseR and SGMII, then
> > > >     use 10GBaseR as MACTYPE
> > > > (...)
> > > > (c) Otherwise, if the intersection contains just 10GBaseR (no SGMII), then
> > > >     use 10GBaseR with rate matching as MACTYPE
> > > > (...)
> > > > (d) Otherwise, if the intersection contains just SGMII (no 10GBaseR), then
> > > >     use 10GBaseR as MACTYPE (no rate matching).
> > > 
> > > What is likely confusing you is a misinterpretation of the constant.
> > > MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER actually means the PHY will
> > > choose between 10GBASE-R, 5GBASE-R, 2500BASE-X, and SGMII depending
> > > on the speed negotiated by the media. In this setting, the PHY
> > > dictates which interface mode will be used.
> > > 
> > > I could have named "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER" as
> > > "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_5GBASER_2500BASEX_SGMII_AUTONEG_ON".
> > > Similar with "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_NO_SGMII_AN", which
> > > would be
> > > "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_5GBASER_2500BASEX_SGMII_AUTONEG_OFF".
> > > And "MV_V2_3310_PORT_CTRL_MACTYPE_XAUI" would be
> > > "MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_5GBASER_2500BASEX_SGMII_AUTONEG_ON".
> > > 
> > > Clearly using such long identifiers would have been rediculous,
> > > especially the second one at 74 characters.
> > 
> > True, but at least there could be a comment above each definition.
> > There's no size limit to that.
> > 
> > > > First of all, what is MACTYPE exactly? And what is the purpose of
> > > > changing it? What would happen if this configuration remained fixed, as
> > > > it were?
> > > 
> > > The PHY defines the MAC interface mode depending on the MACTYPE
> > > setting selected and the results of the media side negotiation.
> > > 
> > > I think the above answers your remaining questions.
> > 
> > Ok, so going back to case (d). You said that the full name would be
> > MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_5GBASER_2500BASEX_SGMII_AUTONEG_ON.
> > This means that when the only interface mode supported by the host would
> > be SGMII, the PHY's MACTYPE is still configured to use 2500basex,
> > 5gbaser, 10gbaser for the higher link speeds. Clearly this won't work.
> > But on the other hand, the phylink validate method will remove
> > 2500baseT, 5000baseT, 1000baseT from the advertising mask of the PHY, so
> > the system will never end up operating at those speeds, so it should be fine.
> 
> I think you mean 10000baseT rather than 1000baseT. With that correction,
> you are then correct - with the media restricted to 1G or slower speeds,
> and the phy in MACTYPE mode 4 (aka 10GBASE-R as the fastest interface
> mode) it will permanently be talking SGMII to the host.

Yes, I missed a zero.

> > The reason why I'm looking at these patches is to see whether they would
> > bring something useful to Aquantia PHYs. These come with firmware on a
> > flash that is customized by Aquantia themselves based on the specifications
> > of a single board. These PHYs have an ability which is very similar to
> > what I'm seeing here, which is to select, for each negotiated link speed
> > on the media side, the SERDES protocol to use on the system side. This
> > is pre-programmed by the firmware, but could be fixed up by the
> > operating system if done carefully.
> > 
> > The way Layerscape boards use Aquantia PHYs is to always select the
> > "rate matching" option and keep the SERDES protocol fixed, just
> > configure the mini MAC inside the PHY to emit PAUSE frames towards the
> > system to keep the data rate under control. We would be using these PHYs
> > with the generic C45 driver, which would be mostly enough except for
> > lack of PHY interrupts, because the firmware already configures
> > everything.
> > 
> > But on the other hand it gets a bit tiring, especially for PHYs on riser
> > cards, to have to change firmware in order to test a different SERDES
> > protocol, so we were experimenting with some changes in the PHY driver
> > that would basically keep the firmware image fixed, and just fix up the
> > configuration it made, and do things like "use 2500base-x for the
> > 2500base-T speed, and sgmii for 1000base-T/100base-TX". The ability for
> > a PHY to work on a board where its firmware image wasn't specifically
> > designed for it comes in handy sometimes.
> 
> You're going to get into problems with this on Layerscape, because
> reconfiguring the Serdes etc is something I've tried to highlight
> as being necessary to NXP since SolidRun started using LX2160A. I
> think there's some slow progress towards that, but it's so slow that
> I've basically given up caring about it on the Honeycomb/Clearfog CX
> boards now.
> 
> All the SFP cages on my Honeycomb have been configured for the most
> useful mode to me - 1000BASE-X/SGMII, and I've given up caring about
> USXGMII/10GBASE-R on those ports.

Speaking of that, do you know of any SFP modules that would use USXGMII?
It doesn't appear to be listed in the spec sheet when looking for that.

> > I see that this patch set basically introduces the phydev->host_interfaces
> > bitmap which is an attempt to find the answer to that question. But when
> > will we know enough about phydev->host_interfaces in order to safely
> > make decisions in the PHY driver based on it? phylink sets it, phylib
> > does not.
> 
> It won't be something phylib could set because phylib doesn't know
> the capabilities of its user - it's information that would need to be
> provided to phylib.

So you're saying it would be in phylib's best interest to not set it at
all, not even to a single bit corresponding to phydev->interface. So PHY
drivers could work out this way whether they should operate in backwards
compatibility mode or they could change MACTYPE at will.

> > And many Aquantia systems use the generic PHY driver, as mentioned.
> > Additionally, there are old device trees at play here, which only define
> > the initial SERDES protocol. Would we be changing the behavior for those,
> > in that we would be configuring the PHY to keep the SERDES protocol
> > fixed whereas it would have dynamically changed before?
> 
> We have the same situation on Macchiatobin. The 88X3310 there defaults
> to MACTYPE mode 4, and we've supported this for years with DT describing
> the interface as 10GBASE-R - because we haven't actually cared very much
> what DT says up to this point for the 88X3310. As I said in my previous
> reply, the 88X3310 effectively dictates what the PHY interface mode will
> be, and that is communicated back through phylib to whoever is using
> phylib.

So what is the full backwards compatibility strategy with old DT blobs?
Is it in this patch set? I didn't notice it.

> > Another question is what to do if there are multiple ways of
> > establishing a system-side link. For example 1000 Mbps can be achieved
> > either through SGMII, or USXGMII with symbol replication, or 2500base-x
> > with flow control, or 10GBaseR with flow control. And I want to test
> > them all. What would I need to do to change the SERDES protocol from one
> > value to the other? Changing the phy-mode array in the device tree would
> > be one option, but that may not always be possible.
> 
> First point to make here is that rate adaption at the PHY is really
> not well supported in Linux, and there is no way to know via phylib if
> a PHY is capable or not of rate adaption.
> 
> Today, if you have a 10GBASE-R link between a PHY doing rate adaption
> and the "MAC", then what you will get from phylib is:
> 
> 	phydev->interface = PHY_INTERFACE_MODE_10GBASER;
> 	phydev->speed = SPEED_1000;	// result of media negotiation
> 	phydev->duplex = DUPLEX_FULL;	// result of media negotiation
> 	phydev->pause = ...;		// result of media negotiation
> 	phydev->asym_pause = ...;	// result of media negotiation
> 
> which will, for the majority of implementations, result in the MAC being
> forced to a 1G speed, possibly with or without pause enabled.
> 
> Due to this, if phylink is being used, the parameters given to
> mac_link_up/pcs_link_up will be the result of the media negotiation, not
> what is required on the actual link.
> 
> You mention "10GBaseR with flow control" but there is another
> possibility that exists in real hardware out there. "10GBaseR without
> flow control" and in that case, the MAC needs to pace its transmission
> for the media speed (which is a good reason why mac_link_up should be
> given the result of the media negotiation so it can do transmission
> pacing.)
> 
> I have a follow-up to the response I gave to Sean Anderson on rate-
> adapting PHYs that I need to finish and send, and it would be better
> to have any discussion on this topic after I've sent that reply and
> follow-up to that reply.

Ok, how would the MAC pace itself to send at a lower data rate, if the
SERDES protocol is 10G and the PHY doesn't send it PAUSE frames back?
At least Layerscape systems can't do this AFAIK.

I can watch for updates on this on the other thread.
