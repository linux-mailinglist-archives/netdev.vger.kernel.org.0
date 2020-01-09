Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC7F136369
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgAIWqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:46:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:46881 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbgAIWqq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926854"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:46 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 09/17] devlink: document info versions for each driver
Date:   Thu,  9 Jan 2020 14:46:17 -0800
Message-Id: <20200109224625.1470433-10-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the set of info versions reported by each device driver, including
a description of what the version represents, and what modes (fixed,
running, stored) it reports.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 Documentation/networking/devlink/mlx5.rst  | 18 +++++++++
 Documentation/networking/devlink/mlxsw.rst | 21 ++++++++++
 Documentation/networking/devlink/nfp.rst   | 45 ++++++++++++++++++++++
 3 files changed, 84 insertions(+)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index cf2e19665e5c..629a6e69c036 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -39,3 +39,21 @@ parameters.
          firmware intervention.
 
 The ``mlx5`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
+
+Info versions
+=============
+
+The ``mlx5`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``fw.psid``
+     - fixed
+     - Used to represent the board id of the device.
+   * - ``fw.version``
+     - stored, running
+     - Three digit major.minor.subminor firmware version number.
diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
index dfb245f0c17d..ccba9769c651 100644
--- a/Documentation/networking/devlink/mlxsw.rst
+++ b/Documentation/networking/devlink/mlxsw.rst
@@ -36,3 +36,24 @@ parameters.
        immediately after the value is set.
 
 The ``mlxsw`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
+
+Info versions
+=============
+
+The ``mlx5`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``hw.revision``
+     - fixed
+     - The hardware revision for this board
+   * - ``fw.psid``
+     - fixed
+     - Firmware PSID
+   * - ``fw.version``
+     - running
+     - Three digit firmware version
diff --git a/Documentation/networking/devlink/nfp.rst b/Documentation/networking/devlink/nfp.rst
index bbb3c6b2280c..a1717db0dfcc 100644
--- a/Documentation/networking/devlink/nfp.rst
+++ b/Documentation/networking/devlink/nfp.rst
@@ -18,3 +18,48 @@ Parameters
      - permanent
    * - ``reset_dev_on_drv_probe``
      - permanent
+
+Info versions
+=============
+
+The ``nfp`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``board.id``
+     - fixed
+     - Part number identifying the board design
+   * - ``board.rev``
+     - fixed
+     - Revision of the board design
+   * - ``board.manufacture``
+     - fixed
+     - Vendor of the board design
+   * - ``board.model``
+     - fixed
+     - Model name of the board design
+   * - ``fw.bundle_id``
+     - stored, running
+     - Firmware bundle id
+   * - ``fw.mgmt``
+     - stored, running
+     - Version of the management firmware
+   * - ``fw.cpld``
+     - stored, running
+     - The CPLD firmware component version
+   * - ``fw.app``
+     - stored, running
+     - The APP firmware component version
+   * - ``fw.undi``
+     - stored, running
+     - The UNDI firmware component version
+   * - ``fw.ncsi``
+     - stored, running
+     - The NSCI firmware component version
+   * - ``chip.init``
+     - stored, running
+     - The CFGR firmware component version
-- 
2.25.0.rc1

