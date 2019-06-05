Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F051D36569
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfFEUYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:24:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:4314 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbfFEUXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 16:23:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 13:23:46 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 05 Jun 2019 13:23:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/15] net: hns3: Use LLDP ethertype define ETH_P_LLDP
Date:   Wed,  5 Jun 2019 13:23:56 -0700
Message-Id: <20190605202358.2767-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
References: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Remove references to HCLGE_MAC_ETHERTYPE_LLDP and use ETH_P_LLDP instead.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  | 1 -
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 61cb10dc2b9b..7a14d806744c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -677,7 +677,6 @@ struct hclge_umv_spc_alc_cmd {
 #define HCLGE_MAC_MGR_MASK_VLAN_B		BIT(0)
 #define HCLGE_MAC_MGR_MASK_MAC_B		BIT(1)
 #define HCLGE_MAC_MGR_MASK_ETHERTYPE_B		BIT(2)
-#define HCLGE_MAC_ETHERTYPE_LLDP		0x88cc
 
 struct hclge_mac_mgr_tbl_entry_cmd {
 	u8      flags;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 35d2a454bf66..cda1b3d096cd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -292,7 +292,7 @@ static const struct hclge_comm_stats_str g_mac_stats_string[] = {
 static const struct hclge_mac_mgr_tbl_entry_cmd hclge_mgr_table[] = {
 	{
 		.flags = HCLGE_MAC_MGR_MASK_VLAN_B,
-		.ethter_type = cpu_to_le16(HCLGE_MAC_ETHERTYPE_LLDP),
+		.ethter_type = cpu_to_le16(ETH_P_LLDP),
 		.mac_addr_hi32 = cpu_to_le32(htonl(0x0180C200)),
 		.mac_addr_lo16 = cpu_to_le16(htons(0x000E)),
 		.i_port_bitmap = 0x1,
-- 
2.21.0

