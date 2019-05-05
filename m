Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 606B913DFE
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 08:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfEEGsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 02:48:42 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44187 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727427AbfEEGsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 02:48:40 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 92B1C21AD0;
        Sun,  5 May 2019 02:48:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 05 May 2019 02:48:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=k+rjVpSkLJS4XibHJvbhoPF0XuYzZMELFb5AH8ehtYs=; b=4cGqrSgi
        7ZMtBI35aTolcU48cv59UbWzyvtIO8ojmq9zfynUje/9LwcL1KsOA5bKUlldY9cB
        NvByK4Vf7w2vTlgxsvZ2Q1FNfN1Fwm4ht3Mu2f5d1Keu0sdKVHOmNBXcBT121IxS
        qChMMyrz6ziiZuHCWfAQubUEBM8zVBfui0hOaNZlCKDE/Y0blX52c7pFmhIBmOif
        Sh/brbnGijMJCnmWe4qgNcnQA+5lafUKpSRx2zuGI2vslqt8/z4cT78ZAnQ5j9+f
        mBnMdvlpIVWpyzgVx2wZ62JaldD3REHBhOqrJwjuQsSOHKe9zFbbOIt5jQequ11g
        JWF9qgHCPpi9Fg==
X-ME-Sender: <xms:R4fOXHQO0f-3BtCxBHbx8RjAFcQ8oEuj8nGhtHrOA0c7WRbg5w8xKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrjeeggdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:R4fOXO5JJDYX3cP72xrekC7L9o0kEDDuk7RTTSeSglZLFqrj74fW9Q>
    <xmx:R4fOXPieoi0PNqytmQftk111T_5Fv56P-Wv77NLfQiJM8mgqHNOoGg>
    <xmx:R4fOXE2OC3b4LJvDsBptI9rPL0LAK0nblqFPzv7Ei7aCShz_39xi_g>
    <xmx:R4fOXAbL-ujOyyKk3P8_ylIbMSXx5evzMxLBYw1DD09G2cHwlYaYLQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4C296E4122;
        Sun,  5 May 2019 02:48:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/3] selftests: Add loopback test
Date:   Sun,  5 May 2019 09:48:07 +0300
Message-Id: <20190505064807.27925-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190505064807.27925-1-idosch@idosch.org>
References: <20190505064807.27925-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add selftest for loopback feature

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/loopback.sh      | 94 +++++++++++++++++++
 1 file changed, 94 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/loopback.sh

diff --git a/tools/testing/selftests/net/forwarding/loopback.sh b/tools/testing/selftests/net/forwarding/loopback.sh
new file mode 100755
index 000000000000..6e4626ae71b0
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/loopback.sh
@@ -0,0 +1,94 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="loopback_test"
+NUM_NETIFS=2
+source tc_common.sh
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/24
+	tc qdisc add dev $h1 clsact
+}
+
+h1_destroy()
+{
+	tc qdisc del dev $h1 clsact
+	simple_if_fini $h1 192.0.2.1/24
+}
+
+h2_create()
+{
+	simple_if_init $h2
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2
+}
+
+loopback_test()
+{
+	RET=0
+
+	tc filter add dev $h1 ingress protocol arp pref 1 handle 101 flower \
+		skip_hw arp_op reply arp_tip 192.0.2.1 action drop
+
+	$MZ $h1 -c 1 -t arp -q
+
+	tc_check_packets "dev $h1 ingress" 101 1
+	check_fail $? "Matched on a filter without loopback setup"
+
+	ethtool -K $h1 loopback on
+	check_err $? "Failed to enable loopback"
+
+	setup_wait_dev $h1
+
+	$MZ $h1 -c 1 -t arp -q
+
+	tc_check_packets "dev $h1 ingress" 101 1
+	check_err $? "Did not match on filter with loopback"
+
+	ethtool -K $h1 loopback off
+	check_err $? "Failed to disable loopback"
+
+	$MZ $h1 -c 1 -t arp -q
+
+	tc_check_packets "dev $h1 ingress" 101 2
+	check_fail $? "Matched on a filter after loopback was removed"
+
+	tc filter del dev $h1 ingress protocol arp pref 1 handle 101 flower
+
+	log_test "loopback"
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	h2=${NETIFS[p2]}
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.20.1

