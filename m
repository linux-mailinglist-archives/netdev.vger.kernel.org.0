Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37E3234833
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 17:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732291AbgGaPIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 11:08:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37060 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbgGaPIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 11:08:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k1Wdz-007iHg-2n; Fri, 31 Jul 2020 17:08:23 +0200
Date:   Fri, 31 Jul 2020 17:08:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
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
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200731150823.GH1712415@lunn.ch>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch>
 <20200727172136.GC8003@bogus>
 <20200728203437.GB1748118@lunn.ch>
 <CAJZ5v0i+a+MS+J_auuuMmq25c1HNb7oV2sqQ87WOtfBBQ6MF7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0i+a+MS+J_auuuMmq25c1HNb7oV2sqQ87WOtfBBQ6MF7w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> However, if those properties are never going to be supplied via ACPI
> on any production systems, the code added in order to be able to
> process them will turn out to be useless and I don't think anyone
> wants useless code in the kernel.
> 
> So the real question is whether or not there will be production
> systems in which those properties will be supplied via ACPI and I
> cannot answer that question.

Hi Rafael

I suspect we are going to have a lot of newbie ACPI questions over the
next few weeks/months as vendors and the PHY maintainers get up to
speed on all this.

In the device tree world, we would expect a patch as part of the
patchset to a device tree file somewhere under arch/*/boot/dts to make
use of any new property added. We then know it is used.

How does this work in the ACPI world?  How does somebody show they are
supplying the property in a production system?

> Basically, the interested vendors need to agree on how exactly they
> want ACPI to be used and come up with a specification setting the
> rules to be followed by the platform firmware on the one side and by
> the code in the kernel on the other side.

...

> Besides, you really should be asking for a spec the work is based on,
> IMO, instead of asking for an ACPI maintainer ACK which is not going
> to be sufficient if the former is missing anyway.

Could you point us towards real world example specs? Giving us a good
best practice example would likely help us to do this work. And reduce
the amount of work you need to do keeping the process going in the
correct direction.

Thanks
	Andrew
