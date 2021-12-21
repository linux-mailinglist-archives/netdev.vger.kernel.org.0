Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA7047C624
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241105AbhLUSQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:16:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:10323 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236770AbhLUSQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:16:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110581; x=1671646581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L8pBCtO6mVkQ0Caci/lPGSF1UpgQEUhwSSftcXGWGyA=;
  b=jkDlLK0TJjLg+ZbrebX2vMXX6AIyzVeRWZWqyCm4SkeRsURRPN9g4oUs
   QDBrQ1eSYcP2LPygxJAmpC+Tn2RX9+FelSLFiPEegALkWDVlp42kZTOba
   cyuHOSAVG7/iAwz/s1nlVrURb9mdrgiAoIHvqS6OymTFXpCVZC9WbSIIF
   mSMWZMsIRRRYUzYkohA7/N+i9XKYQAQtYv/XBznLgtCffUGx0ByR425xL
   JEslFpNe+lgtLmDz+2X2wWiW6x2Hj11vLHPiiuM71qUxAOABOXlI6U0lC
   uqZ8f6nNIhEYfUkF7h1EJD17l7rIM1b164KS6gBDofhvuww7NHlZ1eJcZ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240684211"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240684211"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 10:02:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="613557836"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 21 Dec 2021 10:02:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Paul Menzel <pmenzel@molgen.mpg.de>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net-next 2/8] igc: Remove unused phy type
Date:   Tue, 21 Dec 2021 10:01:54 -0800
Message-Id: <20211221180200.3176851-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
References: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

_phy_none type not in use. Clean up the code accordingly,
and get rid of the unused enum line

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_hw.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 587db7483f25..76832e55cbbb 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -55,7 +55,6 @@ enum igc_mac_type {
 
 enum igc_phy_type {
 	igc_phy_unknown = 0,
-	igc_phy_none,
 	igc_phy_i225,
 };
 
-- 
2.31.1

