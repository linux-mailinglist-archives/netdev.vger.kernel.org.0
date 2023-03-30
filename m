Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8408C6D0C1C
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbjC3RCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbjC3RCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:02:08 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB67903F;
        Thu, 30 Mar 2023 10:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680195726; x=1711731726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R/ssDChJFeElkuFAdv0HOzsNHaITs0Wd/hQ8EL6X4I4=;
  b=Rf7+5x0AB0oi77yIdUtaKgkkLE7yO6vr1k2V3U9xRYSrdIR2tH4JDYgV
   UnkX/SETtW3X4FUMw1C/Ia4wAgbMyYl/cie3r+4Lk3jgbPleECr8qwCIQ
   dKk/1LY9S+2DqNyuBgF0kWrGdVXwjCGrUJ6DHmhFcBp2Pnkxa6s+aud9m
   Tw1wHRK7DlzXTPnzlHpDulQaUnjQ5prKukei7/IKK3LXLRg5DhKvWdYrg
   qQf7B/3glL2pYEuQKvLfD4kwKwPeTyT0a+XCXcs0p+MrEJdMA/6AX1ujx
   p8iz+AwyCf1T8jsVWUowePTIsEC0WKdq77S/PHfN1TGyLSv+VPemIjju/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="329747476"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="329747476"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 10:01:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="687317627"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="687317627"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 30 Mar 2023 10:01:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, corbet@lwn.net,
        linux-doc@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next 1/3] Documentation/eth/intel: Update address for driver support
Date:   Thu, 30 Mar 2023 09:59:33 -0700
Message-Id: <20230330165935.2503604-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230330165935.2503604-1-anthony.l.nguyen@intel.com>
References: <20230330165935.2503604-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the email address for support to use Intel Wired LAN, the mailing
list used for kernel development.

Suggested-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 Documentation/networking/device_drivers/ethernet/intel/e100.rst | 2 +-
 .../networking/device_drivers/ethernet/intel/e1000.rst          | 2 +-
 .../networking/device_drivers/ethernet/intel/e1000e.rst         | 2 +-
 .../networking/device_drivers/ethernet/intel/fm10k.rst          | 2 +-
 Documentation/networking/device_drivers/ethernet/intel/i40e.rst | 2 +-
 Documentation/networking/device_drivers/ethernet/intel/iavf.rst | 2 +-
 Documentation/networking/device_drivers/ethernet/intel/ice.rst  | 2 +-
 Documentation/networking/device_drivers/ethernet/intel/igb.rst  | 2 +-
 .../networking/device_drivers/ethernet/intel/igbvf.rst          | 2 +-
 .../networking/device_drivers/ethernet/intel/ixgbe.rst          | 2 +-
 .../networking/device_drivers/ethernet/intel/ixgbevf.rst        | 2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/intel/e100.rst b/Documentation/networking/device_drivers/ethernet/intel/e100.rst
index 371b7e5c3293..4f613949782c 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/e100.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/e100.rst
@@ -184,4 +184,4 @@ or the Intel Wired Networking project hosted by Sourceforge at:
 http://sourceforge.net/projects/e1000
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
-to e1000-devel@lists.sf.net.
+to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/e1000.rst b/Documentation/networking/device_drivers/ethernet/intel/e1000.rst
index 4aaae0f7d6ba..7b15b8c72be0 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/e1000.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/e1000.rst
@@ -460,4 +460,4 @@ or the Intel Wired Networking project hosted by Sourceforge at:
 
 If an issue is identified with the released source code on the supported
 kernel with a supported adapter, email the specific information related
-to the issue to e1000-devel@lists.sf.net
+to the issue to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst b/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
index f49cd370e7bf..7a9cbfa9e0f3 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
@@ -380,4 +380,4 @@ https://sourceforge.net/projects/e1000
 
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
-to e1000-devel@lists.sf.net.
+to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/fm10k.rst b/Documentation/networking/device_drivers/ethernet/intel/fm10k.rst
index 9258ef6f515c..9d9c2ec2152e 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/fm10k.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/fm10k.rst
@@ -139,4 +139,4 @@ https://sourceforge.net/projects/e1000
 
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
-to e1000-devel@lists.sf.net.
+to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
index c495c4e16b3b..5b13fe0fec82 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
@@ -768,4 +768,4 @@ https://sourceforge.net/projects/e1000
 
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
-to e1000-devel@lists.sf.net.
+to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/iavf.rst b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
index 151af0a8da9c..079847666125 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
@@ -328,4 +328,4 @@ https://sourceforge.net/projects/e1000
 
 If an issue is identified with the released source code on the supported kernel
 with a supported adapter, email the specific information related to the issue
-to e1000-devel@lists.sf.net
+to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/ice.rst b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
index 2b6dc7880d7b..246bf6455f64 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ice.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
@@ -1031,7 +1031,7 @@ https://sourceforge.net/projects/e1000
 
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
-to e1000-devel@lists.sf.net.
+to intel-wired-lan@lists.osuosl.org.
 
 
 Trademarks
diff --git a/Documentation/networking/device_drivers/ethernet/intel/igb.rst b/Documentation/networking/device_drivers/ethernet/intel/igb.rst
index d46289e182cf..ee149bdb42b9 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/igb.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/igb.rst
@@ -210,4 +210,4 @@ https://sourceforge.net/projects/e1000
 
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
-to e1000-devel@lists.sf.net.
+to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/igbvf.rst b/Documentation/networking/device_drivers/ethernet/intel/igbvf.rst
index 40fa210c5e14..78ceb3cdbfdb 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/igbvf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/igbvf.rst
@@ -62,4 +62,4 @@ https://sourceforge.net/projects/e1000
 
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
-to e1000-devel@lists.sf.net.
+to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst b/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
index 0a233b17c664..8d4f7ede2ff8 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
@@ -554,4 +554,4 @@ https://sourceforge.net/projects/e1000
 
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
-to e1000-devel@lists.sf.net.
+to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/ixgbevf.rst b/Documentation/networking/device_drivers/ethernet/intel/ixgbevf.rst
index 76bbde736f21..9201c74e4c36 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ixgbevf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ixgbevf.rst
@@ -64,4 +64,4 @@ https://sourceforge.net/projects/e1000
 
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
-to e1000-devel@lists.sf.net.
+to intel-wired-lan@lists.osuosl.org.
-- 
2.38.1

