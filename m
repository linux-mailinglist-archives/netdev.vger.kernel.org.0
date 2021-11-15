Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAD34503B8
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 12:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhKOLqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 06:46:08 -0500
Received: from mga04.intel.com ([192.55.52.120]:44565 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhKOLqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 06:46:06 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="232146622"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="232146622"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 03:43:11 -0800
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="505889270"
Received: from csrini4x-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.218.37])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 03:43:05 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>
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
        Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/3] string: Consolidate yesno() helpers under string.h hood
In-Reply-To: <YZI/VB+RhScL1wAi@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20210215142137.64476-1-andriy.shevchenko@linux.intel.com> <20211005213423.dklsii4jx37pjvb4@ldmartin-desk2> <YZI/VB+RhScL1wAi@smile.fi.intel.com>
Date:   Mon, 15 Nov 2021 13:43:02 +0200
Message-ID: <874k8d3ard.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> On Tue, Oct 05, 2021 at 02:34:23PM -0700, Lucas De Marchi wrote:
>> On Mon, Feb 15, 2021 at 04:21:35PM +0200, Andy Shevchenko wrote:
>> > We have already few similar implementation and a lot of code that can benefit
>> > of the yesno() helper.  Consolidate yesno() helpers under string.h hood.
>> 
>> I was taking a look on i915_utils.h to reduce it and move some of it
>> elsewhere to be shared with others.  I was starting with these helpers
>> and had [1] done, then Jani pointed me to this thread and also his
>> previous tentative. I thought the natural place for this would be
>> include/linux/string_helpers.h, but I will leave it up to you.
>
> Seems reasonable to use string_helpers (headers and/or C-file).
>
>> After reading the threads, I don't see real opposition to it.
>> Is there a tree you plan to take this through?
>
> I rest my series in favour of Jani's approach, so I suppose there is no go
> for _this_ series.

If you want to make it happen, please pick it up and drive it. I'm
thoroughly had enough of this.

BR,
Jani.


>
>> [1] https://lore.kernel.org/lkml/20211005212634.3223113-1-lucas.demarchi@intel.com/T/#u

-- 
Jani Nikula, Intel Open Source Graphics Center
