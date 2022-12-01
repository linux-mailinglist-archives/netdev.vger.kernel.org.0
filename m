Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F91D63EC8B
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiLAJbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiLAJbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:31:22 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9367975E1
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 01:30:55 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id y16so1730447wrm.2
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 01:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EoRTMNVcYQTgedY2uiMQ9QMpPHQ3mvgwAT6uMCKj34E=;
        b=g5GmAoIEmENTnQkoMRfTbw5Z1YM6pQ6938MZYpNEon85B6aowgwmBChicSr8QEhoFx
         zHhjuRiwouAizynLI6c8JrVItd8BusWH1DV5tw1WLyMhFHcICa1FlFzuehehsnt6Fq6N
         IsCmM6xuCsoQLCXZjbyps5lqkDOW5jiuFwzNQI+oLb/Min9Pm6e+//BU3AtpMNkSLFCD
         ma4SWc09WzPS4ukZYGHrryvfCiUGdZNB0k3v/g385xVsjsfbg1EFfQAYiyln8FUfBTuj
         UWQNqfgKwdfusqolppUkU+npmBTWbD7K5l4UjsSEOR6q/TWdAC1+HNjJ2N5MOR7fXIuM
         WWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EoRTMNVcYQTgedY2uiMQ9QMpPHQ3mvgwAT6uMCKj34E=;
        b=aAuM3zZx81ealDYpwJDpYbHa4raH2MwjfZD5O1s/CS6MRk5F7b+I0YmupRl1BIwSps
         4BdT5Ct++FS3AJjvNN3wLIVHEDHQtGFeEqW8Gx0k2OL9G42GXfk48qYuyxktJ1dAc8C0
         bvgcOTVpHKhy3PbohYCLTtIqjI1PjCXuZbfjTv5E0kZizHElTxFLErDZZnPj1l9EWkSG
         c6TekqpzbdnyFuo6HHJksHiWAOYYhmSHTZZaueqAQQFsphbl0dcNrPQDbqQODpww/a03
         IqykTVx0prKNUBTKSLF62uvHHU3khZkS9SuiIslDTY9OO7fGXoLC4uNxFg+29pz36gNR
         bgwA==
X-Gm-Message-State: ANoB5plK6zwDG7U8oiYpXqTS64OwAhzbmHYnHYbvNpZzaC4WbcWEyotG
        Zv6ZqTfxA8OYWHk8WpoZOrq0fuWJGDYsHQ==
X-Google-Smtp-Source: AA0mqf7LI/wNlmwAtPvQK1caD1/4f4npQl7ADtgABYZRZrLzCNgkUYeIo7z7qqlJBS4egnACcBVo3w==
X-Received: by 2002:a5d:61cd:0:b0:241:f8e3:7111 with SMTP id q13-20020a5d61cd000000b00241f8e37111mr23318771wrv.299.1669887054007;
        Thu, 01 Dec 2022 01:30:54 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id l5-20020a5d5605000000b002367ad808a9sm3886262wrv.30.2022.12.01.01.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 01:30:53 -0800 (PST)
Date:   Thu, 1 Dec 2022 10:30:56 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: Help on PHY not supporting autoneg
Message-ID: <Y4h0UGXR7znwMWLo@gvm01>
References: <Y4dJgj4Z8516tJwx@gvm01>
 <Y4d3fV8lUhUehCq6@lunn.ch>
 <Y4fgT1kjX9LTULOi@gvm01>
 <Y4gOG5rFwlezsfoD@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4gOG5rFwlezsfoD@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 03:14:51AM +0100, Andrew Lunn wrote:
> > /root # ethtool eth0
> > Settings for eth0:
> >         Supported ports: [ MII ]
> >         Supported link modes:   10baseT1S_P2MP/Half
> >         Supported pause frame use: Symmetric Receive-only
> >         Supports auto-negotiation: No
> >         Supported FEC modes: Not reported
> >         Advertised link modes:  10baseT1S_P2MP/Half
> >         Advertised pause frame use: Symmetric Receive-only
> 
> That looks odd. The PHY should indicate if it supports pause
> negotiation. Since this PHY does not support autoneg, it should not be
> saying it can negotiate pause. So i'm wondering why it is saying this
> here. Same for 'Supported pause'.
This is indeed a good question. This is the code snippet for the PHY
driver:

