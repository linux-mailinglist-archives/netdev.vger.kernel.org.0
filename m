Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F5A26569E
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 03:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgIKBYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 21:24:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:51454 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgIKBXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 21:23:55 -0400
IronPort-SDR: 0rFyhXAJG/i0UcS2J7an4gsh6WUKuE0dzBepedqZEVniQrYndQTSQvali5W3iQNNkX0iIxhRsQ
 KcZvYxEoo03w==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="243491825"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="243491825"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:45 -0700
IronPort-SDR: dwcZvbit3yhOvd4Ktbr+yahrN//epTeYelfVCjaoVRA7LyxV3AUFeeGVePNuo3P1dQjPpNGt57
 vg3y/+i9NqdA==
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="449808137"
Received: from jbrandeb-desk.jf.intel.com ([10.166.244.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:44 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [RFC PATCH net-next v1 03/11] iavf: clean up W=1 warnings in iavf
Date:   Thu, 10 Sep 2020 18:23:29 -0700
Message-Id: <20200911012337.14015-4-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200911012337.14015-1-jesse.brandeburg@intel.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inspired by Lee Jones, this eliminates the remaining W=1 warnings
in iavf.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 24 ++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index d870343cf689..814e59bf2c94 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -147,6 +147,7 @@ void iavf_schedule_reset(struct iavf_adapter *adapter)
 /**
  * iavf_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
+ * @txqueue: queue number that is timing out
  **/
 static void iavf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 {
@@ -2572,8 +2573,8 @@ static int iavf_validate_ch_config(struct iavf_adapter *adapter,
 }
 
 /**
- * iavf_del_all_cloud_filters - delete all cloud filters
- * on the traffic classes
+ * iavf_del_all_cloud_filters - delete all cloud filters on the traffic classes
+ * @adapter: board private structure
  **/
 static void iavf_del_all_cloud_filters(struct iavf_adapter *adapter)
 {
@@ -2592,7 +2593,7 @@ static void iavf_del_all_cloud_filters(struct iavf_adapter *adapter)
 /**
  * __iavf_setup_tc - configure multiple traffic classes
  * @netdev: network interface device structure
- * @type_date: tc offload data
+ * @type_data: tc offload data
  *
  * This function processes the config information provided by the
  * user to configure traffic classes/queue channels and packages the
@@ -2690,7 +2691,7 @@ static int __iavf_setup_tc(struct net_device *netdev, void *type_data)
 /**
  * iavf_parse_cls_flower - Parse tc flower filters provided by kernel
  * @adapter: board private structure
- * @cls_flower: pointer to struct flow_cls_offload
+ * @f: pointer to struct flow_cls_offload
  * @filter: pointer to cloud filter structure
  */
 static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
@@ -3064,8 +3065,8 @@ static int iavf_delete_clsflower(struct iavf_adapter *adapter,
 
 /**
  * iavf_setup_tc_cls_flower - flower classifier offloads
- * @netdev: net device to configure
- * @type_data: offload data
+ * @adapter: board private structure
+ * @cls_flower: pointer to flow_cls_offload struct with flow info
  */
 static int iavf_setup_tc_cls_flower(struct iavf_adapter *adapter,
 				    struct flow_cls_offload *cls_flower)
@@ -3112,7 +3113,7 @@ static LIST_HEAD(iavf_block_cb_list);
  * iavf_setup_tc - configure multiple traffic classes
  * @netdev: network interface device structure
  * @type: type of offload
- * @type_date: tc offload data
+ * @type_data: tc offload data
  *
  * This function is the callback to ndo_setup_tc in the
  * netdev_ops.
@@ -3768,8 +3769,7 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 /**
  * iavf_suspend - Power management suspend routine
- * @pdev: PCI device information struct
- * @state: unused
+ * @dev_d: device info pointer
  *
  * Called when the system (VM) is entering sleep/suspend.
  **/
@@ -3799,15 +3799,15 @@ static int __maybe_unused iavf_suspend(struct device *dev_d)
 
 /**
  * iavf_resume - Power management resume routine
- * @pdev: PCI device information struct
+ * @dev_d: device info pointer
  *
  * Called when the system (VM) is resumed from sleep/suspend.
  **/
 static int __maybe_unused iavf_resume(struct device *dev_d)
 {
+	struct net_device *netdev = dev_get_drvdata(dev_d);
+	struct iavf_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev_d);
-	struct iavf_adapter *adapter = pci_get_drvdata(pdev);
-	struct net_device *netdev = adapter->netdev;
 	u32 err;
 
 	pci_set_master(pdev);
-- 
2.27.0

