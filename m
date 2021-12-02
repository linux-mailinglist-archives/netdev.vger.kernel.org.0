Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DAF466BB0
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377106AbhLBVdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:33:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:41941 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354021AbhLBVdr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 16:33:47 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="236656281"
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="236656281"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 13:30:24 -0800
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="513037641"
Received: from smile.fi.intel.com ([10.237.72.184])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 13:30:21 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mstdm-001XeF-Dp;
        Thu, 02 Dec 2021 23:29:18 +0200
Date:   Thu, 2 Dec 2021 23:29:18 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/1] net: dsa: vsc73xxx: Get rid of duplicate of_node
 assignment
Message-ID: <Yak6rnx9IOy6jLEm@smile.fi.intel.com>
References: <20211202210029.77466-1-andriy.shevchenko@linux.intel.com>
 <20211202211259.qzdg3zs7lkjbykhn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202211259.qzdg3zs7lkjbykhn@skbuf>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 11:12:59PM +0200, Vladimir Oltean wrote:
> On Thu, Dec 02, 2021 at 11:00:29PM +0200, Andy Shevchenko wrote:

...

> I'm in To: and everyone else is in Cc? I don't even have the hardware.

get_maintainer + Git heuristics. I see that you have 2 changes out of 9,
maybe this what makes it triggered.

> Adding Linus just in case, although the change seems correct.
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Thanks!

-- 
With Best Regards,
Andy Shevchenko


