Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3DBE8333
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 09:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbfJ2Iap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 04:30:45 -0400
Received: from smtprelay0115.hostedemail.com ([216.40.44.115]:39389 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728757AbfJ2Iap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 04:30:45 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id DEBF1181D3042;
        Tue, 29 Oct 2019 08:30:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3870:3871:3872:3876:4321:5007:6119:6742:7903:10004:10400:10450:10455:11026:11232:11657:11658:11914:12043:12296:12297:12740:12760:12895:13069:13138:13231:13311:13357:13439:13548:14659:14721:19904:19999:21080:21627:21740:30054:30070:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: idea97_7a7d88050d930
X-Filterd-Recvd-Size: 1582
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Tue, 29 Oct 2019 08:30:41 +0000 (UTC)
Message-ID: <055503c8dce7546a8253de1d795ad71870eeb362.camel@perches.com>
Subject: Re: [PATCH] b43: Fix use true/false for bool type
From:   Joe Perches <joe@perches.com>
To:     Simon Horman <simon.horman@netronome.com>,
        Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, swinslow@gmail.com,
        will@kernel.org, opensource@jilayne.com, baijiaju1990@gmail.com,
        tglx@linutronix.de, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, saurav.girepunje@hotmail.com
Date:   Tue, 29 Oct 2019 01:30:34 -0700
In-Reply-To: <20191029082427.GB23615@netronome.com>
References: <20191028190204.GA27248@saurav>
         <20191029082427.GB23615@netronome.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-10-29 at 09:24 +0100, Simon Horman wrote:
> I wonder why bools rather than a bitmask was chosen
> for this field, it seems rather space intensive in its current form.

4 bools is not intensive.

> > diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
[]
> > @@ -3600,7 +3600,7 @@ static void b43_tx_work(struct work_struct *work)
[]
> > -				wl->tx_queue_stopped[queue_num] = 1;
> > +				wl->tx_queue_stopped[queue_num] = true;


