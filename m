Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5CB613636D
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbgAIWq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:46:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:46855 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729353AbgAIWqx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926891"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:53 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 17/17] devlink: document region snapshot triggering from userspace
Date:   Thu,  9 Jan 2020 14:46:25 -0800
Message-Id: <20200109224625.1470433-18-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that devlink regions can be triggered via
DEVLINK_CMD_REGION_TRIGGER, document this in the devlink-region.rst
file.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/networking/devlink/devlink-region.rst | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
index efa11b9a20da..1a7683e7acb2 100644
--- a/Documentation/networking/devlink/devlink-region.rst
+++ b/Documentation/networking/devlink/devlink-region.rst
@@ -12,10 +12,13 @@ region can then be accessed via the devlink region interface.
 
 Region snapshots are collected by the driver, and can be accessed via read
 or dump commands. This allows future analysis on the created snapshots.
+Regions may optionally support triggering snapshots on demand.
 
 The major benefit to creating a region is to provide access to internal
-address regions that are otherwise inaccessible to the user. They can be
-used to provide an additional way to debug complex error states.
+address regions that are otherwise inaccessible to the user.
+
+Regions may also be used to provide an additional way to debug complex error
+states, but see also :doc:`devlink-health`
 
 example usage
 -------------
@@ -37,6 +40,9 @@ example usage
     # Delete a snapshot using:
     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
 
+    # Trigger (request) a snapshot be taken:
+    $ devlink region trigger pci/0000:00:05.0/cr-space
+
     # Dump a snapshot:
     $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
     0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
-- 
2.25.0.rc1

