Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4721BB0F1
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgD0WCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgD0WB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:01:59 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B04218AC;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=UmynUtq3qtulIWnLtvNf0Bt9TiSxo4JcisGU3PNZoCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0e5Im0zuGJsRdkRiJ9zFE1FLea/BC3HxMinCHMvplgoaWEizd+3lg32G4Cw+XqPr
         o6D1GVu/M8iquHbkxd7UH5mz/Wh3H0BJsV5XcRDufiFdJGagu5BqWXZWgcMgWEJB/2
         8DCsLquQ5DquTn9v8anUVGuVe2B14tJYCpVHGBYY=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000IoH-MP; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 08/38] docs: networking: convert baycom.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:23 +0200
Message-Id: <737a50862c00ce0c840c9e846bab48a17cecdcc6.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust titles and chapters, adding proper markups;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{baycom.txt => baycom.rst}     | 110 ++++++++++--------
 Documentation/networking/index.rst            |   1 +
 drivers/net/hamradio/Kconfig                  |   8 +-
 3 files changed, 68 insertions(+), 51 deletions(-)
 rename Documentation/networking/{baycom.txt => baycom.rst} (58%)

diff --git a/Documentation/networking/baycom.txt b/Documentation/networking/baycom.rst
similarity index 58%
rename from Documentation/networking/baycom.txt
rename to Documentation/networking/baycom.rst
index 688f18fd4467..fe2d010f0e86 100644
--- a/Documentation/networking/baycom.txt
+++ b/Documentation/networking/baycom.rst
@@ -1,26 +1,31 @@
-		    LINUX DRIVERS FOR BAYCOM MODEMS
+.. SPDX-License-Identifier: GPL-2.0
 
-       Thomas M. Sailer, HB9JNX/AE4WA, <sailer@ife.ee.ethz.ch>
+===============================
+Linux Drivers for Baycom Modems
+===============================
 
-!!NEW!! (04/98) The drivers for the baycom modems have been split into
+Thomas M. Sailer, HB9JNX/AE4WA, <sailer@ife.ee.ethz.ch>
+
+The drivers for the baycom modems have been split into
 separate drivers as they did not share any code, and the driver
 and device names have changed.
 
 This document describes the Linux Kernel Drivers for simple Baycom style
-amateur radio modems. 
+amateur radio modems.
 
 The following drivers are available:
+====================================
 
 baycom_ser_fdx:
   This driver supports the SER12 modems either full or half duplex.
