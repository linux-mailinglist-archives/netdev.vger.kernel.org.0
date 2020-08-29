Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF462566DF
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 12:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgH2Kr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 06:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgH2KrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 06:47:21 -0400
X-Greylist: delayed 1710 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 29 Aug 2020 03:46:50 PDT
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF460C061236
        for <netdev@vger.kernel.org>; Sat, 29 Aug 2020 03:46:50 -0700 (PDT)
Received: from localhost ([::1]:37796 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kBxw5-0000kM-D9; Sat, 29 Aug 2020 12:18:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: [iproute PATCH] ip link: Fix indenting in help text
Date:   Sat, 29 Aug 2020 12:18:35 +0200
Message-Id: <20200829101835.2372-1-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indenting of 'ip link set' options below 'link-netns' was wrong, they
should be on the same level as the above.

While being at it, fix closing brackets in vf-specific options. Also
write node/port_guid parameters in upper-case without curly braces: They
are supposed to be replaced by values, not put literally.

Fixes: 8589eb4efdf2a ("treewide: refactor help messages")
Fixes: 5a3ec4ba64783 ("iplink: Update usage in help message")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 ip/iplink.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index 7d4b244d1d266..5ec33a98b96e9 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -86,26 +86,26 @@ void iplink_usage(void)
 		"		[ mtu MTU ]\n"
 		"		[ netns { PID | NAME } ]\n"
 		"		[ link-netns NAME | link-netnsid ID ]\n"
-		"			[ alias NAME ]\n"
-		"			[ vf NUM [ mac LLADDR ]\n"
-		"				 [ vlan VLANID [ qos VLAN-QOS ] [ proto VLAN-PROTO ] ]\n"
-		"				 [ rate TXRATE ]\n"
-		"				 [ max_tx_rate TXRATE ]\n"
-		"				 [ min_tx_rate TXRATE ]\n"
-		"				 [ spoofchk { on | off} ]\n"
-		"				 [ query_rss { on | off} ]\n"
-		"				 [ state { auto | enable | disable} ] ]\n"
-		"				 [ trust { on | off} ] ]\n"
-		"				 [ node_guid { eui64 } ]\n"
-		"				 [ port_guid { eui64 } ]\n"
-		"			[ { xdp | xdpgeneric | xdpdrv | xdpoffload } { off |\n"
-		"				  object FILE [ section NAME ] [ verbose ] |\n"
-		"				  pinned FILE } ]\n"
-		"			[ master DEVICE ][ vrf NAME ]\n"
-		"			[ nomaster ]\n"
-		"			[ addrgenmode { eui64 | none | stable_secret | random } ]\n"
-		"			[ protodown { on | off } ]\n"
-		"			[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
+		"		[ alias NAME ]\n"
+		"		[ vf NUM [ mac LLADDR ]\n"
+		"			 [ vlan VLANID [ qos VLAN-QOS ] [ proto VLAN-PROTO ] ]\n"
+		"			 [ rate TXRATE ]\n"
+		"			 [ max_tx_rate TXRATE ]\n"
+		"			 [ min_tx_rate TXRATE ]\n"
+		"			 [ spoofchk { on | off} ]\n"
+		"			 [ query_rss { on | off} ]\n"
+		"			 [ state { auto | enable | disable} ]\n"
+		"			 [ trust { on | off} ]\n"
+		"			 [ node_guid EUI64 ]\n"
+		"			 [ port_guid EUI64 ] ]\n"
+		"		[ { xdp | xdpgeneric | xdpdrv | xdpoffload } { off |\n"
+		"			  object FILE [ section NAME ] [ verbose ] |\n"
+		"			  pinned FILE } ]\n"
+		"		[ master DEVICE ][ vrf NAME ]\n"
+		"		[ nomaster ]\n"
+		"		[ addrgenmode { eui64 | none | stable_secret | random } ]\n"
+		"		[ protodown { on | off } ]\n"
+		"		[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
 		"\n"
 		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]\n"
 		"\n"
-- 
2.27.0

