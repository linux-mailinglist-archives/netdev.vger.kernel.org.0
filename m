Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E8C1A02EC
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgDGAB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbgDGAB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 806022082F;
        Tue,  7 Apr 2020 00:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217718;
        bh=qM8LL6uEKVv7hUeypNV5D5h6B/YiokxF949tvBiBp3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gj6o9DH2xFLmFpM6qblHLRiBLRn0aZAxkCSxvORrUg7MG9h/znLUc/kazXKqmeii/
         tjUTmCfvPRM9/s2GVSjj16KIRsrzrTbyCkGURyS/8a21TTKbzCd3BdG/OYV1cbmAJJ
         aK4rdsGkwMzXAqqgzO9sipPM77BPajLz51SxHjaQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/32] net/mlx5e: kTLS, Fix wrong value in record tracker enum
Date:   Mon,  6 Apr 2020 20:01:23 -0400
Message-Id: <20200407000151.16768-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000151.16768-1-sashal@kernel.org>
References: <20200407000151.16768-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit f28ca65efa87b3fb8da3d69ca7cb1ebc0448de66 ]

Fix to match the HW spec: TRACKING state is 1, SEARCHING is 2.
No real issue for now, as these values are not currently used.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index a3efa29a4629d..63116be6b1d60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -38,8 +38,8 @@ enum {
 
 enum {
 	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START     = 0,
-	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_SEARCHING = 1,
-	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING  = 2,
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING  = 1,
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_SEARCHING = 2,
 };
 
 struct mlx5e_ktls_offload_context_tx {
-- 
2.20.1

