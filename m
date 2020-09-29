Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DAB27D9C8
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgI2VM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:12:28 -0400
Received: from mga14.intel.com ([192.55.52.115]:54447 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbgI2VM2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 17:12:28 -0400
IronPort-SDR: 3dEr0sMbTn1I0XkRG8h/j2heN4bteLFrg2/YWHMv19HNtn+I/WxJjDicITOgIpz2NCTxQxHqmW
 Ehqc+BdADZ5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="161509720"
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="161509720"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 14:12:28 -0700
IronPort-SDR: zCi+B0/rDYJHWF4myKyBJj9fja1tggU85LOswQIBZuEOZJ7HdQvvdwcCTyEw+575DdCKBEpRoY
 aQMaDUvPVMOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="293809543"
Received: from unknown (HELO localhost.jf.intel.com) ([10.166.244.129])
  by fmsmga007.fm.intel.com with ESMTP; 29 Sep 2020 14:12:27 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com
Subject: [PATCH net 1/1] MAINTAINERS: Update MAINTAINERS for Intel ethernet drivers
Date:   Tue, 29 Sep 2020 14:06:18 -0700
Message-Id: <20200929210618.51987-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Jesse Brandeburg and myself; remove Jeff Kirsher.

CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dc9ebf5bf76..eb45c9fdeb21 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8752,7 +8752,8 @@ F:	include/drm/i915*
 F:	include/uapi/drm/i915_drm.h
 
 INTEL ETHERNET DRIVERS
-M:	Jeff Kirsher <jeffrey.t.kirsher@intel.com>
+M:	Jesse Brandeburg <jesse.brandeburg@intel.com>
+M:	Tony Nguyen <anthony.l.nguyen@intel.com>
 L:	intel-wired-lan@lists.osuosl.org (moderated for non-subscribers)
 S:	Supported
 W:	http://www.intel.com/support/feedback.htm
-- 
2.20.1

