Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF521C0146
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgD3QEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgD3QEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:38 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25B2E24962;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=g9zsgpMU0pRn05Q4I3LMUZnpSVfK6mm2505LsXBMD94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECQ+zWV1v8xBEkDa4frh21wMgN4qKZo8CjC6BwGA6TkLwWMmKzPbJCEEMnJiO2LDq
         0RenjuWdT1Jgkmy4um/yCCUIUm+D2JOpVPYYEIqf6/Zvv/GpW1MMz2lPMR7bW9p3q0
         /FS0iuJJST5yLJRe77LY+elwc7IPZRZKeiv3wxpk=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxFD-Bc; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 14/37] docs: networking: convert openvswitch.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:09 +0200
Message-Id: <8ef8171942cf528a54c569cae56f8864ed9c74f2.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
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
 Documentation/networking/index.rst            |  1 +
 .../{openvswitch.txt => openvswitch.rst}      | 23 +++++++++++--------
 2 files changed, 14 insertions(+), 10 deletions(-)
 rename Documentation/networking/{openvswitch.txt => openvswitch.rst} (95%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index c4e8a43741be..b7f558480aca 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -87,6 +87,7 @@ Contents:
    netif-msg
    nf_conntrack-sysctl
    nf_flowtable
+   openvswitch
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/openvswitch.txt b/Documentation/networking/openvswitch.rst
similarity index 95%
rename from Documentation/networking/openvswitch.txt
rename to Documentation/networking/openvswitch.rst
index b3b9ac61d29d..1a8353dbf1b6 100644
--- a/Documentation/networking/openvswitch.txt
+++ b/Documentation/networking/openvswitch.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============================================
 Open vSwitch datapath developer documentation
 =============================================
 
@@ -80,13 +83,13 @@ The <linux/openvswitch.h> header file defines the exact format of the
 flow key attributes.  For informal explanatory purposes here, we write
 them as comma-separated strings, with parentheses indicating arguments
 and nesting.  For example, the following could represent a flow key
-corresponding to a TCP packet that arrived on vport 1:
+corresponding to a TCP packet that arrived on vport 1::
 
     in_port(1), eth(src=e0:91:f5:21:d0:b2, dst=00:02:e3:0f:80:a4),
     eth_type(0x0800), ipv4(src=172.16.0.20, dst=172.18.0.52, proto=17, tos=0,
     frag=no), tcp(src=49163, dst=80)
 
-Often we ellipsize arguments not important to the discussion, e.g.:
+Often we ellipsize arguments not important to the discussion, e.g.::
 
     in_port(1), eth(...), eth_type(0x0800), ipv4(...), tcp(...)
 
@@ -151,20 +154,20 @@ Some care is needed to really maintain forward and backward
 compatibility for applications that follow the rules listed under
 "Flow key compatibility" above.
 
-The basic rule is obvious:
+The basic rule is obvious::
 
-    ------------------------------------------------------------------
+    ==================================================================
     New network protocol support must only supplement existing flow
     key attributes.  It must not change the meaning of already defined
     flow key attributes.
-    ------------------------------------------------------------------
+    ==================================================================
 
 This rule does have less-obvious consequences so it is worth working
 through a few examples.  Suppose, for example, that the kernel module
 did not already implement VLAN parsing.  Instead, it just interpreted
 the 802.1Q TPID (0x8100) as the Ethertype then stopped parsing the
 packet.  The flow key for any packet with an 802.1Q header would look
-essentially like this, ignoring metadata:
+essentially like this, ignoring metadata::
 
     eth(...), eth_type(0x8100)
 
@@ -172,7 +175,7 @@ Naively, to add VLAN support, it makes sense to add a new "vlan" flow
 key attribute to contain the VLAN tag, then continue to decode the
 encapsulated headers beyond the VLAN tag using the existing field
 definitions.  With this change, a TCP packet in VLAN 10 would have a
-flow key much like this:
+flow key much like this::
 
     eth(...), vlan(vid=10, pcp=0), eth_type(0x0800), ip(proto=6, ...), tcp(...)
 
@@ -187,7 +190,7 @@ across kernel versions even though it follows the compatibility rules.
 
 The solution is to use a set of nested attributes.  This is, for
 example, why 802.1Q support uses nested attributes.  A TCP packet in
-VLAN 10 is actually expressed as:
+VLAN 10 is actually expressed as::
 
     eth(...), eth_type(0x8100), vlan(vid=10, pcp=0), encap(eth_type(0x0800),
     ip(proto=6, ...), tcp(...)))
@@ -215,14 +218,14 @@ For example, consider a packet that contains an IP header that
 indicates protocol 6 for TCP, but which is truncated just after the IP
 header, so that the TCP header is missing.  The flow key for this
 packet would include a tcp attribute with all-zero src and dst, like
-this:
+this::
 
     eth(...), eth_type(0x0800), ip(proto=6, ...), tcp(src=0, dst=0)
 
 As another example, consider a packet with an Ethernet type of 0x8100,
 indicating that a VLAN TCI should follow, but which is truncated just
 after the Ethernet type.  The flow key for this packet would include
-an all-zero-bits vlan and an empty encap attribute, like this:
+an all-zero-bits vlan and an empty encap attribute, like this::
 
     eth(...), eth_type(0x8100), vlan(0), encap()
 
-- 
2.25.4

