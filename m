Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B40CABD3A
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395061AbfIFQB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:01:28 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:50209 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbfIFQBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:01:25 -0400
Received: by mail-wm1-f43.google.com with SMTP id c10so7096150wmc.0
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sCHpQCcwyG1Tbe8ndR8Fj+dxUy3O/X90uff0dX2UeSw=;
        b=bHnoEls2W9Av9H591MMPVmLSc7r+qILluQflM/QIA5GDUqhqJvuyHpvugD60rGd3bQ
         bdPCmsx7lJ0p0HVsQifoTiEOoZRRN362AEk5XIS5F2854p0ulkG1KQ/OCAYOO4r/ZTwU
         eDS2jhO+mimnx/3eQYk3uaPKd+V8AVcEdNUIVOh2hMZ44wU96GjMl8dP85g61VwBEQKe
         dpkZHPLYsO51CbeKYC2A2zO1OpDuIhgJLrNDvgOrMbCi3gaDhF5R1GkDmqnd9Pij4RVA
         5O2hS4eLJ4RJgppl2u4IM2ZivDXNNhVB4IkT/8iIxWcuD/A4OP90z/jXrc5NbCIfWrH5
         PnRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sCHpQCcwyG1Tbe8ndR8Fj+dxUy3O/X90uff0dX2UeSw=;
        b=kCh8kpStyng29C7PJgxqeNbcSaQJH4Mf4QwFj3y40OyEQJ1EODGvF1IN9YlT+6Nf/Z
         8RKI1aUU/ehx1XrAFk7QBAcCbwYAwBTXxgOyBpIvyGOJD0JHqgbqj3GltdSm0JsuJlLC
         g+3k03xYyixYeElG7nefywvc4Amp7jvWeXRoECwoU6GD8+ZIzh8HpQVvhOyw5FYzlY5A
         mLRLytFfbpgk0rHi6FyMeuR0IXz8mB4rzN0+BOLmFuZslpWEEJ6A7HQbsbOiZqDoDdN4
         xr+rB8zbqE8Wv9hArXqyr9PZ3Ya3h+pGJEPmPO/CUJawP7fe3usb1uH91wH5XoSL2v9/
         fowA==
X-Gm-Message-State: APjAAAVTyDlnvo1Olb4UKFZTrT3wIj+EXVlNYcUxaHCvz3qmPMDb0bw0
        A6/V0c1VvTPwaccTTuUKMyfw3g==
X-Google-Smtp-Source: APXvYqyFzfxAhmSIQXgxrLfx2Kw7LfUITMt/I5ySCV1A9putA8VGG45GfRbNwHczr/fOkc/E8r5MVA==
X-Received: by 2002:a1c:24c3:: with SMTP id k186mr7933214wmk.126.1567785683331;
        Fri, 06 Sep 2019 09:01:23 -0700 (PDT)
Received: from reginn.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id s1sm8524567wrg.80.2019.09.06.09.01.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:01:22 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [net-next 11/11] Documentation: nfp: add nfp driver specific notes
Date:   Fri,  6 Sep 2019 18:01:01 +0200
Message-Id: <20190906160101.14866-12-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906160101.14866-1-simon.horman@netronome.com>
References: <20190906160101.14866-1-simon.horman@netronome.com>
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

