Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7471AFCCC
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 19:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDSR3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 13:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725969AbgDSR3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 13:29:44 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B591C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:29:44 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id a10so2721234uad.7
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dvCUKxGVlWaHhe/fQ13rPlxV2996HFOT8519fkrtWLg=;
        b=Szw2ZOAhI2A6FucCvg+UFR0fC/sKQ7fZ3ziqkylNluqj0ITiDy9h0N6LjbKEs5ehwE
         Lpxw7WlaBalDMTGWNFK0Jo1f9iRT+b5ADrkCJv6NTmu9vGczKF92SYEyjo/QUO99Ua7a
         lEbKkNi915neiHW/WPcoedUeTQLwcQd/WkEe3XhorIVpVkqbMyJxXWcaGfIZLjBWdceF
         le+x+uHaFx/qVQOWQ9RVny2qZHM+F4m4jyyJuzBWexdxmwYLU6YUeGUF3fg9m/BdmEe2
         MVnFLbAOgvwJl9MGjrNMdDQkoT14iQ65BrqCrFdug786OzK3lgb7DaUkeSaVi+HB+kDM
         BkQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dvCUKxGVlWaHhe/fQ13rPlxV2996HFOT8519fkrtWLg=;
        b=JOEzTImAqa70qJmbGOAZrXj26KD1J5u6vdTU1+7gw3NVOBXdp0mootS5phfjbMi1Hb
         sYvFlrVmFCDezj4IbdRBiPrz0RmEgO7ows4jQmpFUBqbuNWl16xoIJVsafJX8pi934Hp
         7v55G3WytGdPW+tcg/7dxsZ428mN6t/mTiZdScRUGxCi6RSuJOJWbwDGVQCjhMqoUnGQ
         681T2iB4/sqGoZLCn8j0mG4KQ5GtBGEltV8S9E3JjArHOK6bLzevRToKOTF6eJG00IYn
         eYgMiQj/3n9qG01UDBq/Yfehk6ZabCmFoyUBVIo1zBJdyCkOBY5sX8wEvRA0Si5sUg5m
         kO9A==
X-Gm-Message-State: AGi0PuYLB6QMkd6teiFdVcrNTmVFze1sr285qiLTVfMJ0r6Dv07bOQqI
        BRDqB55dgP0611B7GdrvBKac+m1+43XMhS/n9Ps=
X-Google-Smtp-Source: APiQypKhgmuBVsqp+tpA+TQfCTXhib5uhe7ekx/lQiR21AAlhOh64IHAoKUvRKiCLVNvLgUHtUuz1xqKFLdVmuXkFp8=
X-Received: by 2002:ab0:391:: with SMTP id 17mr887837uau.70.1587317382805;
 Sun, 19 Apr 2020 10:29:42 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com> <1587032223-49460-2-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1587032223-49460-2-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sun, 19 Apr 2020 10:29:31 -0700
Message-ID: <CAOrHB_Ape956tPpdMaRv-J2CdaWxkLf5ph57wxSL-6E7pUQ6vg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/5] net: openvswitch: expand the meters
 supported number
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Andy Zhou <azhou@ovn.org>, Ben Pfaff <blp@ovn.org>,
        William Tu <u9012063@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 10:25 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> In kernel datapath of Open vSwitch, there are only 1024
