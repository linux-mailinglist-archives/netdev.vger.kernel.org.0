Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FAA643CC9
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 06:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiLFFvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 00:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLFFvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 00:51:08 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A742E18E33
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 21:51:04 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-352e29ff8c2so146837797b3.21
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 21:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DH6jzHsVpI9ObruTmkI1ZuAZiR6+TqqdR1QCaKU3mKw=;
        b=tVgZJhEiWbYJ+dIZchhHLaASX0VcJj2NxcAlxyqvlryynHCgcFWA/hmQlPhJGqlQrm
         MjS5Ey+dHCNUWCW1cpSbA1gOu1SahNPEj1IdDvsxOXFfzMhxHewDqxBgPoIDv4SYIC9M
         xQ+60fuHYDoyKGDZQOBDKlh2fOF0YFyD8eBDjPbP0y6lQeEnd2ISqGxQO6rxp6pNc8ch
         irdw2zO93bk09vhkm/TrmDz3Bb6/WXGeq9HLrCn8+u3XqfrRkgsjYYak11xK+iG12k1x
         4ZUKPg02iOMYH+7mARIyVxsblnMqM0TxxFuuRYOFi/soMPqcfniR7Dk0odFompcOGhAv
         pXfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DH6jzHsVpI9ObruTmkI1ZuAZiR6+TqqdR1QCaKU3mKw=;
        b=54x/0fm3uFLvTzotA3sIEklCNb8Yp0nxx+2gDr2HC31dwd87ReUwRyCIbYDVIEwRYH
         FR2SlMHqoeLY+kfSl2nc51N62TpXCDU9NOuP2WnhdhrVqpZoPDY67QMWYynLkkfuzXV1
         tz/dkO2yt6ZdDNDAoOyzdNCrm4sw0yNvMZfvFebbTQ4rJzREQ1Xv1/UCn9R2wzJ4cr25
         4txFpExNx/6gAI4McquRNvjalF1+vAzZXSklhH01V/LqgMlLoClGkhpPKfli3QlVNkEU
         ISJjS82jeS867VnSryY4LRhpHNvfMWFVCJ/uO4k2JYpfLFTYQQdYBFU/q9/nSvqWZCHX
         n8dA==
X-Gm-Message-State: ANoB5plUfPbF1ms06zlOhkPwk3+BZwijdhQ7XzQ15GjZofvGiGcQqg2R
        5Od89El1qs9+FWKaIQihMZZfg8c5wXd22A==
X-Google-Smtp-Source: AA0mqf5PQpX7rBNzIY6VsB0l00/fTQR2Ld7OP81ywF1LYZxGGBcqj7S25wNVTfXbBroudJaGjVgjEtzJ337bTg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:7648:0:b0:6fe:54d5:2524 with SMTP id
 r69-20020a257648000000b006fe54d52524mr13061842ybc.522.1670305863932; Mon, 05
 Dec 2022 21:51:03 -0800 (PST)
Date:   Tue,  6 Dec 2022 05:50:57 +0000
In-Reply-To: <20221206055059.1877471-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221206055059.1877471-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206055059.1877471-2-edumazet@google.com>
Subject: [PATCH net-next 1/3] net/mlx4: rename two constants
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAX_DESC_SIZE is really the size of the bounce buffer used
when reaching the right side of TX ring buffer.

MAX_DESC_TXBBS get a MLX4_ prefix.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 10 ++++++----
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h |  4 ++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 43a4102e9c091758b33aa7377dcb82cab7c43a94..8372aeb392a28cf36a454e1b8a4783bc2b2056eb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -65,7 +65,7 @@ int mlx4_en_create_tx_ring(struct mlx4_en_priv *priv,
 	ring->size = size;
 	ring->size_mask = size - 1;
 	ring->sp_stride = stride;
-	ring->full_size = ring->size - HEADROOM - MAX_DESC_TXBBS;
+	ring->full_size = ring->size - HEADROOM - MLX4_MAX_DESC_TXBBS;
 
 	tmp = size * sizeof(struct mlx4_en_tx_info);
 	ring->tx_info = kvmalloc_node(tmp, GFP_KERNEL, node);
@@ -77,9 +77,11 @@ int mlx4_en_create_tx_ring(struct mlx4_en_priv *priv,
 	en_dbg(DRV, priv, "Allocated tx_info ring at addr:%p size:%d\n",
 		 ring->tx_info, tmp);
 
-	ring->bounce_buf = kmalloc_node(MAX_DESC_SIZE, GFP_KERNEL, node);
+	ring->bounce_buf = kmalloc_node(MLX4_TX_BOUNCE_BUFFER_SIZE,
+					GFP_KERNEL, node);
 	if (!ring->bounce_buf) {
-		ring->bounce_buf = kmalloc(MAX_DESC_SIZE, GFP_KERNEL);
+		ring->bounce_buf = kmalloc(MLX4_TX_BOUNCE_BUFFER_SIZE,
+					   GFP_KERNEL);
 		if (!ring->bounce_buf) {
 			err = -ENOMEM;
 			goto err_info;
@@ -909,7 +911,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Align descriptor to TXBB size */
 	desc_size = ALIGN(real_size, TXBB_SIZE);
 	nr_txbb = desc_size >> LOG_TXBB_SIZE;
-	if (unlikely(nr_txbb > MAX_DESC_TXBBS)) {
+	if (unlikely(nr_txbb > MLX4_MAX_DESC_TXBBS)) {
 		if (netif_msg_tx_err(priv))
 			en_warn(priv, "Oversized header or SG list\n");
 		goto tx_drop_count;
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index e132ff4c82f2d33045f6c9aeecaaa409a41e0b0d..7cc288db2a64f75ffe64882e3c25b90715e68855 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -90,8 +90,8 @@
 #define MLX4_EN_FILTER_EXPIRY_QUOTA 60
 
 /* Typical TSO descriptor with 16 gather entries is 352 bytes... */
-#define MAX_DESC_SIZE		512
-#define MAX_DESC_TXBBS		(MAX_DESC_SIZE / TXBB_SIZE)
+#define MLX4_TX_BOUNCE_BUFFER_SIZE 512
+#define MLX4_MAX_DESC_TXBBS	   (MLX4_TX_BOUNCE_BUFFER_SIZE / TXBB_SIZE)
 
 /*
  * OS related constants and tunables
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

