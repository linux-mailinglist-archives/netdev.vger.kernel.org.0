Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF85553132
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348826AbiFULmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349655AbiFULmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:42:19 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F55B25E5;
        Tue, 21 Jun 2022 04:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655811738; x=1687347738;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2g1CBLPR8NwFvZp4HlsXO+3OaWnqrAxa2IDW/eAMcrk=;
  b=imySmsZ5ev1/Gl1INloYrugjA1xMegMsbMAx2gFxlzoExdol69vQX3kt
   n5HdTZlna9wcigpKgOXdWzANfp/JEKYa6mN8H6J4qOD+wPsT4Cp7pah53
   qqvCSnSsYJUBsilbvEbmXodgyYqxMdImea462uiVC41WnMXpiYUVgkRBY
   a7/nqC0fq4HwPzMw7NtTbAD32ETrWfMkxYGPAptatZpvNKlsjFuHAxvcz
   NfAlvdsDBSuf4m6m+ZZtEPBdeYFt14JTfoPGPmgp5EkD4EBcvEUoASp/r
   tkX5INbV0i66JaI9nMujWVK01a1zYy+gkxZlW3aF6kaUxDqwoxYQeqwSO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="259918598"
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="259918598"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 04:42:18 -0700
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="655106067"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 04:42:13 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3cGo-000qz6-70;
        Tue, 21 Jun 2022 14:42:10 +0300
Date:   Tue, 21 Jun 2022 14:42:09 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
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
Message-ID: <YrGukfw4uiQz0NpW@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
 <YrDO05TMK8SVgnBP@lunn.ch>
 <YrGm2jmR7ijHyQjJ@smile.fi.intel.com>
 <YrGpDgtm4rPkMwnl@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrGpDgtm4rPkMwnl@lunn.ch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 01:18:38PM +0200, Andrew Lunn wrote:
> On Tue, Jun 21, 2022 at 02:09:14PM +0300, Andy Shevchenko wrote:
> > On Mon, Jun 20, 2022 at 09:47:31PM +0200, Andrew Lunn wrote:

...

> > > > +        Name (_CRS, ResourceTemplate ()
> > > > +        {
> > > > +            Memory32Fixed (ReadWrite,
> > > > +                0xf212a200,
> > > > +                0x00000010,
> > > 
> > > What do these magic numbers mean?
> > 
> > Address + Length, it's all described in the ACPI specification.
> 
> The address+plus length of what? This device is on an MDIO bus. As
> such, there is no memory! It probably makes sense to somebody who
> knows ACPI, but to me i have no idea what it means.

I see what you mean. Honestly I dunno what the device this description is for.
For the DSA that's behind MDIO bus? Then it's definitely makes no sense and
MDIOSerialBus() resources type is what would be good to have in ACPI
specification.

> > Or if you asked
> > why the values there are the particular numbers? I guess it's fined to have
> > anything sane in the example. OTOH a comment may be added.
> > 
> > > > +                )
> > > > +        })

...

> > > > +        Device (SWI0)
> > > > +        {
> > > > +            Name (_HID, "MRVL0120")
> > > > +            Name (_UID, 0x00)
> > > > +            Name (_ADR, 0x4)
> > > > +            <...>
> > > > +        }
> > > 
> > > I guess it is not normal for ACPI, but could you add some comments
> > > which explain this. In DT we have
> > > 
> > >     properties:
> > >       reg:
> > >         minimum: 0
> > >         maximum: 31
> > >         description:
> > >           The ID number for the device.
> > > 
> > > which i guess what this _ADR property is, but it would be nice if it
> > > actually described what it is supposed to mean. You have a lot of
> > > undocumented properties here.
> > 
> > Btw, you are right, _ADR mustn't go together with _HID/_CID.
> 
> Does ACPI have anything like .yaml to describe the binding and tools
> to validate it?

ACPI is a language, the "bindings" (in a way how you probably use this term)
are a small subset and usually refers to the format whoever provides them. I.e.
_DSD with a certain UUID is a part of the DT bindings, so DT validation is what
is expected to be performed. Otherwise for other UUIDs it may or may be no such
validators exist, I don't know.

-- 
With Best Regards,
Andy Shevchenko


