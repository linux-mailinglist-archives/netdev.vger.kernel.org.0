Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44B848E1F4
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 02:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbiANBHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 20:07:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:16341 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238614AbiANBGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 20:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642122415; x=1673658415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=+1CKek3NsGSxCfNbCgG4vuxkdRV3Dee4OF0iC2Mz5Io=;
  b=jHxVhv7R4c+zHULwI9oFzWP+/8aFx74xwOjB0+CMewzZ0jXIIlGDQE2j
   evzf0jKByuj9XbNdm8PvnzXYETn7e7pOgFG+HeBYHs4eRjurqixvuw1GT
   tFcPUrqDN+QYryJDa4GYEXzf0aA7Smwwy44snIJD/8NOoE2wlxwQ+pfHo
   zAAXYg0ihg7HiZpApzEKyf2NA1hsFLzIWvQeqXfDJNvllj5hlb1ihONGm
   BExgVaL1RuXxVNCmyHJdp5Bp7qU7qS943NP+ZUH7Y8lA6hDT295UCJ9mL
   3AiJI7riG0Nf98NsFBWFB4g4S2RzhwQ0Rb1/x1t1B53yzHaWXjoqbmLIZ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="231503641"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="231503641"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:55 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="692014227"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:54 -0800
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, ilpo.johannes.jarvinen@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next v4 13/13] net: wwan: t7xx: Add maintainers and documentation
Date:   Thu, 13 Jan 2022 18:06:27 -0700
Message-Id: <20220114010627.21104-14-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds maintainers and documentation for MediaTek t7xx 5G WWAN modem
device driver.

Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 .../networking/device_drivers/wwan/index.rst  |   1 +
 .../networking/device_drivers/wwan/t7xx.rst   | 120 ++++++++++++++++++
 MAINTAINERS                                   |  11 ++
 3 files changed, 132 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/wwan/t7xx.rst

diff --git a/Documentation/networking/device_drivers/wwan/index.rst b/Documentation/networking/device_drivers/wwan/index.rst
index 1cb8c7371401..370d8264d5dc 100644
--- a/Documentation/networking/device_drivers/wwan/index.rst
+++ b/Documentation/networking/device_drivers/wwan/index.rst
@@ -9,6 +9,7 @@ Contents:
    :maxdepth: 2
 
    iosm
