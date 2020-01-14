Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14BEF13A859
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 12:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgANLYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 06:24:05 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49789 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729652AbgANLYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 06:24:01 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B71542247C;
        Tue, 14 Jan 2020 06:24:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Jan 2020 06:24:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=RH3GcOKScMopXdOIeQ3naMkD99aPgZXK3xQKTzjCnxU=; b=qt365eOg
        rY0IpDXi/al2+vBd3h3XYVHUljkScQ0V/vZCFOtS6VWVJtSUv0tzBGIMM3uvcu5p
        jAYACfkuCILqdXZSCP6Y61T3JjBEDAuyRzyXu8CxmlEQxeZCEbl60Qnpx24xSLGY
        QDSyBi5QRSkvuAUXtROosU0EH2MiHLbPG9ZQd6bJwCRReHzejHjbBMDA2tSvoCcz
        VWyyksyOnDxePuFzoQUF46VcYY+8ASYTkbTv0UiPJd069eLX4FNTl/I+txqhWZk/
        WZ7yuu221Fakbi02zdl18Ap8ax6tsqgZsNCmmm57V8ZRmKt6jkvG7PSlatT1lb3p
        6s4XgaIv+bIrGA==
X-ME-Sender: <xms:0KQdXiyz1vtE3yKVyoUKRvsXbJ6duh2wUQi3QrYDoxFb8ZA4vHi6SQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtddtgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepje
X-ME-Proxy: <xmx:0KQdXo7EhdTdCsOeb71CUBedaZvlexahA6DFL8CdnoIkvCB3_j_xzA>
    <xmx:0KQdXgXRxundbatVHqDgEq-6_cu3KDbpbE4i_p-u4VeNu53saQYBGA>
    <xmx:0KQdXoxKyALmgYQQuO_-OA2H4iMA0Xn-oJpX8bDn2P_ge0CCZKDfIA>
    <xmx:0KQdXgJloBpzT7ChffC32uVwQgu4uxcYIZeVnH-jhqNJZJaIYqCq_w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3B9B380064;
        Tue, 14 Jan 2020 06:23:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 10/10] selftests: mlxsw: Add test for FIB offload API
Date:   Tue, 14 Jan 2020 13:23:18 +0200
Message-Id: <20200114112318.876378-11-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114112318.876378-1-idosch@idosch.org>
References: <20200114112318.876378-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The test reuses the common FIB offload tests in order to make sure that
mlxsw correctly implements FIB offload.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/fib.sh        | 180 ++++++++++++++++++
 1 file changed, 180 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/fib.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/fib.sh b/tools/testing/selftests/drivers/net/mlxsw/fib.sh
new file mode 100755
index 000000000000..45115f81c2b1
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/fib.sh
@@ -0,0 +1,180 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# This test is for checking the FIB offload API on top of mlxsw.
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	ipv4_identical_routes
+	ipv4_tos
+	ipv4_metric
+	ipv4_replace
+	ipv4_delete
+	ipv4_plen
+	ipv4_replay
+	ipv4_flush
+	ipv6_add
+	ipv6_metric
+	ipv6_append_single
+	ipv6_replace_single
+	ipv6_metric_multipath
+	ipv6_append_multipath
+	ipv6_replace_multipath
+	ipv6_append_multipath_to_single
+	ipv6_delete_single
+	ipv6_delete_multipath
+	ipv6_replay_single
+	ipv6_replay_multipath
+"
+NUM_NETIFS=0
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+source $lib_dir/fib_offload_lib.sh
+
+ipv4_identical_routes()
+{
+	fib_ipv4_identical_routes_test "testns1"
+}
+
+ipv4_tos()
+{
+	fib_ipv4_tos_test "testns1"
+}
+
+ipv4_metric()
+{
+	fib_ipv4_metric_test "testns1"
+}
+
+ipv4_replace()
+{
+	fib_ipv4_replace_test "testns1"
+}
+
+ipv4_delete()
+{
+	fib_ipv4_delete_test "testns1"
+}
+
+ipv4_plen()
+{
+	fib_ipv4_plen_test "testns1"
+}
+
+ipv4_replay_metric()
+{
+	fib_ipv4_replay_metric_test "testns1" "$DEVLINK_DEV"
+}
+
+ipv4_replay_tos()
+{
+	fib_ipv4_replay_tos_test "testns1" "$DEVLINK_DEV"
+}
+
+ipv4_replay_plen()
+{
+	fib_ipv4_replay_plen_test "testns1" "$DEVLINK_DEV"
+}
+
+ipv4_replay()
+{
+	ipv4_replay_metric
+	ipv4_replay_tos
+	ipv4_replay_plen
+}
+
+ipv4_flush()
+{
+	fib_ipv4_flush_test "testns1"
+}
+
+ipv6_add()
+{
+	fib_ipv6_add_test "testns1"
+}
+
+ipv6_metric()
+{
+	fib_ipv6_metric_test "testns1"
+}
+
+ipv6_append_single()
+{
+	fib_ipv6_append_single_test "testns1"
+}
+
+ipv6_replace_single()
+{
+	fib_ipv6_replace_single_test "testns1"
+}
+
+ipv6_metric_multipath()
+{
+	fib_ipv6_metric_multipath_test "testns1"
+}
+
+ipv6_append_multipath()
+{
+	fib_ipv6_append_multipath_test "testns1"
+}
+
+ipv6_replace_multipath()
+{
+	fib_ipv6_replace_multipath_test "testns1"
+}
+
+ipv6_append_multipath_to_single()
+{
+	fib_ipv6_append_multipath_to_single_test "testns1"
+}
+
+ipv6_delete_single()
+{
+	fib_ipv6_delete_single_test "testns1"
+}
+
+ipv6_delete_multipath()
+{
+	fib_ipv6_delete_multipath_test "testns1"
+}
+
+ipv6_replay_single()
+{
+	fib_ipv6_replay_single_test "testns1" "$DEVLINK_DEV"
+}
+
+ipv6_replay_multipath()
+{
+	fib_ipv6_replay_multipath_test "testns1" "$DEVLINK_DEV"
+}
+
+setup_prepare()
+{
+	ip netns add testns1
+	if [ $? -ne 0 ]; then
+		echo "Failed to add netns \"testns1\""
+		exit 1
+	fi
+
+	devlink dev reload $DEVLINK_DEV netns testns1
+	if [ $? -ne 0 ]; then
+		echo "Failed to reload into netns \"testns1\""
+		exit 1
+	fi
+}
+
+cleanup()
+{
+	pre_cleanup
+	devlink -N testns1 dev reload $DEVLINK_DEV netns $$
+	ip netns del testns1
+}
+
+trap cleanup EXIT
+
+setup_prepare
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.24.1

