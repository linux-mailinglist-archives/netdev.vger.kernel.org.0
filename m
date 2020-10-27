Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1D929AB73
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750660AbgJ0MGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:06:44 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38276 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750655AbgJ0MGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 08:06:42 -0400
Received: by mail-lf1-f65.google.com with SMTP id c141so1993168lfg.5;
        Tue, 27 Oct 2020 05:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eohJaWMwHM3aQ7gsRG83gYLtltQvygf7sinDrI0ygig=;
        b=jJruPJIcgydNql7JnixycKQ+5bDsxtg8ayvLQ/D4BQgiTgW8cqyUPP6AUkJpBSI/XT
         iWsbFkxxU4mc5FvEMcL4Ur9QGDQERCf9J1pcie5q4ouSWgvaBH94ljuE7BFRR8oTa5CV
         NFj54t2BK8gK6lN3I59crXIZer9g3OLxCZ+Z4pgI5jFWGRa4nfFbPW4vY3cWZyC+0QT2
         BvkOJ6WzbLgj2Vr+rDMkXCjKrALqltn3hqYUol6iIDcQ+RM5CDLFePPPxfNT9dXI1jxv
         8k6MMvtm+0eVGRWj3VqCAQPJMS4/oyYdHtihCeXCCPthmNgMkIvhDwMHU+HcxqlSE055
         pRlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eohJaWMwHM3aQ7gsRG83gYLtltQvygf7sinDrI0ygig=;
        b=eywCjvdz3RDsIuz8doPm8qI97bVJdbfaJ50G/XnQuebE/0Y/jXebnRcPwuEoOjHroG
         kXpFaYlGBb+SgZklyBjpufn2SyVXM6GB3QN3Yd2cud1OTvhdLcAWrRAWNUGp1okV1w1o
         I7s99blTG0CEcyIM+h6NwFqJr0D7i+5gmU5IpJDLnqyvOYfVo5qm7pJHn4Ba8J2PDdCr
         RmHMbOY0HOdg+WLg8wiIHKLLFidlFXPEh5sHcwIsK2qFk1BB8FnYZ5waQnOnyQMW7DyC
         NWVhI9/Gmk1XxMk3mRKVw55V+DEYUXf1/uv57ehQgYs7JZAGFyjWDVbIxT4ANyoBMk5e
         FoHQ==
X-Gm-Message-State: AOAM532bnP3XZf5ErgTKTNvJTw42rckDMbD2oX+J910QHTEZa5qTWYUz
        VYu7ySDbHs4zNiB4VAQBh1QJIfYXiSdgcQ==
X-Google-Smtp-Source: ABdhPJzUvZkRTixl6eUZ3sGkwZNGRgkZCOElBS24+pUMC7xIHwFUE/IXk4+4s5nLIfZjS4QOAN71UA==
X-Received: by 2002:a05:6512:3254:: with SMTP id c20mr795322lfr.161.1603800398815;
        Tue, 27 Oct 2020 05:06:38 -0700 (PDT)
Received: from mtpad.corp.uber.com (88-119-96-125.static.zebra.lt. [88.119.96.125])
        by smtp.gmail.com with ESMTPSA id 9sm154532lft.116.2020.10.27.05.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 05:06:37 -0700 (PDT)
From:   =?UTF-8?q?Motiejus=20Jak=C5=A1tys?= <desired.mta@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-doc@vger.kernel.org
Cc:     trivial@kernel.org,
        =?UTF-8?q?Motiejus=20Jak=C5=A1tys?= <desired.mta@gmail.com>
Subject: [PATCH] Documentation: tproxy: more gentle intro
Date:   Tue, 27 Oct 2020 14:06:20 +0200
Message-Id: <20201027120620.476066-1-desired.mta@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clarify tproxy odcumentation, so it's easier to read/understand without
a-priori in-kernel transparent proxying knowledge:

