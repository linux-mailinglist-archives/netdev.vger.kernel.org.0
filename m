Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2D124E9FC
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 23:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgHVVUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 17:20:35 -0400
Received: from smtprelay0196.hostedemail.com ([216.40.44.196]:48234 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728750AbgHVVUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 17:20:34 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 0C932181D341E;
        Sat, 22 Aug 2020 21:20:33 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3871:3872:3873:3874:4321:5007:7576:10004:10400:10848:10967:11232:11658:11914:12297:12740:12760:12895:13069:13161:13229:13311:13357:13439:14181:14659:14721:21080:21451:21627:30012:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: rat62_2114dd627045
X-Filterd-Recvd-Size: 1723
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Sat, 22 Aug 2020 21:20:31 +0000 (UTC)
Message-ID: <979bf21913a57f4f402fbd859891907a6ada6209.camel@perches.com>
Subject: Re: [PATCH net-next] net: Remove unnecessary intermediate variables
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin.Lv@arm.com, netdev@vger.kernel.org, kuba@kernel.org,
        Song.Zhu@arm.com, linux-kernel@vger.kernel.org
Date:   Sat, 22 Aug 2020 14:20:30 -0700
In-Reply-To: <20200822.140758.1768310758210192749.davem@davemloft.net>
References: <ae154f9a96a710157f9b402ba21c6888c855dd1e.camel@perches.com>
         <20200822.135941.1718174258763815012.davem@davemloft.net>
         <b3be3e91364781dc5211ef99dec6d9649076b701.camel@perches.com>
         <20200822.140758.1768310758210192749.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-08-22 at 14:07 -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Sat, 22 Aug 2020 14:03:31 -0700
> 
> > The compiler didn't inline the code without it.
> 
> Then the compiler had a good reason for doing so,

The "good" word choice there is slightly dubious.
Compilers make bad decisions all the time.

> or it's a compiler bug that should be reported.

<shrug>

Or just behavioral changes between versions, or
even just random compiler decisions that causes
known unrepeatable compilation output.

That happens all the time.

If you want it just as static without the
inline/__always_inline marking, let me know.


