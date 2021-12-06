Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C3D46AE75
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 00:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350361AbhLFXbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 18:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377357AbhLFXbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 18:31:08 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C380DC0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 15:27:38 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id t5so49511716edd.0
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 15:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=grntaIlUf4/fRq7NWnStKXjwc5oPjnHr0M5wtOsIDso=;
        b=hsR+Dz/Z8SvM1JHo1cLyCtrKryS05Si5Jv8VbQmZK4BxXvsgi2t4ANBus5OhRhbAuE
         bAPn0chsBVMYMHUc/sEuRaNVe/K547N/98l5AffeHsymgygoJGJ3BNoCRRu9OjT7FK3A
         5ID8j3vriF9xVPEuk0S1puu4dQbq4Jc0wtIc1aRfvm4VisTzUfpc2boGEj+Qeh7+5MNc
         mbgi9jrzJ1fQm4WAOVrH3yIz7pKIlZUmHtxiZzwccCD7vVUNpO8l/Ebo8l4Sh+3xa77/
         Nl7UBAd5xig7Rl45TqlDMNNv4h+RPB8JBTfRx9j2plabxQUISsrs03cg5+jDjPJX0kw6
         KnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=grntaIlUf4/fRq7NWnStKXjwc5oPjnHr0M5wtOsIDso=;
        b=5FyCDJWquKSPH3OEnCpRrX/QjhYQN2ZF88AQemhqLaywE4izgK4bbI9118s37cWbJg
         2FdqkAFBUUEiNQ3YHQkLP2JWXafgb0QGar4Sl4e1+HF575xuXwnawDBNz27G67qbq25I
         vB3t0Td80ei/EsgRdv5pEYveJM0Hq8fJGVumwAoPGRbB8UNjBjc/+KlI5Gi0SZRRVixP
         rkWi0h/FnS4d+lYGpItOb+/z1ujqnd3QMipmPJtVxkdu/mOp1MMlDWQ+kuAp5jw51w1Q
         39XE5+TZDtuviKQr2V3OZAyyHcpL8mD6PGXG4cSG41QZEPezbaIs/hzvou3JaXOB+KTL
         EGrA==
X-Gm-Message-State: AOAM531aoaImzTnPhF3qIdGWr5KPlkKh1FhxBZK05s9y89yLvVl7WPl9
        PSxWLd0D3UMuQ+IVm6xY+qjtHlp5uVs=
X-Google-Smtp-Source: ABdhPJybIcVRSG/t15ctSD6cYNFkQpadwVRMFv1+opT/qlrOisRoMbOf36ffKQy+p+r6A4d8uYoJLg==
X-Received: by 2002:a05:6402:42:: with SMTP id f2mr3448421edu.204.1638833257264;
        Mon, 06 Dec 2021 15:27:37 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id sc7sm8130833ejc.50.2021.12.06.15.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 15:27:36 -0800 (PST)
Date:   Tue, 7 Dec 2021 01:27:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211206232735.vvjgm664y67nggmm@skbuf>
References: <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
 <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
 <Ya6FcTIbyO+zXj7V@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ya6FcTIbyO+zXj7V@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 09:49:37PM +0000, Russell King (Oracle) wrote:
