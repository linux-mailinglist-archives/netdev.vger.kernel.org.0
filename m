Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF8C6434E
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 10:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfGJIGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 04:06:14 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42484 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbfGJIGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 04:06:14 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 3CF5025B7D5;
        Wed, 10 Jul 2019 18:06:11 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 348E6940361; Wed, 10 Jul 2019 10:06:09 +0200 (CEST)
Date:   Wed, 10 Jul 2019 10:06:09 +0200
From:   Simon Horman <horms@verge.net.au>
To:     yangxingwu <xingwu.yang@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     wensong@linux-vs.org, ja@ssi.bg, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: remove unnecessary space
Message-ID: <20190710080609.smxjqe2d5jyro4hv@verge.net.au>
References: <20190710074552.74394-1-xingwu.yang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710074552.74394-1-xingwu.yang@gmail.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 03:45:52PM +0800, yangxingwu wrote:
> this patch removes the extra space.
> 
> Signed-off-by: yangxingwu <xingwu.yang@gmail.com>

Thanks, this looks good to me.

Acked-by: Simon Horman <horms@verge.net.au>

Pablo, please consider including this in nf-next.


> ---
>  net/netfilter/ipvs/ip_vs_mh.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs_mh.c
> index 94d9d34..98e358e 100644
> --- a/net/netfilter/ipvs/ip_vs_mh.c
> +++ b/net/netfilter/ipvs/ip_vs_mh.c
> @@ -174,8 +174,8 @@ static int ip_vs_mh_populate(struct ip_vs_mh_state *s,
>  		return 0;
>  	}
>  
> -	table =  kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> -			 sizeof(unsigned long), GFP_KERNEL);
> +	table =	kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> +			sizeof(unsigned long), GFP_KERNEL);
>  	if (!table)
>  		return -ENOMEM;
>  
> -- 
> 1.8.3.1
> 
