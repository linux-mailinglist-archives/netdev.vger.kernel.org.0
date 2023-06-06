Return-Path: <netdev+bounces-8470-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D37C072438E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10D73281684
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A989125B1;
	Tue,  6 Jun 2023 13:04:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304DC37B6F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:04:30 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B278512F;
	Tue,  6 Jun 2023 06:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686056669; x=1717592669;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6IT171qT5AmKSzBUAJosoEK6YDtge7/tdK9pVWUW290=;
  b=eVq9NSneULmj6hAKDPws5JxkXH4V1LTjRRT613NUhhdXwrXtinlzDhal
   qgn+WI3lFerDBtw7emJyqrOYKq6InClPQI01812kadlsyJnKam6HvB82y
   1aTOcMzW+fNtwxRUiUkoZHkys7KjtjuqjfMpxO0sbpXzTwQXOi0dirxHX
   AGtiiKei1Km7YEbZ2TZu7+RaxL7o3NNlUQGPoUYnitOBQ6rz3AjayY+15
   tY8rNOJxd1axUgVHWcL3EvD1hiogwdLEkuBAV795QPpcXe4r/ESE300EN
   PLCxJplqNkJZZTMDjpzSlQ70/fQuiLo3CKIo+MU6/LAKKR8n6u32ZaZMt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="355516183"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="355516183"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 06:04:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="833219876"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="833219876"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga004.jf.intel.com with ESMTP; 06 Jun 2023 06:04:26 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1q6WML-001dDy-13;
	Tue, 06 Jun 2023 16:04:25 +0300
Date: Tue, 6 Jun 2023 16:04:24 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v1 1/1] mac_pton: Clean up the header inclusions
Message-ID: <ZH8u2LLdTeDBQ6ZI@smile.fi.intel.com>
References: <20230604132858.6650-1-andriy.shevchenko@linux.intel.com>
 <ZH7xgznYTfyLIslo@corigine.com>
 <d61eea76bfff30ced8462aeb98409caa9b2232a2.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d61eea76bfff30ced8462aeb98409caa9b2232a2.camel@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 01:20:57PM +0200, Paolo Abeni wrote:
> On Tue, 2023-06-06 at 10:42 +0200, Simon Horman wrote:
> > On Sun, Jun 04, 2023 at 04:28:58PM +0300, Andy Shevchenko wrote:
> > > Since hex_to_bin() is provided by hex.h there is no need to require
> > > kernel.h. Replace the latter by the former and add missing export.h.

...

> > is there a tool that you used to verify this change?
> 
> I guess build testing it should suffice ;)

Yes, it was my brain work with reading the code + compile test on x86.

-- 
With Best Regards,
Andy Shevchenko



