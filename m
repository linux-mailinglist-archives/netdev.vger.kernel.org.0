Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16892A597F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbgKCWHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731143AbgKCWGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DABEC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:46 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4Rw-0006Ui-Aw; Tue, 03 Nov 2020 23:06:44 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Yegor Yefremov <yegorslists@googlemail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 11/27] can: j1939: use backquotes for code samples
Date:   Tue,  3 Nov 2020 23:06:20 +0100
Message-Id: <20201103220636.972106-12-mkl@pengutronix.de>
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

This patch adds backquotes for code samples.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Link: https://lore.kernel.org/r/20201026094442.16587-1-yegorslists@googlemail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/networking/j1939.rst | 88 +++++++++++++++---------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index faf2eb5c5052..0a4b73b03b99 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -131,31 +131,31 @@ API Calls
 ---------
 
 On CAN, you first need to open a socket for communicating over a CAN network.
-To use J1939, #include <linux/can/j1939.h>. From there, <linux/can.h> will be
+To use J1939, ``#include <linux/can/j1939.h>``. From there, ``<linux/can.h>`` will be
 included too. To open a socket, use:
 
 .. code-block:: C
 
     s = socket(PF_CAN, SOCK_DGRAM, CAN_J1939);
 
-J1939 does use SOCK_DGRAM sockets. In the J1939 specification, connections are
+J1939 does use ``SOCK_DGRAM`` sockets. In the J1939 specification, connections are
 mentioned in the context of transport protocol sessions. These still deliver
-packets to the other end (using several CAN packets). SOCK_STREAM is not
+packets to the other end (using several CAN packets). ``SOCK_STREAM`` is not
 supported.
 
-After the successful creation of the socket, you would normally use the bind(2)
-and/or connect(2) system call to bind the socket to a CAN interface.  After
-binding and/or connecting the socket, you can read(2) and write(2) from/to the
-socket or use send(2), sendto(2), sendmsg(2) and the recv*() counterpart
+After the successful creation of the socket, you would normally use the ``bind(2)``
+and/or ``connect(2)`` system call to bind the socket to a CAN interface. After
+binding and/or connecting the socket, you can ``read(2)`` and ``write(2)`` from/to the
+socket or use ``send(2)``, ``sendto(2)``, ``sendmsg(2)`` and the ``recv*()`` counterpart
 operations on the socket as usual. There are also J1939 specific socket options
 described below.
 
-In order to send data, a bind(2) must have been successful. bind(2) assigns a
+In order to send data, a ``bind(2)`` must have been successful. ``bind(2)`` assigns a
 local address to a socket.
 
 Different from CAN is that the payload data is just the data that get sends,
 without its header info. The header info is derived from the sockaddr supplied
-to bind(2), connect(2), sendto(2) and recvfrom(2). A write(2) with size 4 will
+to ``bind(2)``, ``connect(2)``, ``sendto(2)`` and ``recvfrom(2)``. A ``write(2)`` with size 4 will
 result in a packet with 4 bytes.
 
 The sockaddr structure has extensions for use with J1939 as specified below:
@@ -180,47 +180,47 @@ The sockaddr structure has extensions for use with J1939 as specified below:
          } can_addr;
       }
 
-can_family & can_ifindex serve the same purpose as for other SocketCAN sockets.
+``can_family`` & ``can_ifindex`` serve the same purpose as for other SocketCAN sockets.
 
-can_addr.j1939.pgn specifies the PGN (max 0x3ffff). Individual bits are
+``can_addr.j1939.pgn`` specifies the PGN (max 0x3ffff). Individual bits are
 specified above.
 
-can_addr.j1939.name contains the 64-bit J1939 NAME.
+``can_addr.j1939.name`` contains the 64-bit J1939 NAME.
 
-can_addr.j1939.addr contains the address.
+``can_addr.j1939.addr`` contains the address.
 
-The bind(2) system call assigns the local address, i.e. the source address when
-sending packages. If a PGN during bind(2) is set, it's used as a RX filter.
+The ``bind(2)`` system call assigns the local address, i.e. the source address when
+sending packages. If a PGN during ``bind(2)`` is set, it's used as a RX filter.
 I.e. only packets with a matching PGN are received. If an ADDR or NAME is set
 it is used as a receive filter, too. It will match the destination NAME or ADDR
 of the incoming packet. The NAME filter will work only if appropriate Address
 Claiming for this name was done on the CAN bus and registered/cached by the
 kernel.
 
-On the other hand connect(2) assigns the remote address, i.e. the destination
-address. The PGN from connect(2) is used as the default PGN when sending
+On the other hand ``connect(2)`` assigns the remote address, i.e. the destination
+address. The PGN from ``connect(2)`` is used as the default PGN when sending
 packets. If ADDR or NAME is set it will be used as the default destination ADDR
-or NAME. Further a set ADDR or NAME during connect(2) is used as a receive
+or NAME. Further a set ADDR or NAME during ``connect(2)`` is used as a receive
 filter. It will match the source NAME or ADDR of the incoming packet.
 
-Both write(2) and send(2) will send a packet with local address from bind(2) and
-the remote address from connect(2). Use sendto(2) to overwrite the destination
+Both ``write(2)`` and ``send(2)`` will send a packet with local address from ``bind(2)`` and the
+remote address from ``connect(2)``. Use ``sendto(2)`` to overwrite the destination
 address.
 
