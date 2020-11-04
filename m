Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718AE2A6542
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbgKDNcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:32:16 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54717 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730158AbgKDNcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:32:08 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BF6425C008B;
        Wed,  4 Nov 2020 08:32:06 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:32:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zFw9i0A0C0MAPSegl6ifG8rAdWHA4mn5iBaJ1JC1Edw=; b=Fm8VnuT3
        FBCZ33L8FrAfSmRK8tDDGc6GudNsSZmI8Ro389cMtwNYIuteTjhbg9u2HStZinrf
        YuxzOVPak2uhajrZ8nuFov84ZLqj2heDi5pTFbAgL1/u/YgiVR3+UQE2+MpWrBGU
        cBBqpj3uzeVAkuJREke1GhNGpF55s7zNl1Z7bwHL8f1liovrKFgq2UMQMk+nvx9A
        V8KMmyTH8hzYrjUiDEfybrkjAHIq8m4ZtaOTN52vitsmWXVdbNnAVM6NJjufaEJ7
        /yeWbiizwj/t5e7Woe0OdoT09sHZKGjQ2JtGwbmOj9GeQBfAZm9HZL6PR4TUoGaO
        8DHJIn+YKYCnNA==
X-ME-Sender: <xms:Vq2iXxpNc9C1_hIljj8OdVz9oI4yU1iYueInQ4kTcFiVt_1soYFJRQ>
    <xme:Vq2iXzpMS0Bpu5Z8-dXgjgM9IQWfELI3IX4F-bKoff10t0SEVGUPtvUHo1rglKuMg
    p5A19jscmBMPCs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedugeenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Vq2iX-PoY48am1ESqXOtQcFj_TxIpFOoOFcWAcrPHC8bR8VXzVaOPw>
    <xmx:Vq2iX86G7aA-jCw3-8lYCpwkKzNuZBz29PN0ZiRHW9EpNiekSe0GoQ>
    <xmx:Vq2iXw4-axJEnJUQPhFXM0P4pG3yrPvoW-o9ZELHsIzxSqODgYgcnA>
    <xmx:Vq2iX-lCbc8ZCSxSr3ZfJCnSagmtkUYQJAko96Z1XSneHXD9H63bJg>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B31C3064610;
        Wed,  4 Nov 2020 08:32:05 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 18/18] selftests: netdevsim: Add test for nexthop offload API
Date:   Wed,  4 Nov 2020 15:30:40 +0200
Message-Id: <20201104133040.1125369-19-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test various aspects of the nexthop offload API on top of the netdevsim
implementation. Both good and bad flows are tested.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/netdevsim/nexthop.sh          | 436 ++++++++++++++++++
 1 file changed, 436 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/nexthop.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/nexthop.sh b/tools/testing/selftests/drivers/net/netdevsim/nexthop.sh
