Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF44E3F91C3
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244035AbhH0BAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244055AbhH0A7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D67B610CE;
        Fri, 27 Aug 2021 00:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025903;
        bh=+uPUEX/F7Sm7YWIV13G9EXlz4rt6f3VvxnO8Hw2Fht4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jjg00I0MV+OK7DfTEQMxztfGDoaJZZ78TpTWbXpQqkmFKoObmaXJYlLWh18CfSfhn
         SnhlitN7FCBjmtyDcdKj0mhYQyhu4qBilDkGsNaeY3mCfbIyu2MA9IVhXvVwVU5FU/
         mgDcQz1rPCPI7qPyqq2/8xwEl24Z3msPeoy9BtDRDcyQAt1nmRm6Ai2dPS1cSaG2Gy
         +hIQ7yJ8RM8YAI00gZlJdZlt3nh27tNQTjKz6lri/kK6eB9lZ5haT6J5vNpm61EZ0d
         97x4RqQZRti6GeG5eyKFM3nyo1aM+dgDnKFZ89I76Geu7fL9gC/8wcAZKJZEB2SbtB
         tyOIZ1motKmwQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/17] net/mlx5: DR, Merge DR_STE_SIZE enums
Date:   Thu, 26 Aug 2021 17:57:58 -0700
Message-Id: <20210827005802.236119-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Merge DR_STE_SIZE enums - no need for a separate enum for reduced STE size.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index e45fbd6cc13c..dd4712d980ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -83,9 +83,6 @@ enum {
 	DR_STE_SIZE_CTRL = 32,
 	DR_STE_SIZE_TAG = 16,
 	DR_STE_SIZE_MASK = 16,
-};
-
-enum {
 	DR_STE_SIZE_REDUCED = DR_STE_SIZE - DR_STE_SIZE_MASK,
 };
 
-- 
2.31.1

