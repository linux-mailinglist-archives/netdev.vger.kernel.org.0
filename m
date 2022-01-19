Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463C5494260
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 22:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245736AbiASVJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 16:09:07 -0500
Received: from mga06.intel.com ([134.134.136.31]:48567 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbiASVJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 16:09:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642626543; x=1674162543;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZzYmMjvc+5ZxKARHkTHppxBXOgslf91RNegeCdTQKbM=;
  b=e8WFxZ2qNFoncplhhiFPXtf/96EijZn1k7z6GQ3xEGVTX50MQ354iUvC
   1yUfs9eiLRUAoJxqX3Zz4BXxQfl40p88Y7PJXZfRQLsktd8JShQspjBNS
   L/D1dHOHk9AgnXycusyHpVMVDQwJe419KTLebVVPZXypzfJUe0+2rwts1
   alzI2tKLaGKtO59UWpPpkuqYm4I99bLRfG3FkMEUFTiW0zF5BxPBvPCuJ
   YOlNPAlLrn9JnStPFnfB72O6Igsj3FeaNIPsLPVnPvzyRzZuBIFAd7GbF
   oOuGIIER/+Uc5pQ5SVjCLatxC80qrlB9+9KCDdWjAw4KDkbrQF0b7kZCZ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="305924264"
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="305924264"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 13:09:02 -0800
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="578966588"
Received: from smile.fi.intel.com ([10.237.72.61])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 13:08:54 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nAIBD-00CHBb-6W;
        Wed, 19 Jan 2022 23:07:43 +0200
Date:   Wed, 19 Jan 2022 23:07:42 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>, Eryk Brol <eryk.brol@amd.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [Intel-gfx] [PATCH 0/3] lib/string_helpers: Add a few string
 helpers
Message-ID: <Yeh9noiOmJd0DkRO@smile.fi.intel.com>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <YegPiR7LU8aVisMf@alley>
 <87tudzbykz.fsf@intel.com>
 <Yeg5BpV8tknSPdSQ@phenom.ffwll.local>
 <20220119205343.kd5cwfzpg4mlsekk@ldmartin-desk2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119205343.kd5cwfzpg4mlsekk@ldmartin-desk2>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 12:53:43PM -0800, Lucas De Marchi wrote:
> On Wed, Jan 19, 2022 at 05:15:02PM +0100, Daniel Vetter wrote:
> > On Wed, Jan 19, 2022 at 04:16:12PM +0200, Jani Nikula wrote:

...

> > Yeah we can sed this anytime later we want to, but we need to get the foot
> > in the door. There's also a pile more of these all over.
> > 
> > Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > 
> > on the series, maybe it helps? And yes let's merge this through drm-misc.
> 
> Ok, it seems we are reaching some agreement here then:

> - Change it to use str_ prefix

Not sure about this (*), but have no strong argument against. Up to you.
Ah, yes, Jani said about additional churn this change will make if goes
together with this series. Perhaps it can be done separately?

> - Wait -rc1 to avoid conflict
> - Merge through drm-misc

*) E.g. yesno() to me doesn't sound too bad to misunderstand its meaning,
   esp.when it's used as an argument to the printf() functions.

-- 
With Best Regards,
Andy Shevchenko


