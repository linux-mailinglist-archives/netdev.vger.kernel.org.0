Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F52362063
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbfGHOWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:22:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39873 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfGHOWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 10:22:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so17332747wrt.6
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 07:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GCDgX7NKgVsi9iV6LfvYtBfmL6X2W5VX7jTZe2rlqxE=;
        b=Dd/WHi+PRz0fnbSYsXkCtrrAFhOsrpZ2DZNHO2hQ+FznUjDgvcZoyQ8KzVqR/VIrNd
         z3gd7qlBUqSPyZ6k41eQPm74Mv0+YetcYIitwo/AYC9TsIyL2QSoZuvhuHdEX9k+324D
         leJFTLc3B0WzFaEf86k3PLX2DG5wiuBCX4e7EgQy/j30VlT6lJVkDIbdHMX/6Bm6B2AS
         C8ancUmNYOVD/nGDYQORE7clzMu581gl2Qcv5GdWEwklxf4SfWe2PDY+bA7crbR6FkSj
         v50Bu33MKy1fm2cIVoNHn+4xYEJ385PTVNzwGQ0ovuiOAAJM5KSczsAIHmkv0QWAUWu6
         TAtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GCDgX7NKgVsi9iV6LfvYtBfmL6X2W5VX7jTZe2rlqxE=;
        b=sen8ErT5Cr6szP4CQViQjIFBm6UtiLjIyZ8EgsAHV1P3BItIu1cb4c1DNDFoCnWGmh
         NumjUfKYyCupcRY67Zz8PS7JeyKJOmCgz+Wz7Wyq9gAJ0k/BxBX9zKujqaEQi10nH1qo
         m/9mcUmeV+uboXxS2RXACMZ40luPXbEh4TfRhW2kEOkDySeFdyjiuqz5eba3TROJEVc5
         PiqL0DswiYyIlahPVypOcD3mFwOLY1UWsoJz3R376WDQs2ODoGQkmIvAfc3nXc6P8Zbb
         QGRVxJVxQc6nIBB4hKxK7JbbNi7wocTsNfsuFwLsjkA9pvsMTZvDrlO3WHZ1rQzTaOzl
         c+Jw==
X-Gm-Message-State: APjAAAVrQZL4AXxNB7yuN7YKfHw4/tKevQJTl3P+pdjbHvDPiv0qk9Bj
        RzHb3dbzYWZVVP+0VIVVltDPuQ==
X-Google-Smtp-Source: APXvYqwk0+m1pJKDACMgGpu1DHGnvqoIBiGfEepDFjlz5dHtw7y/Opr2dDDDAv++2A0yCiz8UgGKgQ==
X-Received: by 2002:a5d:69cc:: with SMTP id s12mr18344516wrw.174.1562595724326;
        Mon, 08 Jul 2019 07:22:04 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id c30sm17133397wrb.15.2019.07.08.07.22.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 07:22:03 -0700 (PDT)
Date:   Mon, 8 Jul 2019 16:22:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 11/16] net/mlx5e: Add support to rx reporter
 diagnose
