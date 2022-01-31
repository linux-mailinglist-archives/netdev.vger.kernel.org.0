Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03F44A5064
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 21:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344130AbiAaUoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 15:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239860AbiAaUn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 15:43:59 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006FCC061714;
        Mon, 31 Jan 2022 12:43:58 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id n32so13882764pfv.11;
        Mon, 31 Jan 2022 12:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=S1D3Xh8AYuSe6om8jwY6BRq0DL/oG+E3okT1vkS3Jbg=;
        b=cOEebxjevDZrtA1uRIlUscovF+apBcJSrCFz5ykaHA9iCVT/YNWhORCm77au5WahU3
         b8+xxfPWdY2X8hr4B2BOHnqwR3FbBa7lBBN1aylud5nJMzJHELFwneauUZeU4gtACWUt
         g7ypuv2tfud+4jeRdzNvpheX15EN8txlPDh52GJXaCEZb5p2uzq52cBXmHHot9OZqWqM
         oXxnXqvIiYcE/cVEta1L2LV7qDZ4B1pXeFFMUWeK395nxwtPefP97Th9ggM8zGGH2qGh
         eHsseuFPMtZX226Ym0cPrs398bNQAt8eH0mQusupEY0LIS7pl1KbRvukr9FKqQlYrBz+
         B7gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S1D3Xh8AYuSe6om8jwY6BRq0DL/oG+E3okT1vkS3Jbg=;
        b=ZHnXgJf4/bYbJnVfi1e90Tfa5JM6PNTVOpl3k8iC1MoH2bDQ0VzD9OCk1/kDXYs+UD
         f3fqnZKkDFXsVoIG5bMzO9dxZgLNM64LS1UyYGyIBFQYP3tiU15wc3lddOOA5T2VcaCH
         cli84pqtQLqgOoPjSAVtXYmk7bzNrz0QK/Y9lIHYvZvdgG49whHdsgBrx04X6NKOsc8P
         1SsIV8TQc5K/h6I6ORmhirzRao5Dtyi9GSerRcqjNxpIuPTO69vZrV5c67RS/I69i2y7
         L3bw+g8cidpT9SS1AMOY/xEz7sEq1ImUCvQA8U22I8UhCaCrPgWw0BuQn9xmr3ZqPUqV
         JO8A==
X-Gm-Message-State: AOAM532OOuzGycmm6VScDfQONc9NFg+tojfCWGuw01cs44ObwytfK6di
        RNWAU90ZBnKkZpQjtO2owNQ=
X-Google-Smtp-Source: ABdhPJyzuIoTppmcFzPjq3mZKzc1BRWe4ndGhIcTZzBsJ1j3HlEpAsrpCgwUsjZTGqerS6m1b9dt8g==
X-Received: by 2002:a62:e40f:: with SMTP id r15mr22396099pfh.24.1643661838198;
        Mon, 31 Jan 2022 12:43:58 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id t15sm197040pjy.17.2022.01.31.12.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 12:43:57 -0800 (PST)
