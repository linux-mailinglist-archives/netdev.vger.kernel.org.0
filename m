Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89042775F7
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgIXPz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:55:57 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34704 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728343AbgIXPzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 11:55:55 -0400
Received: from madeliefje.horms.nl (unknown [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 4984E25AD79;
        Fri, 25 Sep 2020 01:55:52 +1000 (AEST)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 982D2152D; Thu, 24 Sep 2020 17:55:50 +0200 (CEST)
Date:   Thu, 24 Sep 2020 17:55:50 +0200
From:   Simon Horman <horms@verge.net.au>
To:     "longguang.yue" <bigclouds@163.com>
Cc:     Wensong Zhang <wensong@linux-vs.org>, Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: adjust the debug order of src and dst
Message-ID: <20200924155550.GC13127@vergenet.net>
References: <20200923055000.82748-1-bigclouds@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923055000.82748-1-bigclouds@163.com>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 01:49:59PM +0800, longguang.yue wrote:
> From: ylg <bigclouds@163.com>
> 
> adjust the debug order of src and dst when tcp state changes
> 
> Signed-off-by: ylg <bigclouds@163.com>

Hi,

This sounds reasonable to me but please provide your real name
in the Signed-off-by name, which should be consistent with the From field
at the top of the commit message (or, if absent of the email).

Thanks!

> ---
>  net/netfilter/ipvs/ip_vs_proto_tcp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> index dc2e7da2742a..6567eb45a234 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> @@ -548,10 +548,10 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
>  			      th->fin ? 'F' : '.',
>  			      th->ack ? 'A' : '.',
>  			      th->rst ? 'R' : '.',
> -			      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
> -			      ntohs(cp->dport),
>  			      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
>  			      ntohs(cp->cport),
> +			      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
> +			      ntohs(cp->dport),
>  			      tcp_state_name(cp->state),
>  			      tcp_state_name(new_state),
>  			      refcount_read(&cp->refcnt));
> -- 
> 2.20.1 (Apple Git-117)
> 
