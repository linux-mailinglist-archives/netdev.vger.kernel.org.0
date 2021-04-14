Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BC935F142
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 12:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbhDNKJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 06:09:58 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:34735 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1348932AbhDNKJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 06:09:24 -0400
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2021 06:09:23 EDT
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id C64B69223F4;
        Wed, 14 Apr 2021 12:00:30 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1lWcJy-0003kF-Od; Wed, 14 Apr 2021 12:00:30 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net] doc: move seg6_flowlabel to seg6-sysctl.rst
Date:   Wed, 14 Apr 2021 12:00:27 +0200
Message-Id: <20210414100027.14313-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's have all seg6 sysctl at the same place.

Fixes: a6dc6670cd7e ("ipv6: sr: Add documentation for seg_flowlabel sysctl")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 Documentation/networking/ip-sysctl.rst   | 15 ---------------
 Documentation/networking/seg6-sysctl.rst | 13 +++++++++++++
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c7952ac5bd2f..3feb5e565b1a 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1849,21 +1849,6 @@ ip6frag_low_thresh - INTEGER
 ip6frag_time - INTEGER
 	Time in seconds to keep an IPv6 fragment in memory.
 
-IPv6 Segment Routing:
-
-seg6_flowlabel - INTEGER
-	Controls the behaviour of computing the flowlabel of outer
-	IPv6 header in case of SR T.encaps
-
-	 == =======================================================
-	 -1  set flowlabel to zero.
-	  0  copy flowlabel from Inner packet in case of Inner IPv6
-	     (Set flowlabel to 0 in case IPv4/L2)
-	  1  Compute the flowlabel using seg6_make_flowlabel()
-	 == =======================================================
-
-	Default is 0.
-
 ``conf/default/*``:
 	Change the interface-specific default settings.
 
diff --git a/Documentation/networking/seg6-sysctl.rst b/Documentation/networking/seg6-sysctl.rst
index ec73e1445030..07c20e470baf 100644
--- a/Documentation/networking/seg6-sysctl.rst
+++ b/Documentation/networking/seg6-sysctl.rst
@@ -24,3 +24,16 @@ seg6_require_hmac - INTEGER
 	* 1 - Drop SR packets without HMAC, validate SR packets with HMAC
 
 	Default is 0.
+
+seg6_flowlabel - INTEGER
+	Controls the behaviour of computing the flowlabel of outer
+	IPv6 header in case of SR T.encaps
+
+	 == =======================================================
+	 -1  set flowlabel to zero.
+	  0  copy flowlabel from Inner packet in case of Inner IPv6
+	     (Set flowlabel to 0 in case IPv4/L2)
+	  1  Compute the flowlabel using seg6_make_flowlabel()
+	 == =======================================================
+
+	Default is 0.
-- 
2.30.0

