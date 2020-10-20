Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74C12938EC
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 12:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405965AbgJTKKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 06:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729132AbgJTKKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 06:10:50 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91204C061755;
        Tue, 20 Oct 2020 03:10:50 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id x7so1809590eje.8;
        Tue, 20 Oct 2020 03:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NGt7Vv5fZZPQyrJNHs+nr+L9qr9xbc+vkaOy1+e2Gvs=;
        b=ZPPlxUIYJ3MpbQxdo6at7LdpUaPGBuMHtzRDReahMiZ+w8C/9cuHXPqUTMz7McrCEV
         Xra6TFIPLd0HaSoldut6sSIGKEGuCgWb4jrbnLxLNWlh1RZaj6dB+tJSc271NqsoLXqt
         Ys11bmVV6zkgctCEEAaAbJ3Hp6OAcgDdsDTHV9Qx1DUGmmw1ctdFJUFGrf0/eAs0447Q
         2AdMOEFLLPrvE2CsTEHazshBIwsVlQJopMhL6k7e6saAf2GkirxhT9i9SAE3k7t9jvey
         PnHF1UtrK2wkSKANKmTkOaTrSZKZ+wfYRV890SncBrxORbHIIEzs9uD64qukv4H4nDdh
         S2xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NGt7Vv5fZZPQyrJNHs+nr+L9qr9xbc+vkaOy1+e2Gvs=;
        b=l3gnP6570NXCZz3MeM9TV9CIFPOACAIOp9/ouGhzrFbisur5CarZZZ9ICbeBZ667+u
         bqzjhvTaqTI/nyuo6w2Cuv9y1JL3mRSgO6yRKvBCcd2ve0UHc19HUVgjG+QNj5HoS+lZ
         FcK5VbrJsQpZ+BCSSxGMYB570dHB0vS6tp7N7jrjvoGEigqky90nVG4ORQuRWPUjYdaH
         6o491wvBRp4gJTqQBaUGgFMng2DUstVmBxo6YT3NlCGZVC4Wti7UNUesIJrq+YcCDhWj
         k1k+3FigI0s5rEI1JnV/3fZkNSkRWuh7BYpsKr+G77RpG2O1cuph4Q9NXqKyZHLeI0SS
         Fx6w==
X-Gm-Message-State: AOAM5310LdP9Rt+PgLg2m3Cm6qtHmXjnysVlEcYxCSdBiexb6RxP/esQ
        0OMJ0vRwp4EqQsTUxSULrvdPUwXTfzs=
X-Google-Smtp-Source: ABdhPJwPlxq9BU7ziBsRedk2t4JwUlnJVI/ZZCbcsh7SJ4Gj179Kgg7ImQjaCfF5fX6ACeq/zq3MOA==
X-Received: by 2002:a17:907:aa9:: with SMTP id bz9mr2332777ejc.472.1603188648948;
        Tue, 20 Oct 2020 03:10:48 -0700 (PDT)
Received: from development1.visionsystems.de (mail.visionsystems.de. [213.209.99.202])
        by smtp.gmail.com with ESMTPSA id t3sm1813622edv.59.2020.10.20.03.10.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Oct 2020 03:10:48 -0700 (PDT)
From:   yegorslists@googlemail.com
To:     linux-can@vger.kernel.org
Cc:     mkl@pengutronix.de, netdev@vger.kernel.org,
        Yegor Yefremov <yegorslists@googlemail.com>
Subject: [PATCH] can: j1939: fix syntax and spelling
Date:   Tue, 20 Oct 2020 12:10:43 +0200
Message-Id: <20201020101043.6369-1-yegorslists@googlemail.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 Documentation/networking/j1939.rst | 34 +++++++++++++++---------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index 65b12abcc90a..8b3f4fbc3bbb 100644
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
+Transport Protocol) which, has been included in this implementation. This
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
@@ -58,10 +58,10 @@ Therefore, these parts are left to user space.
 
 The J1939 sockets operate on CAN network devices (see SocketCAN). Any J1939
 user space library operating on CAN raw sockets will still operate properly.
-Since such library does not communicate with the in-kernel implementation, care
-must be taken that these two do not interfere. In practice, this means they
-cannot share ECU addresses. A single ECU (or virtual ECU) address is used by
-the library exclusively, or by the in-kernel system exclusively.
+Since such a library does not communicate with the in-kernel implementation,
+care must be taken that these two do not interfere. In practice, this means
+they cannot share ECU addresses. A single ECU (or virtual ECU) address is
+used by the library exclusively, or by the in-kernel system exclusively.
 
 J1939 concepts
 ==============
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
2.17.0

