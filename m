Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D2FF99AE
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 20:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKLT0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 14:26:34 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34725 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfKLT0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 14:26:33 -0500
Received: by mail-ed1-f68.google.com with SMTP id b72so15943951edf.1
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 11:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DsnxrZJZb7G4FIrbPEPmKv9R+FoV4DBOHnhu+WwVoOU=;
        b=oGhdVoCv9r3vdxdmkKX4tyxWlvNBy+52APuP4cjH3A3XhQxZ0Xo3uk7P69If4MHVx+
         GOR6epiecrLe3kKMBhBnm5nuTsJi00ZqLcIfPUbQJuBJeVc/nBaAPh/MpxdJABnZgH87
         OAnh6+WFYwELhnBer51sJK/TtBjngT4Ru2LtQZVW7vJB5OfUPAVya47CMgQ/tSfLNnnb
         Jr9XuiY3AuZC+2fcAU4lsWgBJGP6iKOd1CeRYiGcqRmDJc7xRFgIdq4DuGhzxbdcDcyw
         rZWwk++45h4GSkLA4vHRG8gxzQpOEO1utr93Hb2lU1aDw/7RhRgWYCchM6kF4krxV8Kd
         /Khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DsnxrZJZb7G4FIrbPEPmKv9R+FoV4DBOHnhu+WwVoOU=;
        b=Zlb6uzEiiP4WdRHKuUm1wnRezLIdQdNgKYg0AfElBwtM5f01BDvgX2Tx1SCuflzy/0
         Kj/5dZNqIhBiYNQaM0zikH9n2OYzETZu61qlnfn6THRtIpP//VnSnEAY+sxL/EbuIRju
         e3F6O3JGZ3E74FNShvNy2GFNRkUTTUO+a0hbjjc3Hq218W5fzgDOkyWRYZnwo7kUGXmL
         W7w3Ovtr3ErG41gwMA53V1d5UCFb9b11fn32qjOiInxCdPZDKAbPqqSLP100EcIDwb8N
         n0r9U8wfl2t6CTdNH20cy9grGwUvEfbi6YY3dvJ+sPqint8cb7OgY6akEr6KUEmuNbL8
         pNOw==
X-Gm-Message-State: APjAAAXDr2pzRYBwI66fSC3qJnA9xgRXrG8GubowUjRgGXQgu5fvrL82
        TLkKAXP9EoNsncnk2eZaGnYNJ3zV3jSckz8IiZrdrlh6
X-Google-Smtp-Source: APXvYqySFpuRxpSKNpOEw0cb/mLqHYzPwwET5rdv+zbDR2mZmrLY56P439iGGV7ToynmyKyi3LPYcCbJ/XWxYSbynV0=
X-Received: by 2002:aa7:d44c:: with SMTP id q12mr34690222edr.108.1573586791316;
 Tue, 12 Nov 2019 11:26:31 -0800 (PST)
MIME-Version: 1.0
References: <20191112124420.6225-1-olteanv@gmail.com> <20191112124420.6225-11-olteanv@gmail.com>
 <20191112130947.GE3572@piout.net> <CA+h21hqYynoGwfd=g3rZFgYSKNxsv8PXstD+6btopykweEi1dw@mail.gmail.com>
 <20191112143346.3pzshxapotwdbzpg@lx-anielsen.microsemi.net>
 <20191112145054.GG10875@lunn.ch> <20191112145732.o7pkbitrvrr2bb7j@lx-anielsen.microsemi.net>
 <CA+h21hrc-vb412iK+hp20K6huFPBABx6xYQjgi7Ew7ET8ryK+g@mail.gmail.com> <20191112190957.nbfb6g2bxiipjnbi@lx-anielsen.microsemi.net>