> On Mon, Dec 06, 2021 at 09:27:33PM +0000, Russell King (Oracle) wrote:
> > We used to just rely on the PPU bit for making the decision, but when
> > I introduced that helper, I forgot that the PPU bit doesn't exist on
> > the 6250 family, which resulted in commit 4a3e0aeddf09. Looking at
> > 4a3e0aeddf09, I now believe the fix there to be wrong. It should
> > have made mv88e6xxx_port_ppu_updates() follow
> > mv88e6xxx_phy_is_internal() for internal ports only for the 6250 family
> > that has the link status bit in that position, especially as one can
> > disable the PPU bit in DSA switches such as 6390, which for some ports
> > stops the PHY being used and switches the port to serdes mode.
> > "Internal" ports aren't always internal on these switches.
> 
> Here's the situation I'm concerned about. The 88E6390X has two serdes
> each with four lanes. Let's just think about one serdes. Lane 0 is
> assigned to port 9 and lane 1 to port 4. We don't need to consider
> any others.
> 
> If the PHY_DETECT bit (effectively PPU poll enable) is set for port 4,
> which is an "internal" port, then the port is in auto-media mode, and
> the PPU will poll the internal PHY and the serdes, and configure
> according to which has link.
>
> If the PPU bit is clear, then the port is forced to serdes mode.
> However, in this configuration, we end up with:
> 
> 	mv88e6xxx_phy_is_internal(ds, port) = true
> 	mv88e6xxx_port_ppu_updates(chip, port) = false
> 
> which results in:
> 
>         if ((!mv88e6xxx_phy_is_internal(ds, port) &&
>              !mv88e6xxx_port_ppu_updates(chip, port)) ||
>             mode == MLO_AN_FIXED) {
> 
> being false since we have (!true && !false) || false. So, in actual
> fact, when we have a PHY_DETECT bit, we _do_ need to take note of it
> whether the port is "internal" or not. Essentially, that means that
> for DSA switches that are not part of the 6250, we should be using
> the PHY_DETECT bit.
> 
> For the 6250 family, the problem is that there's no PHY_DETECT bit,
> and that's the link status. So I've started a separate discussion
> with Maarten to find out which Marvell switch is being used and
> whether an alterative approach would work for him.

I hope that you understand that it is getting very difficult for me to
follow, especially when faced with contradictory information about
hardware that I am not familiar with, and which may well be very
different from one family to another for all I know.

Commit 4a3e0aeddf09 ("net: dsa: mv88e6xxx: don't use PHY_DETECT on
internal PHY's") says nothing about the 6250, and I have nothing through
which I can cross-check your statement about the change only being
applicable/needed for 6250.

The documentation I happen to have access to, which is for the 6097,
says about "Forcing Link, Speed, Duplex in the MAC":

| These bits change the port's MAC mode only! It does not change the mode
| of the PHY for ports where a PHY is connected. These bits are intended
| to be used for the following situations only:
| 
| - When the PHY Polling Unit (PPU) is disabled on the port (PHYDetect
|   equal to zero in Port offset 0x00) and software needs to copy the
|   PHY’s Link, Speed and Duplex values to the port’s MAC (this is not
|   required for internal PHYs as this information is communicated between
|   the PHY and MAC even if the PPU is disabled on the port).
| 
| - When no PHY is connected to the port. This includes ports that connect
|   to a CPU (typically using a digital interface like MII or GMII) and
|   ports connected to another switch device (typically using a SERDES
|   interface).  SERDES ports connected to a fiber module will get their
|   Link from the port’s SDET pin and its Speed and Duplex is set to
|   1000BASE full-duplex (assuming the Px_MODE has been set correctly –
|   see the C_Mode bits, Port offset 0x00).

So the first paragraph is pretty clear to me: the PPU could be disabled
(PHY_DETECT bit unset) and yet there would still be no reason to force
the link for internal PHY ports. So the change still makes some level of
sense to me, even if not for the cited reason from the commit message.

As for your auto-media comment, you say that on 6390X, port 4 is an
auto-media port only if the PPU is enabled - otherwise it falls back to
SERDES mode and not to internal PHY mode. Again, no way to cross-check,
but so be it. The problem that you cite here is that we are in SERDES
mode with PPU disabled, and that we should* (should we?) force the link,
yet we don't, because the mv88e6xxx_phy_is_internal() function only
conveys static information that doesn't properly reflect the current
state of an auto-media port. The question is: did this use to work
properly before the commit 4a3e0aeddf09 ("net: dsa: mv88e6xxx: don't use
PHY_DETECT on internal PHY's") that you mention? This is the same as
asking: if the PPU is disabled on an auto media port, the old code (via
your commit 5d5b231da7ac ("net: dsa: mv88e6xxx: use PHY_DETECT in
mac_link_up/mac_link_down")) would always force the link. Is that ok for
an internal PHY port? Is it ok for a fiber port with clause 37 in-band
autoneg? More below.

* would it not matter whether this SERDES port is used in SGMII vs
  1000base-X mode? According to the documentation I have access to, only
  SGMII would need forcing without a PPU - see second quoted paragraph.

Anyway, so be it. Essentially, what is the most frustrating is that I
haven't been doing anything else for the past 4 hours, and I still
haven't understood enough of what you're saying to even understand why
it is _relevant_ to Martyn's report. All I understand is that you're
also looking in that area of the code for a completely unrelated reason
which you've found adequate to mention here and now.
