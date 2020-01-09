Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 276D1136368
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgAIWqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:46:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:46883 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729171AbgAIWqr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926858"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:47 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH 10/17] devlink: add parameter documentation for the mlx4 driver
Date:   Thu,  9 Jan 2020 14:46:18 -0800
Message-Id: <20200109224625.1470433-11-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx5 and mlxsw drivers have driver-specific documentation for the
devlink features they support. No such file was added for mlx4.

Add a file to document the mlx4 devlink support. Initially it contains
only the devlink parameters.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
---
 Documentation/networking/devlink/index.rst |  1 +
 Documentation/networking/devlink/mlx4.rst  | 43 ++++++++++++++++++++++
 2 files changed, 44 insertions(+)
 create mode 100644 Documentation/networking/devlink/mlx4.rst

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 4035cbefda7c..0cbafef607d8 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -29,6 +29,7 @@ parameters, info versions, and other features it supports.
    :maxdepth: 1
 
    bnxt
+   mlx4
    mlx5
    mlxsw
    mv88e6xxx
diff --git a/Documentation/networking/devlink/mlx4.rst b/Documentation/networking/devlink/mlx4.rst
new file mode 100644
index 000000000000..4fa5c2b51c52
--- /dev/null
+++ b/Documentation/networking/devlink/mlx4.rst
@@ -0,0 +1,43 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+mlx4 devlink support
+====================
+
+This document describes the devlink features implemented by the ``mlx4``
+device driver.
+
+Parameters
+==========
+
+.. list-table:: Generic parameters implemented
+
+   * - Name
+     - Mode
+   * - ``internal_err_reset``
+     - driverinit, runtime
+   * - ``max_macs``
+     - driverinit
+   * - ``region_snapshot_enable``
+     - driverinit, runtime
+
+The ``mlx4`` driver also implements the following driver-specific
+parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``enable_64b_cqe_eqe``
+     - Boolean
+     - driverinit
+     - Enable 64 byte CQEs/EQEs, if the FW supports it.
+   * - ``enable_4k_uar``
+     - Boolean
+     - driverinit
+     - Enable using the 4k UAR.
+
+The ``mlx4`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
-- 
2.25.0.rc1

