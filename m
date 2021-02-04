Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009E630E8EF
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhBDAuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:50:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:40021 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234464AbhBDAnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:43:12 -0500
IronPort-SDR: +ntW3wFuE14yHIsD7eMu1EMJ4PNCekHBi7sYuR8SwXgyX7qVgFeo2aUAHEeOsC1ASgzuVSJjzy
 PBPHTdGUE5tw==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="177638231"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="177638231"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 16:42:13 -0800
IronPort-SDR: 4O6ZpMLYjINZY+lV6Z0Ncp67uw0RlTl8haoq/6nMvPZHFK04awUa7n8cnC5T8cX6xkTEAg98bs
 nqM5FD30Yp4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="579687500"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 03 Feb 2021 16:42:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 08/15] igc: Remove unused local receiver mask
Date:   Wed,  3 Feb 2021 16:42:52 -0800
Message-Id: <20210204004259.3662059-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
References: <20210204004259.3662059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Local receiver mask SR_1000T_LOCAL_RX_STATUS not in use in i225 device
and could be removed

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 4b7251d0c4e1..5286047ff914 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -129,7 +129,6 @@
 
 /* 1000BASE-T Status Register */
 #define SR_1000T_REMOTE_RX_STATUS	0x1000 /* Remote receiver OK */
-#define SR_1000T_LOCAL_RX_STATUS	0x2000 /* Local receiver OK */
 
 /* PHY GPY 211 registers */
 #define STANDARD_AN_REG_MASK	0x0007 /* MMD */
-- 
2.26.2

