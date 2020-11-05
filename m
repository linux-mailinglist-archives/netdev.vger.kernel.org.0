Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C5E2A7BB3
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgKEK14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgKEK14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 05:27:56 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021E2C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 02:27:56 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id f9so1539388lfq.2
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 02:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/hpvIiwrNMtYSLTsQfuYSEJ8uD28oo11HkFz3i7yCF4=;
        b=p+0H1XTYwSBkHE4AIKqUBrj8WjMq+7Ljho7zbG1YD5z65Pyj3mfadpRPYo6o6AXSZx
         y7EesABNwUnXb0pft8tJ7jJ53vSPDq9pUSlHSN00fpDk6CM1uaILjupka4cJPsAmXgiG
         15WhTUxI3NGp7KKLh+RE6jkX+NzO8WLjLS/g7myeAs42iNLhAaXITXFlkKgW6NnOM0k5
         HnY65K+GWWTZg73a2rrdqZnTAWBxzwHO0tBcVhLtvWTyUGeBm7aWSpkyF2xwawIuoml6
         z3FXXNpMCKCH5B1tP7lmc5BI78las4ZMcATCfNyknYtgZ72u07YsJuY/IlR+BWfuSskp
         AzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/hpvIiwrNMtYSLTsQfuYSEJ8uD28oo11HkFz3i7yCF4=;
        b=O66irxjy4IJyPCtapT+9arPNJqkVmrCFCpKoyOa7wDMT5iM05tgsfcDpP099A6QtcP
         IpHyZCkZy6poZqfeDKLwp4dm5QPywL2iyxGh+gNLO/wzPA/LjZ8xztDiGpYHyr2+M9eR
         a9kkBbWH8SgwZaiyUhpwcbq+L+id6a6OjkjYGU9f6F64hfit8GozI7H6jmb81yiuR/8R
         jKiuvp9HWPMQXGfX6Y9N9UoHDaoJGFCPcbAxKutY1ByZpb9iYGeI1w6OIhsUwYJ7Cb4e
         WrzLKfsYbeBb5JdgOpfO7ACyWiQyflJ5mUkuYPEFgWRs7BuePk0a5CyxtrCFlTaAwrGF
         dwRg==
X-Gm-Message-State: AOAM530kn0bPoccn8pg+JFBnQIxIQ6fe91vLIsr32xCjklfiexjmeuT7
        1/QGiii8MbjzJmVQOfLa3lbXj9RzkGhPWg==
X-Google-Smtp-Source: ABdhPJyjrMyJc7/eMpEYj96VBKLT9td7TQRPjPJ4KfwazvyxsEB9hjF5EXiuJaVMI3jJqlTzzX+uSA==
X-Received: by 2002:a19:4a90:: with SMTP id x138mr665782lfa.174.1604572074003;
        Thu, 05 Nov 2020 02:27:54 -0800 (PST)
Received: from mtpad.i.jakstys.lt ([88.223.105.124])
        by smtp.gmail.com with ESMTPSA id c4sm140188lfh.60.2020.11.05.02.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 02:27:53 -0800 (PST)
From:   =?UTF-8?q?Motiejus=20Jak=C5=A1tys?= <desired.mta@gmail.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     trivial@kernel.org,
        =?UTF-8?q?Motiejus=20Jak=C5=A1tys?= <desired.mta@gmail.com>
