Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7D324D62A
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 15:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgHUNgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 09:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgHUNgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 09:36:49 -0400
Received: from sym2.noone.org (sym2.noone.org [IPv6:2a01:4f8:120:4161::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FB4C061573;
        Fri, 21 Aug 2020 06:36:48 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4BY2cC0vFGzvjcZ; Fri, 21 Aug 2020 15:36:42 +0200 (CEST)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] bpf: fix two typos in uapi/linux/bpf.h
Date:   Fri, 21 Aug 2020 15:36:42 +0200
Message-Id: <20200821133642.18870-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also remove trailing whitespaces in bpf_skb_get_tunnel_key example code.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 include/uapi/linux/bpf.h       | 10 +++++-----
 tools/include/uapi/linux/bpf.h | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0480f893facd..b6238b2209b7 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -767,7 +767,7 @@ union bpf_attr {
  *
  * 		Also, note that **bpf_trace_printk**\ () is slow, and should
  * 		only be used for debugging purposes. For this reason, a notice
- * 		bloc (spanning several lines) is printed to kernel logs and
+ * 		block (spanning several lines) is printed to kernel logs and
  * 		states that the helper should not be used "for production use"
  * 		the first time this helper is used (or more precisely, when
  * 		**trace_printk**\ () buffers are allocated). For passing values
@@ -1033,14 +1033,14 @@ union bpf_attr {
  *
  * 			int ret;
  * 			struct bpf_tunnel_key key = {};
- * 			
+ *
  * 			ret = bpf_skb_get_tunnel_key(skb, &key, sizeof(key), 0);
  * 			if (ret < 0)
  * 				return TC_ACT_SHOT;	// drop packet
- * 			
+ *
  * 			if (key.remote_ipv4 != 0x0a000001)
  * 				return TC_ACT_SHOT;	// drop packet
- * 			
+ *
  * 			return TC_ACT_OK;		// accept packet
  *
  * 		This interface can also be used with all encapsulation devices
@@ -1147,7 +1147,7 @@ union bpf_attr {
  * 	Description
  * 		Retrieve the realm or the route, that is to say the
  * 		**tclassid** field of the destination for the *skb*. The
- * 		indentifier retrieved is a user-provided tag, similar to the
+ * 		identifier retrieved is a user-provided tag, similar to the
  * 		one used with the net_cls cgroup (see description for
  * 		**bpf_get_cgroup_classid**\ () helper), but here this tag is
  * 		held by a route (a destination entry), not by a task.
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0480f893facd..b6238b2209b7 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -767,7 +767,7 @@ union bpf_attr {
  *
  * 		Also, note that **bpf_trace_printk**\ () is slow, and should
  * 		only be used for debugging purposes. For this reason, a notice
- * 		bloc (spanning several lines) is printed to kernel logs and
+ * 		block (spanning several lines) is printed to kernel logs and
  * 		states that the helper should not be used "for production use"
  * 		the first time this helper is used (or more precisely, when
  * 		**trace_printk**\ () buffers are allocated). For passing values
@@ -1033,14 +1033,14 @@ union bpf_attr {
  *
  * 			int ret;
  * 			struct bpf_tunnel_key key = {};
- * 			
+ *
  * 			ret = bpf_skb_get_tunnel_key(skb, &key, sizeof(key), 0);
  * 			if (ret < 0)
  * 				return TC_ACT_SHOT;	// drop packet
- * 			
+ *
  * 			if (key.remote_ipv4 != 0x0a000001)
  * 				return TC_ACT_SHOT;	// drop packet
- * 			
+ *
  * 			return TC_ACT_OK;		// accept packet
  *
  * 		This interface can also be used with all encapsulation devices
@@ -1147,7 +1147,7 @@ union bpf_attr {
  * 	Description
  * 		Retrieve the realm or the route, that is to say the
  * 		**tclassid** field of the destination for the *skb*. The
- * 		indentifier retrieved is a user-provided tag, similar to the
+ * 		identifier retrieved is a user-provided tag, similar to the
  * 		one used with the net_cls cgroup (see description for
  * 		**bpf_get_cgroup_classid**\ () helper), but here this tag is
  * 		held by a route (a destination entry), not by a task.
-- 
2.27.0

