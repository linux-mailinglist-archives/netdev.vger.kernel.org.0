Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290743C4E5
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404251AbfFKHUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:20:35 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58125 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404288AbfFKHUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 03:20:19 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EBAA82224B;
        Tue, 11 Jun 2019 03:20:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 03:20:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=zuhMYHRHNo+QouK0pBkJfwGo/+uishZOgWH/Crh0s6w=; b=mwhw5LSA
        xQS7j+A1g9xvAdj6zEdF3Cc7O7dHshkDK+uUCu3m2+82g5rDlWSyIwfBbdt69sRi
        jcFDbUtd0Lu8NGa664aUc5l6GxSnPOxI0Z7lJG9Do2BbF7ObAkosky6tRaUcgrVd
        tqkeEqZXxpGThWNz2PRVUpEQO6I8372GHh3lQWqEWWDv0lheuyBsmK6NJFGWWM27
        yUzkyQKnPMFbcRHxBNmnb/s+wqdaf+7X2i71JYPdXL0rMouQnlbNS3IMTl+J/ZZK
        ZZ/UO32qPa3odfxSS4nhAaekMEi8VyVDrf5MCwr0xSn5xAVcVXa/MgcQhvvqLwhR
        vexFB/EbmkAbzA==
X-ME-Sender: <xms:Mlb_XFkh3jC_cqu4_ximkfYNU1oc-B66YouzSTvgO2n-OCWeJ_y68w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehfedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:Mlb_XFsAaMkLoHvmhEzJgNmtYXyNeQawXlhjitVRxdv5j4_2jaxRRw>
    <xmx:Mlb_XEMxyqIDqq4V1ydk-9wkqLR79aRTX2kv86lulnKgjMdEytY7IQ>
    <xmx:Mlb_XG16IFjXy3scYAh1r_1mor4OxH7M3-OmhNDxFK0L_dqr9Q6IIg>
    <xmx:Mlb_XFfxge7J5rcFPy01uLgN7e1o9JISlgSQIOZwW1gIQ4u1nF5YFw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7261C38008D;
        Tue, 11 Jun 2019 03:20:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 5/7] selftests: tc_flower: Add TOS matching test
Date:   Tue, 11 Jun 2019 10:19:44 +0300
Message-Id: <20190611071946.11089-6-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611071946.11089-1-idosch@idosch.org>
References: <20190611071946.11089-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/tc_flower.sh     | 36 ++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_flower.sh b/tools/testing/selftests/net/forwarding/tc_flower.sh
index 29bcfa84aec7..124803eea4a9 100755
--- a/tools/testing/selftests/net/forwarding/tc_flower.sh
+++ b/tools/testing/selftests/net/forwarding/tc_flower.sh
@@ -2,7 +2,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ALL_TESTS="match_dst_mac_test match_src_mac_test match_dst_ip_test \
-	match_src_ip_test match_ip_flags_test match_pcp_test match_vlan_test"
+	match_src_ip_test match_ip_flags_test match_pcp_test match_vlan_test \
+	match_ip_tos_test"
 NUM_NETIFS=2
 source tc_common.sh
 source lib.sh
@@ -276,6 +277,39 @@ match_vlan_test()
 	log_test "VLAN match ($tcflags)"
 }
 
+match_ip_tos_test()
+{
+	RET=0
+
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		$tcflags dst_ip 192.0.2.2 ip_tos 0x20 action drop
+	tc filter add dev $h2 ingress protocol ip pref 2 handle 102 flower \
+		$tcflags dst_ip 192.0.2.2 ip_tos 0x18 action drop
+
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip tos=18 -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_fail $? "Matched on a wrong filter (0x18)"
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_err $? "Did not match on correct filter (0x18)"
+
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip tos=20 -q
+
+	tc_check_packets "dev $h2 ingress" 102 2
+	check_fail $? "Matched on a wrong filter (0x20)"
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct filter (0x20)"
+
+	tc filter del dev $h2 ingress protocol ip pref 2 handle 102 flower
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
+
+	log_test "ip_tos match ($tcflags)"
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
-- 
2.20.1

