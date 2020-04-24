Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4DC1B7011
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgDXIxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:53:21 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34570 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726298AbgDXIxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 04:53:21 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 37CD7BEBEEF2EECE53D3;
        Fri, 24 Apr 2020 16:53:16 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 16:53:05 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <mlxsw@mellanox.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next] net/mlxfw: Remove unneeded semicolon
Date:   Fri, 24 Apr 2020 17:00:15 +0800
Message-ID: <20200424090015.90790-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c:79:2-3: Unneeded semicolon
drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c:162:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 046a0cb82ed8..7a04c626a2aa 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -76,7 +76,7 @@ static int mlxfw_fsm_state_err(struct mlxfw_dev *mlxfw_dev,
 	case MLXFW_FSM_STATE_ERR_MAX:
 		MLXFW_ERR_MSG(mlxfw_dev, extack, "unknown error", err);
 		break;
-	};
+	}

 	return mlxfw_fsm_state_errno[fsm_state_err];
 };
@@ -159,7 +159,7 @@ mlxfw_fsm_reactivate_err(struct mlxfw_dev *mlxfw_dev,
 	case MLXFW_FSM_REACTIVATE_STATUS_MAX:
 		MLXFW_REACT_ERR("unexpected error", err);
 		break;
-	};
+	}
 	return -EREMOTEIO;
 };

--
2.26.0.106.g9fadedd

