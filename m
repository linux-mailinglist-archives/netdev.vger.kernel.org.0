Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E428616A9E1
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgBXPVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:21:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53263 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727701AbgBXPVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:21:04 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1j6FXZ-00054z-Cl; Mon, 24 Feb 2020 15:21:01 +0000
From:   Colin King <colin.king@canonical.com>
To:     mlxsw@mellanox.com, "David S . Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/mlxfw: fix spelling mistake: "progamming" -> "programming"
Date:   Mon, 24 Feb 2020 15:21:01 +0000
Message-Id: <20200224152101.361648-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a literal string. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
index c7e882eb8f35..046a0cb82ed8 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -150,7 +150,7 @@ mlxfw_fsm_reactivate_err(struct mlxfw_dev *mlxfw_dev,
 		MLXFW_REACT_ERR("device reset required", err);
 		break;
 	case MLXFW_FSM_REACTIVATE_STATUS_ERR_FW_PROGRAMMING_NEEDED:
-		MLXFW_REACT_ERR("fw progamming needed", err);
+		MLXFW_REACT_ERR("fw programming needed", err);
 		break;
 	case MLXFW_FSM_REACTIVATE_STATUS_FW_ALREADY_ACTIVATED:
 		MLXFW_REACT_ERR("fw already activated", err);
-- 
2.25.0

