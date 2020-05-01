Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356231C1823
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbgEAOpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729292AbgEAOpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:06 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0863224958;
        Fri,  1 May 2020 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344305;
        bh=CDa6UpW7/RGJVktJniWzFL5SPPJXC3PdL3ikarRe5hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzTdahS/PrJiGnxqv7C3Le46BJYDHNRcbR3uR0sicVk/9txPJb8iaFZ9z2KOlyMOD
         Xx9JRf9ePmvur3+sKCtgA9yE/PvUUUoVkOblkDkxuiJE/UBWp1XSt1U08wnhOD/wzN
         JZfWfmfUaHdRAZA400+81Bv6oAZMmFYnMo0/24ao=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCe8-O9; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org
Subject: [PATCH 20/37] docs: networking: device drivers: convert dec/dmfe.txt to ReST
Date:   Fri,  1 May 2020 16:44:42 +0200
Message-Id: <e05cabf197a58952ad1610adfe60c9f400465f5d.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust titles and chapters, adding proper markups;
- comment out text-only TOC from html/pdf output;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../device_drivers/dec/{dmfe.txt => dmfe.rst} | 35 +++++++++++--------
 .../networking/device_drivers/index.rst       |  1 +
 MAINTAINERS                                   |  2 +-
 drivers/net/ethernet/dec/tulip/Kconfig        |  2 +-
 4 files changed, 23 insertions(+), 17 deletions(-)
 rename Documentation/networking/device_drivers/dec/{dmfe.txt => dmfe.rst} (68%)

diff --git a/Documentation/networking/device_drivers/dec/dmfe.txt b/Documentation/networking/device_drivers/dec/dmfe.rst
similarity index 68%
rename from Documentation/networking/device_drivers/dec/dmfe.txt
rename to Documentation/networking/device_drivers/dec/dmfe.rst
index 25320bf19c86..c4cf809cad84 100644
--- a/Documentation/networking/device_drivers/dec/dmfe.txt
+++ b/Documentation/networking/device_drivers/dec/dmfe.rst
@@ -1,6 +1,11 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============================================================
+Davicom DM9102(A)/DM9132/DM9801 fast ethernet driver for Linux
+==============================================================
+
 Note: This driver doesn't have a maintainer.
 
-Davicom DM9102(A)/DM9132/DM9801 fast ethernet driver for Linux.
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General   Public License
@@ -16,29 +21,29 @@ GNU General Public License for more details.
 This driver provides kernel support for Davicom DM9102(A)/DM9132/DM9801 ethernet cards ( CNET
 10/100 ethernet cards uses Davicom chipset too, so this driver supports CNET cards too ).If you
 didn't compile this driver as a module, it will automatically load itself on boot and print a
-line similar to :
+line similar to::
 
 	dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
 
-If you compiled this driver as a module, you have to load it on boot.You can load it with command :
+If you compiled this driver as a module, you have to load it on boot.You can load it with command::
 
 	insmod dmfe
 
 This way it will autodetect the device mode.This is the suggested way to load the module.Or you can pass
-a mode= setting to module while loading, like :
+a mode= setting to module while loading, like::
 
 	insmod dmfe mode=0 # Force 10M Half Duplex
 	insmod dmfe mode=1 # Force 100M Half Duplex
 	insmod dmfe mode=4 # Force 10M Full Duplex
 	insmod dmfe mode=5 # Force 100M Full Duplex
 
-Next you should configure your network interface with a command similar to :
+Next you should configure your network interface with a command similar to::
 
 	ifconfig eth0 172.22.3.18
-                      ^^^^^^^^^^^
+		      ^^^^^^^^^^^
 		     Your IP Address
 
-Then you may have to modify the default routing table with command :
+Then you may have to modify the default routing table with command::
 
 	route add default eth0
 
@@ -48,10 +53,10 @@ Now your ethernet card should be up and running.
 
 TODO:
 
-Implement pci_driver::suspend() and pci_driver::resume() power management methods.
-Check on 64 bit boxes.
-Check and fix on big endian boxes.
-Test and make sure PCI latency is now correct for all cases.
+- Implement pci_driver::suspend() and pci_driver::resume() power management methods.
+- Check on 64 bit boxes.
+- Check and fix on big endian boxes.
+- Test and make sure PCI latency is now correct for all cases.
 
 
 Authors:
@@ -60,7 +65,7 @@ Sten Wang <sten_wang@davicom.com.tw >   : Original Author
 
 Contributors:
 
-Marcelo Tosatti <marcelo@conectiva.com.br>
-Alan Cox <alan@lxorguk.ukuu.org.uk>
-Jeff Garzik <jgarzik@pobox.com>
-Vojtech Pavlik <vojtech@suse.cz>
+- Marcelo Tosatti <marcelo@conectiva.com.br>
+- Alan Cox <alan@lxorguk.ukuu.org.uk>
+- Jeff Garzik <jgarzik@pobox.com>
+- Vojtech Pavlik <vojtech@suse.cz>
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 4ad13ffb5800..09728e964ce1 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -35,6 +35,7 @@ Contents:
    cirrus/cs89x0
    davicom/dm9000
    dec/de4x5
+   dec/dmfe
 
 .. only::  subproject and html
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 91098b704635..b92568479a71 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4710,7 +4710,7 @@ F:	net/ax25/sysctl_net_ax25.c
 DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
 L:	netdev@vger.kernel.org
 S:	Orphan
-F:	Documentation/networking/device_drivers/dec/dmfe.txt
+F:	Documentation/networking/device_drivers/dec/dmfe.rst
 F:	drivers/net/ethernet/dec/tulip/dmfe.c
 
 DC390/AM53C974 SCSI driver
diff --git a/drivers/net/ethernet/dec/tulip/Kconfig b/drivers/net/ethernet/dec/tulip/Kconfig
index 8c4245d94bb2..177f36f4b89d 100644
--- a/drivers/net/ethernet/dec/tulip/Kconfig
+++ b/drivers/net/ethernet/dec/tulip/Kconfig
@@ -138,7 +138,7 @@ config DM9102
 	  This driver is for DM9102(A)/DM9132/DM9801 compatible PCI cards from
 	  Davicom (<http://www.davicom.com.tw/>).  If you have such a network
 	  (Ethernet) card, say Y.  Some information is contained in the file
-	  <file:Documentation/networking/device_drivers/dec/dmfe.txt>.
+	  <file:Documentation/networking/device_drivers/dec/dmfe.rst>.
 
 	  To compile this driver as a module, choose M here. The module will
 	  be called dmfe.
-- 
2.25.4

