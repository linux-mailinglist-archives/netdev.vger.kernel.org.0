Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A287F13636F
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgAIWrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:47:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:46885 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729293AbgAIWqu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926870"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:49 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH 13/17] devlink: add documentation for ionic device driver
Date:   Thu,  9 Jan 2020 14:46:21 -0800
Message-Id: <20200109224625.1470433-14-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IONIC device driver allocates a devlink and reports versions. Add
documentation for this driver.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Shannon Nelson <snelson@pensando.io>
---
 Documentation/networking/devlink/index.rst |  1 +
 Documentation/networking/devlink/ionic.rst | 29 ++++++++++++++++++++++
 2 files changed, 30 insertions(+)
 create mode 100644 Documentation/networking/devlink/ionic.rst

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 3d351beedb0a..ce0ee563d83a 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -30,6 +30,7 @@ parameters, info versions, and other features it supports.
    :maxdepth: 1
 
    bnxt
+   ionic
    mlx4
    mlx5
    mlxsw
diff --git a/Documentation/networking/devlink/ionic.rst b/Documentation/networking/devlink/ionic.rst
new file mode 100644
index 000000000000..48da9c92d584
--- /dev/null
+++ b/Documentation/networking/devlink/ionic.rst
@@ -0,0 +1,29 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================
+ionic devlink support
+=====================
+
+This document describes the devlink features implemented by the ``ionic``
+device driver.
+
+Info versions
+=============
+
+The ``ionic`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``fw``
+     - running
+     - Version of firmware running on the device
+   * - ``asic.id``
+     - fixed
+     - The ASIC type for this device
+   * - ``asic.rev``
+     - fixed
+     - The revision of the ASIC for this device
-- 
2.25.0.rc1