In-Reply-To: <20191112190957.nbfb6g2bxiipjnbi@lx-anielsen.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 Nov 2019 21:26:20 +0200
Message-ID: <CA+h21hqo9dWct-068pGv2YhzACp5ooaDKzeh92jHNTYyBvgmqw@mail.gmail.com>
Subject: Re: [PATCH net-next 10/12] net: dsa: vitesse: move vsc73xx driver to
 a separate folder
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 at 21:10, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> The 11/12/2019 17:26, Vladimir Oltean wrote:
> > External E-Mail
> >
> >
> > On Tue, 12 Nov 2019 at 16:57, Allan W. Nielsen
> > <allan.nielsen@microchip.com> wrote:
> > >
> > > The 11/12/2019 15:50, Andrew Lunn wrote:
> > > > External E-Mail
> > > >
> > > >
> > > > > > > As there are no commonalities between the vsc73xx and felix drivers,
> > > > > > > shouldn't you simply leave that one out and have felix in the existing
> > > > > > > microchip folder?
> > > > > > >
> > > > > >
> > > > > > I don't have a strong preference, although where I come from, all new
> > > > > > NXP networking drivers are still labeled as "freescale" even though
> > > > > > there is no code reuse. There are even less commonalities with
> > > > > > Microchip (ex-Micrel, if I am not mistaken) KSZ switches than with the
> > > > > > old vsc73xx. I'll let the ex-Vitesse people decide.
> > > > > I'm on the same page as Alexandre here.
> > > >
> > > > Leaving them where they are makes maintenance easier. Fixes are easier
> > > > to backport if things don't move around.
> > > >
> > > > > I think we should leave vsc73xx where it is already, and put the felix driver in
> > > > > the drivers/net/ethernet/mscc/ folder where ocelot is already.
> > > >
> > > > Currently, all DSA drivers are in drivers/net/dsa. We do occasionally
> > > > make changes over all DSA drivers at once, so it is nice they are all
> > > > together. So i would prefer the DSA part of Felix is also there. But
> > > > the core can be in drivers/net/ethernet/mscc/.
> > > Ahh, my bad.
> > >
> > > In that case I do not have any strong feelings on this either.
> > >
> > > I should say that we are discussing to add support for a Ocelot VSC7511 as a DSA
> > > driver. This one does not have an internal MIPS CPU.
> > >
> > > The vsc73xx, felix and the drivers in dsa/microchip does not share any
> > > functionallity. Not in SW and not in HW.
> > >
> > > Maybe felix should just go directly into drivers/net/dsa/, and then if we add
> > > support for VSC7511 then they can both live in drivers/net/dsa/ocelot/
>
>
> A bit of background such that people outside NXP/MCHP has a better change to
> follow and add to the discussion.
>
> Ocelot is a family name covering 4 VSC parts (VSC7511-14), and a IP used by NXP
> (VSC9959).
>
> VSC7511-14 are all register compatible, it uses the same serdes etc.
>
> VSC7511/12 are "unmanaged" meaning that they do not have an embedded CPU.
>
> VSC7513/14 has an embedded MIPS CPU.
>
> VSC9959 not the same core as VSC7511-14, it is a newer generation with more
> features, it is not register compatible, but all the basic functionallity is
> very similar VSC7511-14 which is why it can call into the
> drivers/net/ethernet/mscc/ocelot.c file.
>
> It is likely that NXP want to add more features in felix/VSC9959 which does not
> exists in VSC7511-14.
>
> > When the felix driver is going to support the vsc7511 ocelot switch
> > through the ocelot core, it will be naming chaos.
> I do not think a VSC7511 will be based on Felix, but it will relay on the
> refacturing/restructuring you have done in Ocelot.
>
> VSC7511 will use the same PCS and serdes settings as Ocelot (VSC7513/VSC7514)
>
> > Maybe we need to clarify what "felix" means (at the moment it means VSC9959).
> Yes.
>
> > What if we just make it mean "DSA driver for Ocelot", and it supports both the
> > VSC751x (Ocelot) and the VSC9959 (Felix) families?
> I'm not too keen on using the felix name for that.
>
> Here is my suggestion:
>
> Drop the felix name and put it in drivers/net/dsa/ocelot_vsc9959* (this would be
> my preference)
>

This has one big issue: the name is very long! I can't see myself
prefixing all function and structure names with ocelot_vsc9959_*.
Felix is just 5 letters. And I can't use "ocelot" either, since that
is taken :)
So the DSA driver needs its own (short) name.

> Or if you want the felix name put it in drivers/net/dsa/ocelot_felix*
>
> Or if we want folders put it in drivers/net/dsa/ocelot/vsc9959*
>

The way I see an Ocelot DSA driver, it would be done a la mv88e6xxx,
aka a single struct dsa_switch_ops registered for the entire family,
and function pointers where the implementation differs. You're not
proposing that here, but rather that each switch driver works in
parallel with each other, and they all call into the Ocelot core. That
would produce a lot more boilerplate, I think.
And if the DSA driver for Ocelot ends up supporting more than 1
device, its name should better not contain "vsc9959" since that's
rather specific.

> When we get to it, we can add vsc7511/12 in drivers/net/dsa/ocelot_vsc7512*
>
> To be consisten and clean up (my) earlier mistake we should rename the
> drivers/net/ethernet/mscc/ocelot_board.c to
> drivers/net/ethernet/mscc/ocelot_vsc7514.c (as it is really not board stuff, but
> ocelot internal cpu stuff).
>
> Andrew also pointed out that the stuff put into this file did not seem very
> board related.
>
> > Is anybody else instantiating the VSC9959 core, or close derivatives, except
> > NXP LS1028A? If the answer is yes, are those other instantiations PCI devices,
> > or something else?
> Not what I'm aware of.
>

Ok, this is good to know.

> > I would appreciate if you could take a
> > look through the probing part of patch 11/12 (the "felix_instance_tbl"
> > part and felix-regs.c) and see if there are any naming changes I can
> > make that would make it easier for you to fit in one more device.
> Will do.
>
> > Of course, I don't expect to make radical changes, you'd still need to do some
> > refactoring if you decide to add your vsc7511, I just care that the
> > refactoring doesn't change any current semantics.
> The majority of the needed changes to add vsc7511 has been done by now ;-)
>
> /Allan
>
