Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEBC5549B9
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiFVJ72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237443AbiFVJ7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:59:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5F13A1AF;
        Wed, 22 Jun 2022 02:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=UBYcbr5Blkb1m1XbSmhN6zU/XE1KbkQTUN0OktUTIP8=; b=H+
        64lTmas6Byuhd/uije30ow2tTek3n1bIjT2R/eSXCX4uXU7gP+GlF4mu89gZr6rhnK/4rd18a6qgh
        9C7r7PcdWKuFnHOZ0M+WwZAXGQq7x8O3dTh3NatD96pdKgtK/LSO8YXnXtlMWF7sijtW9Hw1aENzX
        dwNNF+cFxmIeVz4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o3wal-007ppS-Mh; Wed, 22 Jun 2022 11:24:07 +0200
Date:   Wed, 22 Jun 2022 11:24:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA
 description
Message-ID: <YrLft+BrP2jI5lwp@lunn.ch>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
 <YrDO05TMK8SVgnBP@lunn.ch>
 <YrGm2jmR7ijHyQjJ@smile.fi.intel.com>
 <YrGpDgtm4rPkMwnl@lunn.ch>
 <YrGukfw4uiQz0NpW@smile.fi.intel.com>
 <CAPv3WKf_2QYh0F2LEr1DeErvnMeQqT0M5t40ROP2G6HSUwKpQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKf_2QYh0F2LEr1DeErvnMeQqT0M5t40ROP2G6HSUwKpQQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 11:08:13AM +0200, Marcin Wojtas wrote:
> wt., 21 cze 2022 o 13:42 Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> napisał(a):
> >
> > On Tue, Jun 21, 2022 at 01:18:38PM +0200, Andrew Lunn wrote:
> > > On Tue, Jun 21, 2022 at 02:09:14PM +0300, Andy Shevchenko wrote:
> > > > On Mon, Jun 20, 2022 at 09:47:31PM +0200, Andrew Lunn wrote:
> >
> > ...
> >
> > > > > > +        Name (_CRS, ResourceTemplate ()
> > > > > > +        {
> > > > > > +            Memory32Fixed (ReadWrite,
> > > > > > +                0xf212a200,
> > > > > > +                0x00000010,
> > > > >
> > > > > What do these magic numbers mean?
> > > >
> > > > Address + Length, it's all described in the ACPI specification.
> > >
> > > The address+plus length of what? This device is on an MDIO bus. As
> > > such, there is no memory! It probably makes sense to somebody who
> > > knows ACPI, but to me i have no idea what it means.
> >
> > I see what you mean. Honestly I dunno what the device this description is for.
> > For the DSA that's behind MDIO bus? Then it's definitely makes no sense and
> > MDIOSerialBus() resources type is what would be good to have in ACPI
> > specification.
> >
> 
> It's not device on MDIO bus, but the MDIO controller's register itself

Ah. So this is equivalent to

                CP11X_LABEL(mdio): mdio@12a200 {
                        #address-cells = <1>;
                        #size-cells = <0>;
                        compatible = "marvell,orion-mdio";
                        reg = <0x12a200 0x10>;
                        clocks = <&CP11X_LABEL(clk) 1 9>, <&CP11X_LABEL(clk) 1 5>,
                                 <&CP11X_LABEL(clk) 1 6>, <&CP11X_LABEL(clk) 1 18>;
                        status = "disabled";
                };

DT seems a lot more readable, "marvell,orion-mdio" is a good hint that
device this is. But maybe it is more readable because that is what i'm
used to.

Please could you add a lot more comments. Given that nobody currently
actually does networking via ACPI, we have to assume everybody trying
to use it is a newbie, and more comments are better than less.

Thanks
	Andrew
