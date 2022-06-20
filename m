Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D9F55238D
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244997AbiFTSHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbiFTSHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:07:41 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DF71AF12;
        Mon, 20 Jun 2022 11:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655748460; x=1687284460;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=V2Y1OsymaqXh6H8ZokKMogdPMxoHJLdSFNWGHhHBF84=;
  b=mMGwrsA2WtqByT5k/6uvvOAjoBXSO/ALj5256zUheEfnjGgIX1dMjvf3
   6rW7GeulCkOnnzHjW13GThwAGHlCp24JzZXysJc+mifcQzNlJ5YveJbPU
   CJzjYICrFc0HkfO/pualVDZ15fP6SMwTHZCwEj/3Yg4KV/viX0oFjZ/JL
   ZmsPVxAescwU1mdFs0sPtLg/h6sIHYr/Dd6UHgBV4InXGTsqHoN/8yBX0
   2W29D+iHlCdWfjx9U8jRkobm5pUQEUwKsdjZATXnMzCbmX9181g0Fxsqc
   sGLMmcFRDoEUm4/7YuIqv8LuFobNg4qZCMVlEj3qE+d+xEGI75UH9nrdn
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="280000453"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="280000453"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 11:07:40 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="654784928"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 11:07:36 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3LoC-000kbK-Uk;
        Mon, 20 Jun 2022 21:07:32 +0300
Date:   Mon, 20 Jun 2022 21:07:32 +0300
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
Subject: Re: [net-next: PATCH 00/12] ACPI support for DSA
Message-ID: <YrC3ZKsMQK3PYKkR@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <YrC0oKdDSjQTgUtM@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrC0oKdDSjQTgUtM@lunn.ch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 07:55:44PM +0200, Andrew Lunn wrote:
> On Mon, Jun 20, 2022 at 05:02:13PM +0200, Marcin Wojtas wrote:

...

> > It turned out that without much hassle it is possible to describe
> > DSA-compliant switches as child devices of the MDIO busses, which are
> > responsible for their enumeration based on the standard _ADR fields and
> > description in _DSD objects under 'device properties' UUID [1].
> 
> No surprises there. That is how the DT binding works. And the current
> ACPI concept is basically DT in different words. Maybe the more
> important question is, is rewording DT in ACPI the correct approach,
> or should you bo doing a more native ACPI implementation? I cannot
> answer that, you need to ask the ACPI maintainers.

You beat me up to this. I also was about to mention that the problem with such
conversions (like this series does) is not in the code. It's simplest part. The
problem is bindings and how you get them to be a standard (at least de facto).

> > Note that for now cascade topology remains unsupported in ACPI world
> > (based on "dsa" label and "link" property values). It seems to be feasible,
> > but would extend this patchset due to necessity of of_phandle_iterator
> > migration to fwnode_. Leave it as a possible future step.
> 
> We really do need to ensure this is possible. You are setting an ABI
> here, which everybody else in the ACPI world needs to follow. Cascaded
> switches is fundamental to DSA, it is the D in DSA. So i would prefer
> that you at least define and document the binding for D in DSA and get
> it sanity checked by the ACPI people.

-- 
With Best Regards,
Andy Shevchenko


