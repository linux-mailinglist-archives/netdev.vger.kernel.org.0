Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9631641E4B8
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350395AbhI3XWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349561AbhI3XWm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80BEB61A08;
        Thu, 30 Sep 2021 23:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044059;
        bh=TpPW4GJMm0e4nYZbqayUEE2jf12uKW/qJShFo5ZHMls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbtW95nySRsQQSzUh2hRW/f0YEciHw2RKAic2kHRB+4eYqw9h3/bSWAXUOmb2Y32M
         /CrludtMgP8J5EysjJ49GeUBi8NKDNlPxpDKqlgLKL2ZKrjOv/Awdq1dOhUJ2nUMoV
         PXfpB1bah0k3/Y4d4t7PYiPD2HDSRUWif3OEL7nBic/aOvMJBcFMG1pPxOOlHvFZTe
         iSRsOT15X1HSnuGMmlHDTqYWlr2g8kSIr+SNXIIg5SXELUdjYSKxpRIgyZc4T+3cc4
         mI/2mO36fhaEo4lczT/Rc3XV5LZekZ2clKVH1bXeyNtNpbDK1OMTAAkNW9Pu+wEtbu
         sfj+pkPnjHEqQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5: DR, Add missing string for action type SAMPLER
Date:   Thu, 30 Sep 2021 16:20:45 -0700
Message-Id: <20210930232050.41779-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add missing string value for DR_ACTION_TYP_SAMPLER action type

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 00199b3eae6a..50630112c8ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -39,6 +39,7 @@ static const char * const action_type_to_str[] = {
 	[DR_ACTION_TYP_VPORT] = "DR_ACTION_TYP_VPORT",
 	[DR_ACTION_TYP_POP_VLAN] = "DR_ACTION_TYP_POP_VLAN",
 	[DR_ACTION_TYP_PUSH_VLAN] = "DR_ACTION_TYP_PUSH_VLAN",
+	[DR_ACTION_TYP_SAMPLER] = "DR_ACTION_TYP_SAMPLER",
 	[DR_ACTION_TYP_INSERT_HDR] = "DR_ACTION_TYP_INSERT_HDR",
 	[DR_ACTION_TYP_REMOVE_HDR] = "DR_ACTION_TYP_REMOVE_HDR",
 	[DR_ACTION_TYP_MAX] = "DR_ACTION_UNKNOWN",
-- 
2.31.1

