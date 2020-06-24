Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BFC207C3B
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 21:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406165AbgFXTdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 15:33:19 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:46272 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406009AbgFXTdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 15:33:17 -0400
Received: from ubuntu18.lan (unknown [109.129.49.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 069B2200CD0F;
        Wed, 24 Jun 2020 21:24:25 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 069B2200CD0F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1593026666;
        bh=J6IOBfi+YX/dmLJpGhJELSU+C5lfXydF+0lEFG0qGRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8lyzjpdqL9rWN8oz1Bcvwo0ZXLLknWd8EAEuZXcltPWvjgE+Z0EanE8Kp07sHdLX
         I3lMtwBIkHIJJ50s5m9Pv8ZHzi857BSwhw94QaSn4NVCsSdrDyQ1LaRd966AlDaE1g
         Ivdcr4e4F6/u2SRvfWTq+VA5Lg8V88nx3KygZ6N+6e6WPPpFdbbtEdQLMtXpuh94lA
         T273YJdsr8snXnrukQVLELQ2TschB4WxDoBF7e0NaunweDmQafvjTiGShs8jcq72wQ
         aUb0f/cHKR+ecSwsdupZ7dLaVxPahBiruTZeqrUAYrjOK9KR6TMp0gNSSYhg2eQhlD
         SBWBcjjYnGtSg==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, justin.iurman@uliege.be
Subject: [PATCH net-next 5/5] ipv6: ioam: Documentation for new IOAM sysctls
Date:   Wed, 24 Jun 2020 21:23:10 +0200
Message-Id: <20200624192310.16923-6-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200624192310.16923-1-justin.iurman@uliege.be>
References: <20200624192310.16923-1-justin.iurman@uliege.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for new IOAM sysctls:
 - ioam6_id: a namespace sysctl
 - ioam6_enabled and ioam6_id: two per-interface sysctls

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 Documentation/networking/ioam6-sysctl.rst | 20 ++++++++++++++++++++
 Documentation/networking/ip-sysctl.rst    |  5 +++++
 2 files changed, 25 insertions(+)
 create mode 100644 Documentation/networking/ioam6-sysctl.rst

diff --git a/Documentation/networking/ioam6-sysctl.rst b/Documentation/networking/ioam6-sysctl.rst
new file mode 100644
index 000000000000..bad6c64907bc
--- /dev/null
+++ b/Documentation/networking/ioam6-sysctl.rst
@@ -0,0 +1,20 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================
+IOAM6 Sysfs variables
+=====================
+
+
+/proc/sys/net/conf/<iface>/ioam6_* variables:
+============================================
+
+ioam6_enabled - BOOL
+	Enable (accept) or disable (drop) IPv6 IOAM packets on this interface.
+
+	* 0 - disabled (default)
+	* not 0 - enabled
+
+ioam6_id - INTEGER
+	Define the IOAM id of this interface.
+
+	Default is 0.
diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b72f89d5694c..5ba11f2766bd 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1770,6 +1770,11 @@ nexthop_compat_mode - BOOLEAN
 	and extraneous notifications.
 	Default: true (backward compat mode)
 
+ioam6_id - INTEGER
+	Define the IOAM id of this node.
+
+	Default: 0
+
 IPv6 Fragmentation:
 
 ip6frag_high_thresh - INTEGER
-- 
2.17.1

