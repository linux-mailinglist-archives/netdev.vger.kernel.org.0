Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA593064BD
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhA0UFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:05:32 -0500
Received: from smtprelay0010.hostedemail.com ([216.40.44.10]:56364 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232709AbhA0UEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:04:40 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id D41A118015E22;
        Wed, 27 Jan 2021 20:03:28 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:1963:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12048:12297:12740:12895:13069:13311:13357:13439:13894:14181:14659:14721:21080:21451:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: star19_2017b9a27599
X-Filterd-Recvd-Size: 1713
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Wed, 27 Jan 2021 20:03:27 +0000 (UTC)
Message-ID: <47bd723d309955f1cbd5be503fa9b895a6381221.camel@perches.com>
Subject: Re: [PATCH] Bluetooth: af_bluetooth: checkpatch: fix indentation
 and alignment
From:   Joe Perches <joe@perches.com>
To:     Tomoyuki Matsushita <xorphitus@fastmail.com>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 27 Jan 2021 12:03:26 -0800
In-Reply-To: <20210127150520.3459346-1-xorphitus@fastmail.com>
References: <20210127150520.3459346-1-xorphitus@fastmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-01-28 at 00:05 +0900, Tomoyuki Matsushita wrote:
> Signed-off-by: Tomoyuki Matsushita <xorphitus@fastmail.com>

checkpatch is pretty stupid so whatever it recommends needs to
be looked at carefully by a human and fixed appropriately.

> diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
[]
> @@ -478,7 +478,7 @@ __poll_t bt_sock_poll(struct file *file, struct socket *sock,
>  		mask |= EPOLLHUP;
>  
> 
>  	if (sk->sk_state == BT_CONNECT ||
> -			sk->sk_state == BT_CONNECT2 ||
> +	    sk->sk_state == BT_CONNECT2 ||
>  			sk->sk_state == BT_CONFIG)

checkpatch only warns on the alignment of the second line of multi-line statements.
Please make sure all lines of the multi-line statements are aligned.


