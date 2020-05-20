Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C721DA603
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 02:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgETAEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 20:04:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:15427 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbgETAEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 20:04:32 -0400
IronPort-SDR: E3DaZWihTaWJl+xzseaS8McUI/DFXzMd+YwimderGpvsB7qOh2+auf6TnU9OtTLKU+Joqcmbu1
 qjcJSWWPQurQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 17:04:22 -0700
IronPort-SDR: 9ostQLo+rVblISwBUzjy1k13isj66JAjj37+5n3FKGV/aLLgzEl/mq9+WnCxrHV6/Ghb4fN1kq
 BUgy8RWIe6RQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466324768"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 17:04:22 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/14] igc: Dump VLANPQF register
Date:   Tue, 19 May 2020 17:04:10 -0700
Message-Id: <20200520000419.1595788-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

This patch adds the VLAN Priority Queue Filter Register (VLANPQF) to the
list of registers dumped by igc_get_regs().

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index c21971b40cb2..19da9dc8dafb 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -316,6 +316,8 @@ static void igc_get_regs(struct net_device *netdev,
 		regs_buff[172 + i] = rd32(IGC_RAL(i));
 	for (i = 0; i < 16; i++)
 		regs_buff[188 + i] = rd32(IGC_RAH(i));
+
+	regs_buff[204] = rd32(IGC_VLANPQF);
 }
 
 static void igc_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
-- 
2.26.2

