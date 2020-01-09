Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50BA6136362
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgAIWqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:46:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:46855 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728848AbgAIWqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926803"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:37 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 02/17] devlink: move devlink documentation to subfolder
Date:   Thu,  9 Jan 2020 14:46:10 -0800
Message-Id: <20200109224625.1470433-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Combine the documentation for devlink into a subfolder, and provide an
index.rst file that can be used to generally describe devlink.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../networking/{ => devlink}/devlink-health.txt    |  0
 .../{ => devlink}/devlink-info-versions.rst        |  0
 .../{ => devlink}/devlink-params-bnxt.txt          |  0
 .../{ => devlink}/devlink-params-mlx5.txt          |  0
 .../{ => devlink}/devlink-params-mlxsw.txt         |  0
 .../{ => devlink}/devlink-params-mv88e6xxx.txt     |  0
 .../{ => devlink}/devlink-params-nfp.txt           |  0
 .../devlink-params-ti-cpsw-switch.txt              |  0
 .../networking/{ => devlink}/devlink-params.txt    |  0
 .../{ => devlink}/devlink-trap-netdevsim.rst       |  0
 .../networking/{ => devlink}/devlink-trap.rst      |  0
 Documentation/networking/devlink/index.rst         | 14 ++++++++++++++
 Documentation/networking/index.rst                 |  4 +---
 MAINTAINERS                                        |  1 +
 drivers/net/netdevsim/dev.c                        |  2 +-
 include/net/devlink.h                              |  4 ++--
 16 files changed, 19 insertions(+), 6 deletions(-)
 rename Documentation/networking/{ => devlink}/devlink-health.txt (100%)
 rename Documentation/networking/{ => devlink}/devlink-info-versions.rst (100%)
 rename Documentation/networking/{ => devlink}/devlink-params-bnxt.txt (100%)
 rename Documentation/networking/{ => devlink}/devlink-params-mlx5.txt (100%)
 rename Documentation/networking/{ => devlink}/devlink-params-mlxsw.txt (100%)
 rename Documentation/networking/{ => devlink}/devlink-params-mv88e6xxx.txt (100%)
 rename Documentation/networking/{ => devlink}/devlink-params-nfp.txt (100%)
 rename Documentation/networking/{ => devlink}/devlink-params-ti-cpsw-switch.txt (100%)
 rename Documentation/networking/{ => devlink}/devlink-params.txt (100%)
 rename Documentation/networking/{ => devlink}/devlink-trap-netdevsim.rst (100%)
 rename Documentation/networking/{ => devlink}/devlink-trap.rst (100%)
 create mode 100644 Documentation/networking/devlink/index.rst

