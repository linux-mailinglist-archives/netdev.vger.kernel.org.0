Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFCD26B9A0
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 04:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgIPCE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 22:04:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12712 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726028AbgIPCE4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 22:04:56 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 21358F54E7C224FF230B;
        Wed, 16 Sep 2020 10:04:55 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Wed, 16 Sep 2020
 10:04:48 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <gustavoars@kernel.org>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH] net: hns: kerneldoc fixes
Date:   Wed, 16 Sep 2020 10:04:28 +0800
Message-ID: <20200916020428.86299-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some parameter description or spelling mistakes.

Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  | 40 +++++++++----------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index 4eb50296f653..14e60c9e491d 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -463,8 +463,8 @@ static int __lb_clean_rings(struct hns_nic_priv *priv,
 
 /**
  * nic_run_loopback_test -  run loopback test
- * @nic_dev: net device
- * @loopback_type: loopback type
+ * @ndev: net device
+ * @loop_mode: loopback mode
  */
 static int __lb_run_test(struct net_device *ndev,
 			 enum hnae_loop loop_mode)
@@ -572,7 +572,7 @@ static int __lb_down(struct net_device *ndev, enum hnae_loop loop)
 
 /**
  * hns_nic_self_test - self test
- * @dev: net device
+ * @ndev: net device
  * @eth_test: test cmd
  * @data: test result
  */
@@ -633,7 +633,7 @@ static void hns_nic_self_test(struct net_device *ndev,
 
 /**
  * hns_nic_get_drvinfo - get net driver info
- * @dev: net device
+ * @net_dev: net device
  * @drvinfo: driver info
  */
 static void hns_nic_get_drvinfo(struct net_device *net_dev,
@@ -658,7 +658,7 @@ static void hns_nic_get_drvinfo(struct net_device *net_dev,
 
 /**
  * hns_get_ringparam - get ring parameter
- * @dev: net device
+ * @net_dev: net device
  * @param: ethtool parameter
  */
 static void hns_get_ringparam(struct net_device *net_dev,
@@ -683,7 +683,7 @@ static void hns_get_ringparam(struct net_device *net_dev,
 
 /**
  * hns_get_pauseparam - get pause parameter
- * @dev: net device
+ * @net_dev: net device
  * @param: pause parameter
  */
 static void hns_get_pauseparam(struct net_device *net_dev,
@@ -701,7 +701,7 @@ static void hns_get_pauseparam(struct net_device *net_dev,
 
 /**
  * hns_set_pauseparam - set pause parameter
- * @dev: net device
+ * @net_dev: net device
  * @param: pause parameter
  *
  * Return 0 on success, negative on failure
@@ -725,7 +725,7 @@ static int hns_set_pauseparam(struct net_device *net_dev,
 
 /**
  * hns_get_coalesce - get coalesce info.
- * @dev: net device
+ * @net_dev: net device
  * @ec: coalesce info.
  *
  * Return 0 on success, negative on failure.
@@ -769,7 +769,7 @@ static int hns_get_coalesce(struct net_device *net_dev,
 
 /**
  * hns_set_coalesce - set coalesce info.
- * @dev: net device
+ * @net_dev: net device
  * @ec: coalesce info.
  *
  * Return 0 on success, negative on failure.
@@ -808,7 +808,7 @@ static int hns_set_coalesce(struct net_device *net_dev,
 
 /**
  * hns_get_channels - get channel info.
- * @dev: net device
+ * @net_dev: net device
  * @ch: channel info.
  */
 static void
@@ -825,7 +825,7 @@ hns_get_channels(struct net_device *net_dev, struct ethtool_channels *ch)
 
 /**
  * get_ethtool_stats - get detail statistics.
- * @dev: net device
+ * @netdev: net device
  * @stats: statistics info.
  * @data: statistics data.
  */
@@ -883,8 +883,8 @@ static void hns_get_ethtool_stats(struct net_device *netdev,
 
 /**
  * get_strings: Return a set of strings that describe the requested objects
- * @dev: net device
- * @stats: string set ID.
+ * @netdev: net device
+ * @stringset: string set ID.
  * @data: objects data.
  */
 static void hns_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
@@ -972,7 +972,7 @@ static void hns_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 
 /**
  * nic_get_sset_count - get string set count witch returned by nic_get_strings.
- * @dev: net device
+ * @netdev: net device
  * @stringset: string set index, 0: self test string; 1: statistics string.
  *
  * Return string set count.
@@ -1006,7 +1006,7 @@ static int hns_get_sset_count(struct net_device *netdev, int stringset)
 
 /**
  * hns_phy_led_set - set phy LED status.
- * @dev: net device
+ * @netdev: net device
  * @value: LED state.
  *
  * Return 0 on success, negative on failure.
@@ -1028,7 +1028,7 @@ static int hns_phy_led_set(struct net_device *netdev, int value)
 
 /**
  * nic_set_phys_id - set phy identify LED.
- * @dev: net device
+ * @netdev: net device
  * @state: LED state.
  *
  * Return 0 on success, negative on failure.
@@ -1104,9 +1104,9 @@ hns_set_phys_id(struct net_device *netdev, enum ethtool_phys_id_state state)
 
 /**
  * hns_get_regs - get net device register
- * @dev: net device
+ * @net_dev: net device
  * @cmd: ethtool cmd
- * @date: register data
+ * @data: register data
  */
 static void hns_get_regs(struct net_device *net_dev, struct ethtool_regs *cmd,
 			 void *data)
@@ -1126,7 +1126,7 @@ static void hns_get_regs(struct net_device *net_dev, struct ethtool_regs *cmd,
 
 /**
  * nic_get_regs_len - get total register len.
- * @dev: net device
+ * @net_dev: net device
  *
  * Return total register len.
  */
@@ -1151,7 +1151,7 @@ static int hns_get_regs_len(struct net_device *net_dev)
 
 /**
  * hns_nic_nway_reset - nway reset
- * @dev: net device
+ * @netdev: net device
  *
  * Return 0 on success, negative on failure
  */
-- 
2.17.1

