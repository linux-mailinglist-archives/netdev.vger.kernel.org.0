Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE8E2A7B72
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgKEKOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKEKOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 05:14:15 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD78C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 02:14:15 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id l10so976141lji.4
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 02:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H0Jh8qFmzOTKB0vQ8d8hXJG9B1KbcleeafSmKKRtics=;
        b=YSYYTbBO0wZo1vAHR9ZLQfGYmv8h8IoUbAt6YaLOU2TLLygIk7GP3N/MXkogruMFN/
         Rla+tcIBT/WIAZbopVjbamILlDtS2I5bBJmHy85EUs1wZqkEN6vPX+mLeyNOGrnGPLCW
         w6WwlhgVDF0R00e3zpp1kbg9Yiiw/75aoqMtr7E0uz5QXQ8H/qWpH3hTV06QF9BodoEL
         dCHBmNWLArrY8aXhvso2R67ubPkiX7I41YV2xtBgZGdRNBnqGgnNfkt0Tsm+nATBf5Xn
         t0tIIixr7KNZ5pf1IoutK+s4q2NTMvXrtxQBL2Hvgq02dBIISroOupQYgn20Yp0Qm2wN
         /dGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H0Jh8qFmzOTKB0vQ8d8hXJG9B1KbcleeafSmKKRtics=;
        b=Ip4ysdkK8jlov/JQdqvTRK/yr1zouyauGBKS3eTkVq8xUR2HoX2p6lVIIqkQ8emA5M
         x/JCYsEs2NBRu/FCZeA8bF3hGsrmKp2kkfdQQW43nUtvvoICQ9d6op2PzSCWINR/jMaG
         Pm304Ef+sb28cj14uKmAU2ztgUo8twQrabl4Q18kzp4PGRM0+MTdtHHktkIGcly/k8Z2
         wi0JU0/1y6Ov2hFOJ2wv7Tt2h9NoFfz/FIpY8q1sgDnRtBFbAtdhcKuyc0rIei1CFoIs
         716zmORKKqyKaJIm2zoPL8YiH35O0NwZKmajbEtwHeuIS3BZqlWouWg05qYAjw7HlAJz
         vRug==
X-Gm-Message-State: AOAM532Rd9nLDawbc5EQopmk17Qx2NK4c2qv3/e3+zMnj1Qx+954Sq6K
        mBNMUJBhvM2ouMLiwpUhjWM7o6SRD96Pyg==
X-Google-Smtp-Source: ABdhPJwdVLDVFD/zcBwyUGCda6KSIOEeBG9wpDxya7yW0LyHHHy9CapSplM1yWKkrQBsob+XWWFt6w==
X-Received: by 2002:a2e:88cb:: with SMTP id a11mr669969ljk.304.1604571253216;
        Thu, 05 Nov 2020 02:14:13 -0800 (PST)
Received: from mtpad.i.jakstys.lt ([88.223.105.124])
        by smtp.gmail.com with ESMTPSA id n20sm132545lfl.249.2020.11.05.02.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 02:14:12 -0800 (PST)
From:   =?UTF-8?q?Motiejus=20Jak=C5=A1tys?= <desired.mta@gmail.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     trivial@kernel.org,
        =?UTF-8?q?Motiejus=20Jak=C5=A1tys?= <desired.mta@gmail.com>
Subject: [PATCH] Documentation: tproxy: more gentle intro
Date:   Thu,  5 Nov 2020 12:13:59 +0200
Message-Id: <20201105101359.106730-1-desired.mta@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clarify tproxy odcumentation, so it's easier to read/understand without
a-priori in-kernel transparent proxying knowledge.

Remove a reference to linux 2.2 and cosmetic Sphinx changes.

Signed-off-by: Motiejus Jakštys <desired.mta@gmail.com>
---
 Documentation/networking/tproxy.rst | 119 +++++++++++++++-------------
 1 file changed, 63 insertions(+), 56 deletions(-)

diff --git a/Documentation/networking/tproxy.rst b/Documentation/networking/tproxy.rst
index 00dc3a1a66b4..a15e9651e3df 100644
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
@@ -51,9 +54,21 @@ option before calling bind::
 A trivial patch for netcat is available here:
 http://people.netfilter.org/hidden/tproxy/netcat-ip_transparent-support.patch
 
+Kernel configuration
+====================
 
-2. Redirecting traffic
-======================
+To use tproxy you'll need to have the following modules compiled for iptables:
+
+ - ``NETFILTER_XT_MATCH_SOCKET``
+ - ``NETFILTER_XT_TARGET_TPROXY``
+
+For nf_tables:
+
+ - ``NFT_TPROXY``
+ - ``NFT_SOCKET``
+
+Redirecting traffic
+===================
 
 Transparent proxying often involves "intercepting" traffic on a router. This is
 usually done with the iptables REDIRECT target; however, there are serious
@@ -63,47 +78,39 @@ acceptable in certain situations. (Think of proxying UDP for example: you won't
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

