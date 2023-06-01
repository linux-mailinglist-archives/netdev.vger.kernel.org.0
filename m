Return-Path: <netdev+bounces-7158-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DF8971EF15
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 320B31C2108D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4E1D533;
	Thu,  1 Jun 2023 16:32:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35FF42526
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:32:35 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04C5186;
	Thu,  1 Jun 2023 09:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685637154; x=1717173154;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vn279HRuzB6HR1iJIVPIT3HDj6n27U7CgOAf8DP0lvk=;
  b=YMuYvUMfOJCcmUQqi6HsHJ62EAgN1iNAdy27qUWs8SHduu2hnnxr/9Rk
   p4uOYU30MUEUPMqGedNhAS5K9WhnKUAQbfG3mgvxiBe8GF1MZTgZjWlR3
   68g3/eiA0man7ShOc+Zn8ux0Q70z/PJ888nFo/bk4vgaqAGKJd3jI6gJt
   N52NkArIcOLWy6gbpT77RwAvZb9sbQd4vIfoMRefJVaZO8Vmrm5eiSPHu
   e8hX4JVc4BAqd2NITfLZRqUSmjzaZ3qjPdRpx7aTXNC8CuCtvcgeGtEHd
   +0S7vhIg1JOinNMPDmydMBbsDetKVgCyC1dfGSI+tuF1D5gyb0CObLCkd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="419132619"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="419132619"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 09:32:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="819889665"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="819889665"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002.fm.intel.com with ESMTP; 01 Jun 2023 09:32:31 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1q4lDx-000ScX-2u;
	Thu, 01 Jun 2023 19:32:29 +0300
Date: Thu, 1 Jun 2023 19:32:29 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>, linux-wpan@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Aring <alex.aring@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 1/1] ieee802154: ca8210: Remove stray
 gpiod_unexport() call
Message-ID: <ZHjIHZv4o8JaX7Dt@smile.fi.intel.com>
References: <20230528140938.34034-1-andriy.shevchenko@linux.intel.com>
 <20230529101213.46f4f2b1@xps-13>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529101213.46f4f2b1@xps-13>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 10:12:13AM +0200, Miquel Raynal wrote:
> andriy.shevchenko@linux.intel.com wrote on Sun, 28 May 2023 17:09:38
> +0300:
> 
> > There is no gpiod_export() and gpiod_unexport() looks pretty much stray.
> > The gpiod_export() and gpiod_unexport() shouldn't be used in the code,
> > GPIO sysfs is deprecated. That said, simply drop the stray call.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Any reason not to consider a backport into stable kernels?
> Cc: stable + Fixes would certainly be welcome in this case?

I don't think it's justified for stable. It doesn't fix any existing regression
as far as I understand.

-- 
With Best Regards,
Andy Shevchenko



