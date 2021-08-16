Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D9D3ED00E
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbhHPIMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:12:54 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:36272
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234874AbhHPIMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 04:12:53 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 479763F07E;
        Mon, 16 Aug 2021 08:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629101540;
        bh=1meRxvtUorxwrfyMm6Zk03gMBP22C437FHsug3+oRuI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=c6arQCqnlgMW/Wcj3dbCC5M/HPuDyGGM+jf2Jzs/fzMzNMzN2wCOW+2gjvqNFwzfe
         OIYsvaSEDJLDufKbSAis3mg6CBP+/AET2vyyAKoWehdIpZ+oC1l0Vv5x7Kihp0vpIT
         SwGLOD/KYtnj4hBchuyRXj5ErR7sQlBQjYlwv/eoixauxqnZxswRRPtq8iiMdyHrP/
         LsXoCOaDNm4IltcX3Cnmo2YVNsYO57PwfQHyLsuO6AMwKNuimqyoEx8Rwu6mJ1YdNZ
         5eCegSEe3h4Vzdp63Fgaq1fpFN4HDxF0AEUnA2rrGB+ATEVahrImtFfjzwwvEsHp1Z
         6v7TPFTffcnqw==
From:   Colin King <colin.king@canonical.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/mlx5: Fix spelling mistake "enught" -> "enough"
Date:   Mon, 16 Aug 2021 09:12:20 +0100
Message-Id: <20210816081220.5641-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a mlx5_core_dbg debug message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index c79a10b3454d..fd735299df84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -506,7 +506,7 @@ static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pf_vec)
 	if (!mlx5_sf_max_functions(dev))
 		return 0;
 	if (sf_vec < MLX5_IRQ_VEC_COMP_BASE_SF) {
-		mlx5_core_dbg(dev, "Not enught IRQs for SFs. SF may run at lower performance\n");
+		mlx5_core_dbg(dev, "Not enough IRQs for SFs. SF may run at lower performance\n");
 		return 0;
 	}
 
-- 
2.32.0

