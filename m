Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826DB4A3FD9
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 11:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348217AbiAaKFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 05:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234438AbiAaKFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 05:05:38 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F1BC061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 02:05:37 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id k31so38782056ybj.4
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 02:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=hOMOzNixqICDNet9/KL8pzwoUyO+mOdTQiQJS8OS1yc=;
        b=MMfqwsKjHlc2ztgPFPt4oga15g5fzjIKnkN+ublKQwLn80ddEzKcGahKo0ZY6KZbxg
         NFzY7UA9UWzlSVoJ9pDKfsINE60xymfBXY37TvTdnSkxKONctY8H9dlwiXIzOv6NsBM+
         +auQEZunsVW1RhZpblhJzrY6+XiHyU0UN0W3VmhMQ2wv33ubq+Xzl+aD8fASS50VLU50
         YPvLths6FDGtn/eukBD2UguhP9kkeH1kkDkcPs0kcRNinl4DfciZI9guA18zk6lWVqvq
         fTPvHPSpPE50/NBiTl49S0E+uy7UsIz30l9o9irRVIZVYyqKSXcTeHwd0XUoTmy2PmKA
         gNUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=hOMOzNixqICDNet9/KL8pzwoUyO+mOdTQiQJS8OS1yc=;
        b=5NM1llpmf6VjZHXOtD08Mx4bTBa8HNrwvFVkWwGcB/+G9/EEvNzzlXkhNTch2Hx9TX
         F57+0Owo61KDqrmYvaSngPSlDMQc21m/P22Gun6jeqEBwgDMZF6MWCUix7FrEiwJuqoY
         bWR7DK0hWEY7QSDnW2K+ULDbS8qBgiK/HIB2DbfmcmuTG+1X2S+VAa3vDCo99IRbgfdu
         pQfv4xuheQ/t+JyknOjRviVS36WvyhHaLdl/37n2e/eroD4GbzykcDg3OhCi1gAtmnx3
         qGHQD2yfdLUNm1tR9xQh8m0RLYuS7YxeUdL6qySpdtLR1qsZ4dhzLmLxbxhuYXWayb/+
         uScw==
X-Gm-Message-State: AOAM531zwko99xrTV8kadposJo9ofj3lydL9HmkS3r/PPm7R9pdr3tzv
        C6TZ106cGDxTcc10KT26jBV6AInmjTqUQ9ce2w/YV2SnqkoE48P2
X-Google-Smtp-Source: ABdhPJyqBfQSiTJoZ2j6hxMt9QvvUdl+ByiXfRUHsqPQoskdqHO9pSOB1OREvDUVBV3og9LQ9IvyJIBKPpuvHmRPne0=
X-Received: by 2002:a25:3786:: with SMTP id e128mr29111395yba.706.1643623536564;
 Mon, 31 Jan 2022 02:05:36 -0800 (PST)
MIME-Version: 1.0
References: <20220131090307.2654-1-claudiajkang@gmail.com>
In-Reply-To: <20220131090307.2654-1-claudiajkang@gmail.com>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Mon, 31 Jan 2022 19:05:00 +0900
Message-ID: <CAK+SQuT2d=f2raV4w5-WViapZCtyPOuW1K7p78t1-qgJ3k8JZg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: hsr: use hlist_head instead of list_head
 for mac addresses
To:     davem@davemloft.net, kuba@kernel.org,
        Networking <netdev@vger.kernel.org>, arvid.brodin@alten.se
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are new build warnings in net/hsr/hsr_framereg.c.
I'll fix it and send v2 soon.

Thank you.

Best regards
Juhee

