Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208E81C18B9
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbgEAOtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbgEAOpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:06 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC6320857;
        Fri,  1 May 2020 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344305;
        bh=cbS/UvPxXHd/6qKkogBfad5uTRh7vyKuBBi1oajHudE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6s/cBheaWlXqvUtDzVeyOK6L+94HL+MiawJoaISJJbMvOsoWeBr+CDwlkVjiW3zA
         ArYWytIDe71h2CT5HI+91e8/iy+4KkkTb2+I0SGIJI4yl/dVV0wgJRHL3c3/tK1iaf
         WSAJC+wUgAiSWLfIIJ+wtpBoicf82h3PFc8Lt5z4=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCch-Ak; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 04/37] docs: networking: convert vxlan.txt to ReST
Date:   Fri,  1 May 2020 16:44:26 +0200
Message-Id: <f2a0c9b723a92b697e3161d2b93f5ae87cb3801b.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../networking/{vxlan.txt => vxlan.rst}       | 33 ++++++++++++-------
 2 files changed, 22 insertions(+), 12 deletions(-)
 rename Documentation/networking/{vxlan.txt => vxlan.rst} (73%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 2227b9f4509d..a72fdfb391b6 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -114,6 +114,7 @@ Contents:
    tuntap
    udplite
    vrf
+   vxlan
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/vxlan.txt b/Documentation/networking/vxlan.rst
similarity index 73%
rename from Documentation/networking/vxlan.txt
rename to Documentation/networking/vxlan.rst
index c28f4989c3f0..ce239fa01848 100644
--- a/Documentation/networking/vxlan.txt
+++ b/Documentation/networking/vxlan.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================================================
 Virtual eXtensible Local Area Networking documentation
 ======================================================
 
@@ -21,8 +24,9 @@ neighbors GRE and VLAN. Configuring VXLAN requires the version of
 iproute2 that matches the kernel release where VXLAN was first merged
 upstream.
 
-1. Create vxlan device
- # ip link add vxlan0 type vxlan id 42 group 239.1.1.1 dev eth1 dstport 4789
+1. Create vxlan device::
+
+    # ip link add vxlan0 type vxlan id 42 group 239.1.1.1 dev eth1 dstport 4789
 
 This creates a new device named vxlan0.  The device uses the multicast
 group 239.1.1.1 over eth1 to handle traffic for which there is no
@@ -32,20 +36,25 @@ pre-dates the IANA's selection of a standard destination port number
 and uses the Linux-selected value by default to maintain backwards
 compatibility.
 
-2. Delete vxlan device
-  # ip link delete vxlan0
+2. Delete vxlan device::
 
-3. Show vxlan info
-  # ip -d link show vxlan0
+    # ip link delete vxlan0
+
+3. Show vxlan info::
+
+    # ip -d link show vxlan0
 
 It is possible to create, destroy and display the vxlan
 forwarding table using the new bridge command.
 
-1. Create forwarding table entry
-  # bridge fdb add to 00:17:42:8a:b4:05 dst 192.19.0.2 dev vxlan0
+1. Create forwarding table entry::
 
-2. Delete forwarding table entry
-  # bridge fdb delete 00:17:42:8a:b4:05 dev vxlan0
+    # bridge fdb add to 00:17:42:8a:b4:05 dst 192.19.0.2 dev vxlan0
 
-3. Show forwarding table
-  # bridge fdb show dev vxlan0
+2. Delete forwarding table entry::
+
+    # bridge fdb delete 00:17:42:8a:b4:05 dev vxlan0
+
+3. Show forwarding table::
+
+    # bridge fdb show dev vxlan0
-- 
2.25.4

