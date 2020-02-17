Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76CD116144F
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgBQONz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:13:55 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41086 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgBQONy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:13:54 -0500
Received: by mail-lf1-f65.google.com with SMTP id m30so11967989lfp.8
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 06:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Q0H3LVi0tyt4Qgd6ifz2PDW99lQ43dVBCV4yhDIBTI=;
        b=g53f0a1l5fa0nQcaK5iMY1WC8eXpx46Gbl1lMGQcKjdycjl8B8PGpyfPUx0VVW4oUX
         Xrj44NgClOiHLSUZu9KrarthW2OBD3NJ5Gan0NY/RTjeJk1zrvs92z9FNxItNJDcG7MG
         wdjYBMCoo7L1Er/hkhOKyEJcczEietqmD9o70KCA9/zl5tCeMfJyEMqMRr1EBqiY5Gds
         xf+36G1dB7GpYSlbREnNJR/mQV/T5X2vAWNrPt/kc2/NGnkslOF3QggLIgOFKbgelcAo
         hSamLvHv1VgRcjJTER+1N9H/z0xYBVGt9BXxQ8cxthSmlj1TyBMaSixOLB3a40WRzDx7
         WNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Q0H3LVi0tyt4Qgd6ifz2PDW99lQ43dVBCV4yhDIBTI=;
        b=KbzsNkaIuWyqYFkvRagYwlg6/wtw2f8U9zy8pbfbs7Ji+55mqUq4fFfbJ4JWmgXCIP
         r6vO6WNeziUUL4346dhwjNlb+dj14Fb4bQF/VN+2MM9NokjPkfBr9k+ftfO40XztrCJZ
         /2RwhOK8ZzSTOjmPFJe9oRhT+/rhZykMS2+0wZ+FMcP1I4cJAdp5xw5mUR8ugJdgOTrD
         plo6afkWTFqyqeXKVIBtFERS81MQSnuaNtH3YOq2727pcxeZHYepujiPZ+MYUO/0vlEf
         RcFbeTkV6zlNeIOxyX/szXkJdL8ypEVw7TkY0l8trt+xAhzvGbjTIX7Ci165dOUL6fld
         VY3Q==
X-Gm-Message-State: APjAAAUbpMBWVZ4DJ26oalKEwCfHFce3IDCWVmtV5QMXiWtwKwxgQaet
        EElmmV+4k8x7U4FUEGWhUI5XjnYcrXyt0Bmec80=
X-Google-Smtp-Source: APXvYqzqKhZDTJhAZY5ZRHlrdAxZc6mZwa11WIe28VAxYR6mfsOcNvRrfB5vFxiDOfrfwCADXS6Egr1fG919mvEpZpU=
X-Received: by 2002:a19:4f46:: with SMTP id a6mr8105967lfk.143.1581948831923;
 Mon, 17 Feb 2020 06:13:51 -0800 (PST)
MIME-Version: 1.0
References: <1579691703-56363-1-git-send-email-xiangxia.m.yue@gmail.com>
 <20200122133354.GB2196@nanopsycho> <d5d9c2d1-1201-c1e7-903a-a27c37e9e1e8@mellanox.com>
 <75306dcb-27e3-d80c-806e-d4a86558ebb4@mellanox.com>
In-Reply-To: <75306dcb-27e3-d80c-806e-d4a86558ebb4@mellanox.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 17 Feb 2020 22:13:15 +0800
Message-ID: <CAMDZJNWzJVA0NsbZumt+WNHfhoRknh5G4Z4SwPaqzU1VLL_qog@mail.gmail.com>
Subject: Re: [PATCH v3] net/mlx5e: Don't allow forwarding between uplink
To:     Roi Dayan <roid@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Or Gerlitz <gerlitz.or@gmail.com>,
        Saeed Mahameed <saeedm@dev.mellanox.co.il>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 4:15 PM Roi Dayan <roid@mellanox.com> wrote:
