Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A573382618
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbhEQIA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3713 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235517AbhEQIAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:14 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FkBK82n9Xz16RD3;
        Mon, 17 May 2021 15:56:12 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:56 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:56 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH v2 24/24] net: hisilicon: hns: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:35 +0800
Message-ID: <20210517044535.21473-25-shenyang39@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210517044535.21473-1-shenyang39@huawei.com>
References: <20210517044535.21473-1-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema704-chm.china.huawei.com (10.3.20.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:121: warning: expecting prototype for hns_mac_is_adjust_link(). Prototype was for hns_mac_need_adjust_link() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:386: warning: expecting prototype for hns_mac_queue_config_bc_en(). Prototype was for hns_mac_port_config_bc_en() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c:607: warning: expecting prototype for hns_mac_set_autoneg(). Prototype was for hns_mac_set_pauseparam() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:236: warning: expecting prototype for hns_ppe_qid_cfg(). Prototype was for hns_dsaf_ppe_qid_cfg() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:623: warning: expecting prototype for dsaf_tbl_tcam_mcast_cfg(). Prototype was for hns_dsaf_tbl_tcam_mcast_cfg() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:1220: warning: expecting prototype for hns_dsaf_tbl_tcam_init(). Prototype was for hns_dsaf_comm_init() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2121: warning: expecting prototype for dsaf_pfc_unit_cnt(). Prototype was for hns_dsaf_pfc_unit_cnt() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2153: warning: expecting prototype for dsaf_port_work_rate_cfg(). Prototype was for hns_dsaf_port_work_rate_cfg() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2745: warning: expecting prototype for hns_dsaf_get_sset_count(). Prototype was for hns_dsaf_get_regs_count() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:2957: warning: expecting prototype for dsaf_probe(). Prototype was for hns_dsaf_probe() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c:3011: warning: expecting prototype for dsaf_remove(). Prototype was for hns_dsaf_remove() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c:366: warning: expecting prototype for hns_dsaf_srst_chns(). Prototype was for hns_dsaf_srst_chns_acpi() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c:509: warning: expecting prototype for hns_mac_get_sds_mode(). Prototype was for hns_mac_get_phy_if() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:303: warning: expecting prototype for ppe_init_hw(). Prototype was for hns_ppe_init_hw() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:350: warning: expecting prototype for ppe_uninit_hw(). Prototype was for hns_ppe_uninit_hw() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:391: warning: expecting prototype for hns_ppe_reset(). Prototype was for hns_ppe_reset_common() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c:464: warning: expecting prototype for ppe_get_strings(). Prototype was for hns_ppe_get_strings() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c:920: warning: expecting prototype for rcb_get_sset_count(). Prototype was for hns_rcb_get_ring_regs_count() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c:112: warning: expecting prototype for hns_xgmac_tx_lf_rf_insert(). Prototype was for hns_xgmac_lf_rf_insert() instead
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c:122: warning: expecting prototype for hns_xgmac__lf_rf_control_init(). Prototype was for hns_xgmac_lf_rf_control_init() instead
 drivers/net/ethernet/hisilicon/hns/hns_enet.c:777: warning: expecting prototype for hns_nic_adp_coalesce(). Prototype was for hns_nic_adpt_coalesce() instead
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:202: warning: expecting prototype for hns_nic_set_link_settings(). Prototype was for hns_nic_set_link_ksettings() instead
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:837: warning: expecting prototype for get_ethtool_stats(). Prototype was for hns_get_ethtool_stats() instead
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:894: warning: expecting prototype for get_strings(). Prototype was for hns_get_strings() instead

Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 .../net/ethernet/hisilicon/hns/hns_dsaf_mac.c    |  6 +++---
 .../net/ethernet/hisilicon/hns/hns_dsaf_main.c   | 16 ++++++++--------
 .../net/ethernet/hisilicon/hns/hns_dsaf_misc.c   |  4 ++--
 .../net/ethernet/hisilicon/hns/hns_dsaf_ppe.c    |  8 ++++----
 .../net/ethernet/hisilicon/hns/hns_dsaf_rcb.c    |  2 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c  |  4 ++--
 drivers/net/ethernet/hisilicon/hns/hns_enet.c    |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c |  6 +++---
 8 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
index de6f051f5b0b..f41379de2186 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -111,7 +111,7 @@ int hns_mac_get_port_info(struct hns_mac_cb *mac_cb,
 }
 
 /**
- *hns_mac_is_adjust_link - check is need change mac speed and duplex register
+ *hns_mac_need_adjust_link - check is need change mac speed and duplex register
  *@mac_cb: mac device
  *@speed: phy device speed
  *@duplex:phy device duplex
@@ -374,7 +374,7 @@ static void hns_mac_param_get(struct mac_params *param,
 }
 
 /**
- * hns_mac_queue_config_bc_en - set broadcast rx&tx enable
+ * hns_mac_port_config_bc_en - set broadcast rx&tx enable
  * @mac_cb: mac device
  * @port_num: queue number
  * @vlan_id: vlan id`
@@ -597,7 +597,7 @@ int hns_mac_set_autoneg(struct hns_mac_cb *mac_cb, u8 enable)
 }
 
 /**
- * hns_mac_set_autoneg - set rx & tx pause parameter
+ * hns_mac_set_pauseparam - set rx & tx pause parameter
  * @mac_cb: mac control block
  * @rx_en: rx enable or not
  * @tx_en: tx enable or not
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
index c2a60612f503..fcaf5132b865 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
@@ -227,7 +227,7 @@ hns_dsaf_reg_cnt_clr_ce(struct dsaf_device *dsaf_dev, u32 reg_cnt_clr_ce)
 }
 
 /**
- * hns_ppe_qid_cfg - config ppe qid
+ * hns_dsaf_ppe_qid_cfg - config ppe qid
  * @dsaf_dev: dsa fabric id
  * @qid_cfg: value array
  */
@@ -613,7 +613,7 @@ static void hns_dsaf_tbl_tcam_data_cfg(
 }
 
 /**
- * dsaf_tbl_tcam_mcast_cfg - tbl
+ * hns_dsaf_tbl_tcam_mcast_cfg - tbl
  * @dsaf_dev: dsa fabric id
  * @mcast: addr
  */
@@ -1213,7 +1213,7 @@ void hns_dsaf_get_rx_mac_pause_en(struct dsaf_device *dsaf_dev, int mac_id,
 }
 
 /**
- * hns_dsaf_tbl_tcam_init - INT
+ * hns_dsaf_comm_init - INT
  * @dsaf_dev: dsa fabric id
  */
 static void hns_dsaf_comm_init(struct dsaf_device *dsaf_dev)
@@ -2111,7 +2111,7 @@ static void hns_dsaf_free_dev(struct dsaf_device *dsaf_dev)
 }
 
 /**
- * dsaf_pfc_unit_cnt - set pfc unit count
+ * hns_dsaf_pfc_unit_cnt - set pfc unit count
  * @dsaf_dev: dsa fabric id
  * @mac_id: id in use
  * @rate:  value array
@@ -2142,7 +2142,7 @@ static void hns_dsaf_pfc_unit_cnt(struct dsaf_device *dsaf_dev, int  mac_id,
 }
 
 /**
- * dsaf_port_work_rate_cfg - fifo
+ * hns_dsaf_port_work_rate_cfg - fifo
  * @dsaf_dev: dsa fabric id
  * @mac_id: mac contrl block
  * @rate_mode: value array
@@ -2738,7 +2738,7 @@ void hns_dsaf_get_strings(int stringset, u8 *data, int port,
 }
 
 /**
- *hns_dsaf_get_sset_count - get dsaf regs count
+ *hns_dsaf_get_regs_count - get dsaf regs count
  *return dsaf regs count
  */
 int hns_dsaf_get_regs_count(void)
