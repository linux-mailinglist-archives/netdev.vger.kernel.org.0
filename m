Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C566302BB
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiKRXOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbiKRXNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:45 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8497FCC165
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:57 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 130so6211811pgc.5
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ycCau+ERnFNtdV8h6bYOgIHnoYWi+KmCz0bZPVMNHlc=;
        b=CS3X2tE6sxkjsnKlCEFn1d/MBASMXqux9SD2PeDi6FP3L/THACuSGREwB6U/Hp+Jch
         teXKxdONxi9eY0YY5pjrvq7HX6ezMQqS9iqUNEbrEm0HTkrJiOwATv4oj0M+DjP7Pxkr
         OLZEz17FvrpOisFIaiabzr63orrX5NY6e+fEUEEOyOHwgSjtddPDlViddSCvBUST0RJn
         c6+uuth1Sx9UKRxeLn2iR61eBJz49tDVJ/lTP0Oam9+BDIltlyq8EQEZ/bDG3TJkBWS0
         jq4Mnrcz2Jh64yVh4SEgm+avBQ3z+hdltSiqOJerUWi/KcG5LJVXYQ4npmozaWIcwR7b
         tPfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ycCau+ERnFNtdV8h6bYOgIHnoYWi+KmCz0bZPVMNHlc=;
        b=2abM0+IDzVNSJkUwnjFG8ewjXlcSla5VHHYefw8RqDJe4g9iLTBQHYB2kvpkR+gLI8
         dmH7mj1pEYk9nbjOLEQwCsSAmdipUxZncZ9lh+7UE7Odng7WBHPiW1/V7Gsq5WVzBASx
         1LP9m1OXM5SG5x+4HMr3z6rz69UrcIgXJfCa4LDDro1VIKMzyPpGNPgvjzoHjOb6qKmz
         f0stZWt7iVAjpdUEbhDoIkRcHQiEwDoHnqV+mirIWUsNaUEDaj9qzhhVW9enF15HmYXc
         956ChzzO116coZsJb740N8aw3WmK8erkYJCPO8968AJ7hHlNO7AgfT8gqsuIFtKUp5G8
         UVjw==
X-Gm-Message-State: ANoB5plSGacZvqOGPLFJNMqXzfdmiiHx/v0LzfXkHMiE2+cLlc3HF+c2
        1KFyVkt+d/nbyjZEfFWfEtE5REty5JgrzA==
X-Google-Smtp-Source: AA0mqf5wiqqPAt/Lh2oPa5F0oiOoEmZp5VqC6rC/G6s8QPZK0EWOHLOI0m6aNIu68RoM2SR4JtyO/A==
X-Received: by 2002:a63:7353:0:b0:477:467e:357f with SMTP id d19-20020a637353000000b00477467e357fmr1197086pgn.263.1668812249873;
        Fri, 18 Nov 2022 14:57:29 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:29 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 13/19] pds_core: Kconfig and pds_core.rst
Date:   Fri, 18 Nov 2022 14:56:50 -0800
Message-Id: <20221118225656.48309-14-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118225656.48309-1-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation and Kconfig hook for building the driver.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/pds_core.rst            | 162 ++++++++++++++++++
 MAINTAINERS                                   |   3 +-
 drivers/net/ethernet/pensando/Kconfig         |  12 ++
 3 files changed, 176 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_core.rst

