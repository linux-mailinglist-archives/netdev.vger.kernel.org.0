Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5283496C3
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhCYQ2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:28:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:30653 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhCYQ2Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 12:28:16 -0400
IronPort-SDR: c9dD1QQtzMPreCsqjQEh4epbjvCqdCgd0w7kPg3Klc57N9HU2irTi+i4NjNDPj2xbIzYsAlz+M
 1dqCsrTGHTWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="252324638"
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="252324638"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 09:28:01 -0700
IronPort-SDR: +TraIEIjthGJkacT1TlwM6KGFVSjCLsCOppWpu/mv8ITHkj6JBBpylE/jFi2bVoawLUtuuuMlO
 qZksULdTZGYA==
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="391804051"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 09:28:00 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lPSpx-00G6IH-PF; Thu, 25 Mar 2021 18:27:57 +0200
Date:   Thu, 25 Mar 2021 18:27:57 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v1 1/1] net: pch_gbe: Propagate error from
 devm_gpio_request_one()
Message-ID: <YFy6DU4mp3c5l+lP@smile.fi.intel.com>
References: <20210324212308.84898-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324212308.84898-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 11:23:10PM +0200, Andy Shevchenko wrote:
> If GPIO controller is not available yet we need to defer
> the probe of GBE until provider will become available.
> 
> While here, drop GPIOF_EXPORT because it's deprecated and
> may not be available.

I'll send a v2 with many patches against this driver, so I will include this
fix there as well.

-- 
With Best Regards,
Andy Shevchenko


