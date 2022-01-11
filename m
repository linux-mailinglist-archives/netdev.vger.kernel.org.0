Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C846A48A532
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345899AbiAKBns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243764AbiAKBnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15662C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 17:43:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AA016147C
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AE3C36AF2;
        Tue, 11 Jan 2022 01:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865425;
        bh=4Ts0AYykHf14gGL6emwFKmaJdFBY4MsieI3Zbo/iXEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fR6aR0EKm8zK+lM8yIwdBCaFB3vlp+PxVyB6QN8CMSSJe7U8Z3xfR8mnvt4njZ0WT
         VATCWO5jPktE4k0aLJDE1vOlzCh9oDN9f6XNBJzHjcw1p1zFmKkozJEbH0iXSmw91F
         wfQu0gznZPRz5Me7FxgQ7C3fO/wqsdMYyfHKGKKQf6olnBRVT4tjM4yyKwpSRHaGqf
         iMlixvk06PJX7d3u6Y+VZPizLeJc4pJeGkWOMlBrX59Kwx1OYbo7uVMrwhtqJ8kqpD
         Mm1a3oqmn5CI1IvIECwsCTxFuDeZ2y86oimzaIOWGBtrWOEw5p+VTLhVo1c7elsFKZ
         C5QxOv7bVqV4w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/17] net/mlx5: Remove unused TIR modify bitmask enums
Date:   Mon, 10 Jan 2022 17:43:19 -0800
Message-Id: <20220111014335.178121-2-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
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

