Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C730BDD55B
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387537AbfJRX3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:29:42 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39841 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfJRX3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:29:42 -0400
Received: by mail-qk1-f193.google.com with SMTP id 4so6891142qki.6
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yCww8EInCn7qZ+XHumH4lgjNWiuAucG8KmLtOu1BWx0=;
        b=fO/00Fk1MpILmg5cL/oeqOGnnkMpfKkD7JZ25/KejhRQSmJcxQf3PfYEIRAUTmlcE7
         ZvpFJXNp2tl62oGAgIR40nMaBeGsY0zgdGztKudzO8dh2S1I2EzEJY6GmHcMzlEW8JYU
         gqSHuVGdnMj/VmmFwOfjtTPPMQEIXio+jrJlyLHC69olMIzGQGUFLpjKdAo6Nge2Q2tY
         FC3BdxKNwZncRoBQQtxHuMfY26OvqyR3B61YtUKSsKQH/MtD45Hd64VJYIDpmjnDPuLs
         YtXckM0qbiMyX0EuiQkHpKa+ulZgbI1mj8sax7CXIGZqnTpeOYFUq4lSFkH2V0Us6hlS
         wqmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yCww8EInCn7qZ+XHumH4lgjNWiuAucG8KmLtOu1BWx0=;
        b=RlqTr5/5Pcg6UP6PaaYeHnlKN+5EFWUy1ksYJ3hkOoMvSUdhZgdzgxuHnhnIBdj9rn
         9A/kYRBwhcftSgN8wj9vh5Dh5QfAMl1/vKkgvKuKUZLh95TfcgNVdaIsxdjuSeqdcKUx
         1y/gRLNTTODmtuscW2YPlFssoxupdDtD+1bFuLLd9E6RiL2pY2/z+hSfap6ipb2J+uwg
         0Ikv3NLJYbu+UGtcYEcptlj0zq3Bi9jB4dqYSU1eSj9cKEGKdIZy5qW5IbulQ6mZq/TI
         xkhdVuZm83gBxVrOSvav+IF6KZa4P+aO3lwTF7fblSQ9QOIMG89nXT5Of2lFKblk4rnn
         5dnQ==
X-Gm-Message-State: APjAAAUoGnFsmZoa4EqjSOhdSytEEb5Fnp4DIi1lOUpS+yD+XRQ6nuZl
        bHoZ9fjwAVAiFNkP3S3Xas5/dypt5/dIYjVdlXU=
X-Google-Smtp-Source: APXvYqxk00tAFWcH3zAr/BLItK8h+PYsvScu0jBmvdqUVSZX2xchGc8aaTybxsKkUBmUM1IVnfvbc8NXwXiIQdAXgiM=
X-Received: by 2002:a37:68d0:: with SMTP id d199mr8060542qkc.174.1571441380571;
 Fri, 18 Oct 2019 16:29:40 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com> <1571135440-24313-11-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1571135440-24313-11-git-send-email-xiangxia.m.yue@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 18 Oct 2019 16:29:04 -0700
Message-ID: <CALDO+SYg16y1pkc=9exoJP+Gp_EyXrxkmb1cKatv10xZtXypUQ@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v4 10/10] net: openvswitch: simplify
 the ovs_dp_cmd_new
To:     xiangxia.m.yue@gmail.com
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 5:56 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> use the specified functions to init resource.
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> ---

Looks like this is simply moving code around.
I don't have any opinion.

>  net/openvswitch/datapath.c | 60 +++++++++++++++++++++++++++++-----------------
>  1 file changed, 38 insertions(+), 22 deletions(-)
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index aeb76e4..4d48e48 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -1576,6 +1576,31 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
>         return 0;
>  }
>
> +static int ovs_dp_stats_init(struct datapath *dp)
> +{
> +       dp->stats_percpu = netdev_alloc_pcpu_stats(struct dp_stats_percpu);
> +       if (!dp->stats_percpu)
> +               return -ENOMEM;
> +
> +       return 0;
> +}
> +
> +static int ovs_dp_vport_init(struct datapath *dp)
> +{
> +       int i;
> +
> +       dp->ports = kmalloc_array(DP_VPORT_HASH_BUCKETS,
> +                                 sizeof(struct hlist_head),
> +                                 GFP_KERNEL);
> +       if (!dp->ports)
> +               return -ENOMEM;
> +
> +       for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++)
> +               INIT_HLIST_HEAD(&dp->ports[i]);
> +
> +       return 0;
> +}
> +
>  static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>  {
>         struct nlattr **a = info->attrs;
> @@ -1584,7 +1609,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>         struct datapath *dp;
>         struct vport *vport;
>         struct ovs_net *ovs_net;
> -       int err, i;
> +       int err;
>
>         err = -EINVAL;
>         if (!a[OVS_DP_ATTR_NAME] || !a[OVS_DP_ATTR_UPCALL_PID])
> @@ -1597,35 +1622,26 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>         err = -ENOMEM;
>         dp = kzalloc(sizeof(*dp), GFP_KERNEL);
>         if (dp == NULL)
> -               goto err_free_reply;
> +               goto err_destroy_reply;
>
>         ovs_dp_set_net(dp, sock_net(skb->sk));
>
>         /* Allocate table. */
>         err = ovs_flow_tbl_init(&dp->table);
>         if (err)
> -               goto err_free_dp;
> +               goto err_destroy_dp;
>
> -       dp->stats_percpu = netdev_alloc_pcpu_stats(struct dp_stats_percpu);
> -       if (!dp->stats_percpu) {
> -               err = -ENOMEM;
> +       err = ovs_dp_stats_init(dp);
> +       if (err)
>                 goto err_destroy_table;
> -       }
>
> -       dp->ports = kmalloc_array(DP_VPORT_HASH_BUCKETS,
> -                                 sizeof(struct hlist_head),
> -                                 GFP_KERNEL);
> -       if (!dp->ports) {
> -               err = -ENOMEM;
> -               goto err_destroy_percpu;
> -       }
> -
> -       for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++)
> -               INIT_HLIST_HEAD(&dp->ports[i]);
> +       err = ovs_dp_vport_init(dp);
> +       if (err)
> +               goto err_destroy_stats;
>
>         err = ovs_meters_init(dp);
>         if (err)
> -               goto err_destroy_ports_array;
> +               goto err_destroy_ports;
>
>         /* Set up our datapath device. */
>         parms.name = nla_data(a[OVS_DP_ATTR_NAME]);
> @@ -1675,15 +1691,15 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>
>  err_destroy_meters:
>         ovs_meters_exit(dp);
> -err_destroy_ports_array:
> +err_destroy_ports:
>         kfree(dp->ports);
> -err_destroy_percpu:
> +err_destroy_stats:
>         free_percpu(dp->stats_percpu);
>  err_destroy_table:
>         ovs_flow_tbl_destroy(&dp->table);
> -err_free_dp:
> +err_destroy_dp:
>         kfree(dp);
> -err_free_reply:
> +err_destroy_reply:
>         kfree_skb(reply);
>  err:
>         return err;
> --
> 1.8.3.1
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
