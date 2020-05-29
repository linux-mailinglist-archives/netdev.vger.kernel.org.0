Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609141E7BE2
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgE2Lcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:32:52 -0400
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:45190 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725306AbgE2Lcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 07:32:52 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id E1972100E7B43;
        Fri, 29 May 2020 11:32:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3871:3873:3876:4321:5007:6119:8531:10004:10400:10848:11026:11658:11914:12296:12297:12740:12760:12895:13019:13069:13311:13357:13439:14659:14721:21080:21627:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: cow08_5c1822326d63
X-Filterd-Recvd-Size: 1308
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Fri, 29 May 2020 11:32:50 +0000 (UTC)
Message-ID: <f88a32fd6bdc9e4279cf673966be203bae4652e1.camel@perches.com>
Subject: Re: [PATCH] net: udp: remove the redundant assignment
From:   Joe Perches <joe@perches.com>
To:     Wang Li <wangli8850@gmail.com>, netdev@vger.kernel.org
Cc:     Wang Li <wangli09@kuaishou.com>
Date:   Fri, 29 May 2020 04:32:49 -0700
In-Reply-To: <20200529112321.18606-1-wangli09@kuaishou.com>
References: <20200529112321.18606-1-wangli09@kuaishou.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-05-29 at 19:23 +0800, Wang Li wrote:
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
[]
> @@ -798,7 +798,6 @@ void udp_set_csum(bool nocheck, struct sk_buff *skb,
>  	} else if (skb_is_gso(skb)) {
>  		uh->check = ~udp_v4_check(len, saddr, daddr, 0);
>  	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
> -		uh->check = 0;
>  		uh->check = udp_v4_check(len, saddr, daddr, lco_csum(skb));

Why do you think this is redundant?

Where does uh point? (struct udphdr *uh = udp_hdr(skb);)
What is lco_csum(skb) doing?



