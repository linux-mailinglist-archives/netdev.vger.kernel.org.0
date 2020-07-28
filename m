Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FF2231497
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgG1V2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgG1V2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 17:28:53 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8AEC061794;
        Tue, 28 Jul 2020 14:28:53 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id k27so12939807pgm.2;
        Tue, 28 Jul 2020 14:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xvCoPngM+z+GlDwvhwvsM08dXAE7dolPO7/pheusxuo=;
        b=Du30ik0I9W40K09m3Xsw3yOUzOfgYSiR6mjUm56O9qDqcE5wJpmwCb6sUgA1uq7wvY
         VK2DouubdO89hAyQwfFQKLCHSH8yG4PcfAvBkR3x92RCreH/PGBwpbyZV9eKz7SHg5C2
         YLcBfSnJPxjmMpEaZtSVDNv0ZdDzh3PPuOmvrkcbYPe5HeZM0/BYnBxactVds2LNDSi4
         XxIxzzeBSmKmDTEydQhckqZvVEqi6FBJwZUYM23/QIjLB5RJ+n9wBy1pZ1kn6EmLv8LV
         8Ob1f25wwrqIpRg3CQH6OVH3kJg/nsQm8zEbbHcv+38iXDzo+r/aphYHjI991atOxViv
         7M4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xvCoPngM+z+GlDwvhwvsM08dXAE7dolPO7/pheusxuo=;
        b=gnR8ZFhooB4AazkoKN+uIxc1uJYMUYI0m9DN+zmXFQyG2oGapxNl8JNs8F98oaZLOP
         Bl4sOWqbuzfEAAdwe0PplAMdE5XKKA+nTgdAcZ7TBLq5VcaIdqCbNo/QmDdDa2FSR3ih
         vOwc5KHx8KPumnE2KLuq7cKEhX377HuFsGKu0opXr5cH+GH5tZ9+9XBP1FepTPSABiuY
         tCzyR82nWuybMe7hsaJ8rvzXyOPjkMsQfOsJmjvFOVerkxjmkh+aLyDWQrLl3Pmpg0jV
         YnQCxWl+8qItYSszFCh/FAFVRM1M15RJRwA46SOdTMSgyjGTfOU9pKU1XQzExol3aZzD
         LLSQ==
X-Gm-Message-State: AOAM53205iZQGr0FXCpD+aYhU1crTlCfklLchMzxCxrAYJ7Uiy7P7vgb
        JA904Au6aKG/qtqLYK6xaSwkEb4c/rG/pM/nBk4=
X-Google-Smtp-Source: ABdhPJxpaW7zywECX6fFyX+Krw2RMiTHFv3ybP3Ox9kG48BxRU8ONDj8zntQJoGXd3h+hxl4epqeYfnYeR2mkNKy3Ew=
X-Received: by 2002:a63:ce41:: with SMTP id r1mr26906137pgi.203.1595971733131;
 Tue, 28 Jul 2020 14:28:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com> <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch> <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch> <1595922651-sup-5323@galangal.danc.bne.opengear.com>
 <20200728204548.GC1748118@lunn.ch> <7d42152a-2df1-a26c-b619-b804001e0eac@gmail.com>
In-Reply-To: <7d42152a-2df1-a26c-b619-b804001e0eac@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 29 Jul 2020 00:28:36 +0300
Message-ID: <CAHp75VejnW23LEfyEO6Py8=e3_W0YMomk8jQ3JQeHqYcaeDitg@mail.gmail.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO PHY
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Dan Callaghan <dan.callaghan@opengear.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King <linux@armlinux.org.uk>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 11:56 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 7/28/2020 1:45 PM, Andrew Lunn wrote:
> > On Tue, Jul 28, 2020 at 06:06:26PM +1000, Dan Callaghan wrote:
> >> Excerpts from Andrew Lunn's message of 2020-07-24 21:14:36 +02:00:
> >>> Now i could be wrong, but are Ethernet switches something you expect
> >>> to see on ACPI/SBSA platforms? Or is this a legitimate use of the
> >>> escape hatch?
> >>
> >> As an extra data point: right now I am working on an x86 embedded
> >> appliance (ACPI not Device Tree) with 3x integrated Marvell switches.
> >> I have been watching this patch series with great interest, because
> >> right now there is no way for me to configure a complex switch topology
> >> in DSA without Device Tree.
> >>
> >> For the device I am working on, we will have units shipping before these
> >> questions about how to represent Ethernet switches in ACPI can be
> >> resolved. So realistically, we will have to actually configure the
> >> switches using software_node structures supplied by an out-of-tree
> >> platform driver, or some hackery like that, rather than configuring them
> >> through ACPI.
> >
> > Hi Dan
> >
> > I also have an x86 platform, but with a single switch. For that, i
> > have a platform driver, which instantiates a bit banging MDIO bus, and
> > sets up the switch using platform data. This works, but it is limited
> > to internal Copper only PHYs.
>
> At some point I had a dsa2_platform_data implementation which was
> intended to describe more complex switch set-ups and trees, the old code
> is still there for your entertainment:
>
> https://github.com/ffainelli/linux/commits/dsa-pdata

Platform data in the modern kernel is definitely the wrong approach.
Software nodes of firmware nodes can be much more appreciated.

> >> An approach I have been toying with is to port all of DSA to use the
> >> fwnode_handle abstraction instead of Device Tree nodes, but that is
> >> obviously a large task, and frankly I was not sure whether such a patch
> >> series would be welcomed.
> >
> > I would actually suggest you look at using DT. We are struggling to
> > get ACPI maintainers involved with really simple things, like the ACPI
> > equivalent of a phandle from the MAC to the PHY. A full DSA binding
> > for Marvell switches is pretty complex, especially if you need SFP
> > support. I expect the ACPI maintainers will actively run away
> > screaming when you make your proposal.
> >
> > DT can be used on x86, and i suspect it is a much easier path of least
> > resistance.
>
> And you can easily overlay Device Tree to an existing system by using
> either a full Device Tree overlay (dtbo) or using CONFIG_OF_DYNAMIC and
> creating nodes on the fly.

Why do you need DT on a system that runs without it and Linux has all
means to extend to cover a lot of stuff DT provides for other types of
firmware nodes?

-- 
With Best Regards,
Andy Shevchenko
