Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3CA49EC95
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344079AbiA0Uk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:40:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46344 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344063AbiA0UkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:40:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBF00B8235A
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 20:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E525C340EC;
        Thu, 27 Jan 2022 20:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643316018;
        bh=4Ts0AYykHf14gGL6emwFKmaJdFBY4MsieI3Zbo/iXEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esqrYplxAyTMqRIxL0T7uv9keTbkJ0BpLMD4+Sba26hRfWVFgKYXZ7+Hy0Xiw9GNK
         3M4dGZ0M2aN5ALv2dXW0cY4PwzOdhz0xCnnGNsHwD8GZbWSSdfUp5sWorixASMleKb
         SBIY6sf3RSmzF49eQcWaVbbA+FAjxvm27JudV4OE5kIcaVq96wR9QAKWrB1G3iaxz3
         VroFXkZ4FiddBN1uK0E9/uw/478gO77RrYGMHVc2gmn1aQ4KWITMg37lDhmyBzpbh8
         kJ/YRa2LLZ4v1eWOPqgHeNz8DD824AElDkvjT4tzdSGamRb3Pqamhw9WVCBVaiRPho
         ITLikmg5kChwA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next RESEND 15/17] net/mlx5: Remove unused TIR modify bitmask enums
Date:   Thu, 27 Jan 2022 12:40:05 -0800
Message-Id: <20220127204007.146300-16-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127204007.146300-1-saeed@kernel.org>
References: <20220127204007.146300-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

struct mlx5_ifc_modify_tir_bitmask_bits is used for the bitmask
of MODIFY_TIR operations.
Remove the unused bitmask enums.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 598ac3bcc901..27145c4d6820 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -63,13 +63,6 @@ enum {
 	MLX5_EVENT_TYPE_CODING_FPGA_QP_ERROR                       = 0x21
 };
 
-enum {
-	MLX5_MODIFY_TIR_BITMASK_LRO                   = 0x0,
-	MLX5_MODIFY_TIR_BITMASK_INDIRECT_TABLE        = 0x1,
-	MLX5_MODIFY_TIR_BITMASK_HASH                  = 0x2,
-	MLX5_MODIFY_TIR_BITMASK_TUNNELED_OFFLOAD_EN   = 0x3
-};
-
 enum {
 	MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE        = 0x0,
 	MLX5_SET_HCA_CAP_OP_MOD_ODP                   = 0x2,
-- 
2.34.1

