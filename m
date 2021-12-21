Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61B747C623
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241111AbhLUSQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:16:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:10321 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241021AbhLUSQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:16:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110581; x=1671646581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lxy+0Gj3+/XIRylw0qbVrgNSuXyeTNwnwsYuvwTcln4=;
  b=cAq6j9hr2NrbYzSKq+ace9Oe+BmgbJuAyuaiSL0OM8s1TFa/rrI0XQFy
   z09cPdlBgRDudQ8P2bowzp7RjBfDdVpNJpIxS3zEIFedifhImm9TozyDH
   ocBwOmpKqbUPNW60lKdIg97n4j6nh95rOADxfL5Yn3zUHbqLIccRHvsvk
   wU/2crBVwXrKJti5G7prI2rFeCaHksAOzt9iTz4X3eqormSxiTZfENDEP
   NvqLpnkOqwJchi/sPUrzLyONbvAysGTrd2AmTpariFIyGQUODuc5Mb8aD
   mZK1aEBH4RETZBUjmJt+ZnlLPrWQWc3eNnbE8ONZx1i1RF8zjXSp2/RmS
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240684210"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240684210"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 10:02:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="613557832"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 21 Dec 2021 10:02:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net-next 1/8] igc: Remove unused _I_PHY_ID define
Date:   Tue, 21 Dec 2021 10:01:53 -0800
Message-Id: <20211221180200.3176851-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
References: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

_I_PHY_ID not in use. Clean up the code accordingly,
and get rid of the unused define

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index c7fe61509d5b..8b9b7ec20da7 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -605,9 +605,6 @@
 #define PHY_1000T_CTRL		0x09 /* 1000Base-T Control Reg */
 #define PHY_1000T_STATUS	0x0A /* 1000Base-T Status Reg */
 
-/* Bit definitions for valid PHY IDs. I = Integrated E = External */
-#define I225_I_PHY_ID		0x67C9DC00
-
 /* MDI Control */
 #define IGC_MDIC_DATA_MASK	0x0000FFFF
 #define IGC_MDIC_REG_MASK	0x001F0000
-- 
2.31.1

