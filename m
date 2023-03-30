Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FFD6D0C1B
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbjC3RCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbjC3RCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:02:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8A486AB;
        Thu, 30 Mar 2023 10:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680195726; x=1711731726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sp9gj3Dkpqtvy8eOqrwRYLa69QAUsnMwS3RK/vBFyEo=;
  b=US1Le3eupjVTSDaFhISFPDzCs/7qb8b48LbrQqz6mhFWfICfp0WJlGmD
   1ZyQN1AnoXRQ1zPCpqK2mhBksAGJKeYT1kSS3IJbL7TQG7FOw/ANK7yRC
   M5ho8To3kMSmhNN3MA5tz+UCOxzBDcYVzioIPXoX/F+IG4drYMfPswFTq
   XM1FrSVB2volhcYEdEZTpQLOmGcQFkZZnDH5SLhPnZvbfUwej3TSxH32i
   dJa4akGFQPmHFIJIJdyv6NZ35l7wUoHi5Flp7S4ucgZ+dfcu93wwfaD4x
   FDBlxGhT5h85ZfYRmgRaQBdYKI4ZKorIeY1J3wmPKId1ZinzQnpcfA/fk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="329747484"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="329747484"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 10:01:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="687317631"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="687317631"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 30 Mar 2023 10:01:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, corbet@lwn.net,
        linux-doc@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next 2/3] Documentation/eth/intel: Remove references to SourceForge
Date:   Thu, 30 Mar 2023 09:59:34 -0700
Message-Id: <20230330165935.2503604-3-anthony.l.nguyen@intel.com>
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

The out-of-tree driver is hosted on SourceForge, as this does not apply
to the kernel driver remove references to it. Also do some minor
formatting changes around this section.

Suggested-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 .../networking/device_drivers/ethernet/intel/e100.rst      | 2 --
 .../networking/device_drivers/ethernet/intel/e1000.rst     | 7 +------
 .../networking/device_drivers/ethernet/intel/e1000e.rst    | 5 -----
 .../networking/device_drivers/ethernet/intel/fm10k.rst     | 5 -----
 .../networking/device_drivers/ethernet/intel/i40e.rst      | 5 -----
 .../networking/device_drivers/ethernet/intel/iavf.rst      | 5 -----
 .../networking/device_drivers/ethernet/intel/ice.rst       | 3 ---
 .../networking/device_drivers/ethernet/intel/igb.rst       | 5 -----
 .../networking/device_drivers/ethernet/intel/igbvf.rst     | 5 -----
 .../networking/device_drivers/ethernet/intel/ixgbe.rst     | 5 -----
 .../networking/device_drivers/ethernet/intel/ixgbevf.rst   | 5 -----
 11 files changed, 1 insertion(+), 51 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/intel/e100.rst b/Documentation/networking/device_drivers/ethernet/intel/e100.rst
index 4f613949782c..5dee1b53e977 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/e100.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/e100.rst
@@ -180,8 +180,6 @@ Support
 For general information, go to the Intel support website at:
 https://www.intel.com/support/
 
-or the Intel Wired Networking project hosted by Sourceforge at:
-http://sourceforge.net/projects/e1000
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
 to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/e1000.rst b/Documentation/networking/device_drivers/ethernet/intel/e1000.rst
index 7b15b8c72be0..52a7fb9ce8d9 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/e1000.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/e1000.rst
@@ -451,12 +451,7 @@ Support
 =======
 
 For general information, go to the Intel support website at:
-
-    http://support.intel.com
-
-or the Intel Wired Networking project hosted by Sourceforge at:
-
-    http://sourceforge.net/projects/e1000
+http://support.intel.com
 
 If an issue is identified with the released source code on the supported
 kernel with a supported adapter, email the specific information related
diff --git a/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst b/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
index 7a9cbfa9e0f3..d8f810afdd49 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
@@ -371,13 +371,8 @@ NOTE: Wake on LAN is only supported on port A for the following devices:
 Support
 =======
 For general information, go to the Intel support website at:
-
 https://www.intel.com/support/
 