@@ -2949,7 +2949,7 @@ int hns_dsaf_wait_pkt_clean(struct dsaf_device *dsaf_dev, int port)
 }
 
 /**
- * dsaf_probe - probo dsaf dev
+ * hns_dsaf_probe - probo dsaf dev
  * @pdev: dasf platform device
  * return 0 - success , negative --fail
  */
@@ -3004,7 +3004,7 @@ static int hns_dsaf_probe(struct platform_device *pdev)
 }
 
 /**
- * dsaf_remove - remove dsaf dev
+ * hns_dsaf_remove - remove dsaf dev
  * @pdev: dasf platform device
  */
 static int hns_dsaf_remove(struct platform_device *pdev)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
index 1eaac89d60b7..23d9cbf262c3 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -351,7 +351,7 @@ hns_dsaf_srst_chns(struct dsaf_device *dsaf_dev, u32 msk, bool dereset)
 }
 
 /**
- * hns_dsaf_srst_chns - reset dsaf channels
+ * hns_dsaf_srst_chns_acpi - reset dsaf channels
  * @dsaf_dev: dsaf device struct pointer
  * @msk: xbar channels mask value:
  * @dereset: false - request reset , true - drop reset
@@ -501,7 +501,7 @@ static void hns_ppe_com_srst(struct dsaf_device *dsaf_dev, bool dereset)
 }
 
 /**
- * hns_mac_get_sds_mode - get phy ifterface form serdes mode
+ * hns_mac_get_phy_if - get phy ifterface form serdes mode
  * @mac_cb: mac control block
  * retuen phy interface
  */
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c
index ff03cafccb66..a7eb87da4e70 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c
@@ -296,7 +296,7 @@ int hns_ppe_wait_tx_fifo_clean(struct hns_ppe_cb *ppe_cb)
 }
 
 /**
- * ppe_init_hw - init ppe
+ * hns_ppe_init_hw - init ppe
  * @ppe_cb: ppe device
  */
 static void hns_ppe_init_hw(struct hns_ppe_cb *ppe_cb)
