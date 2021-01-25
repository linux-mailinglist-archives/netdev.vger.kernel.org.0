Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3088630300A
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732149AbhAYXWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:22:33 -0500
Received: from conuserg-10.nifty.com ([210.131.2.77]:49068 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732103AbhAYXVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 18:21:48 -0500
Received: from localhost.localdomain (softbank126026094251.bbtec.net [126.26.94.251]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 10PNKYDv019068;
        Tue, 26 Jan 2021 08:20:34 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 10PNKYDv019068
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1611616834;
        bh=+l83WuWdtV27RWVmVMoaKLClHYmBniItWR+xAN910Iw=;
        h=From:To:Cc:Subject:Date:From;
        b=kLtOiqSG1PsPTiDWCaePLM0vRNPJmBlKXHsz4UUY2gBjqu54b8BYCoQnrq5xweKX3
         XbrfxMJhZa3P03+ttLIXwf0cf2h+9LTaMMH7a4Uz/m/xsqXBh3nLPVrIsPH19nhboz
         2TLkEnIsozUY4szfRdq6QsNMEBj/4MmkI27Icqhj8FUcHIWTRpZQyLcQUgux+Difj0
         3r/amToA5g6Qo2xb8cR2kx3UDzASmYgwEUNs7EAZp7CPdJ8q0B1qTjwpRd6wWwMu3l
         4R5ZSQOCNR/5ne2UUXi7r3Hnrn1dWX6QogeRup5kCfIaWf29v0E0PA8l4y1GkzkG4v
         hkh2ZrXcZuEEA==
X-Nifty-SrcIP: [126.26.94.251]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH] net: remove redundant 'depends on NET'
Date:   Tue, 26 Jan 2021 08:20:26 +0900
Message-Id: <20210125232026.106855-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These Kconfig files are included from net/Kconfig, inside the
if NET ... endif.

Remove 'depends on NET', which we know it is already met.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 net/9p/Kconfig             | 1 -
 net/batman-adv/Kconfig     | 1 -
 net/bluetooth/Kconfig      | 2 +-
 net/bpfilter/Kconfig       | 2 +-
 net/can/Kconfig            | 1 -
 net/dns_resolver/Kconfig   | 2 +-
 net/ife/Kconfig            | 1 -
 net/llc/Kconfig            | 1 -
 net/netfilter/Kconfig      | 2 +-
 net/netfilter/ipvs/Kconfig | 2 +-
 net/nfc/Kconfig            | 1 -
 net/psample/Kconfig        | 1 -
 12 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index 3d11fec3a8dc..64468c49791f 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -4,7 +4,6 @@
 #
 
 menuconfig NET_9P
-	depends on NET
 	tristate "Plan 9 Resource Sharing Support (9P2000)"
 	help
 	  If you say Y here, you will get experimental support for
diff --git a/net/batman-adv/Kconfig b/net/batman-adv/Kconfig
index 993afd5ff7bb..43ae3dcbbbeb 100644
--- a/net/batman-adv/Kconfig
+++ b/net/batman-adv/Kconfig
@@ -9,7 +9,6 @@
 
 config BATMAN_ADV
 	tristate "B.A.T.M.A.N. Advanced Meshing Protocol"
-	depends on NET
 	select LIBCRC32C
 	help
 	  B.A.T.M.A.N. (better approach to mobile ad-hoc networking) is
diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
index 64e669acd42f..400c5130dc0a 100644
--- a/net/bluetooth/Kconfig
+++ b/net/bluetooth/Kconfig
@@ -5,7 +5,7 @@
 
 menuconfig BT
 	tristate "Bluetooth subsystem support"
-	depends on NET && !S390
+	depends on !S390
 	depends on RFKILL || !RFKILL
 	select CRC16
 	select CRYPTO
diff --git a/net/bpfilter/Kconfig b/net/bpfilter/Kconfig
index 8ad0233ce497..3d4a21462458 100644
--- a/net/bpfilter/Kconfig
+++ b/net/bpfilter/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig BPFILTER
 	bool "BPF based packet filtering framework (BPFILTER)"
-	depends on NET && BPF && INET
+	depends on BPF && INET
 	select USERMODE_DRIVER
 	help
 	  This builds experimental bpfilter framework that is aiming to
diff --git a/net/can/Kconfig b/net/can/Kconfig
index 7c9958df91d3..a9ac5ffab286 100644
--- a/net/can/Kconfig
+++ b/net/can/Kconfig
@@ -4,7 +4,6 @@
 #
 
 menuconfig CAN
-	depends on NET
 	tristate "CAN bus subsystem support"
 	help
 	  Controller Area Network (CAN) is a slow (up to 1Mbit/s) serial
diff --git a/net/dns_resolver/Kconfig b/net/dns_resolver/Kconfig
index 255df9b6e9e8..155b06163409 100644
--- a/net/dns_resolver/Kconfig
+++ b/net/dns_resolver/Kconfig
@@ -4,7 +4,7 @@
 #
 config DNS_RESOLVER
 	tristate "DNS Resolver support"
-	depends on NET && KEYS
+	depends on KEYS
 	help
 	  Saying Y here will include support for the DNS Resolver key type
 	  which can be used to make upcalls to perform DNS lookups in
diff --git a/net/ife/Kconfig b/net/ife/Kconfig
index bcf650564db4..de36a5b91e50 100644
--- a/net/ife/Kconfig
+++ b/net/ife/Kconfig
@@ -4,7 +4,6 @@
 #
 
 menuconfig NET_IFE
-	depends on NET
 	tristate "Inter-FE based on IETF ForCES InterFE LFB"
 	default n
 	help
diff --git a/net/llc/Kconfig b/net/llc/Kconfig
index b0e646ac47eb..7f79f5e134f9 100644
--- a/net/llc/Kconfig
+++ b/net/llc/Kconfig
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config LLC
 	tristate
-	depends on NET
 
 config LLC2
 	tristate "ANSI/IEEE 802.2 LLC type 2 Support"
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 49fbef0d99be..1a92063c73a4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menu "Core Netfilter Configuration"
-	depends on NET && INET && NETFILTER
+	depends on INET && NETFILTER
 
 config NETFILTER_INGRESS
 	bool "Netfilter ingress support"
diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index eb0e329f9b8d..c39a1e35c104 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -4,7 +4,7 @@
 #
 menuconfig IP_VS
 	tristate "IP virtual server support"
-	depends on NET && INET && NETFILTER
+	depends on INET && NETFILTER
 	depends on (NF_CONNTRACK || NF_CONNTRACK=n)
 	help
 	  IP Virtual Server support will let you build a high-performance
diff --git a/net/nfc/Kconfig b/net/nfc/Kconfig
index 96b91674dd37..466a0279b93e 100644
--- a/net/nfc/Kconfig
+++ b/net/nfc/Kconfig
@@ -4,7 +4,6 @@
 #
 
 menuconfig NFC
-	depends on NET
 	depends on RFKILL || !RFKILL
 	tristate "NFC subsystem support"
 	default n
diff --git a/net/psample/Kconfig b/net/psample/Kconfig
index 028f514a9c60..be0b839209ba 100644
--- a/net/psample/Kconfig
+++ b/net/psample/Kconfig
@@ -4,7 +4,6 @@
 #
 
 menuconfig PSAMPLE
-	depends on NET
 	tristate "Packet-sampling netlink channel"
 	default n
 	help
-- 
2.27.0

