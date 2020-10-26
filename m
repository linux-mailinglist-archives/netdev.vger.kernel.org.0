Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF52F2989B1
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 10:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1768332AbgJZJqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 05:46:14 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36121 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1767800AbgJZJow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 05:44:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id l16so8579903eds.3;
        Mon, 26 Oct 2020 02:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oPQJhi7KI4NjkEPUj7M6xUF1lYKdVaCZveTIZ5sP3vc=;
        b=D/oWu3pyaSLyOHUrwZoFRrjn0Di4TWz5lGPDYrrnVX85N15q0Utrm3E9j7INgVVTHj
         e7QB2CDdXJtPu9TjRX4pqz9CxPq7MPX0rzAjVSlpM4e615UGyXCHhzu30ygFw8Z43Lth
         +qa4JRxLcQ0qaIvFhYh7FdZD3d/N/UMAk3btfj5KY6McbYnfb+4sBc1HGHMMegR2dx0B
         Bi13Rq9lTEdKnUfA/xTr0vhKSIAzGZnDUJlTNVEusOaCMOiZk1bESxkxDYLhvJsgLL7z
         pmJFDDegN1fBMJ2wETs2MK6I8PSsJU1mzoEOokU7G9/7YrRV0ialFhZj7WfIVyKwtpN1
         CSpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oPQJhi7KI4NjkEPUj7M6xUF1lYKdVaCZveTIZ5sP3vc=;
        b=EolAnnLK36adl5Ue+/DQCShS2vPiZDHD0uRMg9IKXlC77CXcy2QrZcZPlh2TcffvON
         dHUDcgQWi+bI84LSpc25IZpSfRRFnfDVu+Nelxr78ARJBLzaEQgP2u5RrIG5n7n+CfyV
         nuMVHkX3aLYDLZqGioD5OMvgVrBMHreNUVtYtL+90Qgz0pOJ/gsqBprcrBLdYC+fBoxo
         RgJEFKQymhphoTHxnos64B5ESHo7a1UXsV5onCK6oBqeZjYN7gGZz6ihf972aWLSY3St
         xPNKIo07cM4ens1GrVScZtTbS93J0B67f94YoMc86MOGxmv9OMTsHbmfzSZnJ0kvkmRW
         tMSQ==
X-Gm-Message-State: AOAM530KxS8GbAoWD3j1jlgsqhV2pT28ZtX77aoQ9X7cnOq+TC045JVO
        ZmQGQaY+qaL3zHXsLAwy8V3e71mH9gw=
X-Google-Smtp-Source: ABdhPJyzMQtfWDDzsQ/d2spRQuo2/j70PVV5sYKxFOkYWjUVKRjH3yBnc3unZnroJ8I3o3xyTFuirg==
X-Received: by 2002:a05:6402:13cc:: with SMTP id a12mr10194889edx.73.1603705488487;
        Mon, 26 Oct 2020 02:44:48 -0700 (PDT)
Received: from development1.visionsystems.de (mail.visionsystems.de. [213.209.99.202])
        by smtp.gmail.com with ESMTPSA id d11sm4855218eds.83.2020.10.26.02.44.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Oct 2020 02:44:47 -0700 (PDT)
From:   yegorslists@googlemail.com
To:     linux-can@vger.kernel.org
Cc:     mkl@pengutronix.de, netdev@vger.kernel.org,
        dev.kurt@vandijck-laurijssen.be,
        Yegor Yefremov <yegorslists@googlemail.com>
Subject: [PATCH] can: j1939: use backquotes for code samples
Date:   Mon, 26 Oct 2020 10:44:42 +0100
Message-Id: <20201026094442.16587-1-yegorslists@googlemail.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 Documentation/networking/j1939.rst | 128 +++++++++++++++--------------
 1 file changed, 65 insertions(+), 63 deletions(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index bd1584ec90f9..59596ef509c9 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -135,32 +135,32 @@ API Calls
 ---------
 
 On CAN, you first need to open a socket for communicating over a CAN network.
-To use J1939, #include <linux/can/j1939.h>. From there, <linux/can.h> will be
-included too. To open a socket, use:
+To use J1939, ``#include <linux/can/j1939.h>``. From there, ``<linux/can.h>``
+will be included too. To open a socket, use:
 
 .. code-block:: C
 
     s = socket(PF_CAN, SOCK_DGRAM, CAN_J1939);
 
-J1939 does use SOCK_DGRAM sockets. In the J1939 specification, connections are
-mentioned in the context of transport protocol sessions. These still deliver
-packets to the other end (using several CAN packets). SOCK_STREAM is not
+J1939 does use ``SOCK_DGRAM`` sockets. In the J1939 specification, connections
+are mentioned in the context of transport protocol sessions. These still deliver
+packets to the other end (using several CAN packets). ``SOCK_STREAM`` is not
 supported.
 
-After the successful creation of the socket, you would normally use the bind(2)
-and/or connect(2) system call to bind the socket to a CAN interface.  After
-binding and/or connecting the socket, you can read(2) and write(2) from/to the
-socket or use send(2), sendto(2), sendmsg(2) and the recv*() counterpart
-operations on the socket as usual. There are also J1939 specific socket options
-described below.
+After the successful creation of the socket, you would normally use the
+``bind(2)`` and/or ``connect(2)`` system call to bind the socket to a CAN
+interface.  After binding and/or connecting the socket, you can ``read(2)`` and
+``write(2)`` from/to the socket or use ``send(2)``, ``sendto(2)``,
+``sendmsg(2)`` and the ``recv*()`` counterpart operations on the socket as
+usual. There are also J1939 specific socket options described below.
 
-In order to send data, a bind(2) must have been successful. bind(2) assigns a
-local address to a socket.
+In order to send data, a ``bind(2)`` must have been successful. ``bind(2)``
+assigns a local address to a socket.
 
 Different from CAN is that the payload data is just the data that get sends,
 without its header info. The header info is derived from the sockaddr supplied
-to bind(2), connect(2), sendto(2) and recvfrom(2). A write(2) with size 4 will
-result in a packet with 4 bytes.
+to ``bind(2)``, ``connect(2)``, ``sendto(2)`` and ``recvfrom(2)``. A
+``write(2)`` with size 4 will result in a packet with 4 bytes.
 
 The sockaddr structure has extensions for use with J1939 as specified below:
 
@@ -184,47 +184,49 @@ The sockaddr structure has extensions for use with J1939 as specified below:
          } can_addr;
       }
 
