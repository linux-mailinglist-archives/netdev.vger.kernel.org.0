Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC6A2DA017
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502296AbgLNTQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:16:03 -0500
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:34594 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502176AbgLNTPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 14:15:55 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id B8D39181D303A;
        Mon, 14 Dec 2020 19:15:04 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2553:2559:2562:2731:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:6248:7514:7875:8531:9040:10004:10400:10848:10967:11232:11658:11914:12043:12296:12297:12663:12740:12895:13069:13161:13229:13311:13357:13439:13894:14181:14659:14721:14777:14819:21063:21080:21433:21451:21627:21740:21819:30022:30029:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: list62_47160c62741d
X-Filterd-Recvd-Size: 2570
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Mon, 14 Dec 2020 19:15:03 +0000 (UTC)
Message-ID: <1113d2d634d46adb9384e09c3f70cb8376a815c4.camel@perches.com>
Subject: Re: [PATCH v2] net/mlx4: Use true,false for bool variable
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
Cc:     Vasyl Gomonovych <gomonovych@gmail.com>, tariqt@nvidia.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 14 Dec 2020 11:15:01 -0800
In-Reply-To: <20201214110351.29ae7abb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201212090234.0362d64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201214103008.14783-1-gomonovych@gmail.com>
         <20201214111608.GE5005@unreal>
         <20201214110351.29ae7abb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-12-14 at 11:03 -0800, Jakub Kicinski wrote:
> On Mon, 14 Dec 2020 13:16:08 +0200 Leon Romanovsky wrote:
> > On Mon, Dec 14, 2020 at 11:30:08AM +0100, Vasyl Gomonovych wrote:
> > > It is fix for semantic patch warning available in
> > > scripts/coccinelle/misc/boolinit.cocci
> > > Fix en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
> > > Fix main.c:4465:5-13: WARNING: Comparison of 0/1 to bool variable
> > > 
> > > Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>
> > > ---
> > >  - Add coccicheck script name
> > >  - Simplify if condition
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
> > >  drivers/net/ethernet/mellanox/mlx4/main.c  | 2 +-
> > >  2 files changed, 2 insertions(+), 2 deletions(-)  
> > 
> > Please refrain from sending new version of patches as reply-to to
> > previous variants. It makes to appear previous patches out-of-order
> > while viewing in threaded mode.
> 
> Yes, please! I'm glad I'm not the only one who feels this way! :)

I'm the other way.

I prefer revisions to single patches (as opposed to large patch series)
in the same thread.

There is no other easy way for changes to a patch to be tracked AFAIK.

Most email clients use both In-Reply-To: and References: headers as
the mechanism to thread replies.

Keeping the latest messages at the bottom of a thread works well
to see revision sequences.


