Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A555953D9
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiHPHeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiHPHde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:33:34 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2288A857F0
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 21:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660623157; x=1692159157;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DX85tPS9hedUJmSZ0tZr8nyryS6katkFiTveZtVs0K0=;
  b=iyMxle4GBXkW0iWEYCDgXyjBTcowIosMtDEAX5S7tE3tbL5kTlZ/BiCy
   EjKEy1GNuTOMcR+PrTS0F62k1WH/KwwRdgr4cYCBIUQm0oKOqS4ZG16RC
   cmaaUryIdjcCsbgAgFwoNIDwve2jBGpFTL5ZQHfDVhDvndLUNeIORWOnY
   9SHCYZDHq5cd4tFFQVBg/bcvl7FH+fxOmY4RVC0wz8qu98eqe1b2xjNZE
   W33pFBwg+SEotRylacEl+0/a0sLHCPCt09VXrtPzg8/04PQtHbRtHd7qN
   12rpxAIkHDdcvYW1kQ4lSKTcBvUhetSTKaKclETAo8BojAFgEVbK/aPcI
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="275173725"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="275173725"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 21:12:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="635730029"
Received: from bswcg005.iind.intel.com ([10.224.174.23])
  by orsmga008.jf.intel.com with ESMTP; 15 Aug 2022 21:12:33 -0700
From:   m.chetan.kumar@intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
Subject: [PATCH net-next 5/5] net: wwan: t7xx: Devlink documentation
Date:   Tue, 16 Aug 2022 09:54:17 +0530
Message-Id: <20220816042417.2416988-1-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
---
 Documentation/networking/devlink/index.rst |   1 +
 Documentation/networking/devlink/t7xx.rst  | 145 +++++++++++++++++++++
 2 files changed, 146 insertions(+)
 create mode 100644 Documentation/networking/devlink/t7xx.rst

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 850715512293..ed47de1d3b75 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -66,3 +66,4 @@ parameters, info versions, and other features it supports.
    prestera
    iosm
    octeontx2
+   t7xx
diff --git a/Documentation/networking/devlink/t7xx.rst b/Documentation/networking/devlink/t7xx.rst
new file mode 100644
index 000000000000..c0c83ed2d38b
--- /dev/null
+++ b/Documentation/networking/devlink/t7xx.rst
@@ -0,0 +1,145 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+t7xx devlink support
+====================
+
+This document describes the devlink features implemented by the ``t7xx``
+device driver.
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
+procedure, fastboot command's & response's are exchanged between driver
+and wwan device.
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
+Note: component "value" represents the partition type to be programmed.
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
+      - The detailed modem components log are captured in this region
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

