Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7EB2F1F22
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404070AbhAKTWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:22:35 -0500
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:60392 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403887AbhAKTVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:21:18 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 2BF5C1802912A;
        Mon, 11 Jan 2021 19:20:37 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:2915:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3870:3871:3874:4321:4384:5007:7652:7809:10004:10400:10848:10967:11232:11658:11914:12043:12295:12297:12438:12555:12679:12712:12737:12740:12895:13069:13160:13229:13311:13357:13439:13894:14096:14097:14181:14659:14721:21080:21451:21627:21740:30012:30029:30054:30069:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: thumb88_29104752750f
X-Filterd-Recvd-Size: 2849
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Mon, 11 Jan 2021 19:20:35 +0000 (UTC)
Message-ID: <1250007e1e8b70c2ee5b0f3289c592f121ebaa8f.camel@perches.com>
Subject: Re: [PATCH net 6/9] MAINTAINERS: mtk-eth: remove Felix
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, corbet@lwn.net,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
Date:   Mon, 11 Jan 2021 11:20:33 -0800
In-Reply-To: <20210111094137.0ead3481@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210111052759.2144758-1-kuba@kernel.org>
         <20210111052759.2144758-7-kuba@kernel.org>
         <c5d10d66321ee8b58263d6d9fce6c34e99d839e8.camel@perches.com>
         <20210111094137.0ead3481@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-01-11 at 09:41 -0800, Jakub Kicinski wrote:
> On Sun, 10 Jan 2021 21:45:46 -0800 Joe Perches wrote:
> > On Sun, 2021-01-10 at 21:27 -0800, Jakub Kicinski wrote:
> > > Drop Felix from Mediatek Ethernet driver maintainers.
> > > We haven't seen any tags since the initial submission.  
> > []
> > > diff --git a/MAINTAINERS b/MAINTAINERS  
> > []
> > > @@ -11165,7 +11165,6 @@ F:	Documentation/devicetree/bindings/dma/mtk-*
> > >  F:	drivers/dma/mediatek/
> > >  
> > > 
> > >  MEDIATEK ETHERNET DRIVER
> > > -M:	Felix Fietkau <nbd@nbd.name>
> > >  M:	John Crispin <john@phrozen.org>
> > >  M:	Sean Wang <sean.wang@mediatek.com>
> > >  M:	Mark Lee <Mark-MC.Lee@mediatek.com>  
> > 
> > I think your script is broken as there are multiple subdirectories
> > for this entry and 

> 
> Quite the opposite, the script intentionally only counts contributions
> only to the code under the MAINTAINERS entry.

My mistake.  I'd seen Felix's name fairly often.

I ran this command:

$ git log --pretty=oneline --since=5-years-ago --grep="-by: Felix Fietkau" drivers/net/ethernet/mediatek/
656e705243fd0c2864b89634ea16ed444ef64dc6 net-next: mediatek: add support for MT7623 ethernet

Saw that felix had worked on mediatek and then looked up files in
drivers/net with mediatek and conflated the wireless files and ethernet files.

btw: because I didn't see the script published and so can't verify what's
being done here, the MAINTAINERS file shows:

	F: *Files* and directories wildcard patterns.
	   A trailing slash includes all files and subdirectory files.
	   F:	drivers/net/	all files in and below drivers/net
	   F:	drivers/net/*	all files in drivers/net, but not below

cheers, Joe


