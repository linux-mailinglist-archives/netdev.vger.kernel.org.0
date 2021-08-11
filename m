Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CEC3E91EE
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 14:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhHKMvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 08:51:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:51583 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhHKMvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 08:51:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="278861581"
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="278861581"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 05:50:39 -0700
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="590083571"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 05:50:36 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1mDngk-007pI5-Q6; Wed, 11 Aug 2021 15:50:30 +0300
Date:   Wed, 11 Aug 2021 15:50:30 +0300
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 2/2] wwan: core: Unshadow error code returned by
 ida_alloc_range))
Message-ID: <YRPHlsmBv66r4+vD@smile.fi.intel.com>
References: <20210806085413.61536-1-andriy.shevchenko@linux.intel.com>
 <20210806085413.61536-2-andriy.shevchenko@linux.intel.com>
 <CAHNKnsTPQp16FPuVxY+FtJVOXnSga7zt=K8bhXr2YG15M9Y0eQ@mail.gmail.com>
 <CAHp75VcbucQ4w1rki2NZvpS7p-z5b582HwWXDMW5G67C7C6f3w@mail.gmail.com>
 <CAHNKnsQOhpwLFHLbcyLDLDOQjD7uDdsOg4ptVpdVmwWHK01NwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHNKnsQOhpwLFHLbcyLDLDOQjD7uDdsOg4ptVpdVmwWHK01NwQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 11:35:04PM +0300, Sergey Ryazanov wrote:
> On Fri, Aug 6, 2021 at 5:20 PM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Fri, Aug 6, 2021 at 5:14 PM Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
> >> On Fri, Aug 6, 2021 at 12:00 PM Andy Shevchenko
> >> <andriy.shevchenko@linux.intel.com> wrote:
> >>> ida_alloc_range)) may return other than -ENOMEM error code.
> >>> Unshadow it in the wwan_create_port().
> >>>
> >>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >>
> >> A small nitpick, looks like "ida_alloc_range))" in the description is
> >> a typo and should be "ida_alloc_range()". Besides this:
> >
> > Shall I resend?
> 
> Yes, please. And specify the target tree in the subject, please. See
> patchwork warning [1, 2]. The first patch is a clear bug fix, so it
> should be targeted to the 'net' tree, while the second patch despite
> its usefulness could not be considered a bug fix, so it should be
> targeted to the 'net-next' tree. Subjects could be like this:
> 
> [PATCHv3 net 1/2] wwan: core: Avoid returning NULL from wwan_create_dev()
> [PATCHv3 net-next 2/2] wwan: core: Unshadow error code returned by
> ida_alloc_range()
> 
> Or since the second patch is not depends on the first one and patches
> target different trees, patches could be submitted independently:
> 
> [PATCHv3 net] wwan: core: Avoid returning NULL from wwan_create_dev()
> [PATCHv3 net-next] wwan: core: Unshadow error code returned by ida_alloc_range()

Split and sent separately, thanks!

> 1. https://patchwork.kernel.org/project/netdevbpf/patch/20210806085413.61536-1-andriy.shevchenko@linux.intel.com/
> 2. https://patchwork.kernel.org/project/netdevbpf/patch/20210806085413.61536-2-andriy.shevchenko@linux.intel.com/

-- 
With Best Regards,
Andy Shevchenko


