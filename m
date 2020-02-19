Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C071652CC
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgBSWzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:55:06 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:35683 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbgBSWzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 17:55:05 -0500
Received: by mail-il1-f194.google.com with SMTP id g12so22072997ild.2
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 14:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EpAMqTgPV4b+hRig2cUuoFOjWPXPfch7/PyvuUrynfo=;
        b=MgyJDERiivp1dcjo74oCW8yuyz6aC8CNoXb0F6HsaegPUinGGik9ix6+iP5CnOalk1
         4UjzVEepkpU3z8MTk5mU1ADbPZVRkWYWlS2H4Ct3iRstTrtyq6jQV1GZeFhXFsOfAFJB
         MRF928ZnYXO7aHo00rSYB5EX8sAHKDNNxZMo8Ul4ECu0STSLii2l6X4odKnwts1wmiLc
         pTNby6eBi80K/79yJDmac47n7L1nrvDOPTuR0YKYmrKsNjQkf57nQ77NjximRQjy0WPu
         oxVprbv/W3YU12Npr8w3cr1ssDrya9ovY16d0PyCYB6FmQYHDBnlcloXk0iHLs2HOI/B
         oQgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EpAMqTgPV4b+hRig2cUuoFOjWPXPfch7/PyvuUrynfo=;
        b=gmuBThNebr2Z4ptBAVFZEyMxRD80dc9xmFAIBaQhpshsGRI7TQMrr1autUAx3LvqCY
         THtb7bAi/jakt9fPveMf6Ni/LbKJfzE2Kzgwv6KElshAkkxdN/pdK9BujU/aBJ49SpMZ
         rWtF2YUnvla2yZavc7d1+rDBjcGHCmxvF0M26XcOGUB0o9kUcyuXj7FhEEvdElohigYQ
         crbQb0ZRwcDycR9phkRlRZguLWppr5II8jv5W7KESJg/ErA0/yLa0nSbpMhpKp8cYHtQ
         EjFJROBOq/i+0rEWtxQP6o8zQ0Rr+UBaSil6icnt19xKUonc54IHsAWhl5Ye2QIzjSnq
         /oLg==
X-Gm-Message-State: APjAAAXJE1MBCys70IfxoKoLdpouDjMrJheTqiC7fPa/OMbRWDmt5SDt
        MkfDvOqyBjcNW65L9zc6rHQfFgYWsp337L+2H/oSWQ==
X-Google-Smtp-Source: APXvYqyb15r2mBFqMeHZTZlCfhyqX8qvJmHY5h2wuxudCzKO9l5t9qgNWFv72waBtxlihRgSTFhu7tMKS/98+D5l1K0=
X-Received: by 2002:a92:db49:: with SMTP id w9mr24744338ilq.277.1582152904310;
 Wed, 19 Feb 2020 14:55:04 -0800 (PST)
MIME-Version: 1.0
References: <20200218171321.30990-1-robh@kernel.org> <20200218181356.09ae0779@donnerap.cambridge.arm.com>
In-Reply-To: <20200218181356.09ae0779@donnerap.cambridge.arm.com>
From:   Olof Johansson <olof@lixom.net>
Date:   Wed, 19 Feb 2020 14:54:53 -0800
Message-ID: <CAOesGMg=-w6+gpAmBDV6yfAg-HUk5AZfsKxQ+kYOn56NcB59vA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] Removing Calxeda platform support
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Rob Herring <robh@kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        SoC Team <soc@kernel.org>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk <linux-clk@vger.kernel.org>,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Feb 18, 2020 at 10:14 AM Andre Przywara <andre.przywara@arm.com> wr=
ote:
>
> On Tue, 18 Feb 2020 11:13:10 -0600
> Rob Herring <robh@kernel.org> wrote:
>
> Hi,
>
> > Calxeda has been defunct for 6 years now. Use of Calxeda servers carrie=
d
> > on for some time afterwards primarily as distro builders for 32-bit ARM=
.
> > AFAIK, those systems have been retired in favor of 32-bit VMs on 64-bit
> > hosts.
> >
> > The other use of Calxeda Midway I'm aware of was testing 32-bit ARM KVM
> > support as there are few or no other systems with enough RAM and LPAE. =
Now
> > 32-bit KVM host support is getting removed[1].
> >
> > While it's not much maintenance to support, I don't care to convert the
> > Calxeda DT bindings to schema nor fix any resulting errors in the dts f=
iles
> > (which already don't exactly match what's shipping in firmware).
>
> While every kernel maintainer seems always happy to take patches with a n=
egative diffstat, I wonder if this is really justification enough to remove=
 a perfectly working platform. I don't really know about any active users, =
but experience tells that some platforms really are used for quite a long t=
ime, even if they are somewhat obscure. N900 or Netwinder, anyone?

One of the only ways we know to confirm whether there are active users
or not, is to propose removing a platform.

The good news is that if/when you do, and someone cares enough about
it to want to keep it alive, they should also have access to hardware
and can help out in maintaining it and keeping it in a working state.

For some hardware platforms, at some point in time it no longer makes
sense to keep the latest kernel available on them, especially if
maintainers and others no longer have easy access to hardware and
resources/time to keep it functional.

It's really more about "If you care about this enough to keep it
going, please speak up and help out".

> So to not give the impression that actually *everyone* (from that small s=
ubset of people actively reading the kernel list) is happy with that, I thi=
nk that having support for at least Midway would be useful. On the one hand=
 it's a decent LPAE platform (with memory actually exceeding 4GB), and on t=
he other hand it's something with capable I/O (SATA) and networking, so one=
 can actually stress test the system. Which is the reason I was using that =
for KVM testing, but even with that probably going away now there remain st=
ill some use cases, and be it for general ARM(32) testing.

How many bugs have you found on this platform that you would not have
on a more popular one? And, how many of those bugs only affected this
platform, i.e. just adding onto the support burden without positive
impact to the broader community?

> I don't particularly care about the more optional parts like EDAC, cpuidl=
e, or cpufreq, but I wonder if keeping in at least the rather small SATA an=
d XGMAC drivers and basic platform support is feasible.

At what point are you better off just running under QEMU/virtualization?

> If YAML DT bindings are used as an excuse, I am more than happy to conver=
t those over.
>
> And if anyone has any particular gripes with some code, maybe there is a =
way to fix that instead of removing it? I was always wondering if we could =
get rid of the mach-highbank directory, for instance. I think most of it is=
 Highbank (Cortex-A9) related.

Again, how do you fix it if nobody has signed up for maintaining and
keeping it working? Doing blind changes that might or might not work
is not a way to keep a platform supported.

Just because code is removed, it doesn't mean it can't be reintroduced
when someone comes along and wants to do that. Look at some of the
recent additions of old OLPC hardware support, for example. But
there's a difference between this and keeping the code around hoping
that someone will care about it. It's not lost, and it's easy to bring
back.



-Olof
