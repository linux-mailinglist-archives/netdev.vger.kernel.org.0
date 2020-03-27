Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8318196017
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgC0Uzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:55:40 -0400
Received: from mga04.intel.com ([192.55.52.120]:47670 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgC0Uzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 16:55:39 -0400
IronPort-SDR: pj4ONNoBoK1uRIFkOzwWZHBp9YIxMOi/i9r857OfuKDOxlVl1n+0dJIkrRUmM2d8SSxQF3zqJg
 hLwk8bUVXwxw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 13:55:39 -0700
IronPort-SDR: k3flTYbZqGZVdcbRW+RC2nIV4x+XM8Qr52zeL9/qKRsvVx+Mq2YKfLmqmO5B1bNXHgysJ0zMEV
 yQQvvewiQQxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="282966114"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga002.fm.intel.com with ESMTP; 27 Mar 2020 13:55:39 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next] devlink: don't wrap commands in rST shell blocks
Date:   Fri, 27 Mar 2020 13:55:36 -0700
Message-Id: <20200327205536.2527859-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink-region.rst and ice-region.rst documentation files wrapped
some lines within shell code blocks due to being longer than 80 lines.

It was pointed out during review that wrapping these lines shouldn't be
done. Fix these two rST files and remove the line wrapping on these
shell command examples.

Reported-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/networking/devlink/devlink-region.rst | 6 ++----
 Documentation/networking/devlink/ice.rst            | 3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
index 9d2d4c95a5c4..04e04d1ff627 100644
--- a/Documentation/networking/devlink/devlink-region.rst
+++ b/Documentation/networking/devlink/devlink-region.rst
@@ -34,8 +34,7 @@ example usage
     $ devlink region show [ DEV/REGION ]
     $ devlink region del DEV/REGION snapshot SNAPSHOT_ID
     $ devlink region dump DEV/REGION [ snapshot SNAPSHOT_ID ]
-    $ devlink region read DEV/REGION [ snapshot SNAPSHOT_ID ]
-            address ADDRESS length length
+    $ devlink region read DEV/REGION [ snapshot SNAPSHOT_ID ] address ADDRESS length length
 
     # Show all of the exposed regions with region sizes:
     $ devlink region show
@@ -56,8 +55,7 @@ example usage
     0000000000000030 bada cce5 bada cce5 bada cce5 bada cce5
 
     # Read a specific part of a snapshot:
-    $ devlink region read pci/0000:00:05.0/fw-health snapshot 1 address 0
-            length 16
+    $ devlink region read pci/0000:00:05.0/fw-health snapshot 1 address 0 length 16
     0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
 
 As regions are likely very device or driver specific, no generic regions are
diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index f3d6a3b50342..5b58fc4e1268 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -90,8 +90,7 @@ Users can request an immediate capture of a snapshot via the
     0000000000000020 0016 0bb8 0016 1720 0000 0000 c00f 3ffc
     0000000000000030 bada cce5 bada cce5 bada cce5 bada cce5
 
-    $ devlink region read pci/0000:01:00.0/nvm-flash snapshot 1 address 0
-        length 16
+    $ devlink region read pci/0000:01:00.0/nvm-flash snapshot 1 address 0 length 16
     0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
 
     $ devlink region delete pci/0000:01:00.0/nvm-flash snapshot 1
-- 
2.24.1

