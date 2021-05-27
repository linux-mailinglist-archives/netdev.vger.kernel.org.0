Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315BC39267A
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbhE0EiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229905AbhE0EiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:38:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D06C4613D1;
        Thu, 27 May 2021 04:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622090195;
        bh=hmNE4lUnxAlpZHoGjycoEXYBq4sZyFLqbjgBuCeCmrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3OqJ6dzC5n8sTFv4Pg3B7V95SQoiKi3K/ZSuM2vqgl2Mu5+aOj0PF8bzEEkO34B2
         v9fMt2p8CyAjNQCxdqglZf9MQoqmxr4/wJWjKVsIxyuXrzlw/rT/OAxclF4yiBzaaU
         aZyNK6c+MYCulpbgPtnEavEiMQ9WHQoeprPKs2CB+h8ZbU2EWhNFEqqQJC8B9t3dcv
         q6CvZ+X8NdI0KWk20daTKjXPGwHJ0nreUe3ZvpCX+rtVyZKXtZd030q68GXNVJsNmf
         TtFZJlnGAKKoIRGflm7n/VQjKB0wfy5nClTw9TjQxqp0TgchTv+oyYhkyckg/nSSwL
         PBUUfALKwDLTA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/17] net/mlx5: DR, Remove unused field of send_ring struct
Date:   Wed, 26 May 2021 21:35:59 -0700
Message-Id: <20210527043609.654854-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527043609.654854-1-saeed@kernel.org>
References: <20210527043609.654854-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Remove unused field of struct mlx5dr_send_ring

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 67460c42a99b..7600004d79a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1252,7 +1252,6 @@ struct mlx5dr_send_ring {
 	u32 tx_head;
 	void *buf;
 	u32 buf_size;
-	struct ib_wc wc[MAX_SEND_CQE];
 	u8 sync_buff[MIN_READ_SYNC];
 	struct mlx5dr_mr *sync_mr;
 	spinlock_t lock; /* Protect the data path of the send ring */
-- 
2.31.1

