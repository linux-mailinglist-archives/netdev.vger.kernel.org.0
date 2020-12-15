Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4D02DB549
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 21:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgLOUcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 15:32:13 -0500
Received: from smtprelay0050.hostedemail.com ([216.40.44.50]:40640 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727900AbgLOUby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 15:31:54 -0500
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Dec 2020 15:31:49 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave08.hostedemail.com (Postfix) with ESMTP id 6054618027F88;
        Tue, 15 Dec 2020 20:13:54 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 357FE1802958B;
        Tue, 15 Dec 2020 20:13:54 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,coupons@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1434:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2538:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:4605:5007:7576:7902:7903:7904:10004:10400:10848:11026:11232:11658:11783:11914:12043:12296:12297:12679:12740:12895:13069:13311:13357:13439:13894:14181:14347:14659:14721:21080:21627:21740:30054:30067:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: cave84_270289327426
X-Filterd-Recvd-Size: 2059
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf08.hostedemail.com (Postfix) with ESMTPA;
        Tue, 15 Dec 2020 20:13:53 +0000 (UTC)
Message-ID: <baa43defd49bb297cfb7772b999dbd9abf7f4c0d.camel@perches.com>
Subject: Re: [PATCH] atm: horizon: remove h from printk format specifier
From:   Joe Perches <coupons@perches.com>
To:     trix@redhat.com, Chas Williams <3chas3@gmail.com>
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 15 Dec 2020 12:13:51 -0800
In-Reply-To: <20201215142413.1850207-1-trix@redhat.com>
References: <20201215142413.1850207-1-trix@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-12-15 at 06:24 -0800, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> See Documentation/core-api/printk-formats.rst.
> h should no longer be used in the format specifier for printk.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/atm/horizon.c | 6 +++---

Chas?

Madge has been out of business for a couple decades now.

I doubt anyone does but does anyone actually use this driver or
even have working hardware?

If not, how about just deleting this driver altogether instead?

from horizon.h:

/*
  Madge Horizon ATM Adapter driver.
  Copyright (C) 1995-1999  Madge Networks Ltd.

*/

/*
  IMPORTANT NOTE: Madge Networks no longer makes the adapters
  supported by this driver and makes no commitment to maintain it.
*/


> diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
[]
> @@ -1609,7 +1609,7 @@ static int hrz_send (struct atm_vcc * atm_vcc, struct sk_buff * skb) {
>      if (*s++ == 'D') {
>  	for (i = 0; i < 4; ++i)
>  		d = (d << 4) | hex_to_bin(*s++);
> -      PRINTK (KERN_INFO, "debug bitmap is now %hx", debug = d);
> +      PRINTK (KERN_INFO, "debug bitmap is now %x", debug = d);

An IMO ugly assignment in a printk too.


