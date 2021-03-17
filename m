Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0B533EE73
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 11:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhCQKjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 06:39:45 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53335 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230038AbhCQKja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 06:39:30 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 308195C0143;
        Wed, 17 Mar 2021 06:39:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 17 Mar 2021 06:39:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=QR8KtlOrtM6P5NctYTB2IrFKuH77HekdUzWwBFznR/A=; b=oQIR3MdN
        zf5T0Z/946py4XTTuEIu2uKRYEVk4n3nRqYDdvhLo/ISfhCEdCfXuSHBQit+NOtA
        zbGbJVgpqunjBIKux/RdwjFKdROFP+oP1ebsboi+TVUBYI9DPuZShHe3/pnmImEf
        M9kxXfx/ZhkEeiQNUphm+VzFMAmkkKT6LttMdWKXCPTJg5gtK1OgzqBxAX8wbYtg
        xVSbRE6vStxjJ0BfWJO3qs5VMaDMHpPTXMNe01TV0jDV1tvZcCh2Dfmhu/Nzimp1
        z60fbF1Y6YpB0R6u1vAsDHYlNE/Hx43ULXuvb/bUZSIiQ9UrSvWEO+Uq6Bl8VlzX
        6b1ruvQU2A7ILg==
X-ME-Sender: <xms:YtxRYEAhGgcIKt8OjTz-SWdzrrdBUGQGf4qhboqvGVx-hXxpVq3vwg>
    <xme:YtxRYGjE9e7fFKeIu-t-jrLC3QDx74z4x9XpkgowJdMPiJSmbSanYhnJ30vPPcdSQ
    4zqG9xUI0E4-Oc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefgedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:YtxRYHloWsRtO-LGP4jYFBnB8ru35hLXnOZp6_Cz0TV3hTcsYp9GLw>
    <xmx:YtxRYKydylZURTxKadFyOeuRqdugyFZMF8B8AKLW5WPET-1uzCzDrw>
    <xmx:YtxRYJRuwbznCWdQzV3xNagGodJuKrj-XFtR5MrOUYanqjujlvHF8A>
    <xmx:YtxRYHO-qjS9hNgrYlINgjI0vTG-C9JOLdKHGTrODCSJDZnE3m49qA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D48C1080057;
        Wed, 17 Mar 2021 06:39:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/7] selftests: mlxsw: spectrum-2: Remove q_in_vni_veto test
Date:   Wed, 17 Mar 2021 12:35:29 +0200
Message-Id: <20210317103529.2903172-8-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210317103529.2903172-1-idosch@idosch.org>
References: <20210317103529.2903172-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

q_in_vni_veto.sh is not needed anymore because VxLAN with an 802.1ad
bridge and VxLAN with an 802.1d bridge can coexist.

Remove the test.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/mlxsw/spectrum-2/q_in_vni_veto.sh     | 77 -------------------
 1 file changed, 77 deletions(-)
 delete mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh
deleted file mode 100755
index 0231205a7147..000000000000
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh
+++ /dev/null
@@ -1,77 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-lib_dir=$(dirname $0)/../../../../net/forwarding
-
-VXPORT=4789
-
-ALL_TESTS="
-	create_dot1d_and_dot1ad_vxlans
-"
-NUM_NETIFS=2
-source $lib_dir/lib.sh
-
-setup_prepare()
-{
-	swp1=${NETIFS[p1]}
-	swp2=${NETIFS[p2]}
-
-	ip link set dev $swp1 up
-	ip link set dev $swp2 up
-}
-
-cleanup()
-{
-	pre_cleanup
-
-	ip link set dev $swp2 down
-	ip link set dev $swp1 down
-}
-
-create_dot1d_and_dot1ad_vxlans()
-{
-	RET=0
-
-	ip link add dev br0 type bridge vlan_filtering 1 vlan_protocol 802.1ad \
-		vlan_default_pvid 0 mcast_snooping 0
-	ip link set dev br0 up
-
-	ip link add name vx100 type vxlan id 1000 local 192.0.2.17 dstport \
-		"$VXPORT" nolearning noudpcsum tos inherit ttl 100
-	ip link set dev vx100 up
-
-	ip link set dev $swp1 master br0
-	ip link set dev vx100 master br0
-	bridge vlan add vid 100 dev vx100 pvid untagged
-
-	ip link add dev br1 type bridge vlan_filtering 0 mcast_snooping 0
-	ip link set dev br1 up
-
-	ip link add name vx200 type vxlan id 2000 local 192.0.2.17 dstport \
-		"$VXPORT" nolearning noudpcsum tos inherit ttl 100
-	ip link set dev vx200 up
-
-	ip link set dev $swp2 master br1
-	ip link set dev vx200 master br1 2>/dev/null
-	check_fail $? "802.1d and 802.1ad VxLANs at the same time not rejected"
-
-	ip link set dev vx200 master br1 2>&1 >/dev/null \
-		| grep -q mlxsw_spectrum
-	check_err $? "802.1d and 802.1ad VxLANs at the same time rejected without extack"
-
-	log_test "create 802.1d and 802.1ad VxLANs"
-
-	ip link del dev vx200
-	ip link del dev br1
-	ip link del dev vx100
-	ip link del dev br0
-}
-
-trap cleanup EXIT
-
-setup_prepare
-setup_wait
-
-tests_run
-
-exit $EXIT_STATUS
-- 
2.29.2

