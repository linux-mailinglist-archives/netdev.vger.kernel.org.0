Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A01348835
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 06:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhCYFFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 01:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhCYFEv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 01:04:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD8C561A24;
        Thu, 25 Mar 2021 05:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616648691;
        bh=HE/QZFdqS671tqHl5nlwxCKvdp++TU0y/bfIoDjsvEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNeZ0ey3lfaIQtLhxhzb/7+nHw4XHQBB6f0omnB7ZII8YQ415lpdqpFF5a2aOBsq2
         zhGMTPqUy/mGX6TL+6NjmjF20X518K3VmtSlxi9LQiy3AldMkom/gdRAqsWK6E4JHe
         15J3hqD46BqRmLd4CG54GVAciB9qvUOzHzdR4P1QMQeHjWs0cNZp1DwUoRGF+MhQR+
         PQrQbxfKZpqcQZi52pGOStb5HrzS5Rg7mJOeodmpGEU2ycabCE+iPDiVYzQbgbfTqk
         W2RTM04wx1fCy3cYDC2bj2iga019mQ1zrSFJRRL5L/ZOlmBz1tJ0MI3J3YbQXFN3I4
         s9GZeItFqiryg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5: Fix spelling mistakes in mlx5_core_info message
Date:   Wed, 24 Mar 2021 22:04:38 -0700
Message-Id: <20210325050438.261511-16-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325050438.261511-1-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two spelling mistakes in a mlx5_core_info message. Fix them.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index a0a851640804..9ff163c5bcde 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -340,7 +340,7 @@ static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
 		return -EIO;
 	}
 
-	mlx5_core_info(dev, "health revovery succeded\n");
+	mlx5_core_info(dev, "health recovery succeeded\n");
 	return 0;
 }
 
-- 
2.30.2

