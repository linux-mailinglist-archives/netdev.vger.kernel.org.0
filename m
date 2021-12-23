Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1880247E12D
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 11:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239320AbhLWKPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 05:15:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:41706 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhLWKPg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 05:15:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640254536; x=1671790536;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DrtzkCd23HCzpmsaaEVPxgi6r+48nDgYVWL6Zmx/8lE=;
  b=c9PKXHAJgQYLFXyrTWd0F5+OqpbHLOjokKTYUbgegmnhWiDB1ojEsWcg
   YJw8C9ZW9uLPwFQdgsyekq7S4rI9aEHZuekxZKdiDYcEFNJkkcI3xRAbO
   I7WouT+zfNAi/cCNsGwDeVFjEyXbla8vSwlLTPjwP8iRPHdIKv7r5kMb1
   kJn5UQwFalgx6v0+cHz8YxHlBbjpHJhrhzeVRQqUYii3LyuOS1sMgnVge
   jP78hYGd2WUS7tAgElKWoTN2fqg+yTslTbaVkePJLQuVkxnuO/hilaeH7
   5ZCCpp9+Ez/s1MEOdGbM8spLV9HvNf5HsU+k7q1KSDHG+AXEvu+NuKDGr
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="238335579"
X-IronPort-AV: E=Sophos;i="5.88,229,1635231600"; 
   d="scan'208";a="238335579"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2021 02:15:35 -0800
X-IronPort-AV: E=Sophos;i="5.88,229,1635231600"; 
   d="scan'208";a="685334316"
Received: from smile.fi.intel.com ([10.237.72.61])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2021 02:15:33 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1n0L6v-001B8F-Ax;
        Thu, 23 Dec 2021 12:14:09 +0200
Date:   Thu, 23 Dec 2021 12:14:09 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v1 1/1] wwan: Replace kernel.h with the necessary
 inclusions
Message-ID: <YcRL8Ttxm8yMj77U@smile.fi.intel.com>
References: <20211222163256.66270-1-andriy.shevchenko@linux.intel.com>
 <CAHNKnsS_1fQh1UL-VX0kXfDp_umMtfSnDwJXWxiBXFdyrK1pYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHNKnsS_1fQh1UL-VX0kXfDp_umMtfSnDwJXWxiBXFdyrK1pYA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 11:38:44PM +0300, Sergey Ryazanov wrote:
> On Wed, Dec 22, 2021 at 7:32 PM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > When kernel.h is used in the headers it adds a lot into dependency hell,
> > especially when there are circular dependencies are involved.
> >
> > Replace kernel.h inclusion with the list of what is really being used.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Subject and description do not cover cleanup of includes besides the
> kernel.h. But that does not seem like a big issue, so:

Not sure what it's supposed from me to do. The forward declarations are
the tighten part of the cleanup (*) and it's exactly what is happening here,
i.e.  replacing kernel.h "with the list of what is really being used".

*) Either you need a header, or you need a forward declaration, or rely on
   the compiler not to be so strict. I prefer the second option out of three.

> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Thanks!

-- 
With Best Regards,
Andy Shevchenko


