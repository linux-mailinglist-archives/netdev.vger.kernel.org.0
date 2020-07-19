Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BC4225296
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 17:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgGSPsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 11:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgGSPsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 11:48:46 -0400
Received: from smtp.al2klimov.de (smtp.al2klimov.de [IPv6:2a01:4f8:c0c:1465::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC47EC0619D2;
        Sun, 19 Jul 2020 08:48:45 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 613A3BC062;
        Sun, 19 Jul 2020 15:48:42 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH for v5.9] Documentation: intel: Replace HTTP links with HTTPS ones
Date:   Sun, 19 Jul 2020 17:48:36 +0200
Message-Id: <20200719154836.59873-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
X-Spam-Level: *****
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely
 or at least not (just) HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.

 Sorry again to all maintainers who complained about subject lines.
 Now I realized that you want an actually perfect prefixes,
 not just subsystem ones.
 I tried my best...
 And yes, *I could* (at least half-)automate it.
 Impossible is nothing! :)


 Documentation/networking/device_drivers/intel/e100.rst  | 4 ++--
 Documentation/networking/device_drivers/intel/e1000.rst | 2 +-
 Documentation/networking/device_drivers/intel/fm10k.rst | 2 +-
 Documentation/networking/device_drivers/intel/iavf.rst  | 2 +-
 Documentation/networking/device_drivers/intel/igb.rst   | 2 +-
 Documentation/networking/device_drivers/intel/igbvf.rst | 2 +-
 Documentation/networking/device_drivers/intel/ixgb.rst  | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/device_drivers/intel/e100.rst b/Documentation/networking/device_drivers/intel/e100.rst
index 3ac21e7119a7..3d4a9ba21946 100644
--- a/Documentation/networking/device_drivers/intel/e100.rst
+++ b/Documentation/networking/device_drivers/intel/e100.rst
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
diff --git a/Documentation/networking/device_drivers/intel/e1000.rst b/Documentation/networking/device_drivers/intel/e1000.rst
index 4aaae0f7d6ba..9d99ff15d737 100644
--- a/Documentation/networking/device_drivers/intel/e1000.rst
+++ b/Documentation/networking/device_drivers/intel/e1000.rst
@@ -44,7 +44,7 @@ NOTES:
         For more information about the InterruptThrottleRate,
         RxIntDelay, TxIntDelay, RxAbsIntDelay, and TxAbsIntDelay
         parameters, see the application note at:
-        http://www.intel.com/design/network/applnots/ap450.htm
+        https://www.intel.com/design/network/applnots/ap450.htm
 
 AutoNeg
 -------
diff --git a/Documentation/networking/device_drivers/intel/fm10k.rst b/Documentation/networking/device_drivers/intel/fm10k.rst
index 4d279e64e221..9258ef6f515c 100644
--- a/Documentation/networking/device_drivers/intel/fm10k.rst
+++ b/Documentation/networking/device_drivers/intel/fm10k.rst
@@ -22,7 +22,7 @@ Ethernet Multi-host Controller.
 
 For information on how to identify your adapter, and for the latest Intel
 network drivers, refer to the Intel Support website:
-http://www.intel.com/support
+https://www.intel.com/support
 
 
 Flow Control
diff --git a/Documentation/networking/device_drivers/intel/iavf.rst b/Documentation/networking/device_drivers/intel/iavf.rst
index 84ac7e75f363..52e037b11c97 100644
--- a/Documentation/networking/device_drivers/intel/iavf.rst
+++ b/Documentation/networking/device_drivers/intel/iavf.rst
@@ -43,7 +43,7 @@ device.
 
 For information on how to identify your adapter, and for the latest NVM/FW
 images and Intel network drivers, refer to the Intel Support website:
-http://www.intel.com/support
+https://www.intel.com/support
 
 
 Additional Features and Configurations
diff --git a/Documentation/networking/device_drivers/intel/igb.rst b/Documentation/networking/device_drivers/intel/igb.rst
index 87e560fe5eaa..d46289e182cf 100644
--- a/Documentation/networking/device_drivers/intel/igb.rst
+++ b/Documentation/networking/device_drivers/intel/igb.rst
@@ -20,7 +20,7 @@ Identifying Your Adapter
 ========================
 For information on how to identify your adapter, and for the latest Intel
 network drivers, refer to the Intel Support website:
-http://www.intel.com/support
+https://www.intel.com/support
 
 
 Command Line Parameters
diff --git a/Documentation/networking/device_drivers/intel/igbvf.rst b/Documentation/networking/device_drivers/intel/igbvf.rst
index 557fc020ef31..40fa210c5e14 100644
--- a/Documentation/networking/device_drivers/intel/igbvf.rst
+++ b/Documentation/networking/device_drivers/intel/igbvf.rst
@@ -35,7 +35,7 @@ Identifying Your Adapter
 ========================
 For information on how to identify your adapter, and for the latest Intel
 network drivers, refer to the Intel Support website:
-http://www.intel.com/support
+https://www.intel.com/support
 
 
 Additional Features and Configurations
diff --git a/Documentation/networking/device_drivers/intel/ixgb.rst b/Documentation/networking/device_drivers/intel/ixgb.rst
index ab624f1a44a8..c6a233e68ad6 100644
--- a/Documentation/networking/device_drivers/intel/ixgb.rst
+++ b/Documentation/networking/device_drivers/intel/ixgb.rst
@@ -203,7 +203,7 @@ With the 10 Gigabit server adapters, the default Linux configuration will
 very likely limit the total available throughput artificially.  There is a set
 of configuration changes that, when applied together, will increase the ability
 of Linux to transmit and receive data.  The following enhancements were
-originally acquired from settings published at http://www.spec.org/web99/ for
+originally acquired from settings published at https://www.spec.org/web99/ for
 various submitted results using Linux.
 
 NOTE:
-- 
2.27.0

