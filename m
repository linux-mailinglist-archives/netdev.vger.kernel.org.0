Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F932A5955
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731276AbgKCWGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731136AbgKCWGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:45 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7406DC061A48
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:45 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4Rv-0006Ui-H4; Tue, 03 Nov 2020 23:06:43 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Yegor Yefremov <yegorslists@googlemail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 09/27] can: j1939: fix syntax and spelling
Date:   Tue,  3 Nov 2020 23:06:18 +0100
Message-Id: <20201103220636.972106-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103220636.972106-1-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

This patches fixes the syntax an spelling of the j1939 documentation.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Link: https://lore.kernel.org/r/20201020101043.6369-1-yegorslists@googlemail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/networking/j1939.rst | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index 081dfc2e0452..be59fcece3bf 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -10,9 +10,9 @@ Overview / What Is J1939
 SAE J1939 defines a higher layer protocol on CAN. It implements a more
 sophisticated addressing scheme and extends the maximum packet size above 8
 bytes. Several derived specifications exist, which differ from the original
-J1939 on the application level, like MilCAN A, NMEA2000 and especially
+J1939 on the application level, like MilCAN A, NMEA2000, and especially
 ISO-11783 (ISOBUS). This last one specifies the so-called ETP (Extended
-Transport Protocol) which is has been included in this implementation. This
+Transport Protocol), which has been included in this implementation. This
 results in a maximum packet size of ((2 ^ 24) - 1) * 7 bytes == 111 MiB.
 
 Specifications used
@@ -32,15 +32,15 @@ sockets, we found some reasons to justify a kernel implementation for the
 addressing and transport methods used by J1939.
 
 * **Addressing:** when a process on an ECU communicates via J1939, it should
-  not necessarily know its source address. Although at least one process per
+  not necessarily know its source address. Although, at least one process per
   ECU should know the source address. Other processes should be able to reuse
   that address. This way, address parameters for different processes
   cooperating for the same ECU, are not duplicated. This way of working is
-  closely related to the UNIX concept where programs do just one thing, and do
+  closely related to the UNIX concept, where programs do just one thing and do
   it well.
 
 * **Dynamic addressing:** Address Claiming in J1939 is time critical.
-  Furthermore data transport should be handled properly during the address
+  Furthermore, data transport should be handled properly during the address
   negotiation. Putting this functionality in the kernel eliminates it as a
   requirement for _every_ user space process that communicates via J1939. This
   results in a consistent J1939 bus with proper addressing.
@@ -58,7 +58,7 @@ Therefore, these parts are left to user space.
 
 The J1939 sockets operate on CAN network devices (see SocketCAN). Any J1939
 user space library operating on CAN raw sockets will still operate properly.
-Since such library does not communicate with the in-kernel implementation, care
+Since such a library does not communicate with the in-kernel implementation, care
 must be taken that these two do not interfere. In practice, this means they
 cannot share ECU addresses. A single ECU (or virtual ECU) address is used by
 the library exclusively, or by the in-kernel system exclusively.
@@ -77,13 +77,13 @@ is composed as follows:
 8 bits : PS (PDU Specific)
 
 In J1939-21 distinction is made between PDU1 format (where PF < 240) and PDU2
-format (where PF >= 240). Furthermore, when using PDU2 format, the PS-field
+format (where PF >= 240). Furthermore, when using the PDU2 format, the PS-field
 contains a so-called Group Extension, which is part of the PGN. When using PDU2
 format, the Group Extension is set in the PS-field.
 
 On the other hand, when using PDU1 format, the PS-field contains a so-called
 Destination Address, which is _not_ part of the PGN. When communicating a PGN
-from user space to kernel (or visa versa) and PDU2 format is used, the PS-field
+from user space to kernel (or vice versa) and PDU2 format is used, the PS-field
 of the PGN shall be set to zero. The Destination Address shall be set
 elsewhere.
 
@@ -96,15 +96,15 @@ Addressing
 
 Both static and dynamic addressing methods can be used.
 
-For static addresses, no extra checks are made by the kernel, and provided
+For static addresses, no extra checks are made by the kernel and provided
 addresses are considered right. This responsibility is for the OEM or system
 integrator.
 
 For dynamic addressing, so-called Address Claiming, extra support is foreseen
-in the kernel. In J1939 any ECU is known by it's 64-bit NAME. At the moment of
+in the kernel. In J1939 any ECU is known by its 64-bit NAME. At the moment of
 a successful address claim, the kernel keeps track of both NAME and source
 address being claimed. This serves as a base for filter schemes. By default,
-packets with a destination that is not locally, will be rejected.
+packets with a destination that is not locally will be rejected.
 
 Mixed mode packets (from a static to a dynamic address or vice versa) are
 allowed. The BSD sockets define separate API calls for getting/setting the
@@ -153,8 +153,8 @@ described below.
 In order to send data, a bind(2) must have been successful. bind(2) assigns a
 local address to a socket.
 
-Different from CAN is that the payload data is just the data that get send,
-without it's header info. The header info is derived from the sockaddr supplied
+Different from CAN is that the payload data is just the data that get sends,
+without its header info. The header info is derived from the sockaddr supplied
 to bind(2), connect(2), sendto(2) and recvfrom(2). A write(2) with size 4 will
 result in a packet with 4 bytes.
 
@@ -191,7 +191,7 @@ can_addr.j1939.addr contains the address.
 
 The bind(2) system call assigns the local address, i.e. the source address when
 sending packages. If a PGN during bind(2) is set, it's used as a RX filter.
-I.e.  only packets with a matching PGN are received. If an ADDR or NAME is set
+I.e. only packets with a matching PGN are received. If an ADDR or NAME is set
 it is used as a receive filter, too. It will match the destination NAME or ADDR
 of the incoming packet. The NAME filter will work only if appropriate Address
 Claiming for this name was done on the CAN bus and registered/cached by the
-- 
2.28.0