diff --git a/Documentation/networking/device_drivers/ethernet/pensando/pds_core.rst b/Documentation/networking/device_drivers/ethernet/pensando/pds_core.rst
new file mode 100644
index 000000000000..9c2c0c866e0a
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/pensando/pds_core.rst
@@ -0,0 +1,162 @@
+.. SPDX-License-Identifier: GPL-2.0+
+.. note: can be edited and viewed with /usr/bin/formiko-vim
+
+========================================================
+Linux Driver for the Pensando(R) DSC adapter family
+========================================================
+
+Pensando Linux Core driver.
+Copyright(c) 2022 Pensando Systems, Inc
+
+Identifying the Adapter
+=======================
+
+To find if one or more Pensando PCI Core devices are installed on the
+host, check for the PCI devices::
+
+  # lspci -d 1dd8:100c
+  39:00.0 Processing accelerators: Pensando Systems Device 100c
+  3a:00.0 Processing accelerators: Pensando Systems Device 100c
+
+If such devices are listed as above, then the pds_core.ko driver should find
+and configure them for use.  There should be log entries in the kernel
+messages such as these::
+
+  $ dmesg | grep pds_core
+  pds_core 0000:b5:00.0: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
+  pds_core 0000:b5:00.0: FW: 1.51.0-73
+  pds_core 0000:b6:00.0: 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
+  pds_core 0000:b5:00.0: FW: 1.51.0-73
+
+Driver and firmware version information can be gathered with devlink::
+
+  $ devlink dev info pci/0000:b5:00.0
+  pci/0000:b5:00.0:
+    driver pds_core
+    serial_number FLM18420073
+    versions:
+        fixed:
+          asic.id 0x0
+          asic.rev 0x0
+        running:
+          fw 1.51.0-73
+        stored:
+          fw.goldfw 1.15.9-C-22
+          fw.mainfwa 1.51.0-73
+          fw.mainfwb 1.51.0-57
+
+
+Info versions
+=============
+
+The ``pds_core`` driver reports the following versions
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
+   * - ``fw.goldfw``
+     - stored
+     - Version of firmware stored in the goldfw slot
+   * - ``fw.mainfwa``
+     - stored
+     - Version of firmware stored in the mainfwa slot
+   * - ``fw.mainfwb``
+     - stored
+     - Version of firmware stored in the mainfwb slot
+   * - ``asic.id``
+     - fixed
+     - The ASIC type for this device
+   * - ``asic.rev``
+     - fixed
+     - The revision of the ASIC for this device
+
+
+Parameters
+==========
+
+The ``pds_core`` driver implements the following generic
+parameters for controlling the functionality to be made available
+as auxiliary_bus devices.
+
+.. list-table:: Generic parameters implemented
+   :widths: 5 5 8 82
+
+   * - Name
+     - Mode
+     - Type
+     - Description
+   * - ``enable_vnet``
+     - runtime
+     - Boolean
+     - Enables vDPA functionality through an auxiliary_bus device
+
+
+The ``pds_core`` driver also implements the following driver-specific
+parameters for similar uses, as well as for selecting the next boot firmware:
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 8 82
+
+   * - Name
+     - Mode
+     - Type
+     - Description
+   * - ``enable_lm``
+     - runtime
+     - Boolean
+     - Enables Live Migration functionality through an auxiliary_bus device
+   * - ``boot_fw``
+     - runtime
+     - String
+     - Selects the Firmware slot to use for the next DSC boot
+
+
+Firmware Management
+===================
+
+Using the ``devlink`` utility's ``flash`` command the DSC firmware can be
+updated.  The downloaded firmware will be loaded into either of mainfwa or
+mainfwb firmware slots, whichever is not currrently in use, and that slot
+will be then selected for the next boot.  The firmware currently in use can
+be found by inspecting the ``running`` firmware from the devlink dev info.
+
+The ``boot_fw`` parameter can inspect and select the firmware slot to be
+used in the next DSC boot up.  The mainfwa and mainfwb slots are used for
+for normal operations, and the goldfw slot should only be selected for
+recovery purposes if both the other slots have bad or corrupted firmware.
+
+
+Enabling the driver
+===================
+
+The driver is enabled via the standard kernel configuration system,
+using the make command::
+
+  make oldconfig/menuconfig/etc.
+
+The driver is located in the menu structure at:
+
+  -> Device Drivers
+    -> Network device support (NETDEVICES [=y])
+      -> Ethernet driver support
+        -> Pensando devices
+          -> Pensando Ethernet PDS_CORE Support
+
+Support
+=======
+
+For general Linux networking support, please use the netdev mailing
+list, which is monitored by Pensando personnel::
+
+  netdev@vger.kernel.org
+
+For more specific support needs, please use the Pensando driver support
+email::
+
+  drivers@pensando.io
diff --git a/MAINTAINERS b/MAINTAINERS
index 14ee1c72d01a..a4f989fa8192 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16150,8 +16150,9 @@ M:	Shannon Nelson <snelson@pensando.io>
 M:	drivers@pensando.io
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	Documentation/networking/device_drivers/ethernet/pensando/ionic.rst
+F:	Documentation/networking/device_drivers/ethernet/pensando/
 F:	drivers/net/ethernet/pensando/
+F:	include/linux/pds/
 
 PER-CPU MEMORY ALLOCATOR
 M:	Dennis Zhou <dennis@kernel.org>
diff --git a/drivers/net/ethernet/pensando/Kconfig b/drivers/net/ethernet/pensando/Kconfig
index 3f7519e435b8..d9e8973d54f6 100644
--- a/drivers/net/ethernet/pensando/Kconfig
+++ b/drivers/net/ethernet/pensando/Kconfig
@@ -17,6 +17,18 @@ config NET_VENDOR_PENSANDO
 
 if NET_VENDOR_PENSANDO
 
+config PDS_CORE
+	tristate "Pensando Data Systems Core Device Support"
+	depends on 64BIT && PCI
+	help
+	  This enables the support for the Pensando Core device family of
+	  adapters.  More specific information on this driver can be
+	  found in
+	  <file:Documentation/networking/device_drivers/ethernet/pensando/pds_core.rst>.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called pds_core.
+
 config IONIC
 	tristate "Pensando Ethernet IONIC Support"
 	depends on 64BIT && PCI
-- 
2.17.1

