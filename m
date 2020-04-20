Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6BF1AFF2B
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 02:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgDTAXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 20:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725947AbgDTAXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 20:23:55 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82FEC061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 17:23:54 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id q17so7178524qtp.4
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 17:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=au/g/Q7h5qQx/Rh3rv9hMnSVWxe3mA5qL2IUzh3nmDw=;
        b=FHCXyiPaBvQXj1Yt4nwfKYX3e5j54V25FKkUWAD7dw53npM4jsCYosp18P0LbfYPX0
         b0VrnZCBkZThMTbhGm/5bLEXTdpA2Gak+ddpIM3+KoDHWhxnnW3wUagY3U1AvApUpbnz
         Wjk3S9t9wJKJJGP/mXiRA5VPBf1rTQxQW2FJaEyfczCnKx2L6K/d1qwkvAgzH9kcSpOG
         oE6rKGPOssPXGjvbdNOWmwQPXYY9dVodubMLdTm8aKOU+X59h1mKhkKfM4x7gjVDB/S6
         tuzNDi9iBCBvxaS22DkKItSKwAhZoJ+MR9Tc9ajHgwEJPH2k073ypx80r36x+0sNUxGU
         LrGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=au/g/Q7h5qQx/Rh3rv9hMnSVWxe3mA5qL2IUzh3nmDw=;
        b=aleW6beM7alQWFQx+YGc2m2Kj45/ffYDXXlHk3Dza64m0CJA4/cVjIZtl0LzIdgxC9
         CvEHtI2vw1IvNNadgFqUJGlFbO/CFm+HkSI5atRRvHXck3p2vbVGKCn98Ww5OW3Y9Pmo
         waUlne0FW2rGdxzc0qsEHGzRFFypdp+VHP7TJbs9c6/jJBPrtK4zfNUj3ujOF+SKKyW3
         Fg5kJb8pojLM9lVl8XgYo09E5o87AiGSx3OrRXHeLts8zyPGMEDBbRh8MWw+ZjJkYE56
         UTgHAmcbmTrHAws4Vy/MkE+MBpYDNzFiiSNtk1WmxbQC47lzgm03EwU9j+2cHukHv768
         xAOA==
X-Gm-Message-State: AGi0PuaX9SDtGlJEhWRl5DfQ2TXI5UIe8IsXJPQgJxzOEHSXBSeYYBCI
        nKO/0ZR6EsT0pet8/WUbkY5IqQG+gxIgPMfkv54=
X-Google-Smtp-Source: APiQypJnF9AYBMOn6LpeF403HtXLlHQIc0IQXBvSwoiuUHeN+NSzWCyshRxMJMX2837bL/1+3gDbvTC+7CLrwupoAe4=
X-Received: by 2002:ac8:554a:: with SMTP id o10mr14302735qtr.221.1587342233829;
 Sun, 19 Apr 2020 17:23:53 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-2-git-send-email-xiangxia.m.yue@gmail.com> <CAOrHB_Ape956tPpdMaRv-J2CdaWxkLf5ph57wxSL-6E7pUQ6vg@mail.gmail.com>
In-Reply-To: <CAOrHB_Ape956tPpdMaRv-J2CdaWxkLf5ph57wxSL-6E7pUQ6vg@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 20 Apr 2020 08:23:17 +0800
Message-ID: <CAMDZJNXh_1BFRnypUNLgmF5E4s-qN1cg=0Jqr5RoR5bSNgV-FQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/5] net: openvswitch: expand the meters
 supported number
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Andy Zhou <azhou@ovn.org>, Ben Pfaff <blp@ovn.org>,
        William Tu <u9012063@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 1:29 AM Pravin Shelar <pravin.ovn@gmail.com> wrote:
