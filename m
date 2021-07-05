Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BF43BBA98
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 11:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhGEJ7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 05:59:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:41273 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGEJ7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 05:59:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10035"; a="207127596"
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="207127596"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 02:56:38 -0700
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="644154191"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 02:56:34 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1m0LL2-008XrQ-Oh; Mon, 05 Jul 2021 12:56:28 +0300
Date:   Mon, 5 Jul 2021 12:56:28 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, nickhu@andestech.com, green.hu@gmail.com,
        deanbo422@gmail.com, akpm@linux-foundation.org,
        yury.norov@gmail.com, ojeda@kernel.org, ndesaulniers@gooogle.com,
        joe@perches.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] refactor the ringtest testing for ptr_ring
Message-ID: <YOLXTB6VxtLBmsuC@smile.fi.intel.com>
References: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 05, 2021 at 11:57:33AM +0800, Yunsheng Lin wrote:
> tools/include/* have a lot of abstract layer for building
> kernel code from userspace, so reuse or add the abstract
> layer in tools/include/ to build the ptr_ring for ringtest
> testing.

...

>  create mode 100644 tools/include/asm/cache.h
>  create mode 100644 tools/include/asm/processor.h
>  create mode 100644 tools/include/generated/autoconf.h
>  create mode 100644 tools/include/linux/align.h
>  create mode 100644 tools/include/linux/cache.h
>  create mode 100644 tools/include/linux/slab.h

Maybe somebody can change this to be able to include in-tree headers directly?

Besides above, had you tested this with `make O=...`?

-- 
With Best Regards,
Andy Shevchenko


