Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB79063CFCB
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 08:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbiK3Hnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 02:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiK3Hni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 02:43:38 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AD13FB90;
        Tue, 29 Nov 2022 23:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669794217; x=1701330217;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CqntLupJyqVrXhc+FeWD3IIBjSAAy4erEqvvAk+xl78=;
  b=imz+2SO03IQ8YBHoSXaKJcdnjUiSZeSwRsetbR+/YpDduZWD9ra4w+Yx
   NaLDRez1KXSbW3/17T1Y79kYX99yHJmBIKYfUVhStYEPZAq/Nar8corWO
   kWkHqFF32tbN1VIZiS2kssd0Mj67b+INuD7BCWj47gKh5FLIhD8EEexEa
   K+4gWUwKE+aN9cNHsWzj+lRirLVgUeDFqPCpXq3nKDeaBj1ZRaDuzZ/74
   QdBj3gY0ri1LLCRZbzWy4o4CmlYGG465OGsRfFqy6UjX6PbMn74lVHyVc
   B1M2PCJnGA5upeBJAnhr6VuQOb0e2y41Q8h2V0691xseL0wZjFuIT6agQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="401610157"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="401610157"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 23:43:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="676730844"
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="676730844"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 29 Nov 2022 23:43:33 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 1A6B710E; Wed, 30 Nov 2022 09:43:59 +0200 (EET)
Date:   Wed, 30 Nov 2022 09:43:59 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [resend, PATCH net-next v1 1/2] net: thunderbolt: Switch from
 __maybe_unused to pm_sleep_ptr() etc
Message-ID: <Y4cJv4WgFijxZFSZ@black.fi.intel.com>
References: <20221129161359.75792-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221129161359.75792-1-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 06:13:58PM +0200, Andy Shevchenko wrote:
> Letting the compiler remove these functions when the kernel is built
> without CONFIG_PM_SLEEP support is simpler and less heavier for builds
> than the use of __maybe_unused attributes.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
