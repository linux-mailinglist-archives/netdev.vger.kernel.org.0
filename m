Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F8713636A
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbgAIWqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:46:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:46855 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729119AbgAIWqp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926846"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:44 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH 08/17] devlink: convert driver-specific files to reStructuredText
Date:   Thu,  9 Jan 2020 14:46:16 -0800
Message-Id: <20200109224625.1470433-9-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several drivers document what parameters they support in
a devlink-params-*.txt file. This file is supposed to contain both the
list of generic parameters implemented by the driver, as well as a list
of driver-specific parameters and their descriptions.

It would also be good if the driver documentation included other
driver-specific implementations, such as info versions, devlink
regions, and so forth.

Convert all of these documentation files to reStructuredText, and rename
them to just the driver name. Future changes will include other
driver-specific implementations. Each file will contain a table for the
generic parameters implemented, as well as a separate table for the
driver-specific parameters.

Future sections such as for devlink info versions will be added to these
files. This avoids creating additional devlink-<feature>-<driver> files
for each devlink feature, reducing clutter in the documentation folder.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Michael Chan <michael.chan@broadcom.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Ido Schimmel <idosch@mellanox.com>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../device_drivers/ti/cpsw_switchdev.txt      |  2 +-
 Documentation/networking/devlink/bnxt.rst     | 41 +++++++++++++++++++
 .../devlink/devlink-params-bnxt.txt           | 18 --------
 .../devlink/devlink-params-mlx5.txt           | 17 --------
 .../devlink/devlink-params-mlxsw.txt          | 10 -----
 .../devlink/devlink-params-mv88e6xxx.txt      |  7 ----
 .../networking/devlink/devlink-params-nfp.txt |  5 ---
 .../devlink/devlink-params-ti-cpsw-switch.txt | 10 -----
 Documentation/networking/devlink/index.rst    | 22 +++++++++-
 Documentation/networking/devlink/mlx5.rst     | 41 +++++++++++++++++++
 Documentation/networking/devlink/mlxsw.rst    | 38 +++++++++++++++++
 .../networking/devlink/mv88e6xxx.rst          | 28 +++++++++++++
 Documentation/networking/devlink/nfp.rst      | 20 +++++++++
 .../networking/devlink/ti-cpsw-switch.rst     | 31 ++++++++++++++
 MAINTAINERS                                   |  2 +-
 15 files changed, 222 insertions(+), 70 deletions(-)
 create mode 100644 Documentation/networking/devlink/bnxt.rst
 delete mode 100644 Documentation/networking/devlink/devlink-params-bnxt.txt
 delete mode 100644 Documentation/networking/devlink/devlink-params-mlx5.txt
 delete mode 100644 Documentation/networking/devlink/devlink-params-mlxsw.txt
 delete mode 100644 Documentation/networking/devlink/devlink-params-mv88e6xxx.txt
 delete mode 100644 Documentation/networking/devlink/devlink-params-nfp.txt
 delete mode 100644 Documentation/networking/devlink/devlink-params-ti-cpsw-switch.txt
 create mode 100644 Documentation/networking/devlink/mlx5.rst
 create mode 100644 Documentation/networking/devlink/mlxsw.rst
 create mode 100644 Documentation/networking/devlink/mv88e6xxx.rst
 create mode 100644 Documentation/networking/devlink/nfp.rst
 create mode 100644 Documentation/networking/devlink/ti-cpsw-switch.rst

diff --git a/Documentation/networking/device_drivers/ti/cpsw_switchdev.txt b/Documentation/networking/device_drivers/ti/cpsw_switchdev.txt
index 5c8cee17fca9..12855ab268b8 100644
--- a/Documentation/networking/device_drivers/ti/cpsw_switchdev.txt
+++ b/Documentation/networking/device_drivers/ti/cpsw_switchdev.txt
@@ -39,7 +39,7 @@ but without enabling "switch" mode, or to different bridges.
 
 Devlink configuration parameters
 ====================
