Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3473E92D5
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhHKNkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:40:45 -0400
Received: from mga07.intel.com ([134.134.136.100]:55278 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhHKNkp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 09:40:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="278870031"
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="278870031"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 06:40:20 -0700
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="672876930"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 06:40:17 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mDoSp-007uwO-Ed; Wed, 11 Aug 2021 16:40:11 +0300
Date:   Wed, 11 Aug 2021 16:40:11 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v3 net-next 1/1] wwan: core: Unshadow error code returned
 by ida_alloc_range))
Message-ID: <YRPTO4OdT8dVq2ei@smile.fi.intel.com>
References: <20210811125010.11167-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811125010.11167-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 03:50:10PM +0300, Andy Shevchenko wrote:
> ida_alloc_range() may return other than -ENOMEM error code.
> Unshadow it in the wwan_create_port().

> v3: split from original series with fixed subject and typo in body (Sergey)

Oh, another typo in the subject (I'll fix it in v4)

-- 
With Best Regards,
Andy Shevchenko


