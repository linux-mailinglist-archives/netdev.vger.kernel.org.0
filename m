Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04CF23407B
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731808AbgGaHtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:49:14 -0400
Received: from mga05.intel.com ([192.55.52.43]:38361 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731684AbgGaHtN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:49:13 -0400
IronPort-SDR: +rBaEvswEfdptFgd0Xk05kDqDLtxcy7nzJpgGf8vApDnauYK0cQvw+hTa4o/ykRtlESVbI4foT
 4FcVCZgokx3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="236608240"
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="236608240"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 00:49:13 -0700
IronPort-SDR: 9z+o4333UTXOSFImoXh3bcELfU8ctNA9YDwO/2FP+1o4P9mcNTV2pVw2F2SKWy6B6oUTZBzcCU
 qIZIpZT2c1iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="465544437"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga005.jf.intel.com with ESMTP; 31 Jul 2020 00:49:09 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1k1Pmu-005GWu-OG; Fri, 31 Jul 2020 10:49:08 +0300
Date:   Fri, 31 Jul 2020 10:49:08 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1] ice: devlink: use %*phD to print small buffer
Message-ID: <20200731074908.GE3703480@smile.fi.intel.com>
References: <20200730160451.40810-1-andriy.shevchenko@linux.intel.com>
 <77247fbc-152a-517f-2500-ce761b7afa6a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77247fbc-152a-517f-2500-ce761b7afa6a@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 02:20:46PM -0700, Jacob Keller wrote:
> On 7/30/2020 9:04 AM, Andy Shevchenko wrote:
> > Use %*phD format to print small buffer as hex string.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Ah nice. I swear I looked for a printk format to do this and didn't find
> one. But it's been there since 2012.. so I guess I just missed it.

commit 31550a16a5d2af859e8a11839e8c6c6c9c92dfa7
Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date:   Mon Jul 30 14:40:27 2012 -0700

    vsprintf: add support of '%*ph[CDN]'

Maybe it was just a coincidence :-)

> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> I also tested this on my system to make sure it gives the same output
> for the serial value, so I guess also:
> 
> Tested-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks!

-- 
With Best Regards,
Andy Shevchenko


