Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD1E137099
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgAJPEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:04:00 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34393 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbgAJPD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:03:59 -0500
Received: by mail-qt1-f196.google.com with SMTP id 5so2171655qtz.1;
        Fri, 10 Jan 2020 07:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lPwriYPpmU7vTBtppMavx7sT+x5VSWjpmuZxvXXCnKQ=;
        b=nhMgq8wecsXKtiA5/JyeKmp4/i56C8MciqPhLrUM/3fN6GQdJLLTUQwX1eXmjHDr6W
         QCXj1CgjIAjVmYtaY3yV3P3cY3C3BvDWEOLMvqJS6X+K6ClyTj/7rkMTbSaimFZsPJcA
         KDpZ56oN9oRERUj1QSWr+Xt0g/m6xY2gdxZN0SesRW9c8lNAEGE09lR4dSd85SSQYQtV
         7AEmmAehrUo7y+n1dR+8MBKe66hVQI2GhND7y77FbAhzEIfdOaHNI6fN+ODLHX8Tt9Tx
         qItgJYMqDKTNQ04eyy5TMXVWbTj1olRCqs7P0W9+QQXQFk6gAG/k+xb8NJ8Tw1qzEerV
         ou2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lPwriYPpmU7vTBtppMavx7sT+x5VSWjpmuZxvXXCnKQ=;
        b=hJ5DqQjiQAfIwf46SncoMgw+Vu/U8meKdiBH7/WVuvoJZ4EKppR81Z/g5F2H8wI8eb
         9T+9hJIvWGkzH4Tfm/rwq/7frctTMgA1AUmUo6wl+S39MeFTEG4FEEYK6EAC/zbpyytM
         6+niYcReuM0cZT0yGwX7aLstketoIEjHPCybJeBmD/hr4UzLcQrjGi6pJKQRPdpSNxPf
         p+Nr901tFFyYtm2ot4aWj8SQdYEbYCcCouGIoIab9UKB1D3L04JFktEQg/wC9wUyUk9w
         N9qX8RxZKRrJDXhdm9XNtX6giGybI16pWVvJI6se1kQjOMUCdNYXmjNIyqkA3VCDgiN2
         Vm0g==
X-Gm-Message-State: APjAAAXL8PIxJTIT/IL2S+ihBnLKP2+Ibt/lZ8GECAW+pGzmdmax2uOn
        uVjig024uJnlkYYuQ58jvbLB57t4ard6faD1Nfs=
X-Google-Smtp-Source: APXvYqxSTZTCVrDCTz/VA1e2oRKnHJ8Dunm/AOlYmFKG3BMI35MXijjpH7dscBqiufb1d3yLRo90GX2OPLAGYjBQFWg=
X-Received: by 2002:ac8:33a5:: with SMTP id c34mr2779846qtb.359.1578668638333;
 Fri, 10 Jan 2020 07:03:58 -0800 (PST)
