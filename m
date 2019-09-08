Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51913AD150
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 01:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbfIHXzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 19:55:14 -0400
Received: from mail-qt1-f179.google.com ([209.85.160.179]:38692 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731675AbfIHXzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 19:55:11 -0400
Received: by mail-qt1-f179.google.com with SMTP id b2so14136406qtq.5
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 16:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=INumR7NpyhxctnUiH8eSiMISlDBQHE0cLlhCKcV3eyk=;
        b=Epl+RTl1oTm3S3AY/IZotMwyK0PHPEnR6liIV7+ljOcGs7DA9ihSnfvRyoFwA0meZj
         scrAaba57/S2eFhBt5eqq2ZQtH2F9z/3Zu4UFJD+M1lwN1L10h9MLXJ89QrSBLGFTKdX
         Vig19SH+OTY/Me3Fyphsv1nc6u0hBfdL7hInRG5OHp8NrgC4pXohihbQoyHug7MhJ4il
         jF6Nkcm4Aayqgm2/kJe6uJovKVj56EGOpxwXJz6wiQDz4AwJkadaKp+QoujGaoIemO5M
         ON6zM7xK14mgb3jHwyMbIF00O3n0YvwuE3CXW6oEVuSqgVEIbOsBgMmI1gwfRjLhVLHq
         NYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=INumR7NpyhxctnUiH8eSiMISlDBQHE0cLlhCKcV3eyk=;
        b=Hp8d69/ZCyDTax2Y7IqvwotFiVCOwDhjw44we9caZsNXgaEe0xJdFLUaV7uzrDhQoI
         b1ZN/6o5FQ4rBlF6P0QAtI6cboGo+JouSh2tT3eNfg8eGFNAYjSuZrFDHaD7ZaSjpQbt
         Sstu2HHPqN9UandtMB0oitdo+xM2QUvoJ3ajAG1k7IECzefoK6+VcTp2UTpmuRbIrINq
         3GIbHYg/0hTKk9Xjr6Z2dVNVbtuQxk4BlakeiRIuHzZTDPgkMDuAbkYIZqw8wwSuGhSG
         eMjPA6WSEg8ZzyJ5CWvoPkaUb1otPo/UNPh+m4EB1Go1qXYFgb3SbXZi0Ki02va6NgyS
         RF9A==
X-Gm-Message-State: APjAAAUFUeHj10ZFwl5iq5obVoIGpDZevxovuYqUnPG4+LaPSLA5EztU
        XUK5ByEpiXhxRx+zVwYzXetqMA==
X-Google-Smtp-Source: APXvYqwP37yOdgusaCv+L7fhZ+c5bQbRlHPs90xFZODFiLy2NUyeqAtt9jPSXDSiE3pDah9kQCvW6g==
X-Received: by 2002:ad4:5303:: with SMTP id y3mr13043510qvr.19.1567986910163;
        Sun, 08 Sep 2019 16:55:10 -0700 (PDT)
Received: from penelope.pa.netronome.com (195-23-252-147.net.novis.pt. [195.23.252.147])
        by smtp.gmail.com with ESMTPSA id p27sm5464406qkm.92.2019.09.08.16.55.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 16:55:09 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 11/11] Documentation: nfp: add nfp driver specific notes
Date:   Mon,  9 Sep 2019 00:54:27 +0100
Message-Id: <20190908235427.9757-12-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190908235427.9757-1-simon.horman@netronome.com>
References: <20190908235427.9757-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

This adds the initial documentation for the NFP driver specific
documentation.

Right now, only basic information is provided about acquiring firmware
and configuring device firmware loading.

Original driver documentation can be found here:
https://github.com/Netronome/nfp-drv-kmods/blob/master/README.md

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 .../networking/device_drivers/netronome/nfp.rst    | 133 +++++++++++++++++++++
 1 file changed, 133 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/netronome/nfp.rst