Subject: [PATCH] Documentation: tproxy: more gentle intro (re-post #2)
Date:   Thu,  5 Nov 2020 12:26:04 +0200
Message-Id: <20201105102602.109991-1-desired.mta@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clarify tproxy odcumentation, so it's easier to read/understand without
a-priori in-kernel transparent proxying knowledge.

Remove a reference to linux 2.2 and cosmetic Sphinx changes and address
comments from kuba@.

Sorry for re-posting, I realized I left a gap just after sending.

Signed-off-by: Motiejus Jakštys <desired.mta@gmail.com>
---
 Documentation/networking/tproxy.rst | 120 +++++++++++++++-------------
 1 file changed, 64 insertions(+), 56 deletions(-)

diff --git a/Documentation/networking/tproxy.rst b/Documentation/networking/tproxy.rst
index 00dc3a1a66b4..d2673de0e408 100644
--- a/Documentation/networking/tproxy.rst
+++ b/Documentation/networking/tproxy.rst
@@ -1,42 +1,45 @@
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
+TPROXY enables forwarding and intercepting packets that were destined for other
+endpoints, without using NAT chain or REDIRECT targets.
 
-From Linux 4.18 transparent proxy support is also available in nf_tables.
+Intercepting non-local packets
+==============================
 
-1. Making non-local sockets work
-================================
+To identify packets with destination address matching a local socket on your
+box, set the packet mark to a certain value:
 
-The idea is that you identify packets with destination address matching a local
-socket on your box, set the packet mark to a certain value::
+.. code-block:: sh
 
-    # iptables -t mangle -N DIVERT
-    # iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
-    # iptables -t mangle -A DIVERT -j MARK --set-mark 1
-    # iptables -t mangle -A DIVERT -j ACCEPT
+    iptables -t mangle -N DIVERT
+    iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
+    iptables -t mangle -A DIVERT -j MARK --set-mark 1
+    iptables -t mangle -A DIVERT -j ACCEPT
 
-Alternatively you can do this in nft with the following commands::
+Alternatively in nft:
 
-    # nft add table filter
-    # nft add chain filter divert "{ type filter hook prerouting priority -150; }"
-    # nft add rule filter divert meta l4proto tcp socket transparent 1 meta mark set 1 accept
+.. code-block:: sh
 
-And then match on that value using policy routing to have those packets
-delivered locally::
+    nft add table filter
+    nft add chain filter divert "{ type filter hook prerouting priority -150; }"
+    nft add rule filter divert meta l4proto tcp socket transparent 1 meta mark set 1 accept
 
-    # ip rule add fwmark 1 lookup 100
-    # ip route add local 0.0.0.0/0 dev lo table 100
+Then match on that value using policy routing to deliver those packets locally:
 
-Because of certain restrictions in the IPv4 routing output code you'll have to
-modify your application to allow it to send datagrams _from_ non-local IP
-addresses. All you have to do is enable the (SOL_IP, IP_TRANSPARENT) socket
-option before calling bind::
+.. code-block:: sh
+
+    ip rule add fwmark 1 lookup 100
+    ip route add local 0.0.0.0/0 dev lo table 100
+
+Because of certain restrictions in the IPv4 routing application will need to be
+modified to allow it to send datagrams *from* non-local IP addresses. Enable
+the ``SOL_IP``, ``IP_TRANSPARENT`` socket options before calling ``bind``:
+
+.. code-block:: c
 
     fd = socket(AF_INET, SOCK_STREAM, 0);
     /* - 8< -*/
@@ -51,9 +54,22 @@ option before calling bind::
 A trivial patch for netcat is available here:
 http://people.netfilter.org/hidden/tproxy/netcat-ip_transparent-support.patch
 
+Kernel configuration
+====================
 
-2. Redirecting traffic
-======================
+To use tproxy you'll need to have the following modules compiled for iptables:
+
+- ``NETFILTER_XT_MATCH_POLICY``
+- ``NETFILTER_XT_MATCH_SOCKET``
+- ``NETFILTER_XT_TARGET_TPROXY``
+
+For nf_tables:
+
+- ``NFT_TPROXY``
+- ``NFT_SOCKET``
+
+Redirecting traffic
+===================
 
 Transparent proxying often involves "intercepting" traffic on a router. This is
 usually done with the iptables REDIRECT target; however, there are serious
@@ -63,47 +79,39 @@ acceptable in certain situations. (Think of proxying UDP for example: you won't
 be able to find out the original destination address. Even in case of TCP
 getting the original destination address is racy.)
 
-The 'TPROXY' target provides similar functionality without relying on NAT. Simply
-add rules like this to the iptables ruleset above::
+The ``TPROXY`` target provides similar functionality without relying on NAT.
+Simply add rules like this to the iptables ruleset:
 
-    # iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY \
+.. code-block:: sh
+
+    iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY \
       --tproxy-mark 0x1/0x1 --on-port 50080
 
 Or the following rule to nft:
 
-# nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
+.. code-block:: sh
+
+    nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
 
-Note that for this to work you'll have to modify the proxy to enable (SOL_IP,
-IP_TRANSPARENT) for the listening socket.
+Note that for this to work you'll have to modify the proxy to enable
+(``SOL_IP``, ``IP_TRANSPARENT``) for the listening socket.
 
 As an example implementation, tcprdr is available here:
 https://git.breakpoint.cc/cgit/fw/tcprdr.git/
 This tool is written by Florian Westphal and it was used for testing during the
 nf_tables implementation.
 
-3. Iptables and nf_tables extensions
-====================================
-
-To use tproxy you'll need to have the following modules compiled for iptables:
-
- - NETFILTER_XT_MATCH_SOCKET
- - NETFILTER_XT_TARGET_TPROXY
-
-Or the floowing modules for nf_tables:
 
- - NFT_SOCKET
- - NFT_TPROXY
-
-4. Application support
+Application support
 ======================
 
-4.1. Squid
-----------
+Squid
+-----
+
+Squid 3.1+ has built-in support for TPROXY. To use it, pass
+``--enable-linux-netfilter`` to configure and set the 'tproxy' option on the
+HTTP listener you redirect traffic to with the TPROXY iptables target.
 
-Squid 3.HEAD has support built-in. To use it, pass
-'--enable-linux-netfilter' to configure and set the 'tproxy' option on
-the HTTP listener you redirect traffic to with the TPROXY iptables
-target.
+For more information please consult the `Squid wiki`_.
 
-For more information please consult the following page on the Squid
-wiki: http://wiki.squid-cache.org/Features/Tproxy4
+.. _`Squid wiki`: http://wiki.squid-cache.org/Features/Tproxy4
-- 
2.28.0

