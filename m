Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F9067668C
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 14:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjAUNej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 08:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjAUNei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 08:34:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DBA49430;
        Sat, 21 Jan 2023 05:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674308076; x=1705844076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YTo9XdCPLUIuEozMh2J4WJXDRm/6gdlVCFZsPnk++0U=;
  b=ULVZYjQnRyqUJzwujlblb1rwj34L29fslh4eRkGXxzbxT38P8gavAuH6
   11Rq8nH+qcbemMLkapn7IYiMr/X57iyAzqszj+njY2V59fVTPzJPsOjVH
   Oebr4Wfmhm0SFcbspg55dvsJ22jPIGMGZuAzh1kGBJH6KjzUZ80o5UPss
   XweFEQton8eR/eWrDtA2Axnik/iUPSI/i2hSh+xAsxH6LCXEcySK2SXTs
   mdYuCj5n880azfTtM28BEPKPUG5Evfp+BtL6gXeEFR2WhIIqMACvsbnPs
   8BMmNVdyRYisj+lBsKu5/y+Cxqacnvw9HZ5NDTDbRo9HDK4JuGvz+1Q8g
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="323474410"
X-IronPort-AV: E=Sophos;i="5.97,235,1669104000"; 
   d="scan'208";a="323474410"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2023 05:34:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="662844793"
X-IronPort-AV: E=Sophos;i="5.97,235,1669104000"; 
   d="scan'208";a="662844793"
Received: from bswcg005.iind.intel.com ([10.224.174.136])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jan 2023 05:34:30 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com, linuxwwan_5g@intel.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, jiri@nvidia.com
Subject: [PATCH v5 net-next 5/5] net: wwan: t7xx: Devlink documentation
Date:   Sat, 21 Jan 2023 19:03:58 +0530
Message-Id: <f902d4a0cb807a205687f7e693079fba72ca7341.1674307425.git.m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1674307425.git.m.chetan.kumar@linux.intel.com>
References: <cover.1674307425.git.m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Document the t7xx devlink commands usage for firmware flashing &
coredump collection.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
--
v5:
 * No Change.
v4:
 * Spell out fw as firmware.
 * Drop "Refer to t7xx.rst file for details" in commit message.
 * Move explanation below commands under flash update.
 * Move firmware image type list under flash commands.
 * Keyword formatting.
 * Trim the unneeded trailing colon.
 * Describe region commands.
v3:
 * No change.
v2:
 * Documentation correction.
 * Add param details.
---
 Documentation/networking/devlink/index.rst |   1 +
 Documentation/networking/devlink/t7xx.rst  | 224 +++++++++++++++++++++
 2 files changed, 225 insertions(+)
 create mode 100644 Documentation/networking/devlink/t7xx.rst

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index fee4d3968309..0c4f5961e78f 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -66,3 +66,4 @@ parameters, info versions, and other features it supports.
    prestera
    iosm
    octeontx2
