Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6910437F313
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 08:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhEMGbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 02:31:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2469 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhEMGbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 02:31:02 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FghXD4BtBzBtxY;
        Thu, 13 May 2021 14:27:08 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Thu, 13 May 2021 14:29:47 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <luobin9@huawei.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 3/4] net: hinic: remove unnecessary parentheses
Date:   Thu, 13 May 2021 14:26:52 +0800
Message-ID: <1620887213-49364-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620887213-49364-1-git-send-email-huangguangbin2@huawei.com>
References: <1620887213-49364-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some unnecessary parentheses, this patch deletes them.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c |  2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c  | 10 +++++-----
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c  |  6 +++---
 drivers/net/ethernet/huawei/hinic/hinic_hw_io.c   |  4 ++--
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c |  4 ++--
 drivers/net/ethernet/huawei/hinic/hinic_port.c    | 10 +++++-----
 drivers/net/ethernet/huawei/hinic/hinic_tx.c      |  2 +-
 7 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index 5a6bbee819cd..577cb2cffff2 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -223,7 +223,7 @@ static void cmdq_prepare_wqe_ctrl(struct hinic_cmdq_wqe *wqe, int wrapped,
 	saved_data = CMDQ_WQE_HEADER(wqe)->saved_data;
 	saved_data = HINIC_SAVED_DATA_CLEAR(saved_data, ARM);
 
-	if ((cmd == CMDQ_SET_ARM_CMD) && (mod == HINIC_MOD_COMM))
+	if (cmd == CMDQ_SET_ARM_CMD && mod == HINIC_MOD_COMM)
 		CMDQ_WQE_HEADER(wqe)->saved_data |=
 						HINIC_SAVED_DATA_SET(1, ARM);
 	else
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 0c74f6674634..19a91c0223a7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -257,7 +257,7 @@ static int init_fw_ctxt(struct hinic_hwdev *hwdev)
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_FWCTXT_INIT,
 				 &fw_ctxt, sizeof(fw_ctxt),
 				 &fw_ctxt, &out_size);