- re-shuffle the sections, as the "router" section is easier to
  understand when getting started.
- add a link to HAProxy page. This is where I learned most about what
  tproxy is, so I believe it is reasonable to include.
- removed a reference to linux 2.2.

Plus Sphinx formatting/cosmetic changes.

Signed-off-by: Motiejus Jakštys <desired.mta@gmail.com>
---
 Documentation/networking/tproxy.rst | 155 +++++++++++++++-------------
 1 file changed, 83 insertions(+), 72 deletions(-)

diff --git a/Documentation/networking/tproxy.rst b/Documentation/networking/tproxy.rst
index 00dc3a1a66b4..0f43159046fb 100644
--- a/Documentation/networking/tproxy.rst
+++ b/Documentation/networking/tproxy.rst
@@ -1,42 +1,77 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-=========================
-Transparent proxy support
-=========================
+==========================
+Transparent proxy (TPROXY)
+==========================
 
-This feature adds Linux 2.2-like transparent proxy support to current kernels.
-To use it, enable the socket match and the TPROXY target in your kernel config.
-You will need policy routing too, so be sure to enable that as well.
+TPROXY enables forwarding and intercepting packets that were destined
+for other destination IPs, without using NAT chain or REDIRECT targets.
 
-From Linux 4.18 transparent proxy support is also available in nf_tables.
+Redirecting traffic
+===================
 
-1. Making non-local sockets work
-================================
+TPROXY is often used to "intercept" traffic on a router. This is usually done
+with the iptables ``REDIRECT`` target, however, there are serious limitations:
+it modifies the packets to change the destination address -- which might not be
+acceptable in certain situations, e.g.:
+- UDP: you won't be able to find out the original destination address.
+- TCP: getting the original destination address is racy.
 
-The idea is that you identify packets with destination address matching a local
-socket on your box, set the packet mark to a certain value::
+The ``TPROXY`` target provides similar functionality without relying on NAT.
+Simply add rules like this to the iptables ruleset above:
 
-    # iptables -t mangle -N DIVERT
-    # iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
-    # iptables -t mangle -A DIVERT -j MARK --set-mark 1
-    # iptables -t mangle -A DIVERT -j ACCEPT
+.. code-block:: sh
 
-Alternatively you can do this in nft with the following commands::
+    iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY \
+      --tproxy-mark 0x1/0x1 --on-port 50080
+
+Or the following rule to nft:
+
+.. code-block:: sh
+
+    nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
+
+Note that for this to work you'll have to modify the proxy to enable
+(``SOL_IP``, ``IP_TRANSPARENT``) for the listening socket.
+
+As an example implementation, tcprdr is available here:
+https://git.breakpoint.cc/cgit/fw/tcprdr.git/
+This tool is written by Florian Westphal and it was used for testing during the
+nf_tables implementation.
+
+Intercepting non-local packets
+==============================
+
+To identify packets with destination address matching a local socket on your
+box, set the packet mark to a certain value:
+
+.. code-block:: sh
+
+    iptables -t mangle -N DIVERT
+    iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
+    iptables -t mangle -A DIVERT -j MARK --set-mark 1
+    iptables -t mangle -A DIVERT -j ACCEPT
+
+Alternatively in nft:
+
+.. code-block:: sh
+
+    nft add table filter
+    nft add chain filter divert "{ type filter hook prerouting priority -150; }"
+    nft add rule filter divert meta l4proto tcp socket transparent 1 meta mark set 1 accept
 
-    # nft add table filter
-    # nft add chain filter divert "{ type filter hook prerouting priority -150; }"
-    # nft add rule filter divert meta l4proto tcp socket transparent 1 meta mark set 1 accept
+Then match on that value using policy routing to deliver those packets locally:
 
-And then match on that value using policy routing to have those packets
-delivered locally::
+.. code-block:: sh
 
