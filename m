Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4707F232211
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgG2QAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:00:52 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34771 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgG2QAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 12:00:52 -0400
Received: by mail-oi1-f195.google.com with SMTP id q4so9396867oia.1;
        Wed, 29 Jul 2020 09:00:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p0Y+Of9nO9ViApSeALIlEmJwdSnO9om2LOq636DVfDc=;
        b=r9ybpXzI60tYiekctdQjNJB0ln43dB+hLBijzknfwg7LUR4j5WXc4Y3psRJpGYotSz
         o81xvPlvzQBoeYjucdbjhXgBYRkJdnPjE5VWxi6RjAwFoiEiY67MVdbnC8at+K57bMjH
         vk0HXHlt9GIyiNn14OhzFekWC6+ibz1w5oU0CoUZx4O6LSUuQ5eW0rd18sliC/JNZh0X
         EdkFqLUglCvt/LPEIW6l3yI/fbAMCM8vDYqDT0KsZyYZgs/q93xPDBu464oIXfvyWXC7
         qTbchB9uNZGQqcH3pO+JkpajK5g0mx7Qt70kIUguypvVECkiBYb2gu9d5vSVkYEu4AZY
         Xsmg==
X-Gm-Message-State: AOAM5309w0LB8/wBqVZFUIX1Z4n3PTNsSUKzirELEpgiArwPjBGY71gg
        +eFmXa/tNZCZz2uegT89CgMOjAJs+vyrBkbR7WTOKn1U
X-Google-Smtp-Source: ABdhPJwh0fLZ3K43GmgVaI2Q+8DibZfSZb5MYzM1MraFc+NlCjA7MnR18oVv1iZJAyaiWwWgBcnxOAbh+fvYxjwMooA=
X-Received: by 2002:aca:4a89:: with SMTP id x131mr8727867oia.103.1596038451170;
 Wed, 29 Jul 2020 09:00:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com> <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch> <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch> <20200727172136.GC8003@bogus> <20200728203437.GB1748118@lunn.ch>
In-Reply-To: <20200728203437.GB1748118@lunn.ch>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 29 Jul 2020 18:00:39 +0200
Message-ID: <CAJZ5v0i+a+MS+J_auuuMmq25c1HNb7oV2sqQ87WOtfBBQ6MF7w@mail.gmail.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Vikas Singh <vikas.singh@puresoftware.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, Jul 28, 2020 at 10:34 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Hi Everybody
>
> So i think it is time to try to bring this discussion to some sort of
> conclusion.
>
> No ACPI maintainer is willing to ACK any of these patches. Nor are
> they willing to NACK them.

Let's first clarify one thing: ACPI maintainers take care of the
generic code implementing the interactions between the OS and the
platform firmware in accordance with ACPI (which is an interface
specification to be precise).  They do not set rules on what
ACPI-related things device drivers can do.  Those rules are set in the
ACPI specification and other standard definitions (like PCI, USB,
etc.) and they just need to be followed.  So ACPI maintainers cannot
"bless" any new rule to be followed going forward.

An ACPI maintainer can tell you whether or not some driver code
follows the rules set by the ACPI specification (or conventions
related to using the ACPI support code in the kernel) and that's about
it.

In this particular case, a bit of ACPI-related code is there in the
last two patches and it doesn't look broken.  It uses the ACPI side of
the device properties API correctly AFAICS.

Also, from a slightly broader perspective, this patch series adds an
ability to look up certain device properties in the ACPI namespace.
That appears to be done in accordance with all of the rules set so
far, so there is nothing wrong with it in principle.

However, if those properties are never going to be supplied via ACPI
on any production systems, the code added in order to be able to
process them will turn out to be useless and I don't think anyone
wants useless code in the kernel.

So the real question is whether or not there will be production
systems in which those properties will be supplied via ACPI and I
cannot answer that question.  Therefore I cannot ACK the patches
(because I don't know whether or not the code added by them is going
to be useful), but I cannot NACK them either, because the code added
by them looks correct to me.

> ACPI maintainers simply don't want to get
> involved in making use of ACPI in networking.

That's not about making use of ACPI in networking in general (which
already happens in many ways), but about a specific use of ACPI for a
specific purpose related to networking.

> I personally don't have the knowledge to do ACPI correctly, review
> patches, point people in the right direction. I suspect the same can
> be said for the other PHY maintainers.
>
> Having said that, there is clearly a wish from vendors to make use of
> ACPI in the networking subsystem to describe hardware.
>
> How do we go forward?

Basically, the interested vendors need to agree on how exactly they
want ACPI to be used and come up with a specification setting the
rules to be followed by the platform firmware on the one side and by
the code in the kernel on the other side.

> For the moment, we will need to NACK all patches adding ACPI support
> to the PHY subsystem.
>
> Vendors who really do want to use ACPI, not device tree, probably
> need to get involved in standardisation. Vendors need to submit a
> proposal to UEFI and get it accepted.

The UEFI Forum maintains the ACPI specification itself (so changes to
the specification need to be accepted by it), but it is not uncommon
for a group of vendors (or even one vendor in some cases) to come up
with additional rules and specify them separately.  Of course,
involving the UEFI Forum may help to simplify things from the legal
and spec hosting perspective, but I don't think it is mandatory.

In the particular case at hand the additional rules may just be based
on the analogous DT bindings, but they need to be officially defined.

> Developers should try to engage with the ACPI maintainers and see
> if they can get them involved in networking. Patches with an
> Acked-by from an ACPI maintainer will be accepted, assuming they
> fulfil all the other usual requirements. But please don't submit
> patches until you do have an ACPI maintainer on board. We don't
> want to spamming the lists with NACKs all the time.

Well, do you ask for a PCI maintainer ACK on a patch adding a PCI
driver for a NIC as a rule?  If not, I don't see a reason for making
ACPI an exception.

Besides, you really should be asking for a spec the work is based on,
IMO, instead of asking for an ACPI maintainer ACK which is not going
to be sufficient if the former is missing anyway.

Thanks!
