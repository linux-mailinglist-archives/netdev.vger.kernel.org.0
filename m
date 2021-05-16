Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C561381F17
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 15:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbhEPNXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 09:23:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39098 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhEPNXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 09:23:46 -0400
Received: from mail-ed1-f71.google.com ([209.85.208.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <juerg.haefliger@canonical.com>)
        id 1liGj0-0001HU-Lt
        for netdev@vger.kernel.org; Sun, 16 May 2021 13:22:30 +0000
Received: by mail-ed1-f71.google.com with SMTP id q18-20020a50cc920000b029038cf491864cso2309149edi.14
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 06:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TUZHq1LlIrTbAZVDobXbN76FSlqGTNui2ct6NU02wJo=;
        b=LMOLwKSoIhMCQQ5JtVJt3bCT6ZG4BQRZxkt/jhxPkF1SG8+ESQis6SCDLV7nyzNRg9
         IGvG9EZVujqkhchNTxZycMSpiU9gnMlOcvZLN7kX4yhT4pY8D/xfuSb5eFRChITQNpLj
         wuGLzbxJ+wGxZVAqDEUzBoqeIoDdVfI9v05i0BO0cw+p6+KNS4sYR9OikwOSQ/qO4XQc
         iYk8jXQEEPD1rnBayOSDZ+3bLB68/5x5KjxVPK0513OUhn1A/P2+kJ4EFVcFXRk9W+Eh
         iJxJjA5SN4cD96guUhf+hi5CuIOpZk3K+7k51M0qul1PQarjo/zjFRQ2qGIO1Ta8st2c
         OT2w==
X-Gm-Message-State: AOAM531OTtp4MgDkLYvKmttxIhTuwcuNIXgHcc3grMagF6G4abtk9Smo
        G8OsllsSCFEJZT9W8YhR69Jc2Y+etrhMVW+18NA2XZ6OrSmsyERhMhNM0EWdHEShdfK5gNsjZNN
        M0w4Y2bdoAC89JXnsa368FKAbxIdi1vI4gQ==
X-Received: by 2002:a17:906:b2c1:: with SMTP id cf1mr47188834ejb.544.1621171350269;
        Sun, 16 May 2021 06:22:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwemSH08vKN86fYRji/0gf7FGjjmYQFhv1Tge7BtiRE3+6x/Y5AKDM4p5D+miAtvUmM3VDZVQ==
X-Received: by 2002:a17:906:b2c1:: with SMTP id cf1mr47188589ejb.544.1621171345102;
        Sun, 16 May 2021 06:22:25 -0700 (PDT)
Received: from gollum.fritz.box ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id n15sm7126596eje.118.2021.05.16.06.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 06:22:24 -0700 (PDT)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
To:     aaro.koskinen@iki.fi, tony@atomide.com, linux@prisktech.co.nz,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        lee.jones@linaro.org, daniel.thompson@linaro.org,
        jingoohan1@gmail.com, mst@redhat.com, jasowang@redhat.com,
        zbr@ioremap.net, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, horms@verge.net.au, ja@ssi.bg,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, lvs-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Juerg Haefliger <juergh@canonical.com>
Subject: [PATCH] treewide: Remove leading spaces in Kconfig files
Date:   Sun, 16 May 2021 15:22:09 +0200
Message-Id: <20210516132209.59229-1-juergh@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few occurences of leading spaces before tabs in a couple of
Kconfig files. Remove them by running the following command:

  $ find . -name 'Kconfig*' | xargs sed -r -i 's/^[ ]+\t/\t/'

Signed-off-by: Juerg Haefliger <juergh@canonical.com>
---
 arch/arm/mach-omap1/Kconfig     | 12 ++++++------
 arch/arm/mach-vt8500/Kconfig    |  6 +++---
 arch/arm/mm/Kconfig             | 10 +++++-----
 drivers/char/hw_random/Kconfig  |  8 ++++----
 drivers/net/usb/Kconfig         | 10 +++++-----
 drivers/net/wan/Kconfig         |  4 ++--
 drivers/scsi/Kconfig            |  2 +-
 drivers/uio/Kconfig             |  2 +-
 drivers/video/backlight/Kconfig | 10 +++++-----
 drivers/virtio/Kconfig          |  2 +-
 drivers/w1/masters/Kconfig      |  6 +++---
 fs/proc/Kconfig                 |  4 ++--
 init/Kconfig                    |  2 +-
 net/netfilter/Kconfig           |  2 +-
 net/netfilter/ipvs/Kconfig      |  2 +-
 15 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
index 9536b8f3c07d..208c700c2455 100644
--- a/arch/arm/mach-omap1/Kconfig
+++ b/arch/arm/mach-omap1/Kconfig
@@ -65,14 +65,14 @@ config MACH_OMAP_INNOVATOR
 config MACH_OMAP_H2
 	bool "TI H2 Support"
 	depends on ARCH_OMAP16XX
-    	help
+	help
 	  TI OMAP 1610/1611B H2 board support. Say Y here if you have such
 	  a board.
 
 config MACH_OMAP_H3
 	bool "TI H3 Support"
 	depends on ARCH_OMAP16XX
-    	help
+	help
 	  TI OMAP 1710 H3 board support. Say Y here if you have such
 	  a board.
 
@@ -85,14 +85,14 @@ config MACH_HERALD
 config MACH_OMAP_OSK
 	bool "TI OSK Support"
 	depends on ARCH_OMAP16XX
-    	help
+	help
 	  TI OMAP 5912 OSK (OMAP Starter Kit) board support. Say Y here
           if you have such a board.
 
 config OMAP_OSK_MISTRAL
 	bool "Mistral QVGA board Support"
 	depends on MACH_OMAP_OSK
-    	help
+	help
 	  The OSK supports an optional add-on board with a Quarter-VGA
 	  touchscreen, PDA-ish buttons, a resume button, bicolor LED,
 	  and camera connector.  Say Y here if you have this board.
@@ -100,14 +100,14 @@ config OMAP_OSK_MISTRAL
 config MACH_OMAP_PERSEUS2
 	bool "TI Perseus2"
 	depends on ARCH_OMAP730
-    	help
+	help
 	  Support for TI OMAP 730 Perseus2 board. Say Y here if you have such
 	  a board.
 
 config MACH_OMAP_FSAMPLE
 	bool "TI F-Sample"
 	depends on ARCH_OMAP730
-    	help
+	help
 	  Support for TI OMAP 850 F-Sample board. Say Y here if you have such
 	  a board.
 
diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
index d01cdd9ad9c7..408e405ae568 100644
--- a/arch/arm/mach-vt8500/Kconfig
+++ b/arch/arm/mach-vt8500/Kconfig
@@ -9,9 +9,9 @@ config ARCH_VT8500
 
 config ARCH_WM8505
 	bool "VIA/Wondermedia 85xx and WM8650"
- 	depends on ARCH_MULTI_V5
- 	select ARCH_VT8500
- 	select CPU_ARM926T
+	depends on ARCH_MULTI_V5
+	select ARCH_VT8500
+	select CPU_ARM926T
 
 config ARCH_WM8750
 	bool "WonderMedia WM8750"
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 35f43d0aa056..7a4a04bafa92 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -123,13 +123,13 @@ config CPU_ARM925T
 	select CPU_PABRT_LEGACY
 	select CPU_THUMB_CAPABLE
 	select CPU_TLB_V4WBI if MMU
- 	help
- 	  The ARM925T is a mix between the ARM920T and ARM926T, but with
+	help
+	  The ARM925T is a mix between the ARM920T and ARM926T, but with
 	  different instruction and data caches. It is used in TI's OMAP
- 	  device family.
+	  device family.
 
- 	  Say Y if you want support for the ARM925T processor.
- 	  Otherwise, say N.
+	  Say Y if you want support for the ARM925T processor.
+	  Otherwise, say N.
 
 # ARM926T
 config CPU_ARM926T
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 1fe006f3f12f..0e1e97680f08 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -168,14 +168,14 @@ config HW_RANDOM_OMAP
 	depends on ARCH_OMAP16XX || ARCH_OMAP2PLUS || ARCH_MVEBU
 	default HW_RANDOM
 	help
- 	  This driver provides kernel-side support for the Random Number
+	  This driver provides kernel-side support for the Random Number
 	  Generator hardware found on OMAP16xx, OMAP2/3/4/5, AM33xx/AM43xx
 	  multimedia processors, and Marvell Armada 7k/8k SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called omap-rng.
 
- 	  If unsure, say Y.
+	  If unsure, say Y.
 
 config HW_RANDOM_OMAP3_ROM
 	tristate "OMAP3 ROM Random Number Generator support"
@@ -485,13 +485,13 @@ config HW_RANDOM_NPCM
 	depends on ARCH_NPCM || COMPILE_TEST
 	default HW_RANDOM
 	help
- 	  This driver provides support for the Random Number
+	  This driver provides support for the Random Number
 	  Generator hardware available in Nuvoton NPCM SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called npcm-rng.
 
- 	  If unsure, say Y.
+	  If unsure, say Y.
 
 config HW_RANDOM_KEYSTONE
 	depends on ARCH_KEYSTONE || COMPILE_TEST
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index fbbe78643631..179308782888 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -169,7 +169,7 @@ config USB_NET_AX8817X
 	  This option adds support for ASIX AX88xxx based USB 2.0
 	  10/100 Ethernet adapters.
 
- 	  This driver should work with at least the following devices:
+	  This driver should work with at least the following devices:
 	    * Aten UC210T
 	    * ASIX AX88172
 	    * Billionton Systems, USB2AR
@@ -220,13 +220,13 @@ config USB_NET_CDCETHER
 	  CDC Ethernet is an implementation option for DOCSIS cable modems
 	  that support USB connectivity, used for non-Microsoft USB hosts.
 	  The Linux-USB CDC Ethernet Gadget driver is an open implementation.
- 	  This driver should work with at least the following devices:
+	  This driver should work with at least the following devices:
 
 	    * Dell Wireless 5530 HSPA
- 	    * Ericsson PipeRider (all variants)
+	    * Ericsson PipeRider (all variants)
 	    * Ericsson Mobile Broadband Module (all variants)
- 	    * Motorola (DM100 and SB4100)
- 	    * Broadcom Cable Modem (reference design)
+	    * Motorola (DM100 and SB4100)
+	    * Broadcom Cable Modem (reference design)
 	    * Toshiba (PCX1100U and F3507g/F3607gw)
 	    * ...
 
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 83c9481995dd..473df2505c8e 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -49,7 +49,7 @@ config COSA
 	  network device.
 
 	  You will need user-space utilities COSA or SRP boards for downloading
- 	  the firmware to the cards and to set them up. Look at the
+	  the firmware to the cards and to set them up. Look at the
 	  <http://www.fi.muni.cz/~kas/cosa/> for more information. You can also
 	  read the comment at the top of the <file:drivers/net/wan/cosa.c> for
 	  details about the cards and the driver itself.
@@ -108,7 +108,7 @@ config HDLC
 	  Generic HDLC driver currently supports raw HDLC, Cisco HDLC, Frame
 	  Relay, synchronous Point-to-Point Protocol (PPP) and X.25.
 
- 	  To compile this driver as a module, choose M here: the
+	  To compile this driver as a module, choose M here: the
 	  module will be called hdlc.
 
 	  If unsure, say N.
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3d114be5b662..c5612896cdb9 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -311,7 +311,7 @@ source "drivers/scsi/cxlflash/Kconfig"
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
 	depends on SGI_HAS_WD93 && SCSI
-  	help
+	help
 	  If you have a Western Digital WD93 SCSI controller on
 	  an SGI MIPS system, say Y.  Otherwise, say N.
 
diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index 5531f3afeb21..2e16c5338e5b 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -18,7 +18,7 @@ config UIO_CIF
 	depends on PCI
 	help
 	  Driver for Hilscher CIF DeviceNet and Profibus cards.  This
-  	  driver requires a userspace component called cif that handles
+	  driver requires a userspace component called cif that handles
 	  all of the heavy lifting and can be found at:
 	        <http://www.osadl.org/projects/downloads/UIO/user/>
 
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index d83c87b902c1..a967974f6cd6 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -129,11 +129,11 @@ config LCD_HX8357
 	  driver.
 
   config LCD_OTM3225A
-  	tristate "ORISE Technology OTM3225A support"
-  	depends on SPI
-  	help
-  	  If you have a panel based on the OTM3225A controller
-  	  chip then say y to include a driver for it.
+	tristate "ORISE Technology OTM3225A support"
+	depends on SPI
+	help
+	  If you have a panel based on the OTM3225A controller
+	  chip then say y to include a driver for it.
 
 endif # LCD_CLASS_DEVICE
 
diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index ce1b3f6ec325..3b3644d60d11 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -128,7 +128,7 @@ config VIRTIO_MMIO
 	 This drivers provides support for memory mapped virtio
 	 platform device driver.
 
- 	 If unsure, say N.
+	 If unsure, say N.
 
 config VIRTIO_MMIO_CMDLINE_DEVICES
 	bool "Memory mapped virtio devices parameter parsing"
diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 24b9a8e05f64..32e993ea6f96 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -17,12 +17,12 @@ config W1_MASTER_MATROX
 
 config W1_MASTER_DS2490
 	tristate "DS2490 USB <-> W1 transport layer for 1-wire"
-  	depends on USB
-  	help
+	depends on USB
+	help
 	  Say Y here if you want to have a driver for DS2490 based USB <-> W1 bridges,
 	  for example DS9490*.
 
-  	  This support is also available as a module.  If so, the module
+	  This support is also available as a module.  If so, the module
 	  will be called ds2490.
 
 config W1_MASTER_DS2482
diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index c930001056f9..e8410a99a0ca 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -81,10 +81,10 @@ config PROC_SYSCTL
 	  limited in memory.
 
 config PROC_PAGE_MONITOR
- 	default y
+	default y
 	depends on PROC_FS && MMU
 	bool "Enable /proc page monitoring" if EXPERT
- 	help
+	help
 	  Various /proc files exist to monitor process memory utilization:
 	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
diff --git a/init/Kconfig b/init/Kconfig
index 1ea12c64e4c9..9f1cde503739 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2149,7 +2149,7 @@ config MODULE_SRCVERSION_ALL
 	help
 	  Modules which contain a MODULE_VERSION get an extra "srcversion"
 	  field inserted into their modinfo section, which contains a
-    	  sum of the source files which made it.  This helps maintainers
+	  sum of the source files which made it.  This helps maintainers
 	  see exactly which source was used to build a module (since
 	  others sometimes change the module source without updating
 	  the version).  With this option, such a "srcversion" field
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 56a2531a3402..172d74560632 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -816,7 +816,7 @@ config NETFILTER_XT_TARGET_CLASSIFY
 	  the priority of a packet. Some qdiscs can use this value for
 	  classification, among these are:
 
-  	  atm, cbq, dsmark, pfifo_fast, htb, prio
+	  atm, cbq, dsmark, pfifo_fast, htb, prio
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index d61886874940..271da8447b29 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -318,7 +318,7 @@ config IP_VS_MH_TAB_INDEX
 comment 'IPVS application helper'
 
 config	IP_VS_FTP
-  	tristate "FTP protocol helper"
+	tristate "FTP protocol helper"
 	depends on IP_VS_PROTO_TCP && NF_CONNTRACK && NF_NAT && \
 		NF_CONNTRACK_FTP
 	select IP_VS_NFCT
-- 
2.27.0

