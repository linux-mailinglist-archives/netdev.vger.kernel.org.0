Return-Path: <netdev+bounces-3270-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C63BA70653B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:29:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AF8928122E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF3D3156FC;
	Wed, 17 May 2023 10:29:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A875258
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:29:10 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAD93A80;
	Wed, 17 May 2023 03:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684319349; x=1715855349;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=s+Q9MD8MUeL3jqq4EHyk0PRGS6hQxwGEoNlmystB14k=;
  b=HZf5EORYCAd4Gpzxje6G6gu/k/6yyRtNN7rr4QggBvQGGStWsxtRp1Sn
   /FOqL+v5G4Ucp4A1Yd4VMUakEe5EnNICp96PQcTqoFAFx+Z2W1FxdRXIF
   VKkNgbpQvgPvC0QOYbcuBDhymO0JFz/Y1qa6+2s9ilWPCh4RtXO4JXGgd
   AsMFPSFrK8zSJoMFNlqTWN/YqoPVMMBu1TtDl969b1ryQkkO7w3PkGlsS
   K8UkVTTSEVQxft6x8FWgMnRCdt2jUqoDouPPOgfdIryQimGsGPHWEL6Jc
   gM+GtAgEJP0//havY0ZZZxxtEJ2dVhLt/12JuDo/jTi0dVtpstdPBvW6x
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="438066579"
X-IronPort-AV: E=Sophos;i="5.99,281,1677571200"; 
   d="scan'208";a="438066579"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 03:29:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="876013032"
X-IronPort-AV: E=Sophos;i="5.99,281,1677571200"; 
   d="scan'208";a="876013032"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005.jf.intel.com with ESMTP; 17 May 2023 03:29:04 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1pzEP0-0008HZ-1H;
	Wed, 17 May 2023 13:29:02 +0300
Date: Wed, 17 May 2023 13:29:02 +0300
From: 'Andy Shevchenko' <andriy.shevchenko@linux.intel.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v8 6/9] net: txgbe: Support GPIO to SFP socket
Message-ID: <ZGSsbr7oPZAZ4U7V@smile.fi.intel.com>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
 <20230515063200.301026-7-jiawenwu@trustnetic.com>
 <ZGKlzFXfqCuq3s8u@smile.fi.intel.com>
 <00c601d9879a$ea72dd90$bf5898b0$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00c601d9879a$ea72dd90$bf5898b0$@trustnetic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 10:05:41AM +0800, Jiawen Wu wrote:
> On Tuesday, May 16, 2023 5:36 AM, Andy Shevchenko wrote:
> > On Mon, May 15, 2023 at 02:31:57PM +0800, Jiawen Wu wrote:
> > > Register GPIO chip and handle GPIO IRQ for SFP socket.

...

> > > +	spin_lock_init(&wx->gpio_lock);
> > 
> > Almost forgot to ask, are you planning to use this GPIO part on PREEMPT_RT
> > kernels? Currently you will get a splat in case IRQ is fired.
> 
> Hmmm, I don't know much about this. Should I use raw_spinlock_t instead of
> spinlock_t?

If you need support PREEMPT_RT.

-- 
With Best Regards,
Andy Shevchenko



