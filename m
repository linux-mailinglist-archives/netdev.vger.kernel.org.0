Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B1CDD0EB
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 23:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506112AbfJRVNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 17:13:44 -0400
Received: from mga07.intel.com ([134.134.136.100]:17949 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408295AbfJRVNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 17:13:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 14:13:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,313,1566889200"; 
   d="scan'208";a="208752586"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 18 Oct 2019 14:13:42 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 1/5] igc: Add SCTP CRC checksumming functionality
Date:   Fri, 18 Oct 2019 14:13:36 -0700
Message-Id: <20191018211340.31885-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191018211340.31885-1-jeffrey.t.kirsher@intel.com>
References: <20191018211340.31885-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add stream control transmission protocol CRC checksum.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 63b62d74f961..69e70b297e85 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4211,6 +4211,7 @@ static int igc_probe(struct pci_dev *pdev,
 
 	/* Add supported features to the features list*/
 	netdev->features |= NETIF_F_HW_CSUM;
+	netdev->features |= NETIF_F_SCTP_CRC;
 
 	/* setup the private structure */
 	err = igc_sw_init(adapter);
-- 
2.21.0