-	if (err || (out_size != sizeof(fw_ctxt)) || fw_ctxt.status) {
+	if (err || out_size != sizeof(fw_ctxt) || fw_ctxt.status) {
 		dev_err(&pdev->dev, "Failed to init FW ctxt, err: %d, status: 0x%x, out size: 0x%x\n",
 			err, fw_ctxt.status, out_size);
 		return -EIO;
@@ -424,7 +424,7 @@ static int get_base_qpn(struct hinic_hwdev *hwdev, u16 *base_qpn)
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_GLOBAL_QPN,
 				 &cmd_base_qpn, sizeof(cmd_base_qpn),
 				 &cmd_base_qpn, &out_size);
-	if (err || (out_size != sizeof(cmd_base_qpn)) || cmd_base_qpn.status) {
+	if (err || out_size != sizeof(cmd_base_qpn) || cmd_base_qpn.status) {
 		dev_err(&pdev->dev, "Failed to get base qpn, err: %d, status: 0x%x, out size: 0x%x\n",
 			err, cmd_base_qpn.status, out_size);
 		return -EIO;
@@ -605,8 +605,8 @@ static void nic_mgmt_msg_handler(void *handle, u8 cmd, void *buf_in,
 	hwif = hwdev->hwif;
 	pdev = hwif->pdev;
 
-	if ((cmd < HINIC_MGMT_MSG_CMD_BASE) ||
-	    (cmd >= HINIC_MGMT_MSG_CMD_MAX)) {
+	if (cmd < HINIC_MGMT_MSG_CMD_BASE ||
+	    cmd >= HINIC_MGMT_MSG_CMD_MAX) {
 		dev_err(&pdev->dev, "unknown L2NIC event, cmd = %d\n", cmd);
 		return;
 	}
@@ -619,7 +619,7 @@ static void nic_mgmt_msg_handler(void *handle, u8 cmd, void *buf_in,
 			   HINIC_CB_ENABLED,
 			   HINIC_CB_ENABLED | HINIC_CB_RUNNING);
 
-	if ((cb_state == HINIC_CB_ENABLED) && (nic_cb->handler))
+	if (cb_state == HINIC_CB_ENABLED && nic_cb->handler)
 		nic_cb->handler(nic_cb->handle, buf_in,
 				in_size, buf_out, out_size);
 	else
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index 19942fef99d9..d3fc05a07fdb 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
@@ -254,8 +254,8 @@ static void aeq_irq_handler(struct hinic_eq *eq)
 					    HINIC_EQE_ENABLED,
 					    HINIC_EQE_ENABLED |
 					    HINIC_EQE_RUNNING);
-			if ((eqe_state == HINIC_EQE_ENABLED) &&
-			    (hwe_cb->hwe_handler))
+			if (eqe_state == HINIC_EQE_ENABLED &&
+			    hwe_cb->hwe_handler)
 				hwe_cb->hwe_handler(hwe_cb->handle,
 						    aeqe_curr->data, size);
 			else
@@ -299,7 +299,7 @@ static void ceq_event_handler(struct hinic_ceqs *ceqs, u32 ceqe)
 			    HINIC_EQE_ENABLED,
 			    HINIC_EQE_ENABLED | HINIC_EQE_RUNNING);
 
-	if ((eqe_state == HINIC_EQE_ENABLED) && (ceq_cb->handler))
+	if (eqe_state == HINIC_EQE_ENABLED && ceq_cb->handler)
 		ceq_cb->handler(ceq_cb->handle, CEQE_DATA(ceqe));
 	else
 		dev_err(&pdev->dev, "Unhandled CEQ Event %d\n", event);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
index 4ef4008e65bd..a6e43d686293 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
@@ -137,7 +137,7 @@ static int write_sq_ctxts(struct hinic_func_to_io *func_to_io, u16 base_qpn,
 	err = hinic_cmdq_direct_resp(&func_to_io->cmdqs, HINIC_MOD_L2NIC,
 				     IO_CMD_MODIFY_QUEUE_CTXT, &cmdq_buf,
 				     &out_param);
-	if ((err) || (out_param != 0)) {
+	if (err || out_param != 0) {
 		dev_err(&pdev->dev, "Failed to set SQ ctxts\n");
 		err = -EFAULT;
 	}
@@ -181,7 +181,7 @@ static int write_rq_ctxts(struct hinic_func_to_io *func_to_io, u16 base_qpn,
 	err = hinic_cmdq_direct_resp(&func_to_io->cmdqs, HINIC_MOD_L2NIC,
 				     IO_CMD_MODIFY_QUEUE_CTXT, &cmdq_buf,
 				     &out_param);
-	if ((err) || (out_param != 0)) {
+	if (err || out_param != 0) {
 		dev_err(&pdev->dev, "Failed to set RQ ctxts\n");
 		err = -EFAULT;
 	}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index 817173f1fbb7..ebc77771f5da 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -294,7 +294,7 @@ static int msg_to_mgmt_sync(struct hinic_pf_to_mgmt *pf_to_mgmt,
 		goto unlock_sync_msg;
 	}
 
-	if ((buf_out) && (recv_msg->msg_len <= MAX_PF_MGMT_BUF_SIZE)) {
+	if (buf_out && recv_msg->msg_len <= MAX_PF_MGMT_BUF_SIZE) {
 		memcpy(buf_out, recv_msg->msg, recv_msg->msg_len);
 		*out_size = recv_msg->msg_len;
 	}
@@ -411,7 +411,7 @@ static void recv_mgmt_msg_work_handler(struct work_struct *work)
 			   HINIC_MGMT_CB_ENABLED,
 			   HINIC_MGMT_CB_ENABLED | HINIC_MGMT_CB_RUNNING);
 
-	if ((cb_state == HINIC_MGMT_CB_ENABLED) && (mgmt_cb->cb))
+	if (cb_state == HINIC_MGMT_CB_ENABLED && mgmt_cb->cb)
 		mgmt_cb->cb(mgmt_cb->handle, mgmt_work->cmd,
 			    mgmt_work->msg, mgmt_work->msg_len,
 			    buf_out, &out_size);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index eb97f2d6b1ad..28ae6f1201a8 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -128,7 +128,7 @@ int hinic_port_get_mac(struct hinic_dev *nic_dev, u8 *addr)
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_MAC,
 				 &port_mac_cmd, sizeof(port_mac_cmd),
 				 &port_mac_cmd, &out_size);
-	if (err || (out_size != sizeof(port_mac_cmd)) || port_mac_cmd.status) {
+	if (err || out_size != sizeof(port_mac_cmd) || port_mac_cmd.status) {
 		dev_err(&pdev->dev, "Failed to get mac, err: %d, status: 0x%x, out size: 0x%x\n",
 			err, port_mac_cmd.status, out_size);
 		return -EFAULT;
@@ -263,7 +263,7 @@ int hinic_port_link_state(struct hinic_dev *nic_dev,
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_LINK_STATE,
 				 &link_cmd, sizeof(link_cmd),
 				 &link_cmd, &out_size);
-	if (err || (out_size != sizeof(link_cmd)) || link_cmd.status) {
+	if (err || out_size != sizeof(link_cmd) || link_cmd.status) {
 		dev_err(&pdev->dev, "Failed to get link state, err: %d, status: 0x%x, out size: 0x%x\n",
 			err, link_cmd.status, out_size);
 		return -EINVAL;
@@ -297,7 +297,7 @@ int hinic_port_set_state(struct hinic_dev *nic_dev, enum hinic_port_state state)
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_PORT_STATE,
 				 &port_state, sizeof(port_state),
 				 &port_state, &out_size);
-	if (err || (out_size != sizeof(port_state)) || port_state.status) {
+	if (err || out_size != sizeof(port_state) || port_state.status) {
 		dev_err(&pdev->dev, "Failed to set port state, err: %d, status: 0x%x, out size: 0x%x\n",
 			err, port_state.status, out_size);
 		return -EFAULT;
@@ -329,7 +329,7 @@ int hinic_port_set_func_state(struct hinic_dev *nic_dev,
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_FUNC_STATE,
 				 &func_state, sizeof(func_state),
 				 &func_state, &out_size);
-	if (err || (out_size != sizeof(func_state)) || func_state.status) {
+	if (err || out_size != sizeof(func_state) || func_state.status) {
 		dev_err(&pdev->dev, "Failed to set port func state, err: %d, status: 0x%x, out size: 0x%x\n",
 			err, func_state.status, out_size);
 		return -EFAULT;
@@ -359,7 +359,7 @@ int hinic_port_get_cap(struct hinic_dev *nic_dev,
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_CAP,
 				 port_cap, sizeof(*port_cap),
 				 port_cap, &out_size);
-	if (err || (out_size != sizeof(*port_cap)) || port_cap->status) {
+	if (err || out_size != sizeof(*port_cap) || port_cap->status) {
 		dev_err(&pdev->dev,
 			"Failed to get port capabilities, err: %d, status: 0x%x, out size: 0x%x\n",
 			err, port_cap->status, out_size);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 710c4ff7bc0e..7bd414aed6ff 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -717,7 +717,7 @@ static int free_tx_poll(struct napi_struct *napi, int budget)
 
 		/* Reading a WQEBB to get real WQE size and consumer index. */
 		sq_wqe = hinic_sq_read_wqebb(sq, &skb, &wqe_size, &sw_ci);
-		if ((!sq_wqe) ||
+		if (!sq_wqe ||
 		    (((hw_ci - sw_ci) & wq->mask) * wq->wqebb_size < wqe_size))
 			break;
 
-- 
2.8.1

