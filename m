Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B6830E8C5
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhBDAoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:44:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:40026 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234488AbhBDAna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:43:30 -0500
IronPort-SDR: 6d9adVLgwVxaw9PoKZ0NMj74bpaHClB1P7zH+fqcWTqvDQXqL9WQkT5ta+mbB9/dMB5OqiUV4w
 Wya+KI6JTVaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638226"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638226"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:13 -0800
IronPort-SDR: F/106Ule2nmgHFfuyKCr9CXALfjGkzRuzvi6Bf9wc5i5eLqViyjkkamUgGCU4PaUC6vE37HHOP
 GHXmV0shcGmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687487"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 04/15] igc: Add Host Good Packets Transmitted Count
Date:   Wed,  3 Feb 2021 16:42:48 -0800
Message-Id: <20210204004259.3662059-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

This counter counts the number of good (non-erred) packets
transmitted sent by the host.
A good transmit packet is considered one that is 64 or more bytes
in length (from <Destination Address> through <CRC>,
inclusively) in length

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 43aec42e6d9d..e26ec0c82271 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3674,6 +3674,7 @@ void igc_update_stats(struct igc_adapter *adapter)
 	adapter->stats.prc1522 += rd32(IGC_PRC1522);
 	adapter->stats.tlpic += rd32(IGC_TLPIC);
 	adapter->stats.rlpic += rd32(IGC_RLPIC);
+	adapter->stats.hgptc += rd32(IGC_HGPTC);
 
 	mpc = rd32(IGC_MPC);
 	adapter->stats.mpc += mpc;
-- 
2.26.2

