Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AD32339C1
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730441AbgG3Uha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:37:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:30887 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730409AbgG3Uh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 16:37:28 -0400
IronPort-SDR: Em1qaKD6jsfFpkNYs4Zgac5FWW4VG5x1p8gJJts9L/g/B4PGRXUmEqEPqo8kRHIRlx0VCd5HAL
 U5qxvXRpL9kA==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="150885536"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="150885536"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 13:37:26 -0700
IronPort-SDR: bkpmklyfiHhjYVIm+RLzQU3oyOQfLgOCsE3mZrAESWRpLG3QaWFHHousZq7Btpzto6dX7xha9Z
 UQOtsV9IHqvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="274324275"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2020 13:37:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com
Subject: [net-next 10/12] Documentation: intel: Replace HTTP links with HTTPS ones
Date:   Thu, 30 Jul 2020 13:37:18 -0700
Message-Id: <20200730203720.3843018-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730203720.3843018-1-anthony.l.nguyen@intel.com>
References: <20200730203720.3843018-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Alexander A. Klimov" <grandmaster@al2klimov.de>

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
          If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../networking/device_drivers/ethernet/intel/e100.rst         | 4 ++--
 .../networking/device_drivers/ethernet/intel/fm10k.rst        | 2 +-
 .../networking/device_drivers/ethernet/intel/iavf.rst         | 2 +-
 .../networking/device_drivers/ethernet/intel/igb.rst          | 2 +-
 .../networking/device_drivers/ethernet/intel/igbvf.rst        | 2 +-
 .../networking/device_drivers/ethernet/intel/ixgb.rst         | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/intel/e100.rst b/Documentation/networking/device_drivers/ethernet/intel/e100.rst
index 3ac21e7119a7..3d4a9ba21946 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/e100.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/e100.rst
@@ -41,7 +41,7 @@ Identifying Your Adapter
 
 For information on how to identify your adapter, and for the latest Intel
 network drivers, refer to the Intel Support website:
-http://www.intel.com/support
+https://www.intel.com/support
 
 Driver Configuration Parameters
 ===============================
@@ -179,7 +179,7 @@ filtering by
 Support
 =======
 For general information, go to the Intel support website at:
-http://www.intel.com/support/
+https://www.intel.com/support/
 
 or the Intel Wired Networking project hosted by Sourceforge at:
 http://sourceforge.net/projects/e1000
diff --git a/Documentation/networking/device_drivers/ethernet/intel/fm10k.rst b/Documentation/networking/device_drivers/ethernet/intel/fm10k.rst
index 4d279e64e221..9258ef6f515c 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/fm10k.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/fm10k.rst
@@ -22,7 +22,7 @@ Ethernet Multi-host Controller.
 
 For information on how to identify your adapter, and for the latest Intel
 network drivers, refer to the Intel Support website:
-http://www.intel.com/support
+https://www.intel.com/support
 
 
 Flow Control
diff --git a/Documentation/networking/device_drivers/ethernet/intel/iavf.rst b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
index 84ac7e75f363..52e037b11c97 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
@@ -43,7 +43,7 @@ device.
 
 For information on how to identify your adapter, and for the latest NVM/FW
 images and Intel network drivers, refer to the Intel Support website:
-http://www.intel.com/support
+https://www.intel.com/support
 
 
 Additional Features and Configurations
diff --git a/Documentation/networking/device_drivers/ethernet/intel/igb.rst b/Documentation/networking/device_drivers/ethernet/intel/igb.rst
index 87e560fe5eaa..d46289e182cf 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/igb.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/igb.rst
@@ -20,7 +20,7 @@ Identifying Your Adapter
 ========================
 For information on how to identify your adapter, and for the latest Intel
 network drivers, refer to the Intel Support website:
-http://www.intel.com/support
+https://www.intel.com/support
 
 
 Command Line Parameters
diff --git a/Documentation/networking/device_drivers/ethernet/intel/igbvf.rst b/Documentation/networking/device_drivers/ethernet/intel/igbvf.rst
index 557fc020ef31..40fa210c5e14 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/igbvf.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/igbvf.rst
@@ -35,7 +35,7 @@ Identifying Your Adapter
 ========================
 For information on how to identify your adapter, and for the latest Intel
 network drivers, refer to the Intel Support website:
-http://www.intel.com/support
+https://www.intel.com/support
 
 
 Additional Features and Configurations
diff --git a/Documentation/networking/device_drivers/ethernet/intel/ixgb.rst b/Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
index ab624f1a44a8..c6a233e68ad6 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
@@ -203,7 +203,7 @@ With the 10 Gigabit server adapters, the default Linux configuration will
 very likely limit the total available throughput artificially.  There is a set
 of configuration changes that, when applied together, will increase the ability
 of Linux to transmit and receive data.  The following enhancements were
-originally acquired from settings published at http://www.spec.org/web99/ for
+originally acquired from settings published at https://www.spec.org/web99/ for
 various submitted results using Linux.
 
 NOTE:
-- 
2.26.2

