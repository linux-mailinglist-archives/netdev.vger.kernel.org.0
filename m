Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2830424C0C
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 11:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfEUJ5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 05:57:13 -0400
Received: from smtprelay0119.hostedemail.com ([216.40.44.119]:56608 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726242AbfEUJ5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 05:57:13 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 83549180A8876;
        Tue, 21 May 2019 09:57:12 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:599:968:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3872:4321:4823:5007:7903:10004:10400:10848:11232:11658:11914:12043:12683:12740:12760:12895:13069:13311:13357:13439:14095:14110:14659:14721:21080:21627:30012:30054:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:27,LUA_SUMMARY:none
X-HE-Tag: rake41_5be978daa584c
X-Filterd-Recvd-Size: 1208
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Tue, 21 May 2019 09:57:11 +0000 (UTC)
Message-ID: <60901822e34c6c715668dbcf7adbded312d19ea4.camel@perches.com>
Subject: Re: [PATCH net] mISDN: Fix indenting in dsp_cmx.c
From:   Joe Perches <joe@perches.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Karsten Keil <isdn@linux-pingi.de>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Date:   Tue, 21 May 2019 02:57:10 -0700
In-Reply-To: <20190521094256.GA11899@mwanda>
References: <20190521094256.GA11899@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-05-21 at 12:42 +0300, Dan Carpenter wrote:
> We used a script to indent this code back in 2012, but I guess it got
> confused by the ifdefs and added some extra tabs.  This patch removes
> them.

Yup, thanks Dan.
Emacs indent-region made a mess of it.

>  drivers/isdn/mISDN/dsp_cmx.c | 427 +++++++++++++++++------------------
>  1 file changed, 213 insertions(+), 214 deletions(-)


