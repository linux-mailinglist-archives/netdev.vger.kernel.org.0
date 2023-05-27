Return-Path: <netdev+bounces-5865-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93361713375
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 10:44:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C18E2818DC
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 08:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04FA01C04;
	Sat, 27 May 2023 08:44:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA58F17FC
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 08:44:32 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7865FE3;
	Sat, 27 May 2023 01:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685177071; x=1716713071;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aL0kr5TSI7kBcksuy1NH51yy/ONbfNHJ9y74kDFI+s8=;
  b=nozhyB5LZylfDqlMxkucjT3NUcNeySLYt7nxvBTcj9n3N8NtO8LrMrNU
   CeSWCcs36Y26irqNlYni8WQxGpxq23zVIqtldTT4K7LiBGG7mg/pIIuMJ
   ug8cR1bkPmkFTZHkHeGuu6b+YTsEYmhdBDE6+ESllzFZOLPLICyoUDOaO
   7Rfh6cuh89tgjFzRcooxbL15ySngi64lsXGqKJU8cVD9LJJjGcguj68m5
   UzDOfeoLeYiL+Qcgh0ItYihOW1iHnupAiWgFsRynsnCBo2kgDA1OxeAGV
   ogrdDhY7Tzjr78REuF6ob7hH9xy3QSHolTJqpyZqNl93QHwySRRb7mvhU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="354391414"
X-IronPort-AV: E=Sophos;i="6.00,196,1681196400"; 
   d="scan'208";a="354391414"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2023 01:44:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="655905835"
X-IronPort-AV: E=Sophos;i="6.00,196,1681196400"; 
   d="scan'208";a="655905835"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga003.jf.intel.com with ESMTP; 27 May 2023 01:44:27 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1q2pXF-000Irb-0R;
	Sat, 27 May 2023 11:44:25 +0300
Date: Sat, 27 May 2023 11:44:24 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>,
	Hans de Goede <hdegoede@redhat.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com,
	Piotr Raczynski <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v9 1/9] net: txgbe: Add software nodes to
 support phylink
Message-ID: <ZHHC6OGH9NJZgRfA@smile.fi.intel.com>
References: <20230524091722.522118-1-jiawenwu@trustnetic.com>
 <20230524091722.522118-2-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524091722.522118-2-jiawenwu@trustnetic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+Cc Hans (see below)

On Wed, May 24, 2023 at 05:17:14PM +0800, Jiawen Wu wrote:
> Register software nodes for GPIO, I2C, SFP and PHYLINK. Define the
> device properties.

...

> +int txgbe_init_phy(struct txgbe *txgbe)
> +{
> +	int ret;
> +
> +	ret = txgbe_swnodes_register(txgbe);
> +	if (ret) {
> +		wx_err(txgbe->wx, "failed to register software nodes\n");

> +		return ret;
> +	}
> +
> +	return 0;

These 4 lines can be as simple as

	return ret;

> +}

...

> +#define NODE_PROP(_NAME, _PROP)			\
> +	(const struct software_node) {		\
> +		.name = _NAME,			\
> +		.properties = _PROP,		\
> +	}

Looking at the amount of drivers that want this, I would declare it in the
property.h with SOFTWARE_NODE_PROPERTY name. I'll Ack that.

Hans, what do you think?

-- 
With Best Regards,
Andy Shevchenko



