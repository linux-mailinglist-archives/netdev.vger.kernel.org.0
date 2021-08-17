Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7873EEA47
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbhHQJtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:49:22 -0400
Received: from mga06.intel.com ([134.134.136.31]:55274 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235438AbhHQJtL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 05:49:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="277059667"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="277059667"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 02:48:30 -0700
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="680276924"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 02:48:28 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1mFvhm-00AhKq-Ri; Tue, 17 Aug 2021 12:48:22 +0300
Date:   Tue, 17 Aug 2021 12:48:22 +0300
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v1 net-next 1/3] ptp_ocp: Switch to use
 module_pci_driver() macro
Message-ID: <YRuF5hd0BL/RAEZw@smile.fi.intel.com>
References: <20210813122737.45860-1-andriy.shevchenko@linux.intel.com>
 <20210813111407.0c2288f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHp75VeEO+givZ_SvUc2Wu7=iKvoqJEWYnMD=RHZCxKhqsV-9Q@mail.gmail.com>
 <20210816210101.cnhb4xfifzctr4kj@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816210101.cnhb4xfifzctr4kj@bsd-mbp.dhcp.thefacebook.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 02:01:01PM -0700, Jonathan Lemon wrote:
> On Fri, Aug 13, 2021 at 10:30:51PM +0300, Andy Shevchenko wrote:
> > On Fri, Aug 13, 2021 at 9:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Fri, 13 Aug 2021 15:27:35 +0300 Andy Shevchenko wrote:
> > > > Eliminate some boilerplate code by using module_pci_driver() instead of
> > > > init/exit, and, if needed, moving the salient bits from init into probe.
> > > >
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > >
> > > Jonathan has a series in flight which is fixing some of the same issues:
> > > https://patchwork.kernel.org/project/netdevbpf/list/?series=530079&state=*
> > >
> > > Please hold off for a day or two so it can get merged, and if you don't
> > > mind double check at that point which of your patches are still needed.
> > 
> > Actually it may be the other way around. Since patch 2 in his series
> > is definitely an unneeded churn here, because my devm conversion will
> > have to effectively revert it.
> > 
> > 
> > > According to patchwork your series does not apply to net-next as of
> > > last night so it'll need a respin anyway.
> > 
> > I hope he will chime in and see what we can do the best.
> 
> I'm going to submit a respin of the last patch, I screwed something
> up from all the various trees I'm using.
> 
> Please update to net-next first - the firat patch in your series
> doesn't make any longer, given the current status.

I'll rebase my stuff on top of net-next and resubmit.

Thanks!


-- 
With Best Regards,
Andy Shevchenko