>
>
>
> On 2020-01-29 1:42 PM, Roi Dayan wrote:
> >
> >
> > On 2020-01-22 3:33 PM, Jiri Pirko wrote:
> >> Wed, Jan 22, 2020 at 12:15:03PM CET, xiangxia.m.yue@gmail.com wrote:
> >>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >>>
> >>> We can install forwarding packets rule between uplink
> >>> in switchdev mode, as show below. But the hardware does
> >>> not do that as expected (mlnx_perf -i $PF1, we can't get
> >>> the counter of the PF1). By the way, if we add the uplink
> >>> PF0, PF1 to Open vSwitch and enable hw-offload, the rules
> >>> can be offloaded but not work fine too. This patch add a
> >>> check and if so return -EOPNOTSUPP.
> >>>
> >>> $ tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1 \
> >>>    flower skip_sw action mirred egress redirect dev $PF1
> >>>
> >>> $ tc -d -s filter show dev $PF0 ingress
> >>>    skip_sw
> >>>    in_hw in_hw_count 1
> >>>    action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
> >>>    ...
> >>>    Sent hardware 408954 bytes 4173 pkt
> >>>    ...
> >>>
> >>> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >>> ---
> >>> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  5 +++++
> >>> drivers/net/ethernet/mellanox/mlx5/core/en_rep.h |  1 +
> >>> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 19 +++++++++++++++++++
> >>> 3 files changed, 25 insertions(+)
> >>>
> >>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> >>> index f175cb2..ac2a035 100644
> >>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> >>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> >>> @@ -1434,6 +1434,11 @@ static struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
> >>>     .ndo_set_features        = mlx5e_set_features,
> >>> };
> >>>
> >>> +bool mlx5e_eswitch_uplink_rep(struct net_device *netdev)
> >>> +{
> >>> +   return netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep;
> >>> +}
> >>> +
> >>> bool mlx5e_eswitch_rep(struct net_device *netdev)
> >>> {
> >>>     if (netdev->netdev_ops == &mlx5e_netdev_ops_rep ||
> >>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> >>> index 31f83c8..5211819 100644
> >>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> >>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
> >>> @@ -199,6 +199,7 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
> >>> void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
> >>>
> >>> bool mlx5e_eswitch_rep(struct net_device *netdev);
> >>> +bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
> >>>
> >>> #else /* CONFIG_MLX5_ESWITCH */
> >>> static inline bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv) { return false; }
> >>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> >>> index db614bd..35f68e4 100644
> >>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> >>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> >>> @@ -3361,6 +3361,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
> >>>                             struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
> >>>                             struct net_device *uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
> >>>                             struct net_device *uplink_upper;
> >>> +                           struct mlx5e_rep_priv *rep_priv;
> >>>
> >>>                             if (is_duplicated_output_device(priv->netdev,
> >>>                                                             out_dev,
> >>> @@ -3396,6 +3397,24 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
> >>>                                             return err;
> >>>                             }
> >>>
> >>> +                           /* Don't allow forwarding between uplink.
> >>> +                            *
> >>> +                            * Input vport was stored esw_attr->in_rep.
> >>> +                            * In LAG case, *priv* is the private data of
> >>> +                            * uplink which may be not the input vport.
> >>> +                            */
> >>> +                           rep_priv = mlx5e_rep_to_rep_priv(attr->in_rep);
> >>> +                           if (mlx5e_eswitch_uplink_rep(rep_priv->netdev) &&
> >>> +                               mlx5e_eswitch_uplink_rep(out_dev)) {
> >>> +                                   NL_SET_ERR_MSG_MOD(extack,
> >>> +                                                      "devices are both uplink, "
> >>
> >> Never break error messages.
> >>
> >>
> >>> +                                                      "can't offload forwarding");
> >>> +                                   pr_err("devices %s %s are both uplink, "
> >>
> >> Here as well.
> >>
> >>
> >>> +                                          "can't offload forwarding\n",
> >>> +                                          priv->netdev->name, out_dev->name);
> >>> +                                   return -EOPNOTSUPP;
> >>> +                           }
> >>> +
> >>>                             if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
> >>>                                     NL_SET_ERR_MSG_MOD(extack,
> >>>                                                        "devices are not on same switch HW, can't offload forwarding");
> >>> --
> >>> 1.8.3.1
> >>>
> >
> > beside what Jiri commented, the rest looks fine to me.
> >
>
> Hi Zhang,
>
> Are you going to send v4?
Hi, I am so sorry, reply too later. Holiday ends.
v4 is sent.
> Thanks,
> Roi
