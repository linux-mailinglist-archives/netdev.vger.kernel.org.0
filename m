Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4891261EA6
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbfGHMm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:42:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35619 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730890AbfGHMmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:42:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id y4so8333254wrm.2
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 05:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0NHftvV6yBL7y41ZF8tZPrzXFrpBBTr4SREGZKp4GUI=;
        b=T/0G6oXOM4+k1IjGq63F0vHn04IT8x00FpL/PpBuaQ6HV3mcWgD3uxD5mzrLdrLADE
         0seFOKNR94F5s9gVmJQkKHn/RhMkmM9+UxhM8BPgySSOW7PU5/44MQ3vLpOePNl5Agpv
         sOHXtaQlYVC78dtLfL4iUahI4tyfGD8XKpcHK0W7hsZSucEXiDsgsnrEUNmiknBLD6jj
         C6cQMZdqrPRVt83ZqfLos6b7uJFmRDbmWdBMzvnqw65iu+gAE76lssjjohRuHEjsGeCu
         0zf3ZB549YdpeaSCIvrIcGLG5VWuwGMuEEXD/we5YAgxEkUIHGIqzZRNWSnkW4mokFf2
         CHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0NHftvV6yBL7y41ZF8tZPrzXFrpBBTr4SREGZKp4GUI=;
        b=NuEgJ3LfhrCpw1gqsaPgnTXqJbVgiyidMq6zdJUDjbvqAUC3TzOd+JhGtu38W/9eco
         SZ7yeje4NCSwwowWlJsrA6Nx4U8R6oYJr2t+ZR1hua2VGsn/4aDktlrvQxSF1xfjua9E
         m5bFCpmOw7G74S3Vcdv79oKfnxnBpq/8RKLycnAGZVPn1TtkY1U0U/ylyPwpJtga4MoO
         FmLDrHNP9bxFcNOVi7iMxhGgqAE1n3CJl3t3mOoAWUHMxo+gd6SY+dSKBbV7hkAO9Olf
         nlN6ZiRp/Hn3olmR7FpZ5qXvCXPgzXMuqH/PvpruoAqmKrwcJD2xSa2TfuF6X9Rj2tiQ
         IXGA==
X-Gm-Message-State: APjAAAUIRwBqO71NqnkPhPplCz13pv1wEE9abHiEWm9OtDF27DC8HJZf
        gerPAY4DRUg8xefSnSS/qBm5Wg==
X-Google-Smtp-Source: APXvYqxRj3HfcmZKCTsg8SMgpm1KaMDms0pH1GNyv3GDkHHg4rpJWDPsWVkEcBCGD8izNtLu3NQqyg==
X-Received: by 2002:adf:f64a:: with SMTP id x10mr18564620wrp.287.1562589742411;
        Mon, 08 Jul 2019 05:42:22 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id f7sm14551512wrv.38.2019.07.08.05.42.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 05:42:21 -0700 (PDT)
Date:   Mon, 8 Jul 2019 14:42:20 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 07/16] net/mlx5e: Generalize tx reporter's
 functionality
