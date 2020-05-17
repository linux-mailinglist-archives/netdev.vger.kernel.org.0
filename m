Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC1B1D651E
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 04:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgEQCCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 22:02:03 -0400
Received: from smtprelay0034.hostedemail.com ([216.40.44.34]:46198 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726880AbgEQCCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 22:02:02 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id D684618224504;
        Sun, 17 May 2020 02:02:01 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3868:3874:4250:4321:5007:7903:8784:10004:10400:10848:11232:11657:11658:11914:12043:12297:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21433:21451:21611:21627:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: smile27_85fe491442e21
X-Filterd-Recvd-Size: 1382
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Sun, 17 May 2020 02:02:00 +0000 (UTC)
Message-ID: <bd3a3e31d17146965c5a0ff7228cb00ec46f4edb.camel@perches.com>
Subject: Re: [PATCH V6 20/20] net: ks8851: Drop define debug and pr_fmt()
From:   Joe Perches <joe@perches.com>
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Date:   Sat, 16 May 2020 19:01:59 -0700
In-Reply-To: <20200517003354.233373-21-marex@denx.de>
References: <20200517003354.233373-1-marex@denx.de>
         <20200517003354.233373-21-marex@denx.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-05-17 at 02:33 +0200, Marek Vasut wrote:
> Drop those debug statements from both drivers. They were there since
> at least 2011 and enabled by default, but that's likely wrong.
[]
> diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
[]
> -#define DEBUG

Dropping the #define DEBUG lines will cause a behavior
change for the netdev/netif_dbg uses as these messages
will no longer be output by default.


