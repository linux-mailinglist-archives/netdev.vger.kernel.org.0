Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88804181A8A
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 14:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgCKN5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 09:57:32 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37739 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbgCKN5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 09:57:31 -0400
Received: by mail-ed1-f68.google.com with SMTP id b23so2987948edx.4
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 06:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8aIos8SD9MBQRyIBPK6l7k8KvBZOlZr6kbMWgZIFc8I=;
        b=UEqU49N9bXJR7ZozEFz2KSNR4cU1WSMxfFYuoOHZaMju1vNuG6Y9qAPj2eLaNCKzCI
         zPvZsEO4hQQU+R+0immMS2IKD79VisinAYIQSY5JPxaTVpkCSQt7Dx4bS9etyusOR8N6
         6Z+g6KBqR6zrG1XKErgcufIzVKUQK7dcCIYJmyY5M8DGJ0tV5oYT+HLZQoMM5nk9UWsi
         WvzZbjVnnamdtJOxPOeGlazac1Q1AxsfK/mTyaFFa1ZwNbOV8zz3m81XDbeJvQ5tbT6t
         lUaZyN11+FBs01rbTQOl4DXah8B77c/V+eo0CFmt+Ix/5/Hfb4xtyAOmtT4dh84TOf7e
         b7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8aIos8SD9MBQRyIBPK6l7k8KvBZOlZr6kbMWgZIFc8I=;
        b=lV+mzWMXcdH9OxCBKTjCtZ4dZIwWz8HTuJwvBKQ+LYARp/t0zKujqd0zluCwMMIEBl
         7LZhgnZvBg7j11TkYDG9UPK5+rkrkn+bMxUaelEoVlm6NsFzWNgWb7irK95fL8foAv/S
         VnUWL/ftMO3vhuK3khILTaenXkHqTmXiiJDPzJ6Bdhq6B4zEBrIDPd8r6VX5ODcowpho
         IXEYHIV2gR2QchQsZaK7edwt+kguQLO1GQ7Cp8vf7KzTzeNX+9hlLYlrX2w4fwEAcyPo
         eyr7HGXRianQTEXJFuOTaq69iAI9CJTfLWvIOwc7HVlowVZmfpYX63hap1DNCr8/WwnI
         ovmw==
X-Gm-Message-State: ANhLgQ3Jdca/kGyNNB3IiabjgYGkgif9aAIKlYwAuC1V2e8kcmmF0xXS
        T6uerjTJACIo6ahZISlHr7gGeBBJTgWY+m+1XkU=
X-Google-Smtp-Source: ADFU+vszQWEP9hyYUP5NFSn7/G4K2/DyiJe/6Pktt+y9oN+F3oLJpyaaf6dHON8rgYElzdm3VVwLMvVXEA/S6iBCgZs=
X-Received: by 2002:a17:906:e91:: with SMTP id p17mr2454622ejf.239.1583935049775;
 Wed, 11 Mar 2020 06:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200311120643.GN25745@shell.armlinux.org.uk> <CA+h21hoq2qkmxDFEb2QgLfrbC0PYRBHsca=0cDcGOr3txy9hsg@mail.gmail.com>
 <20200311125445.GO25745@shell.armlinux.org.uk>
In-Reply-To: <20200311125445.GO25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 11 Mar 2020 15:57:18 +0200
Message-ID: <CA+h21hpk+TMofHFjg_Z-UZOPp+7zn29ZNLFP+JKreJtbZouiZQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] add phylink support for PCS
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 at 14:54, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Mar 11, 2020 at 02:46:33PM +0200, Vladimir Oltean wrote:
> > Hi Russell,
> >
> > On Wed, 11 Mar 2020 at 14:09, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > Hi,
> > >
> > > This series adds support for IEEE 802.3 register set compliant PCS
> > > for phylink.  In order to do this, we:
> > >
> > > 1. convert the existing (unused) mii_lpa_to_ethtool_lpa_x() function
> > >    to a linkmode variant.
> > > 2. add a helper for clause 37 advertisements, supporting both the
> > >    1000baseX and defacto 2500baseX variants. Note that ethtool does
> > >    not support half duplex for either of these, and we make no effort
> > >    to do so.
> > > 3. add accessors for modifying a MDIO device register, and use them in
> > >    phylib, rather than duplicating the code from phylib.
> >
> > Have you considered accessing the PCS as a phy_device structure, a la
> > drivers/net/dsa/ocelot/felix_vsc9959.c?
>
> I don't want to tie this into phylib, because I don't think phylib
> should be dealing with PCS.  It brings with it many problems, such as:
>

Agree that the struct mdio_device -> struct phy_device diff is pretty
much useless to a PCS.

> 1. how do we know whether the Clause 22 registers are supposed to be
>    Clause 37 format.

Well, they are, aren't they?

> 2. how do we program the PCS appropriately for the negotiation results
>    (which phylib doesn't support).

You mean how to read the LPA and logically-AND it with ADV?
The PCS doesn't need to be "programmed" according to the resolved link
state. Maybe the MAC does.

> 3. how do we deal with selecting the appropriate device for the mode
>    selected (LX2160A has multiple different PCS which depend on the
>    mode selected.)

What I've been doing is to call get_phy_device with an is_c45 argument
depending on the PHY interface type.
Actually the real problem in your case is that the LX2160A doesn't
expose a valid PHY ID in registers 2&3 (unlike other Layerscape PCS
implementations), so get_phy_device is likely going to fail unless
some sort of PHY ID fixup is not done.

>
> Note that a phy_device structure embeds a mdio_device structure, and
> so these helpers can be used inside phylib if one desires - so this
> approach is more flexible than "bolt it into phylib" approach would
> be.
>

It's hard to really say without seeing more than one caller of these
new helpers.
For example the sja1105 DSA switch has a PCS for SGMII (not supported
yet in mainline) that kind-of-emulates a C22 register map, except that
it's accessed over SPI, and that the "pcs_get_state" needs to look at
some vendor-specific registers too. From that perspective, I was
thinking that PHYLINK could be given a phy_device structure with the
advertising, supported and lp_advertising linkmode bit fields
populated who-knows-how, and PHYLINK just resolves that into its
phylink_link_state structure.
But then I guess that sort of hardware is not among your target
candidates for the generic helpers. Whoever can't expose an MDIO bus
or needs to access any vendor-specific register just shouldn't use
these functions. And maybe you're right, I don't really know what the
balance in practice will be.


> > > 4. add support for decoding the advertisement from clause 22 compatible
> > >    register sets for clause 37 advertisements and SGMII advertisements.
> > > 5. add support for clause 45 register sets for 10GBASE-R PCS.
> > >
> > > These have been tested on the LX2160A Clearfog-CX platform.
> > >
> > >  drivers/net/phy/mdio_bus.c |  55 +++++++++++
> > >  drivers/net/phy/phy-core.c |  31 ------
> > >  drivers/net/phy/phylink.c  | 236 +++++++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/mdio.h       |   4 +
> > >  include/linux/mii.h        |  57 +++++++----
> > >  include/linux/phy.h        |  19 ++++
> > >  include/linux/phylink.h    |   8 ++
> > >  include/uapi/linux/mii.h   |   5 +
> > >  8 files changed, 366 insertions(+), 49 deletions(-)
> > >
> > > --
> > > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > > FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

Regards,
-Vladimir
