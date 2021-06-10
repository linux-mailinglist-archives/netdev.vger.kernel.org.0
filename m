Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06B73A3310
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhFJS1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:27:52 -0400
Received: from mail-oi1-f175.google.com ([209.85.167.175]:35363 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhFJS1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:27:52 -0400
Received: by mail-oi1-f175.google.com with SMTP id v22so3121256oic.2;
        Thu, 10 Jun 2021 11:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x9O7WDb0h2yPXvCI9h/Ix7Roza/ERoBJnbg0xo/9sf0=;
        b=dzC85EIwRWlQxslgYu4LxPJ8uwzsPoQsLUNqokjCN3JZy/1UXgM684OiXVsJKPehR8
         1Ys6DZYvLpkgD2spozPNabObTMM4CHdgPAa3bk6ynS4gFHv1/6YUTf7r2IF2KIyAxogL
         WjxXNhW0kvOxbipRFVqbmPpIqMKswe08Ko79LtjO+MqXHrMIw4eMRqKSuHwMeKtiQ08y
         9ZWz6hQtUCTKK9ZH84VRt0eXWMT3ONXxRpTsnGonMUOa2pjT9zPpNxm2WKgVL2tTnxjH
         ovYyezB3HebHBdTQGzO7Rj3SMqnqc9XqtO1wAB/hGaEZszGTD7Fw2dTSBHFjWYg+wVTJ
         Fblw==
X-Gm-Message-State: AOAM530KP/2QUIvMROjBiCBSBYTSkJZcjEx0c7uypZtZXWboCkhrVDKw
        NxMLZCy7MYjGlItonSyf5L1r5c5eAJoJ59lQBNKmpYTQ
X-Google-Smtp-Source: ABdhPJzlnt/h+1MlN1oNGI21u1ESMKIHRQClj/dTxQUQ797NGn26Ug/+PysQw30jmtLu21x6u/X3P6756WsFYYK0u8M=
X-Received: by 2002:a05:6808:f08:: with SMTP id m8mr1266505oiw.69.1623349544872;
 Thu, 10 Jun 2021 11:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
 <YMJEMXEDAE/m9MhA@lunn.ch> <CABdtJHv-Xu5bC2-T7a0UgbYpkNP1SLfWwdLWLLKj5MBvA2Ajyw@mail.gmail.com>
In-Reply-To: <CABdtJHv-Xu5bC2-T7a0UgbYpkNP1SLfWwdLWLLKj5MBvA2Ajyw@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 10 Jun 2021 20:25:33 +0200
Message-ID: <CAJZ5v0iNTaFQuZZid77qTpfbs-4YdDgZdcC+rt4+mXV9f=OpTA@mail.gmail.com>
Subject: Re: [PATCH net-next v8 00/15] ACPI support for dpaa2 driver
To:     Jon Nettleton <jon@solid-run.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ciorneiioana@gmail.com>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 7:51 PM Jon Nettleton <jon@solid-run.com> wrote:
>
> On Thu, Jun 10, 2021 at 6:56 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Thu, Jun 10, 2021 at 07:39:02PM +0300, Ioana Ciornei wrote:
> > > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > >
> > > This patch set provides ACPI support to DPAA2 network drivers.
> >
> > Just to be clear and avoid confusion, there is a standing NACK against
> > this patchset. Please see the discussion here:
> >
> > https://patchwork.kernel.org/project/linux-acpi/patch/20200715090400.4733-2-calvin.johnson@oss.nxp.com/#23518385
> >
> > So far, i've not seen any indication the issues raised there have been
> > resolved. I don't see any Acked-by from an ACPI maintainer. So this
> > code remains NACKed.
>
> Andrew,
>
> The ACPI maintainers did bless the use of the ACPI standards followed
> in this patchset, and their only abstinence from ACK'ing the patchset
> was whether the code was used in production systems.  Well currently,
> not only have we, SolidRun, been using this patchset and the associated
> ACPI tables in our SystemsReady certified firmware for the HoneyComb,
> but we also have customers using this same patchset and firmware on
> their systems rolled out to customers.
>
> Additionally we have an entire new product line based on Marvell's
> Armada CN913x series, which also needs this patchset to be fully
> functional.
>
> I am quite certain this is more than enough production systems using
> this ACPI description method for networking to progress this patchset
> forward.

And I believe that you have all of the requisite ACKs from the ACPI
side now, so it is up to the networking guys to decide what to do
next.

Thanks,
Rafael
