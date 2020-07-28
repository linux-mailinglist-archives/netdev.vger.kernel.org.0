Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29688231401
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgG1Uep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:34:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60680 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728529AbgG1Ueo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:34:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0WJ3-007LCj-8V; Tue, 28 Jul 2020 22:34:37 +0200
Date:   Tue, 28 Jul 2020 22:34:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sudeep Holla <sudeep.holla@arm.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org,
        Vikas Singh <vikas.singh@puresoftware.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200728203437.GB1748118@lunn.ch>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch>
 <20200727172136.GC8003@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727172136.GC8003@bogus>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Everybody

So i think it is time to try to bring this discussion to some sort of
conclusion.

No ACPI maintainer is willing to ACK any of these patches. Nor are
they willing to NACK them. ACPI maintainers simply don't want to get
involved in making use of ACPI in networking.

I personally don't have the knowledge to do ACPI correctly, review
patches, point people in the right direction. I suspect the same can
be said for the other PHY maintainers.

Having said that, there is clearly a wish from vendors to make use of
ACPI in the networking subsystem to describe hardware.

How do we go forward?

For the moment, we will need to NACK all patches adding ACPI support
to the PHY subsystem.

Vendors who really do want to use ACPI, not device tree, probably
need to get involved in standardisation. Vendors need to submit a
proposal to UEFI and get it accepted.

Developers should try to engage with the ACPI maintainers and see
if they can get them involved in networking. Patches with an
Acked-by from an ACPI maintainer will be accepted, assuming they
fulfil all the other usual requirements. But please don't submit
patches until you do have an ACPI maintainer on board. We don't
want to spamming the lists with NACKs all the time.

     Andrew