Message-ID: <20190708142203.GJ2201@nanopsycho>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-12-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-12-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:53:03PM CEST, tariqt@mellanox.com wrote:
>From: Aya Levin <ayal@mellanox.com>
>
>Add rx reporter, which supports diagnose call-back. Diagnostics output
>include: information common to all RQs: RQ type, RQ size, RQ stride
>size, CQ size and CQ stride size. In addition advertise information per
>RQ and its related icosq and attached CQ.
>
>$ devlink health diagnose pci/0000:00:0b.0 reporter rx
>Common config:
>   RQ: type: 2 stride size: 2048 size: 8
>   CQ: stride size: 64 size: 1024
> RQs:
>   channel ix: 0 rqn: 4284 HW state: 1 SW state: 3 posted WQEs: 7 cc: 7 ICOSQ HW state: 1 CQ: cqn: 1032 HW status: 0
>   channel ix: 1 rqn: 4289 HW state: 1 SW state: 3 posted WQEs: 7 cc: 7 ICOSQ HW state: 1 CQ: cqn: 1036 HW status: 0
>   channel ix: 2 rqn: 4294 HW state: 1 SW state: 3 posted WQEs: 7 cc: 7 ICOSQ HW state: 1 CQ: cqn: 1040 HW status: 0
>   channel ix: 3 rqn: 4299 HW state: 1 SW state: 3 posted WQEs: 7 cc: 7 ICOSQ HW state: 1 CQ: cqn: 1044 HW status: 0
>
>$ devlink health diagnose pci/0000:00:0b.0 reporter rx -jp
>{
>    "Common config": [
>        "RQ": {
>            "type": 2,
>            "stride size": 2048,
>            "size": 8
>        },
>        "CQ": {
>            "stride size": 64,
>            "size": 1024
>        } ],
>    "RQs": [ {
>            "channel ix": 0,
>            "rqn": 4284,
>            "HW state": 1,
>            "SW state": 3,
>            "posted WQEs": 7,
>            "cc": 7,
>            "ICOSQ HW state": 1,
>            "CQ": {
>                "cqn": 1032,
>                "HW status": 0
>            }
>        },{
>            "channel ix": 1,
>            "rqn": 4289,
>            "HW state": 1,
>            "SW state": 3,
>            "posted WQEs": 7,
>            "cc": 7,
>            "ICOSQ HW state": 1,
>            "CQ": {
>                "cqn": 1036,
>                "HW status": 0
>            }
>        },{
>            "channel ix": 2,
>            "rqn": 4294,
>            "HW state": 1,
>            "SW state": 3,
>            "posted WQEs": 7,
>            "cc": 7,
>            "ICOSQ HW state": 1,
>            "CQ": {
>                "cqn": 1040,
>                "HW status": 0
>            }
>        },{
>            "channel ix": 3,
>            "rqn": 4299,
>            "HW state": 1,
>            "SW state": 3,
>            "posted WQEs": 7,
>            "cc": 7,
>            "ICOSQ HW state": 1,
>            "CQ": {
>                "cqn": 1044,
>                "HW status": 0
>            }
>        } ]
>}
>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>---
> drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   4 +-
> drivers/net/ethernet/mellanox/mlx5/core/en.h       |  21 +++
> .../net/ethernet/mellanox/mlx5/core/en/health.c    |  31 ++++
> .../net/ethernet/mellanox/mlx5/core/en/health.h    |   7 +
> .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 194 +++++++++++++++++++++
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  29 +--
> 6 files changed, 258 insertions(+), 28 deletions(-)
> create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
>index 23d566a45a30..a3b9659649a8 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
>@@ -24,8 +24,8 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
> mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
> 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
> 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
>-		en/reporter_tx.o en/params.o en/xsk/umem.o en/xsk/setup.o \
>-		en/xsk/rx.o en/xsk/tx.o
>+		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/umem.o \
>+		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o
> 
> #
> # Netdev extra
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>index 263558875f20..f7c5cf7a7064 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>@@ -848,6 +848,7 @@ struct mlx5e_priv {
> 	struct mlx5e_tls          *tls;
> #endif
> 	struct devlink_health_reporter *tx_reporter;
>+	struct devlink_health_reporter *rx_reporter;
> 	struct mlx5e_xsk           xsk;
> };
> 
>@@ -888,6 +889,26 @@ netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
> int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget);
> void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
> 
>+static inline u32 mlx5e_rqwq_get_size(struct mlx5e_rq *rq)
>+{
>+	switch (rq->wq_type) {
>+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
>+		return mlx5_wq_ll_get_size(&rq->mpwqe.wq);
>+	default:
>+		return mlx5_wq_cyc_get_size(&rq->wqe.wq);
>+	}
>+}
>+
>+static inline u32 mlx5e_rqwq_get_cur_sz(struct mlx5e_rq *rq)
>+{
>+	switch (rq->wq_type) {
>+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
>+		return rq->mpwqe.wq.cur_sz;
>+	default:
>+		return rq->wqe.wq.cur_sz;
>+	}
>+}
>+
> bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev);
> bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
> 				struct mlx5e_params *params);
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
>index a266717d41e5..a0579de8e2e0 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
>@@ -96,6 +96,37 @@ int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *
> 	return 0;
> }
> 
>+int mlx5e_health_create_reporters(struct mlx5e_priv *priv)
>+{
>+	int err;
>+
>+	err = mlx5e_reporter_tx_create(priv);
>+	if (err)
>+		return err;
>+
>+	err = mlx5e_reporter_rx_create(priv);
>+	if (err)
>+		return err;
>+
>+	return 0;
>+}
>+
>+void mlx5e_health_destroy_reporters(struct mlx5e_priv *priv)
>+{
>+	mlx5e_reporter_rx_destroy(priv);
>+	mlx5e_reporter_tx_destroy(priv);
>+}
>+
>+void mlx5e_health_channels_update(struct mlx5e_priv *priv)
>+{
>+	if (priv->tx_reporter)
>+		devlink_health_reporter_state_update(priv->tx_reporter,
>+						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
>+	if (priv->rx_reporter)
>+		devlink_health_reporter_state_update(priv->rx_reporter,
>+						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
>+}

Could you do this introduction of mlx5e_health_create_reporters(),
mlx5e_health_destroy_reporters(), and mlx5e_health_channels_update()
in a separate patch before this one?


>+
> int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn)
> {
> 	struct mlx5_core_dev *mdev = channel->mdev;
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>index b0c8bda3d25f..7829ea229914 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>@@ -16,6 +16,9 @@
> int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *name);
> int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg);
> 
>+int mlx5e_reporter_rx_create(struct mlx5e_priv *priv);
>+void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv);
>+
> #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
> 
> struct mlx5e_err_ctx {
>@@ -29,5 +32,9 @@ struct mlx5e_err_ctx {
> int mlx5e_health_report(struct mlx5e_priv *priv,
> 			struct devlink_health_reporter *reporter, char *err_str,
> 			struct mlx5e_err_ctx *err_ctx);
>+int mlx5e_health_create_reporters(struct mlx5e_priv *priv);
>+void mlx5e_health_destroy_reporters(struct mlx5e_priv *priv);
>+void mlx5e_health_channels_update(struct mlx5e_priv *priv);
>+
> 
> #endif
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
>new file mode 100644
>index 000000000000..b24bdff473b0
>--- /dev/null
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
>@@ -0,0 +1,194 @@
>+// SPDX-License-Identifier: GPL-2.0
>+// Copyright (c) 2019 Mellanox Technologies.
>+
>+#include "health.h"
>+#include "params.h"
>+
>+static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *state)
>+{
>+	int outlen = MLX5_ST_SZ_BYTES(query_rq_out);
>+	void *out;
>+	void *rqc;
>+	int err;
>+
>+	out = kvzalloc(outlen, GFP_KERNEL);
>+	if (!out)
>+		return -ENOMEM;
>+
>+	err = mlx5_core_query_rq(dev, rqn, out);
>+	if (err)
>+		goto out;
>+
>+	rqc = MLX5_ADDR_OF(query_rq_out, out, rq_context);
>+	*state = MLX5_GET(rqc, rqc, state);
>+
>+out:
>+	kvfree(out);
>+	return err;
>+}
>+
>+static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
>+						   struct devlink_fmsg *fmsg)
>+{
>+	struct mlx5e_priv *priv = rq->channel->priv;
>+	struct mlx5e_params *params = &priv->channels.params;
>+	struct mlx5e_icosq *icosq = &rq->channel->icosq;
>+	u8 icosq_hw_state;
>+	int wqes_sz;
>+	u8 hw_state;
>+	u16 wq_head;
>+	int err;
>+
>+	err = mlx5e_query_rq_state(priv->mdev, rq->rqn, &hw_state);
>+	if (err)
>+		return err;
>+
>+	err = mlx5_core_query_sq_state(priv->mdev, icosq->sqn, &icosq_hw_state);
>+	if (err)
>+		return err;
>+
>+	wqes_sz = mlx5e_rqwq_get_cur_sz(rq);
>+	wq_head = params->rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ ?
>+		  rq->mpwqe.wq.head : mlx5_wq_cyc_get_head(&rq->wqe.wq);
>+
>+	err = devlink_fmsg_obj_nest_start(fmsg);
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_u32_pair_put(fmsg, "channel ix", rq->channel->ix);
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_u32_pair_put(fmsg, "rqn", rq->rqn);
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_u8_pair_put(fmsg, "HW state", hw_state);
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_u8_pair_put(fmsg, "SW state", rq->state);
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_u32_pair_put(fmsg, "posted WQEs", wqes_sz);
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_u32_pair_put(fmsg, "cc", wq_head);
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_u8_pair_put(fmsg, "ICOSQ HW state", icosq_hw_state);
>+	if (err)
>+		return err;
>+
>+	err = mlx5e_reporter_cq_diagnose(&rq->cq, fmsg);
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_obj_nest_end(fmsg);
>+	if (err)
>+		return err;
>+
>+	return 0;
>+}
>+
>+static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
>+				      struct devlink_fmsg *fmsg)
>+{
>+	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
>+	struct mlx5e_params *params = &priv->channels.params;
>+	struct mlx5e_rq *generic_rq;
>+	u32 rq_stride, rq_sz;
>+	int i, err = 0;
>+
>+	mutex_lock(&priv->state_lock);
>+
>+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
>+		goto unlock;
>+
>+	generic_rq = &priv->channels.c[0]->rq;
>+	rq_sz = mlx5e_rqwq_get_size(generic_rq);
>+	rq_stride = BIT(mlx5e_mpwqe_get_log_stride_size(priv->mdev, params, NULL));
>+
>+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "Common config");
>+	if (err)
>+		goto unlock;
>+
>+	err = mlx5e_reporter_named_obj_nest_start(fmsg, "RQ");
>+	if (err)
>+		goto unlock;
>+
>+	err = devlink_fmsg_u8_pair_put(fmsg, "type", params->rq_wq_type);
>+	if (err)
>+		goto unlock;
>+
>+	err = devlink_fmsg_u64_pair_put(fmsg, "stride size", rq_stride);
>+	if (err)
>+		goto unlock;
>+
>+	err = devlink_fmsg_u32_pair_put(fmsg, "size", rq_sz);
>+	if (err)
>+		goto unlock;
>+
>+	err = devlink_fmsg_arr_pair_nest_end(fmsg);

