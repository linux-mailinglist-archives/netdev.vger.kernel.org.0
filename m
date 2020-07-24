Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388F522CE89
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 21:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGXTOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 15:14:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54222 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgGXTOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 15:14:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jz39Q-006iXQ-To; Fri, 24 Jul 2020 21:14:36 +0200
Date:   Fri, 24 Jul 2020 21:14:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200724191436.GH1594328@lunn.ch>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hence my previous comment that we should consider this an escape
> hatch rather than the last word in how to describe networking on
> ACPI/SBSA platforms.

One problem i have is that this patch set suggests ACPI can be used to
describe complex network hardware. It is opening the door for others
to follow and add more ACPI support in networking. How long before it
is not considered an escape hatch, but the front door?

For an example, see

https://patchwork.ozlabs.org/project/netdev/patch/1595417547-18957-3-git-send-email-vikas.singh@puresoftware.com/

It is hard to see what the big picture is here. The [0/2] patch is not
particularly good. But it makes it clear that people are wanting to
add fixed-link PHYs into ACPI. These are pseudo devices, used to make
the MAC think it is connected to a PHY when it is not. The MAC still
gets informed of link speed, etc via the standard PHYLIB API. They are
mostly used for when the Ethernet MAC is directly connected to an
Ethernet Switch, at a MAC to MAC level.

Now i could be wrong, but are Ethernet switches something you expect
to see on ACPI/SBSA platforms? Or is this a legitimate use of the
escape hatch?

       Andrew
