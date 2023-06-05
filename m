Return-Path: <netdev+bounces-8241-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43CC37233B2
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 01:33:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F30FD281415
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B77928C11;
	Mon,  5 Jun 2023 23:33:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372A22773D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 23:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C352C433D2;
	Mon,  5 Jun 2023 23:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686007980;
	bh=oHDlpQD95d8Yfc5m/V1ZxXmkoVPQUktthDXFgzS4BSc=;
	h=From:To:Cc:Subject:Date:From;
	b=AIFntCJ/vBN1bJcSSVHGGBv5h5gvRQjsytDOfcmyf7U7aNgVCTZrxenW034jV+aXz
	 9v/Ih4V94pMqQm7bdRMUla/OO8VKIYG4S79A1+EwU5heDZxC68+YOIV74eX4lDUu4z
	 gKW16Hu2TV5cTZLSm1zUG6u7vEblUsrY9wZT9o5wlh/4QM5n2a/DZIR23YioJ0lqXQ
	 cBxFMEciXIRPCqDot02s2OLeIWLe6qCu9VrpngoAa8he29+/TkQyUfm4S+SdpKNLsb
	 gbCEh/XFQwswP2LREKdLgzlXQ3EdOAF35mmd/Ico36o99eUlivH4kNz1ZuCvh48qou
	 13anGFA2McpdA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	sdf@google.com
Subject: [PATCH net] netlink: specs: ethtool: fix random typos
Date: Mon,  5 Jun 2023 16:32:57 -0700
Message-Id: <20230605233257.843977-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Working on the code gen for C reveals typos in the ethtool spec
as the compiler tries to find the names in the existing uAPI
header. Fix the mistakes.

Fixes: a353318ebf24 ("tools: ynl: populate most of the ethtool spec")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: sdf@google.com
---
 Documentation/netlink/specs/ethtool.yaml | 32 ++++++++++++------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 3abc576ff797..4846345bade4 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -223,7 +223,7 @@ doc: Partial family for Ethtool Netlink.
         name: tx-min-frag-size
         type: u32
       -
-        name: tx-min-frag-size
+        name: rx-min-frag-size
         type: u32
       -
         name: verify-enabled
@@ -294,7 +294,7 @@ doc: Partial family for Ethtool Netlink.
         name: master-slave-state
         type: u8
       -
-        name: master-slave-lanes
+        name: lanes
         type: u32
       -
         name: rate-matching
@@ -322,7 +322,7 @@ doc: Partial family for Ethtool Netlink.
         name: ext-substate
         type: u8
       -
-        name: down-cnt
+        name: ext-down-cnt
         type: u32
   -
     name: debug
@@ -577,7 +577,7 @@ doc: Partial family for Ethtool Netlink.
         name: phc-index
         type: u32
   -
-    name: cable-test-nft-nest-result
+    name: cable-test-ntf-nest-result
     attributes:
       -
         name: pair
@@ -586,7 +586,7 @@ doc: Partial family for Ethtool Netlink.
         name: code
         type: u8
   -
-    name: cable-test-nft-nest-fault-length
+    name: cable-test-ntf-nest-fault-length
     attributes:
       -
         name: pair
@@ -595,16 +595,16 @@ doc: Partial family for Ethtool Netlink.
         name: cm
         type: u32
   -
-    name: cable-test-nft-nest
+    name: cable-test-ntf-nest
     attributes:
       -
         name: result
         type: nest
-        nested-attributes: cable-test-nft-nest-result
+        nested-attributes: cable-test-ntf-nest-result
       -
         name: fault-length
         type: nest
-        nested-attributes: cable-test-nft-nest-fault-length
+        nested-attributes: cable-test-ntf-nest-fault-length
   -
     name: cable-test
     attributes:
@@ -618,7 +618,7 @@ doc: Partial family for Ethtool Netlink.
       -
         name: nest
         type: nest
-        nested-attributes: cable-test-nft-nest
+        nested-attributes: cable-test-ntf-nest
   -
     name: cable-test-tdr-cfg
     attributes:
@@ -776,7 +776,7 @@ doc: Partial family for Ethtool Netlink.
         name: hist-bkt-hi
         type: u32
       -
-        name: hist-bkt-val
+        name: hist-val
         type: u64
   -
     name: stats
@@ -965,7 +965,7 @@ doc: Partial family for Ethtool Netlink.
             - duplex
             - master-slave-cfg
             - master-slave-state
-            - master-slave-lanes
+            - lanes
             - rate-matching
       dump: *linkmodes-get-op
     -
@@ -999,7 +999,7 @@ doc: Partial family for Ethtool Netlink.
             - sqi-max
             - ext-state
             - ext-substate
-            - down-cnt
+            - ext-down-cnt
       dump: *linkstate-get-op
     -
       name: debug-get
@@ -1351,7 +1351,7 @@ doc: Partial family for Ethtool Netlink.
         reply:
           attributes:
             - header
-            - cable-test-nft-nest
+            - cable-test-ntf-nest
     -
       name: cable-test-tdr-act
       doc: Cable test TDR.
@@ -1539,7 +1539,7 @@ doc: Partial family for Ethtool Netlink.
             - hkey
       dump: *rss-get-op
     -
-      name: plca-get
+      name: plca-get-cfg
       doc: Get PLCA params.
 
       attribute-set: plca
@@ -1561,7 +1561,7 @@ doc: Partial family for Ethtool Netlink.
             - burst-tmr
       dump: *plca-get-op
     -
-      name: plca-set
+      name: plca-set-cfg
       doc: Set PLCA params.
 
       attribute-set: plca
@@ -1585,7 +1585,7 @@ doc: Partial family for Ethtool Netlink.
     -
       name: plca-ntf
       doc: Notification for change in PLCA params.
-      notify: plca-get
+      notify: plca-get-cfg
     -
       name: mm-get
       doc: Get MAC Merge configuration and state
-- 
2.40.1


