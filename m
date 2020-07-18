Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18210224A83
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 12:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgGRKCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 06:02:51 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:59602 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgGRKCu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 06:02:50 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 7543CBC053;
        Sat, 18 Jul 2020 10:02:46 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     stas.yakovlev@gmail.com, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] ipw2x00: Replace HTTP links with HTTPS ones
Date:   Sat, 18 Jul 2020 12:02:40 +0200
Message-Id: <20200718100240.98593-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
X-Spam: Yes
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

 If there are any URLs to be removed completely
 or at least not (just) HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.


 Documentation/networking/device_drivers/intel/ipw2100.rst | 2 +-
 drivers/net/wireless/intel/ipw2x00/Kconfig                | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/device_drivers/intel/ipw2100.rst b/Documentation/networking/device_drivers/intel/ipw2100.rst
index d54ad522f937..883e96355799 100644
--- a/Documentation/networking/device_drivers/intel/ipw2100.rst
+++ b/Documentation/networking/device_drivers/intel/ipw2100.rst
@@ -78,7 +78,7 @@ such, if you are interested in deploying or shipping a driver as part of
 solution intended to be used for purposes other than development, please
 obtain a tested driver from Intel Customer Support at:
 
-http://www.intel.com/support/wireless/sb/CS-006408.htm
+https://www.intel.com/support/wireless/sb/CS-006408.htm
 
 1. Introduction
 ===============
diff --git a/drivers/net/wireless/intel/ipw2x00/Kconfig b/drivers/net/wireless/intel/ipw2x00/Kconfig
index d00386915a9d..f3e09b630d8b 100644
--- a/drivers/net/wireless/intel/ipw2x00/Kconfig
+++ b/drivers/net/wireless/intel/ipw2x00/Kconfig
@@ -28,7 +28,7 @@ config IPW2100
 	  You will also very likely need the Wireless Tools in order to
 	  configure your card:
 
-	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
+	  <https://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
 
 	  It is recommended that you compile this driver as a module (M)
 	  rather than built-in (Y). This driver requires firmware at device
@@ -90,7 +90,7 @@ config IPW2200
 	  You will also very likely need the Wireless Tools in order to
 	  configure your card:
 
-	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
+	  <https://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
 
 	  It is recommended that you compile this driver as a module (M)
 	  rather than built-in (Y). This driver requires firmware at device
-- 
2.27.0

