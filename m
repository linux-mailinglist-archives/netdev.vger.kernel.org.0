Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DAD5C0E7
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfGAQKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:10:36 -0400
Received: from smtprelay0187.hostedemail.com ([216.40.44.187]:51287 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726646AbfGAQKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:10:36 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 47501629;
        Mon,  1 Jul 2019 16:10:35 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3871:4321:5007:9165:10004:10400:10848:11026:11232:11658:11914:12296:12297:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21627:30003:30054:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.14.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:27,LUA_SUMMARY:none
X-HE-Tag: act42_3f2b48fec7d3c
X-Filterd-Recvd-Size: 1392
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Mon,  1 Jul 2019 16:10:33 +0000 (UTC)
Message-ID: <42624f83da71354a5daef959a4749cb75516d37f.camel@perches.com>
Subject: Re: [PATCH net] ipv4: don't set IPv6 only flags to IPv4 addresses
From:   Joe Perches <joe@perches.com>
To:     Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Date:   Mon, 01 Jul 2019 09:10:32 -0700
In-Reply-To: <20190701160805.32404-1-mcroce@redhat.com>
References: <20190701160805.32404-1-mcroce@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-07-01 at 18:08 +0200, Matteo Croce wrote:
> Avoid the situation where an IPV6 only flag is applied to an IPv4 address:
[]
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
[]
> @@ -468,6 +473,9 @@ static int __inet_insert_ifa(struct in_ifaddr *ifa, struct nlmsghdr *nlh,
>  	ifa->ifa_flags &= ~IFA_F_SECONDARY;
>  	last_primary = &in_dev->ifa_list;
>  
> +	/* Don't set IPv6 only flags to IPv6 addresses */

umm, IPv4 addresses?


