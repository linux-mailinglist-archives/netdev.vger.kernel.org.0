Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EFA46E7EC
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 12:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbhLIMDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:03:16 -0500
Received: from mga14.intel.com ([192.55.52.115]:49365 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233270AbhLIMDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 07:03:15 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="238308050"
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="238308050"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 03:59:41 -0800
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="503464127"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 03:59:39 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mvI4O-0044ax-JK;
        Thu, 09 Dec 2021 13:58:40 +0200
Date:   Thu, 9 Dec 2021 13:58:40 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/1] can: mcp251x: Get rid of duplicate of_node
 assignment
Message-ID: <YbHvcDhtZFTyfThT@smile.fi.intel.com>
References: <20211202205855.76946-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202205855.76946-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 10:58:55PM +0200, Andy Shevchenko wrote:
> GPIO library does copy the of_node from the parent device of
> the GPIO chip, there is no need to repeat this in the individual
> drivers. Remove assignment here.
> 
> For the details one may look into the of_gpio_dev_init() implementation.

Marc, what do you think about this change?

-- 
With Best Regards,
Andy Shevchenko


