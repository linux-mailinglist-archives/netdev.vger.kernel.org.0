Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D202A64E3
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 11:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfICJPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 05:15:39 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39435 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfICJPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 05:15:39 -0400
Received: by mail-wm1-f66.google.com with SMTP id n2so15905610wmk.4
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 02:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2zn2+gGBVSe8RHtdUqIeIke+cPnfQF4ffAmKjrpAITo=;
        b=R8t/RMXye8kSD/UOlq3Z+gPssebfcPLSUSn2PzHbUIVnznehGmQgSU5rd0ogvdVHLd
         Hmp/OSGEQnN9462gGUCD7USO22w1hwG3OZ6ULg6VcjoJZZtG4z6RMCwoQVmqTT2SOLAe
         ta1Qx0nzyqYL/PhnGFQXqDTRIPyZolhcWpE7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2zn2+gGBVSe8RHtdUqIeIke+cPnfQF4ffAmKjrpAITo=;
        b=lfi1iY50Z719Cy1n3MIT7ichiW+R7WyPAXy/DzteW9BPMzHSDpDGsaIYUsaLa7A335
         b8M+E5GvrmA+GfmRRDkFY5kJLKLluJUMMnufCuYeG8LdHW2pQtDjkcF7C7I5m6QkUYDn
         3HfmuLL3RCcbSfmW+a6I66L6hPj+I7dbWga94g4dQrqvyZM0jmeI9Ysvabtf/o3Wr5V2
         b0Cdojr5M+pGcbaJq16bZJwqX6ULhGyFg0El+SuYt3pRwAH06H9ETZM9GZSlAjnkeUUv
         /RnlNu2Tc1lNUlM+TR5ZsPg9XZhQusdyD4JCrX5VYWLvtX+eZ+ak7QxaQUOFDMpoaKG6
         +jRA==
X-Gm-Message-State: APjAAAVENP351V2p02ZUFMbxb40YkjOYDDjqOq4NrFXkCyUOVzvqKGsK
        VFRyzEA2sfgkqGyoY14pk40rNgz0xGf9+w==
X-Google-Smtp-Source: APXvYqy7M9SrDfhOnQD6yg2YgKjwAJ278uOV4J0BmVbfAKqXnYI5IP2G84iyjXWA3Wwy3AoC3UqYQA==
X-Received: by 2002:a1c:9dc1:: with SMTP id g184mr25555636wme.77.1567502136131;
        Tue, 03 Sep 2019 02:15:36 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m18sm10934920wrg.97.2019.09.03.02.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 02:15:35 -0700 (PDT)
Subject: Re: [PATCH net] ipmr: remove cache_resolve_queue_len
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Phil Karn <karn@ka9q.net>,
        Sukumar Gopalakrishnan <sukumarg1973@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20190903084359.13310-1-liuhangbin@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <e0261582-78ce-038f-ed4c-c2694fb70250@cumulusnetworks.com>
Date:   Tue, 3 Sep 2019 12:15:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903084359.13310-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/09/2019 11:43, Hangbin Liu wrote:
> This is a re-post of previous patch wrote by David Miller[1].
> 
> Phil Karn reported[2] that on busy networks with lots of unresolved
> multicast routing entries, the creation of new multicast group routes
> can be extremely slow and unreliable.
> 
> The reason is we hard-coded multicast route entries with unresolved source
> addresses(cache_resolve_queue_len) to 10. If some multicast route never
> resolves and the unresolved source addresses increased, there will
> be no ability to create new multicast route cache.
> 
> To resolve this issue, we need either add a sysctl entry to make the
> cache_resolve_queue_len configurable, or just remove cache_resolve_queue_len
> directly, as we already have the socket receive queue limits of mrouted
> socket, pointed by David.
> 
> From my side, I'd perfer to remove the cache_resolve_queue_len instead
> of creating two more(IPv4 and IPv6 version) sysctl entry.
> 
> [1] https://lkml.org/lkml/2018/7/22/11
> [2] https://lkml.org/lkml/2018/7/21/343
> 
> Reported-by: Phil Karn <karn@ka9q.net>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/linux/mroute_base.h |  2 --
>  net/ipv4/ipmr.c             | 27 ++++++++++++++++++---------
>  net/ipv6/ip6mr.c            | 10 +++-------
>  3 files changed, 21 insertions(+), 18 deletions(-)
> 

