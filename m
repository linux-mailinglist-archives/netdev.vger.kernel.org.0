Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1780C6302BE
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbiKRXPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235372AbiKRXNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:46 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF27ACC166
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:59 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d20so5792547plr.10
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=y0IYmb41g1s9QaOF+G4sj2azfDLjrRwJoDz3fJ0vLtQ=;
        b=xbL57mKTTJdSGbXq6t4unVLGnBn3hV87oqWvjjkMlle+xElEb5mx0bmDbYMjqYPeCA
         +2BjFt1KQBA9YbxRHJACORc72Y7oSMpDuhbvWXjoLyvRcL2xM6L1CErEux+86J2typ8W
         5EJhkNGOExMooN1UE/mLQtTpA7JxtpR67IzN0DDRbX1g9oR2Fxr0HE8mAoN6kHfOql6P
         P6ajsmQtjXDy44+o0OJVl/I4+Esj3R9dq7DKaU9Lx6ZhWj65ohOpmcshvoRVpvviiTYg
         qciu8BmzM4G/1FjC46rPaMQ/9p6ftUzHCe9FjModVxLR00pGfPTLfMfzJHDUG98tL2xs
         aRSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y0IYmb41g1s9QaOF+G4sj2azfDLjrRwJoDz3fJ0vLtQ=;
        b=Vp6dLscFyESlCJV0NE4jcX/Q/aUf8QK/yGEGdVDzASACbK2dsQnDtfPCYYr0TVPZSI
         O8CsIfbDrYLKM+HU4RNTuDWl09rUjAURCMFUmz5AOufJZGjqftmQtO17zFZlQ/tot3v8
         e1xURNLX0d/5ACAkC1YGCpbUstfLlxb3zj15nqfXRJZ3L/mGGE1owEE/ErzgQ2YsFnNz
         LyiZuT5aOvtAMGoDXzbxQBjjijgNu2yRacRWzjTyPRUxVIKvdv+2EsdjC4WGmAYWbKmv
         sMIUuKlinvhSlkEy2hRn3MVtHjQyP+MBwKeRh30QqAFacq6/Zq4DK6y29DY6QdgKgGdy
         Hrwg==
X-Gm-Message-State: ANoB5pmXgURk3R0+S0gU72EJUWNvxlZRpjq0VAwAk3ezGEBKJyQXpscZ
        JKk4cadxiwq60ZANMagCj8vlM03xJEVoIQ==
X-Google-Smtp-Source: AA0mqf7xhXwjZwsohgKCVerjn+lyiUq7JunzKxZgtG1beusuM+Ttbo+dUE9XkLxIo8f2VYU4RLDWsA==
X-Received: by 2002:a17:902:f792:b0:186:b32c:4cdc with SMTP id q18-20020a170902f79200b00186b32c4cdcmr1456579pln.166.1668812258049;
        Fri, 18 Nov 2022 14:57:38 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:37 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 19/19] pds_vdpa: add Kconfig entry and pds_vdpa.rst
Date:   Fri, 18 Nov 2022 14:56:56 -0800
Message-Id: <20221118225656.48309-20-snelson@pensando.io>
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

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/pds_vdpa.rst            | 85 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 drivers/vdpa/Kconfig                          |  7 ++
 3 files changed, 93 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst

diff --git a/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst b/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
new file mode 100644
index 000000000000..c517f337d212
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/pensando/pds_vdpa.rst
@@ -0,0 +1,85 @@
+.. SPDX-License-Identifier: GPL-2.0+
+.. note: can be edited and viewed with /usr/bin/formiko-vim
+
+==========================================================
+PCI vDPA driver for the Pensando(R) DSC adapter family
+==========================================================
+
+Pensando vDPA VF Device Driver
+Copyright(c) 2022 Pensando Systems, Inc
+
+Overview
+========
+
+The ``pds_vdpa`` driver is a PCI and auxiliary bus driver and supplies
+a vDPA device for use by the virtio network stack.  It is used with
+the Pensando Virtual Function devices that offer vDPA and virtio queue
+services.  It depends on the ``pds_core`` driver and hardware for the PF
+and for device configuration services.
+
+Using the device
+================
+
+The ``pds_vdpa`` device is enabled via multiple configuration steps and
+depends on the ``pds_core`` driver to create and enable SR-IOV Virtual
+Function devices.
+
+Shown below are the steps to bind the driver to a VF and also to the
+associated auxiliary device created by the ``pds_core`` driver. This
+example assumes the pds_core and pds_vdpa modules are already
+loaded.
+
+.. code-block:: bash
+
+  #!/bin/bash
+
+  modprobe pds_core
+  modprobe pds_vdpa
+
+  PF_BDF=`grep "vDPA.*1" /sys/kernel/debug/pds_core/*/viftypes | head -1 | awk -F / '{print $6}'`
+
+  # Enable vDPA VF auxiliary device(s) in the PF
+  devlink dev param set pci/$PF_BDF name enable_vnet value true cmode runtime
+
+  # Create a VF for vDPA use
+  echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
+
+  # Find the vDPA services/devices available
+  PDS_VDPA_MGMT=`vdpa mgmtdev show | grep vDPA | head -1 | cut -d: -f1`
+
+  # Create a vDPA device for use in virtio network configurations
+  vdpa dev add name vdpa1 mgmtdev $PDS_VDPA_MGMT mac 00:11:22:33:44:55
+
+  # Set up an ethernet interface on the vdpa device
+  modprobe virtio_vdpa
+
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
+          -> Pensando Ethernet PDS_VDPA Support
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
index a4f989fa8192..a4d96e854757 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16152,6 +16152,7 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/device_drivers/ethernet/pensando/
 F:	drivers/net/ethernet/pensando/
+F:	drivers/vdpa/pds/
 F:	include/linux/pds/
 
 PER-CPU MEMORY ALLOCATOR
diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
index 50f45d037611..1c44df18f3da 100644
--- a/drivers/vdpa/Kconfig
+++ b/drivers/vdpa/Kconfig
@@ -86,4 +86,11 @@ config ALIBABA_ENI_VDPA
 	  VDPA driver for Alibaba ENI (Elastic Network Interface) which is built upon
 	  virtio 0.9.5 specification.
 
+config PDS_VDPA
+	tristate "vDPA driver for Pensando DSC devices"
+	select VHOST_RING
+	depends on PDS_CORE
+	help
+	  VDPA network driver for Pensando's PDS Core devices.
+
 endif # VDPA
-- 
2.17.1

