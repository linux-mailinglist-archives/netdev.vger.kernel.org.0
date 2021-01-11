Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AAC2F0CA3
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbhAKFqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:46:31 -0500
Received: from smtprelay0015.hostedemail.com ([216.40.44.15]:42094 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725536AbhAKFqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 00:46:30 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 77FE7182CED28;
        Mon, 11 Jan 2021 05:45:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:966:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2828:2904:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:4321:4385:5007:7652:7809:7903:9121:10004:10400:10848:11232:11233:11658:11914:12043:12262:12297:12438:12555:12679:12740:12895:13019:13069:13311:13357:13439:13894:14181:14659:14721:21080:21324:21365:21451:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: force93_27151e22750a
X-Filterd-Recvd-Size: 1961
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Mon, 11 Jan 2021 05:45:48 +0000 (UTC)
Message-ID: <c5d10d66321ee8b58263d6d9fce6c34e99d839e8.camel@perches.com>
Subject: Re: [PATCH net 6/9] MAINTAINERS: mtk-eth: remove Felix
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
Date:   Sun, 10 Jan 2021 21:45:46 -0800
In-Reply-To: <20210111052759.2144758-7-kuba@kernel.org>
References: <20210111052759.2144758-1-kuba@kernel.org>
         <20210111052759.2144758-7-kuba@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-01-10 at 21:27 -0800, Jakub Kicinski wrote:
> Drop Felix from Mediatek Ethernet driver maintainers.
> We haven't seen any tags since the initial submission.
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -11165,7 +11165,6 @@ F:	Documentation/devicetree/bindings/dma/mtk-*
>  F:	drivers/dma/mediatek/
>  
> 
>  MEDIATEK ETHERNET DRIVER
> -M:	Felix Fietkau <nbd@nbd.name>
>  M:	John Crispin <john@phrozen.org>
>  M:	Sean Wang <sean.wang@mediatek.com>
>  M:	Mark Lee <Mark-MC.Lee@mediatek.com>

I think your script is broken as there are multiple subdirectories
for this entry and Felix is active.

For instance:

commit 9716ef046b46a6426b2a11301ea5232fc8cdce63
Author: Felix Fietkau <nbd@nbd.name>
Date:   Sat Nov 21 18:23:35 2020 +0100

    mt76: attempt to free up more room when filling the tx queue
    
    Run dma cleanup immediately if the queue is almost full, instead of waiting
    for the tx interrupt
    
    Signed-off-by: Felix Fietkau <nbd@nbd.name>