@@ -343,7 +343,7 @@ static void hns_ppe_init_hw(struct hns_ppe_cb *ppe_cb)
 }
 
 /**
- * ppe_uninit_hw - uninit ppe
+ * hns_ppe_uninit_hw - uninit ppe
  * @ppe_cb: ppe device
  */
 static void hns_ppe_uninit_hw(struct hns_ppe_cb *ppe_cb)
@@ -382,7 +382,7 @@ void hns_ppe_uninit(struct dsaf_device *dsaf_dev)
 }
 
 /**
- * hns_ppe_reset - reinit ppe/rcb hw
+ * hns_ppe_reset_common - reinit ppe/rcb hw
  * @dsaf_dev: dasf device
  * @ppe_common_index: the index
  * return void
@@ -455,7 +455,7 @@ int hns_ppe_get_regs_count(void)
 }
 
 /**
- * ppe_get_strings - get ppe srting
+ * hns_ppe_get_strings - get ppe srting
  * @ppe_cb: ppe device
  * @stringset: string set type
  * @data: output string
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c
index 5d5dc6942232..e2ff3ca198d1 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c
@@ -913,7 +913,7 @@ int hns_rcb_get_common_regs_count(void)
 }
 
 /**
- *rcb_get_sset_count - rcb ring regs count
+ *hns_rcb_get_ring_regs_count - rcb ring regs count
  *return regs count
  */
 int hns_rcb_get_ring_regs_count(void)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
index be52acd448f9..401fef5f1d07 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c
@@ -104,7 +104,7 @@ static void hns_xgmac_rx_enable(struct mac_driver *drv, u32 value)
 }
 
 /**
- * hns_xgmac_tx_lf_rf_insert - insert lf rf control about xgmac
+ * hns_xgmac_lf_rf_insert - insert lf rf control about xgmac
  * @mac_drv: mac driver
  * @mode: inserf rf or lf
  */
@@ -115,7 +115,7 @@ static void hns_xgmac_lf_rf_insert(struct mac_driver *mac_drv, u32 mode)
 }
 
 /**
- * hns_xgmac__lf_rf_control_init - initial the lf rf control register
+ * hns_xgmac_lf_rf_control_init - initial the lf rf control register
  * @mac_drv: mac driver
  */
 static void hns_xgmac_lf_rf_control_init(struct mac_driver *mac_drv)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 5e349c0bdecc..ad534f9e41ab 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -770,7 +770,7 @@ static u32 smooth_alg(u32 new_param, u32 old_param)
 }
 
 /**
- * hns_nic_adp_coalesce - self adapte coalesce according to rx rate
+ * hns_nic_adpt_coalesce - self adapte coalesce according to rx rate
  * @ring_data: pointer to hns_nic_ring_data
  **/
 static void hns_nic_adpt_coalesce(struct hns_nic_ring_data *ring_data)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index da48c05435ea..7e62dcff2426 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -192,7 +192,7 @@ static int hns_nic_get_link_ksettings(struct net_device *net_dev,
 }
 
 /**
- *hns_nic_set_link_settings - implement ethtool set link ksettings
+ *hns_nic_set_link_ksettings - implement ethtool set link ksettings
  *@net_dev: net_device
  *@cmd: ethtool_link_ksettings
  *retuen 0 - success , negative --fail
@@ -827,7 +827,7 @@ hns_get_channels(struct net_device *net_dev, struct ethtool_channels *ch)
 }
 
 /**
- * get_ethtool_stats - get detail statistics.
+ * hns_get_ethtool_stats - get detail statistics.
  * @netdev: net device
  * @stats: statistics info.
  * @data: statistics data.
@@ -885,7 +885,7 @@ static void hns_get_ethtool_stats(struct net_device *netdev,
 }
 
 /**
- * get_strings: Return a set of strings that describe the requested objects
+ * hns_get_strings: Return a set of strings that describe the requested objects
  * @netdev: net device
  * @stringset: string set ID.
  * @data: objects data.
-- 
2.17.1

