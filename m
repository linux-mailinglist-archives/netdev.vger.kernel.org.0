Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F16F27D21F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731469AbgI2PGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 11:06:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33822 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgI2PGc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 11:06:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNHCw-00Gljc-7s; Tue, 29 Sep 2020 17:06:22 +0200
Date:   Tue, 29 Sep 2020 17:06:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        nd <nd@arm.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200929150622.GK3950513@lunn.ch>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
 <20200929051703.GA10849@lsv03152.swis.in-blr01.nxp.com>
 <20200929134302.GF3950513@lunn.ch>
 <CAHp75VcMbNqizMnwz_SwBEs=yPG0+uL38C0XeS7r_RqFREj7zQ@mail.gmail.com>
 <20200929143239.GI3950513@lunn.ch>
 <CAHp75VfjOBDpuY_df1wdxUUfFQV_t_k2PjrwHjd0dvE3jojZ=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfjOBDpuY_df1wdxUUfFQV_t_k2PjrwHjd0dvE3jojZ=w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Does it have a standardized way of
> > saying a device is big endian, swap words around if appropriate when
> > doing IO?
> 
> I guess this is not applicable to ACPI. Does Linux have a standardized way?

DT does. You add the property 'little-endian' to indicate you should
do IO to the device using little endian.

> So, what did you mean under doing I/O? I mean in which context?

NXP can synthesise the MDIO controller either big endian, or little
endian. So on some SoCs we need to tell the driver to talk to the
hardware using big endian accesses. On other SoCs we need to tell the
driver to talk to the hardware using little endian.

Is there a standard way in ACPI to describe this?

   Andrew
