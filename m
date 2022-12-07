Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60520645C23
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiLGOMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiLGOMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:12:47 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9648229CA5
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:12:42 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3b48b605351so191883087b3.22
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 06:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DH6jzHsVpI9ObruTmkI1ZuAZiR6+TqqdR1QCaKU3mKw=;
        b=o63EmYZVe8yWFG9tBix1Eed7W/ndbRAqpzBZnyzXrPJ5WzDctsOjfoDHdsgSaL8Xqx
         4hDfrw8dMvEd/o9BQYslk9T1IcUqHFh69t9tVKZBUKj+TbWAYu/j+zuXqF48fKAw4weZ
         WfNiVyI760jTIDayR2SEl49s6vqKrDfzMkEuzt9Z1nuyzFefoQyH2B4kjw78l97GS4Uo
         HMTj23r7+nz7fqbQNtbxkin/kaAmjIR7y1Kqlhq4H0FukxUEn79dUDUYmOS8hpVhciqp
         Pchz/CENOj/cPaJxvpTABoCPr5jP1LHt/1cY0e9l+OkMTyrI7KZLy+pxNgyYx47ksQWq
         CzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DH6jzHsVpI9ObruTmkI1ZuAZiR6+TqqdR1QCaKU3mKw=;
        b=DUNAt+9eXvXujgB4Gr+pMR1Kp6Byl2LRKZYkTBNYJjaQCSq7xlH7g+MW8XqZS5M0p2
         9qj4pS6DCrwLrzfWBkWjBNG9TNl2CH9X1P8b4JDZqvmAELYpoS6KcD3BFCA0upG3XNdH
         zMNobCvCTXYZ/a1vrpPYtq6ffSCRs5RAWJZwJ7RzY2Ib+csFfpab/esnGTrIAitE/fUJ
         Jl4ydwm5KbuPxj78P1Z1LQStZ9PqVLHS5P3fNtqsrWyE693x4HVBqpcIRpdSYJXQUuPO
         do3Enpl4RdEh3U+M8zVCFvgHJdKWBS67nyK2l1cD5fUZp/HF+nb2cR8h0WYVLU12Yx6i
         SPlQ==
X-Gm-Message-State: ANoB5pkd7TzASZ3Zx7aN+6fqcFj+RQkK3LFAjTPFe/f4joRuEaFfyc7M
        0evx3JMJkEJlgzYoT8r3SP+WAl0r3aOOWw==
X-Google-Smtp-Source: AA0mqf7CkY3ojCCW21xefQkuZamdTgC1JzS9xPH6ETc5vjdIBbPibncpMzSY+9JZlP3CXWUVr2tekUQkuA7sIw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:9216:0:b0:3df:22d0:ee81 with SMTP id
 j22-20020a819216000000b003df22d0ee81mr23484686ywg.183.1670422361872; Wed, 07
 Dec 2022 06:12:41 -0800 (PST)
Date:   Wed,  7 Dec 2022 14:12:35 +0000
In-Reply-To: <20221207141237.2575012-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221207141237.2575012-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221207141237.2575012-2-edumazet@google.com>
Subject: [PATCH v2 net-next 1/3] net/mlx4: rename two constants
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
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

