Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104531C01A5
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgD3QEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgD3QEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:36 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEF3420775;
        Thu, 30 Apr 2020 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262675;
        bh=kwLf545ZLLKl4cDNQVW1Q3oZtALV8Rc5ZHCSwPCR5Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9ovvL+5dz7imvEp73G2FjBuKbniXBnBMIKtI4d9elsbHrE1UUt+FzZpOrn37PSO+
         nBWW4Ee5nxtZ9iU0NIL+oRH8wC7P1d0G55vIa3LWdDlXuEynayk6+qNL8oqvTIchaC
         HvaP/bdqo+axBzq/a/8HQ/laEsPCtjA5OuBycePk=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxEJ-1p; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 03/37] docs: networking: convert ltpc.txt to ReST
Date:   Thu, 30 Apr 2020 18:03:58 +0200
Message-Id: <6e495bae2c1b7804fd7ff0d3462c1d15b5c0dc3d.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- add a document title;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../networking/{ltpc.txt => ltpc.rst}         | 45 ++++++++++++-------
 drivers/net/appletalk/Kconfig                 |  2 +-
 3 files changed, 31 insertions(+), 17 deletions(-)
 rename Documentation/networking/{ltpc.txt => ltpc.rst} (86%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index acd2567cf0d4..b3608b177a8b 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -76,6 +76,7 @@ Contents:
    kcm
    l2tp
    lapb-module
+   ltpc
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/ltpc.txt b/Documentation/networking/ltpc.rst
similarity index 86%
rename from Documentation/networking/ltpc.txt
rename to Documentation/networking/ltpc.rst
index a005a73b76d0..0ad197fd17ce 100644
--- a/Documentation/networking/ltpc.txt
+++ b/Documentation/networking/ltpc.rst
@@ -1,3 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========
+LTPC Driver
+===========
+
 This is the ALPHA version of the ltpc driver.
 
 In order to use it, you will need at least version 1.3.3 of the
@@ -15,7 +21,7 @@ yourself.  (see "Card Configuration" below for how to determine or
 change the settings on your card)
 
 When the driver is compiled into the kernel, you can add a line such
-as the following to your /etc/lilo.conf:
+as the following to your /etc/lilo.conf::
 
  append="ltpc=0x240,9,1"
 
@@ -25,13 +31,13 @@ the driver will try to determine them itself.
 
 If you load the driver as a module, you can pass the parameters "io=",
 "irq=", and "dma=" on the command line with insmod or modprobe, or add
-them as options in a configuration file in /etc/modprobe.d/ directory:
+them as options in a configuration file in /etc/modprobe.d/ directory::
 
  alias lt0 ltpc # autoload the module when the interface is configured
  options ltpc io=0x240 irq=9 dma=1
 
 Before starting up the netatalk demons (perhaps in rc.local), you
-need to add a line such as:
+need to add a line such as::
 
  /sbin/ifconfig lt0 127.0.0.42
 
@@ -42,7 +48,7 @@ The appropriate netatalk configuration depends on whether you are
 attached to a network that includes AppleTalk routers or not.  If,
 like me, you are simply connecting to your home Macintoshes and
 printers, you need to set up netatalk to "seed".  The way I do this
-is to have the lines
+is to have the lines::
 
  dummy -seed -phase 2 -net 2000 -addr 2000.26 -zone "1033"
  lt0 -seed -phase 1 -net 1033 -addr 1033.27 -zone "1033"
@@ -57,13 +63,13 @@ such.
 
 If you are attached to an extended AppleTalk network, with routers on
 it, then you don't need to fool around with this -- the appropriate
-line in atalkd.conf is
+line in atalkd.conf is::
 
  lt0 -phase 1
 
---------------------------------------
 
-Card Configuration:
+Card Configuration
+==================
 
 The interrupts and so forth are configured via the dipswitch on the
 board.  Set the switches so as not to conflict with other hardware.
@@ -73,26 +79,32 @@ board.  Set the switches so as not to conflict with other hardware.
        original documentation refers to IRQ2.  Since you'll be running
        this on an AT (or later) class machine, that really means IRQ9.
 
+       ===     ===========================================================
        SW1     IRQ 4
        SW2     IRQ 3
        SW3     IRQ 9 (2 in original card documentation only applies to XT)
+       ===     ===========================================================
 
 
        DMA -- choose DMA 1 or 3, and set both corresponding switches.
 
+       ===     =====
        SW4     DMA 3
        SW5     DMA 1
        SW6     DMA 3
        SW7     DMA 1
+       ===     =====
 
 
        I/O address -- choose one.
 
+       ===     =========
        SW8     220 / 240
+       ===     =========
 
---------------------------------------
 
-IP:
+IP
+==
 
 Yes, it is possible to do IP over LocalTalk.  However, you can't just
 treat the LocalTalk device like an ordinary Ethernet device, even if
@@ -102,9 +114,9 @@ Instead, you follow the same procedure as for doing IP in EtherTalk.
 See Documentation/networking/ipddp.rst for more information about the
 kernel driver and userspace tools needed.
 
---------------------------------------
 
-BUGS:
+Bugs
+====
 
 IRQ autoprobing often doesn't work on a cold boot.  To get around
 this, either compile the driver as a module, or pass the parameters
@@ -120,12 +132,13 @@ It may theoretically be possible to use two LTPC cards in the same
 machine, but this is unsupported, so if you really want to do this,
 you'll probably have to hack the initialization code a bit.
 
-______________________________________
 
-THANKS:
-	Thanks to Alan Cox for helpful discussions early on in this
+Thanks
+======
+
+Thanks to Alan Cox for helpful discussions early on in this
 work, and to Denis Hainsworth for doing the bleeding-edge testing.
 
--- Bradford Johnson <bradford@math.umn.edu>
+Bradford Johnson <bradford@math.umn.edu>
 
--- Updated 11/09/1998 by David Huggins-Daines <dhd@debian.org>
+Updated 11/09/1998 by David Huggins-Daines <dhd@debian.org>
diff --git a/drivers/net/appletalk/Kconfig b/drivers/net/appletalk/Kconfig
index ccde6479050c..10589a82263b 100644
--- a/drivers/net/appletalk/Kconfig
+++ b/drivers/net/appletalk/Kconfig
@@ -48,7 +48,7 @@ config LTPC
 	  If you are in doubt, this card is the one with the 65C02 chip on it.
 	  You also need version 1.3.3 or later of the netatalk package.
 	  This driver is experimental, which means that it may not work.
-	  See the file <file:Documentation/networking/ltpc.txt>.
+	  See the file <file:Documentation/networking/ltpc.rst>.
 
 config COPS
 	tristate "COPS LocalTalk PC support"
-- 
2.25.4

