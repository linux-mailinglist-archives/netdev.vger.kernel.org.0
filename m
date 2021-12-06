Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EA246A1CB
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239770AbhLFQws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:52:48 -0500
Received: from mga18.intel.com ([134.134.136.126]:15444 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239044AbhLFQwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 11:52:46 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="224222787"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="224222787"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 08:49:17 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="461905691"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 08:49:15 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1muH9y-002qzn-H6;
        Mon, 06 Dec 2021 18:48:14 +0200
Date:   Mon, 6 Dec 2021 18:48:14 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 2/4] can: hi311x: try to get crystal clock rate from
 property
Message-ID: <Ya4+zveKTTtfHNw+@smile.fi.intel.com>
References: <20211206162323.29281-1-andriy.shevchenko@linux.intel.com>
 <20211206162323.29281-2-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206162323.29281-2-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 06:23:21PM +0200, Andy Shevchenko wrote:
> In some configurations, mainly ACPI-based, the clock frequency of the
> device is supplied by very well established 'clock-frequency'
> property. Hence, try to get it from the property at last if no other
> providers are available.

Sorry, this shouldn't be like this.
Wrongly rebased version. I will redo v2.

-- 
With Best Regards,
Andy Shevchenko


