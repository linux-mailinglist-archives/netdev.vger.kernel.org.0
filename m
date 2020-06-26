Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFBD20B2A3
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 15:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgFZNjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 09:39:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33866 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgFZNjt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 09:39:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jooZy-002NAM-1d; Fri, 26 Jun 2020 15:39:42 +0200
Date:   Fri, 26 Jun 2020 15:39:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org,
        "Rajesh V. Bikkina" <rajesh.bikkina@nxp.com>
Subject: Re: [net-next PATCH v1] net: dpaa2-mac: Add ACPI support for DPAA2
 MAC driver
Message-ID: <20200626133942.GD504133@lunn.ch>
References: <20200625043538.25464-1-calvin.johnson@oss.nxp.com>
 <20200625194211.GA535869@lunn.ch>
 <20200626132024.GA15707@lsv03152.swis.in-blr01.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626132024.GA15707@lsv03152.swis.in-blr01.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew
> 
> As you know, making this code generic would bring us back to waiting for
> ACPI team's approval which is very difficult to get as the ACPI doesn't
> have any opinion on MDIO bus.
> 
> Like other ACPI ethernet drivers, can't we keep it local to this driver to
> avoid the above issue?

Hi Calvin

That does not scale. Every driver doing its own thing. Each having its
own bugs, maintenance overheads, documentation problems, no meta
validation of the ACPI tables because every table is different,
etc. Where is the Advanced in that? It sounds more like Primitive,
Chaotic, Antiquated?

Plus having it generic means there is one place which needs
modifications when the ACPI standards committee does decide how this
should be done.

> If we plan to make this approach generic, then it may have to be put in:
> Documentation/firmware-guide/acpi/

So looking in this directory, we have defacto standards,
e.g. linux/Documentation/firmware-guide/acpi/dsd/leds.rst.

So lets add another defacto standard, how you find a PHY.

   Andrew
