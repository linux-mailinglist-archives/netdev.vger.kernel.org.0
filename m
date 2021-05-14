Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA58380684
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 11:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhENJxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 05:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbhENJxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 05:53:41 -0400
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C51CC061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 02:52:30 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 10FC23E906;
        Fri, 14 May 2021 11:52:27 +0200 (CEST)
Date:   Fri, 14 May 2021 11:52:26 +0200
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next] net: bridge: fix br_multicast_is_router stub
 when igmp is disabled
Message-ID: <20210514095226.GE2222@otheros>
References: <20210514073233.2564187-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210514073233.2564187-1-razor@blackwall.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Last-TLS-Session-Version: TLSv1.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 10:32:33AM +0300, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> br_multicast_is_router takes two arguments when bridge IGMP is enabled
> and just one when it's disabled, fix the stub to take two as well.
> 
> Fixes: 1a3065a26807 ("net: bridge: mcast: prepare is-router function for mcast router split")
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
>  net/bridge/br_private.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 53cace4d9487..28f91b111085 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -1081,7 +1081,8 @@ static inline void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
>  {
>  }
>  
> -static inline bool br_multicast_is_router(struct net_bridge *br)
> +static inline bool br_multicast_is_router(struct net_bridge *br,
> +					  struct sk_buff *skb)
>  {
>  	return false;
>  }
> -- 
> 2.30.2
> 

Acked-by: Linus Lüssing <linus.luessing@c0d3.blue>
