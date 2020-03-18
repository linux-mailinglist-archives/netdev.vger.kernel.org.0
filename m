Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2DBE189D54
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgCRNtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:49:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36397 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727116AbgCRNty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:49:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9F2EE5C019D;
        Wed, 18 Mar 2020 09:49:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 18 Mar 2020 09:49:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ro72zr/yv5EhaekOKPK2qdvRg2tMpMqpboNZUF5kewk=; b=pbGdaQUb
        wmbq6SeSPIlaFp6ALAb1Ejt2LkNPSRwcE1bPr6YnWqr6fW7cSenHkRr+OOzvlUIm
        Gk4FHuDkUzq4cT4GGcivqus/AYfZYBKPnKL0jLQp0a0ceMSVOplWaoPb47mA2vq5
        J6v4nrz2pcBWotiq96ZEX4h2vLzw8MNF/RvVIlY6ZM5butgVJJcqoOQjN82VNa6k
        R09qCB4E9yGDLNivOyYhWbhX5l5LDYmOzBLq9t6IfLBo0GDxes/ekZ1PTqxmMtOH
        h91BhKkF6Q8nxrFsJWk5wP57sRMHUO5G1sHcVeMa3AxnbTJaAzoNKm8rRrnPvCXc
        TK6M+uAoB8yQ1Q==
X-ME-Sender: <xms:ASdyXiRxb-SlSP8DB7X8kWnPdEDfTeFjLqIW2FJXBnmSL5zxkM7dRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefjedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekfedrkedrudekudenucevlhhushhtvghruf
    hiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:ASdyXjuadmEoiDShagbkRVw0T-_T-h6ZM9jjR_w5rGOAOYbC2dlMsg>
    <xmx:ASdyXi7KBQSmie0-TRL9pHFuD5Wi8l5LTCZ9ZMmRJoyeo7vMLzEyRg>
    <xmx:ASdyXpYZVGDxPapAwhpVt0QNIb9z9zWW2qoA5xrBFytStuJgiHB_Sg>
    <xmx:ASdyXvQ1f-l-qvrIJxLVJcudld-HOEQdHaA1cWcn6LuW-Cr7LgbD6Q>
Received: from splinter.mtl.com (bzq-79-183-8-181.red.bezeqint.net [79.183.8.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5C01A3061CB6;
        Wed, 18 Mar 2020 09:49:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 9/9] selftests: mlxsw: Add tc action hw_stats tests
Date:   Wed, 18 Mar 2020 15:48:57 +0200
Message-Id: <20200318134857.1003018-10-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318134857.1003018-1-idosch@idosch.org>
References: <20200318134857.1003018-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add tests for mlxsw hw_stats types.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/tc_action_hw_stats.sh   | 130 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |   9 ++
 2 files changed, 139 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/tc_action_hw_stats.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_action_hw_stats.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_action_hw_stats.sh
new file mode 100755
index 000000000000..20ed98fe5a60
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_action_hw_stats.sh
@@ -0,0 +1,130 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	default_hw_stats_test
+	immediate_hw_stats_test
+	delayed_hw_stats_test
+	disabled_hw_stats_test
+"
+NUM_NETIFS=2
+
+source $lib_dir/tc_common.sh
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.2.1/24
+}
+
+switch_create()
+{
+	simple_if_init $swp1 192.0.2.2/24
+	tc qdisc add dev $swp1 clsact
+}
+
+switch_destroy()
+{
+	tc qdisc del dev $swp1 clsact
+	simple_if_fini $swp1 192.0.2.2/24
+}
+
+hw_stats_test()
+{
+	RET=0
+
+	local name=$1
+	local action_hw_stats=$2
+	local occ_delta=$3
+	local expected_packet_count=$4
+
+	local orig_occ=$(devlink_resource_get "counters" "flow" | jq '.["occ"]')
+
+	tc filter add dev $swp1 ingress protocol ip pref 1 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 action drop $action_hw_stats
+	check_err $? "Failed to add rule with $name hw_stats"
+
+	local new_occ=$(devlink_resource_get "counters" "flow" | jq '.["occ"]')
+	local expected_occ=$((orig_occ + occ_delta))
+	[ "$new_occ" == "$expected_occ" ]
+	check_err $? "Expected occupancy of $expected_occ, got $new_occ"
+
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $swp1mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t ip -q
+
+	tc_check_packets "dev $swp1 ingress" 101 $expected_packet_count
+	check_err $? "Did not match incoming packet"
+
+	tc filter del dev $swp1 ingress protocol ip pref 1 handle 101 flower
+
+	log_test "$name hw_stats"
+}
+
+default_hw_stats_test()
+{
+	hw_stats_test "default" "" 2 1
+}
+
+immediate_hw_stats_test()
+{
+	hw_stats_test "immediate" "hw_stats immediate" 2 1
+}
+
+delayed_hw_stats_test()
+{
+	RET=0
+
+	tc filter add dev $swp1 ingress protocol ip pref 1 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 action drop hw_stats delayed
+	check_fail $? "Unexpected success in adding rule with delayed hw_stats"
+
+	log_test "delayed hw_stats"
+}
+
+disabled_hw_stats_test()
+{
+	hw_stats_test "disabled" "hw_stats disabled" 0 0
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	h1mac=$(mac_get $h1)
+	swp1mac=$(mac_get $swp1)
+
+	vrf_prepare
+
+	h1_create
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+check_tc_action_hw_stats_support
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index a4a7879b3bb9..977fc2b326a2 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -60,6 +60,15 @@ check_tc_chain_support()
 	fi
 }
 
+check_tc_action_hw_stats_support()
+{
+	tc actions help 2>&1 | grep -q hw_stats
+	if [[ $? -ne 0 ]]; then
+		echo "SKIP: iproute2 too old; tc is missing action hw_stats support"
+		exit 1
+	fi
+}
+
 if [[ "$(id -u)" -ne 0 ]]; then
 	echo "SKIP: need root privileges"
 	exit 0
-- 
2.24.1