-    # ip rule add fwmark 1 lookup 100
-    # ip route add local 0.0.0.0/0 dev lo table 100
+    ip rule add fwmark 1 lookup 100
+    ip route add local 0.0.0.0/0 dev lo table 100
 
-Because of certain restrictions in the IPv4 routing output code you'll have to
-modify your application to allow it to send datagrams _from_ non-local IP
-addresses. All you have to do is enable the (SOL_IP, IP_TRANSPARENT) socket
-option before calling bind::
+Because of certain restrictions in the IPv4 routing application will need to be
+modified to allow it to send datagrams *from* non-local IP addresses. Enable
+the ``SOL_IP``, ``IP_TRANSPARENT`` socket options before calling ``bind``:
+
+.. code-block:: c
 
     fd = socket(AF_INET, SOCK_STREAM, 0);
     /* - 8< -*/
@@ -51,59 +86,35 @@ option before calling bind::
 A trivial patch for netcat is available here:
 http://people.netfilter.org/hidden/tproxy/netcat-ip_transparent-support.patch
 
+Kernel configuration
+====================
 
-2. Redirecting traffic
-======================
-
-Transparent proxying often involves "intercepting" traffic on a router. This is
-usually done with the iptables REDIRECT target; however, there are serious
-limitations of that method. One of the major issues is that it actually
-modifies the packets to change the destination address -- which might not be
-acceptable in certain situations. (Think of proxying UDP for example: you won't
-be able to find out the original destination address. Even in case of TCP
-getting the original destination address is racy.)
-
-The 'TPROXY' target provides similar functionality without relying on NAT. Simply
-add rules like this to the iptables ruleset above::
-
-    # iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY \
-      --tproxy-mark 0x1/0x1 --on-port 50080
-
-Or the following rule to nft:
-
-# nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
-
-Note that for this to work you'll have to modify the proxy to enable (SOL_IP,
-IP_TRANSPARENT) for the listening socket.
+To use tproxy you'll need to have the following modules compiled for iptables:
 
-As an example implementation, tcprdr is available here:
-https://git.breakpoint.cc/cgit/fw/tcprdr.git/
-This tool is written by Florian Westphal and it was used for testing during the
-nf_tables implementation.
+ - ``NETFILTER_XT_MATCH_SOCKET``
+ - ``NETFILTER_XT_TARGET_TPROXY``
 
-3. Iptables and nf_tables extensions
-====================================
+For nf_tables:
 
-To use tproxy you'll need to have the following modules compiled for iptables:
+ - ``NFT_TPROXY``
+ - ``NFT_SOCKET``
 
- - NETFILTER_XT_MATCH_SOCKET
- - NETFILTER_XT_TARGET_TPROXY
+Application support
+======================
 
-Or the floowing modules for nf_tables:
+Squid
+-----
 
- - NFT_SOCKET
- - NFT_TPROXY
+Squid 3.1+ has built-in support for TPROXY. To use it, pass
+``--enable-linux-netfilter`` to configure and set the 'tproxy' option on the
+HTTP listener you redirect traffic to with the TPROXY iptables target.
 
-4. Application support
-======================
+For more information please consult the `Squid wiki`_.
 
-4.1. Squid
-----------
+HAproxy
+-------
 
-Squid 3.HEAD has support built-in. To use it, pass
-'--enable-linux-netfilter' to configure and set the 'tproxy' option on
-the HTTP listener you redirect traffic to with the TPROXY iptables
-target.
+Documented in `Haproxy blog`_.
 
-For more information please consult the following page on the Squid
-wiki: http://wiki.squid-cache.org/Features/Tproxy4
+.. _`Squid wiki`: http://wiki.squid-cache.org/Features/Tproxy4
+.. _`HAproxy blog`: https://www.haproxy.com/blog/howto-transparent-proxying-and-binding-with-haproxy-and-aloha-load-balancer/

base-commit: 4525c8781ec0701ce824e8bd379ae1b129e26568
-- 
2.28.0

