Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569631D8A98
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgERWRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:17:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:58882 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgERWRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 18:17:00 -0400
IronPort-SDR: OzXkG9B9S9lLB3ssGfLQYtolJYMUZpec9Bk7muPQrEh8Zh/aSm6t3VD3kA6VQf0iQb8LcEwYVB
 1gdGBOAew7DQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 15:16:59 -0700
IronPort-SDR: El6IBmUB0b6UCv9RLds0rLNOVDPZlJ5G01BB/gsw3KENFjzVUdAq7+sd+K4P6zStKAMdU9moHR
 2AatU+hUDrpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="439387796"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 18 May 2020 15:16:59 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v4 1/9] igc: Add ECN support for TSO
Date:   Mon, 18 May 2020 15:16:49 -0700
Message-Id: <20200518221657.1420070-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518221657.1420070-1-jeffrey.t.kirsher@intel.com>
References: <20200518221657.1420070-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Align with other Intel drivers and add ECN support for TSO.

Add NETIF_F_TSO_ECN flag

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9d5f8287c704..7556fcdf1fd7 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4838,6 +4838,7 @@ static int igc_probe(struct pci_dev *pdev,
 	netdev->features |= NETIF_F_SG;
 	netdev->features |= NETIF_F_TSO;
 	netdev->features |= NETIF_F_TSO6;
+	netdev->features |= NETIF_F_TSO_ECN;
 	netdev->features |= NETIF_F_RXCSUM;
 	netdev->features |= NETIF_F_HW_CSUM;
 	netdev->features |= NETIF_F_SCTP_CRC;
-- 
2.26.2

