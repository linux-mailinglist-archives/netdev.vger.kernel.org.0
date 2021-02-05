Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8421310319
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 04:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhBEDFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 22:05:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229783AbhBEDFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 22:05:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02C1164FCA;
        Fri,  5 Feb 2021 03:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612494276;
        bh=gTokBUxpPJnt/tbALr3OJRucvf0IwqfShLu+k3D+vD0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rQz511WXuzrUAQ3cumFf7z3fsidiqUWzQoHOZSl6KHQKfdTzNvAfp0M4hScnRRoU6
         fMkWjTY18WhhNTll1GP/dqqamowecFXfySxalobEy9B2ytfNiZB0taoI7YrPnVBMi9
         V6Ngzqt+NB00i0rqUB+dbQ9oiuvLe6pZopKzz1ViypOEkflusei6IuqtySEMpsXtTV
         h5SsWTYq7GJiBRCDmqVs3i+zdkDT+8iLiZSAgomXQz4HiaT2HNnfVARXDSWhggrRkd
         nb+q7KaoBAjIrcdqxLa/tfw9CYP5JwBUBnTbEOPIPhSAYkea6j9D0Juu60Lyo7NOlm
         IRtUSA1skQ86Q==
Date:   Thu, 4 Feb 2021 19:04:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: core: Remove extra spaces
Message-ID: <20210204190434.0771aa83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210204030639.14965-1-zhengyongjun3@huawei.com>
References: <20210204030639.14965-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Feb 2021 11:06:39 +0800 Zheng Yongjun wrote:
> Do codingstyle clean up to remove extra spaces.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/core/neighbour.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 9500d28a43b0..72ea94ec8c4a 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1618,7 +1618,7 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
>  
>  	p = kmemdup(&tbl->parms, sizeof(*p), GFP_KERNEL);
>  	if (p) {
> -		p->tbl		  = tbl;
> +		p->tbl = tbl;
>  		refcount_set(&p->refcnt, 1);
>  		p->reachable_time =

                                  ^

It's aligned with the assignment to reachable_time.

I don't find this particularly offensive, there are worse style issues
in this function.

>  				neigh_rand_reach_time(NEIGH_VAR(p, BASE_REACHABLE_TIME));

