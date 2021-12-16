Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C73847727D
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 14:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhLPNAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 08:00:19 -0500
Received: from mga12.intel.com ([192.55.52.136]:11214 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231903AbhLPNAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 08:00:18 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219492415"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219492415"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 05:00:18 -0800
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="464664186"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 05:00:11 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mxqLr-0072QX-V0;
        Thu, 16 Dec 2021 14:59:15 +0200
Date:   Thu, 16 Dec 2021 14:59:15 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
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
Subject: Re: [PATCH net-next v3 05/12] net: wwan: t7xx: Add AT and MBIM WWAN
 ports
Message-ID: <Ybs4I9U0Qnnr9m3T@smile.fi.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
 <20211207024711.2765-6-ricardo.martinez@linux.intel.com>
 <66e09242-ee3e-f714-a9b9-d3ee80ef6596@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <66e09242-ee3e-f714-a9b9-d3ee80ef6596@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 02:25:47PM +0200, Ilpo Järvinen wrote:
> On Mon, 6 Dec 2021, Ricardo Martinez wrote:

> > +		if (multi_packet == 1)
> > +			return actual_count;
> > +		else if (multi_packet == i + 1)

On top of that redundant 'else' here.

> > +			return count;
> > +	}
> 
> I'd recommend renaming variables to make it clearer what they count:
> - count -> bytes
> - actual_count -> actual_bytes
> - multi_packet -> packets

-- 
With Best Regards,
Andy Shevchenko


