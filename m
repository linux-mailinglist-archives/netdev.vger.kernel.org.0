Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E49339A05
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbhCLXjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:39:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235775AbhCLXi4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:38:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9A7364F86;
        Fri, 12 Mar 2021 23:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615592336;
        bh=xlxQIHZ5FOTHP6mv0KJY11l7eWsg49hW69Tx1fcL1BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbIngIKSzXqwbc0tvXMtO0PbJNYb3x8Hsy1XsIfgVQ5q1pmm3OJNhPxCQpryCf8Qb
         jyjHP75GrX62N6CqSGiVsE19Cb6QFSzew/z0lxuc42rSzlVgirRFGp0CwXRhRcCoBy
         SJPbY5DWMWDIdvONC8KcpGFDcMlWCk+JcSn0k2AkXHn+GGrDflqgD14OKfyJFwyPoG
         aAzjgvIpzleQBiWaXHn+Nic2R7x4RFkcFZKlYfkphGJPLYXJL5lLKaRLrTUUzhANvv
         pv9GrqPxA24QbhQ9Weon+8BfGaameIl6xP0t+lm0Fm238QizR32dwTLCxa47PT0KPh
         HDF8kuKMZIFBw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/13] net/mlx5: DR, Fixed typo in STE v0
Date:   Fri, 12 Mar 2021 15:38:39 -0800
Message-Id: <20210312233851.494832-2-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312233851.494832-1-saeed@kernel.org>
References: <20210312233851.494832-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

"reforamt" -> "reformat"

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 9ec079247c4b..c5f62d2a058f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -331,7 +331,7 @@ static void dr_ste_v0_set_tx_push_vlan(u8 *hw_ste_p, u32 vlan_hdr,
 	MLX5_SET(ste_sx_transmit, hw_ste_p, action_type,
 		 DR_STE_ACTION_TYPE_PUSH_VLAN);
 	MLX5_SET(ste_sx_transmit, hw_ste_p, encap_pointer_vlan_data, vlan_hdr);
-	/* Due to HW limitation we need to set this bit, otherwise reforamt +
+	/* Due to HW limitation we need to set this bit, otherwise reformat +
 	 * push vlan will not work.
 	 */
 	if (go_back)
-- 
2.29.2