>
> On Sat, Apr 18, 2020 at 10:25 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > In kernel datapath of Open vSwitch, there are only 1024
> > buckets of meter in one dp. If installing more than 1024
> > (e.g. 8192) meters, it may lead to the performance drop.
> > But in some case, for example, Open vSwitch used as edge
> > gateway, there should be 200,000+ at least, meters used for
> > IP address bandwidth limitation.
> >
> > [Open vSwitch userspace datapath has this issue too.]
> >
> > For more scalable meter, this patch expands the buckets
> > when necessary, so we can install more meters in the datapath.
> > Introducing the struct *dp_meter_instance*, it's easy to
> > expand meter though changing the *ti* point in the struct
> > *dp_meter_table*.
> >
> > Cc: Pravin B Shelar <pshelar@ovn.org>
> > Cc: Andy Zhou <azhou@ovn.org>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >  net/openvswitch/datapath.h |   2 +-
> >  net/openvswitch/meter.c    | 200 +++++++++++++++++++++++++++++--------
> >  net/openvswitch/meter.h    |  15 ++-
> >  3 files changed, 169 insertions(+), 48 deletions(-)
> >
> > diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> > index e239a46c2f94..785105578448 100644
> > --- a/net/openvswitch/datapath.h
> > +++ b/net/openvswitch/datapath.h
> > @@ -82,7 +82,7 @@ struct datapath {
> >         u32 max_headroom;
> >
> >         /* Switch meters. */
> > -       struct hlist_head *meters;
> > +       struct dp_meter_table *meters;
> lets define it as part of this struct to avoid indirection.
>
> >  };
> >
> >  /**
> > diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> > index 5010d1ddd4bd..494a0014ecd8 100644
> > --- a/net/openvswitch/meter.c
> > +++ b/net/openvswitch/meter.c
> > @@ -19,8 +19,6 @@
> >  #include "datapath.h"
> >  #include "meter.h"
> >
> > -#define METER_HASH_BUCKETS 1024
> > -
> >  static const struct nla_policy meter_policy[OVS_METER_ATTR_MAX + 1] = {
> >         [OVS_METER_ATTR_ID] = { .type = NLA_U32, },
> >         [OVS_METER_ATTR_KBPS] = { .type = NLA_FLAG },
> > @@ -39,6 +37,11 @@ static const struct nla_policy band_policy[OVS_BAND_ATTR_MAX + 1] = {
> >         [OVS_BAND_ATTR_STATS] = { .len = sizeof(struct ovs_flow_stats) },
> >  };
> >
> > +static u32 meter_hash(struct dp_meter_instance *ti, u32 id)
> > +{
> > +       return id % ti->n_meters;
> > +}
> > +
> >  static void ovs_meter_free(struct dp_meter *meter)
> >  {
> >         if (!meter)
> > @@ -47,40 +50,141 @@ static void ovs_meter_free(struct dp_meter *meter)
> >         kfree_rcu(meter, rcu);
> >  }
> >
> > -static struct hlist_head *meter_hash_bucket(const struct datapath *dp,
> > -                                           u32 meter_id)
> > -{
> > -       return &dp->meters[meter_id & (METER_HASH_BUCKETS - 1)];
> > -}
> > -
> >  /* Call with ovs_mutex or RCU read lock. */
> > -static struct dp_meter *lookup_meter(const struct datapath *dp,
> > +static struct dp_meter *lookup_meter(const struct dp_meter_table *tbl,
> >                                      u32 meter_id)
> >  {
> > +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> > +       u32 hash = meter_hash(ti, meter_id);
> >         struct dp_meter *meter;
> > -       struct hlist_head *head;
> >
> > -       head = meter_hash_bucket(dp, meter_id);
> > -       hlist_for_each_entry_rcu(meter, head, dp_hash_node,
> > -                               lockdep_ovsl_is_held()) {
> > -               if (meter->id == meter_id)
> > -                       return meter;
> > -       }
> > +       meter = rcu_dereference_ovsl(ti->dp_meters[hash]);
> > +       if (meter && likely(meter->id == meter_id))
> > +               return meter;
> > +
> >         return NULL;
> >  }
> >
> > -static void attach_meter(struct datapath *dp, struct dp_meter *meter)
> > +static struct dp_meter_instance *dp_meter_instance_alloc(const u32 size)
> > +{
> > +       struct dp_meter_instance *ti;
> > +
> > +       ti = kvzalloc(sizeof(*ti) +
> > +                     sizeof(struct dp_meter *) * size,
> > +                     GFP_KERNEL);
> > +       if (!ti)
> > +               return NULL;
> Given this is a kernel space array we need to have hard limit inplace.
In patch 2, I limited the meter number, should we add hard limit here ?
> > +
> > +       ti->n_meters = size;
> > +
> > +       return ti;
> > +}
> > +
> > +static void dp_meter_instance_free(struct dp_meter_instance *ti)
> > +{
> > +       kvfree(ti);
> > +}
> > +
> > +static void dp_meter_instance_free_rcu(struct rcu_head *rcu)
> > +{
> > +       struct dp_meter_instance *ti;
> > +
> > +       ti = container_of(rcu, struct dp_meter_instance, rcu);
> > +       kvfree(ti);
> > +}
> > +
> > +static int
> > +dp_meter_instance_realloc(struct dp_meter_table *tbl, u32 size)
> > +{
> > +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> > +       int n_meters = min(size, ti->n_meters);
> > +       struct dp_meter_instance *new_ti;
> > +       int i;
> > +
> > +       new_ti = dp_meter_instance_alloc(size);
> > +       if (!new_ti)
> > +               return -ENOMEM;
> > +
> > +       for (i = 0; i < n_meters; i++)
> > +               new_ti->dp_meters[i] =
> > +                       rcu_dereference_ovsl(ti->dp_meters[i]);
> > +
> > +       rcu_assign_pointer(tbl->ti, new_ti);
> > +       call_rcu(&ti->rcu, dp_meter_instance_free_rcu);
> > +
> > +       return 0;
> > +}
> > +
> > +static void dp_meter_instance_insert(struct dp_meter_instance *ti,
> > +                                    struct dp_meter *meter)
> > +{
> > +       u32 hash;
> > +
> > +       hash = meter_hash(ti, meter->id);
> > +       rcu_assign_pointer(ti->dp_meters[hash], meter);
> > +}
> > +
> > +static void dp_meter_instance_remove(struct dp_meter_instance *ti,
> > +                                    struct dp_meter *meter)
> >  {
> > -       struct hlist_head *head = meter_hash_bucket(dp, meter->id);
> > +       u32 hash;
> >
> > -       hlist_add_head_rcu(&meter->dp_hash_node, head);
> > +       hash = meter_hash(ti, meter->id);
> > +       RCU_INIT_POINTER(ti->dp_meters[hash], NULL);
> >  }
> >
> > -static void detach_meter(struct dp_meter *meter)
> > +static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
> >  {
> > +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> > +       u32 hash = meter_hash(ti, meter->id);
> > +
> > +       /*
> > +        * In generally, slot selected should be empty, because
> > +        * OvS uses id-pool to fetch a available id.
> > +        */
> > +       if (unlikely(rcu_dereference_ovsl(ti->dp_meters[hash])))
> > +               return -EINVAL;
> we could return -EBUSY instead.
> > +
> > +       dp_meter_instance_insert(ti, meter);
> > +
> > +       /* That function is thread-safe. */
> > +       if (++tbl->count >= ti->n_meters)
> > +               if (dp_meter_instance_realloc(tbl, ti->n_meters * 2))
> > +                       goto expand_err;
> > +
> > +       return 0;
> > +
> > +expand_err:
> > +       dp_meter_instance_remove(ti, meter);
> > +       tbl->count--;
> > +       return -ENOMEM;
> > +}
> > +
> > +static void detach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
> > +{
> > +       struct dp_meter_instance *ti;
> > +
> >         ASSERT_OVSL();
> > -       if (meter)
> > -               hlist_del_rcu(&meter->dp_hash_node);
> > +       if (!meter)
> > +               return;
> > +
> > +       ti = rcu_dereference_ovsl(tbl->ti);
> > +       dp_meter_instance_remove(ti, meter);
> > +
> > +       tbl->count--;
> > +
> > +       /* Shrink the meter array if necessary. */
> > +       if (ti->n_meters > DP_METER_ARRAY_SIZE_MIN &&
> > +           tbl->count <= (ti->n_meters / 4)) {
> > +               int half_size = ti->n_meters / 2;
> > +               int i;
> > +
> Lets add a comment about this.
> > +               for (i = half_size; i < ti->n_meters; i++)
> > +                       if (rcu_dereference_ovsl(ti->dp_meters[i]))
> > +                               return;
> > +
> > +               dp_meter_instance_realloc(tbl, half_size);
> > +       }
> >  }
> >
> >  static struct sk_buff *
> > @@ -303,9 +407,13 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
> >         meter_id = nla_get_u32(a[OVS_METER_ATTR_ID]);
> >
> >         /* Cannot fail after this. */
> > -       old_meter = lookup_meter(dp, meter_id);
> > -       detach_meter(old_meter);
> > -       attach_meter(dp, meter);
> > +       old_meter = lookup_meter(dp->meters, meter_id);
> in new scheme this can fail due to hash collision, lets check for NULL.
If old_meter is NULL, detach_meter will do nothing.
> > +       detach_meter(dp->meters, old_meter);
> > +
> > +       err = attach_meter(dp->meters, meter);
> > +       if (err)
> > +               goto exit_unlock;
> > +
> >         ovs_unlock();
> >
> >         /* Build response with the meter_id and stats from
> > @@ -365,7 +473,7 @@ static int ovs_meter_cmd_get(struct sk_buff *skb, struct genl_info *info)
> >         }
> >
> >         /* Locate meter, copy stats. */
> > -       meter = lookup_meter(dp, meter_id);
> > +       meter = lookup_meter(dp->meters, meter_id);
> >         if (!meter) {
> >                 err = -ENOENT;
> >                 goto exit_unlock;
> > @@ -416,13 +524,13 @@ static int ovs_meter_cmd_del(struct sk_buff *skb, struct genl_info *info)
> >                 goto exit_unlock;
> >         }
> >
> > -       old_meter = lookup_meter(dp, meter_id);
> > +       old_meter = lookup_meter(dp->meters, meter_id);
> >         if (old_meter) {
> >                 spin_lock_bh(&old_meter->lock);
> >                 err = ovs_meter_cmd_reply_stats(reply, meter_id, old_meter);
> >                 WARN_ON(err);
> >                 spin_unlock_bh(&old_meter->lock);
> > -               detach_meter(old_meter);
> > +               detach_meter(dp->meters, old_meter);
> >         }
> >         ovs_unlock();
> >         ovs_meter_free(old_meter);
> > @@ -452,7 +560,7 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
> >         int i, band_exceeded_max = -1;
> >         u32 band_exceeded_rate = 0;
> >
> > -       meter = lookup_meter(dp, meter_id);
> > +       meter = lookup_meter(dp->meters, meter_id);
> >         /* Do not drop the packet when there is no meter. */
> >         if (!meter)
> >                 return false;
> > @@ -570,32 +678,36 @@ struct genl_family dp_meter_genl_family __ro_after_init = {
> >
> >  int ovs_meters_init(struct datapath *dp)
> >  {
> > -       int i;
> > +       struct dp_meter_instance *ti;
> > +       struct dp_meter_table *tbl;
> > +
> > +       tbl = kmalloc(sizeof(*tbl), GFP_KERNEL);
> > +       if (!tbl)
> > +               return -ENOMEM;
> >
> > -       dp->meters = kmalloc_array(METER_HASH_BUCKETS,
> > -                                  sizeof(struct hlist_head), GFP_KERNEL);
> > +       tbl->count = 0;
> >
> > -       if (!dp->meters)
> > +       ti = dp_meter_instance_alloc(DP_METER_ARRAY_SIZE_MIN);
> > +       if (!ti) {
> > +               kfree(tbl);
> >                 return -ENOMEM;
> > +       }
> >
> > -       for (i = 0; i < METER_HASH_BUCKETS; i++)
> > -               INIT_HLIST_HEAD(&dp->meters[i]);
> > +       rcu_assign_pointer(tbl->ti, ti);
> > +       dp->meters = tbl;
> >
> >         return 0;
> >  }
> >
> >  void ovs_meters_exit(struct datapath *dp)
> >  {
> > +       struct dp_meter_table *tbl = dp->meters;
> > +       struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> >         int i;
> >
> > -       for (i = 0; i < METER_HASH_BUCKETS; i++) {
> > -               struct hlist_head *head = &dp->meters[i];
> > -               struct dp_meter *meter;
> > -               struct hlist_node *n;
> > -
> > -               hlist_for_each_entry_safe(meter, n, head, dp_hash_node)
> > -                       kfree(meter);
> > -       }
> > +       for (i = 0; i < ti->n_meters; i++)
> > +               ovs_meter_free(ti->dp_meters[i]);
> >
> > -       kfree(dp->meters);
> > +       dp_meter_instance_free(ti);
> > +       kfree(tbl);
> >  }
> > diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
> > index f645913870bd..d91940383bbe 100644
> > --- a/net/openvswitch/meter.h
> > +++ b/net/openvswitch/meter.h
> > @@ -18,6 +18,7 @@
> >  struct datapath;
> >
> >  #define DP_MAX_BANDS           1
> > +#define DP_METER_ARRAY_SIZE_MIN        (1ULL << 10)
> >
> >  struct dp_meter_band {
> >         u32 type;
> > @@ -30,9 +31,6 @@ struct dp_meter_band {
> >  struct dp_meter {
> >         spinlock_t lock;    /* Per meter lock */
> >         struct rcu_head rcu;
> > -       struct hlist_node dp_hash_node; /*Element in datapath->meters
> > -                                        * hash table.
> > -                                        */
> >         u32 id;
> >         u16 kbps:1, keep_stats:1;
> >         u16 n_bands;
> > @@ -42,6 +40,17 @@ struct dp_meter {
> >         struct dp_meter_band bands[];
> >  };
> >
> > +struct dp_meter_instance {
> > +       struct rcu_head rcu;
> > +       u32 n_meters;
> > +       struct dp_meter __rcu *dp_meters[];
> > +};
> > +
> > +struct dp_meter_table {
> > +       struct dp_meter_instance __rcu *ti;
> > +       u32 count;
> > +};
> > +
> >  extern struct genl_family dp_meter_genl_family;
> >  int ovs_meters_init(struct datapath *dp);
> >  void ovs_meters_exit(struct datapath *dp);
> > --
> > 2.23.0
> >



-- 
Best regards, Tonghao
