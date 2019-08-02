Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9CB180010
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 20:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406544AbfHBSJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 14:09:33 -0400
Received: from smtprelay0155.hostedemail.com ([216.40.44.155]:46166 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406250AbfHBSJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 14:09:33 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 7C446100E86C4;
        Fri,  2 Aug 2019 18:09:31 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3872:4321:5007:10004:10400:10848:11232:11658:11914:12043:12297:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21080:21451:21627:30054:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:30,LUA_SUMMARY:none
X-HE-Tag: print78_35d552e2a8f3a
X-Filterd-Recvd-Size: 1809
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Fri,  2 Aug 2019 18:09:29 +0000 (UTC)
Message-ID: <f2b2559865e8bd59202e14b837a522a801d498e2.camel@perches.com>
Subject: Re: [PATCH V2] mlx5: Fix formats with line continuation whitespace
From:   Joe Perches <joe@perches.com>
To:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Aug 2019 11:09:28 -0700
In-Reply-To: <ac8361beee5dd80ad6546328dd7457bb6ee1ca5a.camel@redhat.com>
References: <f14db3287b23ed8af9bdbf8001e2e2fe7ae9e43a.camel@perches.com>
         <20181101073412.GQ3974@mtr-leonro.mtl.com>
         <ac8361beee5dd80ad6546328dd7457bb6ee1ca5a.camel@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2018-11-06 at 16:34 -0500, Doug Ledford wrote:
> On Thu, 2018-11-01 at 09:34 +0200, Leon Romanovsky wrote:
> > On Thu, Nov 01, 2018 at 12:24:08AM -0700, Joe Perches wrote:
> > > The line continuations unintentionally add whitespace so
> > > instead use coalesced formats to remove the whitespace.
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > > ---
> > > 
> > > v2: Remove excess space after %u
> > > 
> > >  drivers/net/ethernet/mellanox/mlx5/core/rl.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > 
> > 
> > Thanks,
> > Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> 
> Applied, thanks.

Still not upstream.  How long does it take?