-See Documentation/networking/devlink-params-ti-cpsw-switch.txt
+See Documentation/networking/devlink/ti-cpsw-switch.rst
 
 ====================
 # Bridging in dual mac mode
diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
new file mode 100644
index 000000000000..79e746d22a53
--- /dev/null
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -0,0 +1,41 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+bnxt devlink support
+====================
+
+This document describes the devlink features implemented by the ``bnxt``
+device driver.
+
+Parameters
+==========
+
+.. list-table:: Generic parameters implemented
+
+   * - Name
+     - Mode
+   * - ``enable_sriov``
+     - Permanent
+   * - ``ignore_ari``
+     - Permanent
+   * - ``msix_vec_per_pf_max``
+     - Permanent
+   * - ``msix_vec_per_pf_min``
+     - Permanent
+
+The ``bnxt`` driver also implements the following driver-specific
+parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``gre_ver_check``
+     - Boolean
+     - Permanent
+     - Generic Routing Encapsulation (GRE) version check will be enabled in
+       the device. If disabled, the device will skip the version check for
+       incoming packets.
diff --git a/Documentation/networking/devlink/devlink-params-bnxt.txt b/Documentation/networking/devlink/devlink-params-bnxt.txt
deleted file mode 100644
index 481aa303d5b4..000000000000
--- a/Documentation/networking/devlink/devlink-params-bnxt.txt
+++ /dev/null
@@ -1,18 +0,0 @@
-enable_sriov		[DEVICE, GENERIC]
-			Configuration mode: Permanent
-
-ignore_ari		[DEVICE, GENERIC]
-			Configuration mode: Permanent
-
-msix_vec_per_pf_max	[DEVICE, GENERIC]
-			Configuration mode: Permanent
-
-msix_vec_per_pf_min	[DEVICE, GENERIC]
-			Configuration mode: Permanent
-
-gre_ver_check		[DEVICE, DRIVER-SPECIFIC]
-			Generic Routing Encapsulation (GRE) version check will
-			be enabled in the device. If disabled, device skips
-			version checking for incoming packets.
-			Type: Boolean
-			Configuration mode: Permanent
diff --git a/Documentation/networking/devlink/devlink-params-mlx5.txt b/Documentation/networking/devlink/devlink-params-mlx5.txt
deleted file mode 100644
index 5071467118bd..000000000000
--- a/Documentation/networking/devlink/devlink-params-mlx5.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-flow_steering_mode	[DEVICE, DRIVER-SPECIFIC]
-			Controls the flow steering mode of the driver.
-			Two modes are supported:
-			1. 'dmfs' - Device managed flow steering.
-			2. 'smfs  - Software/Driver managed flow steering.
-			In DMFS mode, the HW steering entities are created and
-			managed through the Firmware.
-			In SMFS mode, the HW steering entities are created and
-			managed though by the driver directly into Hardware
-			without firmware intervention.
-			Type: String
-			Configuration mode: runtime
-
-enable_roce		[DEVICE, GENERIC]
-			Enable handling of RoCE traffic in the device.
-			Defaultly enabled.
-			Configuration mode: driverinit
diff --git a/Documentation/networking/devlink/devlink-params-mlxsw.txt b/Documentation/networking/devlink/devlink-params-mlxsw.txt
deleted file mode 100644
index c63ea9fc7009..000000000000
--- a/Documentation/networking/devlink/devlink-params-mlxsw.txt
+++ /dev/null
@@ -1,10 +0,0 @@
-fw_load_policy		[DEVICE, GENERIC]
-			Configuration mode: driverinit
-
-acl_region_rehash_interval	[DEVICE, DRIVER-SPECIFIC]
-			Sets an interval for periodic ACL region rehashes.
-			The value is in milliseconds, minimal value is "3000".
-			Value "0" disables the periodic work.
-			The first rehash will be run right after value is set.
-			Type: u32
-			Configuration mode: runtime
diff --git a/Documentation/networking/devlink/devlink-params-mv88e6xxx.txt b/Documentation/networking/devlink/devlink-params-mv88e6xxx.txt
deleted file mode 100644
index 21c4b3556ef2..000000000000
--- a/Documentation/networking/devlink/devlink-params-mv88e6xxx.txt
+++ /dev/null
@@ -1,7 +0,0 @@
-ATU_hash		[DEVICE, DRIVER-SPECIFIC]
-			Select one of four possible hashing algorithms for
-			MAC addresses in the Address Translation Unit.
-			A value of 3 seems to work better than the default of
-			1 when many MAC addresses have the same OUI.
-			Configuration mode: runtime
-			Type: u8. 0-3 valid.
diff --git a/Documentation/networking/devlink/devlink-params-nfp.txt b/Documentation/networking/devlink/devlink-params-nfp.txt
deleted file mode 100644
index 43e4d4034865..000000000000
--- a/Documentation/networking/devlink/devlink-params-nfp.txt
+++ /dev/null
@@ -1,5 +0,0 @@
-fw_load_policy		[DEVICE, GENERIC]
-			Configuration mode: permanent
-
-reset_dev_on_drv_probe	[DEVICE, GENERIC]
-			Configuration mode: permanent
diff --git a/Documentation/networking/devlink/devlink-params-ti-cpsw-switch.txt b/Documentation/networking/devlink/devlink-params-ti-cpsw-switch.txt
deleted file mode 100644
index 4037458499f7..000000000000
--- a/Documentation/networking/devlink/devlink-params-ti-cpsw-switch.txt
+++ /dev/null
@@ -1,10 +0,0 @@
-ale_bypass	[DEVICE, DRIVER-SPECIFIC]
-		Allows to enable ALE_CONTROL(4).BYPASS mode for debug purposes.
-		All packets will be sent to the Host port only if enabled.
-		Type: bool
-		Configuration mode: runtime
-
-switch_mode	[DEVICE, DRIVER-SPECIFIC]
-		Enable switch mode
-		Type: bool
-		Configuration mode: runtime
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index ae3f20919d22..4035cbefda7c 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -4,7 +4,11 @@ Linux Devlink Documentation
 devlink is an API to expose device information and resources not directly
 related to any device class, such as chip-wide/switch-ASIC-wide configuration.
 
