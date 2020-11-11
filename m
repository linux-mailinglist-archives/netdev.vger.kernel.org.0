Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC802AE4D6
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731984AbgKKAU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:20:27 -0500
Received: from mga17.intel.com ([192.55.52.151]:17132 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgKKAU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 19:20:27 -0500
IronPort-SDR: 5CDq2jAYYcSUpNLVWzJxSkMakI8NLgOmh9PF5vu8HbAqFnua71rCGOJ1XYYukefCzQrnL8Sp6g
 ZN0dbMloTZ3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="149921005"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="149921005"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 16:20:26 -0800
IronPort-SDR: NAcy4HrQv4RSd6KD/PklsUXkPpIPXlFdhEq153OP8bg6WoifoHNhamuDpJIGXOeeeqcEWsGfVP
 Jjuq4b1E2bOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="366049060"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 10 Nov 2020 16:20:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [net 4/4] MAINTAINERS: Update repositories for Intel Ethernet Drivers
Date:   Tue, 10 Nov 2020 16:19:55 -0800
Message-Id: <20201111001955.533210-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201111001955.533210-1-anthony.l.nguyen@intel.com>
References: <20201111001955.533210-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update Intel Ethernet Drivers repositories to new locations.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cd123d0a6a2d..9e826b55fcd9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8829,8 +8829,8 @@ S:	Supported
 W:	http://www.intel.com/support/feedback.htm
 W:	http://e1000.sourceforge.net/
 Q:	http://patchwork.ozlabs.org/project/intel-wired-lan/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git
 F:	Documentation/networking/device_drivers/ethernet/intel/
 F:	drivers/net/ethernet/intel/
 F:	drivers/net/ethernet/intel/*/
-- 
2.26.2