-  Its baud rate may be changed via the `baud' module parameter,
+  Its baud rate may be changed via the ``baud`` module parameter,
   therefore it supports just about every bit bang modem on a
   serial port. Its devices are called bcsf0 through bcsf3.
   This is the recommended driver for SER12 type modems,
   however if you have a broken UART clone that does not have working
-  delta status bits, you may try baycom_ser_hdx. 
+  delta status bits, you may try baycom_ser_hdx.
 
-baycom_ser_hdx: 
+baycom_ser_hdx:
   This is an alternative driver for SER12 type modems.
   It only supports half duplex, and only 1200 baud. Its devices
   are called bcsh0 through bcsh3. Use this driver only if baycom_ser_fdx
@@ -37,45 +42,48 @@ baycom_epp:
 
 The following modems are supported:
 
-ser12:  This is a very simple 1200 baud AFSK modem. The modem consists only
-        of a modulator/demodulator chip, usually a TI TCM3105. The computer
-        is responsible for regenerating the receiver bit clock, as well as
-        for handling the HDLC protocol. The modem connects to a serial port,
-        hence the name. Since the serial port is not used as an async serial
-        port, the kernel driver for serial ports cannot be used, and this
-        driver only supports standard serial hardware (8250, 16450, 16550)
+======= ========================================================================
+ser12   This is a very simple 1200 baud AFSK modem. The modem consists only
+	of a modulator/demodulator chip, usually a TI TCM3105. The computer
+	is responsible for regenerating the receiver bit clock, as well as
+	for handling the HDLC protocol. The modem connects to a serial port,
+	hence the name. Since the serial port is not used as an async serial
+	port, the kernel driver for serial ports cannot be used, and this
+	driver only supports standard serial hardware (8250, 16450, 16550)
 
-par96:  This is a modem for 9600 baud FSK compatible to the G3RUH standard.
-        The modem does all the filtering and regenerates the receiver clock.
-        Data is transferred from and to the PC via a shift register.
-        The shift register is filled with 16 bits and an interrupt is signalled.
-        The PC then empties the shift register in a burst. This modem connects
-        to the parallel port, hence the name. The modem leaves the 
-        implementation of the HDLC protocol and the scrambler polynomial to
-        the PC.
+par96   This is a modem for 9600 baud FSK compatible to the G3RUH standard.
+	The modem does all the filtering and regenerates the receiver clock.
+	Data is transferred from and to the PC via a shift register.
+	The shift register is filled with 16 bits and an interrupt is signalled.
+	The PC then empties the shift register in a burst. This modem connects
+	to the parallel port, hence the name. The modem leaves the
+	implementation of the HDLC protocol and the scrambler polynomial to
+	the PC.
 
-picpar: This is a redesign of the par96 modem by Henning Rech, DF9IC. The modem
-        is protocol compatible to par96, but uses only three low power ICs
-        and can therefore be fed from the parallel port and does not require
-        an additional power supply. Furthermore, it incorporates a carrier
-        detect circuitry.
+picpar  This is a redesign of the par96 modem by Henning Rech, DF9IC. The modem
+	is protocol compatible to par96, but uses only three low power ICs
+	and can therefore be fed from the parallel port and does not require
+	an additional power supply. Furthermore, it incorporates a carrier
+	detect circuitry.
 
-EPP:    This is a high-speed modem adaptor that connects to an enhanced parallel port.
-        Its target audience is users working over a high speed hub (76.8kbit/s).
-
-eppfpga: This is a redesign of the EPP adaptor.
+EPP     This is a high-speed modem adaptor that connects to an enhanced parallel
+	port.
 
+	Its target audience is users working over a high speed hub (76.8kbit/s).
 
+eppfpga This is a redesign of the EPP adaptor.
+======= ========================================================================
 
 All of the above modems only support half duplex communications. However,
 the driver supports the KISS (see below) fullduplex command. It then simply
 starts to send as soon as there's a packet to transmit and does not care
 about DCD, i.e. it starts to send even if there's someone else on the channel.
-This command is required by some implementations of the DAMA channel 
+This command is required by some implementations of the DAMA channel
 access protocol.
 
 
 The Interface of the drivers
+============================
 
 Unlike previous drivers, these drivers are no longer character devices,
 but they are now true kernel network interfaces. Installation is therefore
@@ -88,20 +96,22 @@ me for WAMPES which allows attaching a kernel network interface directly.
 
 
 Configuring the driver
+======================
 
 Every time a driver is inserted into the kernel, it has to know which
 modems it should access at which ports. This can be done with the setbaycom
 utility. If you are only using one modem, you can also configure the
 driver from the insmod command line (or by means of an option line in
-/etc/modprobe.d/*.conf).
+``/etc/modprobe.d/*.conf``).
+
+Examples::
 
-Examples:
   modprobe baycom_ser_fdx mode="ser12*" iobase=0x3f8 irq=4
   sethdlc -i bcsf0 -p mode "ser12*" io 0x3f8 irq 4
 
 Both lines configure the first port to drive a ser12 modem at the first
-serial port (COM1 under DOS). The * in the mode parameter instructs the driver to use
-the software DCD algorithm (see below).
+serial port (COM1 under DOS). The * in the mode parameter instructs the driver
+to use the software DCD algorithm (see below)::
 
   insmod baycom_par mode="picpar" iobase=0x378
   sethdlc -i bcp0 -p mode "picpar" io 0x378
@@ -115,29 +125,33 @@ Note that both utilities interpret the values slightly differently.
 
 
 Hardware DCD versus Software DCD
+================================
 
 To avoid collisions on the air, the driver must know when the channel is
 busy. This is the task of the DCD circuitry/software. The driver may either
 utilise a software DCD algorithm (options=1) or use a DCD signal from
 the hardware (options=0).
 
-ser12:  if software DCD is utilised, the radio's squelch should always be
-        open. It is highly recommended to use the software DCD algorithm,
-        as it is much faster than most hardware squelch circuitry. The
-        disadvantage is a slightly higher load on the system.
+======= =================================================================
+ser12   if software DCD is utilised, the radio's squelch should always be
+	open. It is highly recommended to use the software DCD algorithm,
+	as it is much faster than most hardware squelch circuitry. The
+	disadvantage is a slightly higher load on the system.
 
-par96:  the software DCD algorithm for this type of modem is rather poor.
-        The modem simply does not provide enough information to implement
-        a reasonable DCD algorithm in software. Therefore, if your radio
-        feeds the DCD input of the PAR96 modem, the use of the hardware
-        DCD circuitry is recommended.
+par96   the software DCD algorithm for this type of modem is rather poor.
+	The modem simply does not provide enough information to implement
+	a reasonable DCD algorithm in software. Therefore, if your radio
+	feeds the DCD input of the PAR96 modem, the use of the hardware
+	DCD circuitry is recommended.
 
-picpar: the picpar modem features a builtin DCD hardware, which is highly
-        recommended.
+picpar  the picpar modem features a builtin DCD hardware, which is highly
+	recommended.
+======= =================================================================
 
 
 
 Compatibility with the rest of the Linux kernel
+===============================================
 
 The serial driver and the baycom serial drivers compete
 for the same hardware resources. Of course only one driver can access a given
@@ -154,5 +168,7 @@ The parallel port drivers (baycom_par, baycom_epp) now use the parport subsystem
 to arbitrate the ports between different client drivers.
 
 vy 73s de
+
 Tom Sailer, sailer@ife.ee.ethz.ch
+
 hb9jnx @ hb9w.ampr.org
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 6a5858b27cf6..fbf845fbaff7 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -43,6 +43,7 @@ Contents:
    arcnet
    atm
    ax25
+   baycom
 
 .. only::  subproject and html
 
diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index bf306fed04cc..fe409819b56d 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -127,7 +127,7 @@ config BAYCOM_SER_FDX
 	  your serial interface chip. To configure the driver, use the sethdlc
 	  utility available in the standard ax25 utilities package. For
 	  information on the modems, see <http://www.baycom.de/> and
-	  <file:Documentation/networking/baycom.txt>.
+	  <file:Documentation/networking/baycom.rst>.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called baycom_ser_fdx.  This is recommended.
@@ -145,7 +145,7 @@ config BAYCOM_SER_HDX
 	  the driver, use the sethdlc utility available in the standard ax25
 	  utilities package. For information on the modems, see
 	  <http://www.baycom.de/> and
-	  <file:Documentation/networking/baycom.txt>.
+	  <file:Documentation/networking/baycom.rst>.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called baycom_ser_hdx.  This is recommended.
@@ -160,7 +160,7 @@ config BAYCOM_PAR
 	  par96 designs. To configure the driver, use the sethdlc utility
 	  available in the standard ax25 utilities package. For information on
 	  the modems, see <http://www.baycom.de/> and the file
-	  <file:Documentation/networking/baycom.txt>.
+	  <file:Documentation/networking/baycom.rst>.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called baycom_par.  This is recommended.
@@ -175,7 +175,7 @@ config BAYCOM_EPP
 	  designs. To configure the driver, use the sethdlc utility available
 	  in the standard ax25 utilities package. For information on the
 	  modems, see <http://www.baycom.de/> and the file
-	  <file:Documentation/networking/baycom.txt>.
+	  <file:Documentation/networking/baycom.rst>.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called baycom_epp.  This is recommended.
-- 
2.25.4

