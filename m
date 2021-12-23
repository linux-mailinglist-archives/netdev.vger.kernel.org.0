Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E2B47E137
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 11:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243097AbhLWKSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 05:18:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:29551 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhLWKSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 05:18:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640254701; x=1671790701;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GzB/NR4iClizQsqPjrZZWaIkksTdxNwLazxBvftmulA=;
  b=NCYn018HvVrfCG9T2kCDQEIZZnr5j7j9c4Xr2n66JMH7iOc1JJ85xFSH
   CmGXspJZ3S/KjsdtqJdDte9y18wx6YeCjR0a5YPIWRqMz//IE0l3u/hNp
   LET6VVfXDUGQiMQtJzNYzAZf0qHK+7F+yXXHfcnoHgyvstl/20dPtqvLM
   0O06Gnt7ljututbGRdZyugTAhCgpTAPmpGcQNOkO4n0bozpg3wWQmJx8C
   W00ZswI8FnbNG+YR0iKwY8x29b3NYsGIB7AkXLkt6tz1UkxGYFcjQTLpb
   qJotTUSapxgTvNVt6myCFxEY42nZvy14hOByJ0YP0eH6sr+FLB9O5EA2G
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="265009965"
X-IronPort-AV: E=Sophos;i="5.88,229,1635231600"; 
   d="scan'208";a="265009965"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2021 02:18:21 -0800
X-IronPort-AV: E=Sophos;i="5.88,229,1635231600"; 
   d="scan'208";a="685334990"
Received: from smile.fi.intel.com ([10.237.72.61])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2021 02:18:19 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1n0L9a-001BAi-Te;
        Thu, 23 Dec 2021 12:16:54 +0200
Date:   Thu, 23 Dec 2021 12:16:54 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v1 1/1] wwan: Replace kernel.h with the necessary
 inclusions
Message-ID: <YcRMlp6ux+R0op3Q@smile.fi.intel.com>
References: <20211222163256.66270-1-andriy.shevchenko@linux.intel.com>
 <CAHNKnsS_1fQh1UL-VX0kXfDp_umMtfSnDwJXWxiBXFdyrK1pYA@mail.gmail.com>
 <YcRL8Ttxm8yMj77U@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcRL8Ttxm8yMj77U@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 12:14:09PM +0200, Andy Shevchenko wrote:
> On Wed, Dec 22, 2021 at 11:38:44PM +0300, Sergey Ryazanov wrote:
> > On Wed, Dec 22, 2021 at 7:32 PM Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:

...

> Not sure what it's supposed from me to do. The forward declarations are
> the tighten part of the cleanup (*) and it's exactly what is happening here,
> i.e.  replacing kernel.h "with the list of what is really being used".
> 
> *) Either you need a header, or you need a forward declaration, or rely on
>    the compiler not to be so strict. I prefer the second option out of three.

Ah, seems indeed the skbuf and netdevice ones can be split. Do you want me to
resend as series of two?

(Sorry I have sent many similar changes and haven't remembered by heart where
 I did what exactly, but here it looks natural to cleanup that stuff at the
 same time, so the question is if it should be a separate change or not)

-- 
With Best Regards,
Andy Shevchenko


