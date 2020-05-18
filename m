Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48E01D8A9E
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgERWRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:17:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:58887 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728372AbgERWRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 18:17:09 -0400
IronPort-SDR: nRUD9VI1zj4w8SuI8npo4SmqcTVvmHkCBaLzeAQS8MYnDy5oBA+2vPnsoRBU4XyIZ9zSwVdVed
 MiljkldBJKAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 15:16:59 -0700
IronPort-SDR: ZemnwKhtTEQhhdXNk0/AYWalKiBsi8krJmk6n7NKs6XkWmv0GxBNSGycgFv0HbypzzeYlqmYM4
 wfFoFEQepKPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="439387820"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 18 May 2020 15:16:59 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v4 9/9] igc: Remove unneeded register
Date:   Mon, 18 May 2020 15:16:57 -0700
Message-Id: <20200518221657.1420070-10-jeffrey.t.kirsher@intel.com>
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

Flow control status register not applicable for i225 parts
so clean up the unneeded define.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_regs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 633545977a65..5a6110e211fd 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -35,7 +35,6 @@
 #define IGC_FCRTL		0x02160  /* FC Receive Threshold Low - RW */
 #define IGC_FCRTH		0x02168  /* FC Receive Threshold High - RW */
 #define IGC_FCRTV		0x02460  /* FC Refresh Timer Value - RW */
-#define IGC_FCSTS		0x02464  /* FC Status - RO */
 
 /* PCIe Register Description */
 #define IGC_GCR			0x05B00  /* PCIe control- RW */
-- 
2.26.2

