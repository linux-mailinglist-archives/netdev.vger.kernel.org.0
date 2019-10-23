Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD516E22B4
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403979AbfJWStO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:49:14 -0400
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:57924 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726506AbfJWStN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 14:49:13 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id B81DA1822327E;
        Wed, 23 Oct 2019 18:49:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2689:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3873:4321:5007:10004:10400:11232:11658:11914:12050:12297:12740:12760:12895:13069:13255:13311:13357:13439:14181:14659:14721:21080:21451:21627:30054:30090:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: seed76_500e99da2a55d
X-Filterd-Recvd-Size: 1829
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Wed, 23 Oct 2019 18:49:10 +0000 (UTC)
Message-ID: <bff0a1c4fc69b83c763ffbce42a0152e1573499a.camel@perches.com>
Subject: Re: [Kgdb-bugreport] [PATCH] kernel: convert switch/case
 fallthrough comments to fallthrough;
From:   Joe Perches <joe@perches.com>
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pm@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-audit@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 23 Oct 2019 11:49:08 -0700
In-Reply-To: <20191021090909.yjyed4qodjjcioqc@holly.lan>
References: <f31b38b9ad515a138edaecf85701b1e3db064114.camel@perches.com>
         <20191021090909.yjyed4qodjjcioqc@holly.lan>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-10-21 at 10:09 +0100, Daniel Thompson wrote:
> On Fri, Oct 18, 2019 at 09:35:08AM -0700, Joe Perches wrote:
> > Use the new pseudo keyword "fallthrough;" and not the
> > various /* fallthrough */ style comments.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> > 
> > This is a single patch for the kernel/ source tree,
> > which would otherwise be sent through as separate
> > patches to 19 maintainer sections.
> 
> For the kernel/debug/ files:
> 
> Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
> 
> Will you be putting this in an immutable branch once you've collected
> enough acks?

No, I expect Linus will either run the script
or apply this patch one day.