new file mode 100755
index 000000000000..be0c1b5ee6b8
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/nexthop.sh
@@ -0,0 +1,436 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# This test is for checking the nexthop offload API. It makes use of netdevsim
+# which registers a listener to the nexthop notification chain.
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	nexthop_single_add_test
+	nexthop_single_add_err_test
+	nexthop_group_add_test
+	nexthop_group_add_err_test
+	nexthop_group_replace_test
+	nexthop_group_replace_err_test
+	nexthop_single_replace_test
+	nexthop_single_replace_err_test
+	nexthop_single_in_group_replace_test
+	nexthop_single_in_group_replace_err_test
+	nexthop_single_in_group_delete_test
+	nexthop_single_in_group_delete_err_test
+	nexthop_replay_test
+	nexthop_replay_err_test
+"
+NETDEVSIM_PATH=/sys/bus/netdevsim/
+DEV_ADDR=1337
+DEV=netdevsim${DEV_ADDR}
+DEVLINK_DEV=netdevsim/${DEV}
+SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV/net/
+NUM_NETIFS=0
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+
+nexthop_check()
+{
+	local nharg="$1"; shift
+	local expected="$1"; shift
+
+	out=$($IP nexthop show ${nharg} | sed -e 's/ *$//')
+	if [[ "$out" != "$expected" ]]; then
+		return 1
+	fi
+
+	return 0
+}
+
+nexthop_resource_check()
+{
+	local expected_occ=$1; shift
+
+	occ=$($DEVLINK -jp resource show $DEVLINK_DEV \
+		| jq '.[][][] | select(.name=="nexthops") | .["occ"]')
+
+	if [ $expected_occ -ne $occ ]; then
+		return 1
+	fi
+
+	return 0
+}
+
+nexthop_resource_set()
+{
+	local size=$1; shift
+
+	$DEVLINK resource set $DEVLINK_DEV path nexthops size $size
+	$DEVLINK dev reload $DEVLINK_DEV
+}
+
+nexthop_single_add_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	nexthop_check "id 1" "id 1 via 192.0.2.2 dev dummy1 scope link trap"
+	check_err $? "Unexpected nexthop entry"
+
+	nexthop_resource_check 1
+	check_err $? "Wrong nexthop occupancy"
+
+	$IP nexthop del id 1
+	nexthop_resource_check 0
+	check_err $? "Wrong nexthop occupancy after delete"
+
+	log_test "Single nexthop add and delete"
+}
+
+nexthop_single_add_err_test()
+{
+	RET=0
+
+	nexthop_resource_set 1
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1 &> /dev/null
+	check_fail $? "Nexthop addition succeeded when should fail"
+
+	nexthop_resource_check 1
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Single nexthop add failure"
+
+	$IP nexthop flush &> /dev/null
+	nexthop_resource_set 9999
+}
+
+nexthop_group_add_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+
+	$IP nexthop add id 10 group 1/2
+	nexthop_check "id 10" "id 10 group 1/2 trap"
+	check_err $? "Unexpected nexthop group entry"
+
+	nexthop_resource_check 4
+	check_err $? "Wrong nexthop occupancy"
+
+	$IP nexthop del id 10
+	nexthop_resource_check 2
+	check_err $? "Wrong nexthop occupancy after delete"
+
+	$IP nexthop add id 10 group 1,20/2,39
+	nexthop_check "id 10" "id 10 group 1,20/2,39 trap"
+	check_err $? "Unexpected weighted nexthop group entry"
+
+	nexthop_resource_check 61
+	check_err $? "Wrong weighted nexthop occupancy"
+
+	$IP nexthop del id 10
+	nexthop_resource_check 2
+	check_err $? "Wrong nexthop occupancy after delete"
+
+	log_test "Nexthop group add and delete"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_group_add_err_test()
+{
+	RET=0
+
+	nexthop_resource_set 2
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+
+	$IP nexthop add id 10 group 1/2 &> /dev/null
+	check_fail $? "Nexthop group addition succeeded when should fail"
+
+	nexthop_resource_check 2
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Nexthop group add failure"
+
+	$IP nexthop flush &> /dev/null
+	nexthop_resource_set 9999
+}
+
+nexthop_group_replace_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 3 via 192.0.2.4 dev dummy1
+	$IP nexthop add id 10 group 1/2
+
+	$IP nexthop replace id 10 group 1/2/3
+	nexthop_check "id 10" "id 10 group 1/2/3 trap"
+	check_err $? "Unexpected nexthop group entry"
+
+	nexthop_resource_check 6
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Nexthop group replace"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_group_replace_err_test()
+{
+	RET=0
+
+	nexthop_resource_set 5
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 3 via 192.0.2.4 dev dummy1
+	$IP nexthop add id 10 group 1/2
+
+	$IP nexthop replace id 10 group 1/2/3 &> /dev/null
+	check_fail $? "Nexthop group replacement succeeded when should fail"
+
+	nexthop_check "id 10" "id 10 group 1/2 trap"
+	check_err $? "Unexpected nexthop group entry after failure"
+
+	nexthop_resource_check 5
+	check_err $? "Wrong nexthop occupancy after failure"
+
+	log_test "Nexthop group replace failure"
+
+	$IP nexthop flush &> /dev/null
+	nexthop_resource_set 9999
+}
+
+nexthop_single_replace_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+
+	$IP nexthop replace id 1 via 192.0.2.3 dev dummy1
+	nexthop_check "id 1" "id 1 via 192.0.2.3 dev dummy1 scope link trap"
+	check_err $? "Unexpected nexthop entry"
+
+	nexthop_resource_check 1
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Single nexthop replace"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_single_replace_err_test()
+{
+	RET=0
+
+	# This is supposed to cause the replace to fail because the new nexthop
+	# is programmed before deleting the replaced one.
+	nexthop_resource_set 1
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+
+	$IP nexthop replace id 1 via 192.0.2.3 dev dummy1 &> /dev/null
+	check_fail $? "Nexthop replace succeeded when should fail"
+
+	nexthop_check "id 1" "id 1 via 192.0.2.2 dev dummy1 scope link trap"
+	check_err $? "Unexpected nexthop entry after failure"
+
+	nexthop_resource_check 1
+	check_err $? "Wrong nexthop occupancy after failure"
+
+	log_test "Single nexthop replace failure"
+
+	$IP nexthop flush &> /dev/null
+	nexthop_resource_set 9999
+}
+
+nexthop_single_in_group_replace_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 10 group 1/2
+
+	$IP nexthop replace id 1 via 192.0.2.4 dev dummy1
+	check_err $? "Failed to replace nexthop when should not"
+
+	nexthop_check "id 10" "id 10 group 1/2 trap"
+	check_err $? "Unexpected nexthop group entry"
+
+	nexthop_resource_check 4
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Single nexthop replace while in group"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_single_in_group_replace_err_test()
+{
+	RET=0
+
+	nexthop_resource_set 5
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 10 group 1/2
+
+	$IP nexthop replace id 1 via 192.0.2.4 dev dummy1 &> /dev/null
+	check_fail $? "Nexthop replacement succeeded when should fail"
+
+	nexthop_check "id 1" "id 1 via 192.0.2.2 dev dummy1 scope link trap"
+	check_err $? "Unexpected nexthop entry after failure"
+
+	nexthop_check "id 10" "id 10 group 1/2 trap"
+	check_err $? "Unexpected nexthop group entry after failure"
+
+	nexthop_resource_check 4
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Single nexthop replace while in group failure"
+
+	$IP nexthop flush &> /dev/null
+	nexthop_resource_set 9999
+}
+
+nexthop_single_in_group_delete_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 10 group 1/2
+
+	$IP nexthop del id 1
+	nexthop_check "id 10" "id 10 group 2 trap"
+	check_err $? "Unexpected nexthop group entry"
+
+	nexthop_resource_check 2
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Single nexthop delete while in group"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_single_in_group_delete_err_test()
+{
+	RET=0
+
+	# First, nexthop 1 will be deleted, which will reduce the occupancy to
+	# 5. Afterwards, a replace notification will be sent for nexthop group
+	# 10 with only two nexthops. Since the new group is allocated before
+	# the old is deleted, the replacement will fail as it will result in an
+	# occupancy of 7.
+	nexthop_resource_set 6
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 3 via 192.0.2.4 dev dummy1
+	$IP nexthop add id 10 group 1/2/3
+
+	$IP nexthop del id 1
+
+	nexthop_resource_check 5
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Single nexthop delete while in group failure"
+
+	$IP nexthop flush &> /dev/null
+	nexthop_resource_set 9999
+}
+
+nexthop_replay_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 10 group 1/2
+
+	$DEVLINK dev reload $DEVLINK_DEV
+	check_err $? "Failed to reload when should not"
+
+	nexthop_check "id 1" "id 1 via 192.0.2.2 dev dummy1 scope link trap"
+	check_err $? "Unexpected nexthop entry after reload"
+
+	nexthop_check "id 2" "id 2 via 192.0.2.3 dev dummy1 scope link trap"
+	check_err $? "Unexpected nexthop entry after reload"
+
+	nexthop_check "id 10" "id 10 group 1/2 trap"
+	check_err $? "Unexpected nexthop group entry after reload"
+
+	nexthop_resource_check 4
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Nexthop replay"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_replay_err_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 10 group 1/2
+
+	# Reduce size of nexthop resource so that reload will fail.
+	$DEVLINK resource set $DEVLINK_DEV path nexthops size 3
+	$DEVLINK dev reload $DEVLINK_DEV &> /dev/null
+	check_fail $? "Reload succeeded when should fail"
+
+	$DEVLINK resource set $DEVLINK_DEV path nexthops size 9999
+	$DEVLINK dev reload $DEVLINK_DEV
+	check_err $? "Failed to reload when should not"
+
+	log_test "Nexthop replay failure"
+
+	$IP nexthop flush &> /dev/null
+}
+
+setup_prepare()
+{
+	local netdev
+
+	modprobe netdevsim &> /dev/null
+
+	echo "$DEV_ADDR 1" > ${NETDEVSIM_PATH}/new_device
+	while [ ! -d $SYSFS_NET_DIR ] ; do :; done
+
+	set -e
+
+	ip netns add testns1
+	devlink dev reload $DEVLINK_DEV netns testns1
+
+	IP="ip -netns testns1"
+	DEVLINK="devlink -N testns1"
+
+	$IP link add name dummy1 up type dummy
+	$IP address add 192.0.2.1/24 dev dummy1
+
+	set +e
+}
+
+cleanup()
+{
+	pre_cleanup
+	ip netns del testns1
+	echo "$DEV_ADDR" > ${NETDEVSIM_PATH}/del_device
+	modprobe -r netdevsim &> /dev/null
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
2.26.2