This is odd. I think that you should have
mlx5e_reporter_named_obj_nest_end() called here and
devlink_fmsg_arr_pair_nest_end() after
mlx5e_reporter_cq_common_diagnose()

Misuse of this seems to be a pattern. We need some checker for this
apparently.


>+	if (err)
>+		goto unlock;
>+
>+	err = mlx5e_reporter_cq_common_diagnose(&generic_rq->cq, fmsg);
>+	if (err)
>+		goto unlock;
>+
>+	err = mlx5e_reporter_named_obj_nest_end(fmsg);
>+	if (err)
>+		goto unlock;
>+
>+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "RQs");
>+	if (err)
>+		goto unlock;
>+
>+	for (i = 0; i < priv->channels.num; i++) {
>+		struct mlx5e_rq *rq = &priv->channels.c[i]->rq;
>+
>+		err = mlx5e_rx_reporter_build_diagnose_output(rq, fmsg);
>+		if (err)
>+			goto unlock;
>+	}
>+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
>+	if (err)
>+		goto unlock;
>+unlock:
>+	mutex_unlock(&priv->state_lock);
>+	return err;
>+}
>+
>+static const struct devlink_health_reporter_ops mlx5_rx_reporter_ops = {
>+		.name = "rx",
>+		.diagnose = mlx5e_rx_reporter_diagnose,
>+};
>+
>+int mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
>+{
>+	struct devlink_health_reporter *reporter;
>+	struct mlx5_core_dev *mdev = priv->mdev;
>+	struct devlink *devlink = priv_to_devlink(mdev);
>+
>+	reporter =
>+		devlink_health_reporter_create(devlink, &mlx5_rx_reporter_ops,
>+					       0, false, priv);

Rather align like this:

	reporter = devlink_health_reporter_create(devlink,
						  &mlx5_rx_reporter_ops,
						  0, false, priv);


>+	if (IS_ERR(reporter))
>+		netdev_warn(priv->netdev, "Failed to create rx reporter, err = %ld\n",
>+			    PTR_ERR(reporter));
>+	else
>+		priv->tx_reporter = reporter;
>+	return PTR_ERR_OR_ZERO(reporter);

Change the flow to:

	if (IS_ERR(reporter)) {
		netdev_warn(priv->netdev, "Failed to create rx reporter, err = %ld\n",
			    PTR_ERR(reporter));
		return PTR_ERR(reporter);
	}
	priv->tx_reporter = reporter;
	return 0;


>+}
>+
>+void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv)
>+{
>+	if (!priv->rx_reporter)
>+		return;
>+
>+	devlink_health_reporter_destroy(priv->rx_reporter);
>+}
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>index 98c925e72706..3922905e909f 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>@@ -247,26 +247,6 @@ static inline void mlx5e_build_umr_wqe(struct mlx5e_rq *rq,
> 	ucseg->mkey_mask     = cpu_to_be64(MLX5_MKEY_MASK_FREE);
> }
> 
>-static u32 mlx5e_rqwq_get_size(struct mlx5e_rq *rq)
>-{
>-	switch (rq->wq_type) {
>-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
>-		return mlx5_wq_ll_get_size(&rq->mpwqe.wq);
>-	default:
>-		return mlx5_wq_cyc_get_size(&rq->wqe.wq);
>-	}
>-}
>-
>-static u32 mlx5e_rqwq_get_cur_sz(struct mlx5e_rq *rq)
>-{
>-	switch (rq->wq_type) {
>-	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
>-		return rq->mpwqe.wq.cur_sz;
>-	default:
>-		return rq->wqe.wq.cur_sz;
>-	}
>-}
>-
> static int mlx5e_rq_alloc_mpwqe_info(struct mlx5e_rq *rq,
> 				     struct mlx5e_channel *c)
> {
>@@ -2320,10 +2300,7 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
> 			goto err_close_channels;
> 	}
> 
>-	if (priv->tx_reporter)
>-		devlink_health_reporter_state_update(priv->tx_reporter,
>-						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
>-
>+	mlx5e_health_channels_update(priv);
> 	kvfree(cparam);
> 	return 0;
> 
>@@ -3201,7 +3178,6 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv)
> {
> 	int tc;
> 
>-	mlx5e_reporter_tx_destroy(priv);
> 	for (tc = 0; tc < priv->profile->max_tc; tc++)
> 		mlx5e_destroy_tis(priv->mdev, priv->tisn[tc]);
> }
>@@ -4985,12 +4961,14 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
> 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
> 	mlx5e_build_nic_netdev(netdev);
> 	mlx5e_build_tc2txq_maps(priv);
>+	mlx5e_health_create_reporters(priv);
> 
> 	return 0;
> }
> 
> static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
> {
>+	mlx5e_health_destroy_reporters(priv);
> 	mlx5e_tls_cleanup(priv);
> 	mlx5e_ipsec_cleanup(priv);
> 	mlx5e_netdev_cleanup(priv->netdev, priv);
>@@ -5093,7 +5071,6 @@ static int mlx5e_init_nic_tx(struct mlx5e_priv *priv)
> #ifdef CONFIG_MLX5_CORE_EN_DCB
> 	mlx5e_dcbnl_initialize(priv);
> #endif
>-	mlx5e_reporter_tx_create(priv);
> 	return 0;
> }
> 
>-- 
>1.8.3.1
>
