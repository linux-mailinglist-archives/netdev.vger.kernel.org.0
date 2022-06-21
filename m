Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267FA553176
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350243AbiFUL5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350237AbiFUL5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:57:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A4E11460;
        Tue, 21 Jun 2022 04:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xQFqvX/2U0sysOS7JlcEgkNOgJ7FhhhaD6YU2rG8wGM=; b=jbni4AfMdOAxiigUTxB7wRppR0
        D5kYFDzS6jHCSYoiNManujTW4YxoyWK0Ndseqf+hKpPEf3vWyUUgmWDAn6K2bL1LZZPWZk9kWNdXV
        b4C/87HPklnO7EAapuNzPYiNrO+QHfrVmOhzmAAKJbR0f895bfXCzLB8jbo0HxjzMp98=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o3cVH-007iX1-Oa; Tue, 21 Jun 2022 13:57:07 +0200
Date:   Tue, 21 Jun 2022 13:57:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, lenb@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA
 description
Message-ID: <YrGyE2boRg9Fy4A4@lunn.ch>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
 <20220621094556.5ev3nencnw7a5xwv@bogus>
 <YrGoXXBgHvyifny3@smile.fi.intel.com>
 <YrGqg5fHB4s+Y7wx@lunn.ch>
 <YrGvfdRF4jNIGzQq@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrGvfdRF4jNIGzQq@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 02:46:05PM +0300, Andy Shevchenko wrote:
> On Tue, Jun 21, 2022 at 01:24:51PM +0200, Andrew Lunn wrote:
> > On Tue, Jun 21, 2022 at 02:15:41PM +0300, Andy Shevchenko wrote:
> > > On Tue, Jun 21, 2022 at 10:45:56AM +0100, Sudeep Holla wrote:
> 
> ...
> 
> > > I dunno we have a such, but the closest I may imagine is MIPI standardization,
> > > that we have at least for cameras and sound.
> > > 
> > > I would suggest to go and work with MIPI for network / DSA / etc area, so
> > > everybody else will be aware of the standard.
> > 
> > It is the same argument as for DT. Other OSes and bootloaders seem to
> > manage digging around in Linux for DT binding documentation. I don't
> > see why bootloaders and other OSes can not also dig around in Linux
> > for ACPI binding documentations.
> > 
> > Ideally, somebody will submit all this for acceptance into ACPI, but
> > into somebody does, i suspect it will just remain a defacto standard
> > in Linux.
> 
> The "bindings" are orthogonal to ACPI specification. It's a vendor / OS / ...
> specific from ACPI p.o.v. It has an UUID field and each UUID may or may not
> be a part of any standard.

We want to avoid snowflakes, each driver doing its own thing,
different to every other driver. So we push as much as possible into
the core, meaning the driver have no choice. So i expect the MDIO part
to look the same for every MDIO bus in Linux using ACPI. I expect the
PHY part to look the same, for every PHY using ACPI in Linux, the DSA
part to look the same, for every DSA switch using linux, because all
the ACPI is in the core of each of these subsystems. The driver only
gets to implement its own properties for anything which is not in one
of these cores.

So you say these bindings are vendor/OS specific, which is great. We
are defining how Linux does this. We are fully open, any other OS or
bootloader can copy it, but it also suggests we don't need to care
about other OSes and bootloaders? That actually seems opposite to DT,
were we do try to share it, and avoid being vendor or OS specific!

    Andrew
