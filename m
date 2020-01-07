Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C4A132A58
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgAGPqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:46:08 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45503 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728410AbgAGPqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:46:04 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C94C222233;
        Tue,  7 Jan 2020 10:46:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 07 Jan 2020 10:46:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=RH3GcOKScMopXdOIeQ3naMkD99aPgZXK3xQKTzjCnxU=; b=eayXArrC
        SgL0aoSmMZEOmDBpWyJIUv9FetUgsQr/+wRoAzmwez0aFy6i7ep9vsFVDKqNnTtf
        EvptmLULLNKUXy/uDNPy7TrSiCBBr7tb88vk+vBcqbhXkNw2Ry6XKZt9OBwqtzNi
        UYWwip7hsyrmU0QsTbcKQmmOj3RJjmPr2388UKqcOmNR7kGaaeH5XJ+eG3u96Gro
        okfiZtBajk5tnD4amM7KeuZtr5JnQuVtm+j4EmTtpO8DzHi9nRzxBWmOSGxF69RI
        7yj/orxStmhzj84TFIBqeZuDgAg/JALMqEGOOaDLzLV5g5To/s67fYFVFoT6OSbg
        H/J9THfSsg9y7A==
X-ME-Sender: <xms:u6cUXvJkXioEVcFCnk5UQsX5ppCIKZOaAGjanPsqmc5WRBlkkumcWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehgedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeek
X-ME-Proxy: <xmx:u6cUXuDOX_CbAcrLeKM54h8DH-XEyKaSF1AbLFkMQJks9r7P1_cJvQ>
    <xmx:u6cUXoo1MNHRGC51fbRQVZnePt3mOkuVNGTtVN9XW2PWi-zYFC8Lhw>
    <xmx:u6cUXvYlr2MYKFC7nUmVPCuKfG5b6t8VlKFpujo7a1FuoGNGeXJzjg>
    <xmx:u6cUXu9wKa2hQS8XmDzPZEiM5Fi-T-w1EB_mI5V3FVWs69RdSKJ_fw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4321F8005B;
        Tue,  7 Jan 2020 10:46:02 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/10] selftests: mlxsw: Add test for FIB offload API
Date:   Tue,  7 Jan 2020 17:45:17 +0200
Message-Id: <20200107154517.239665-11-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107154517.239665-1-idosch@idosch.org>
References: <20200107154517.239665-1-idosch@idosch.org>
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

