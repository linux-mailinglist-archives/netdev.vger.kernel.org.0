Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89331456D0
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgAVNd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:33:58 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39306 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVNd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 08:33:58 -0500
Received: by mail-wm1-f65.google.com with SMTP id 20so7196478wmj.4
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 05:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+TclySAyLKcuDBB3f8B/4PxfW/gUnKLMcoGkNZ0oz3E=;
        b=k4trAhb2U63dwSB5i66ID2675oPQuvh3F7VvcYyC/02vBx28UWf9ZA0UXCGpEEl70/
         uEDa75pn86P2FK4q3M0ZN6nJjrGSPfceWeyKNxPeqVXZcc7uZa1w5388307/D+YYJ+jr
         FnjC7c+aTvX6oakY69tgcx0nJenitl7bUXu7WdTrhGFzErHRFJSGOUV5a5sbDAeelQey
         CiiSxIOtoOy0NyvdGQ8fvTBUjFIus5nMhhteALWawQXiTx0QjMRKvmqxeupt4ramWaJb
         QEHXa9ETvutND9pJrJAIVtc/CX69VyA8zCqhn1MiWkmwkrc1LId9MvnD1L9YxAB8BJC6
         6nqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+TclySAyLKcuDBB3f8B/4PxfW/gUnKLMcoGkNZ0oz3E=;
        b=WGjHZXnDEImpX5JXQZW6cDFOLvwyoVuFIDh0stNPxX/Uqpc+S0upt6VJahhMzX4i07
         yhWnJryn5yW4X+HmiW3gh32sT1/OhGSDxt/wO0ZEjp9esPOCMz6uOZFIhN+vunADqgX0
         NLYAUZsA+iXi1kRyQXAg/Bw7FE5/DHfJckkoVZGjerPUOY4/apQl+kPDrwbpLbYJZxO8
         WbsdBwX9IpAALZDnGWgOJCpmiAbvaAusXUMQjc6eVJCtRugFh87l8qdlKzK8tAljpBb1
         D/OyAFE8GjEtSe1p7Pmx9QWoM81Kg/zlqAtPBm5XB29fJNnlNIRLGznRv0x81J4D88uK
         FGJQ==
X-Gm-Message-State: APjAAAUV1GVZoFT2AoP1M86Y4vaHM5MTVCObvQdce+NXmyM3QvXmqwUG
        Y1oefX0JLrD3gbRYBaawm9ULtA==
X-Google-Smtp-Source: APXvYqxuuZRgkmY/F2k4ekxbu6HCSkz6VJqEvKYrZMKRMvG8dw6scl0GvuBC+2vtHMILffRBihYCNw==
X-Received: by 2002:a05:600c:145:: with SMTP id w5mr2947081wmm.157.1579700036062;
        Wed, 22 Jan 2020 05:33:56 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id o187sm3017363wme.36.2020.01.22.05.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 05:33:55 -0800 (PST)
Date:   Wed, 22 Jan 2020 14:33:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     xiangxia.m.yue@gmail.com
Cc:     gerlitz.or@gmail.com, roid@mellanox.com, saeedm@dev.mellanox.co.il,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] net/mlx5e: Don't allow forwarding between uplink
Message-ID: <20200122133354.GB2196@nanopsycho>
References: <1579691703-56363-1-git-send-email-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579691703-56363-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 22, 2020 at 12:15:03PM CET, xiangxia.m.yue@gmail.com wrote:
>From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
>We can install forwarding packets rule between uplink
>in switchdev mode, as show below. But the hardware does
>not do that as expected (mlnx_perf -i $PF1, we can't get
>the counter of the PF1). By the way, if we add the uplink
>PF0, PF1 to Open vSwitch and enable hw-offload, the rules
>can be offloaded but not work fine too. This patch add a
>check and if so return -EOPNOTSUPP.
>
>$ tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1 \
>    flower skip_sw action mirred egress redirect dev $PF1
>
>$ tc -d -s filter show dev $PF0 ingress
>    skip_sw
>    in_hw in_hw_count 1
>    action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
>    ...
>    Sent hardware 408954 bytes 4173 pkt
>    ...
>
>Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>---
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  5 +++++
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.h |  1 +
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 19 +++++++++++++++++++
> 3 files changed, 25 insertions(+)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>index f175cb2..ac2a035 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>@@ -1434,6 +1434,11 @@ static struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
> 	.ndo_set_features        = mlx5e_set_features,
> };
> 
>+bool mlx5e_eswitch_uplink_rep(struct net_device *netdev)
>+{
>+	return netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep;
>+}
>+
> bool mlx5e_eswitch_rep(struct net_device *netdev)
> {
> 	if (netdev->netdev_ops == &mlx5e_netdev_ops_rep ||
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
>index 31f83c8..5211819 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
>@@ -199,6 +199,7 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
> void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
> 
> bool mlx5e_eswitch_rep(struct net_device *netdev);
>+bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
> 
> #else /* CONFIG_MLX5_ESWITCH */
> static inline bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv) { return false; }
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>index db614bd..35f68e4 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>@@ -3361,6 +3361,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
> 				struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
> 				struct net_device *uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
> 				struct net_device *uplink_upper;
>+				struct mlx5e_rep_priv *rep_priv;
> 
> 				if (is_duplicated_output_device(priv->netdev,
> 								out_dev,
>@@ -3396,6 +3397,24 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
> 						return err;
> 				}
> 
>+				/* Don't allow forwarding between uplink.
>+				 *
>+				 * Input vport was stored esw_attr->in_rep.
>+				 * In LAG case, *priv* is the private data of
>+				 * uplink which may be not the input vport.
>+				 */
>+				rep_priv = mlx5e_rep_to_rep_priv(attr->in_rep);
>+				if (mlx5e_eswitch_uplink_rep(rep_priv->netdev) &&
>+				    mlx5e_eswitch_uplink_rep(out_dev)) {
>+					NL_SET_ERR_MSG_MOD(extack,
>+							   "devices are both uplink, "

Never break error messages.


>+							   "can't offload forwarding");
>+					pr_err("devices %s %s are both uplink, "

Here as well.


>+					       "can't offload forwarding\n",
>+					       priv->netdev->name, out_dev->name);
>+					return -EOPNOTSUPP;
>+				}
>+
> 				if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
> 					NL_SET_ERR_MSG_MOD(extack,
> 							   "devices are not on same switch HW, can't offload forwarding");
>-- 
>1.8.3.1
>
