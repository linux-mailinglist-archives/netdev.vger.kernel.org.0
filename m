Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100E06D773F
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237162AbjDEIrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237188AbjDEIrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:47:31 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A987155AF
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 01:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680684429; x=1712220429;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=63OqokPcS5gPx+1ANbnLrRdtY0J4gdWnlr7hhAGh80M=;
  b=MhgfGVgW+EEiAAK0YH2X//6Q6Y5VyGXKlabOdc9WqWnxE/K6w4x2O14R
   ymKXyh0kDrqP61drU1067RIfmFwzQm5MWS78g8nHjwUvqQyOJP0HG6BAL
   r4oM96h9Mp5hKFan/25FLGKvI93LX3aGmIkvL/Jmd8+Tc++nIr7JlO3e6
   Aft394i86/FbEHyuCd1Cs4kNVza0IMYepe+RczoRJgebPzVOJ+QeNM/Jj
   kH5Gt5xTnQQJcnbczAJPvWQWijRPRybEZNSAhGsx31nRhRQrpatAKAMir
   FENSbBBpx0aMHW5HSgAA1g5ANGvNV1Y2HJwFrxw1/CQwAqzlnWfxy9oFj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="344115822"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="344115822"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 01:47:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="689188505"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="689188505"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga007.fm.intel.com with ESMTP; 05 Apr 2023 01:47:01 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pjynE-00Ckus-0E;
        Wed, 05 Apr 2023 11:47:00 +0300
Date:   Wed, 5 Apr 2023 11:46:59 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] net: thunderbolt: Fix for sparse warnings and typo
Message-ID: <ZC01g9zqSLw9fo8R@smile.fi.intel.com>
References: <20230404053636.51597-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404053636.51597-1-mika.westerberg@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 08:36:34AM +0300, Mika Westerberg wrote:
> Hi,
> 
> The first patch should get rid of the sparse reported warnings that
> still exist in the driver. The second one is trivial fix for typo.

Thank you, I believe v2 is needed which will look good with addressed
Simon's and my comments. Taking this into account,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>


> Mika Westerberg (2):
>   net: thunderbolt: Fix sparse warnings
>   net: thunderbolt: Fix typo in comment

-- 
With Best Regards,
Andy Shevchenko


