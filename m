Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E781BB101
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgD0WDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbgD0WCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:01 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3088E22285;
        Mon, 27 Apr 2020 22:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=RpfAiculO1CWkSlT+K3PNUD5JFFarLwrKakCGdMtgK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwXZo1SaI47WPVn/HK875y7YQt97p5fJ9mu9XdaiyJCnDv9GTq1unFfl9+irbMiAK
         jLfKdiQ32/o6lbfoKyX1vPNRqxMzdV9llSygTL380Zc6JTJdHInqvrlaywo+VyEdPL
         UQutuXD0M1VuwSNciluQj4u8ZqM4iMnbOoq3IA90=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000IqS-Di; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Subject: [PATCH 35/38] docs: networking: convert ipv6.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:50 +0200
Message-Id: <3eafd57c449c38460db2aa1628e2034de2406f66.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not much to be done here:

- add SPDX header;
- add a document title;
- mark a literal as such, in order to avoid a warning;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 6 +++---
 Documentation/networking/index.rst              | 1 +
 Documentation/networking/{ipv6.txt => ipv6.rst} | 8 +++++++-
 net/ipv6/Kconfig                                | 2 +-
 4 files changed, 12 insertions(+), 5 deletions(-)
 rename Documentation/networking/{ipv6.txt => ipv6.rst} (93%)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index ef9779398cee..e84951d80e6f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -356,7 +356,7 @@
 			      shot down by NMI
 
 	autoconf=	[IPV6]
-			See Documentation/networking/ipv6.txt.
+			See Documentation/networking/ipv6.rst.
 
 	show_lapic=	[APIC,X86] Advanced Programmable Interrupt Controller
 			Limit apic dumping. The parameter defines the maximal
@@ -875,7 +875,7 @@
 			miss to occur.
 
 	disable=	[IPV6]
-			See Documentation/networking/ipv6.txt.
+			See Documentation/networking/ipv6.rst.
 
 	hardened_usercopy=
                         [KNL] Under CONFIG_HARDENED_USERCOPY, whether
@@ -915,7 +915,7 @@
 			to workaround buggy firmware.
 
 	disable_ipv6=	[IPV6]
-			See Documentation/networking/ipv6.txt.
+			See Documentation/networking/ipv6.rst.
 
 	disable_mtrr_cleanup [X86]
 			The kernel tries to adjust MTRR layout from continuous
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 7d133d8dbe2a..709675464e51 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -70,6 +70,7 @@ Contents:
    iphase
    ipsec
    ip-sysctl
+   ipv6
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/ipv6.txt b/Documentation/networking/ipv6.rst
similarity index 93%
rename from Documentation/networking/ipv6.txt
rename to Documentation/networking/ipv6.rst
index 6cd74fa55358..ba09c2f2dcc7 100644
--- a/Documentation/networking/ipv6.txt
+++ b/Documentation/networking/ipv6.rst
@@ -1,9 +1,15 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====
+IPv6
+====
+
 
 Options for the ipv6 module are supplied as parameters at load time.
 
 Module options may be given as command line arguments to the insmod
 or modprobe command, but are usually specified in either
-/etc/modules.d/*.conf configuration files, or in a distro-specific
+``/etc/modules.d/*.conf`` configuration files, or in a distro-specific
 configuration file.
 
 The available ipv6 module parameters are listed below.  If a parameter
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 2ccaee98fddb..5a6111da26c4 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -13,7 +13,7 @@ menuconfig IPV6
 	  For general information about IPv6, see
 	  <https://en.wikipedia.org/wiki/IPv6>.
 	  For specific information about IPv6 under Linux, see
-	  Documentation/networking/ipv6.txt and read the HOWTO at
+	  Documentation/networking/ipv6.rst and read the HOWTO at
 	  <http://www.tldp.org/HOWTO/Linux+IPv6-HOWTO/>
 
 	  To compile this protocol support as a module, choose M here: the
-- 
2.25.4