-or the Intel Wired Networking project hosted by Sourceforge at:
-
-https://sourceforge.net/projects/e1000
-
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
 to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/fm10k.rst b/Documentation/networking/device_drivers/ethernet/intel/fm10k.rst
index 9d9c2ec2152e..396a2c8c3db1 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/fm10k.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/fm10k.rst
@@ -130,13 +130,8 @@ the Intel Ethernet Controller XL710.
 Support
 =======
 For general information, go to the Intel support website at:
-
 https://www.intel.com/support/
 
-or the Intel Wired Networking project hosted by Sourceforge at:
-
-https://sourceforge.net/projects/e1000
-
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
 to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
index 5b13fe0fec82..4fbaa1a2d674 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
@@ -759,13 +759,8 @@ enabled when setting up DCB on your switch.
 Support
 =======
 For general information, go to the Intel support website at:
-
 https://www.intel.com/support/
 
-or the Intel Wired Networking project hosted by Sourceforge at:
-
-https://sourceforge.net/projects/e1000
-
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
 to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/iavf.rst b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
index 079847666125..eb926c3bd4cd 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
@@ -319,13 +319,8 @@ This is caused by the way the Linux kernel reports this stressed condition.
 Support
 =======
 For general information, go to the Intel support website at:
-
 https://support.intel.com
 
-or the Intel Wired Networking project hosted by Sourceforge at:
-
-https://sourceforge.net/projects/e1000
-
 If an issue is identified with the released source code on the supported kernel
 with a supported adapter, email the specific information related to the issue
 to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/ice.rst b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
index 246bf6455f64..69695e5511f4 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ice.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
@@ -1026,9 +1026,6 @@ Support
 For general information, go to the Intel support website at:
 https://www.intel.com/support/
 
-or the Intel Wired Networking project hosted by Sourceforge at:
-https://sourceforge.net/projects/e1000
-
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
 to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/igb.rst b/Documentation/networking/device_drivers/ethernet/intel/igb.rst
index ee149bdb42b9..fbd590b6a0d6 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/igb.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/igb.rst
@@ -201,13 +201,8 @@ NOTE: This feature is exclusive to i210 models.
 Support
 =======
 For general information, go to the Intel support website at:
-
 https://www.intel.com/support/
 
-or the Intel Wired Networking project hosted by Sourceforge at:
-
-https://sourceforge.net/projects/e1000
-
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
 to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/igbvf.rst b/Documentation/networking/device_drivers/ethernet/intel/igbvf.rst
index 78ceb3cdbfdb..11a9017f3069 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/igbvf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/igbvf.rst
@@ -53,13 +53,8 @@ https://www.kernel.org/pub/software/network/ethtool/
 Support
 =======
 For general information, go to the Intel support website at:
-
 https://www.intel.com/support/
 
-or the Intel Wired Networking project hosted by Sourceforge at:
-
-https://sourceforge.net/projects/e1000
-
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
 to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst b/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
index 8d4f7ede2ff8..1e5f16993f69 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
@@ -545,13 +545,8 @@ on the Intel Ethernet Controller XL710.
 Support
 =======
 For general information, go to the Intel support website at:
-
 https://www.intel.com/support/
 
-or the Intel Wired Networking project hosted by Sourceforge at:
-
-https://sourceforge.net/projects/e1000
-
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
 to intel-wired-lan@lists.osuosl.org.
diff --git a/Documentation/networking/device_drivers/ethernet/intel/ixgbevf.rst b/Documentation/networking/device_drivers/ethernet/intel/ixgbevf.rst
index 9201c74e4c36..08dc0d368a48 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ixgbevf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ixgbevf.rst
@@ -55,13 +55,8 @@ VLANs: There is a limit of a total of 64 shared VLANs to 1 or more VFs.
 Support
 =======
 For general information, go to the Intel support website at:
-
 https://www.intel.com/support/
 
-or the Intel Wired Networking project hosted by Sourceforge at:
-
-https://sourceforge.net/projects/e1000
-
 If an issue is identified with the released source code on a supported kernel
 with a supported adapter, email the specific information related to the issue
 to intel-wired-lan@lists.osuosl.org.
-- 
2.38.1

