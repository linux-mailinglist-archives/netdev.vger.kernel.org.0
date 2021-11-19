Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C9E456BAE
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 09:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbhKSIcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 03:32:09 -0500
Received: from mga17.intel.com ([192.55.52.151]:46235 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234147AbhKSIcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 03:32:09 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="215094726"
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="215094726"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 00:29:07 -0800
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="455380711"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 00:28:58 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mnzGN-008TT0-2r;
        Fri, 19 Nov 2021 10:28:51 +0200
Date:   Fri, 19 Nov 2021 10:28:50 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Subject: Re: [PATCH v2 02/14] net: wwan: t7xx: Add control DMA interface
Message-ID: <YZdgQpiPZo2Xp1pB@smile.fi.intel.com>
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-3-ricardo.martinez@linux.intel.com>
 <YX/zmY81A9d0nIlO@smile.fi.intel.com>
 <30a536cc-5343-c719-0122-cbedcd7cd03f@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30a536cc-5343-c719-0122-cbedcd7cd03f@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 10:36:32PM -0800, Martinez, Ricardo wrote:
> On 11/1/2021 7:03 AM, Andy Shevchenko wrote:
> > On Sun, Oct 31, 2021 at 08:56:23PM -0700, Ricardo Martinez wrote:

...

> > > +		ret = cldma_gpd_rx_from_queue(queue, budget, &over_budget);
> > > +		if (ret == -ENODATA)
> > > +			return 0;
> > > +
> > > +		if (ret)
> > > +			return ret;
> > Drop redundant blank line
> 
> The style followed is to keep a blank line after 'if' blocks.
> 
> Is that acceptable as long as it is consistent across the driver?

The idea behind suggestion is that you check for value returned from the call.
So, both if:s are tighten to that call and can be considered as a whole.

It doesn't mean you should blindly remove blank lines everywhere.

...

> > > +exit:
> > Seems useless.
> 
> This tag is used when the PM patch is introduced later in the same series.

Can you give it better name?

> > +	return ret;

-- 
With Best Regards,
Andy Shevchenko


