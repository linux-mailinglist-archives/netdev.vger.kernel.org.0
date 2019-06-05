Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06F0D36567
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfFEUXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:23:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:4309 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbfFEUXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 16:23:47 -0400
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
Subject: [net-next 10/15] i40e: Use LLDP ethertype define ETH_P_LLDP
Date:   Wed,  5 Jun 2019 13:23:53 -0700
Message-Id: <20190605202358.2767-11-jeffrey.t.kirsher@intel.com>
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

Remove references to I40E_ETH_P_LLDP and use ETH_P_LLDP instead.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h         | 2 --
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 7ce42040b851..8dc98d1d2e86 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -295,8 +295,6 @@ struct i40e_cloud_filter {
 	u8 tunnel_type;
 };
 
-#define I40E_ETH_P_LLDP			0x88cc
-
 #define I40E_DCB_PRIO_TYPE_STRICT	0
 #define I40E_DCB_PRIO_TYPE_ETS		1
 #define I40E_DCB_STRICT_PRIO_CREDITS	127
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 7ea4f09229e4..dc5b40013e61 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -1330,7 +1330,7 @@ static ssize_t i40e_dbg_command_write(struct file *filp,
 			}
 			ret = i40e_aq_add_rem_control_packet_filter(&pf->hw,
 						pf->hw.mac.addr,
-						I40E_ETH_P_LLDP, 0,
+						ETH_P_LLDP, 0,
 						pf->vsi[pf->lan_vsi]->seid,
 						0, true, NULL, NULL);
 			if (ret) {
@@ -1348,7 +1348,7 @@ static ssize_t i40e_dbg_command_write(struct file *filp,
 
 			ret = i40e_aq_add_rem_control_packet_filter(&pf->hw,
 						pf->hw.mac.addr,
-						I40E_ETH_P_LLDP, 0,
+						ETH_P_LLDP, 0,
 						pf->vsi[pf->lan_vsi]->seid,
 						0, false, NULL, NULL);
 			if (ret) {
-- 
2.21.0

