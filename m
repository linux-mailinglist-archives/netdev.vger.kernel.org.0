Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC96017A8C0
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 16:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgCEPVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 10:21:42 -0500
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:48150 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726243AbgCEPVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 10:21:42 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id EEE36100E7B45;
        Thu,  5 Mar 2020 15:21:40 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3870:3871:3872:4321:5007:10004:10400:10848:11232:11658:11914:12043:12297:12663:12740:12760:12895:13069:13255:13311:13357:13439:14181:14659:14721:21080:21627:21740:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: love54_65c8d50a17e50
X-Filterd-Recvd-Size: 1591
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Thu,  5 Mar 2020 15:21:39 +0000 (UTC)
Message-ID: <256881484c5db07e47c611a56550642a6f6bd8e9.camel@perches.com>
Subject: Re: [PATCH][next] zd1211rw/zd_usb.h: Replace zero-length array with
 flexible-array member
From:   Joe Perches <joe@perches.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 05 Mar 2020 07:20:04 -0800
In-Reply-To: <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
References: <20200305111216.GA24982@embeddedor>
         <87k13yq2jo.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-03-05 at 16:50 +0200, Kalle Valo wrote:
> "Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:
[]
> >  drivers/net/wireless/zydas/zd1211rw/zd_usb.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> "zd1211rw: " is enough, no need to have the filename in the title.
> 
> But I asked this already in an earlier patch, who prefers this format?
> It already got opposition so I'm not sure what to do.

I think it doesn't matter.

Trivial inconsistencies in patch subject and word choice
don't have much overall impact.