2022=EB=85=84 1=EC=9B=94 31=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 6:03, J=
uhee Kang <claudiajkang@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Currently, HSR manages mac addresses of known HSR nodes by using list_hea=
d.
> It takes a lot of time when there are a lot of registered nodes due to
> finding specific mac address nodes by using linear search. We can be
> reducing the time by using hlist. Thus, this patch moves list_head to
> hlist_head for mac addresses and this allows for further improvement of
> network performance.
>
>     Condition: registered 10,000 known HSR nodes
>     Before:
>     # iperf3 -c 192.168.10.1 -i 1 -t 10
>     Connecting to host 192.168.10.1, port 5201
>     [  5] local 192.168.10.2 port 59442 connected to 192.168.10.1 port 52=
01
>     [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
>     [  5]   0.00-1.49   sec  3.75 MBytes  21.1 Mbits/sec    0    158 KByt=
es
>     [  5]   1.49-2.05   sec  1.25 MBytes  18.7 Mbits/sec    0    166 KByt=
es
>     [  5]   2.05-3.06   sec  2.44 MBytes  20.3 Mbits/sec   56   16.9 KByt=
es
>     [  5]   3.06-4.08   sec  1.43 MBytes  11.7 Mbits/sec   11   38.0 KByt=
es
>     [  5]   4.08-5.00   sec   951 KBytes  8.49 Mbits/sec    0   56.3 KByt=
es
>
>     After:
>     # iperf3 -c 192.168.10.1 -i 1 -t 10
>     Connecting to host 192.168.10.1, port 5201
>     [  5] local 192.168.10.2 port 41756 connected to 192.168.10.1 port 52=
01
>     [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
>     [  5]   0.00-1.16   sec  8.75 MBytes  63.2 Mbits/sec    4   95.8 KByt=
es
>     [  5]   1.16-2.17   sec  7.50 MBytes  62.3 Mbits/sec   13   78.9 KByt=
es
>     [  5]   2.17-3.03   sec  7.50 MBytes  73.2 Mbits/sec    0    125 KByt=
es
>     [  5]   3.03-4.14   sec  7.93 MBytes  60.1 Mbits/sec   35   69.0 KByt=
es
>     [  5]   4.14-5.00   sec  6.25 MBytes  60.8 Mbits/sec   18   19.7 KByt=
es
>     [  5]   5.00-6.17   sec  7.93 MBytes  57.0 Mbits/sec   14    161 KByt=
es
>
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> ---
>  net/hsr/hsr_debugfs.c  |  39 +++++----
>  net/hsr/hsr_device.c   |  10 ++-
>  net/hsr/hsr_forward.c  |   7 +-
>  net/hsr/hsr_framereg.c | 190 ++++++++++++++++++++++++-----------------
>  net/hsr/hsr_framereg.h |   7 +-
>  net/hsr/hsr_main.h     |   9 +-
>  net/hsr/hsr_netlink.c  |   4 +-
>  7 files changed, 162 insertions(+), 104 deletions(-)
>
> diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
> index 99f3af1a9d4d..4d50e9b3055d 100644
> --- a/net/hsr/hsr_debugfs.c
> +++ b/net/hsr/hsr_debugfs.c
> @@ -17,6 +17,7 @@
>  #include <linux/module.h>
>  #include <linux/errno.h>
>  #include <linux/debugfs.h>
> +#include <linux/jhash.h>
>  #include "hsr_main.h"
>  #include "hsr_framereg.h"
>
> @@ -28,6 +29,7 @@ hsr_node_table_show(struct seq_file *sfp, void *data)
>  {
>         struct hsr_priv *priv =3D (struct hsr_priv *)sfp->private;
>         struct hsr_node *node;
> +       int i;
>
>         seq_printf(sfp, "Node Table entries for (%s) device\n",
>                    (priv->prot_version =3D=3D PRP_V1 ? "PRP" : "HSR"));
> @@ -39,22 +41,27 @@ hsr_node_table_show(struct seq_file *sfp, void *data)
>                 seq_puts(sfp, "DAN-H\n");
>
>         rcu_read_lock();
> -       list_for_each_entry_rcu(node, &priv->node_db, mac_list) {
> -               /* skip self node */
> -               if (hsr_addr_is_self(priv, node->macaddress_A))
> -                       continue;
> -               seq_printf(sfp, "%pM ", &node->macaddress_A[0]);
> -               seq_printf(sfp, "%pM ", &node->macaddress_B[0]);
> -               seq_printf(sfp, "%10lx, ", node->time_in[HSR_PT_SLAVE_A])=
;
> -               seq_printf(sfp, "%10lx, ", node->time_in[HSR_PT_SLAVE_B])=
;
> -               seq_printf(sfp, "%14x, ", node->addr_B_port);
> -
> -               if (priv->prot_version =3D=3D PRP_V1)
> -                       seq_printf(sfp, "%5x, %5x, %5x\n",
> -                                  node->san_a, node->san_b,
> -                                  (node->san_a =3D=3D 0 && node->san_b =
=3D=3D 0));
> -               else
> -                       seq_printf(sfp, "%5x\n", 1);
> +
> +       for (i =3D 0 ; i < priv->hash_buckets; i++) {
> +               hlist_for_each_entry_rcu(node, &priv->node_db[i], mac_lis=
t) {
> +                       /* skip self node */
> +                       if (hsr_addr_is_self(priv, node->macaddress_A))
> +                               continue;
> +                       seq_printf(sfp, "%pM ", &node->macaddress_A[0]);
> +                       seq_printf(sfp, "%pM ", &node->macaddress_B[0]);
> +                       seq_printf(sfp, "%10lx, ",
> +                                  node->time_in[HSR_PT_SLAVE_A]);
> +                       seq_printf(sfp, "%10lx, ",
> +                                  node->time_in[HSR_PT_SLAVE_B]);
> +                       seq_printf(sfp, "%14x, ", node->addr_B_port);
> +
> +                       if (priv->prot_version =3D=3D PRP_V1)
> +                               seq_printf(sfp, "%5x, %5x, %5x\n",
> +                                          node->san_a, node->san_b,
> +                                       (node->san_a =3D=3D 0 && node->sa=
n_b =3D=3D 0));
> +                       else
> +                               seq_printf(sfp, "%5x\n", 1);
> +               }
>         }
>         rcu_read_unlock();
>         return 0;
> diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> index e57fdad9ef94..7f250216433d 100644
> --- a/net/hsr/hsr_device.c
> +++ b/net/hsr/hsr_device.c
> @@ -485,12 +485,16 @@ int hsr_dev_finalize(struct net_device *hsr_dev, st=
ruct net_device *slave[2],
>  {
>         bool unregister =3D false;
>         struct hsr_priv *hsr;
> -       int res;
> +       int res, i;
>
>         hsr =3D netdev_priv(hsr_dev);
>         INIT_LIST_HEAD(&hsr->ports);
> -       INIT_LIST_HEAD(&hsr->node_db);
> -       INIT_LIST_HEAD(&hsr->self_node_db);
> +       INIT_HLIST_HEAD(&hsr->self_node_db);
> +       hsr->hash_buckets =3D HSR_HSIZE;
> +       get_random_bytes(&hsr->hash_seed, sizeof(hsr->hash_seed));
> +       for (i =3D 0; i < hsr->hash_buckets; i++)
> +               INIT_HLIST_HEAD(&hsr->node_db[i]);
> +
>         spin_lock_init(&hsr->list_lock);
>
>         eth_hw_addr_set(hsr_dev, slave[0]->dev_addr);
> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> index e59cbb4f0cd1..5bf357734b11 100644
> --- a/net/hsr/hsr_forward.c
> +++ b/net/hsr/hsr_forward.c
> @@ -570,20 +570,23 @@ static int fill_frame_info(struct hsr_frame_info *f=
rame,
>         struct ethhdr *ethhdr;
>         __be16 proto;
>         int ret;
> +       u32 hash;
>
>         /* Check if skb contains ethhdr */
>         if (skb->mac_len < sizeof(struct ethhdr))
>                 return -EINVAL;
>
>         memset(frame, 0, sizeof(*frame));
> +
> +       ethhdr =3D (struct ethhdr *)skb_mac_header(skb);
> +       hash =3D hsr_mac_hash(port->hsr, ethhdr->h_source);
>         frame->is_supervision =3D is_supervision_frame(port->hsr, skb);
> -       frame->node_src =3D hsr_get_node(port, &hsr->node_db, skb,
> +       frame->node_src =3D hsr_get_node(port, &hsr->node_db[hash], skb,
>                                        frame->is_supervision,
>                                        port->type);
>         if (!frame->node_src)
>                 return -1; /* Unknown node and !is_supervision, or no mem=
 */
>
> -       ethhdr =3D (struct ethhdr *)skb_mac_header(skb);
>         frame->is_vlan =3D false;
>         proto =3D ethhdr->h_proto;
>
> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> index 0775f0f95dbf..6960808edbf0 100644
> --- a/net/hsr/hsr_framereg.c
> +++ b/net/hsr/hsr_framereg.c
> @@ -15,11 +15,17 @@
>  #include <linux/etherdevice.h>
>  #include <linux/slab.h>
>  #include <linux/rculist.h>
> +#include <linux/jhash.h>
>  #include "hsr_main.h"
>  #include "hsr_framereg.h"
>  #include "hsr_netlink.h"
>
> -/*     TODO: use hash lists for mac addresses (linux/jhash.h)?    */
> +u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr)
> +{
> +       u32 hash =3D jhash(addr, ETH_ALEN, hsr->hash_seed);
> +
> +       return reciprocal_scale(hash, hsr->hash_buckets);
> +}
>
>  /* seq_nr_after(a, b) - return true if a is after (higher in sequence th=
an) b,
>   * false otherwise.
> @@ -42,8 +48,9 @@ bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned ch=
ar *addr)
>  {
>         struct hsr_node *node;
>
> -       node =3D list_first_or_null_rcu(&hsr->self_node_db, struct hsr_no=
de,
> -                                     mac_list);
> +       node =3D hlist_empty(&hsr->self_node_db) ? NULL :
> +               hlist_entry(hlist_first_rcu(&hsr->self_node_db),
> +                           struct hsr_node, mac_list);
>         if (!node) {
>                 WARN_ONCE(1, "HSR: No self node\n");
>                 return false;
> @@ -59,12 +66,12 @@ bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned =
char *addr)
>
>  /* Search for mac entry. Caller must hold rcu read lock.
>   */
> -static struct hsr_node *find_node_by_addr_A(struct list_head *node_db,
> +static struct hsr_node *find_node_by_addr_A(struct hlist_head *node_db,
>                                             const unsigned char addr[ETH_=
ALEN])
>  {
>         struct hsr_node *node;
>
> -       list_for_each_entry_rcu(node, node_db, mac_list) {
> +       hlist_for_each_entry_rcu(node, node_db, mac_list) {
>                 if (ether_addr_equal(node->macaddress_A, addr))
>                         return node;
>         }
> @@ -79,7 +86,7 @@ int hsr_create_self_node(struct hsr_priv *hsr,
>                          const unsigned char addr_a[ETH_ALEN],
>                          const unsigned char addr_b[ETH_ALEN])
>  {
> -       struct list_head *self_node_db =3D &hsr->self_node_db;
> +       struct hlist_head *self_node_db =3D &hsr->self_node_db;
>         struct hsr_node *node, *oldnode;
>
>         node =3D kmalloc(sizeof(*node), GFP_KERNEL);
> @@ -90,14 +97,15 @@ int hsr_create_self_node(struct hsr_priv *hsr,
>         ether_addr_copy(node->macaddress_B, addr_b);
>
>         spin_lock_bh(&hsr->list_lock);
> -       oldnode =3D list_first_or_null_rcu(self_node_db,
> -                                        struct hsr_node, mac_list);
> +       oldnode =3D hlist_empty(self_node_db) ? NULL :
> +                               hlist_entry(hlist_first_rcu(self_node_db)=
,
> +                                           struct hsr_node, mac_list);
>         if (oldnode) {
> -               list_replace_rcu(&oldnode->mac_list, &node->mac_list);
> +               hlist_replace_rcu(&oldnode->mac_list, &node->mac_list);
>                 spin_unlock_bh(&hsr->list_lock);
>                 kfree_rcu(oldnode, rcu_head);
>         } else {
> -               list_add_tail_rcu(&node->mac_list, self_node_db);
> +               hlist_add_tail_rcu(&node->mac_list, self_node_db);
>                 spin_unlock_bh(&hsr->list_lock);
>         }
>
> @@ -106,25 +114,27 @@ int hsr_create_self_node(struct hsr_priv *hsr,
>
>  void hsr_del_self_node(struct hsr_priv *hsr)
>  {
> -       struct list_head *self_node_db =3D &hsr->self_node_db;
> +       struct hlist_head *self_node_db =3D &hsr->self_node_db;
>         struct hsr_node *node;
>
>         spin_lock_bh(&hsr->list_lock);
> -       node =3D list_first_or_null_rcu(self_node_db, struct hsr_node, ma=
c_list);
> +       node =3D hlist_empty(self_node_db) ? NULL :
> +                       hlist_entry(hlist_first_rcu(self_node_db),
> +                                   struct hsr_node, mac_list);
>         if (node) {
> -               list_del_rcu(&node->mac_list);
> +               hlist_del_rcu(&node->mac_list);
>                 kfree_rcu(node, rcu_head);
>         }
>         spin_unlock_bh(&hsr->list_lock);
>  }
>
> -void hsr_del_nodes(struct list_head *node_db)
> +void hsr_del_nodes(struct hlist_head *node_db)
>  {
>         struct hsr_node *node;
> -       struct hsr_node *tmp;
> +       struct hlist_node *tmp;
>
> -       list_for_each_entry_safe(node, tmp, node_db, mac_list)
> -               kfree(node);
> +       hlist_for_each_entry_safe(node, tmp, node_db, mac_list)
> +               kfree_rcu(node, rcu_head);
>  }
>
>  void prp_handle_san_frame(bool san, enum hsr_port_type port,
> @@ -145,7 +155,7 @@ void prp_handle_san_frame(bool san, enum hsr_port_typ=
e port,
>   * originating from the newly added node.
>   */
>  static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
> -                                    struct list_head *node_db,
> +                                    struct hlist_head *node_db,
>                                      unsigned char addr[],
>                                      u16 seq_out, bool san,
>                                      enum hsr_port_type rx_port)
> @@ -175,14 +185,14 @@ static struct hsr_node *hsr_add_node(struct hsr_pri=
v *hsr,
>                 hsr->proto_ops->handle_san_frame(san, rx_port, new_node);
>
>         spin_lock_bh(&hsr->list_lock);
> -       list_for_each_entry_rcu(node, node_db, mac_list,
> +       hlist_for_each_entry_rcu(node, node_db, mac_list,
>                                 lockdep_is_held(&hsr->list_lock)) {
>                 if (ether_addr_equal(node->macaddress_A, addr))
>                         goto out;
>                 if (ether_addr_equal(node->macaddress_B, addr))
>                         goto out;
>         }
> -       list_add_tail_rcu(&new_node->mac_list, node_db);
> +       hlist_add_tail_rcu(&new_node->mac_list, node_db);
>         spin_unlock_bh(&hsr->list_lock);
>         return new_node;
>  out:
> @@ -202,7 +212,7 @@ void prp_update_san_info(struct hsr_node *node, bool =
is_sup)
>
>  /* Get the hsr_node from which 'skb' was sent.
>   */
> -struct hsr_node *hsr_get_node(struct hsr_port *port, struct list_head *n=
ode_db,
> +struct hsr_node *hsr_get_node(struct hsr_port *port, struct hlist_head *=
node_db,
>                               struct sk_buff *skb, bool is_sup,
>                               enum hsr_port_type rx_port)
>  {
> @@ -218,7 +228,7 @@ struct hsr_node *hsr_get_node(struct hsr_port *port, =
struct list_head *node_db,
>
>         ethhdr =3D (struct ethhdr *)skb_mac_header(skb);
>
> -       list_for_each_entry_rcu(node, node_db, mac_list) {
> +       hlist_for_each_entry_rcu(node, node_db, mac_list) {
>                 if (ether_addr_equal(node->macaddress_A, ethhdr->h_source=
)) {
>                         if (hsr->proto_ops->update_san_info)
>                                 hsr->proto_ops->update_san_info(node, is_=
sup);
> @@ -268,11 +278,12 @@ void hsr_handle_sup_frame(struct hsr_frame_info *fr=
ame)
>         struct hsr_sup_tlv *hsr_sup_tlv;
>         struct hsr_node *node_real;
>         struct sk_buff *skb =3D NULL;
> -       struct list_head *node_db;
> +       struct hlist_head *node_db;
>         struct ethhdr *ethhdr;
>         int i;
>         unsigned int pull_size =3D 0;
>         unsigned int total_pull_size =3D 0;
> +       u32 hash;
>
>         /* Here either frame->skb_hsr or frame->skb_prp should be
>          * valid as supervision frame always will have protocol
> @@ -310,11 +321,13 @@ void hsr_handle_sup_frame(struct hsr_frame_info *fr=
ame)
>         hsr_sp =3D (struct hsr_sup_payload *)skb->data;
>
>         /* Merge node_curr (registered on macaddress_B) into node_real */
> -       node_db =3D &port_rcv->hsr->node_db;
> -       node_real =3D find_node_by_addr_A(node_db, hsr_sp->macaddress_A);
> +       node_db =3D port_rcv->hsr->node_db;
> +       hash =3D hsr_mac_hash(hsr, hsr_sp->macaddress_A);
> +       node_real =3D find_node_by_addr_A(&node_db[hash], hsr_sp->macaddr=
ess_A);
>         if (!node_real)
>                 /* No frame received from AddrA of this node yet */
> -               node_real =3D hsr_add_node(hsr, node_db, hsr_sp->macaddre=
ss_A,
> +               node_real =3D hsr_add_node(hsr, &node_db[hash],
> +                                        hsr_sp->macaddress_A,
>                                          HSR_SEQNR_START - 1, true,
>                                          port_rcv->type);
>         if (!node_real)
> @@ -348,7 +361,8 @@ void hsr_handle_sup_frame(struct hsr_frame_info *fram=
e)
>                 hsr_sp =3D (struct hsr_sup_payload *)skb->data;
>
>                 /* Check if redbox mac and node mac are equal. */
> -               if (!ether_addr_equal(node_real->macaddress_A, hsr_sp->ma=
caddress_A)) {
> +               if (!ether_addr_equal(node_real->macaddress_A,
> +                                     hsr_sp->macaddress_A)) {
>                         /* This is a redbox supervision frame for a VDAN!=
 */
>                         goto done;
>                 }
> @@ -368,7 +382,7 @@ void hsr_handle_sup_frame(struct hsr_frame_info *fram=
e)
>         node_real->addr_B_port =3D port_rcv->type;
>
>         spin_lock_bh(&hsr->list_lock);
> -       list_del_rcu(&node_curr->mac_list);
> +       hlist_del_rcu(&node_curr->mac_list);
>         spin_unlock_bh(&hsr->list_lock);
>         kfree_rcu(node_curr, rcu_head);
>
> @@ -406,6 +420,7 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, s=
truct sk_buff *skb,
>                          struct hsr_port *port)
>  {
>         struct hsr_node *node_dst;
> +       u32 hash;
>
>         if (!skb_mac_header_was_set(skb)) {
>                 WARN_ONCE(1, "%s: Mac header not set\n", __func__);
> @@ -415,7 +430,8 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, s=
truct sk_buff *skb,
>         if (!is_unicast_ether_addr(eth_hdr(skb)->h_dest))
>                 return;
>
> -       node_dst =3D find_node_by_addr_A(&port->hsr->node_db,
> +       hash =3D hsr_mac_hash(port->hsr, eth_hdr(skb)->h_dest);
> +       node_dst =3D find_node_by_addr_A(&port->hsr->node_db[hash],
>                                        eth_hdr(skb)->h_dest);
>         if (!node_dst) {
>                 if (net_ratelimit())
> @@ -491,59 +507,72 @@ static struct hsr_port *get_late_port(struct hsr_pr=
iv *hsr,
>  void hsr_prune_nodes(struct timer_list *t)
>  {
>         struct hsr_priv *hsr =3D from_timer(hsr, t, prune_timer);
> +       struct hlist_node *tmp;
>         struct hsr_node *node;
> -       struct hsr_node *tmp;
>         struct hsr_port *port;
>         unsigned long timestamp;
>         unsigned long time_a, time_b;
> +       int i;
>
>         spin_lock_bh(&hsr->list_lock);
> -       list_for_each_entry_safe(node, tmp, &hsr->node_db, mac_list) {
> -               /* Don't prune own node. Neither time_in[HSR_PT_SLAVE_A]
> -                * nor time_in[HSR_PT_SLAVE_B], will ever be updated for
> -                * the master port. Thus the master node will be repeated=
ly
> -                * pruned leading to packet loss.
> -                */
> -               if (hsr_addr_is_self(hsr, node->macaddress_A))
> -                       continue;
> -
> -               /* Shorthand */
> -               time_a =3D node->time_in[HSR_PT_SLAVE_A];
> -               time_b =3D node->time_in[HSR_PT_SLAVE_B];
> -
> -               /* Check for timestamps old enough to risk wrap-around */
> -               if (time_after(jiffies, time_a + MAX_JIFFY_OFFSET / 2))
> -                       node->time_in_stale[HSR_PT_SLAVE_A] =3D true;
> -               if (time_after(jiffies, time_b + MAX_JIFFY_OFFSET / 2))
> -                       node->time_in_stale[HSR_PT_SLAVE_B] =3D true;
> -
> -               /* Get age of newest frame from node.
> -                * At least one time_in is OK here; nodes get pruned long
> -                * before both time_ins can get stale
> -                */
> -               timestamp =3D time_a;
> -               if (node->time_in_stale[HSR_PT_SLAVE_A] ||
> -                   (!node->time_in_stale[HSR_PT_SLAVE_B] &&
> -                   time_after(time_b, time_a)))
> -                       timestamp =3D time_b;
> -
> -               /* Warn of ring error only as long as we get frames at al=
l */
> -               if (time_is_after_jiffies(timestamp +
> -                               msecs_to_jiffies(1.5 * MAX_SLAVE_DIFF))) =
{
> -                       rcu_read_lock();
> -                       port =3D get_late_port(hsr, node);
> -                       if (port)
> -                               hsr_nl_ringerror(hsr, node->macaddress_A,=
 port);
> -                       rcu_read_unlock();
> -               }
>
> -               /* Prune old entries */
> -               if (time_is_before_jiffies(timestamp +
> +       for (i =3D 0; i < hsr->hash_buckets; i++) {
> +               hlist_for_each_entry_safe(node, tmp, &hsr->node_db[i],
> +                                         mac_list) {
> +                       /* Don't prune own node.
> +                        * Neither time_in[HSR_PT_SLAVE_A]
> +                        * nor time_in[HSR_PT_SLAVE_B], will ever be upda=
ted
> +                        * for the master port. Thus the master node will=
 be
> +                        * repeatedly pruned leading to packet loss.
> +                        */
> +                       if (hsr_addr_is_self(hsr, node->macaddress_A))
> +                               continue;
> +
> +                       /* Shorthand */
> +                       time_a =3D node->time_in[HSR_PT_SLAVE_A];
> +                       time_b =3D node->time_in[HSR_PT_SLAVE_B];
> +
> +                       /* Check for timestamps old enough to
> +                        * risk wrap-around
> +                        */
> +                       if (time_after(jiffies, time_a + MAX_JIFFY_OFFSET=
 / 2))
> +                               node->time_in_stale[HSR_PT_SLAVE_A] =3D t=
rue;
> +                       if (time_after(jiffies, time_b + MAX_JIFFY_OFFSET=
 / 2))
> +                               node->time_in_stale[HSR_PT_SLAVE_B] =3D t=
rue;
> +
> +                       /* Get age of newest frame from node.
> +                        * At least one time_in is OK here; nodes get pru=
ned
> +                        * long before both time_ins can get stale
> +                        */
> +                       timestamp =3D time_a;
> +                       if (node->time_in_stale[HSR_PT_SLAVE_A] ||
> +                           (!node->time_in_stale[HSR_PT_SLAVE_B] &&
> +                       time_after(time_b, time_a)))
> +                               timestamp =3D time_b;
> +
> +                       /* Warn of ring error only as long as we get
> +                        * frames at all
> +                        */
> +                       if (time_is_after_jiffies(timestamp +
> +                               msecs_to_jiffies(1.5 * MAX_SLAVE_DIFF))) =
{
> +                               rcu_read_lock();
> +                               port =3D get_late_port(hsr, node);
> +                               if (port)
> +                                       hsr_nl_ringerror(hsr,
> +                                                        node->macaddress=
_A, port);
> +                               rcu_read_unlock();
> +                       }
> +
> +                       /* Prune old entries */
> +                       if (time_is_before_jiffies(timestamp +
>                                 msecs_to_jiffies(HSR_NODE_FORGET_TIME))) =
{
> -                       hsr_nl_nodedown(hsr, node->macaddress_A);
> -                       list_del_rcu(&node->mac_list);
> -                       /* Note that we need to free this entry later: */
> -                       kfree_rcu(node, rcu_head);
> +                               hsr_nl_nodedown(hsr, node->macaddress_A);
> +                               hlist_del_rcu(&node->mac_list);
> +                               /* Note that we need to free this
> +                                * entry later:
> +                                */
> +                               kfree_rcu(node, rcu_head);
> +                       }
>                 }
>         }
>         spin_unlock_bh(&hsr->list_lock);
> @@ -557,9 +586,13 @@ void *hsr_get_next_node(struct hsr_priv *hsr, void *=
_pos,
>                         unsigned char addr[ETH_ALEN])
>  {
>         struct hsr_node *node;
> +       u32 hash;
> +
> +       hash =3D hsr_mac_hash(hsr, addr);
>
>         if (!_pos) {
> -               node =3D list_first_or_null_rcu(&hsr->node_db,
> +               node =3D hlist_empty(&hsr->node_db[hash]) ? NULL :
> +                       hlist_entry(hlist_first_rcu(&hsr->node_db[hash]),
>                                               struct hsr_node, mac_list);
>                 if (node)
>                         ether_addr_copy(addr, node->macaddress_A);
> @@ -567,7 +600,7 @@ void *hsr_get_next_node(struct hsr_priv *hsr, void *_=
pos,
>         }
>
>         node =3D _pos;
> -       list_for_each_entry_continue_rcu(node, &hsr->node_db, mac_list) {
> +       hlist_for_each_entry_continue_rcu(node, mac_list) {
>                 ether_addr_copy(addr, node->macaddress_A);
>                 return node;
>         }
> @@ -587,8 +620,11 @@ int hsr_get_node_data(struct hsr_priv *hsr,
>         struct hsr_node *node;
>         struct hsr_port *port;
>         unsigned long tdiff;
> +       u32 hash;
> +
> +       hash =3D hsr_mac_hash(hsr, addr);
>
> -       node =3D find_node_by_addr_A(&hsr->node_db, addr);
> +       node =3D find_node_by_addr_A(&hsr->node_db[hash], addr);
>         if (!node)
>                 return -ENOENT;
>
> diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
> index bdbb8c822ba1..d297873a3395 100644
> --- a/net/hsr/hsr_framereg.h
> +++ b/net/hsr/hsr_framereg.h
> @@ -28,9 +28,10 @@ struct hsr_frame_info {
>         bool is_from_san;
>  };
>
> +u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr);
>  void hsr_del_self_node(struct hsr_priv *hsr);
> -void hsr_del_nodes(struct list_head *node_db);
> -struct hsr_node *hsr_get_node(struct hsr_port *port, struct list_head *n=
ode_db,
> +void hsr_del_nodes(struct hlist_head *node_db);
> +struct hsr_node *hsr_get_node(struct hsr_port *port, struct hlist_head *=
node_db,
>                               struct sk_buff *skb, bool is_sup,
>                               enum hsr_port_type rx_port);
>  void hsr_handle_sup_frame(struct hsr_frame_info *frame);
> @@ -68,7 +69,7 @@ void prp_handle_san_frame(bool san, enum hsr_port_type =
port,
>  void prp_update_san_info(struct hsr_node *node, bool is_sup);
>
>  struct hsr_node {
> -       struct list_head        mac_list;
> +       struct hlist_node       mac_list;
>         unsigned char           macaddress_A[ETH_ALEN];
>         unsigned char           macaddress_B[ETH_ALEN];
>         /* Local slave through which AddrB frames are received from this =
node */
> diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
> index 043e4e9a1694..1465346bd235 100644
> --- a/net/hsr/hsr_main.h
> +++ b/net/hsr/hsr_main.h
> @@ -63,6 +63,9 @@ struct hsr_tag {
>
>  #define HSR_V1_SUP_LSDUSIZE            52
>
> +#define HSR_HSIZE_SHIFT        8
> +#define HSR_HSIZE      BIT(HSR_HSIZE_SHIFT)
> +
>  /* The helper functions below assumes that 'path' occupies the 4 most
>   * significant bits of the 16-bit field shared by 'path' and 'LSDU_size'=
 (or
>   * equivalently, the 4 most significant bits of HSR tag byte 14).
> @@ -201,8 +204,8 @@ struct hsr_proto_ops {
>  struct hsr_priv {
>         struct rcu_head         rcu_head;
>         struct list_head        ports;
> -       struct list_head        node_db;        /* Known HSR nodes */
> -       struct list_head        self_node_db;   /* MACs of slaves */
> +       struct hlist_head       node_db[HSR_HSIZE];     /* Known HSR node=
s */
> +       struct hlist_head       self_node_db;   /* MACs of slaves */
>         struct timer_list       announce_timer; /* Supervision frame disp=
atch */
>         struct timer_list       prune_timer;
>         int announce_count;
> @@ -212,6 +215,8 @@ struct hsr_priv {
>         spinlock_t seqnr_lock;  /* locking for sequence_nr */
>         spinlock_t list_lock;   /* locking for node list */
>         struct hsr_proto_ops    *proto_ops;
> +       u32 hash_buckets;
> +       u32 hash_seed;
>  #define PRP_LAN_ID     0x5     /* 0x1010 for A and 0x1011 for B. Bit 0 i=
s set
>                                  * based on SLAVE_A or SLAVE_B
>                                  */
> diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
> index f3c8f91dbe2c..1405c037cf7a 100644
> --- a/net/hsr/hsr_netlink.c
> +++ b/net/hsr/hsr_netlink.c
> @@ -105,6 +105,7 @@ static int hsr_newlink(struct net *src_net, struct ne=
t_device *dev,
>  static void hsr_dellink(struct net_device *dev, struct list_head *head)
>  {
>         struct hsr_priv *hsr =3D netdev_priv(dev);
> +       int i;
>
>         del_timer_sync(&hsr->prune_timer);
>         del_timer_sync(&hsr->announce_timer);
> @@ -113,7 +114,8 @@ static void hsr_dellink(struct net_device *dev, struc=
t list_head *head)
>         hsr_del_ports(hsr);
>
>         hsr_del_self_node(hsr);
> -       hsr_del_nodes(&hsr->node_db);
> +       for (i =3D 0; i < hsr->hash_buckets; i++)
> +               hsr_del_nodes(&hsr->node_db[i]);
>
>         unregister_netdevice_queue(dev, head);
>  }
> --
> 2.25.1
>


--=20

Best regards,
Juhee Kang
