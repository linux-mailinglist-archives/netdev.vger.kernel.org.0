Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC51F553088
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348360AbiFULPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiFULPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:15:52 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016B329C9E;
        Tue, 21 Jun 2022 04:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655810152; x=1687346152;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T9u4NQStwqgT/FP8Ox1SftRm7jpPdpysrGAUgD9ZRjc=;
  b=jI6VRD9GRDbsv3Akw1drAKKPQ21dMtKU9nfmw53ZDJFHzB8cQXiO5yZX
   H4An/jembi6KUNHb26jF1Khrg1lcfJ1HCLH/6IjJcji30MTx/NtWhPqNl
   v3vzQ8v+edg1KwP1eIfFOXIeq5XDu5R0f5OVup6xm4LEwP9Nd7yAprR47
   HOfc4bWPwoIE3NT5aWne1eVuFD6eGJWTIf00JC3P+b1B/LgxG0lLcDzrX
   4S5Jz49VaIQ2xgoyjmuovetKYgbP6nl4Uwgfy9B600ddyGd6BJYaHLqkh
   LnuIvAqeSTYftGQOB52sZUUEICOX3gt/XdrJ1x8aAiS/gAJ6LgXoXXazd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="259914733"
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="259914733"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 04:15:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="614710772"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 04:15:45 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3brC-000qy0-7b;
        Tue, 21 Jun 2022 14:15:42 +0300
Date:   Tue, 21 Jun 2022 14:15:41 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Sudeep Holla <sudeep.holla@arm.com>
Cc:     Marcin Wojtas <mw@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, lenb@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        gjb@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA
 description
Message-ID: <YrGoXXBgHvyifny3@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
 <20220621094556.5ev3nencnw7a5xwv@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621094556.5ev3nencnw7a5xwv@bogus>
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

On Tue, Jun 21, 2022 at 10:45:56AM +0100, Sudeep Holla wrote:
> On Mon, Jun 20, 2022 at 05:02:22PM +0200, Marcin Wojtas wrote:
> > Describe the Distributed Switch Architecture (DSA) - compliant
> > MDIO devices. In ACPI world they are represented as children
> > of the MDIO busses, which are responsible for their enumeration
> > based on the standard _ADR fields and description in _DSD objects
> > under device properties UUID [1].
> > 
> > [1] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf

> Why is this document part of Linux code base ?

It's fine, but your are right with your latter questions.

> How will the other OSes be aware of this ?

Should be a standard somewhere.

> I assume there was some repository to maintain such DSDs so that it
> is accessible for other OSes. I am not agreeing or disagreeing on the
> change itself, but I am concerned about this present in the kernel
> code.

I dunno we have a such, but the closest I may imagine is MIPI standardization,
that we have at least for cameras and sound.

I would suggest to go and work with MIPI for network / DSA / etc area, so
everybody else will be aware of the standard.

-- 
With Best Regards,
Andy Shevchenko


