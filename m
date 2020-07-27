Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0139222F677
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbgG0RVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:21:42 -0400
Received: from foss.arm.com ([217.140.110.172]:48270 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgG0RVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 13:21:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89E6A30E;
        Mon, 27 Jul 2020 10:21:41 -0700 (PDT)
Received: from bogus (unknown [10.37.12.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F27E73F718;
        Mon, 27 Jul 2020 10:21:38 -0700 (PDT)
Date:   Mon, 27 Jul 2020 18:21:36 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        linux.cj@gmail.com, linux-acpi@vger.kernel.org
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200727172136.GC8003@bogus>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724191436.GH1594328@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 09:14:36PM +0200, Andrew Lunn wrote:
> > Hence my previous comment that we should consider this an escape
> > hatch rather than the last word in how to describe networking on
> > ACPI/SBSA platforms.
>
> One problem i have is that this patch set suggests ACPI can be used to
> describe complex network hardware. It is opening the door for others
> to follow and add more ACPI support in networking. How long before it
> is not considered an escape hatch, but the front door?
>

I understand your concerns here. But as I mentioned in other email in
the same thread, it is very tricky problem to solve as no one is ready
to take up and maintain these.

> For an example, see
>
> https://patchwork.ozlabs.org/project/netdev/patch/1595417547-18957-3-git-send-email-vikas.singh@puresoftware.com/
>
> It is hard to see what the big picture is here. The [0/2] patch is not
> particularly good. But it makes it clear that people are wanting to
> add fixed-link PHYs into ACPI. These are pseudo devices, used to make
> the MAC think it is connected to a PHY when it is not. The MAC still
> gets informed of link speed, etc via the standard PHYLIB API. They are
> mostly used for when the Ethernet MAC is directly connected to an
> Ethernet Switch, at a MAC to MAC level.
>
> Now i could be wrong, but are Ethernet switches something you expect
> to see on ACPI/SBSA platforms? Or is this a legitimate use of the
> escape hatch?
>

My guess is that similar products running on other architectures(namely
x86) might be running ACPI and hence the push to have ACPI on such ARM
systems. It may weak argument for that and I agree with it. I want to
think it as legitimate use here but I am well aware and afraid that this
may become front door instead of escape hatch.

Sorry, I am not helpful at all, but I am just sharing my personal opinion
on this matter.

--
Regards,
Sudeep
