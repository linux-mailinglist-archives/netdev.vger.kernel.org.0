Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A160788A6
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 11:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfG2Jkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 05:40:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:41341 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfG2Jkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 05:40:51 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 02:40:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="195303174"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.145])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2019 02:40:49 -0700
Received: from andy by smile with local (Exim 4.92)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1hs299-0005Bs-Bn; Mon, 29 Jul 2019 12:40:47 +0300
Date:   Mon, 29 Jul 2019 12:40:47 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     David Miller <davem@davemloft.net>
Cc:     clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        netdev@vger.kernel.org, sedat.dilek@credativ.de,
        sedat.dilek@gmail.com
Subject: Re: [PATCH v3 11/14] NFC: nxp-nci: Remove unused macro pr_fmt()
Message-ID: <20190729094047.GH9224@smile.fi.intel.com>
References: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
 <20190725193511.64274-11-andriy.shevchenko@linux.intel.com>
 <20190726.142346.407773857500139523.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726.142346.407773857500139523.davem@davemloft.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 02:23:46PM -0700, David Miller wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Date: Thu, 25 Jul 2019 22:35:08 +0300
> 
> > The macro had never been used.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
>  ...
> > @@ -12,8 +12,6 @@
> >   * Copyright (C) 2012  Intel Corporation. All rights reserved.
> >   */
> >  
> > -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> If there are any kernel log messages generated, which is the case in
> this file, this is used.

AFAICS no, it's not.
All nfc_*() macros are built on top of dev_*() ones for which pr_fmt() is no-op.
If we would like to have it in that way, we rather should use dev_fmt().


> Also, please resubmit this series with a proper header posting containing
> a high level description of what this patch series does, how it is doing it,
> and why it is doing it that way.  Also include a changelog.

Will do.

Thank you for review!

-- 
With Best Regards,
Andy Shevchenko