> buckets of meter in one dp. If installing more than 1024
> (e.g. 8192) meters, it may lead to the performance drop.
> But in some case, for example, Open vSwitch used as edge
> gateway, there should be 200,000+ at least, meters used for
> IP address bandwidth limitation.
>
> [Open vSwitch userspace datapath has this issue too.]
>
> For more scalable meter, this patch expands the buckets
> when necessary, so we can install more meters in the datapath.
> Introducing the struct *dp_meter_instance*, it's easy to
> expand meter though changing the *ti* point in the struct
> *dp_meter_table*.
>
> Cc: Pravin B Shelar <pshelar@ovn.org>
> Cc: Andy Zhou <azhou@ovn.org>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/datapath.h |   2 +-
>  net/openvswitch/meter.c    | 200 +++++++++++++++++++++++++++++--------
>  net/openvswitch/meter.h    |  15 ++-
>  3 files changed, 169 insertions(+), 48 deletions(-)
>
> diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> index e239a46c2f94..785105578448 100644
> --- a/net/openvswitch/datapath.h
> +++ b/net/openvswitch/datapath.h
> @@ -82,7 +82,7 @@ struct datapath {
>         u32 max_headroom;
>
>         /* Switch meters. */
> -       struct hlist_head *meters;
> +       struct dp_meter_table *meters;
lets define it as part of this struct to avoid indirection.

>  };
>
>  /**
> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> index 5010d1ddd4bd..494a0014ecd8 100644
> --- a/net/openvswitch/meter.c
> +++ b/net/openvswitch/meter.c
> @@ -19,8 +19,6 @@
>  #include "datapath.h"
>  #include "meter.h"
>
> -#define METER_HASH_BUCKETS 1024
> -
>  static const struct nla_policy meter_policy[OVS_METER_ATTR_MAX + 1] = {
>         [OVS_METER_ATTR_ID] = { .type = NLA_U32, },
>         [OVS_METER_ATTR_KBPS] = { .type = NLA_FLAG },
> @@ -39,6 +37,11 @@ static const struct nla_policy band_policy[OVS_BAND_ATTR_MAX + 1] = {
>         [OVS_BAND_ATTR_STATS] = { .len = sizeof(struct ovs_flow_stats) },
>  };
>
> +static u32 meter_hash(struct dp_meter_instance *ti, u32 id)
> +{
> +       return id % ti->n_meters;
> +}
> +
>  static void ovs_meter_free(struct dp_meter *meter)
>  {
>         if (!meter)
> @@ -47,40 +50,141 @@ static void ovs_meter_free(struct dp_meter *meter)
>         kfree_rcu(meter, rcu);
>  }
>
> -static struct hlist_head *meter_hash_bucket(const struct datapath *dp,
> -                                           u32 meter_id)
> -{
> -       return &dp->meters[meter_id & (METER_HASH_BUCKETS - 1)];
> -}
> -
>  /* Call with ovs_mutex or RCU read lock. */
> -static struct dp_meter *lookup_meter(const struct datapath *dp,
> +static struct dp_meter *lookup_meter(const struct dp_meter_table *tbl,
>                                      u32 meter_id)
>  {
> +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> +       u32 hash = meter_hash(ti, meter_id);
>         struct dp_meter *meter;
> -       struct hlist_head *head;
>
> -       head = meter_hash_bucket(dp, meter_id);
> -       hlist_for_each_entry_rcu(meter, head, dp_hash_node,
> -                               lockdep_ovsl_is_held()) {
> -               if (meter->id == meter_id)
> -                       return meter;
> -       }
> +       meter = rcu_dereference_ovsl(ti->dp_meters[hash]);
> +       if (meter && likely(meter->id == meter_id))
> +               return meter;
> +
>         return NULL;
>  }
>
> -static void attach_meter(struct datapath *dp, struct dp_meter *meter)
> +static struct dp_meter_instance *dp_meter_instance_alloc(const u32 size)
> +{
> +       struct dp_meter_instance *ti;
> +
> +       ti = kvzalloc(sizeof(*ti) +
> +                     sizeof(struct dp_meter *) * size,
> +                     GFP_KERNEL);
> +       if (!ti)
> +               return NULL;
Given this is a kernel space array we need to have hard limit inplace.

> +
> +       ti->n_meters = size;
> +
> +       return ti;
> +}
> +
> +static void dp_meter_instance_free(struct dp_meter_instance *ti)
> +{
> +       kvfree(ti);
> +}
> +
> +static void dp_meter_instance_free_rcu(struct rcu_head *rcu)
> +{
> +       struct dp_meter_instance *ti;
> +
> +       ti = container_of(rcu, struct dp_meter_instance, rcu);
> +       kvfree(ti);
> +}
> +
> +static int
> +dp_meter_instance_realloc(struct dp_meter_table *tbl, u32 size)
> +{
> +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> +       int n_meters = min(size, ti->n_meters);
> +       struct dp_meter_instance *new_ti;
> +       int i;
> +
> +       new_ti = dp_meter_instance_alloc(size);
> +       if (!new_ti)
> +               return -ENOMEM;
> +
> +       for (i = 0; i < n_meters; i++)
> +               new_ti->dp_meters[i] =
> +                       rcu_dereference_ovsl(ti->dp_meters[i]);
> +
> +       rcu_assign_pointer(tbl->ti, new_ti);
> +       call_rcu(&ti->rcu, dp_meter_instance_free_rcu);
> +
> +       return 0;
> +}
> +
> +static void dp_meter_instance_insert(struct dp_meter_instance *ti,
> +                                    struct dp_meter *meter)
> +{
> +       u32 hash;
> +
> +       hash = meter_hash(ti, meter->id);
> +       rcu_assign_pointer(ti->dp_meters[hash], meter);
> +}
> +
> +static void dp_meter_instance_remove(struct dp_meter_instance *ti,
> +                                    struct dp_meter *meter)
>  {
> -       struct hlist_head *head = meter_hash_bucket(dp, meter->id);
> +       u32 hash;
>
> -       hlist_add_head_rcu(&meter->dp_hash_node, head);
> +       hash = meter_hash(ti, meter->id);
> +       RCU_INIT_POINTER(ti->dp_meters[hash], NULL);
>  }
>
> -static void detach_meter(struct dp_meter *meter)
> +static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
>  {
> +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> +       u32 hash = meter_hash(ti, meter->id);
> +
> +       /*
> +        * In generally, slot selected should be empty, because
> +        * OvS uses id-pool to fetch a available id.
> +        */
> +       if (unlikely(rcu_dereference_ovsl(ti->dp_meters[hash])))
> +               return -EINVAL;
we could return -EBUSY instead.
> +
> +       dp_meter_instance_insert(ti, meter);
> +
> +       /* That function is thread-safe. */
> +       if (++tbl->count >= ti->n_meters)
> +               if (dp_meter_instance_realloc(tbl, ti->n_meters * 2))
> +                       goto expand_err;
> +
> +       return 0;
> +
> +expand_err:
> +       dp_meter_instance_remove(ti, meter);
> +       tbl->count--;
> +       return -ENOMEM;
> +}
> +
> +static void detach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
> +{
> +       struct dp_meter_instance *ti;
> +
>         ASSERT_OVSL();
> -       if (meter)
> -               hlist_del_rcu(&meter->dp_hash_node);
> +       if (!meter)
> +               return;
> +
> +       ti = rcu_dereference_ovsl(tbl->ti);
> +       dp_meter_instance_remove(ti, meter);
> +
> +       tbl->count--;
> +
> +       /* Shrink the meter array if necessary. */
> +       if (ti->n_meters > DP_METER_ARRAY_SIZE_MIN &&
> +           tbl->count <= (ti->n_meters / 4)) {
> +               int half_size = ti->n_meters / 2;
> +               int i;
> +
Lets add a comment about this.
> +               for (i = half_size; i < ti->n_meters; i++)
> +                       if (rcu_dereference_ovsl(ti->dp_meters[i]))
> +                               return;
> +
> +               dp_meter_instance_realloc(tbl, half_size);
> +       }
>  }
>
>  static struct sk_buff *
> @@ -303,9 +407,13 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
>         meter_id = nla_get_u32(a[OVS_METER_ATTR_ID]);
>
>         /* Cannot fail after this. */
> -       old_meter = lookup_meter(dp, meter_id);
> -       detach_meter(old_meter);
> -       attach_meter(dp, meter);
> +       old_meter = lookup_meter(dp->meters, meter_id);
in new scheme this can fail due to hash collision, lets check for NULL.

> +       detach_meter(dp->meters, old_meter);
> +
> +       err = attach_meter(dp->meters, meter);
> +       if (err)
> +               goto exit_unlock;
> +
>         ovs_unlock();
>
>         /* Build response with the meter_id and stats from
> @@ -365,7 +473,7 @@ static int ovs_meter_cmd_get(struct sk_buff *skb, struct genl_info *info)
>         }
>
>         /* Locate meter, copy stats. */
> -       meter = lookup_meter(dp, meter_id);
> +       meter = lookup_meter(dp->meters, meter_id);
>         if (!meter) {
>                 err = -ENOENT;
>                 goto exit_unlock;
> @@ -416,13 +524,13 @@ static int ovs_meter_cmd_del(struct sk_buff *skb, struct genl_info *info)
>                 goto exit_unlock;
>         }
>
> -       old_meter = lookup_meter(dp, meter_id);
> +       old_meter = lookup_meter(dp->meters, meter_id);
>         if (old_meter) {
>                 spin_lock_bh(&old_meter->lock);
>                 err = ovs_meter_cmd_reply_stats(reply, meter_id, old_meter);
>                 WARN_ON(err);
>                 spin_unlock_bh(&old_meter->lock);
> -               detach_meter(old_meter);
> +               detach_meter(dp->meters, old_meter);
>         }
>         ovs_unlock();
>         ovs_meter_free(old_meter);
> @@ -452,7 +560,7 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
>         int i, band_exceeded_max = -1;
>         u32 band_exceeded_rate = 0;
>
> -       meter = lookup_meter(dp, meter_id);
> +       meter = lookup_meter(dp->meters, meter_id);
>         /* Do not drop the packet when there is no meter. */
>         if (!meter)
>                 return false;
> @@ -570,32 +678,36 @@ struct genl_family dp_meter_genl_family __ro_after_init = {
>
>  int ovs_meters_init(struct datapath *dp)
>  {
> -       int i;
> +       struct dp_meter_instance *ti;
> +       struct dp_meter_table *tbl;
> +
> +       tbl = kmalloc(sizeof(*tbl), GFP_KERNEL);
> +       if (!tbl)
> +               return -ENOMEM;
>
> -       dp->meters = kmalloc_array(METER_HASH_BUCKETS,
> -                                  sizeof(struct hlist_head), GFP_KERNEL);
> +       tbl->count = 0;
>
> -       if (!dp->meters)
> +       ti = dp_meter_instance_alloc(DP_METER_ARRAY_SIZE_MIN);
> +       if (!ti) {
> +               kfree(tbl);
>                 return -ENOMEM;
> +       }
>
> -       for (i = 0; i < METER_HASH_BUCKETS; i++)
> -               INIT_HLIST_HEAD(&dp->meters[i]);
> +       rcu_assign_pointer(tbl->ti, ti);
> +       dp->meters = tbl;
>
>         return 0;
>  }
>
>  void ovs_meters_exit(struct datapath *dp)
>  {
> +       struct dp_meter_table *tbl = dp->meters;
> +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
>         int i;
>
> -       for (i = 0; i < METER_HASH_BUCKETS; i++) {
> -               struct hlist_head *head = &dp->meters[i];
> -               struct dp_meter *meter;
> -               struct hlist_node *n;
> -
> -               hlist_for_each_entry_safe(meter, n, head, dp_hash_node)
> -                       kfree(meter);
> -       }
> +       for (i = 0; i < ti->n_meters; i++)
> +               ovs_meter_free(ti->dp_meters[i]);
>
> -       kfree(dp->meters);
> +       dp_meter_instance_free(ti);
> +       kfree(tbl);
>  }
> diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
> index f645913870bd..d91940383bbe 100644
> --- a/net/openvswitch/meter.h
> +++ b/net/openvswitch/meter.h
> @@ -18,6 +18,7 @@
>  struct datapath;
>
>  #define DP_MAX_BANDS           1
> +#define DP_METER_ARRAY_SIZE_MIN        (1ULL << 10)
>
>  struct dp_meter_band {
>         u32 type;
> @@ -30,9 +31,6 @@ struct dp_meter_band {
>  struct dp_meter {
>         spinlock_t lock;    /* Per meter lock */
>         struct rcu_head rcu;
> -       struct hlist_node dp_hash_node; /*Element in datapath->meters
> -                                        * hash table.
> -                                        */
>         u32 id;
>         u16 kbps:1, keep_stats:1;
>         u16 n_bands;
> @@ -42,6 +40,17 @@ struct dp_meter {
>         struct dp_meter_band bands[];
>  };
>
> +struct dp_meter_instance {
> +       struct rcu_head rcu;
> +       u32 n_meters;
> +       struct dp_meter __rcu *dp_meters[];
> +};
> +
> +struct dp_meter_table {
> +       struct dp_meter_instance __rcu *ti;
> +       u32 count;
> +};
> +
>  extern struct genl_family dp_meter_genl_family;
>  int ovs_meters_init(struct datapath *dp);
>  void ovs_meters_exit(struct datapath *dp);
> --
> 2.23.0
>
