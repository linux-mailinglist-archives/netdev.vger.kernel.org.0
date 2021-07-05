Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4164B3BBE8F
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 16:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhGEPAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 11:00:16 -0400
Received: from mga12.intel.com ([192.55.52.136]:65369 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231549AbhGEPAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 11:00:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="188671938"
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="188671938"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 07:57:39 -0700
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="644215013"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 07:57:35 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1m0Q2M-008hn9-8M; Mon, 05 Jul 2021 17:57:30 +0300
Date:   Mon, 5 Jul 2021 17:57:30 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, nickhu@andestech.com, green.hu@gmail.com,
        deanbo422@gmail.com, akpm@linux-foundation.org,
        yury.norov@gmail.com, ojeda@kernel.org, ndesaulniers@gooogle.com,
        joe@perches.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] refactor the ringtest testing for ptr_ring
Message-ID: <YOMd2q8Mf08+QVQ2@smile.fi.intel.com>
References: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
 <YOLXTB6VxtLBmsuC@smile.fi.intel.com>
 <c6844e2b-530f-14b2-0ec3-d47574135571@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6844e2b-530f-14b2-0ec3-d47574135571@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 05, 2021 at 08:06:50PM +0800, Yunsheng Lin wrote:
> On 2021/7/5 17:56, Andy Shevchenko wrote:
> > On Mon, Jul 05, 2021 at 11:57:33AM +0800, Yunsheng Lin wrote:
> >> tools/include/* have a lot of abstract layer for building
> >> kernel code from userspace, so reuse or add the abstract
> >> layer in tools/include/ to build the ptr_ring for ringtest
> >> testing.
> > 
> > ...
> > 
> >>  create mode 100644 tools/include/asm/cache.h
> >>  create mode 100644 tools/include/asm/processor.h
> >>  create mode 100644 tools/include/generated/autoconf.h
> >>  create mode 100644 tools/include/linux/align.h
> >>  create mode 100644 tools/include/linux/cache.h
> >>  create mode 100644 tools/include/linux/slab.h
> > 
> > Maybe somebody can change this to be able to include in-tree headers directly?
> 
> If the above works, maybe the files in tools/include/* is not
> necessary any more, just use the in-tree headers to compile
> the user space app?
> 
> Or I missed something here?

I don't know if it works or not or why that decision had been made to
copy'n'paste headers (Yes, I know they have some modifications).

Somebody needs to check that and see what can be done in order to avoid copying
entire include into tools/include.

> > Besides above, had you tested this with `make O=...`?
> 
> You are right, the generated/autoconf.h is in another directory
> with `make O=...`.
> 
> Any nice idea to fix the above problem?

No idea. But I consider breakage of O= is a show stopper.

-- 
With Best Regards,
Andy Shevchenko


