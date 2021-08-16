Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E153EDEE5
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhHPVBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:01:36 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:63467 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbhHPVBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 17:01:35 -0400
Received: (qmail 1791 invoked by uid 89); 16 Aug 2021 21:01:02 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 16 Aug 2021 21:01:02 -0000
Date:   Mon, 16 Aug 2021 14:01:01 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v1 net-next 1/3] ptp_ocp: Switch to use
 module_pci_driver() macro
Message-ID: <20210816210101.cnhb4xfifzctr4kj@bsd-mbp.dhcp.thefacebook.com>
References: <20210813122737.45860-1-andriy.shevchenko@linux.intel.com>
 <20210813111407.0c2288f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHp75VeEO+givZ_SvUc2Wu7=iKvoqJEWYnMD=RHZCxKhqsV-9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeEO+givZ_SvUc2Wu7=iKvoqJEWYnMD=RHZCxKhqsV-9Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 10:30:51PM +0300, Andy Shevchenko wrote:
> On Fri, Aug 13, 2021 at 9:15 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 13 Aug 2021 15:27:35 +0300 Andy Shevchenko wrote:
> > > Eliminate some boilerplate code by using module_pci_driver() instead of
> > > init/exit, and, if needed, moving the salient bits from init into probe.
> > >
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >
> > Jonathan has a series in flight which is fixing some of the same issues:
> > https://patchwork.kernel.org/project/netdevbpf/list/?series=530079&state=*
> >
> > Please hold off for a day or two so it can get merged, and if you don't
> > mind double check at that point which of your patches are still needed.
> 
> Actually it may be the other way around. Since patch 2 in his series
> is definitely an unneeded churn here, because my devm conversion will
> have to effectively revert it.
> 
> 
> > According to patchwork your series does not apply to net-next as of
> > last night so it'll need a respin anyway.
> 
> I hope he will chime in and see what we can do the best.

I'm going to submit a respin of the last patch, I screwed something
up from all the various trees I'm using.

Please update to net-next first - the firat patch in your series
doesn't make any longer, given the current status.
-- 
Jonathan