-Contents:
+Interface documentation
+-----------------------
+
+The following pages describe various interfaces available through devlink in
+general.
 
 .. toctree::
    :maxdepth: 1
@@ -14,3 +18,19 @@ Contents:
    devlink-params
    devlink-trap
    devlink-trap-netdevsim
+
+Driver-specific documentation
+-----------------------------
+
+Each driver that implements ``devlink`` is expected to document what
+parameters, info versions, and other features it supports.
+
+.. toctree::
+   :maxdepth: 1
+
+   bnxt
+   mlx5
+   mlxsw
+   mv88e6xxx
+   nfp
+   ti-cpsw-switch
diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
new file mode 100644
index 000000000000..cf2e19665e5c
--- /dev/null
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -0,0 +1,41 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+mlx5 devlink support
+====================
+
+This document describes the devlink features implemented by the ``mlx5``
+device driver.
+
+Parameters
+==========
+
+.. list-table:: Generic parameters implemented
+
+   * - Name
+     - Mode
+   * - ``enable_roce``
+     - driverinit
+
+The ``mlx5`` driver also implements the following driver-specific
+parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``flow_steering_mode``
+     - string
+     - runtime
+     - Controls the flow steering mode of the driver
+
+       * ``dmfs`` Device managed flow steering. In DMFS mode, the HW
+         steering entities are created and managed through firmware.
+       * ``smfs`` Software managed flow steering. In SMFS mode, the HW
+         steering entities are created and manage through the driver without
+         firmware intervention.
+
+The ``mlx5`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
new file mode 100644
index 000000000000..dfb245f0c17d
--- /dev/null
+++ b/Documentation/networking/devlink/mlxsw.rst
@@ -0,0 +1,38 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================
+mlxsw devlink support
+=====================
+
+This document describes the devlink features implemented by the ``mlxsw``
+device driver.
+
+Parameters
+==========
+
+.. list-table:: Generic parameters implemented
+
+   * - Name
+     - Mode
+   * - ``fw_load_policy``
+     - driverinit
+
+The ``mlxsw`` driver also implements the following driver-specific
+parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``acl_region_rehash_interval``
+     - u32
+     - runtime
+     - Sets an interval for periodic ACL region rehashes. The value is
+       specified in milliseconds, with a minimum of ``3000``. The value of
+       ``0`` disables periodic work entirely. The first rehash will be run
+       immediately after the value is set.
+
+The ``mlxsw`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
diff --git a/Documentation/networking/devlink/mv88e6xxx.rst b/Documentation/networking/devlink/mv88e6xxx.rst
new file mode 100644
index 000000000000..c621212a47a1
--- /dev/null
+++ b/Documentation/networking/devlink/mv88e6xxx.rst
@@ -0,0 +1,28 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+mv88e6xxx devlink support
+=========================
+
+This document describes the devlink features implemented by the ``mv88e6xxx``
+device driver.
+
+Parameters
+==========
+
+The ``mv88e6xxx`` driver implements the following driver-specific parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``ATU_hash``
+     - u8
+     - runtime
+     - Select one of four possible hashing algorithms for MAC addresses in
+       the Address Translation Unit. A value of 3 may work better than the
+       default of 1 when many MAC addresses have the same OUI. Only the
+       values 0 to 3 are valid for this parameter.
diff --git a/Documentation/networking/devlink/nfp.rst b/Documentation/networking/devlink/nfp.rst
new file mode 100644
index 000000000000..bbb3c6b2280c
--- /dev/null
+++ b/Documentation/networking/devlink/nfp.rst
@@ -0,0 +1,20 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================
+nfp devlink support
+===================
+
+This document describes the devlink features implemented by the ``nfp``
+device driver.
+
+Parameters
+==========
+
+.. list-table:: Generic parameters implemented
+
+   * - Name
+     - Mode
+   * - ``fw_load_policy``
+     - permanent
+   * - ``reset_dev_on_drv_probe``
+     - permanent
diff --git a/Documentation/networking/devlink/ti-cpsw-switch.rst b/Documentation/networking/devlink/ti-cpsw-switch.rst
new file mode 100644
index 000000000000..dc399e32abaa
--- /dev/null
+++ b/Documentation/networking/devlink/ti-cpsw-switch.rst
@@ -0,0 +1,31 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============================
+ti-cpsw-switch devlink support
+==============================
+
+This document describes the devlink features implemented by the ``ti-cpsw-switch``
+device driver.
+
+Parameters
+==========
+
+The ``ti-cpsw-switch`` driver implements the following driver-specific
+parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``ale_bypass``
+     - Boolean
+     - runtime
+     - Enables ALE_CONTROL(4).BYPASS mode for debugging purposes. In this
+       mode, all packets will be sent to the host port only.
+   * - ``switch_mode``
+     - Boolean
+     - runtime
+     - Enable switch mode
diff --git a/MAINTAINERS b/MAINTAINERS
index b4512918d33e..9b277c3ac1eb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9890,7 +9890,7 @@ S:	Maintained
 F:	drivers/net/dsa/mv88e6xxx/
 F:	include/linux/platform_data/mv88e6xxx.h
 F:	Documentation/devicetree/bindings/net/dsa/marvell.txt
-F:	Documentation/networking/devlink-params-mv88e6xxx.txt
+F:	Documentation/networking/devlink/mv88e6xxx.rst
 
 MARVELL ARMADA DRM SUPPORT
 M:	Russell King <linux@armlinux.org.uk>
-- 
2.25.0.rc1

