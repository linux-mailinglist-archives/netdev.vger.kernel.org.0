Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97662DA7BF
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 06:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgLOFiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 00:38:46 -0500
Received: from smtprelay0245.hostedemail.com ([216.40.44.245]:35184 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725966AbgLOFib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 00:38:31 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 85076180A8CBE;
        Tue, 15 Dec 2020 05:37:37 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2731:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:7875:10004:10400:10848:11232:11658:11914:12295:12297:12663:12740:12760:12895:13069:13311:13357:13439:14096:14097:14659:14819:21080:21433:21627:21790:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: wire01_4f04bab27421
X-Filterd-Recvd-Size: 2020
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Tue, 15 Dec 2020 05:37:36 +0000 (UTC)
Message-ID: <19198242da4d01804dc20cb41e870b05041bede2.camel@perches.com>
Subject: Re: [PATCH v2] net/mlx4: Use true,false for bool variable
From:   Joe Perches <joe@perches.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vasyl Gomonovych <gomonovych@gmail.com>, tariqt@nvidia.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 14 Dec 2020 21:37:34 -0800
In-Reply-To: <20201215051838.GH5005@unreal>
References: <20201212090234.0362d64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201214103008.14783-1-gomonovych@gmail.com>
         <20201214111608.GE5005@unreal>
         <20201214110351.29ae7abb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <1113d2d634d46adb9384e09c3f70cb8376a815c4.camel@perches.com>
         <20201215051838.GH5005@unreal>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-12-15 at 07:18 +0200, Leon Romanovsky wrote:
> On Mon, Dec 14, 2020 at 11:15:01AM -0800, Joe Perches wrote:
> > I prefer revisions to single patches (as opposed to large patch series)
> > in the same thread.
> 
> It depends which side you are in that game. From the reviewer point of
> view, such submission breaks flow very badly. It unfolds the already
> reviewed thread, messes with the order and many more little annoying
> things.

This is where I disagree with you.  I am a reviewer here.

Not having context to be able to inspect vN -> vN+1 is made
more difficult not having the original patch available and
having to search history for it.

Almost no one adds URL links to older submissions below the ---.

Were that a standard mechanism below the --- line, then it would
be OK.

