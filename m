Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24FD01BB10F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgD0WDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgD0WCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:01 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED3B82224E;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=korjmdIz5+QmtD2eNR4t6gFNj/yVol8UzgK9BHlywlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbz+/zx6OyRtWiJyqMAA3erBs+E7NpVNGzQ4D5sM5C1Nt4R6enZIRVOM2dCQUpM9b
         Pd01KgISFMgp+H2Z4Uc+ckTfflH+mj+fxG9XZtyM4PHzmBYxgLur3KkkfSElxbKTpf
         HvgUr7tDu7BR1jj1l03rc8JvNY0Lg8unvfZr2i5Y=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000Ipx-8C; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 29/38] docs: networking: convert ila.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:44 +0200
Message-Id: <92d7e5c4989e8aa5630d30bc07463de3662084c5.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/{ila.txt => ila.rst} | 81 +++++++++++--------
 Documentation/networking/index.rst            |  1 +
 2 files changed, 47 insertions(+), 35 deletions(-)
 rename Documentation/networking/{ila.txt => ila.rst} (82%)

diff --git a/Documentation/networking/ila.txt b/Documentation/networking/ila.rst
similarity index 82%
rename from Documentation/networking/ila.txt
rename to Documentation/networking/ila.rst
index a17dac9dc915..5ac0a6270b17 100644
--- a/Documentation/networking/ila.txt
+++ b/Documentation/networking/ila.rst
@@ -1,4 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
 Identifier Locator Addressing (ILA)
+===================================
 
 
 Introduction
@@ -26,11 +30,13 @@ The ILA protocol is described in Internet-Draft draft-herbert-intarea-ila.
 ILA terminology
 ===============
 
-  - Identifier	A number that identifies an addressable node in the network
+  - Identifier
+		A number that identifies an addressable node in the network
 		independent of its location. ILA identifiers are sixty-four
 		bit values.
 
-  - Locator	A network prefix that routes to a physical host. Locators
+  - Locator
+		A network prefix that routes to a physical host. Locators
 		provide the topological location of an addressed node. ILA
 		locators are sixty-four bit prefixes.
 
@@ -51,17 +57,20 @@ ILA terminology
 		bits) and an identifier (low order sixty-four bits). ILA
 		addresses are never visible to an application.
 
-  - ILA host	An end host that is capable of performing ILA translations
+  - ILA host
+		An end host that is capable of performing ILA translations
 		on transmit or receive.
 
-  - ILA router	A network node that performs ILA translation and forwarding
+  - ILA router
+		A network node that performs ILA translation and forwarding
 		of translated packets.
 
   - ILA forwarding cache
 		A type of ILA router that only maintains a working set
 		cache of mappings.
 
-  - ILA node	A network node capable of performing ILA translations. This
+  - ILA node
+		A network node capable of performing ILA translations. This
 		can be an ILA router, ILA forwarding cache, or ILA host.
 
 
@@ -82,18 +91,18 @@ Configuration and datapath for these two points of deployment is somewhat
 different.
 
 The diagram below illustrates the flow of packets through ILA as well