diff --git a/Documentation/networking/devlink-health.txt b/Documentation/networking/devlink/devlink-health.txt
similarity index 100%
rename from Documentation/networking/devlink-health.txt
rename to Documentation/networking/devlink/devlink-health.txt
diff --git a/Documentation/networking/devlink-info-versions.rst b/Documentation/networking/devlink/devlink-info-versions.rst
similarity index 100%
rename from Documentation/networking/devlink-info-versions.rst
rename to Documentation/networking/devlink/devlink-info-versions.rst
diff --git a/Documentation/networking/devlink-params-bnxt.txt b/Documentation/networking/devlink/devlink-params-bnxt.txt
similarity index 100%
rename from Documentation/networking/devlink-params-bnxt.txt
rename to Documentation/networking/devlink/devlink-params-bnxt.txt
diff --git a/Documentation/networking/devlink-params-mlx5.txt b/Documentation/networking/devlink/devlink-params-mlx5.txt
similarity index 100%
rename from Documentation/networking/devlink-params-mlx5.txt
rename to Documentation/networking/devlink/devlink-params-mlx5.txt
diff --git a/Documentation/networking/devlink-params-mlxsw.txt b/Documentation/networking/devlink/devlink-params-mlxsw.txt
similarity index 100%
rename from Documentation/networking/devlink-params-mlxsw.txt
rename to Documentation/networking/devlink/devlink-params-mlxsw.txt
diff --git a/Documentation/networking/devlink-params-mv88e6xxx.txt b/Documentation/networking/devlink/devlink-params-mv88e6xxx.txt
similarity index 100%
rename from Documentation/networking/devlink-params-mv88e6xxx.txt
rename to Documentation/networking/devlink/devlink-params-mv88e6xxx.txt
diff --git a/Documentation/networking/devlink-params-nfp.txt b/Documentation/networking/devlink/devlink-params-nfp.txt
similarity index 100%
rename from Documentation/networking/devlink-params-nfp.txt
rename to Documentation/networking/devlink/devlink-params-nfp.txt
diff --git a/Documentation/networking/devlink-params-ti-cpsw-switch.txt b/Documentation/networking/devlink/devlink-params-ti-cpsw-switch.txt
similarity index 100%
rename from Documentation/networking/devlink-params-ti-cpsw-switch.txt
rename to Documentation/networking/devlink/devlink-params-ti-cpsw-switch.txt
diff --git a/Documentation/networking/devlink-params.txt b/Documentation/networking/devlink/devlink-params.txt
similarity index 100%
rename from Documentation/networking/devlink-params.txt
rename to Documentation/networking/devlink/devlink-params.txt
diff --git a/Documentation/networking/devlink-trap-netdevsim.rst b/Documentation/networking/devlink/devlink-trap-netdevsim.rst
similarity index 100%
rename from Documentation/networking/devlink-trap-netdevsim.rst
rename to Documentation/networking/devlink/devlink-trap-netdevsim.rst
diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
similarity index 100%
rename from Documentation/networking/devlink-trap.rst
rename to Documentation/networking/devlink/devlink-trap.rst
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
new file mode 100644
index 000000000000..1252c2a1b680
--- /dev/null
+++ b/Documentation/networking/devlink/index.rst
@@ -0,0 +1,14 @@
+Linux Devlink Documentation
+===========================
+
+devlink is an API to expose device information and resources not directly
+related to any device class, such as chip-wide/switch-ASIC-wide configuration.
+
+Contents:
+
+.. toctree::
+   :maxdepth: 1
+
+   devlink-info-versions
+   devlink-trap
+   devlink-trap-netdevsim
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index bee73be7af93..d07d9855dcd3 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -13,9 +13,7 @@ Contents:
    can_ucan_protocol
    device_drivers/index
    dsa/index
-   devlink-info-versions
-   devlink-trap
-   devlink-trap-netdevsim
+   devlink/index
    ethtool-netlink
    ieee802154
    j1939
diff --git a/MAINTAINERS b/MAINTAINERS
index 66a2e5e07117..b4512918d33e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4848,6 +4848,7 @@ S:	Supported
 F:	net/core/devlink.c
 F:	include/net/devlink.h
 F:	include/uapi/linux/devlink.h
+F:	Documentation/networking/devlink
 
 DIALOG SEMICONDUCTOR DRIVERS
 M:	Support Opensource <support.opensource@diasemi.com>
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 4ed9c8d8de7c..2eb4ca564745 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -287,7 +287,7 @@ struct nsim_trap_data {
 };
 
 /* All driver-specific traps must be documented in
- * Documentation/networking/devlink-trap-netdevsim.rst
+ * Documentation/networking/devlink/devlink-trap-netdevsim.rst
  */
 enum {
 	NSIM_TRAP_ID_BASE = DEVLINK_TRAP_GENERIC_ID_MAX,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 55fc1e0e6513..4622ae37785a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -568,7 +568,7 @@ struct devlink_trap {
 };
 
 /* All traps must be documented in
- * Documentation/networking/devlink-trap.rst
+ * Documentation/networking/devlink/devlink-trap.rst
  */
 enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_SMAC_MC,
@@ -602,7 +602,7 @@ enum devlink_trap_generic_id {
 };
 
 /* All trap groups must be documented in
- * Documentation/networking/devlink-trap.rst
+ * Documentation/networking/devlink/devlink-trap.rst
  */
 enum devlink_trap_group_generic_id {
 	DEVLINK_TRAP_GROUP_GENERIC_ID_L2_DROPS,
-- 
2.25.0.rc1

