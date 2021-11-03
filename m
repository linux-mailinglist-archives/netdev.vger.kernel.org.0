Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F6D444343
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhKCOUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:20:30 -0400
Received: from mga07.intel.com ([134.134.136.100]:3548 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230472AbhKCOU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 10:20:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10156"; a="294951923"
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="294951923"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 07:17:52 -0700
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="667537530"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 07:17:49 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1miH53-003HSL-N2;
        Wed, 03 Nov 2021 16:17:33 +0200
Date:   Wed, 3 Nov 2021 16:17:33 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH v2 1/2] mwifiex: Use a define for firmware version string
 length
Message-ID: <YYKZ/a11TEs48+Xb@smile.fi.intel.com>
References: <20211103135529.8537-1-verdre@v0yd.nl>
 <20211103135529.8537-2-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211103135529.8537-2-verdre@v0yd.nl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 02:55:28PM +0100, Jonas Dreßler wrote:
> Since the version string we get from the firmware is always 128
> characters long, use a define for this size instead of having the number
> 128 copied all over the place.

Just answered to the previous one :-) Okay, you may ignore that thread
since you did what you and I were talking about.

...

> +		       sizeof(char) * MWIFIEX_VERSION_STR_LENGTH);

While at it, drop the redundant sizeof().

-- 
With Best Regards,
Andy Shevchenko


