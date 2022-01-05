Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22C7485498
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240908AbiAEOcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:32:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:47560 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240924AbiAEOb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 09:31:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641393118; x=1672929118;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x6pVlsWPdSUlw8ph9IrfWMeatITLHCUX/k2+8AmnbS8=;
  b=GCJ7zhX+mHotgj9qai/7HZY0LtV8YrgYNclLyPaNB5Xinf8UZ1EFWPEA
   B5hmxoZokomjFM6FSdr1YyGX4uzg5+4l9Pm8SLbCfv2c5fTigih9qtpdL
   469Oem6Qv7hIyV4ljjWzYsdBSu/mOmDHb9j5KzJAlIAVucCPfzqa4AbkV
   K5DlemNqldoZfwqCfCE2XMrb3vbdBkN/aMoFOaAf2hCcJ+H0t0u/8Fbt+
   VzsdBHgD6n6KHjIKZ04Z+HbtZRj4VpoYQpqRKJC5dMofawCcnE2CYIKtv
   CgNENnycO4B1m/vemugW+a40SS/RAg25tDD+iBz1Wc460H/UfaN4DQ1zA
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="328798816"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="328798816"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 06:22:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="689014926"
Received: from smile.fi.intel.com ([10.237.72.61])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 06:22:31 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1n57A9-006jDx-U6;
        Wed, 05 Jan 2022 16:21:13 +0200
Date:   Wed, 5 Jan 2022 16:21:13 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/1] can: mcp251x: Get rid of duplicate of_node
 assignment
Message-ID: <YdWpWSMhzmElnIJH@smile.fi.intel.com>
References: <20211202205855.76946-1-andriy.shevchenko@linux.intel.com>
 <YbHvcDhtZFTyfThT@smile.fi.intel.com>
 <20211210130607.rajkkzr7lf6l4tok@pengutronix.de>
 <YbNT4iOj+jfMiIDu@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbNT4iOj+jfMiIDu@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 03:19:31PM +0200, Andy Shevchenko wrote:
> On Fri, Dec 10, 2021 at 02:06:07PM +0100, Marc Kleine-Budde wrote:
> > On 09.12.2021 13:58:40, Andy Shevchenko wrote:
> > > On Thu, Dec 02, 2021 at 10:58:55PM +0200, Andy Shevchenko wrote:
> 
> ...
> 
> > > Marc, what do you think about this change?
> > 
> > LGTM, added to linux-can-next/testing.
> 
> Thanks for applying this and hi311x patches!

Can we have a chance to see it in the v5.17-rc1?

-- 
With Best Regards,
Andy Shevchenko


