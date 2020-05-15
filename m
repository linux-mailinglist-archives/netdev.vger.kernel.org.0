Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D502D1D445D
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 06:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgEOEVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 00:21:42 -0400
Received: from mga18.intel.com ([134.134.136.126]:35149 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgEOEVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 00:21:41 -0400
IronPort-SDR: 3RsZEHK41d7OPBsE89JV2Wdh6YxdmyqRqcNYW4EwD4FJNPF7I4YJXGDqUTq6gnMQLoP8cqxH+J
 Xv5MOjAy0kqw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 21:21:41 -0700
IronPort-SDR: c23DZRZlP0XP1eohgS33kaExdnE1bZ2FZhf/7RkWBW1S8OeTAZfORp3ja/dOTmG3bvM/2iKWNh
 Ft39enyez/KQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,393,1583222400"; 
   d="scan'208";a="263066063"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 14 May 2020 21:21:40 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 1/9] igc: Add ECN support for TSO
Date:   Thu, 14 May 2020 21:21:31 -0700
Message-Id: <20200515042139.749859-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515042139.749859-1-jeffrey.t.kirsher@intel.com>
References: <20200515042139.749859-1-jeffrey.t.kirsher@intel.com>
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

