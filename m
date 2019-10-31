Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5007EAEC8
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfJaLXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:23:20 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5665 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726709AbfJaLXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:23:03 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 16AA468BBBAE43112AB3;
        Thu, 31 Oct 2019 19:22:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 19:22:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/9] net: hns3: cleanup some coding style issues
Date:   Thu, 31 Oct 2019 19:23:19 +0800
Message-ID: <1572521004-36126-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
References: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

To unify code style and make code simpler, this patch modifies
some code, deletes unnecessary blank lines and {}, changes
location of code, and so on.

No functional change.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h                |  1 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h            |  4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c     |  5 ++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h     |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |  4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 11 ++++++-----
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  1 -
 7 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index e480236..23478ee 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -130,7 +130,6 @@ enum hnae3_module_type {
 	HNAE3_MODULE_TYPE_CR		= 0x04,
 	HNAE3_MODULE_TYPE_KR		= 0x05,
 	HNAE3_MODULE_TYPE_TP		= 0x06,
-
 };
 
 enum hnae3_fec_mode {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 0725dc5..345633f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -186,7 +186,7 @@ enum hns3_nic_state {
 #define HNS3_TXD_MSS_S				0
 #define HNS3_TXD_MSS_M				(0x3fff << HNS3_TXD_MSS_S)
 
-#define HNS3_TX_LAST_SIZE_M                    0xffff
+#define HNS3_TX_LAST_SIZE_M			0xffff
 
 #define HNS3_VECTOR_TX_IRQ			BIT_ULL(0)
 #define HNS3_VECTOR_RX_IRQ			BIT_ULL(1)
@@ -313,7 +313,7 @@ struct hns3_desc_cb {
 
 	u16 reuse_flag;
 
-       /* desc type, used by the ring user to mark the type of the priv data */
+	/* desc type, used by the ring user to mark the type of the priv data */
 	u16 type;
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index ecf58cf..c331146 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -314,11 +314,10 @@ int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
 		} while (timeout < hw->cmq.tx_timeout);
 	}
 
-	if (!complete) {
+	if (!complete)
 		retval = -EBADE;
-	} else {
+	else
 		retval = hclge_cmd_check_retval(hw, desc, num, ntc);
-	}
 
 	/* Clean the command send queue */
 	handle = hclge_cmd_csq_clean(hw);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index a4633d2..af96e79 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -261,6 +261,7 @@ enum hclge_opcode_type {
 
 	/* NCL config command */
 	HCLGE_OPC_QUERY_NCL_CONFIG	= 0x7011,
+
 	/* M7 stats command */
 	HCLGE_OPC_M7_STATS_BD		= 0x7012,
 	HCLGE_OPC_M7_STATS_INFO		= 0x7013,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 122ad92..e65c8cf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -145,7 +145,7 @@ static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
 		return;
 	}
 
-	buf_len	 = sizeof(struct hclge_desc) * bd_num;
+	buf_len	= sizeof(struct hclge_desc) * bd_num;
 	desc_src = kzalloc(buf_len, GFP_KERNEL);
 	if (!desc_src) {
 		dev_err(&hdev->pdev->dev, "call kzalloc failed\n");
@@ -153,7 +153,7 @@ static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
 	}
 
 	desc = desc_src;
-	ret  = hclge_dbg_cmd_send(hdev, desc, index, bd_num, reg_msg->cmd);
+	ret = hclge_dbg_cmd_send(hdev, desc, index, bd_num, reg_msg->cmd);
 	if (ret) {
 		kfree(desc_src);
 		return;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dbdc245..69ab86a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2777,7 +2777,7 @@ static void hclge_update_port_capability(struct hclge_mac *mac)
 	else if (mac->media_type == HNAE3_MEDIA_TYPE_COPPER)
 		mac->module_type = HNAE3_MODULE_TYPE_TP;
 
-	if (mac->support_autoneg == true) {
+	if (mac->support_autoneg) {
 		linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, mac->supported);
 		linkmode_copy(mac->advertising, mac->supported);
 	} else {
@@ -3855,12 +3855,13 @@ static void hclge_reset_event(struct pci_dev *pdev, struct hnae3_handle *handle)
 				  HCLGE_RESET_INTERVAL))) {
 		mod_timer(&hdev->reset_timer, jiffies + HCLGE_RESET_INTERVAL);
 		return;
-	} else if (hdev->default_reset_request)
+	} else if (hdev->default_reset_request) {
 		hdev->reset_level =
 			hclge_get_reset_level(ae_dev,
 					      &hdev->default_reset_request);
-	else if (time_after(jiffies, (hdev->last_reset_time + 4 * 5 * HZ)))
+	} else if (time_after(jiffies, (hdev->last_reset_time + 4 * 5 * HZ))) {
 		hdev->reset_level = HNAE3_FUNC_RESET;
+	}
 
 	dev_info(&hdev->pdev->dev, "received reset event, reset type is %d\n",
 		 hdev->reset_level);
@@ -3985,6 +3986,7 @@ static void hclge_service_task(struct work_struct *work)
 	hclge_update_link_status(hdev);
 	hclge_update_vport_alive(hdev);
 	hclge_sync_vlan_filter(hdev);
+
 	if (hdev->fd_arfs_expire_timer >= HCLGE_FD_ARFS_EXPIRE_TIMER_INTERVAL) {
 		hclge_rfs_filter_expire(hdev);
 		hdev->fd_arfs_expire_timer = 0;
@@ -7409,7 +7411,7 @@ void hclge_rm_vport_mac_table(struct hclge_vport *vport, const u8 *mac_addr,
 	mc_flag = is_write_tbl && mac_type == HCLGE_MAC_ADDR_MC;
 
 	list_for_each_entry_safe(mac_cfg, tmp, list, node) {
-		if (strncmp(mac_cfg->mac_addr, mac_addr, ETH_ALEN) == 0) {
+		if (ether_addr_equal(mac_cfg->mac_addr, mac_addr)) {
 			if (uc_flag && mac_cfg->hd_tbl_status)
 				hclge_rm_uc_addr_common(vport, mac_addr);
 
@@ -9093,7 +9095,6 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 
 		switch (client->type) {
 		case HNAE3_CLIENT_KNIC:
-
 			hdev->nic_client = client;
 			vport->nic.client = client;
 			ret = hclge_init_nic_client_instance(ae_dev, vport);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 2f3f63b..9506d7d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2170,7 +2170,6 @@ static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 		ret = hclgevf_set_rss_input_tuple(hdev, rss_cfg);
 		if (ret)
 			return ret;
-
 	}
 
 	/* Initialize RSS indirect table */
-- 
2.7.4

