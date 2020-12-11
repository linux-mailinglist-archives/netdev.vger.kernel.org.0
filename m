Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D013E2D736A
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 11:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405751AbgLKKH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 05:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405739AbgLKKGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 05:06:40 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488FDC0613CF;
        Fri, 11 Dec 2020 02:06:00 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id f11so10225346ljm.8;
        Fri, 11 Dec 2020 02:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=P/SiCCZOAOSw4oYWu5cwF6660nrQZQI22Lgjpro8r28=;
        b=PD81smQzhajFH1JOBchcwn6+BdBhkp9eJ03uz7eDWjQUJh2JRc+OeQ6XC2PX58n1b6
         +bWLrk8i3e8fZrbyu7KwF364wJ/PgDbSg33i3IaQJkAgNjU18eT1qr9miBTvKBqQDueQ
         PszeML+jZXsC1vVMC+o4jr95qNI4cMjhCUNxOOUR3qSk1iCbnR1e6mPIBDDQWbaF7E5R
         K5YVWVXlqqHuP5XgdcIJJTunJ0BZ/dcPF4epN1Wsw/bUbi+0lyEJRYQeiYjr24zyA98K
         td1k4EX3ampvd5iwEzWAFP8scraVh/BNzboBr+V1ZMjcbE3EcR8rwALhlbOCa6FEEOtc
         +ZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=P/SiCCZOAOSw4oYWu5cwF6660nrQZQI22Lgjpro8r28=;
        b=GtOJ9KdCNCMlhRGlVT/FwnoEaPTsLlSiZp9xdS6yOEwVE5NhqXHClig91e74+RumYV
         EnRjxwD1/vtQW17DI207HH1lFh19gzc++Hy2T0A+004VewCo32JZhF7/4NtL6+FGU1FU
         ZCj7NdBh1J0zC0Ytj8ZNWZITEDclyY9WyL4HgpIBRDusnYvCy9dHJfE+1S98XuPxB/sl
         UaSQ+dD3zMlUP+hdOGaIe8xXHR56p2HQWe957RMNWI7qBmrtQN8k+VGAFBVeM0ijnX08
         M7e80RToMDSSxalnrzOOEs4IzH8rj0wNGpKqZ+ZNZCM+g+RaSCN7pH6iyJC2OzjFMf6j
         FnUA==
X-Gm-Message-State: AOAM530fktVihGrsfGSAJxkwKoK9T1mk74vsedtEBORMFDedW+4J790F
        y36ooIGiXWJ0SCtnRXninMA=
X-Google-Smtp-Source: ABdhPJwhBEvLeuQpy0wnqBGf7LGPl8uD9kzG6zGXUSB9e7oc/vmJb9RFNBhFDxISupF12GAM5BQASg==
X-Received: by 2002:a2e:5cc6:: with SMTP id q189mr4984960ljb.316.1607681158828;
        Fri, 11 Dec 2020 02:05:58 -0800 (PST)
Received: from localhost.localdomain ([91.90.166.178])
        by smtp.googlemail.com with ESMTPSA id q21sm347968ljj.31.2020.12.11.02.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 02:05:58 -0800 (PST)
From:   Vasyl Gomonovych <gomonovych@gmail.com>
To:     tariqt@nvidia.com
Cc:     Vasyl Gomonovych <gomonovych@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx4: Use true,false for bool variable
Date:   Fri, 11 Dec 2020 11:05:18 +0100
Message-Id: <20201211100518.29804-1-gomonovych@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
Fix main.c:4465:5-13: WARNING: Comparison of 0/1 to bool variable

Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>
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
index c326b434734e..c5bce3eeed91 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4462,7 +4462,7 @@ static int __init mlx4_verify_params(void)
 		pr_warn("mlx4_core: log_num_vlan - obsolete module param, using %d\n",
 			MLX4_LOG_NUM_VLANS);
 
-	if (use_prio != 0)
+	if (use_prio != false)
 		pr_warn("mlx4_core: use_prio - obsolete module param, ignored\n");
 
 	if ((log_mtts_per_seg < 0) || (log_mtts_per_seg > 7)) {
-- 
2.17.1