-can_family & can_ifindex serve the same purpose as for other SocketCAN sockets.
+``can_family`` & ``can_ifindex`` serve the same purpose as for other SocketCAN
+sockets.
 
-can_addr.j1939.pgn specifies the PGN (max 0x3ffff). Individual bits are
+``can_addr.j1939.pgn`` specifies the PGN (max 0x3ffff). Individual bits are
 specified above.
 
-can_addr.j1939.name contains the 64-bit J1939 NAME.
+``can_addr.j1939.name`` contains the 64-bit J1939 NAME.
 
-can_addr.j1939.addr contains the address.
+``can_addr.j1939.addr`` contains the address.
 
-The bind(2) system call assigns the local address, i.e. the source address when
-sending packages. If a PGN during bind(2) is set, it's used as a RX filter.
-I.e. only packets with a matching PGN are received. If an ADDR or NAME is set
-it is used as a receive filter, too. It will match the destination NAME or ADDR
-of the incoming packet. The NAME filter will work only if appropriate Address
-Claiming for this name was done on the CAN bus and registered/cached by the
-kernel.
+The ``bind(2)`` system call assigns the local address, i.e. the source address
+when sending packages. If a PGN during ``bind(2)`` is set, it's used as a
+RX filter.  I.e. only packets with a matching PGN are received. If an ADDR or
+NAME is set it is used as a receive filter, too. It will match the destination
+NAME or ADDR of the incoming packet. The NAME filter will work only if
+appropriate Address Claiming for this name was done on the CAN bus and
+registered/cached by the kernel.
 
-On the other hand connect(2) assigns the remote address, i.e. the destination
-address. The PGN from connect(2) is used as the default PGN when sending
-packets. If ADDR or NAME is set it will be used as the default destination ADDR
-or NAME. Further a set ADDR or NAME during connect(2) is used as a receive
-filter. It will match the source NAME or ADDR of the incoming packet.
+On the other hand ``connect(2)`` assigns the remote address, i.e. the
+destination address. The PGN from ``connect(2)`` is used as the default PGN when
+sending packets. If ADDR or NAME is set it will be used as the default
+destination ADDR or NAME. Further a set ADDR or NAME during ``connect(2)`` is
+used as a receive filter. It will match the source NAME or ADDR of the incoming
+packet.
 
-Both write(2) and send(2) will send a packet with local address from bind(2) and
-the remote address from connect(2). Use sendto(2) to overwrite the destination
-address.
+Both ``write(2)`` and ``send(2)`` will send a packet with local address from
+``bind(2)`` and the remote address from ``connect(2)``. Use ``sendto(2)`` to
+overwrite the destination address.
 
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
 
@@ -265,26 +267,26 @@ The following diagram illustrates the RX path:
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
 
@@ -309,13 +311,13 @@ Dynamic Addressing
 
 Distinction has to be made between using the claimed address and doing an
 address claim. To use an already claimed address, one has to fill in the
-j1939.name member and provide it to bind(2). If the name had claimed an address
-earlier, all further messages being sent will use that address. And the
-j1939.addr member will be ignored.
+``j1939.name`` member and provide it to ``bind(2)``. If the name had claimed an
+address earlier, all further messages being sent will use that address. And the
+``j1939.addr`` member will be ignored.
 
 An exception on this is PGN 0x0ee00. This is the "Address Claim/Cannot Claim
-Address" message and the kernel will use the j1939.addr member for that PGN if
-necessary.
+Address" message and the kernel will use the ``j1939.addr`` member for that PGN
+if necessary.
 
 To claim an address following code example can be used:
 
@@ -375,13 +377,13 @@ NAME can send packets.
 
 If another ECU claims the address, the kernel will mark the NAME-SA expired.
 No socket bound to the NAME can send packets (other than address claims). To
-claim another address, some socket bound to NAME, must bind(2) again, but with
-only j1939.addr changed to the new SA, and must then send a valid address claim
-packet. This restarts the state machine in the kernel (and any other
-participant on the bus) for this NAME.
+claim another address, some socket bound to NAME, must ``bind(2)`` again, but
+with only ``j1939.addr`` changed to the new SA, and must then send a valid
+address claim packet. This restarts the state machine in the kernel (and any
+other participant on the bus) for this NAME.
 
-can-utils also include the j1939acd tool, so it can be used as code example or as
-default Address Claiming daemon.
+``can-utils`` also include the ``j1939acd`` tool, so it can be used as code
+example or as default Address Claiming daemon.
 
 Send Examples
 -------------
@@ -407,8 +409,8 @@ Bind:
 
 	bind(sock, (struct sockaddr *)&baddr, sizeof(baddr));
 
-Now, the socket 'sock' is bound to the SA 0x20. Since no connect(2) was called,
-at this point we can use only sendto(2) or sendmsg(2).
+Now, the socket 'sock' is bound to the SA 0x20. Since no ``connect(2)`` was called,
+at this point we can use only ``sendto(2)`` or ``sendmsg(2)``.
 
 Send:
 
-- 
2.17.0