-If can_addr.j1939.name is set (!= 0) the NAME is looked up by the kernel and
-the corresponding ADDR is used. If can_addr.j1939.name is not set (== 0),
-can_addr.j1939.addr is used.
+If ``can_addr.j1939.name`` is set (!= 0) the NAME is looked up by the kernel and
+the corresponding ADDR is used. If ``can_addr.j1939.name`` is not set (== 0),
+``can_addr.j1939.addr`` is used.
 
 When creating a socket, reasonable defaults are set. Some options can be
-modified with setsockopt(2) & getsockopt(2).
+modified with ``setsockopt(2)`` & ``getsockopt(2)``.
 
 RX path related options:
 
-- SO_J1939_FILTER - configure array of filters
-- SO_J1939_PROMISC - disable filters set by bind(2) and connect(2)
+- ``SO_J1939_FILTER`` - configure array of filters
+- ``SO_J1939_PROMISC`` - disable filters set by ``bind(2)`` and ``connect(2)``
 
 By default no broadcast packets can be send or received. To enable sending or
-receiving broadcast packets use the socket option SO_BROADCAST:
+receiving broadcast packets use the socket option ``SO_BROADCAST``:
 
 .. code-block:: C
 
@@ -261,26 +261,26 @@ The following diagram illustrates the RX path:
      +---------------------------+
 
 TX path related options:
-SO_J1939_SEND_PRIO - change default send priority for the socket
+``SO_J1939_SEND_PRIO`` - change default send priority for the socket
 
 Message Flags during send() and Related System Calls
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-send(2), sendto(2) and sendmsg(2) take a 'flags' argument. Currently
+``send(2)``, ``sendto(2)`` and ``sendmsg(2)`` take a 'flags' argument. Currently
 supported flags are:
 
-* MSG_DONTWAIT, i.e. non-blocking operation.
+* ``MSG_DONTWAIT``, i.e. non-blocking operation.
 
 recvmsg(2)
 ^^^^^^^^^^
 
-In most cases recvmsg(2) is needed if you want to extract more information than
-recvfrom(2) can provide. For example package priority and timestamp. The
+In most cases ``recvmsg(2)`` is needed if you want to extract more information than
+``recvfrom(2)`` can provide. For example package priority and timestamp. The
 Destination Address, name and packet priority (if applicable) are attached to
-the msghdr in the recvmsg(2) call. They can be extracted using cmsg(3) macros,
-with cmsg_level == SOL_J1939 && cmsg_type == SCM_J1939_DEST_ADDR,
-SCM_J1939_DEST_NAME or SCM_J1939_PRIO. The returned data is a uint8_t for
-priority and dst_addr, and uint64_t for dst_name.
+the msghdr in the ``recvmsg(2)`` call. They can be extracted using ``cmsg(3)`` macros,
+with ``cmsg_level == SOL_J1939 && cmsg_type == SCM_J1939_DEST_ADDR``,
+``SCM_J1939_DEST_NAME`` or ``SCM_J1939_PRIO``. The returned data is a ``uint8_t`` for
+``priority`` and ``dst_addr``, and ``uint64_t`` for ``dst_name``.
 
 .. code-block:: C
 
@@ -305,12 +305,12 @@ Dynamic Addressing
 
 Distinction has to be made between using the claimed address and doing an
 address claim. To use an already claimed address, one has to fill in the
-j1939.name member and provide it to bind(2). If the name had claimed an address
+``j1939.name`` member and provide it to ``bind(2)``. If the name had claimed an address
 earlier, all further messages being sent will use that address. And the
-j1939.addr member will be ignored.
+``j1939.addr`` member will be ignored.
 
 An exception on this is PGN 0x0ee00. This is the "Address Claim/Cannot Claim
-Address" message and the kernel will use the j1939.addr member for that PGN if
+Address" message and the kernel will use the ``j1939.addr`` member for that PGN if
 necessary.
 
 To claim an address following code example can be used:
@@ -371,12 +371,12 @@ NAME can send packets.
 
 If another ECU claims the address, the kernel will mark the NAME-SA expired.
 No socket bound to the NAME can send packets (other than address claims). To
-claim another address, some socket bound to NAME, must bind(2) again, but with
-only j1939.addr changed to the new SA, and must then send a valid address claim
+claim another address, some socket bound to NAME, must ``bind(2)`` again, but with
+only ``j1939.addr`` changed to the new SA, and must then send a valid address claim
 packet. This restarts the state machine in the kernel (and any other
 participant on the bus) for this NAME.
 
-can-utils also include the j1939acd tool, so it can be used as code example or as
+``can-utils`` also include the ``j1939acd`` tool, so it can be used as code example or as
 default Address Claiming daemon.
 
 Send Examples
@@ -403,8 +403,8 @@ Bind:
 
 	bind(sock, (struct sockaddr *)&baddr, sizeof(baddr));
 
-Now, the socket 'sock' is bound to the SA 0x20. Since no connect(2) was called,
-at this point we can use only sendto(2) or sendmsg(2).
+Now, the socket 'sock' is bound to the SA 0x20. Since no ``connect(2)`` was called,
+at this point we can use only ``sendto(2)`` or ``sendmsg(2)``.
 
 Send:
 
-- 
2.28.0

