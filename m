Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F57F136371
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgAIWrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:47:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:46855 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729239AbgAIWqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926862"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:48 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com
Subject: [PATCH 11/17] devlink: add a driver-specific file for the qed driver
Date:   Thu,  9 Jan 2020 14:46:19 -0800
Message-Id: <20200109224625.1470433-12-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qed driver recently added devlink support with a single devlink
parameter. Add a driver-specific file to document the devlink features
that the qed driver supports.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Ariel Elior <aelior@marvell.com>
Cc: GR-everest-linux-l2@marvell.com
---
 Documentation/networking/devlink/index.rst |  1 +
 Documentation/networking/devlink/qed.rst   | 26 ++++++++++++++++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 Documentation/networking/devlink/qed.rst

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 0cbafef607d8..2007e257fd8a 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -34,4 +34,5 @@ parameters, info versions, and other features it supports.
    mlxsw
    mv88e6xxx
    nfp
+   qed
    ti-cpsw-switch
diff --git a/Documentation/networking/devlink/qed.rst b/Documentation/networking/devlink/qed.rst
new file mode 100644
index 000000000000..e7e17acf1eca
--- /dev/null
+++ b/Documentation/networking/devlink/qed.rst
@@ -0,0 +1,26 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================
+qed devlink support
+===================
+
+This document describes the devlink features implemented by the ``qed`` core
+device driver.
+
+Parameters
+==========
+
+The ``qed`` driver implements the following driver-specific parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``iwarp_cmt``
+     - Boolean
+     - runtime
+     - Enable iWARP functionality for 100g devices. Notee that this impacts
+       L2 performance, and is therefor not enabled by default.
-- 
2.25.0.rc1