static int ncn26000_get_features(struct phy_device *phydev) {
	linkmode_zero(phydev->supported);
	linkmode_set_bit(ETHTOOL_LINK_MODE_MII_BIT, phydev->supported);

	linkmode_set_bit(
		ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
		phydev->supported
	);

	linkmode_copy(phydev->advertising, phydev->supported);
	return 0;
}

static int ncn26000_config_aneg(struct phy_device *phydev) {
	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
	phydev->mdix = ETH_TP_MDI;
	phydev->pause = 0;
	phydev->asym_pause = 0;
	phydev->speed = SPEED_10;
	phydev->duplex = DUPLEX_HALF;

	// bring up the link (link_ctrl is mapped to BMCR_ANENABLE)
	// clear also ISOLATE mode and Collision Test
	return phy_write(phydev, MII_BMCR, BMCR_ANENABLE);
}

As you can see there is no mention of PAUSE support in the features, and
the pause/asym_pause flags in phydev are set to 0.

Could it be a problem of the userspace tool?
Any advice on where to start looking?
 
> >         Advertised auto-negotiation: No
> >         Advertised FEC modes: Not reported
> >         Speed: 10Mb/s
> >         Duplex: Half
> >         Auto-negotiation: off
> >         Port: Twisted Pair
> >         PHYAD: 8
> >         Transceiver: external
> >         MDI-X: off (auto)
> 
> Given that this is a T1 PHY does MDI-X have any meaning? The (auto)
> indicates the PHY is returning mdix_ctrl=ETH_TP_MDI_AUTO, when it
> should be returning ETH_TP_MDI_INVALID to indicate it is not
> supported.
This is in fact debatable. The 10BASE-T1S has a unique feature making it
polarity insensitive. It's not like other xBASE-T1 PHYs that
auto-detects the polarity, the line coding (Differential Manchester) is
intrinsically polarity agnostic. Therefore I'm personally undecided on
the best approach.

On one hand, If the driver reports that MDI-X is not supported, the user
might think he needs to care about the polarity, which could be
misleading. On the other hand, there is no real auto-switch of TX/RX.

I'm not sure if/how 100BASE-T1 for example handles polarity, but we
probably need a common approach.

Thoughts?
 
> >         Supports Wake-on: d
> >         Wake-on: d
> >         Current message level: 0x0000003f (63)
> >                                drv probe link timer ifdown ifup
> >         Link detected: yes
> > 
> > 
> > > What exactly is LINK_CONTROL. It is not one of the Linux names for a
> > > bit in BMCR.
> > The 802.3cg standard define link_control as a varibale set by autoneg.
> > In factm it is tied to the BMCR_ANENABLE bit. The standard further
> > specifies that when AN is not supported, this bit can be supplied in a
> > vendor-specific way. A common thing to do is to just leave it tied to
> > the BMCR_ANENABLE bit.
> > 
> > So, the "problem" seems to lie in the genphy_setup_forced() function.
> > More precisely, where you pointed me at: 
> > >       return phy_modify(phydev, MII_BMCR,
> > >                         ~(BMCR_LOOPBACK | BMCR_ISOLATE | BMCR_PDOWN), ctl);
> > > 
> > 
> > In my view we have two choices to handle LINK_CONTROL.
> > 
> > 1. Just let the PHY driver override the config_aneg() callback as I did.
> > This may be a bit counter-intuitive because of the function name, but it
> > works.
> > 
> > 2. in phylib, distinguish the case of a PHY having aneg disabled from a
> > PHY NOT supporting aneg. In the latter case, don't touch the control
> > register and/or provide a separate callback for "starting" the PHY
> > (e.g., set_link_ctrl)
> 
> 2) sounds wrong. As you said, it is vendor-specific. As such you
> cannot trust it to mean anything. The standard has left it undefined,
> so you cannot do anything in generic code. I would also worry about
> breaking older PHYs who have never had this bit set.
Maybe I did not explain what I had in mind correctly.
I did not mean to set this bit, it is indeed vendor-specific.
The idea would be to define a new callback that by default does what we
have right now (clear all bits in register 0). But PHY drivers may
override it to actually do something meaningful, like setting the AN
bit.
> 
> So i would go with 1). As i said, the function name is not ideal, but
> it has been like this since forever.
I'm not strongly biased between 1 and 2, but I would first re-consider 2
before making a final decision.

Thank you very much for your kind reply.
Piergiorgio
