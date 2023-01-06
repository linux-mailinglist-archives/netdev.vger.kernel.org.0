Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D97D660446
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbjAFQ2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235516AbjAFQ2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:28:19 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8FA76EC8;
        Fri,  6 Jan 2023 08:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673022498; x=1704558498;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KPM4CYTOH2kJiIRbFngO28NyOGabwRen0ySdT9mHomU=;
  b=UMrnQAg/8Sb7rwoxghnkPvXgbIEFm8u5HvsJ+pl2ItU74+VYSgoy7kcB
   X563EZoVbhQd/TIN8N5PGdsQOlgbNLKicA3UoePeAbIo45SIjEOKIGL9f
   WPZShWU9XGe5SalB2EJhFlWt/XXu9pIuK4COFHE7DaleJ4NHdgA+ptIkT
   9TdSBMUWem2JD6NfHNq7wSDWRZIBNJ5NEad9b2iRv9aSodom35ChQlE5O
   w2a+b2zzvbX3kdUA9xyg2QbUC/5zN/d8LPL8YjzdUr86Z1PytQ5vPP+Kk
   hPbtolzODFPJTE6XR/bPVBKWE3afXUnLpQ/wQL9Up/FS2SO0PtXWR04Mx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="384808567"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="384808567"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 08:28:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="655987093"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="655987093"
Received: from bswcg005.iind.intel.com ([10.224.174.136])
  by orsmga002.jf.intel.com with ESMTP; 06 Jan 2023 08:28:11 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com, chandrashekar.devegowda@intel.com,
        m.chetan.kumar@linux.intel.com, matthias.bgg@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-doc@vger.kernel.org,
        jiri@nvidia.com, corbet@lwn.net
Subject: [PATCH v3 net-next 5/5] net: wwan: t7xx: Devlink documentation
Date:   Fri,  6 Jan 2023 21:58:06 +0530
Message-Id: <500a41cb400b4cdedd6df414b40200a5211965f5.1673016069.git.m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1673016069.git.m.chetan.kumar@linux.intel.com>
References: <cover.1673016069.git.m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Document the t7xx devlink commands usage for fw flashing &
coredump collection.

Refer to t7xx.rst file for details.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
--
v3:
 * No Change.
v2:
 * Documentation correction.
 * Add param details.
---
 Documentation/networking/devlink/index.rst |   1 +
 Documentation/networking/devlink/t7xx.rst  | 161 +++++++++++++++++++++
 2 files changed, 162 insertions(+)
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
index 000000000000..de220878ad76
--- /dev/null
+++ b/Documentation/networking/devlink/t7xx.rst
@@ -0,0 +1,161 @@
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
+.. list-table:: Driver-specific parameters implemented
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
+The driver uses DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT to identify the type of
+firmware image that need to be programmed upon the request by user space application.
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
+``t7xx`` driver uses fastboot protocol for fw flashing. In the fw flashing
+procedure, fastboot command & response are exchanged between driver and wwan
+device.
+
+The wwan device is put into fastboot mode via devlink reload command, by
+passing "driver_reinit" action.
+
+$ devlink dev reload pci/0000:$bdf action driver_reinit
+
+Upon completion of fw flashing or coredump collection the wwan device is
+reset to normal mode using devlink reload command, by passing "fw_activate"
+action.
+
+$ devlink dev reload pci/0000:$bdf action fw_activate
+
+Flash Commands:
+===============
+
+$ devlink dev flash pci/0000:$bdf file preloader_k6880v1_mdot2_datacard.bin component "preloader"
+
+$ devlink dev flash pci/0000:$bdf file loader_ext-verified.img component "loader_ext1"
+
+$ devlink dev flash pci/0000:$bdf file tee-verified.img component "tee1"
+
+$ devlink dev flash pci/0000:$bdf file lk-verified.img component "lk"
+
+$ devlink dev flash pci/0000:$bdf file spmfw-verified.img component "spmfw"
+
+$ devlink dev flash pci/0000:$bdf file sspm-verified.img component "sspm_1"
+
+$ devlink dev flash pci/0000:$bdf file mcupm-verified.img component "mcupm_1"
+
+$ devlink dev flash pci/0000:$bdf file dpm-verified.img component "dpm_1"
+
+$ devlink dev flash pci/0000:$bdf file boot-verified.img component "boot"
+
+$ devlink dev flash pci/0000:$bdf file root.squashfs component "rootfs"
+
+$ devlink dev flash pci/0000:$bdf file modem-verified.img component "md1img"
+
+$ devlink dev flash pci/0000:$bdf file dsp-verified.bin component "md1dsp"
+
+$ devlink dev flash pci/0000:$bdf file OP_OTA.img component "mcf1"
+
+$ devlink dev flash pci/0000:$bdf file OEM_OTA.img component "mcf2"
+
+$ devlink dev flash pci/0000:$bdf file DEV_OTA.img component "mcf3"
+
+Note: Component selects the partition type to be programmed.
+
+Regions
+=======
+
+The ``t7xx`` driver supports core dump collection when device encounters
+an exception. When wwan device encounters an exception, a snapshot of device
+internal data will be taken by the driver using fastboot commands.
+
+Following regions are accessed for device internal data.
+
+.. list-table:: Regions implemented
+    :widths: 15 85
+
+    * - Name
+      - Description
+    * - ``mr_dump``
+      - The detailed modem component logs are captured in this region
+    * - ``lk_dump``
+      - This region dumps the current snapshot of lk
+
+
+Region commands
+===============
+
+$ devlink region show
+
+
+$ devlink region new mr_dump
+
+$ devlink region read mr_dump snapshot 0 address 0 length $len
+
+$ devlink region del mr_dump snapshot 0
+
+$ devlink region new lk_dump
+
+$ devlink region read lk_dump snapshot 0 address 0 length $len
+
+$ devlink region del lk_dump snapshot 0
+
+Note: $len is actual len to be dumped.
-- 
2.34.1

