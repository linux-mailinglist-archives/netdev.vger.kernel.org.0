Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5587C6F353
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 15:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfGUNI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 09:08:57 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:51371 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfGUNI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 09:08:57 -0400
Received: from localhost.localdomain ([92.140.204.221])
        by mwinf5d34 with ME
        id fR8s2000B4n7eLC03R8sHs; Sun, 21 Jul 2019 15:08:55 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 21 Jul 2019 15:08:55 +0200
X-ME-IP: 92.140.204.221
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, tanhuazhong@huawei.com, lipeng321@huawei.com,
        shenjian15@huawei.com, liuzhongzhu@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: hns3: typo in the name of a constant
Date:   Sun, 21 Jul 2019 15:08:31 +0200
Message-Id: <20190721130831.16330-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All constant in 'enum HCLGE_MBX_OPCODE' start with HCLGE, except
'HLCGE_MBX_PUSH_VLAN_INFO' (C and L switched)

s/HLC/HCL/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h          | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c   | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 8ad5292eebbe..75329ab775a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -43,7 +43,7 @@ enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_GET_QID_IN_PF,	/* (VF -> PF) get queue id in pf */
 	HCLGE_MBX_LINK_STAT_MODE,	/* (PF -> VF) link mode has changed */
 	HCLGE_MBX_GET_LINK_MODE,	/* (VF -> PF) get the link mode of pf */
-	HLCGE_MBX_PUSH_VLAN_INFO,	/* (PF -> VF) push port base vlan */
+	HCLGE_MBX_PUSH_VLAN_INFO,	/* (PF -> VF) push port base vlan */
 	HCLGE_MBX_GET_MEDIA_TYPE,       /* (VF -> PF) get media type */
 
 	HCLGE_MBX_GET_VF_FLR_STATUS = 200, /* (M7 -> PF) get vf reset status */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 64578e96b2e2..d1f5ccee79d3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -300,7 +300,7 @@ int hclge_push_vf_port_base_vlan_info(struct hclge_vport *vport, u8 vfid,
 	memcpy(&msg_data[6], &vlan_tag, sizeof(u16));
 
 	return hclge_send_mbx_msg(vport, msg_data, sizeof(msg_data),
-				  HLCGE_MBX_PUSH_VLAN_INFO, vfid);
+				  HCLGE_MBX_PUSH_VLAN_INFO, vfid);
 }
 
 static int hclge_set_vf_vlan_cfg(struct hclge_vport *vport,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 30f2e9352cf3..2bf6ace289ff 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -203,7 +203,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 		case HCLGE_MBX_LINK_STAT_CHANGE:
 		case HCLGE_MBX_ASSERTING_RESET:
 		case HCLGE_MBX_LINK_STAT_MODE:
-		case HLCGE_MBX_PUSH_VLAN_INFO:
+		case HCLGE_MBX_PUSH_VLAN_INFO:
 			/* set this mbx event as pending. This is required as we
 			 * might loose interrupt event when mbx task is busy
 			 * handling. This shall be cleared when mbx task just
@@ -306,7 +306,7 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 			hclgevf_reset_task_schedule(hdev);
 
 			break;
-		case HLCGE_MBX_PUSH_VLAN_INFO:
+		case HCLGE_MBX_PUSH_VLAN_INFO:
 			state = le16_to_cpu(msg_q[1]);
 			vlan_info = &msg_q[1];
 			hclgevf_update_port_base_vlan_info(hdev, state,
-- 
2.20.1

