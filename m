Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B74B31BE4E
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhBOQGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:06:48 -0500
Received: from mga05.intel.com ([192.55.52.43]:33146 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232091AbhBOQBd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 11:01:33 -0500
IronPort-SDR: O5hpvc2A4AQ0VWOvXQfCRBGiK37lI80cxYgoOh/+d6R2I4wCYoZC4WuS1+ywvaaD4xJkXVAN6O
 ZJINbiTWkYiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="267558229"
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="267558229"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 07:58:55 -0800
IronPort-SDR: qUBcDnMNGWB44uoh1MTupZsdb45fxio3m0E/f9VI6r96twT5vE68fSmGs0x7S+Ia9ZGYH1KBSs
 erfQ6tr1Worg==
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="580213026"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 07:58:50 -0800
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lBgGs-005GNG-Ra; Mon, 15 Feb 2021 17:58:46 +0200
Date:   Mon, 15 Feb 2021 17:58:46 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        netdev@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/3] string: Consolidate yesno() helpers under
 string.h hood
Message-ID: <YCqaNnr7ynRydczE@smile.fi.intel.com>
References: <20210215142137.64476-1-andriy.shevchenko@linux.intel.com>
 <87y2fpbdmp.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2fpbdmp.fsf@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 04:37:50PM +0200, Jani Nikula wrote:
> On Mon, 15 Feb 2021, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > We have already few similar implementation and a lot of code that can benefit
> > of the yesno() helper.  Consolidate yesno() helpers under string.h hood.
> 
> Good luck. I gave up after just four versions. [1]

Thanks for a pointer! I like your version, but here we also discussing a
possibility to do something like %py[DOY]. It will consolidate all those RO or
whatever sections inside one data structure.

> Acked-by: Jani Nikula <jani.nikula@intel.com>
> 
> [1] http://lore.kernel.org/r/20191023131308.9420-1-jani.nikula@intel.com


-- 
With Best Regards,
Andy Shevchenko


