Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3BD6213F1
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbiKHNzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbiKHNzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:55:36 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC4CEA1;
        Tue,  8 Nov 2022 05:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667915736; x=1699451736;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hSs/9wNT0EGOI37Oz+MQ6xPOM6Ayl887RbLjJ+yFmkQ=;
  b=J7ycUe4d3M0SwNviI1TAyjDHa06HYFCJL2YeRoCZfJfd0fVf/u73fi/+
   ZBziE0YzaN8qIlzNB8wSkO+fxuH8MtT/xfMgtzc6aSObW4CAOGI16fVVv
   9Jj6ocHnWty4lmyCX42XfLuOGQxMbAEsBp9u6KLmOGPabPEE0Ki1gDmzH
   aPzPltK/kW94MUnSO//53zLyopmtRMZQoX0GaboUiubGXONnG8kTNeWTB
   gQiDhFJA18t8+Xsh6JxP+XjRmkuTJ6A8YpxrKy8QtR5uvPiE2RsWLjfFV
   EhPW60SaQRgFVFV3R1nTvYrr/8kz1cEDl9UdxYI5hlND4Z0ZV6n0ezRAU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="372838955"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="372838955"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 05:55:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="636338939"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="636338939"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2022 05:55:33 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1osP4d-0099md-27;
        Tue, 08 Nov 2022 15:55:31 +0200
Date:   Tue, 8 Nov 2022 15:55:31 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v1 1/1] mac_pton: Don't access memory over expected length
Message-ID: <Y2pf06Oezvrb1yrv@smile.fi.intel.com>
References: <20221005164301.14381-1-andriy.shevchenko@linux.intel.com>
 <Y0R+ZU6kdbeUER1c@lunn.ch>
 <20221010173809.5f863ea6@kernel.org>
 <Y2pe5JqTbTykO5Qf@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2pe5JqTbTykO5Qf@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 03:51:33PM +0200, Andy Shevchenko wrote:
> On Mon, Oct 10, 2022 at 05:38:09PM -0700, Jakub Kicinski wrote:

...

> So, what is the decision with this patch? Should I resend that with net-next
> in the subject?

Found the answer in the other mail in this thread :-)

-- 
With Best Regards,
Andy Shevchenko


