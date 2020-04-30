Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01531C01A2
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgD3QHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgD3QEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:38 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA6F3217BA;
        Thu, 30 Apr 2020 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=VskrOSds+k6lATCBRxSNU8FwGkjkFNi0RCLoQYUzeio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w96YBFQL43JPBzEzOIR2cQc1RJ1EREU8munTIHlc6DD2iW/w2zeeoTWGmN4q7IP9v
         /Vd7qXRQzofKcwb3CwxqsUeayJzgBMhkogOEWKx6gHc3/551p5K2eSZKWyAq3h5DUH
         Wi/MHtE9M2Qdtm2ZEGG2+AhB82t+i1tnsCZgEIEA=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxEi-6Z; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 08/37] docs: networking: convert netdev-features.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:03 +0200
Message-Id: <6990088c4a50c1da5a563649189e5fd0c114ddf3.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not much to be done here:

- add SPDX header;
- adjust titles and chapters, adding proper markups;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/checksum-offloads.rst          |  2 +-
 Documentation/networking/index.rst            |  1 +
 ...etdev-features.txt => netdev-features.rst} | 19 +++++++++++--------
 include/linux/netdev_features.h               |  2 +-
 4 files changed, 14 insertions(+), 10 deletions(-)
 rename Documentation/networking/{netdev-features.txt => netdev-features.rst} (95%)

diff --git a/Documentation/networking/checksum-offloads.rst b/Documentation/networking/checksum-offloads.rst
index 905c8a84b103..69b23cf6879e 100644
--- a/Documentation/networking/checksum-offloads.rst
+++ b/Documentation/networking/checksum-offloads.rst
@@ -59,7 +59,7 @@ recomputed for each resulting segment.  See the skbuff.h comment (section 'E')
 for more details.
 
 A driver declares its offload capabilities in netdev->hw_features; see
-Documentation/networking/netdev-features.txt for more.  Note that a device
+Documentation/networking/netdev-features.rst for more.  Note that a device
 which only advertises NETIF_F_IP[V6]_CSUM must still obey the csum_start and
 csum_offset given in the SKB; if it tries to deduce these itself in hardware
 (as some NICs do) the driver should check that the values in the SKB match
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index e58f872d401d..4c6aa3db97d4 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -81,6 +81,7 @@ Contents:
    mpls-sysctl
    multiqueue
    netconsole
+   netdev-features
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/netdev-features.txt b/Documentation/networking/netdev-features.rst
similarity index 95%
rename from Documentation/networking/netdev-features.txt
rename to Documentation/networking/netdev-features.rst
index 58dd1c1e3c65..a2d7d7160e39 100644
--- a/Documentation/networking/netdev-features.txt
+++ b/Documentation/networking/netdev-features.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================================================
 Netdev features mess and how to get out from it alive
 =====================================================
 
@@ -6,8 +9,8 @@ Author:
 
 
 
- Part I: Feature sets
-======================
+Part I: Feature sets
+====================
 
 Long gone are the days when a network card would just take and give packets
 verbatim.  Today's devices add multiple features and bugs (read: offloads)
@@ -39,8 +42,8 @@ one used internally by network core:
 
 
 
- Part II: Controlling enabled features
-=======================================
+Part II: Controlling enabled features
+=====================================
 
 When current feature set (netdev->features) is to be changed, new set
 is calculated and filtered by calling ndo_fix_features callback
@@ -65,8 +68,8 @@ driver except by means of ndo_fix_features callback.
 
 
 
- Part III: Implementation hints
-================================
+Part III: Implementation hints
+==============================
 
  * ndo_fix_features:
 
@@ -94,8 +97,8 @@ Errors returned are not (and cannot be) propagated anywhere except dmesg.
 
 
 
- Part IV: Features
-===================
+Part IV: Features
+=================
 
 For current list of features, see include/linux/netdev_features.h.
 This section describes semantics of some of them.
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 9d53c5ad272c..2cc3cf80b49a 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -89,7 +89,7 @@ enum {
 	 * Add your fresh new feature above and remember to update
 	 * netdev_features_strings[] in net/core/ethtool.c and maybe
 	 * some feature mask #defines below. Please also describe it
-	 * in Documentation/networking/netdev-features.txt.
+	 * in Documentation/networking/netdev-features.rst.
 	 */
 
 	/**/NETDEV_FEATURE_COUNT
-- 
2.25.4

