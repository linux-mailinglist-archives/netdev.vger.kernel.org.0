Return-Path: <netdev+bounces-8469-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BED98724386
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12EC81C20F54
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D39A937B9F;
	Tue,  6 Jun 2023 13:03:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B9D37B6F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:03:26 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765A4F4;
	Tue,  6 Jun 2023 06:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686056605; x=1717592605;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=SoK98zYoZg/QJdhX9TAOHffu0QsXR3TmI0mQNbTwSWA=;
  b=BU2b4VJQwD2k/AfzYICbGtQfUDdeGwCHMvMoBbDTi3sgIirAXNFL3mTj
   Jf+weopn4+6ZciLZ4sbdiwJvl5SpjomxkdJvZr13acMkJ4328Nd+j4zSo
   SfLCAhSkttexqnn1zutoIN9dMoSduWnwJiayK03QJYGjTg3LpAlzOaG6f
   M0Uy8fvvQr+MNtZMOMdFN1r6WPbGmpyJzT4S2/qOcr0tKH9gqSXIy4Bnu
   LN0fBMDdhtCX3dCN0ZyaCzZ5QrxQAo1fmXx4wdbTZSBhZODiv4IJ+XGIP
   Bptc79V6gMjLX95OpiHDJsVX/JdtzAyh4wL7t80X8qOEEpQrxj+u+U8wu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="384974419"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="384974419"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 06:03:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="778989489"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="778989489"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jun 2023 06:03:22 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1q6WLI-001dDJ-0Z;
	Tue, 06 Jun 2023 16:03:20 +0300
Date: Tue, 6 Jun 2023 16:03:19 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Alexander Aring <aahringo@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexander Aring <alex.aring@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 1/1] ieee802154: ca8210: Remove stray
 gpiod_unexport() call
Message-ID: <ZH8ulwyl6e/eLfA0@smile.fi.intel.com>
References: <20230528140938.34034-1-andriy.shevchenko@linux.intel.com>
 <ZHWo3LHLunOkXaqW@corigine.com>
 <ZH3srm+8PnZ1rJm9@smile.fi.intel.com>
 <CAK-6q+hkL8cStdSPnZF_D1CtLvJZ=P16TJ8BCGpkGwrbh8uN3A@mail.gmail.com>
 <20230606114743.30f7567e@xps-13>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230606114743.30f7567e@xps-13>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 11:47:43AM +0200, Miquel Raynal wrote:
> aahringo@redhat.com wrote on Tue, 6 Jun 2023 05:33:47 -0400:
> > On Mon, Jun 5, 2023 at 10:12 AM Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> > > On Tue, May 30, 2023 at 09:42:20AM +0200, Simon Horman wrote:  
> > > > On Sun, May 28, 2023 at 05:09:38PM +0300, Andy Shevchenko wrote:  
> > > > > There is no gpiod_export() and gpiod_unexport() looks pretty much stray.
> > > > > The gpiod_export() and gpiod_unexport() shouldn't be used in the code,
> > > > > GPIO sysfs is deprecated. That said, simply drop the stray call.
> > > > >
> > > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>  
> > > >
> > > > Reviewed-by: Simon Horman <simon.horman@corigine.com>  
> > >
> > > Thank you!
> > > Can this be applied now?  
> > 
> > ping, Miquel? :)
> 
> I already applied it locally, but I am trying to fix my "thanks for
> patch" routine to not tell you it was applied on the mtd tree :-p

Good to know and thank you!

-- 
With Best Regards,
Andy Shevchenko



