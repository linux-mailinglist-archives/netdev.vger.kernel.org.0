Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9941BA79E
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgD0POC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:14:02 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52485 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728214AbgD0PNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id BF42D5C00A1;
        Mon, 27 Apr 2020 11:13:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=RztEzVJh3dJTftPpTVSmpsROlhFCl9elhIJQjqNwTCU=; b=xfzhK0c/
        HqSc+r3dUi3qkpWAREEb4guBthm90m//m7K6UFBdWF7l/d3NQUiRO58KYRPMR7Hc
        aSf2JMeqijRs/fDxhh4cV9WmULK+lpueL9/EaXS/hrMc8xAXn5+iHjeDdQ+nL5TF
        JB6ukrt4bhzmN0pUQf3jRITa0G6WDzE4eQ6zAqk4jAdlfD+d/G7b1brsi1nrUHql
        f9kzvhMQK+pQBKXXTA1G5Alwm3+OpwzivCYy6R30qWlgIDa4Sfhtn6BWq7kqLMMp
        nTVB9r7JVNnjiaybL/5IpPGVExUcYqCYPMEFAOzHKiHFayLssH0tG4fJhTFEOx1P
        dmzZWpOwoPO8Mg==
X-ME-Sender: <xms:rPamXryl32K0FfqqwbpFBPk2nDnzTyDUeejuHhajWX_7bQC54o_GSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpeduudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:rPamXreJ4psI6FYvhrfxtSEb1XzckM-YKGgATRtd-81w5-QPniF5PA>
    <xmx:rPamXg7PXRdraku-Giq7t8ERu7sDhSIShBSQtZcbentqZw_skMhfrw>
    <xmx:rPamXgJDWKKYSPo1G3OoiE0oOOqXxtTFBAFHpQ9T1An8o8FoSOYWhw>
    <xmx:rPamXvkgqkMEzlPxfPbCxdf5n-B36Eaf1Nne3R3dGpiw2imd7hEqUw>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E781328005D;
        Mon, 27 Apr 2020 11:13:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 13/13] selftests: forwarding: tc_actions.sh: add matchall mirror test
Date:   Mon, 27 Apr 2020 18:13:10 +0300
Message-Id: <20200427151310.3950411-14-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427151310.3950411-1-idosch@idosch.org>
References: <20200427151310.3950411-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add test for matchall classifier with mirred egress mirror action.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/tc_actions.sh    | 26 +++++++++++++------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index 813d02d1939d..d9eca227136b 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -2,7 +2,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ALL_TESTS="gact_drop_and_ok_test mirred_egress_redirect_test \
-	mirred_egress_mirror_test gact_trap_test"
+	mirred_egress_mirror_test matchall_mirred_egress_mirror_test \
+	gact_trap_test"
 NUM_NETIFS=4
 source tc_common.sh
 source lib.sh
@@ -50,6 +51,9 @@ switch_destroy()
 mirred_egress_test()
 {
 	local action=$1
+	local protocol=$2
+	local classifier=$3
+	local classifier_args=$4
 
 	RET=0
 
@@ -62,9 +66,9 @@ mirred_egress_test()
 	tc_check_packets "dev $h2 ingress" 101 1
 	check_fail $? "Matched without redirect rule inserted"
 
-	tc filter add dev $swp1 ingress protocol ip pref 1 handle 101 flower \
-		$tcflags dst_ip 192.0.2.2 action mirred egress $action \
-		dev $swp2
+	tc filter add dev $swp1 ingress protocol $protocol pref 1 handle 101 \
+		$classifier $tcflags $classifier_args \
+		action mirred egress $action dev $swp2
 
 	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
 		-t ip -q
@@ -72,10 +76,11 @@ mirred_egress_test()
 	tc_check_packets "dev $h2 ingress" 101 1
 	check_err $? "Did not match incoming $action packet"
 
-	tc filter del dev $swp1 ingress protocol ip pref 1 handle 101 flower
+	tc filter del dev $swp1 ingress protocol $protocol pref 1 handle 101 \
+		$classifier
 	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
 
-	log_test "mirred egress $action ($tcflags)"
+	log_test "mirred egress $classifier $action ($tcflags)"
 }
 
 gact_drop_and_ok_test()
@@ -187,12 +192,17 @@ cleanup()
 
 mirred_egress_redirect_test()
 {
-	mirred_egress_test "redirect"
+	mirred_egress_test "redirect" "ip" "flower" "dst_ip 192.0.2.2"
 }
 
 mirred_egress_mirror_test()
 {
-	mirred_egress_test "mirror"
+	mirred_egress_test "mirror" "ip" "flower" "dst_ip 192.0.2.2"
+}
+
+matchall_mirred_egress_mirror_test()
+{
+	mirred_egress_test "mirror" "all" "matchall" ""
 }
 
 trap cleanup EXIT
-- 
2.24.1