MIME-Version: 1.0
References: <157866612174.432695.5077671447287539053.stgit@toke.dk> <157866612285.432695.6722430952732620313.stgit@toke.dk>
In-Reply-To: <157866612285.432695.6722430952732620313.stgit@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 10 Jan 2020 16:03:47 +0100
Message-ID: <CAJ+HfNgkouU8=T2+Of1nAfwBQ-eqCKKAqrNzhhEafw5qW8bO_w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] xdp: Move devmap bulk queue into struct net_device
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 at 15:22, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Commit 96360004b862 ("xdp: Make devmap flush_list common for all map
> instances"), changed devmap flushing to be a global operation instead of =
a
> per-map operation. However, the queue structure used for bulking was stil=
l
> allocated as part of the containing map.
>
> This patch moves the devmap bulk queue into struct net_device. The
> motivation for this is reusing it for the non-map variant of XDP_REDIRECT=
,
> which will be changed in a subsequent commit.
>
> We defer the actual allocation of the bulk queue structure until the
> NETDEV_REGISTER notification devmap.c. This makes it possible to check fo=
r
> ndo_xdp_xmit support before allocating the structure, which is not possib=
le
> at the time struct net_device is allocated. However, we keep the freeing =
in
> free_netdev() to avoid adding another RCU callback on NETDEV_UNREGISTER.
>
> Because of this change, we lose the reference back to the map that
> originated the redirect, so change the tracepoint to always return 0 as t=
he
> map ID and index. Otherwise no functional change is intended with this
> patch.
>

Nice work, Toke!

I'm getting some checkpatch warnings (>80 char lines), other than that:

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  include/linux/netdevice.h  |    3 ++
>  include/trace/events/xdp.h |    2 +
>  kernel/bpf/devmap.c        |   61 ++++++++++++++++++--------------------=
------
>  net/core/dev.c             |    2 +
>  4 files changed, 31 insertions(+), 37 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 2741aa35bec6..1b2bc2a7522e 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -876,6 +876,7 @@ enum bpf_netdev_command {
>  struct bpf_prog_offload_ops;
>  struct netlink_ext_ack;
>  struct xdp_umem;
> +struct xdp_dev_bulk_queue;
>
>  struct netdev_bpf {
>         enum bpf_netdev_command command;
> @@ -1993,6 +1994,8 @@ struct net_device {
>         spinlock_t              tx_global_lock;
>         int                     watchdog_timeo;
>
> +       struct xdp_dev_bulk_queue __percpu *xdp_bulkq;
> +
>  #ifdef CONFIG_XPS
>         struct xps_dev_maps __rcu *xps_cpus_map;
>         struct xps_dev_maps __rcu *xps_rxqs_map;
> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
> index a7378bcd9928..72bad13d4a3c 100644
> --- a/include/trace/events/xdp.h
> +++ b/include/trace/events/xdp.h
> @@ -278,7 +278,7 @@ TRACE_EVENT(xdp_devmap_xmit,
>         ),
>
>         TP_fast_assign(
> -               __entry->map_id         =3D map->id;
> +               __entry->map_id         =3D map ? map->id : 0;
>                 __entry->act            =3D XDP_REDIRECT;
>                 __entry->map_index      =3D map_index;
>                 __entry->drops          =3D drops;
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index da9c832fc5c8..bcb05cb6b728 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -53,13 +53,11 @@
>         (BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
>
>  #define DEV_MAP_BULK_SIZE 16
> -struct bpf_dtab_netdev;
> -
> -struct xdp_bulk_queue {
> +struct xdp_dev_bulk_queue {
>         struct xdp_frame *q[DEV_MAP_BULK_SIZE];
>         struct list_head flush_node;
> +       struct net_device *dev;
>         struct net_device *dev_rx;
> -       struct bpf_dtab_netdev *obj;
>         unsigned int count;
>  };
>
> @@ -67,9 +65,8 @@ struct bpf_dtab_netdev {
>         struct net_device *dev; /* must be first member, due to tracepoin=
t */
>         struct hlist_node index_hlist;
>         struct bpf_dtab *dtab;
> -       struct xdp_bulk_queue __percpu *bulkq;
>         struct rcu_head rcu;
> -       unsigned int idx; /* keep track of map index for tracepoint */
> +       unsigned int idx;
>  };
>
>  struct bpf_dtab {
> @@ -219,7 +216,6 @@ static void dev_map_free(struct bpf_map *map)
>
>                         hlist_for_each_entry_safe(dev, next, head, index_=
hlist) {
>                                 hlist_del_rcu(&dev->index_hlist);
> -                               free_percpu(dev->bulkq);
>                                 dev_put(dev->dev);
>                                 kfree(dev);
>                         }
> @@ -234,7 +230,6 @@ static void dev_map_free(struct bpf_map *map)
>                         if (!dev)
>                                 continue;
>
> -                       free_percpu(dev->bulkq);
>                         dev_put(dev->dev);
>                         kfree(dev);
>                 }
> @@ -320,10 +315,9 @@ static int dev_map_hash_get_next_key(struct bpf_map =
*map, void *key,
>         return -ENOENT;
>  }
>
> -static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags)
> +static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>  {
> -       struct bpf_dtab_netdev *obj =3D bq->obj;
> -       struct net_device *dev =3D obj->dev;
> +       struct net_device *dev =3D bq->dev;
>         int sent =3D 0, drops =3D 0, err =3D 0;
>         int i;
>
> @@ -346,8 +340,7 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, u32=
 flags)
>  out:
>         bq->count =3D 0;
>
> -       trace_xdp_devmap_xmit(&obj->dtab->map, obj->idx,
> -                             sent, drops, bq->dev_rx, dev, err);
> +       trace_xdp_devmap_xmit(NULL, 0, sent, drops, bq->dev_rx, dev, err)=
;
>         bq->dev_rx =3D NULL;
>         __list_del_clearprev(&bq->flush_node);
>         return 0;
> @@ -374,7 +367,7 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, u32=
 flags)
>  void __dev_map_flush(void)
>  {
>         struct list_head *flush_list =3D this_cpu_ptr(&dev_map_flush_list=
);
> -       struct xdp_bulk_queue *bq, *tmp;
> +       struct xdp_dev_bulk_queue *bq, *tmp;
>
>         rcu_read_lock();
>         list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
> @@ -401,12 +394,12 @@ struct bpf_dtab_netdev *__dev_map_lookup_elem(struc=
t bpf_map *map, u32 key)
>  /* Runs under RCU-read-side, plus in softirq under NAPI protection.
>   * Thus, safe percpu variable access.
>   */
> -static int bq_enqueue(struct bpf_dtab_netdev *obj, struct xdp_frame *xdp=
f,
> +static int bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
>                       struct net_device *dev_rx)
>
>  {
>         struct list_head *flush_list =3D this_cpu_ptr(&dev_map_flush_list=
);
> -       struct xdp_bulk_queue *bq =3D this_cpu_ptr(obj->bulkq);
> +       struct xdp_dev_bulk_queue *bq =3D this_cpu_ptr(dev->xdp_bulkq);
>
>         if (unlikely(bq->count =3D=3D DEV_MAP_BULK_SIZE))
>                 bq_xmit_all(bq, 0);
> @@ -444,7 +437,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, stru=
ct xdp_buff *xdp,
>         if (unlikely(!xdpf))
>                 return -EOVERFLOW;
>
> -       return bq_enqueue(dst, xdpf, dev_rx);
> +       return bq_enqueue(dev, xdpf, dev_rx);
>  }
>
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff=
 *skb,
> @@ -483,7 +476,6 @@ static void __dev_map_entry_free(struct rcu_head *rcu=
)
>         struct bpf_dtab_netdev *dev;
>
>         dev =3D container_of(rcu, struct bpf_dtab_netdev, rcu);
> -       free_percpu(dev->bulkq);
>         dev_put(dev->dev);
>         kfree(dev);
>  }
> @@ -538,30 +530,14 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node=
(struct net *net,
>                                                     u32 ifindex,
>                                                     unsigned int idx)
>  {
> -       gfp_t gfp =3D GFP_ATOMIC | __GFP_NOWARN;
>         struct bpf_dtab_netdev *dev;
> -       struct xdp_bulk_queue *bq;
> -       int cpu;
>
> -       dev =3D kmalloc_node(sizeof(*dev), gfp, dtab->map.numa_node);
> +       dev =3D kmalloc_node(sizeof(*dev), GFP_ATOMIC | __GFP_NOWARN, dta=
b->map.numa_node);
>         if (!dev)
>                 return ERR_PTR(-ENOMEM);
>
> -       dev->bulkq =3D __alloc_percpu_gfp(sizeof(*dev->bulkq),
> -                                       sizeof(void *), gfp);
> -       if (!dev->bulkq) {
> -               kfree(dev);
> -               return ERR_PTR(-ENOMEM);
> -       }
> -
> -       for_each_possible_cpu(cpu) {
> -               bq =3D per_cpu_ptr(dev->bulkq, cpu);
> -               bq->obj =3D dev;
> -       }
> -
>         dev->dev =3D dev_get_by_index(net, ifindex);
>         if (!dev->dev) {
> -               free_percpu(dev->bulkq);
>                 kfree(dev);
>                 return ERR_PTR(-EINVAL);
>         }
> @@ -721,9 +697,22 @@ static int dev_map_notification(struct notifier_bloc=
k *notifier,
>  {
>         struct net_device *netdev =3D netdev_notifier_info_to_dev(ptr);
>         struct bpf_dtab *dtab;
> -       int i;
> +       int i, cpu;
>
>         switch (event) {
> +       case NETDEV_REGISTER:
> +               if (!netdev->netdev_ops->ndo_xdp_xmit || netdev->xdp_bulk=
q)
> +                       break;
> +
> +               /* will be freed in free_netdev() */
> +               netdev->xdp_bulkq =3D __alloc_percpu_gfp(sizeof(struct xd=
p_dev_bulk_queue),
> +                                                      sizeof(void *), GF=
P_ATOMIC);
> +               if (!netdev->xdp_bulkq)
> +                       return NOTIFY_BAD;
> +
> +               for_each_possible_cpu(cpu)
> +                       per_cpu_ptr(netdev->xdp_bulkq, cpu)->dev =3D netd=
ev;
> +               break;
>         case NETDEV_UNREGISTER:
>                 /* This rcu_read_lock/unlock pair is needed because
>                  * dev_map_list is an RCU list AND to ensure a delete
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d99f88c58636..e7802a41ae7f 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9847,6 +9847,8 @@ void free_netdev(struct net_device *dev)
>
>         free_percpu(dev->pcpu_refcnt);
>         dev->pcpu_refcnt =3D NULL;
> +       free_percpu(dev->xdp_bulkq);
> +       dev->xdp_bulkq =3D NULL;
>
>         netdev_unregister_lockdep_key(dev);
>
>
