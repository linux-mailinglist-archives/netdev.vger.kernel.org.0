Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007F3553075
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348285AbiFULJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiFULJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:09:24 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A071C29C80;
        Tue, 21 Jun 2022 04:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655809763; x=1687345763;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LZ7wcisG5occ9JV5pidM/OQD/o/yWikJJHJfKMo/ZqM=;
  b=bBWxl1tzaO20Aw1wY+ixQz+H0Lh+I1nyqO+uyi/uqd0jzC08Fv/esSTg
   9yTF/OYymrvfnlA4IE9J8jTeKtA7crcjjNMyIMWDIoupB5efCDm0A+V4I
   6oOQ70x/MLdP0rDm8K+NCr4s18yKJQtw3ot6g/mJ/VCqDm+nIzzXdLvrc
   bgNR5LQJGNpfGUUnuucZast6Umitbiz268rPCYcrp/H15WCx8ifPtYxg7
   er32TQeRYXsEcL8LM9Rg+BOQlXXnFyO+FBnUhXu8Pu7cJgUFiXFb+a4Fg
   BCIyQsHspvL24b98taJOVv+pJMRltK9hjJYantZypep5UI0PlL8qDmI/p
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="263125602"
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="263125602"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 04:09:23 -0700
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="676951239"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 04:09:18 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3bkw-000qxT-Px;
        Tue, 21 Jun 2022 14:09:14 +0300
Date:   Tue, 21 Jun 2022 14:09:14 +0300
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
Message-ID: <YrGm2jmR7ijHyQjJ@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
 <YrDO05TMK8SVgnBP@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrDO05TMK8SVgnBP@lunn.ch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 09:47:31PM +0200, Andrew Lunn wrote:

...

> > +        Name (_CRS, ResourceTemplate ()
> > +        {
> > +            Memory32Fixed (ReadWrite,
> > +                0xf212a200,
> > +                0x00000010,
> 
> What do these magic numbers mean?

Address + Length, it's all described in the ACPI specification. Or if you asked
why the values there are the particular numbers? I guess it's fined to have
anything sane in the example. OTOH a comment may be added.

> > +                )
> > +        })

...

> > +        Device (SWI0)
> > +        {
> > +            Name (_HID, "MRVL0120")
> > +            Name (_UID, 0x00)
> > +            Name (_ADR, 0x4)
> > +            <...>
> > +        }
> 
> I guess it is not normal for ACPI, but could you add some comments
> which explain this. In DT we have
> 
>     properties:
>       reg:
>         minimum: 0
>         maximum: 31
>         description:
>           The ID number for the device.
> 
> which i guess what this _ADR property is, but it would be nice if it
> actually described what it is supposed to mean. You have a lot of
> undocumented properties here.

Btw, you are right, _ADR mustn't go together with _HID/_CID.

-- 
With Best Regards,
Andy Shevchenko


