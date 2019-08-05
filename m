Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A27827A4
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 00:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbfHEWaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 18:30:12 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45824 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728922AbfHEWaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 18:30:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so40337774pfq.12
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 15:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZCTMX6LuNQ2GOh37kxx78RuHorm4xdwVfnJeDhgl2/0=;
        b=Bp6s7ZpGfaLquyKNoL2b+53SrAv7rIMUENVcWftvN1w4ISWX/jsFC1hVxP81GfDXsu
         8UaBFWF6i2sG3/4O0GdsEV+34BM5SFgjtQRrbhTeFLpH7QwLQSuEQTrzPPzJlDOLoJfd
         e1Mydrs+lDvtzepJRGD9S1Mu1mL16j9QgsKDNf5TjbLuGfGUVEzDOgLP6GeOD+v8rneB
         Nf7WH0nVEXhIJx/+HbXjvZ3v3g3ioyaR32dOx0X5ZyI8qcIt880ADDvj5UmEXx5WnU2L
         QviBnAZyNx3TP0a3j3DSf/PAmoYJbAGuFbhl2OKoSbuAwkXBrOcM+byotFXANoW+2Rlv
         0ykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZCTMX6LuNQ2GOh37kxx78RuHorm4xdwVfnJeDhgl2/0=;
        b=gVS2HJ4aTcUmSQbXnBhqF3aiZOihmGfM3qnZpsYwxq/lK1CNc7qhfULLPt9JcH57tY
         Wd3KT9J4wH/PGYO7VXHVVVTZgZdr7eN9YBvQxnz1j8n9a2HvEKKtEA+Kl+nxYDr3qEKA
         ss7mIkChsu1/YJzAA0TcqUa62FNU7Vc50Mrb78FQIyutut8Dp1yxNfzIkAzUfrIUrYEo
         Bglyz5AsaUrrZ35P0lSAj+Pkn19mGunJU32/KqjEc4HfJTtwD8veWJufYgIfJziNlCUL
         jXU4z+XhnR8rHv6JjQIDczpW0PsFqXKMeXNfbnJCTbxGwTyTX8Nb+j6Lq6wHqA1/6ST0
         ayOA==
X-Gm-Message-State: APjAAAV9PSZhW7iZq/wKUJ1ciqhj+BTTE2SqlaJhdSYp4M0zr2DFlD4z
        gl0Oe0gOmEps4y7CRdkYu3fhXtPW6DQ=
X-Google-Smtp-Source: APXvYqxBD/kTrg2qVokubfFuxaoYdAZUxdwjF2egxraa72SGKxhh95BHGmx4KoY3xRBJlunNH+YlSg==
X-Received: by 2002:aa7:92d2:: with SMTP id k18mr273208pfa.153.1565044210957;
        Mon, 05 Aug 2019 15:30:10 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x9sm60024281pgp.75.2019.08.05.15.30.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 15:30:10 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     davem@davemloft.net, corbet@lwn.net
Cc:     linux-dog@vger.kernel.org, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net 1/2] docs: admin-guide: remove references to IPX and token-ring
Date:   Mon,  5 Aug 2019 15:30:02 -0700
Message-Id: <20190805223003.13444-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both IPX and TR have not been supported for a while now.
Remove them from the /proc/sys/net documentation.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 Documentation/admin-guide/sysctl/net.rst | 29 +-----------------------
 1 file changed, 1 insertion(+), 28 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index a7d44e71019d..287b98708a40 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -39,7 +39,6 @@ Table : Subdirectories in /proc/sys/net
  802       E802 protocol         ax25       AX25
  ethernet  Ethernet protocol     rose       X.25 PLP layer
  ipv4      IP version 4          x25        X.25 protocol
- ipx       IPX                   token-ring IBM token ring
  bridge    Bridging              decnet     DEC net
  ipv6      IP version 6          tipc       TIPC
  ========= =================== = ========== ==================
@@ -401,33 +400,7 @@ interface.
 (network) that the route leads to, the router (may be directly connected), the
 route flags, and the device the route is using.
 
-
-5. IPX
-------
-
-The IPX protocol has no tunable values in proc/sys/net.
-
-The IPX  protocol  does,  however,  provide  proc/net/ipx. This lists each IPX
-socket giving  the  local  and  remote  addresses  in  Novell  format (that is
-network:node:port). In  accordance  with  the  strange  Novell  tradition,
-everything but the port is in hex. Not_Connected is displayed for sockets that
-are not  tied to a specific remote address. The Tx and Rx queue sizes indicate
-the number  of  bytes  pending  for  transmission  and  reception.  The  state
-indicates the  state  the  socket  is  in and the uid is the owning uid of the
-socket.
-
-The /proc/net/ipx_interface  file lists all IPX interfaces. For each interface
-it gives  the network number, the node number, and indicates if the network is
-the primary  network.  It  also  indicates  which  device  it  is bound to (or
-Internal for  internal  networks)  and  the  Frame  Type if appropriate. Linux
-supports 802.3,  802.2,  802.2  SNAP  and DIX (Blue Book) ethernet framing for
-IPX.
-
-The /proc/net/ipx_route  table  holds  a list of IPX routes. For each route it
-gives the  destination  network, the router node (or Directly) and the network
-address of the router (or Connected) for internal networks.
-
-6. TIPC
+5. TIPC
 -------
 
 tipc_rmem
-- 
2.20.1