Message-ID: <20190708124220.GE2201@nanopsycho>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-8-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-8-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:52:59PM CEST, tariqt@mellanox.com wrote:
>From: Aya Levin <ayal@mellanox.com>
>
>Prepare for code sharing with rx reporter, which is added in the
>following patches in the set. Introduce a generic error_ctx for
>agnostic recovery despatch.
>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>---
> drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   5 +-
> .../net/ethernet/mellanox/mlx5/core/en/health.c    |  82 ++++++++++++++
> .../net/ethernet/mellanox/mlx5/core/en/health.h    |  15 ++-
> .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 126 ++++-----------------
> 4 files changed, 124 insertions(+), 104 deletions(-)
> create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/health.c
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
>index 57d2cc666fe3..23d566a45a30 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
>@@ -23,8 +23,9 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
> #
> mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
> 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
>-		en_selftest.o en/port.o en/monitor_stats.o en/reporter_tx.o \
>-		en/params.o en/xsk/umem.o en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o
>+		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
>+		en/reporter_tx.o en/params.o en/xsk/umem.o en/xsk/setup.o \
>+		en/xsk/rx.o en/xsk/tx.o
> 
> #
> # Netdev extra
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
>new file mode 100644
>index 000000000000..60166e5432ae
>--- /dev/null
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
>@@ -0,0 +1,82 @@
>+// SPDX-License-Identifier: GPL-2.0
>+// Copyright (c) 2019 Mellanox Technologies.
>+
>+#include "health.h"
>+#include "lib/eq.h"
>+
>+int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn)
>+{
>+	struct mlx5_core_dev *mdev = channel->mdev;
>+	struct net_device *dev = channel->netdev;
>+	struct mlx5e_modify_sq_param msp = {0};
>+	int err;
>+
>+	msp.curr_state = MLX5_SQC_STATE_ERR;
>+	msp.next_state = MLX5_SQC_STATE_RST;
>+
>+	err = mlx5e_modify_sq(mdev, sqn, &msp);
>+	if (err) {
>+		netdev_err(dev, "Failed to move sq 0x%x to reset\n", sqn);
>+		return err;
>+	}
>+
>+	memset(&msp, 0, sizeof(msp));
>+	msp.curr_state = MLX5_SQC_STATE_RST;
>+	msp.next_state = MLX5_SQC_STATE_RDY;
>+
>+	err = mlx5e_modify_sq(mdev, sqn, &msp);
>+	if (err) {
>+		netdev_err(dev, "Failed to move sq 0x%x to ready\n", sqn);
>+		return err;
>+	}
>+
>+	return 0;
>+}
>+
>+int mlx5e_health_recover_channels(struct mlx5e_priv *priv)
>+{
>+	int err = 0;
>+
>+	rtnl_lock();
>+	mutex_lock(&priv->state_lock);
>+
>+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
>+		goto out;
>+
>+	err = mlx5e_safe_reopen_channels(priv);
>+
>+out:
>+	mutex_unlock(&priv->state_lock);
>+	rtnl_unlock();
>+
>+	return err;
>+}
>+
>+int mlx5e_health_channel_eq_recover(struct mlx5_eq_comp *eq, struct mlx5e_channel *channel)
>+{
>+	u32 eqe_count;
>+
>+	netdev_err(channel->netdev, "EQ 0x%x: Cons = 0x%x, irqn = 0x%x\n",
>+		   eq->core.eqn, eq->core.cons_index, eq->core.irqn);
>+
>+	eqe_count = mlx5_eq_poll_irq_disabled(eq);
>+	if (!eqe_count)
>+		return -EIO;
>+
>+	netdev_err(channel->netdev, "Recovered %d eqes on EQ 0x%x\n",
>+		   eqe_count, eq->core.eqn);
>+
>+	channel->stats->eq_rearm++;
>+	return 0;
>+}
>+
>+int mlx5e_health_report(struct mlx5e_priv *priv,
>+			struct devlink_health_reporter *reporter, char *err_str,
>+			struct mlx5e_err_ctx *err_ctx)
>+{
>+	if (!reporter) {
>+		netdev_err(priv->netdev, err_str);
>+		return err_ctx->recover(&err_ctx->ctx);
>+	}
>+	return devlink_health_report(reporter, err_str, err_ctx);
>+}
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>index e3a3bcee89e7..960aa18c425d 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
>@@ -4,7 +4,6 @@
> #ifndef __MLX5E_EN_REPORTER_H
> #define __MLX5E_EN_REPORTER_H
> 
>-#include <linux/mlx5/driver.h>

How is this related to the rest of the patch?


