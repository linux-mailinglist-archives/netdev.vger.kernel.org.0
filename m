Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD96271BE2
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 09:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgIUHcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 03:32:11 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51692 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgIUHcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 03:32:11 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 03:32:10 EDT
Received: from reginn.horms.nl (unknown [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id C1DC425B7CE;
        Mon, 21 Sep 2020 17:24:42 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 90EA89402DE; Mon, 21 Sep 2020 09:24:40 +0200 (CEST)
Date:   Mon, 21 Sep 2020 09:24:40 +0200
From:   Simon Horman <horms@verge.net.au>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     wensong@linux-vs.org, ja@ssi.bg, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ipvs: Remove unused macros
Message-ID: <20200921072436.GA8437@vergenet.net>
References: <20200918131656.46260-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918131656.46260-1-yuehaibing@huawei.com>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 09:16:56PM +0800, YueHaibing wrote:
> They are not used since commit e4ff67513096 ("ipvs: add
> sync_maxlen parameter for the sync daemon")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Thanks, this look good to me.

Acked-by: Simon Horman <horms@verge.net.au>

Pablo, please consider this for nf-next.

> ---
>  net/netfilter/ipvs/ip_vs_sync.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index 2b8abbfe018c..16b48064f715 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c
> @@ -242,9 +242,6 @@ struct ip_vs_sync_thread_data {
>        |                    IPVS Sync Connection (1)                   |
>  */
>  
> -#define SYNC_MESG_HEADER_LEN	4
> -#define MAX_CONNS_PER_SYNCBUFF	255 /* nr_conns in ip_vs_sync_mesg is 8 bit */
> -
>  /* Version 0 header */
>  struct ip_vs_sync_mesg_v0 {
>  	__u8                    nr_conns;
> -- 
> 2.17.1
> 
