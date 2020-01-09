Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F2E1360C1
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388718AbgAITI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:08:26 -0500
Received: from mga07.intel.com ([134.134.136.100]:22128 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732255AbgAITIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 14:08:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 11:08:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="371388518"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by orsmga004.jf.intel.com with ESMTP; 09 Jan 2020 11:08:24 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     valex@mellanox.com, jiri@resnulli.us,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 2/2] doc: fix typo of snapshot in documentation
Date:   Thu,  9 Jan 2020 11:08:21 -0800
Message-Id: <20200109190821.1335579-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109190821.1335579-1-jacob.e.keller@intel.com>
References: <20200109190821.1335579-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A couple of locations accidentally misspelled snapshot as shapshot.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/admin-guide/devices.txt    | 2 +-
 Documentation/media/v4l-drivers/meye.rst | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/devices.txt b/Documentation/admin-guide/devices.txt
index 1c5d2281efc9..2a97aaec8b12 100644
--- a/Documentation/admin-guide/devices.txt
+++ b/Documentation/admin-guide/devices.txt
@@ -319,7 +319,7 @@
 		182 = /dev/perfctr	Performance-monitoring counters
 		183 = /dev/hwrng	Generic random number generator
 		184 = /dev/cpu/microcode CPU microcode update interface
-		186 = /dev/atomicps	Atomic shapshot of process state data
+		186 = /dev/atomicps	Atomic snapshot of process state data
 		187 = /dev/irnet	IrNET device
 		188 = /dev/smbusbios	SMBus BIOS
 		189 = /dev/ussp_ctl	User space serial port control
diff --git a/Documentation/media/v4l-drivers/meye.rst b/Documentation/media/v4l-drivers/meye.rst
index a572996cdbf6..dc57a6a91b43 100644
--- a/Documentation/media/v4l-drivers/meye.rst
+++ b/Documentation/media/v4l-drivers/meye.rst
@@ -95,7 +95,7 @@ so all video4linux tools (like xawtv) should work with this driver.
 
 Besides the video4linux interface, the driver has a private interface
 for accessing the Motion Eye extended parameters (camera sharpness,
-agc, video framerate), the shapshot and the MJPEG capture facilities.
+agc, video framerate), the snapshot and the MJPEG capture facilities.
 
 This interface consists of several ioctls (prototypes and structures
 can be found in include/linux/meye.h):
-- 
2.25.0.rc1

