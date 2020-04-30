Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279651C018F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgD3QGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbgD3QEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:38 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 289DE24964;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=aYPeW3IqG9lVg2I9kmZNk4mbS6HsxCxvZcoR6oz+QKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwE5aS2k2cfrMPA6I5wlEh4Ce/YUcKtv8lsyqqm+ZvKnlGpMSZl0WNtV1gd6nLBSt
         Z/IPRbGmtgADNIXX6sQDymcVp/w0OEQRxcqxHhqEM0+CCMiBMokeAgMQgZwKik9ElI
         ocGvbRQ6U794fdm9Xgt0pXXaqhzc8sjxtw4qyXys=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxFT-EE; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH 17/37] docs: networking: convert phonet.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:12 +0200
Message-Id: <423e28fd2a70f7128a99bc52231fdc6e2a244f65.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- use copyright symbol;
- add notes markups;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 Documentation/networking/packet_mmap.rst      |  2 +-
 .../networking/{phonet.txt => phonet.rst}     | 56 ++++++++++++-------
 MAINTAINERS                                   |  2 +-
 4 files changed, 39 insertions(+), 22 deletions(-)
 rename Documentation/networking/{phonet.txt => phonet.rst} (82%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 8262b535a83e..e460026331c6 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -90,6 +90,7 @@ Contents:
    openvswitch
    operstates
    packet_mmap
+   phonet
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/packet_mmap.rst b/Documentation/networking/packet_mmap.rst
index 5f213d17652f..884c7222b9e9 100644
--- a/Documentation/networking/packet_mmap.rst
+++ b/Documentation/networking/packet_mmap.rst
@@ -1076,7 +1076,7 @@ Miscellaneous bits
 ==================
 
 - Packet sockets work well together with Linux socket filters, thus you also
-  might want to have a look at Documentation/networking/filter.txt
+  might want to have a look at Documentation/networking/filter.rst
 
 THANKS
 ======
diff --git a/Documentation/networking/phonet.txt b/Documentation/networking/phonet.rst
similarity index 82%
rename from Documentation/networking/phonet.txt
rename to Documentation/networking/phonet.rst
index 81003581f47a..8668dcbc5e6a 100644
--- a/Documentation/networking/phonet.txt
+++ b/Documentation/networking/phonet.rst
@@ -1,3 +1,7 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. include:: <isonum.txt>
+
+============================
 Linux Phonet protocol family
 ============================
 
@@ -11,6 +15,7 @@ device attached to the modem. The modem takes care of routing.
 
 Phonet packets can be exchanged through various hardware connections
 depending on the device, such as:
+
   - USB with the CDC Phonet interface,
   - infrared,
   - Bluetooth,
@@ -21,7 +26,7 @@ depending on the device, such as:
 Packets format
 --------------
 
-Phonet packets have a common header as follows:
+Phonet packets have a common header as follows::
 
   struct phonethdr {
     uint8_t  pn_media;  /* Media type (link-layer identifier) */
@@ -72,7 +77,7 @@ only the (default) Linux FIFO qdisc should be used with them.
 Network layer
 -------------
 
-The Phonet socket address family maps the Phonet packet header:
+The Phonet socket address family maps the Phonet packet header::
 
   struct sockaddr_pn {
     sa_family_t spn_family;    /* AF_PHONET */
@@ -94,6 +99,8 @@ protocol from the PF_PHONET family. Each socket is bound to one of the
 2^10 object IDs available, and can send and receive packets with any
 other peer.
 
+::
+
   struct sockaddr_pn addr = { .spn_family = AF_PHONET, };
   ssize_t len;
   socklen_t addrlen = sizeof(addr);
@@ -105,7 +112,7 @@ other peer.
 
   sendto(fd, msg, msglen, 0, (struct sockaddr *)&addr, sizeof(addr));
   len = recvfrom(fd, buf, sizeof(buf), 0,
-                 (struct sockaddr *)&addr, &addrlen);
+		 (struct sockaddr *)&addr, &addrlen);
 
 This protocol follows the SOCK_DGRAM connection-less semantics.
 However, connect() and getpeername() are not supported, as they did
@@ -116,7 +123,7 @@ Resource subscription
 ---------------------
 
 A Phonet datagram socket can be subscribed to any number of 8-bits
-Phonet resources, as follow:
+Phonet resources, as follow::
 
   uint32_t res = 0xXX;
   ioctl(fd, SIOCPNADDRESOURCE, &res);
@@ -137,6 +144,8 @@ socket paradigm. The listening socket is bound to an unique free object
 ID. Each listening socket can handle up to 255 simultaneous
 connections, one per accept()'d socket.
 
+::
+
   int lfd, cfd;
 
   lfd = socket(PF_PHONET, SOCK_SEQPACKET, PN_PROTO_PIPE);
@@ -161,7 +170,7 @@ Connections are traditionally established between two endpoints by a
 As of Linux kernel version 2.6.39, it is also possible to connect
 two endpoints directly, using connect() on the active side. This is
 intended to support the newer Nokia Wireless Modem API, as found in
-e.g. the Nokia Slim Modem in the ST-Ericsson U8500 platform:
+e.g. the Nokia Slim Modem in the ST-Ericsson U8500 platform::
 
   struct sockaddr_spn spn;
   int fd;
@@ -177,38 +186,45 @@ e.g. the Nokia Slim Modem in the ST-Ericsson U8500 platform:
   close(fd);
 
 
-WARNING:
-When polling a connected pipe socket for writability, there is an
-intrinsic race condition whereby writability might be lost between the
-polling and the writing system calls. In this case, the socket will
-block until write becomes possible again, unless non-blocking mode
-is enabled.
+.. Warning:
+
+   When polling a connected pipe socket for writability, there is an
+   intrinsic race condition whereby writability might be lost between the
+   polling and the writing system calls. In this case, the socket will
+   block until write becomes possible again, unless non-blocking mode
+   is enabled.
 
 
 The pipe protocol provides two socket options at the SOL_PNPIPE level:
 
   PNPIPE_ENCAP accepts one integer value (int) of:
 
-    PNPIPE_ENCAP_NONE: The socket operates normally (default).
+    PNPIPE_ENCAP_NONE:
+      The socket operates normally (default).
 
-    PNPIPE_ENCAP_IP: The socket is used as a backend for a virtual IP
+    PNPIPE_ENCAP_IP:
+      The socket is used as a backend for a virtual IP
       interface. This requires CAP_NET_ADMIN capability. GPRS data
       support on Nokia modems can use this. Note that the socket cannot
       be reliably poll()'d or read() from while in this mode.
 
-  PNPIPE_IFINDEX is a read-only integer value. It contains the
-    interface index of the network interface created by PNPIPE_ENCAP,
-    or zero if encapsulation is off.
+  PNPIPE_IFINDEX
+      is a read-only integer value. It contains the
+      interface index of the network interface created by PNPIPE_ENCAP,
+      or zero if encapsulation is off.
 
-  PNPIPE_HANDLE is a read-only integer value. It contains the underlying
-    identifier ("pipe handle") of the pipe. This is only defined for
-    socket descriptors that are already connected or being connected.
+  PNPIPE_HANDLE
+      is a read-only integer value. It contains the underlying
+      identifier ("pipe handle") of the pipe. This is only defined for
+      socket descriptors that are already connected or being connected.
 
 
 Authors
 -------
 
 Linux Phonet was initially written by Sakari Ailus.
+
 Other contributors include Mikä Liljeberg, Andras Domokos,
 Carlos Chinea and Rémi Denis-Courmont.
-Copyright (C) 2008 Nokia Corporation.
+
+Copyright |copy| 2008 Nokia Corporation.
diff --git a/MAINTAINERS b/MAINTAINERS
index 1546ecb855b5..0d2005e8380e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13297,7 +13297,7 @@ F:	drivers/input/joystick/pxrc.c
 PHONET PROTOCOL
 M:	Remi Denis-Courmont <courmisch@gmail.com>
 S:	Supported
-F:	Documentation/networking/phonet.txt
+F:	Documentation/networking/phonet.rst
 F:	include/linux/phonet.h
 F:	include/net/phonet/
 F:	include/uapi/linux/phonet.h
-- 
2.25.4

