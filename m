Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F751D6568
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 04:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgEQCz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 22:55:26 -0400
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:37112 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726880AbgEQCzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 22:55:25 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id BE248180A6EE6;
        Sun, 17 May 2020 02:55:24 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:3870:3871:3872:3874:4250:4321:5007:7903:10004:10400:10848:11232:11657:11658:11914:12043:12297:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21433:21451:21611:21627:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: dad00_11feab4ec331b
X-Filterd-Recvd-Size: 2123
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Sun, 17 May 2020 02:55:23 +0000 (UTC)
Message-ID: <11c77ba05a8951d0c269c7f3a7b7e2695f59ebc4.camel@perches.com>
Subject: Re: [PATCH V6 20/20] net: ks8851: Drop define debug and pr_fmt()
From:   Joe Perches <joe@perches.com>
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Date:   Sat, 16 May 2020 19:55:22 -0700
In-Reply-To: <125652bf-45e6-f380-2754-628075526109@denx.de>
References: <20200517003354.233373-1-marex@denx.de>
         <20200517003354.233373-21-marex@denx.de>
         <bd3a3e31d17146965c5a0ff7228cb00ec46f4edb.camel@perches.com>
         <7447d18e-cd81-b98e-a0d9-1059b60a3cf0@denx.de>
         <a27c9079fb257b90382f3af7e071078ab5948eb2.camel@perches.com>
         <125652bf-45e6-f380-2754-628075526109@denx.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-05-17 at 04:47 +0200, Marek Vasut wrote:
> On 5/17/20 4:37 AM, Joe Perches wrote:
> > On Sun, 2020-05-17 at 04:28 +0200, Marek Vasut wrote:
> > > On 5/17/20 4:01 AM, Joe Perches wrote:
> > > > On Sun, 2020-05-17 at 02:33 +0200, Marek Vasut wrote:
> > > > > Drop those debug statements from both drivers. They were there since
> > > > > at least 2011 and enabled by default, but that's likely wrong.
> > > > []
> > > > > diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
> > > > []
> > > > > -#define DEBUG
> > > > 
> > > > Dropping the #define DEBUG lines will cause a behavior
> > > > change for the netdev/netif_dbg uses as these messages
> > > > will no longer be output by default.
> > > 
> > > Is that a problem ?
> > 
> > Dunno.  I don't use nor debug these drivers.
> > 
> 
> I don't use those debug messages either, so it's not a problem for me.

Just mention it in the changelog please.

