Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B801235F746
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347168AbhDNPKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:10:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:34043 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347174AbhDNPKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 11:10:50 -0400
IronPort-SDR: NkDhiYHKCsFU6mMTtgc+ob3kbqTChbOI5OILWBpnTrHT9QmHqDCCq+g28k13zjkroyNbOi4xC/
 5+hrXqpWEWFQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="194768016"
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="194768016"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 08:10:15 -0700
IronPort-SDR: aZgfj1IxVxNFY4kP4MSWfZpcXsUtzUBNLWl3hJsxLJLj+ikwlVn8HR4DMtE2tvqdF3Qwf5aEub
 KrF5E0pVhirg==
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="399211281"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 08:10:13 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lWh9e-0041hY-Mt; Wed, 14 Apr 2021 18:10:10 +0300
Date:   Wed, 14 Apr 2021 18:10:10 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Flavio Suligoi <f.suligoi@asem.it>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 0/5] net: pch: fix and a few cleanups
Message-ID: <YHcF0kqenD5Si66Z@smile.fi.intel.com>
References: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 07:34:07PM +0200, Andy Shevchenko wrote:
> The series provides one fix (patch 1) for GPIO to be able to wait for
> the GPIO driver to appear. This is separated from the conversion to
> the GPIO descriptors (patch 2) in order to have a possibility for
> backporting. Patches 3 and 4 fix a minor warnings from Sparse while
> moving to a new APIs. Patch 5 is MODULE_VERSION() clean up.
> 
> Tested on Intel Minnowboard (v1).

Guys, it has been already the report from kbuild bot (sparse warnings), which
should be fixed by this series (at least partially if not completely).

Please, apply this as soon as it's possible.
Or tell me what's wrong with the series.

Thanks!

> Since v2:
> - added a few cleanups on top of the fix
> 
> Andy Shevchenko (5):
>   net: pch_gbe: Propagate error from devm_gpio_request_one()
>   net: pch_gbe: Convert to use GPIO descriptors
>   net: pch_gbe: use readx_poll_timeout_atomic() variant
>   net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()
>   net: pch_gbe: remove unneeded MODULE_VERSION() call
> 
>  .../net/ethernet/oki-semi/pch_gbe/pch_gbe.h   |   2 -
>  .../oki-semi/pch_gbe/pch_gbe_ethtool.c        |   2 +
>  .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  | 103 +++++++++---------
>  3 files changed, 54 insertions(+), 53 deletions(-)
> 
> -- 
> 2.30.2
> 

-- 
With Best Regards,
Andy Shevchenko