+   t7xx
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/wwan/t7xx.rst b/Documentation/networking/device_drivers/wwan/t7xx.rst
new file mode 100644
index 000000000000..dd5b731957ca
--- /dev/null
+++ b/Documentation/networking/device_drivers/wwan/t7xx.rst
@@ -0,0 +1,120 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+.. Copyright (C) 2020-21 Intel Corporation
+
+.. _t7xx_driver_doc:
+
+============================================
+t7xx driver for MTK PCIe based T700 5G modem
+============================================
+The t7xx driver is a WWAN PCIe host driver developed for linux or Chrome OS platforms
+for data exchange over PCIe interface between Host platform & MediaTek's T700 5G modem.
+The driver exposes an interface conforming to the MBIM protocol [1]. Any front end
+application (e.g. Modem Manager) could easily manage the MBIM interface to enable
+data communication towards WWAN. The driver also provides an interface to interact
+with the MediaTek's modem via AT commands.
+
+Basic usage
+===========
+MBIM & AT functions are inactive when unmanaged. The t7xx driver provides
+WWAN port userspace interfaces representing MBIM & AT control channels and does
+not play any role in managing their functionality. It is the job of a userspace
+application to detect port enumeration and enable MBIM & AT functionalities.
+
+Examples of few such userspace applications are:
+
+- mbimcli (included with the libmbim [2] library), and
+- Modem Manager [3]
+
+Management Applications to carry out below required actions for establishing
+MBIM IP session:
+
+- open the MBIM control channel
+- configure network connection settings
+- connect to network
+- configure IP network interface
+
+Management Applications to carry out below required actions for send an AT
+command and receive response:
+
+- open the AT control channel using a UART tool or a special user tool
+
+Management application development
+==================================
+The driver and userspace interfaces are described below. The MBIM protocol is
+described in [1] Mobile Broadband Interface Model v1.0 Errata-1.
+
+MBIM control channel userspace ABI
+----------------------------------
+
+/dev/wwan0mbim0 character device
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+The driver exposes an MBIM interface to the MBIM function by implementing
+MBIM WWAN Port. The userspace end of the control channel pipe is a
+/dev/wwan0mbim0 character device. Application shall use this interface for
+MBIM protocol communication.
+
+Fragmentation
+~~~~~~~~~~~~~
+The userspace application is responsible for all control message fragmentation
+and defragmentation as per MBIM specification.
+
+/dev/wwan0mbim0 write()
+~~~~~~~~~~~~~~~~~~~~~~~
+The MBIM control messages from the management application must not exceed the
+negotiated control message size.
+
+/dev/wwan0mbim0 read()
+~~~~~~~~~~~~~~~~~~~~~~
+The management application must accept control messages of up the negotiated
+control message size.
+
+MBIM data channel userspace ABI
+-------------------------------
+
+wwan0-X network device
+~~~~~~~~~~~~~~~~~~~~~~
+The t7xx driver exposes IP link interface "wwan0-X" of type "wwan" for IP
+traffic. Iproute network utility is used for creating "wwan0-X" network
+interface and for associating it with MBIM IP session.
+
+The userspace management application is responsible for creating new IP link
+prior to establishing MBIM IP session where the SessionId is greater than 0.
+
+For example, creating new IP link for a MBIM IP session with SessionId 1:
+
+  ip link add dev wwan0-1 parentdev wwan0 type wwan linkid 1
+
+The driver will automatically map the "wwan0-1" network device to MBIM IP
+session 1.
+
+AT port userspace ABI
+----------------------------------
+
+/dev/wwan0at0 character device
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+The driver exposes an AT port by implementing AT WWAN Port.
+The userspace end of the control port is a /dev/wwan0at0 character
+device. Application shall use this interface to issue AT commands.
+
+The MediaTek's T700 modem supports the 3GPP TS 27.007 [4] specification.
+
+References
+==========
+[1] *MBIM (Mobile Broadband Interface Model) Errata-1*
+
+- https://www.usb.org/document-library/
+
+[2] *libmbim "a glib-based library for talking to WWAN modems and devices which
+speak the Mobile Interface Broadband Model (MBIM) protocol"*
+
+- http://www.freedesktop.org/wiki/Software/libmbim/
+
+[3] *Modem Manager "a DBus-activated daemon which controls mobile broadband
+(2G/3G/4G/5G) devices and connections"*
+
+- http://www.freedesktop.org/wiki/Software/ModemManager/
+
+[4] *Specification # 27.007 - 3GPP*
+
+- https://www.3gpp.org/DynaReport/27007.htm
diff --git a/MAINTAINERS b/MAINTAINERS
index 53c98d5d204c..a5fd392331ea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12208,6 +12208,17 @@ S:	Maintained
 F:	drivers/net/dsa/mt7530.*
 F:	net/dsa/tag_mtk.c
 
+MEDIATEK T7XX 5G WWAN MODEM DRIVER
+M:	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
+M:	Intel Corporation <linuxwwan@intel.com>
+R:	Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>
+R:	Liu Haijun <haijun.liu@mediatek.com>
+R:	M Chetan Kumar <m.chetan.kumar@linux.intel.com>
+R:	Ricardo Martinez <ricardo.martinez@linux.intel.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/wwan/t7xx/
+
 MEDIATEK USB3 DRD IP DRIVER
 M:	Chunfeng Yun <chunfeng.yun@mediatek.com>
 L:	linux-usb@vger.kernel.org
-- 
2.17.1

