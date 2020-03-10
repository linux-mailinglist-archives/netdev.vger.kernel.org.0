Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58CDC180B4F
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgCJWRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:17:30 -0400
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:35170 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726283AbgCJWR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:17:29 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 6609018224D99;
        Tue, 10 Mar 2020 22:17:28 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1605:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2561:2564:2682:2685:2828:2859:2892:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6117:6119:7903:9025:10004:10400:10848:11026:11232:11473:11658:11914:12043:12295:12297:12438:12555:12663:12740:12760:12895:12986:13161:13229:13255:13439:14040:14181:14659:14721:21080:21094:21324:21433:21451:21627:21740:21939:21972:21990:30006:30012:30041:30054:30070:30075:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:5,LUA_SUMMARY:none
X-HE-Tag: event05_5e115b0cde81b
X-Filterd-Recvd-Size: 4412
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Tue, 10 Mar 2020 22:17:26 +0000 (UTC)
Message-ID: <937b0b529509ec1641453ef7c13f38e2d7cc813e.camel@perches.com>
Subject: Re: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with
 flexible-array member
From:   Joe Perches <joe@perches.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Mar 2020 15:15:44 -0700
In-Reply-To: <fb3395d7-e932-10ac-1feb-ab2ceb63424e@embeddedor.com>
References: <20200305111216.GA24982@embeddedor>
         <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
         <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com>
         <87blpapyu5.fsf@kamboji.qca.qualcomm.com>
         <1bb7270f-545b-23ca-aa27-5b3c52fba1be@embeddedor.com>
         <87r1y0nwip.fsf@kamboji.qca.qualcomm.com>
         <48ff1333-0a14-36d8-9565-a7f13a06c974@embeddedor.com>
         <021d1125-3ffd-39ef-395a-b796c527bde4@gmail.com>
         <fb3395d7-e932-10ac-1feb-ab2ceb63424e@embeddedor.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-03-10 at 17:13 -0500, Gustavo A. R. Silva wrote:
> 
> On 3/10/20 5:07 PM, Jes Sorensen wrote:
> > On 3/10/20 5:52 PM, Gustavo A. R. Silva wrote:
> > > 
> > > On 3/10/20 8:56 AM, Kalle Valo wrote:
> > > > + jes
> > > > 
> > > > "Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:
> > > > > > I wrote in a confusing way, my question above was about the actual patch
> > > > > > and not the the title. For example, Jes didn't like this style change:
> > > > > > 
> > > > > > https://patchwork.kernel.org/patch/11402315/
> > > > > > 
> > > > > 
> > > > > It doesn't seem that that comment adds a lot to the conversation. The only
> > > > > thing that it says is literally "fix the compiler". By the way, more than
> > > > > a hundred patches have already been applied to linux-next[1] and he seems
> > > > > to be the only person that has commented such a thing.
> > > > 
> > > > But I also asked who prefers this format in that thread, you should not
> > > > ignore questions from two maintainers (me and Jes).
> > > > 
> > > 
> > > I'm sorry. I thought the changelog text had already the proper information.
> > > In the changelog text I'm quoting the GCC documentation below:
> > > 
> > > "The preferred mechanism to declare variable-length types like struct line
> > > above is the ISO C99 flexible array member..." [1]
> > > 
> > > I'm also including a link to the following KSPP open issue:
> > > 
> > > https://github.com/KSPP/linux/issues/21
> > > 
> > > The issue above mentions the following:
> > > 
> > > "Both cases (0-byte and 1-byte arrays) pose confusion for things like sizeof(),
> > > CONFIG_FORTIFY_SOURCE."
> > > 
> > > sizeof(flexible-array-member) triggers a warning because flexible array members have
> > > incomplete type[1]. There are some instances of code in which the sizeof operator
> > > is being incorrectly/erroneously applied to zero-length arrays and the result is zero.
> > > Such instances may be hiding some bugs. So, the idea is also to get completely rid
> > > of those sorts of issues.
> > 
> > As I stated in my previous answer, this seems more code churn than an
> > actual fix. If this is a real problem, shouldn't the work be put into
> > fixing the compiler to handle foo[0] instead? It seems that is where the
> > real value would be.
> > 
> 
> Yeah. But, unfortunately, I'm not a compiler guy, so I'm not able to fix the
> compiler as you suggest. And I honestly don't see what is so annoying/disturbing
> about applying a patch that removes the 0 from foo[0] when it brings benefit
> to the whole codebase.

As far as I can tell, it doesn't actually make a difference as
all the compilers produce the same object code with either form.

There may be some compiler warning by clang through.

Does any version of gcc produce a warning on 

	struct foo {
		...
		type bar[0];
	};

but not

	struct foo {
		...
		type bar[];
	};


