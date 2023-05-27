Return-Path: <netdev+bounces-5864-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A81CF71336F
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 10:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 603BD281954
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 08:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C6117FC;
	Sat, 27 May 2023 08:38:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0458D17EF
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 08:38:55 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A29E3;
	Sat, 27 May 2023 01:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685176734; x=1716712734;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+D1UGu/X+QqVHidIIXV3nlOrlEFw8rSYcVo9In5cBaw=;
  b=CxfUxl2Z4sGwdO70LNnO2npCGayhhwlqX/9LoyF/Dzl+fGZtMWNWBfpw
   btDOz2x71gB/5SDGhpeqnjAM5sQ5vg1vq3C0YLjKt81xXUCpJHAi1+10w
   vZ5LKQ8i55g5jTOWfUtn+fDZ8WutA31KhFEBTArNLwKWofi13Z14RKPrv
   6dR2lHtsqFZdZNNUXDZ5WmBFzbun7dT18FzWY4KdiS9dDxEM9peHlSiZC
   NMH6ZJFD1dNPO3tAScLjS0IEYwQyOtk6m5RNvnZXuiwhz6rsp57fDuijs
   2xvD7j3HfUbTzXYOx7pgNSy0c9RZo/U+RcFPCJBg5n5oOrZBrM4WZHdT0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="382628868"
X-IronPort-AV: E=Sophos;i="6.00,196,1681196400"; 
   d="scan'208";a="382628868"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2023 01:38:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="952136449"
X-IronPort-AV: E=Sophos;i="6.00,196,1681196400"; 
   d="scan'208";a="952136449"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP; 27 May 2023 01:38:50 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1q2pRo-000IrO-2g;
	Sat, 27 May 2023 11:38:48 +0300
Date: Sat, 27 May 2023 11:38:48 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com,
	Piotr Raczynski <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v9 4/9] net: txgbe: Register I2C platform device
Message-ID: <ZHHBmJwwaw1KynB9@smile.fi.intel.com>
References: <20230524091722.522118-1-jiawenwu@trustnetic.com>
 <20230524091722.522118-5-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524091722.522118-5-jiawenwu@trustnetic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 05:17:17PM +0800, Jiawen Wu wrote:
> Register the platform device to use Designware I2C bus master driver.
> Use regmap to read/write I2C device region from given base offset.

...

> +#include <linux/platform_device.h>

Can this be ordered (to some extent), please?

>  #include <linux/gpio/property.h>
>  #include <linux/clk-provider.h>
>  #include <linux/clkdev.h>
> +#include <linux/regmap.h>

This too.

>  #include <linux/i2c.h>
>  #include <linux/pci.h>

Somewhere here...

...

Otherwise looks good, thank you.

-- 
With Best Regards,
Andy Shevchenko



