Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461E95530D0
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349258AbiFULY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348439AbiFULYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:24:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2501E7;
        Tue, 21 Jun 2022 04:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FZ/UEYEMWjOlIYXpn4b+wFVai7b+Mp2cQMDTXYu+VaA=; b=amR6q4/WHpPhoD2RHfTx8ODHNv
        TuScfrplmH02qw+h83GmFORlldE1X1vJtFnC1SOKaplD+Jmuoai0cGTNShff4YrkM1a9anbZuz9z4
        E5iKZjHBDsEiePPk/cRaafU4HJTbGolI7f6B5IBFQISS4UjLxhT1tDYSAnGCDfhGC3HE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o3c03-007iHx-Sl; Tue, 21 Jun 2022 13:24:51 +0200
Date:   Tue, 21 Jun 2022 13:24:51 +0200
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
Message-ID: <YrGqg5fHB4s+Y7wx@lunn.ch>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
 <20220621094556.5ev3nencnw7a5xwv@bogus>
 <YrGoXXBgHvyifny3@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrGoXXBgHvyifny3@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 02:15:41PM +0300, Andy Shevchenko wrote:
> On Tue, Jun 21, 2022 at 10:45:56AM +0100, Sudeep Holla wrote:
> > On Mon, Jun 20, 2022 at 05:02:22PM +0200, Marcin Wojtas wrote:
> > > Describe the Distributed Switch Architecture (DSA) - compliant
> > > MDIO devices. In ACPI world they are represented as children
> > > of the MDIO busses, which are responsible for their enumeration
> > > based on the standard _ADR fields and description in _DSD objects
> > > under device properties UUID [1].
> > > 
> > > [1] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> 
> > Why is this document part of Linux code base ?
> 
> It's fine, but your are right with your latter questions.
> 
> > How will the other OSes be aware of this ?
> 
> Should be a standard somewhere.
> 
> > I assume there was some repository to maintain such DSDs so that it
> > is accessible for other OSes. I am not agreeing or disagreeing on the
> > change itself, but I am concerned about this present in the kernel
> > code.
> 
> I dunno we have a such, but the closest I may imagine is MIPI standardization,
> that we have at least for cameras and sound.
> 
> I would suggest to go and work with MIPI for network / DSA / etc area, so
> everybody else will be aware of the standard.

It is the same argument as for DT. Other OSes and bootloaders seem to
manage digging around in Linux for DT binding documentation. I don't
see why bootloaders and other OSes can not also dig around in Linux
for ACPI binding documentations.

Ideally, somebody will submit all this for acceptance into ACPI, but
into somebody does, i suspect it will just remain a defacto standard
in Linux.

   Andrew
