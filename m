Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CF33935B1
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbhE0S6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236102AbhE0S6L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:58:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE6EF61077;
        Thu, 27 May 2021 18:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141798;
        bh=hmNE4lUnxAlpZHoGjycoEXYBq4sZyFLqbjgBuCeCmrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMtRh7X+1b8UhtN6Dhsu8A2t1fKAjSRMWS+AxtzWWAK37UjJoADeYnmpCnrZ+bSBp
         7dX1OHIUWyUmkPPUQ41b2Ke2as8XD4hptXYy0TNb8fK8WJnk/GArQ5SuSI1WWRk4WB
         WfqKYg41XhnUKLefah3ixGXqYQI9eFeO3fhDNWyzuPxUsy6QcFgrKpbbMks1GWyp9i
         EZcZ+Nh/RHv3qlmgFYVzqYFmmGO5ksTBvBvdD3WnwctgY0cB/7BDCsoxXTplqnMWA5
         AZKXntaVvAirNGw7ADS6zZ4MxQaUN4D2Fbdi2ET8Q2uWxnZKLB/ANZEFnNKDWlhRMy
         mXQcAsfsA7jcw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 07/15] net/mlx5: DR, Remove unused field of send_ring struct
Date:   Thu, 27 May 2021 11:56:16 -0700
Message-Id: <20210527185624.694304-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527185624.694304-1-saeed@kernel.org>
References: <20210527185624.694304-1-saeed@kernel.org>
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

