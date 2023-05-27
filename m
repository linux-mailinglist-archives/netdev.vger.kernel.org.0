Return-Path: <netdev+bounces-5863-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5D5713369
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 10:36:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 810A11C21140
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 08:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF1D37D;
	Sat, 27 May 2023 08:36:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F63379
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 08:36:49 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7A5C3;
	Sat, 27 May 2023 01:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685176607; x=1716712607;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=g3ihKGcQNUVjVYDTifA1jleLYRKsYAXBvdU0tE1BbaE=;
  b=FgJ55xiO7H/uV4ClLpU/NY1T7Y6WUuVS6p2TP7JtdBY93KRr4DKgs+cU
   PQcem86WtiToJ1uCRoY3DBmPCPSDusMoNemJkcMxLJlPbToiOxyTg8zoe
   Wd8LagPp5BIr9cF64jlWds3B006m7daSARMny7AQtKY5XPFhq7MKNsf13
   xVMyy7XwuogDKEdO3d5ap/ct1nuu8jvjpikQxinozKCqO1Cr4zPOc+H1m
   6HbaD5ApToGf61BbI6FS8RUJGo6+tfvpH/uAHWaeD4E3lxhADLhWKOIUo
   LFjD1cMnJDNrJqdAdipKx8TSFo1hnKz1P91Zr87qmH3DsfV9jAoQ0C1zp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="382628816"
X-IronPort-AV: E=Sophos;i="6.00,196,1681196400"; 
   d="scan'208";a="382628816"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2023 01:36:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="736261280"
X-IronPort-AV: E=Sophos;i="6.00,196,1681196400"; 
   d="scan'208";a="736261280"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008.jf.intel.com with ESMTP; 27 May 2023 01:36:44 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1q2pPm-000IrD-0S;
	Sat, 27 May 2023 11:36:42 +0300
Date: Sat, 27 May 2023 11:36:41 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com,
	Piotr Raczynski <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v9 2/9] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <ZHHBGevv5D1++eIv@smile.fi.intel.com>
References: <20230524091722.522118-1-jiawenwu@trustnetic.com>
 <20230524091722.522118-3-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524091722.522118-3-jiawenwu@trustnetic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 05:17:15PM +0800, Jiawen Wu wrote:
> Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> with SFP.
> 
> Introduce the property "wx,i2c-snps-model" to match device data for Wangxun
> in software node case. Since IO resource was mapped on the ethernet driver,
> add a model quirk to get regmap from parent device.
> 
> The exists IP limitations are dealt as workarounds:
> - IP does not support interrupt mode, it works on polling mode.
> - Additionally set FIFO depth address the chip issue.

Looks better, thank you!
My comments below.

...

> +	if (device_property_present(&pdev->dev, "wx,i2c-snps-model"))

Assuming people are fine with this, I have no objection on the name.

> +		dev->flags |= MODEL_WANGXUN_SP;

You probably has to clear the model in dev_flags, but here still a question
which one should have a priority.

-- 
With Best Regards,
Andy Shevchenko



