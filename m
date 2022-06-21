Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9847553095
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349184AbiFULSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349175AbiFULSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:18:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4CD289AA;
        Tue, 21 Jun 2022 04:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7vOo5p0yQrz8WvA9OW0P/gHDo5luj3WAxgSKgWBriNM=; b=6ZJJRVIprvtfY3nIuee+3aB2we
        QiYsFG3+otBHZgSQ3k9TVyggTrFkrzXw9fLthopF7SW6V2E6YXgAFzYmIy7GKREtifJl4asoYPq5T
        YXx2sbjr2oKlB2JYnL1eirrvcSGH05kGbYdJk9zbdvxxqeIanZ326qUWLU5srR9l6YBA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o3bu2-007iEV-1l; Tue, 21 Jun 2022 13:18:38 +0200
Date:   Tue, 21 Jun 2022 13:18:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Marcin Wojtas <mw@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, lenb@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA
 description
Message-ID: <YrGpDgtm4rPkMwnl@lunn.ch>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
 <YrDO05TMK8SVgnBP@lunn.ch>
 <YrGm2jmR7ijHyQjJ@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrGm2jmR7ijHyQjJ@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 02:09:14PM +0300, Andy Shevchenko wrote:
> On Mon, Jun 20, 2022 at 09:47:31PM +0200, Andrew Lunn wrote:
> 
> ...
> 
> > > +        Name (_CRS, ResourceTemplate ()
> > > +        {
> > > +            Memory32Fixed (ReadWrite,
> > > +                0xf212a200,
> > > +                0x00000010,
> > 
> > What do these magic numbers mean?
> 
> Address + Length, it's all described in the ACPI specification.

The address+plus length of what? This device is on an MDIO bus. As
such, there is no memory! It probably makes sense to somebody who
knows ACPI, but to me i have no idea what it means.

> Or if you asked
> why the values there are the particular numbers? I guess it's fined to have
> anything sane in the example. OTOH a comment may be added.
> 
> > > +                )
> > > +        })
> 
> ...
> 
> > > +        Device (SWI0)
> > > +        {
> > > +            Name (_HID, "MRVL0120")
> > > +            Name (_UID, 0x00)
> > > +            Name (_ADR, 0x4)
> > > +            <...>
> > > +        }
> > 
> > I guess it is not normal for ACPI, but could you add some comments
> > which explain this. In DT we have
> > 
> >     properties:
> >       reg:
> >         minimum: 0
> >         maximum: 31
> >         description:
> >           The ID number for the device.
> > 
> > which i guess what this _ADR property is, but it would be nice if it
> > actually described what it is supposed to mean. You have a lot of
> > undocumented properties here.
> 
> Btw, you are right, _ADR mustn't go together with _HID/_CID.

Does ACPI have anything like .yaml to describe the binding and tools
to validate it?

   Andrew
