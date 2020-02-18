Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0869162EC2
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgBRSkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:40:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbgBRSkY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 13:40:24 -0500
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3BA124656;
        Tue, 18 Feb 2020 18:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582051223;
        bh=e0prGkshvWw2XTwL3+iei7JE8F3vbsgEto2sLKzoNxY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZbapHghKemvj/oI+zpPIruW3rQ0y+/IGCFK4hWmOUDx7Vi4fNxeSS/WMkU/tOfVw6
         5U9tzmE0siFMLLMGiimacSWFAD6i3onMYAlpQEevIhoPtM05rP/W3Mn7mRRqz8OUEZ
         FvJ+rEAk2hZeuYncgmnHdz8KREoKXg7XPBgExTnc=
Received: by mail-qk1-f170.google.com with SMTP id h4so20556083qkm.0;
        Tue, 18 Feb 2020 10:40:22 -0800 (PST)
X-Gm-Message-State: APjAAAXMOybWhbMjP/PI5WyTkGrIoj25iB3wKpVv2e+lmQsAhJTKVBQW
        6myrge+bZL3RZnK73O4cu1nqjyZvPb1bDrWCqQ==
X-Google-Smtp-Source: APXvYqzzc5l2bT41Ulxw896RzAsZHa163jCmWCxKmNgy3aUdTfnzFWB1uBJXqNRZFmClh71pLAlutTDYlRFRVHXfwrQ=
X-Received: by 2002:ae9:f205:: with SMTP id m5mr20551704qkg.152.1582051221993;
 Tue, 18 Feb 2020 10:40:21 -0800 (PST)
MIME-Version: 1.0
References: <20200218171321.30990-1-robh@kernel.org> <20200218181356.09ae0779@donnerap.cambridge.arm.com>
In-Reply-To: <20200218181356.09ae0779@donnerap.cambridge.arm.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 18 Feb 2020 12:40:10 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJpDLn5Zr2UHno1TeReqrwZ-HAAfd78AouigGi4sAQuOw@mail.gmail.com>
Message-ID: <CAL_JsqJpDLn5Zr2UHno1TeReqrwZ-HAAfd78AouigGi4sAQuOw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] Removing Calxeda platform support
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        soc@kernel.org, Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk <linux-clk@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev <netdev@vger.kernel.org>,
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

On Tue, Feb 18, 2020 at 12:14 PM Andre Przywara <andre.przywara@arm.com> wr=
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
>
> So to not give the impression that actually *everyone* (from that small s=
ubset of people actively reading the kernel list) is happy with that, I thi=
nk that having support for at least Midway would be useful. On the one hand=
 it's a decent LPAE platform (with memory actually exceeding 4GB), and on t=
he other hand it's something with capable I/O (SATA) and networking, so one=
 can actually stress test the system. Which is the reason I was using that =
for KVM testing, but even with that probably going away now there remain st=
ill some use cases, and be it for general ARM(32) testing.

Does LPAE with more than 4GB actually need to work if there's not
another platform out there?

> I don't particularly care about the more optional parts like EDAC, cpuidl=
e, or cpufreq, but I wonder if keeping in at least the rather small SATA an=
d XGMAC drivers and basic platform support is feasible.

cpuidle isn't actually stable from what I remember. I think without
cpufreq, we default to 1.1GHz instead of 1.4.

> If YAML DT bindings are used as an excuse, I am more than happy to conver=
t those over.

Thanks!

>
> And if anyone has any particular gripes with some code, maybe there is a =
way to fix that instead of removing it? I was always wondering if we could =
get rid of the mach-highbank directory, for instance. I think most of it is=
 Highbank (Cortex-A9) related.

All the reset/suspend/poweroff and coherency parts are shared. The SCU
and L2 parts could be removed, but not really worth the surgery IMO.

Rob
