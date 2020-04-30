Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0526B1C019C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgD3QH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbgD3QEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:38 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ECD424960;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=AKLSRgDRMriBe2VoqmymF5TgViMK8zitSGO+zOckj4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmz2JniklUmBdPRbKa2AoCq051T0Mmlq6iC1/X2xhwrCFRLKwyuDwgMbn58tU1E3O
         H9Fzrae1h+3NJ3h1TRtpKdoGgRXO0knnexhH6niXDR9202ah23t1yFNgpIHGChaSG+
         v8JUvHp7ECphYKGa1/MlifkBkLyBs8MF5kmRhRYc=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxF3-9x; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 12/37] docs: networking: convert nf_conntrack-sysctl.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:07 +0200
Message-Id: <4ce89bb56e2bf138c78dbf9ad9d654051b786be1.1588261997.git.mchehab+huawei@kernel.org>
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
- add a document title;
- mark lists as such;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 ...ack-sysctl.txt => nf_conntrack-sysctl.rst} | 51 +++++++++++--------
 2 files changed, 30 insertions(+), 22 deletions(-)
 rename Documentation/networking/{nf_conntrack-sysctl.txt => nf_conntrack-sysctl.rst} (85%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index d98509f15363..e5128bb7e7df 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -85,6 +85,7 @@ Contents:
    netdevices
    netfilter-sysctl
    netif-msg
+   nf_conntrack-sysctl
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/nf_conntrack-sysctl.txt b/Documentation/networking/nf_conntrack-sysctl.rst
similarity index 85%
rename from Documentation/networking/nf_conntrack-sysctl.txt
rename to Documentation/networking/nf_conntrack-sysctl.rst
index f75c2ce6e136..11a9b76786cb 100644
--- a/Documentation/networking/nf_conntrack-sysctl.txt
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -1,8 +1,15 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+Netfilter Conntrack Sysfs variables
+===================================
+
 /proc/sys/net/netfilter/nf_conntrack_* Variables:
+=================================================
 
 nf_conntrack_acct - BOOLEAN
-	0 - disabled (default)
-	not 0 - enabled
+	- 0 - disabled (default)
+	- not 0 - enabled
 
 	Enable connection tracking flow accounting. 64-bit byte and packet
 	counters per flow are added.
@@ -16,8 +23,8 @@ nf_conntrack_buckets - INTEGER
 	This sysctl is only writeable in the initial net namespace.
 
 nf_conntrack_checksum - BOOLEAN
-	0 - disabled
-	not 0 - enabled (default)
+	- 0 - disabled
+	- not 0 - enabled (default)
 
 	Verify checksum of incoming packets. Packets with bad checksums are
 	in INVALID state. If this is enabled, such packets will not be
@@ -27,8 +34,8 @@ nf_conntrack_count - INTEGER (read-only)
 	Number of currently allocated flow entries.
 
 nf_conntrack_events - BOOLEAN
-	0 - disabled
-	not 0 - enabled (default)
+	- 0 - disabled
+	- not 0 - enabled (default)
 
 	If this option is enabled, the connection tracking code will
 	provide userspace with connection tracking events via ctnetlink.
@@ -62,8 +69,8 @@ nf_conntrack_generic_timeout - INTEGER (seconds)
 	protocols.
 
 nf_conntrack_helper - BOOLEAN
-	0 - disabled (default)
-	not 0 - enabled
+	- 0 - disabled (default)
+	- not 0 - enabled
 
 	Enable automatic conntrack helper assignment.
 	If disabled it is required to set up iptables rules to assign
@@ -81,14 +88,14 @@ nf_conntrack_icmpv6_timeout - INTEGER (seconds)
 	Default for ICMP6 timeout.
 
 nf_conntrack_log_invalid - INTEGER
-	0   - disable (default)
-	1   - log ICMP packets
-	6   - log TCP packets
-	17  - log UDP packets
-	33  - log DCCP packets
-	41  - log ICMPv6 packets
-	136 - log UDPLITE packets
-	255 - log packets of any protocol
+	- 0   - disable (default)
+	- 1   - log ICMP packets
+	- 6   - log TCP packets
+	- 17  - log UDP packets
+	- 33  - log DCCP packets
+	- 41  - log ICMPv6 packets
+	- 136 - log UDPLITE packets
+	- 255 - log packets of any protocol
 
 	Log invalid packets of a type specified by value.
 
@@ -97,15 +104,15 @@ nf_conntrack_max - INTEGER
 	nf_conntrack_buckets value * 4.
 
 nf_conntrack_tcp_be_liberal - BOOLEAN
-	0 - disabled (default)
-	not 0 - enabled
+	- 0 - disabled (default)
+	- not 0 - enabled
 
 	Be conservative in what you do, be liberal in what you accept from others.
 	If it's non-zero, we mark only out of window RST segments as INVALID.
 
 nf_conntrack_tcp_loose - BOOLEAN
-	0 - disabled
-	not 0 - enabled (default)
+	- 0 - disabled
+	- not 0 - enabled (default)
 
 	If it is set to zero, we disable picking up already established
 	connections.
@@ -148,8 +155,8 @@ nf_conntrack_tcp_timeout_unacknowledged - INTEGER (seconds)
 	default 300
 
 nf_conntrack_timestamp - BOOLEAN
-	0 - disabled (default)
-	not 0 - enabled
+	- 0 - disabled (default)
+	- not 0 - enabled
 
 	Enable connection tracking flow timestamping.
 
-- 
2.25.4