-as showing ILA hosts and routers.
+as showing ILA hosts and routers::
 
     +--------+                                                +--------+
     | Host A +-+                                         +--->| Host B |
     |        | |              (2) ILA                   (')   |        |
     +--------+ |            ...addressed....           (   )  +--------+
-               V  +---+--+  .  packet      .  +---+--+  (_)
+	       V  +---+--+  .  packet      .  +---+--+  (_)
    (1) SIR     |  | ILA  |----->-------->---->| ILA  |   |   (3) SIR
     addressed  +->|router|  .              .  |router|->-+    addressed
     packet        +---+--+  .     IPv6     .  +---+--+        packet
-                   /        .    Network   .
-                  /         .              .   +--+-++--------+
+		   /        .    Network   .
+		  /         .              .   +--+-++--------+
     +--------+   /          .              .   |ILA ||  Host  |
     |  Host  +--+           .              .- -|host||        |
     |        |              .              .   +--+-++--------+
@@ -173,7 +182,7 @@ ILA address, never a SIR address.
 
 In the simplest format the identifier types, C-bit, and checksum
 adjustment value are not present so an identifier is considered an
-unstructured sixty-four bit value.
+unstructured sixty-four bit value::
 
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                            Identifier                         |
@@ -184,7 +193,7 @@ unstructured sixty-four bit value.
 The checksum neutral adjustment may be configured to always be
 present using neutral-map-auto. In this case there is no C-bit, but the
 checksum adjustment is in the low order 16 bits. The identifier is
-still sixty-four bits.
+still sixty-four bits::
 
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |                            Identifier                         |
@@ -193,7 +202,7 @@ still sixty-four bits.
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 
 The C-bit may used to explicitly indicate that checksum neutral
-mapping has been applied to an ILA address. The format is:
+mapping has been applied to an ILA address. The format is::
 
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      |     |C|                    Identifier                         |
@@ -204,7 +213,7 @@ mapping has been applied to an ILA address. The format is:
 The identifier type field may be present to indicate the identifier
 type. If it is not present then the type is inferred based on mapping
 configuration. The checksum neutral adjustment may automatically
-used with the identifier type as illustrated below.
+used with the identifier type as illustrated below::
 
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      | Type|                      Identifier                         |
@@ -213,7 +222,7 @@ used with the identifier type as illustrated below.
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 
 If the identifier type and the C-bit can be present simultaneously so
-the identifier format would be:
+the identifier format would be::
 
      +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
      | Type|C|                    Identifier                         |
@@ -258,28 +267,30 @@ same meanings as described above.
 Some examples
 =============
 
-# Configure an ILA route that uses checksum neutral mapping as well
-# as type field. Note that the type field is set in the SIR address
-# (the 2000 implies type is 1 which is LUID).
-ip route add 3333:0:0:1:2000:0:1:87/128 encap ila 2001:0:87:0 \
-     csum-mode neutral-map ident-type use-format
+::
 
-# Configure an ILA LWT route that uses auto checksum neutral mapping
-# (no C-bit) and configure identifier type to be LUID so that the
-# identifier type field will not be present.
-ip route add 3333:0:0:1:2000:0:2:87/128 encap ila 2001:0:87:1 \
-     csum-mode neutral-map-auto ident-type luid
+     # Configure an ILA route that uses checksum neutral mapping as well
+     # as type field. Note that the type field is set in the SIR address
+     # (the 2000 implies type is 1 which is LUID).
+     ip route add 3333:0:0:1:2000:0:1:87/128 encap ila 2001:0:87:0 \
+	  csum-mode neutral-map ident-type use-format
 
-ila_xlat configuration
+     # Configure an ILA LWT route that uses auto checksum neutral mapping
+     # (no C-bit) and configure identifier type to be LUID so that the
+     # identifier type field will not be present.
+     ip route add 3333:0:0:1:2000:0:2:87/128 encap ila 2001:0:87:1 \
+	  csum-mode neutral-map-auto ident-type luid
 
-# Configure an ILA to SIR mapping that matches a locator and overwrites
-# it with a SIR address (3333:0:0:1 in this example). The C-bit and
-# identifier field are used.
-ip ila add loc_match 2001:0:119:0 loc 3333:0:0:1 \
-    csum-mode neutral-map-auto ident-type use-format
+     ila_xlat configuration
 
-# Configure an ILA to SIR mapping where checksum neutral is automatically
-# set without the C-bit and the identifier type is configured to be LUID
-# so that the identifier type field is not present.
-ip ila add loc_match 2001:0:119:0 loc 3333:0:0:1 \
-    csum-mode neutral-map-auto ident-type use-format
+     # Configure an ILA to SIR mapping that matches a locator and overwrites
+     # it with a SIR address (3333:0:0:1 in this example). The C-bit and
+     # identifier field are used.
+     ip ila add loc_match 2001:0:119:0 loc 3333:0:0:1 \
+	 csum-mode neutral-map-auto ident-type use-format
+
+     # Configure an ILA to SIR mapping where checksum neutral is automatically
+     # set without the C-bit and the identifier type is configured to be LUID
+     # so that the identifier type field is not present.
+     ip ila add loc_match 2001:0:119:0 loc 3333:0:0:1 \
+	 csum-mode neutral-map-auto ident-type use-format
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 5a7889df1375..488971f6b650 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -64,6 +64,7 @@ Contents:
    gen_stats
    gtp
    hinic
+   ila
 
 .. only::  subproject and html
 
-- 
2.25.4

