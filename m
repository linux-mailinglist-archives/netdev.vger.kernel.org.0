Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B161F768F
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 12:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgFLKPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 06:15:08 -0400
Received: from smtprelay0080.hostedemail.com ([216.40.44.80]:56746 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725927AbgFLKPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 06:15:05 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 5E8FE18002A55;
        Fri, 12 Jun 2020 10:15:02 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:2895:2901:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3871:3872:3873:3874:4321:5007:6742:7514:10004:10400:10848:10967:11026:11232:11658:11914:12297:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21080:21212:21433:21451:21627:30012:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:12,LUA_SUMMARY:none
X-HE-Tag: tree29_1c128ad26ddb
X-Filterd-Recvd-Size: 2024
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Fri, 12 Jun 2020 10:14:59 +0000 (UTC)
Message-ID: <427be84b1154978342ef861f1f4634c914d03a94.camel@perches.com>
Subject: Re: [PATCH] xdp_rxq_info_user: Replace malloc/memset w/calloc
From:   Joe Perches <joe@perches.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Gaurav Singh <gaurav1086@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "open list:XDP (eXpress Data Path)" <netdev@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Fri, 12 Jun 2020 03:14:58 -0700
In-Reply-To: <20200612084244.4ab4f6c6@carbon>
References: <20200611150221.15665-1-gaurav1086@gmail.com>
         <20200612003640.16248-1-gaurav1086@gmail.com>
         <20200612084244.4ab4f6c6@carbon>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-06-12 at 08:42 +0200, Jesper Dangaard Brouer wrote:
> On Thu, 11 Jun 2020 20:36:40 -0400
> Gaurav Singh <gaurav1086@gmail.com> wrote:
> 
> > Replace malloc/memset with calloc
> > 
> > Fixes: 0fca931a6f21 ("samples/bpf: program demonstrating access to xdp_rxq_info")
> > Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> 
> Above is the correct use of Fixes + Signed-off-by.
> 
> Now you need to update/improve the description, to also
> mention/describe that this also solves the bug you found.

This is not a fix, it's a conversion of one
correct code to a shorter one.