Hi,
IMO this is definitely net-next material. A few more comments below.

Note that hosts will automatically have this limit lifted to about 270
entries with current defaults, some might be surprised if they have
higher limits set and could be left with queues allowing for thousands
of entries in a linked list.

> diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
> index 34de06b426ef..50fb89533029 100644
> --- a/include/linux/mroute_base.h
> +++ b/include/linux/mroute_base.h
> @@ -235,7 +235,6 @@ struct mr_table_ops {
>   * @mfc_hash: Hash table of all resolved routes for easy lookup
>   * @mfc_cache_list: list of resovled routes for possible traversal
>   * @maxvif: Identifier of highest value vif currently in use
> - * @cache_resolve_queue_len: current size of unresolved queue
>   * @mroute_do_assert: Whether to inform userspace on wrong ingress
>   * @mroute_do_pim: Whether to receive IGMP PIMv1
>   * @mroute_reg_vif_num: PIM-device vif index
> @@ -252,7 +251,6 @@ struct mr_table {
>  	struct rhltable		mfc_hash;
>  	struct list_head	mfc_cache_list;
>  	int			maxvif;
> -	atomic_t		cache_resolve_queue_len;
>  	bool			mroute_do_assert;
>  	bool			mroute_do_pim;
>  	bool			mroute_do_wrvifwhole;
> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index c07bc82cbbe9..6c5278b45afb 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -744,8 +744,6 @@ static void ipmr_destroy_unres(struct mr_table *mrt, struct mfc_cache *c)
>  	struct sk_buff *skb;
>  	struct nlmsgerr *e;
>  
> -	atomic_dec(&mrt->cache_resolve_queue_len);
> -
>  	while ((skb = skb_dequeue(&c->_c.mfc_un.unres.unresolved))) {
>  		if (ip_hdr(skb)->version == 0) {
>  			struct nlmsghdr *nlh = skb_pull(skb,
> @@ -1133,9 +1131,11 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
>  	}
>  
>  	if (!found) {
> +		bool was_empty;
> +
>  		/* Create a new entry if allowable */
> -		if (atomic_read(&mrt->cache_resolve_queue_len) >= 10 ||
> -		    (c = ipmr_cache_alloc_unres()) == NULL) {
> +		c = ipmr_cache_alloc_unres();
> +		if (!c) {
>  			spin_unlock_bh(&mfc_unres_lock);
>  
>  			kfree_skb(skb);
> @@ -1161,11 +1161,11 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
>  			return err;
>  		}
>  
> -		atomic_inc(&mrt->cache_resolve_queue_len);
> +		was_empty = list_empty(&mrt->mfc_unres_queue);
>  		list_add(&c->_c.list, &mrt->mfc_unres_queue);
>  		mroute_netlink_event(mrt, c, RTM_NEWROUTE);
>  
> -		if (atomic_read(&mrt->cache_resolve_queue_len) == 1)
> +		if (was_empty)
>  			mod_timer(&mrt->ipmr_expire_timer,
>  				  c->_c.mfc_un.unres.expires);
>  	}
> @@ -1272,7 +1272,6 @@ static int ipmr_mfc_add(struct net *net, struct mr_table *mrt,
>  		if (uc->mfc_origin == c->mfc_origin &&
>  		    uc->mfc_mcastgrp == c->mfc_mcastgrp) {
>  			list_del(&_uc->list);
> -			atomic_dec(&mrt->cache_resolve_queue_len);
>  			found = true;
>  			break;
>  		}
> @@ -1328,7 +1327,7 @@ static void mroute_clean_tables(struct mr_table *mrt, int flags)
>  	}
>  
>  	if (flags & MRT_FLUSH_MFC) {
> -		if (atomic_read(&mrt->cache_resolve_queue_len) != 0) {
> +		if (!list_empty(&mrt->mfc_unres_queue)) {
>  			spin_lock_bh(&mfc_unres_lock);
>  			list_for_each_entry_safe(c, tmp, &mrt->mfc_unres_queue, list) {
>  				list_del(&c->list);
> @@ -2750,9 +2749,19 @@ static int ipmr_rtm_route(struct sk_buff *skb, struct nlmsghdr *nlh,
>  		return ipmr_mfc_delete(tbl, &mfcc, parent);
>  }
>  
> +static int queue_count(struct mr_table *mrt)
> +{
> +	struct list_head *pos;
> +	int count = 0;
> +
> +	list_for_each(pos, &mrt->mfc_unres_queue)
> +		count++;
> +	return count;
> +}

I don't think we hold the mfc_unres_lock here while walking
the unresolved list below in ipmr_fill_table().

> +
>  static bool ipmr_fill_table(struct mr_table *mrt, struct sk_buff *skb)
>  {
> -	u32 queue_len = atomic_read(&mrt->cache_resolve_queue_len);
> +	u32 queue_len = queue_count(mrt);
>  
>  	if (nla_put_u32(skb, IPMRA_TABLE_ID, mrt->id) ||
>  	    nla_put_u32(skb, IPMRA_TABLE_CACHE_RES_QUEUE_LEN, queue_len) ||
> diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
> index e80d36c5073d..d02f0f903559 100644
> --- a/net/ipv6/ip6mr.c
> +++ b/net/ipv6/ip6mr.c
> @@ -768,8 +768,6 @@ static void ip6mr_destroy_unres(struct mr_table *mrt, struct mfc6_cache *c)
>  	struct net *net = read_pnet(&mrt->net);
>  	struct sk_buff *skb;
>  
> -	atomic_dec(&mrt->cache_resolve_queue_len);
> -
>  	while ((skb = skb_dequeue(&c->_c.mfc_un.unres.unresolved)) != NULL) {
>  		if (ipv6_hdr(skb)->version == 0) {
>  			struct nlmsghdr *nlh = skb_pull(skb,
> @@ -1148,8 +1146,8 @@ static int ip6mr_cache_unresolved(struct mr_table *mrt, mifi_t mifi,
>  		 *	Create a new entry if allowable
>  		 */
>  
> -		if (atomic_read(&mrt->cache_resolve_queue_len) >= 10 ||
> -		    (c = ip6mr_cache_alloc_unres()) == NULL) {
> +		c = ip6mr_cache_alloc_unres();
> +		if (!c) {
>  			spin_unlock_bh(&mfc_unres_lock);
>  
>  			kfree_skb(skb);
> @@ -1176,7 +1174,6 @@ static int ip6mr_cache_unresolved(struct mr_table *mrt, mifi_t mifi,
>  			return err;
>  		}
>  
> -		atomic_inc(&mrt->cache_resolve_queue_len);
>  		list_add(&c->_c.list, &mrt->mfc_unres_queue);
>  		mr6_netlink_event(mrt, c, RTM_NEWROUTE);
>  
> @@ -1468,7 +1465,6 @@ static int ip6mr_mfc_add(struct net *net, struct mr_table *mrt,
>  		if (ipv6_addr_equal(&uc->mf6c_origin, &c->mf6c_origin) &&
>  		    ipv6_addr_equal(&uc->mf6c_mcastgrp, &c->mf6c_mcastgrp)) {
>  			list_del(&_uc->list);
> -			atomic_dec(&mrt->cache_resolve_queue_len);
>  			found = true;
>  			break;
>  		}
> @@ -1526,7 +1522,7 @@ static void mroute_clean_tables(struct mr_table *mrt, int flags)
>  	}
>  
>  	if (flags & MRT6_FLUSH_MFC) {
> -		if (atomic_read(&mrt->cache_resolve_queue_len) != 0) {
> +		if (!list_empty(&mrt->mfc_unres_queue)) {
>  			spin_lock_bh(&mfc_unres_lock);
>  			list_for_each_entry_safe(c, tmp, &mrt->mfc_unres_queue, list) {
>  				list_del(&c->list);
> 

