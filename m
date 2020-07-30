Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAF9233633
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 18:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbgG3QBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 12:01:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:60128 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgG3QBD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 12:01:03 -0400
IronPort-SDR: VIsPyKo+Q60oNdsVDTr5tPkfPuHAdlBOuuy8GUYCwi+RWvdPJsdpfwzEn817o1JaDphjKY5RNC
 qm/kqBQTscuw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="152848809"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="152848809"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 09:01:02 -0700
IronPort-SDR: gfx8tIYtKjAhwfsl5EmTqxGaf/+QtqZe1PBIygOC1E3DGx4/zwasOt/EOyQOU4s5vRqsZ66fLa
 yhOr0uNwYvag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="286900259"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 30 Jul 2020 09:00:59 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id EC11F119; Thu, 30 Jul 2020 19:00:58 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        Alexander Lobakin <alobakin@marvell.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] qede: Use %pM format specifier for MAC addresses
Date:   Thu, 30 Jul 2020 19:00:57 +0300
Message-Id: <20200730160057.40569-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to %pM instead of using custom code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 1aaae3203f5a..4250c17940c0 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -144,9 +144,7 @@ static int qede_set_vf_mac(struct net_device *ndev, int vfidx, u8 *mac)
 {
 	struct qede_dev *edev = netdev_priv(ndev);
 
-	DP_VERBOSE(edev, QED_MSG_IOV,
-		   "Setting MAC %02x:%02x:%02x:%02x:%02x:%02x to VF [%d]\n",
-		   mac[0], mac[1], mac[2], mac[3], mac[4], mac[5], vfidx);
+	DP_VERBOSE(edev, QED_MSG_IOV, "Setting MAC %pM to VF [%d]\n", mac, vfidx);
 
 	if (!is_valid_ether_addr(mac)) {
 		DP_VERBOSE(edev, QED_MSG_IOV, "MAC address isn't valid\n");
-- 
2.27.0