diff --git a/Documentation/networking/device_drivers/netronome/nfp.rst b/Documentation/networking/device_drivers/netronome/nfp.rst
new file mode 100644
index 000000000000..6c08ac8b5147
--- /dev/null
+++ b/Documentation/networking/device_drivers/netronome/nfp.rst
@@ -0,0 +1,133 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+=============================================
+Netronome Flow Processor (NFP) Kernel Drivers
+=============================================
+
+Copyright (c) 2019, Netronome Systems, Inc.
+
+Contents
+========
+
+- `Overview`_
+- `Acquiring Firmware`_
+
+Overview
+========
+
+This driver supports Netronome's line of Flow Processor devices,
+including the NFP4000, NFP5000, and NFP6000 models, which are also
+incorporated in the company's family of Agilio SmartNICs. The SR-IOV
+physical and virtual functions for these devices are supported by
+the driver.
+
+Acquiring Firmware
+==================
+
+The NFP4000 and NFP6000 devices require application specific firmware
+to function.  Application firmware can be located either on the host file system
+or in the device flash (if supported by management firmware).
+
+Firmware files on the host filesystem contain card type (`AMDA-*` string), media
+config etc.  They should be placed in `/lib/firmware/netronome` directory to
+load firmware from the host file system.
+
+Firmware for basic NIC operation is available in the upstream
+`linux-firmware.git` repository.
+
+Firmware in NVRAM
+-----------------
+
+Recent versions of management firmware supports loading application
+firmware from flash when the host driver gets probed.  The firmware loading
+policy configuration may be used to configure this feature appropriately.
+
+Devlink or ethtool can be used to update the application firmware on the device
+flash by providing the appropriate `nic_AMDA*.nffw` file to the respective
+command.  Users need to take care to write the correct firmware image for the
+card and media configuration to flash.
+
+Available storage space in flash depends on the card being used.
+
+Dealing with multiple projects
+------------------------------
+
+NFP hardware is fully programmable therefore there can be different
+firmware images targeting different applications.
+
+When using application firmware from host, we recommend placing
+actual firmware files in application-named subdirectories in
+`/lib/firmware/netronome` and linking the desired files, e.g.::
+
+    $ tree /lib/firmware/netronome/
+    /lib/firmware/netronome/
+    ├── bpf
+    │   ├── nic_AMDA0081-0001_1x40.nffw
+    │   └── nic_AMDA0081-0001_4x10.nffw
+    ├── flower
+    │   ├── nic_AMDA0081-0001_1x40.nffw
+    │   └── nic_AMDA0081-0001_4x10.nffw
+    ├── nic
+    │   ├── nic_AMDA0081-0001_1x40.nffw
+    │   └── nic_AMDA0081-0001_4x10.nffw
+    ├── nic_AMDA0081-0001_1x40.nffw -> bpf/nic_AMDA0081-0001_1x40.nffw
+    └── nic_AMDA0081-0001_4x10.nffw -> bpf/nic_AMDA0081-0001_4x10.nffw
+
+    3 directories, 8 files
+
+You may need to use hard instead of symbolic links on distributions
+which use old `mkinitrd` command instead of `dracut` (e.g. Ubuntu).
+
+After changing firmware files you may need to regenerate the initramfs
+image.  Initramfs contains drivers and firmware files your system may
+need to boot.  Refer to the documentation of your distribution to find
+out how to update initramfs.  Good indication of stale initramfs
+is system loading wrong driver or firmware on boot, but when driver is
+later reloaded manually everything works correctly.
+
+Selecting firmware per device
+-----------------------------
+
+Most commonly all cards on the system use the same type of firmware.
+If you want to load specific firmware image for a specific card, you
+can use either the PCI bus address or serial number.  Driver will print
+which files it's looking for when it recognizes a NFP device::
+
+    nfp: Looking for firmware file in order of priority:
+    nfp:  netronome/serial-00-12-34-aa-bb-cc-10-ff.nffw: not found
+    nfp:  netronome/pci-0000:02:00.0.nffw: not found
+    nfp:  netronome/nic_AMDA0081-0001_1x40.nffw: found, loading...
+
+In this case if file (or link) called *serial-00-12-34-aa-bb-5d-10-ff.nffw*
+or *pci-0000:02:00.0.nffw* is present in `/lib/firmware/netronome` this
+firmware file will take precedence over `nic_AMDA*` files.
+
+Note that `serial-*` and `pci-*` files are **not** automatically included
+in initramfs, you will have to refer to documentation of appropriate tools
+to find out how to include them.
+
+Firmware loading policy
+-----------------------
+
+Firmware loading policy is controlled via three HWinfo parameters
+stored as key value pairs in the device flash:
+
+app_fw_from_flash
+    Defines which firmware should take precedence, 'Disk' (0), 'Flash' (1) or
+    the 'Preferred' (2) firmware. When 'Preferred' is selected, the management
+    firmware makes the decision over which firmware will be loaded by comparing
+    versions of the flash firmware and the host supplied firmware.
+    This variable is configurable using the 'fw_load_policy'
+    devlink parameter.
+
+abi_drv_reset
+    Defines if the driver should reset the firmware when
+    the driver is probed, either 'Disk' (0) if firmware was found on disk,
+    'Always' (1) reset or 'Never' (2) reset. Note that the device is always
+    reset on driver unload if firmware was loaded when the driver was probed.
+    This variable is configurable using the 'reset_dev_on_drv_probe'
+    devlink parameter.
+
+abi_drv_load_ifc
+    Defines a list of PF devices allowed to load FW on the device.
+    This variable is not currently user configurable.
-- 
2.11.0

