Return-Path: <netdev+bounces-8038-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB598722875
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:12:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72FA528106E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:12:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB921DDC9;
	Mon,  5 Jun 2023 14:12:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E48B1548E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:12:40 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCE71707;
	Mon,  5 Jun 2023 07:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685974340; x=1717510340;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tnFykrtFgC+nsW5qzjC49sVe9sqAoGlIaP4E3a3EaSA=;
  b=avunHCe4Uzy+72x1vDfmwlYzHtrlMV+3IQJnXWZg1buaCzE8flSIwTW8
   0hBU4ElfBHZYC/32n0nx0tX3v8Jgt1uWlrL9JDOhShjM5x+ICaoqY3v7I
   KrEfqKtOyeUiUEG7PRb3nhAYnygyUhwDdx50K2jcTCe6ceRclX3z9toIj
   n1u2a8GlIyy6oIEUdLakXFaFHx9W7YTwaI+6MVgmiLmm/35IWsMlXjSf6
   TEkYW/jgTMBNuxhm2JfbWea84xwRGz5RwX1Og+Nuc1GXtO3ssgsAoFAKm
   QEpFBCh19HPR02t/mrch+mdIvP6nr0amdr8dSOWC2fyxSV4mj5r7R84l2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="345968875"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="345968875"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 07:09:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="741737980"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="741737980"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP; 05 Jun 2023 07:09:52 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1q6Au6-001ODW-0y;
	Mon, 05 Jun 2023 17:09:50 +0300
Date: Mon, 5 Jun 2023 17:09:50 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>, linux-wpan@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Aring <alex.aring@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 1/1] ieee802154: ca8210: Remove stray
 gpiod_unexport() call
Message-ID: <ZH3srm+8PnZ1rJm9@smile.fi.intel.com>
References: <20230528140938.34034-1-andriy.shevchenko@linux.intel.com>
 <ZHWo3LHLunOkXaqW@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHWo3LHLunOkXaqW@corigine.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 09:42:20AM +0200, Simon Horman wrote:
> On Sun, May 28, 2023 at 05:09:38PM +0300, Andy Shevchenko wrote:
> > There is no gpiod_export() and gpiod_unexport() looks pretty much stray.
> > The gpiod_export() and gpiod_unexport() shouldn't be used in the code,
> > GPIO sysfs is deprecated. That said, simply drop the stray call.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Thank you!
Can this be applied now?

-- 
With Best Regards,
Andy Shevchenko



