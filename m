Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A4D374B54
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 00:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhEEWmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 18:42:24 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45966 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhEEWmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 18:42:22 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 325EF6412C;
        Thu,  6 May 2021 00:40:40 +0200 (CEST)
Date:   Thu, 6 May 2021 00:41:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Pallavi Prabhu <rpallaviprabhu@gmail.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: netfilter.c: fix missing line after declaration
Message-ID: <20210505224121.GA23510@salvia>
References: <20210505192007.GA12080@pallavi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210505192007.GA12080@pallavi>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pallavi,

On Thu, May 06, 2021 at 12:50:07AM +0530, Pallavi Prabhu wrote:
> Fixed a missing line after a declaration for proper coding style.

I'd probably suggest to use Coccinelle or similar to make a Netfilter
tree wide patch to add line after a declaration.

Probably there are more spots in the Netfilter codebase that can
benefit from this cleanup.

> Signed-off-by: Pallavi Prabhu <rpallaviprabhu@gmail.com>
> ---
>  net/ipv6/netfilter.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
> index ab9a279dd6d4..7b1671f48593 100644
> --- a/net/ipv6/netfilter.c
> +++ b/net/ipv6/netfilter.c
> @@ -81,6 +81,7 @@ static int nf_ip6_reroute(struct sk_buff *skb,
>  
>  	if (entry->state.hook == NF_INET_LOCAL_OUT) {
>  		const struct ipv6hdr *iph = ipv6_hdr(skb);
> +
>  		if (!ipv6_addr_equal(&iph->daddr, &rt_info->daddr) ||
>  		    !ipv6_addr_equal(&iph->saddr, &rt_info->saddr) ||
>  		    skb->mark != rt_info->mark)
> -- 
> 2.25.1
> 
