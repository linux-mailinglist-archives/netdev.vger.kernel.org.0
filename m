Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D224FADF
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 11:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfFWJKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 05:10:31 -0400
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:36653 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbfFWJKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 05:10:31 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 1A4FE180A8854;
        Sun, 23 Jun 2019 09:10:30 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:560:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1381:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2538:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3870:4321:5007:10004:10400:10848:11232:11657:11658:11914:12043:12297:12740:12760:12895:13069:13161:13229:13311:13357:13439:14659:21080:21627:30034:30054:30067:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.14.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: trees44_44490b1b5b60
X-Filterd-Recvd-Size: 1365
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Sun, 23 Jun 2019 09:10:29 +0000 (UTC)
Message-ID: <8eb161f4757cc55d7138bf5d30014e8fb8e38a0d.camel@perches.com>
Subject: Re: [PATCH] sis900: increment revision number
From:   Joe Perches <joe@perches.com>
To:     Sergej Benilov <sergej.benilov@googlemail.com>, venza@brownhat.org,
        netdev@vger.kernel.org
Date:   Sun, 23 Jun 2019 02:10:27 -0700
In-Reply-To: <20190623074707.6348-1-sergej.benilov@googlemail.com>
References: <20190623074707.6348-1-sergej.benilov@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2019-06-23 at 09:47 +0200, Sergej Benilov wrote:
> Increment revision number to 1.08.11 (TX completion fix).

Better not to bother as the last increment was in 2006.
The driver version gets the kernel version in any case.

> diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
[]
> @@ -1,6 +1,6 @@
>  /* sis900.c: A SiS 900/7016 PCI Fast Ethernet driver for Linux.
>     Copyright 1999 Silicon Integrated System Corporation
> -   Revision:	1.08.10 Apr. 2 2006
> +   Revision:	1.08.11 Jun. 23 2019

etc...