+   t7xx
diff --git a/Documentation/networking/devlink/t7xx.rst b/Documentation/networking/devlink/t7xx.rst
new file mode 100644
index 000000000000..dc795c8cc851
--- /dev/null
+++ b/Documentation/networking/devlink/t7xx.rst
@@ -0,0 +1,224 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+t7xx devlink support
+====================
+
+This document describes the devlink features implemented by the ``t7xx``
+device driver.
+
+Parameters
+==========
+The ``t7xx_driver`` driver implements the following driver-specific parameters.
+
+.. list-table:: Driver-specific parameters
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``fastboot``
+     - boolean
+     - driverinit
+     - Set this param to enter fastboot mode.
+
+Flash Update
+============
+
+The ``t7xx`` driver implements the flash update using the ``devlink-flash``
+interface.
+
+The driver uses ``DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT`` to identify the type of
+firmware image that need to be programmed upon the request by user space application.
+
+``t7xx`` driver uses fastboot protocol for firmware flashing. In the firmware
+flashing procedure, fastboot command & response are exchanged between driver
+and wwan device.
+
+::
+
+  $ devlink dev reload pci/0000:$bdf action driver_reinit
+
+The wwan device is put into fastboot mode via devlink reload command, by
+passing ``driver_reinit`` action.
+
+::
+
+  $ devlink dev reload pci/0000:$bdf action fw_activate
+
+Upon completion of firmware flashing or coredump collection the wwan device is
+reset to normal mode using devlink reload command, by passing ``fw_activate``
+action.
+
+Flash Commands
+--------------
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file preloader_k6880v1_mdot2_datacard.bin component "preloader"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file loader_ext-verified.img component "loader_ext1"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file tee-verified.img component "tee1"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file lk-verified.img component "lk"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file spmfw-verified.img component "spmfw"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file sspm-verified.img component "sspm_1"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file mcupm-verified.img component "mcupm_1"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file dpm-verified.img component "dpm_1"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file boot-verified.img component "boot"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file root.squashfs component "rootfs"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file modem-verified.img component "md1img"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file dsp-verified.bin component "md1dsp"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file OP_OTA.img component "mcf1"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file OEM_OTA.img component "mcf2"
+
+::
+
+  $ devlink dev flash pci/0000:$bdf file DEV_OTA.img component "mcf3"
+
+Note: Component selects the partition type to be programmed.
+
+
+The supported list of firmware image types is described below.
+
+.. list-table:: Firmware Image types
+    :widths: 15 85
+
+    * - Name
+      - Description
+    * - ``preloader``
+      - The first-stage bootloader image
+    * - ``loader_ext1``
+      - Preloader extension image
+    * - ``tee1``
+      - ARM trusted firmware and TEE (Trusted Execution Environment) image
+    * - ``lk``
+      - The second-stage bootloader image
+    * - ``spmfw``
+      - MediaTek in-house ASIC for power management image
+    * - ``sspm_1``
+      - MediaTek in-house ASIC for power management under secure world image
+    * - ``mcupm_1``
+      - MediaTek in-house ASIC for cpu power management image
+    * - ``dpm_1``
+      - MediaTek in-house ASIC for dram power management image
+    * - ``boot``
+      - The kernel and dtb image
+    * - ``rootfs``
+      - Root filesystem image
+    * - ``md1img``
+      - Modem image
+    * - ``md1dsp``
+      - Modem DSP image
+    * - ``mcf1``
+      - Modem OTA image (Modem Configuration Framework) for operators
+    * - ``mcf2``
+      - Modem OTA image (Modem Configuration Framework) for OEM vendors
+    * - ``mcf3``
+      - Modem OTA image (other usage) for OEM configurations
+
+
+Regions
+=======
+
+The ``t7xx`` driver supports core dump collection in exception state and second
+stage bootloader log collection in fastboot mode. The log snapshot is taken by
+the driver using fastboot commands.
+
+Region commands
+---------------
+
+::
+
+  $ devlink region show
+
+This command list the regions implemented by driver. These regions are accessed
+for device internal data. Below table describes the regions.
+
+.. list-table:: Regions
+    :widths: 15 85
+
+    * - Name
+      - Description
+    * - ``mr_dump``
+      - The detailed modem component logs are captured in this region
+    * - ``lk_dump``
+      - This region dumps the current snapshot of lk
+
+Coredump Collection
+~~~~~~~~~~~~~~~~~~~
+
+::
+
+  $ devlink region new mr_dump
+
+::
+
+  $ devlink region read mr_dump snapshot 0 address 0 length $len
+
+::
+
+  $ devlink region del mr_dump snapshot 0
+
+Note: $len is actual len to be dumped.
+
+The userspace application uses these commands for obtaining the modem component
+logs when device encounters an exception.
+
+Second Stage Bootloader dump
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+::
+
+  $ devlink region new lk_dump
+
+::
+
+  $ devlink region read lk_dump snapshot 0 address 0 length $len
+
+::
+
+  $ devlink region del lk_dump snapshot 0
+
+Note: $len is actual len to be dumped.
+
+In fastboot mode the userspace application uses these commands for obtaining the
+current snapshot of second stage bootloader.
-- 
2.34.1

