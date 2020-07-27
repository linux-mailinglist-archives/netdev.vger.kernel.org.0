Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D600722F602
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgG0RD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:03:29 -0400
Received: from foss.arm.com ([217.140.110.172]:47974 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729567AbgG0RDV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 13:03:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C722E30E;
        Mon, 27 Jul 2020 10:03:20 -0700 (PDT)
Received: from bogus (unknown [10.37.12.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45DFF3F718;
        Mon, 27 Jul 2020 10:03:18 -0700 (PDT)
Date:   Mon, 27 Jul 2020 18:03:14 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        linux.cj@gmail.com, linux-acpi@vger.kernel.org
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200727170314.GB8003@bogus>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <a95f8e07-176b-7f22-1217-466205fa22e7@gmail.com>
 <20200724192008.GI1594328@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724192008.GI1594328@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 09:20:08PM +0200, Andrew Lunn wrote:
> > We are at v7 of this patch series, and no authoritative ACPI Linux
> > maintainer appears to have reviewed this, so there is no clear sign of
> > this converging anywhere. This is looking a lot like busy work for
> > nothing. Given that the representation appears to be wildly
> > misunderstood and no one seems to come up with something that reaches
> > community agreement, what exactly is the plan here?
>
> I think we need to NACK all attempts to add ACPI support to phylib and
> phylink until an authoritative ACPI Linux maintainer makes an
> appearance and actively steers the work. And not just this patchset,
> but all patchsets in the networking domain which have an ACPI
> component.
>

Unfortunately, this is one such problem that can never be solved easily
TBH.

We, in Linux kernel community had lots of discussion around _DSD and
how it can be misused if not moderated after the introduction of ACPI
support on Arm. It is useful property used by the kernel today both
on x86 and Arm. Even other OS vendors do use, but the standard body
recently deprecated the process we introduced few years back[1] as it
really never kicked off. All OS vendors have introduced the properties
as they need and have supported without a formal registry and this is
the argument made to deprecate that process.

As a general rule, we say no to any new property added unless there is
no existing solution for the same. It might just expand exponential if
not controlled. So if networking folks agree that there is a need for
it and there exists no alternative solution, then we may need to add
the support for the same. I don't have strong objection as I have least
knowledge in network domain.

But I agree, there exists a possibility of duplication of properties
amongst different OS vendors and could be argument on the other side.

--
Regards,
Sudeep

[1] http://www.uefi.org/sites/default/files/resources/web-page-v2.pdf