Message-ID: <949e2f20-5eef-ac9b-2583-f3937cf032d1@gmail.com>
Date:   Mon, 31 Jan 2022 12:43:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next 4/4] net, neigh: Add NTF_MANAGED flag for managed
 neighbor entries
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-5-daniel@iogearbox.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20211011121238.25542-5-daniel@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/11/21 05:12, Daniel Borkmann wrote:
> Allow a user space control plane to insert entries with a new NTF_EXT_MANAGED
> flag. The flag then indicates to the kernel that the neighbor entry should be
> periodically probed for keeping the entry in NUD_REACHABLE state iff possible.
>
> The use case for this is targeting XDP or tc BPF load-balancers which use
> the bpf_fib_lookup() BPF helper in order to piggyback on neighbor resolution
> for their backends. Given they cannot be resolved in fast-path, a control
> plane inserts the L3 (without L2) entries manually into the neighbor table
> and lets the kernel do the neighbor resolution either on the gateway or on
> the backend directly in case the latter resides in the same L2. This avoids
> to deal with L2 in the control plane and to rebuild what the kernel already
> does best anyway.
>
> NTF_EXT_MANAGED can be combined with NTF_EXT_LEARNED in order to avoid GC
> eviction. The kernel then adds NTF_MANAGED flagged entries to a per-neighbor
> table which gets triggered by the system work queue to periodically call
> neigh_event_send() for performing the resolution. The implementation allows
> migration from/to NTF_MANAGED neighbor entries, so that already existing
> entries can be converted by the control plane if needed. Potentially, we could
> make the interval for periodically calling neigh_event_send() configurable;
> right now it's set to DELAY_PROBE_TIME which is also in line with mlxsw which
> has similar driver-internal infrastructure c723c735fa6b ("mlxsw: spectrum_router:
> Periodically update the kernel's neigh table"). In future, the latter could
> possibly reuse the NTF_MANAGED neighbors as well.
>
> Example:
>
>    # ./ip/ip n replace 192.168.178.30 dev enp5s0 managed extern_learn
>    # ./ip/ip n
>    192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a managed extern_learn REACHABLE
>    [...]
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Roopa Prabhu <roopa@nvidia.com>
> Link: https://linuxplumbersconf.org/event/11/contributions/953/
> ---
>   include/net/neighbour.h        |  21 ++++--
>   include/uapi/linux/neighbour.h |  34 ++++++----
>   net/core/neighbour.c           | 113 ++++++++++++++++++++++++---------
>   3 files changed, 120 insertions(+), 48 deletions(-)
>
> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> index 26d4ada0aea9..e8e48be66755 100644
> --- a/include/net/neighbour.h
> +++ b/include/net/neighbour.h
> @@ -155,6 +155,7 @@ struct neighbour {
>   	int			(*output)(struct neighbour *, struct sk_buff *);
>   	const struct neigh_ops	*ops;
>   	struct list_head	gc_list;
> +	struct list_head	managed_list;
>   	struct rcu_head		rcu;
>   	struct net_device	*dev;
>   	u8			primary_key[0];
> @@ -216,11 +217,13 @@ struct neigh_table {
>   	int			gc_thresh3;
>   	unsigned long		last_flush;
>   	struct delayed_work	gc_work;
> +	struct delayed_work	managed_work;
>   	struct timer_list 	proxy_timer;
>   	struct sk_buff_head	proxy_queue;
>   	atomic_t		entries;
>   	atomic_t		gc_entries;
>   	struct list_head	gc_list;
> +	struct list_head	managed_list;
>   	rwlock_t		lock;
>   	unsigned long		last_rand;
>   	struct neigh_statistics	__percpu *stats;
> @@ -250,17 +253,21 @@ static inline void *neighbour_priv(const struct neighbour *n)
>   }
>   
>   /* flags for neigh_update() */
> -#define NEIGH_UPDATE_F_OVERRIDE			0x00000001
> -#define NEIGH_UPDATE_F_WEAK_OVERRIDE		0x00000002
> -#define NEIGH_UPDATE_F_OVERRIDE_ISROUTER	0x00000004
> -#define NEIGH_UPDATE_F_USE			0x10000000
> -#define NEIGH_UPDATE_F_EXT_LEARNED		0x20000000
> -#define NEIGH_UPDATE_F_ISROUTER			0x40000000
> -#define NEIGH_UPDATE_F_ADMIN			0x80000000
> +#define NEIGH_UPDATE_F_OVERRIDE			BIT(0)
> +#define NEIGH_UPDATE_F_WEAK_OVERRIDE		BIT(1)
> +#define NEIGH_UPDATE_F_OVERRIDE_ISROUTER	BIT(2)
> +#define NEIGH_UPDATE_F_USE			BIT(3)
> +#define NEIGH_UPDATE_F_MANAGED			BIT(4)
> +#define NEIGH_UPDATE_F_EXT_LEARNED		BIT(5)
> +#define NEIGH_UPDATE_F_ISROUTER			BIT(6)
> +#define NEIGH_UPDATE_F_ADMIN			BIT(7)
>   
>   /* In-kernel representation for NDA_FLAGS_EXT flags: */
>   #define NTF_OLD_MASK		0xff
>   #define NTF_EXT_SHIFT		8
> +#define NTF_EXT_MASK		(NTF_EXT_MANAGED)
> +
> +#define NTF_MANAGED		(NTF_EXT_MANAGED << NTF_EXT_SHIFT)
>   
>   extern const struct nla_policy nda_policy[];
>   
> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index a80cca141855..db05fb55055e 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -41,14 +41,16 @@ enum {
>    *	Neighbor Cache Entry Flags
>    */
>   
> -#define NTF_USE		0x01
> -#define NTF_SELF	0x02
> -#define NTF_MASTER	0x04
> -#define NTF_PROXY	0x08	/* == ATF_PUBL */
> -#define NTF_EXT_LEARNED	0x10
> -#define NTF_OFFLOADED   0x20
> -#define NTF_STICKY	0x40
> -#define NTF_ROUTER	0x80
> +#define NTF_USE		(1 << 0)
> +#define NTF_SELF	(1 << 1)
> +#define NTF_MASTER	(1 << 2)
> +#define NTF_PROXY	(1 << 3)	/* == ATF_PUBL */
> +#define NTF_EXT_LEARNED	(1 << 4)
> +#define NTF_OFFLOADED   (1 << 5)
> +#define NTF_STICKY	(1 << 6)
> +#define NTF_ROUTER	(1 << 7)
> +/* Extended flags under NDA_FLAGS_EXT: */
> +#define NTF_EXT_MANAGED	(1 << 0)
>   
>   /*
>    *	Neighbor Cache Entry States.
> @@ -66,12 +68,22 @@ enum {
>   #define NUD_PERMANENT	0x80
>   #define NUD_NONE	0x00
>   
> -/* NUD_NOARP & NUD_PERMANENT are pseudostates, they never change
> - * and make no address resolution or NUD.
> - * NUD_PERMANENT also cannot be deleted by garbage collectors.
> +/* NUD_NOARP & NUD_PERMANENT are pseudostates, they never change and make no
> + * address resolution or NUD.
> + *
> + * NUD_PERMANENT also cannot be deleted by garbage collectors. This holds true
> + * for dynamic entries with NTF_EXT_LEARNED flag as well. However, upon carrier
> + * down event, NUD_PERMANENT entries are not flushed whereas NTF_EXT_LEARNED
> + * flagged entries explicitly are (which is also consistent with the routing
> + * subsystem).
> + *
>    * When NTF_EXT_LEARNED is set for a bridge fdb entry the different cache entry
>    * states don't make sense and thus are ignored. Such entries don't age and
>    * can roam.
> + *
> + * NTF_EXT_MANAGED flagged neigbor entries are managed by the kernel on behalf
> + * of a user space control plane, and automatically refreshed so that (if
> + * possible) they remain in NUD_REACHABLE state.
>    */
>   
>   struct nda_cacheinfo {
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 5245e888c981..eae73efa9245 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -122,6 +122,8 @@ static void neigh_mark_dead(struct neighbour *n)
>   		list_del_init(&n->gc_list);
>   		atomic_dec(&n->tbl->gc_entries);
>   	}
> +	if (!list_empty(&n->managed_list))
> +		list_del_init(&n->managed_list);
>   }
>   
>   static void neigh_update_gc_list(struct neighbour *n)
> @@ -130,7 +132,6 @@ static void neigh_update_gc_list(struct neighbour *n)
>   
>   	write_lock_bh(&n->tbl->lock);
>   	write_lock(&n->lock);
> -
>   	if (n->dead)
>   		goto out;
>   
> @@ -149,32 +150,59 @@ static void neigh_update_gc_list(struct neighbour *n)
>   		list_add_tail(&n->gc_list, &n->tbl->gc_list);
>   		atomic_inc(&n->tbl->gc_entries);
>   	}
> +out:
> +	write_unlock(&n->lock);
> +	write_unlock_bh(&n->tbl->lock);
> +}
> +
> +static void neigh_update_managed_list(struct neighbour *n)
> +{
> +	bool on_managed_list, add_to_managed;
> +
> +	write_lock_bh(&n->tbl->lock);
> +	write_lock(&n->lock);
> +	if (n->dead)
> +		goto out;
> +
> +	add_to_managed = n->flags & NTF_MANAGED;
> +	on_managed_list = !list_empty(&n->managed_list);
>   
> +	if (!add_to_managed && on_managed_list)
> +		list_del_init(&n->managed_list);
> +	else if (add_to_managed && !on_managed_list)
> +		list_add_tail(&n->managed_list, &n->tbl->managed_list);
>   out:
>   	write_unlock(&n->lock);
>   	write_unlock_bh(&n->tbl->lock);
>   }
>   
> -static bool neigh_update_ext_learned(struct neighbour *neigh, u32 flags,
> -				     int *notify)
> +static void neigh_update_flags(struct neighbour *neigh, u32 flags, int *notify,
> +			       bool *gc_update, bool *managed_update)
>   {
> -	bool rc = false;
> -	u32 ndm_flags;
> +	u32 ndm_flags, old_flags = neigh->flags;
>   
>   	if (!(flags & NEIGH_UPDATE_F_ADMIN))
> -		return rc;
> +		return;
> +
> +	ndm_flags  = (flags & NEIGH_UPDATE_F_EXT_LEARNED) ? NTF_EXT_LEARNED : 0;
> +	ndm_flags |= (flags & NEIGH_UPDATE_F_MANAGED) ? NTF_MANAGED : 0;
>   
> -	ndm_flags = (flags & NEIGH_UPDATE_F_EXT_LEARNED) ? NTF_EXT_LEARNED : 0;
> -	if ((neigh->flags ^ ndm_flags) & NTF_EXT_LEARNED) {
> +	if ((old_flags ^ ndm_flags) & NTF_EXT_LEARNED) {
>   		if (ndm_flags & NTF_EXT_LEARNED)
>   			neigh->flags |= NTF_EXT_LEARNED;
>   		else
>   			neigh->flags &= ~NTF_EXT_LEARNED;
> -		rc = true;
>   		*notify = 1;
> +		*gc_update = true;
> +	}
> +	if ((old_flags ^ ndm_flags) & NTF_MANAGED) {
> +		if (ndm_flags & NTF_MANAGED)
> +			neigh->flags |= NTF_MANAGED;
> +		else
> +			neigh->flags &= ~NTF_MANAGED;
> +		*notify = 1;
> +		*managed_update = true;
>   	}
> -
> -	return rc;
>   }
>   
>   static bool neigh_del(struct neighbour *n, struct neighbour __rcu **np,
> @@ -422,6 +450,7 @@ static struct neighbour *neigh_alloc(struct neigh_table *tbl,
>   	refcount_set(&n->refcnt, 1);
>   	n->dead		  = 1;
>   	INIT_LIST_HEAD(&n->gc_list);
> +	INIT_LIST_HEAD(&n->managed_list);
>   
>   	atomic_inc(&tbl->entries);
>   out:
> @@ -650,7 +679,8 @@ ___neigh_create(struct neigh_table *tbl, const void *pkey,
>   	n->dead = 0;
>   	if (!exempt_from_gc)
>   		list_add_tail(&n->gc_list, &n->tbl->gc_list);
> -
> +	if (n->flags & NTF_MANAGED)
> +		list_add_tail(&n->managed_list, &n->tbl->managed_list);
>   	if (want_ref)
>   		neigh_hold(n);
>   	rcu_assign_pointer(n->next,
> @@ -1205,8 +1235,6 @@ static void neigh_update_hhs(struct neighbour *neigh)
>   	}
>   }
>   
> -
> -
>   /* Generic update routine.
>      -- lladdr is new lladdr or NULL, if it is not supplied.
>      -- new    is new state.
> @@ -1218,6 +1246,7 @@ static void neigh_update_hhs(struct neighbour *neigh)
>   				if it is different.
>   	NEIGH_UPDATE_F_ADMIN	means that the change is administrative.
>   	NEIGH_UPDATE_F_USE	means that the entry is user triggered.
> +	NEIGH_UPDATE_F_MANAGED	means that the entry will be auto-refreshed.
>   	NEIGH_UPDATE_F_OVERRIDE_ISROUTER allows to override existing
>   				NTF_ROUTER flag.
>   	NEIGH_UPDATE_F_ISROUTER	indicates if the neighbour is known as
> @@ -1225,17 +1254,15 @@ static void neigh_update_hhs(struct neighbour *neigh)
>   
>      Caller MUST hold reference count on the entry.
>    */
> -
>   static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
>   			  u8 new, u32 flags, u32 nlmsg_pid,
>   			  struct netlink_ext_ack *extack)
>   {
> -	bool ext_learn_change = false;
> -	u8 old;
> -	int err;
> -	int notify = 0;
> -	struct net_device *dev;
> +	bool gc_update = false, managed_update = false;
>   	int update_isrouter = 0;
> +	struct net_device *dev;
> +	int err, notify = 0;
> +	u8 old;
>   
>   	trace_neigh_update(neigh, lladdr, new, flags, nlmsg_pid);
>   
> @@ -1254,8 +1281,8 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
>   	    (old & (NUD_NOARP | NUD_PERMANENT)))
>   		goto out;
>   
> -	ext_learn_change = neigh_update_ext_learned(neigh, flags, &notify);
> -	if (flags & NEIGH_UPDATE_F_USE) {
> +	neigh_update_flags(neigh, flags, &notify, &gc_update, &managed_update);
> +	if (flags & (NEIGH_UPDATE_F_USE | NEIGH_UPDATE_F_MANAGED)) {
>   		new = old & ~NUD_PERMANENT;
>   		neigh->nud_state = new;
>   		err = 0;
> @@ -1405,15 +1432,13 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
>   	if (update_isrouter)
>   		neigh_update_is_router(neigh, flags, &notify);
>   	write_unlock_bh(&neigh->lock);
> -
> -	if (((new ^ old) & NUD_PERMANENT) || ext_learn_change)
> +	if (((new ^ old) & NUD_PERMANENT) || gc_update)
>   		neigh_update_gc_list(neigh);
> -
> +	if (managed_update)
> +		neigh_update_managed_list(neigh);
>   	if (notify)
>   		neigh_update_notify(neigh, nlmsg_pid);
> -
>   	trace_neigh_update_done(neigh, err);
> -
>   	return err;
>   }
>   
> @@ -1539,6 +1564,20 @@ int neigh_direct_output(struct neighbour *neigh, struct sk_buff *skb)
>   }
>   EXPORT_SYMBOL(neigh_direct_output);
>   
> +static void neigh_managed_work(struct work_struct *work)
> +{
> +	struct neigh_table *tbl = container_of(work, struct neigh_table,
> +					       managed_work.work);
> +	struct neighbour *neigh;
> +
> +	write_lock_bh(&tbl->lock);
> +	list_for_each_entry(neigh, &tbl->managed_list, managed_list)
> +		neigh_event_send(neigh, NULL);

neigh_event_send() can need to lock tbl->lock, leading to a deadlock ?

__raw_write_lock_bh include/linux/rwlock_api_smp.h:202 [inline]
  _raw_write_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:334
  ___neigh_create+0x9e1/0x2990 net/core/neighbour.c:652
  ip6_finish_output2+0x1070/0x14f0 net/ipv6/ip6_output.c:123
  __ip6_finish_output net/ipv6/ip6_output.c:191 [inline]
  __ip6_finish_output+0x61e/0xe90 net/ipv6/ip6_output.c:170
  ip6_finish_output+0x32/0x200 net/ipv6/ip6_output.c:201
  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
  ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:224
  dst_output include/net/dst.h:451 [inline]
  NF_HOOK include/linux/netfilter.h:307 [inline]
  ndisc_send_skb+0xa99/0x17f0 net/ipv6/ndisc.c:508
  ndisc_send_ns+0x3a9/0x840 net/ipv6/ndisc.c:650
  ndisc_solicit+0x2cd/0x4f0 net/ipv6/ndisc.c:742
  neigh_probe+0xc2/0x110 net/core/neighbour.c:1040
  __neigh_event_send+0x37d/0x1570 net/core/neighbour.c:1201
  neigh_event_send include/net/neighbour.h:470 [inline]
  neigh_managed_work+0x162/0x250 net/core/neighbour.c:1574
  process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
  worker_thread+0x657/0x1110 kernel/workqueue.c:2454
  kthread+0x2e9/0x3a0 kernel/kthread.c:377
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

> +	queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
> +			   NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
> +	write_unlock_bh(&tbl->lock);
> +}
> +
>   static void neigh_proxy_process(struct timer_list *t)
>   {
>   	struct neigh_table *tbl = from_timer(tbl, t, proxy_timer);
> @@ -1685,6 +1724,8 @@ void neigh_table_init(int index, struct neigh_table *tbl)
>   
>   	INIT_LIST_HEAD(&tbl->parms_list);
>   	INIT_LIST_HEAD(&tbl->gc_list);
> +	INIT_LIST_HEAD(&tbl->managed_list);
> +
>   	list_add(&tbl->parms.list, &tbl->parms_list);
>   	write_pnet(&tbl->parms.net, &init_net);
>   	refcount_set(&tbl->parms.refcnt, 1);
> @@ -1716,9 +1757,13 @@ void neigh_table_init(int index, struct neigh_table *tbl)
>   		WARN_ON(tbl->entry_size % NEIGH_PRIV_ALIGN);
>   
>   	rwlock_init(&tbl->lock);
> +
>   	INIT_DEFERRABLE_WORK(&tbl->gc_work, neigh_periodic_work);
>   	queue_delayed_work(system_power_efficient_wq, &tbl->gc_work,
>   			tbl->parms.reachable_time);
> +	INIT_DEFERRABLE_WORK(&tbl->managed_work, neigh_managed_work);
> +	queue_delayed_work(system_power_efficient_wq, &tbl->managed_work, 0);
> +
>   	timer_setup(&tbl->proxy_timer, neigh_proxy_process, 0);
>   	skb_queue_head_init_class(&tbl->proxy_queue,
>   			&neigh_table_proxy_queue_class);
> @@ -1891,7 +1936,7 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
>   	if (tb[NDA_FLAGS_EXT]) {
>   		u32 ext = nla_get_u32(tb[NDA_FLAGS_EXT]);
>   
> -		if (ext & ~0) {
> +		if (ext & ~NTF_EXT_MASK) {
>   			NL_SET_ERR_MSG(extack, "Invalid extended flags");
>   			goto out;
>   		}
> @@ -1927,6 +1972,11 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
>   	if (ndm_flags & NTF_PROXY) {
>   		struct pneigh_entry *pn;
>   
> +		if (ndm_flags & NTF_MANAGED) {
> +			NL_SET_ERR_MSG(extack, "Invalid NTF_* flag combination");
> +			goto out;
> +		}
> +
>   		err = -ENOBUFS;
>   		pn = pneigh_lookup(tbl, net, dst, dev, 1);
>   		if (pn) {
> @@ -1960,7 +2010,8 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
>   		exempt_from_gc = ndm->ndm_state & NUD_PERMANENT ||
>   				 ndm_flags & NTF_EXT_LEARNED;
>   		neigh = ___neigh_create(tbl, dst, dev,
> -					ndm_flags & NTF_EXT_LEARNED,
> +					ndm_flags &
> +					(NTF_EXT_LEARNED | NTF_MANAGED),
>   					exempt_from_gc, true);
>   		if (IS_ERR(neigh)) {
>   			err = PTR_ERR(neigh);
> @@ -1984,12 +2035,14 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
>   		flags |= NEIGH_UPDATE_F_EXT_LEARNED;
>   	if (ndm_flags & NTF_ROUTER)
>   		flags |= NEIGH_UPDATE_F_ISROUTER;
> +	if (ndm_flags & NTF_MANAGED)
> +		flags |= NEIGH_UPDATE_F_MANAGED;
>   	if (ndm_flags & NTF_USE)
>   		flags |= NEIGH_UPDATE_F_USE;
>   
>   	err = __neigh_update(neigh, lladdr, ndm->ndm_state, flags,
>   			     NETLINK_CB(skb).portid, extack);
> -	if (!err && ndm_flags & NTF_USE) {
> +	if (!err && ndm_flags & (NTF_USE | NTF_MANAGED)) {
>   		neigh_event_send(neigh, NULL);
>   		err = 0;
>   	}
