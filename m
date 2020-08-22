Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD8624E9EC
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 23:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgHVVDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 17:03:36 -0400
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:47968 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727005AbgHVVDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 17:03:36 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 18045180101ED;
        Sat, 22 Aug 2020 21:03:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3868:3870:3872:3874:4321:5007:6119:6691:7576:7903:10004:10400:10848:10967:11232:11658:11914:12297:12740:12760:12895:13019:13069:13161:13229:13311:13357:13439:14181:14659:14721:21080:21451:21627:30012:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: drum98_630e40427045
X-Filterd-Recvd-Size: 1615
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Sat, 22 Aug 2020 21:03:32 +0000 (UTC)
Message-ID: <b3be3e91364781dc5211ef99dec6d9649076b701.camel@perches.com>
Subject: Re: [PATCH net-next] net: Remove unnecessary intermediate variables
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin.Lv@arm.com, netdev@vger.kernel.org, kuba@kernel.org,
        Song.Zhu@arm.com, linux-kernel@vger.kernel.org
Date:   Sat, 22 Aug 2020 14:03:31 -0700
In-Reply-To: <20200822.135941.1718174258763815012.davem@davemloft.net>
References: <20200822020431.125732-1-Jianlin.Lv@arm.com>
         <20200822.123315.787815838209253525.davem@davemloft.net>
         <ae154f9a96a710157f9b402ba21c6888c855dd1e.camel@perches.com>
         <20200822.135941.1718174258763815012.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-08-22 at 13:59 -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Sat, 22 Aug 2020 13:39:28 -0700
> 
> > It _might_ be slightly faster to use inlines
> 
> We are not using the inline directive in foo.c files and are letting
> the compiler decide.
> 
> Please don't give out advice like this.

Actually, I checked with and without inline
before posting the proposal.

The compiler didn't inline the code without it.
Not even with just static inline.
For gcc 9.3 only the __always_inline did.
That's the only version I checked.



