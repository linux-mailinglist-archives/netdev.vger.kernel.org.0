Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193D627D131
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbgI2Ocs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:32:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33726 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgI2Ocr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 10:32:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNGgJ-00GlXJ-G4; Tue, 29 Sep 2020 16:32:39 +0200
Date:   Tue, 29 Sep 2020 16:32:39 +0200
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
Message-ID: <20200929143239.GI3950513@lunn.ch>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
 <20200929051703.GA10849@lsv03152.swis.in-blr01.nxp.com>
 <20200929134302.GF3950513@lunn.ch>
 <CAHp75VcMbNqizMnwz_SwBEs=yPG0+uL38C0XeS7r_RqFREj7zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VcMbNqizMnwz_SwBEs=yPG0+uL38C0XeS7r_RqFREj7zQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 04:55:40PM +0300, Andy Shevchenko wrote:
> On Tue, Sep 29, 2020 at 4:43 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > On Tue, Sep 29, 2020 at 10:47:03AM +0530, Calvin Johnson wrote:
> > > On Fri, Sep 25, 2020 at 02:34:21PM +0100, Grant Likely wrote:
> 
> ...
> 
> > Newbie ACPI question: Does ACPI even support big endian CPUs, given
> > its x86 origins?
> 
> I understand the newbie part, but can you elaborate what did you mean
> under 'support'?
> To me it sounds like 'network stack was developed for BE CPUs, does it
> support LE ones?'

Does ACPI define the endianness of its tables? Is it written in the
standard that they should be little endian?  Does Tianocore, or any
other implementations, have the needed le32_to_cpu() calls so that
they can boot on a big endian CPU? Does it have a standardized way of
saying a device is big endian, swap words around if appropriate when
doing IO?

Is it feasible to boot an ARM system big endian? Can i boot the same
system little endian? The CPU should be able to do it, but are the
needed things in the ACPI specification and implementation to allow
it?

	Andrew

