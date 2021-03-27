Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E74C34B582
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 09:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhC0Igj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 04:36:39 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56306 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbhC0IgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 04:36:19 -0400
Received: from madeliefje.horms.nl (tulip.horms.nl [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id E688B25B7A8;
        Sat, 27 Mar 2021 19:36:17 +1100 (AEDT)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 3477D3C01; Sat, 27 Mar 2021 09:36:15 +0100 (CET)
Date:   Sat, 27 Mar 2021 09:36:15 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipvs: A spello fix
Message-ID: <20210327083615.GA734@vergenet.net>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
 <20210326231608.24407-13-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326231608.24407-13-unixbhaskar@gmail.com>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ netfilter-devel@vger.kernel.org

On Sat, Mar 27, 2021 at 04:42:48AM +0530, Bhaskar Chowdhury wrote:
> s/registerd/registered/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Reviewed-by: Simon Horman <horms@verge.net.au>

> ---
>  net/netfilter/ipvs/ip_vs_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 0c132ff9b446..128690c512df 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -2398,7 +2398,7 @@ static int __net_init __ip_vs_init(struct net *net)
>  	if (ipvs == NULL)
>  		return -ENOMEM;
> 
> -	/* Hold the beast until a service is registerd */
> +	/* Hold the beast until a service is registered */
>  	ipvs->enable = 0;
>  	ipvs->net = net;
>  	/* Counters used for creating unique names */
> --
> 2.26.2
> 
