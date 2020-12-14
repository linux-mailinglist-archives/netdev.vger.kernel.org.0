Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7A32D9653
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 11:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407166AbgLNKbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 05:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407098AbgLNKbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 05:31:39 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4E8C0613CF;
        Mon, 14 Dec 2020 02:30:59 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id o13so5697675lfr.3;
        Mon, 14 Dec 2020 02:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MI62PWiHocssZD5BOU83V19NEAQHNHTNpNxSRVXX950=;
        b=KN+oDWEueXCIIw9fKU/tzVzw2tDpcZ0vyfFhKk6DCsLaCEuHpzoaIehE2xu2jOTiSz
         AANvBxFdPKUydxlUwWxxEKU5cP42K1p3HoPvPPNdjrMNPRhXgdr6KkwAwiY+wDQRFAGG
         J5LKorHuvMUFsGEXrfN8SkZbZzLC9DCN8RI++49VS+/PA2r3bL5dqF8jbGPrLN/JD2W1
         oxr9lXi+kjRoimjzJ1/HEtz5HYIdSavrL79Sp4I2D287UhY5AFuQlAOXvjJvcBR+05rl
         1Lkshxjatu5vOMMuZWbM718st5SSHS0/+w6MVH57HBtEZu0H5AohcMdw0uyYJ9DLdVKY
         FmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MI62PWiHocssZD5BOU83V19NEAQHNHTNpNxSRVXX950=;
        b=hi96ywtZWE+TmxZ00bTQU9hzMQbS1oIo5+4JiEA1M7VubF5crzJx6mfUiaKThEwLKg
         rN9d58+gZRjhNfFOiNzGKmARMaPWOK24tJ+3xWbyq2zYnwAyEHpsIu5ONIZiOvc5XCMa
         O671kLzEEwoFBBfuQE0rC0TvZ8WpgO0qBIYLXGRO1J/a0hzPZp6MSycehCYYkSj4cO1O
         pPR1uB/C64aBruCP3sxLhJvAcHeWFZ3Hrz7fae2M3XG77hPJbfDVCB94AVo/zpdbsyD+
         H4DvpvW60K5/GPmsSAqKlQ3CTESoy+aDleGNbxtYZQtp5xn6FOzxK6BV6wMWAtmrqmXk
         wDeA==
X-Gm-Message-State: AOAM530W3MW8J7aB+KQvO8FjYD21XPuHJUWtOVWZphPNbbFDS2xWz8DG
        S2s7iu7Q08VjvpPJ+vmbaAw=
X-Google-Smtp-Source: ABdhPJyltMX/8ogUUfsgUpl8NqA7BNTGX8eDd2C5+4Ujp33w1VpZwefeR/4+zU97uY2gpl0v2nhxYA==
X-Received: by 2002:a19:2254:: with SMTP id i81mr9991848lfi.422.1607941857651;
        Mon, 14 Dec 2020 02:30:57 -0800 (PST)
Received: from localhost.localdomain ([91.90.166.178])
        by smtp.googlemail.com with ESMTPSA id x8sm54361ljd.67.2020.12.14.02.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 02:30:56 -0800 (PST)
From:   Vasyl Gomonovych <gomonovych@gmail.com>
To:     tariqt@nvidia.com, kuba@kernel.org, joe@perches.com
Cc:     Vasyl Gomonovych <gomonovych@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net/mlx4: Use true,false for bool variable
Date:   Mon, 14 Dec 2020 11:30:08 +0100
Message-Id: <20201214103008.14783-1-gomonovych@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201212090234.0362d64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201212090234.0362d64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is fix for semantic patch warning available in
scripts/coccinelle/misc/boolinit.cocci
Fix en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
Fix main.c:4465:5-13: WARNING: Comparison of 0/1 to bool variable

Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>
---
 - Add coccicheck script name
 - Simplify if condition
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 502d1b97855c..b0f79a5151cf 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -684,7 +684,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 	xdp_prog = rcu_dereference(ring->xdp_prog);
 	xdp.rxq = &ring->xdp_rxq;
 	xdp.frame_sz = priv->frag_info[0].frag_stride;
-	doorbell_pending = 0;
+	doorbell_pending = false;
 
 	/* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
 	 * descriptor offset can be deduced from the CQE index instead of
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index c326b434734e..3492a4f3691e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4462,7 +4462,7 @@ static int __init mlx4_verify_params(void)
 		pr_warn("mlx4_core: log_num_vlan - obsolete module param, using %d\n",
 			MLX4_LOG_NUM_VLANS);
 
-	if (use_prio != 0)
+	if (use_prio)
 		pr_warn("mlx4_core: use_prio - obsolete module param, ignored\n");
 
 	if ((log_mtts_per_seg < 0) || (log_mtts_per_seg > 7)) {
-- 
2.17.1