> #include "en.h"
> 
> int mlx5e_reporter_tx_create(struct mlx5e_priv *priv);
>@@ -12,4 +11,18 @@
> void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
> int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq);
> 
>+#define MLX5E_REPORTER_PER_Q_MAX_LEN 256
>+
>+struct mlx5e_err_ctx {
>+	int (*recover)(void *ctx);
>+	void *ctx;
>+};
>+
>+int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn);
>+int mlx5e_health_channel_eq_recover(struct mlx5_eq_comp *eq, struct mlx5e_channel *channel);
>+int mlx5e_health_recover_channels(struct mlx5e_priv *priv);
>+int mlx5e_health_report(struct mlx5e_priv *priv,
>+			struct devlink_health_reporter *reporter, char *err_str,
>+			struct mlx5e_err_ctx *err_ctx);
>+
> #endif
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
>index d5ecfcfe5d52..3e03a1ac8e5a 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
>@@ -2,14 +2,6 @@
> /* Copyright (c) 2019 Mellanox Technologies. */
> 
> #include "health.h"
>-#include "lib/eq.h"
>-
>-#define MLX5E_TX_REPORTER_PER_SQ_MAX_LEN 256
>-
>-struct mlx5e_tx_err_ctx {
>-	int (*recover)(struct mlx5e_txqsq *sq);
>-	struct mlx5e_txqsq *sq;
>-};
> 
> static int mlx5e_wait_for_sq_flush(struct mlx5e_txqsq *sq)
> {
>@@ -39,37 +31,9 @@ static void mlx5e_reset_txqsq_cc_pc(struct mlx5e_txqsq *sq)
> 	sq->pc = 0;
> }
> 
>-static int mlx5e_sq_to_ready(struct mlx5e_txqsq *sq, int curr_state)
>-{
>-	struct mlx5_core_dev *mdev = sq->channel->mdev;
>-	struct net_device *dev = sq->channel->netdev;
>-	struct mlx5e_modify_sq_param msp = {0};
>-	int err;
>-
>-	msp.curr_state = curr_state;
>-	msp.next_state = MLX5_SQC_STATE_RST;
>-
>-	err = mlx5e_modify_sq(mdev, sq->sqn, &msp);
>-	if (err) {
>-		netdev_err(dev, "Failed to move sq 0x%x to reset\n", sq->sqn);
>-		return err;
>-	}
>-
>-	memset(&msp, 0, sizeof(msp));
>-	msp.curr_state = MLX5_SQC_STATE_RST;
>-	msp.next_state = MLX5_SQC_STATE_RDY;
>-
>-	err = mlx5e_modify_sq(mdev, sq->sqn, &msp);
>-	if (err) {
>-		netdev_err(dev, "Failed to move sq 0x%x to ready\n", sq->sqn);
>-		return err;
>-	}
>-
>-	return 0;
>-}
>-
>-static int mlx5e_tx_reporter_err_cqe_recover(struct mlx5e_txqsq *sq)
>+static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
> {
>+	struct mlx5e_txqsq *sq = (struct mlx5e_txqsq *)ctx;

No need to cast from void *


> 	struct mlx5_core_dev *mdev = sq->channel->mdev;
> 	struct net_device *dev = sq->channel->netdev;
> 	u8 state;
>@@ -101,7 +65,7 @@ static int mlx5e_tx_reporter_err_cqe_recover(struct mlx5e_txqsq *sq)
> 	 * pending WQEs. SQ can safely reset the SQ.
> 	 */
> 
>-	err = mlx5e_sq_to_ready(sq, state);
>+	err = mlx5e_health_sq_to_ready(sq->channel, sq->sqn);
> 	if (err)
> 		return err;
> 
>@@ -112,104 +76,64 @@ static int mlx5e_tx_reporter_err_cqe_recover(struct mlx5e_txqsq *sq)
> 	return 0;
> }
> 
>-static int mlx5_tx_health_report(struct devlink_health_reporter *tx_reporter,
>-				 char *err_str,
>-				 struct mlx5e_tx_err_ctx *err_ctx)
>-{
>-	if (!tx_reporter) {
>-		netdev_err(err_ctx->sq->channel->netdev, err_str);
>-		return err_ctx->recover(err_ctx->sq);
>-	}
>-
>-	return devlink_health_report(tx_reporter, err_str, err_ctx);
>-}
>-
> void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
> {
>-	char err_str[MLX5E_TX_REPORTER_PER_SQ_MAX_LEN];
>-	struct mlx5e_tx_err_ctx err_ctx = {0};
>+	struct mlx5e_priv *priv = sq->channel->priv;
>+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
>+	struct mlx5e_err_ctx err_ctx = {0};
> 
>-	err_ctx.sq       = sq;
>-	err_ctx.recover  = mlx5e_tx_reporter_err_cqe_recover;
>+	err_ctx.ctx = sq;
>+	err_ctx.recover = mlx5e_tx_reporter_err_cqe_recover;
> 	sprintf(err_str, "ERR CQE on SQ: 0x%x", sq->sqn);
> 
>-	mlx5_tx_health_report(sq->channel->priv->tx_reporter, err_str,
>-			      &err_ctx);
>+	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
> }
> 
>-static int mlx5e_tx_reporter_timeout_recover(struct mlx5e_txqsq *sq)
>+static int mlx5e_tx_reporter_timeout_recover(void *ctx)
> {
>+	struct mlx5e_txqsq *sq = (struct mlx5e_txqsq *)ctx;

No need to cast from void *

	
> 	struct mlx5_eq_comp *eq = sq->cq.mcq.eq;
>-	u32 eqe_count;
>-	int ret;
>-
>-	netdev_err(sq->channel->netdev, "EQ 0x%x: Cons = 0x%x, irqn = 0x%x\n",
>-		   eq->core.eqn, eq->core.cons_index, eq->core.irqn);
>+	int err;
> 
>-	eqe_count = mlx5_eq_poll_irq_disabled(eq);
>-	ret = eqe_count ? false : true;
>-	if (!eqe_count) {
>+	err = mlx5e_health_channel_eq_recover(eq, sq->channel);
>+	if (err)
> 		clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
>-		return ret;
>-	}
> 
>-	netdev_err(sq->channel->netdev, "Recover %d eqes on EQ 0x%x\n",
>-		   eqe_count, eq->core.eqn);
>-	sq->channel->stats->eq_rearm++;
>-	return ret;
>+	return err;
> }
> 
> int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
> {
>-	char err_str[MLX5E_TX_REPORTER_PER_SQ_MAX_LEN];
>-	struct mlx5e_tx_err_ctx err_ctx;
>+	struct mlx5e_priv *priv = sq->channel->priv;
>+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
>+	struct mlx5e_err_ctx err_ctx;
> 
>-	err_ctx.sq       = sq;
>-	err_ctx.recover  = mlx5e_tx_reporter_timeout_recover;
>+	err_ctx.ctx = sq;
>+	err_ctx.recover = mlx5e_tx_reporter_timeout_recover;
> 	sprintf(err_str,
> 		"TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%x, usecs since last trans: %u\n",
> 		sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
> 		jiffies_to_usecs(jiffies - sq->txq->trans_start));
> 
>-	return mlx5_tx_health_report(sq->channel->priv->tx_reporter, err_str,
>-				     &err_ctx);
>+	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
> }
> 
> /* state lock cannot be grabbed within this function.
>  * It can cause a dead lock or a read-after-free.
>  */
>-static int mlx5e_tx_reporter_recover_from_ctx(struct mlx5e_tx_err_ctx *err_ctx)
>+static int mlx5e_tx_reporter_recover_from_ctx(struct mlx5e_err_ctx *err_ctx)
> {
>-	return err_ctx->recover(err_ctx->sq);
>-}
>-
>-static int mlx5e_tx_reporter_recover_all(struct mlx5e_priv *priv)
>-{
>-	int err = 0;
>-
>-	rtnl_lock();
>-	mutex_lock(&priv->state_lock);
>-
>-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
>-		goto out;
>-
>-	err = mlx5e_safe_reopen_channels(priv);
>-
>-out:
>-	mutex_unlock(&priv->state_lock);
>-	rtnl_unlock();
>-
>-	return err;
>+	return err_ctx->recover(err_ctx->ctx);
> }
> 
> static int mlx5e_tx_reporter_recover(struct devlink_health_reporter *reporter,
> 				     void *context)
> {
> 	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
>-	struct mlx5e_tx_err_ctx *err_ctx = context;
>+	struct mlx5e_err_ctx *err_ctx = context;
> 
> 	return err_ctx ? mlx5e_tx_reporter_recover_from_ctx(err_ctx) :
>-			 mlx5e_tx_reporter_recover_all(priv);
>+			 mlx5e_health_recover_channels(priv);
> }
> 
> static int
>-- 
>1.8.3.1
>
