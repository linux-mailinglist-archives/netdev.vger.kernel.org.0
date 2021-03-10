Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6B833477E
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhCJTEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233762AbhCJTEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:04:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3609564EAE;
        Wed, 10 Mar 2021 19:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403041;
        bh=43+/ZZSPKSiMCVCq2+3jniZ9miyU2OH6HlnfC0/Rg+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQKl03SCXl1UUdMUfJvEYq1KpIJsFsyXBuiyYgAFnQio9pV5DcxqO7MUECyeeEmMm
         qpbWxy/p2FFO6mLyAhZaLMQpYBLAMD0G1TaOjr3Gaz6MkPDVIW/vvC/fppXlgnGm0F
         Yj7offNIYfIOTQtIXb5RepEXTSZhwlHkelbc3XPlchORV+8VLmsO8oU72x9q/QGH/i
         3aYQBEpanNT5vrrUPVUiD2098KlwU17sje7IITEh+y4392kAJZU3IgcMxDx938jctL
         mLlqE0897EimkPyegYWOoGEZ8SErXr1cRE9vF8MxG+C+tsbPLd2knQRjvoowt0Llgf
         MtLM9Z7YgMrNg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 15/18] net/mlx5: SF, Correct vhca context size
Date:   Wed, 10 Mar 2021 11:03:39 -0800
Message-Id: <20210310190342.238957-16-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Fix vhca context size as defined by device interface specification.

Fixes: f3196bb0f14c ("net/mlx5: Introduce vhca state event notifier")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h
index 1daf5a122ba3..4fc870140d71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/mlx5_ifc_vhca_event.h
@@ -20,7 +20,7 @@ struct mlx5_ifc_vhca_state_context_bits {
 
 	u8         sw_function_id[0x20];
 
-	u8         reserved_at_40[0x80];
+	u8         reserved_at_40[0x40];
 };
 
 struct mlx5_ifc_query_vhca_state_out_bits {
-- 
2.29.2

