Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5482443AF4C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbhJZJpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:45:45 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41017 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234937AbhJZJpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:45:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7DDF45C02B6;
        Tue, 26 Oct 2021 05:43:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 26 Oct 2021 05:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=VZ7nnrjZsGX4TDCFGigQwQ27KMa9CxfG1JQU6weG9Ng=; b=ePYN5vAb
        oDiF0C/k8NQgL8SMBlGqkHcujoalCyAQK1MVTXSOXckrWsHtO5vycz1IIBW9O2eD
        vdiXq8JVioyfNdJaDGwomZbbR0NTVXvFcMJOeaMcMM1NbUCHkAgcrr2PBYo70mSE
        ve/kexysAk5k60axc52uqdUCVfQzOsPj8EuuyPpwTWWmqbGEHDMEEdQjdvtY3lx9
        yfEKliAspMURQb+9UnguMigzhblbf8m3zScwBh08r2et40zT9X8zMDsGEGhesfAl
        v8HdLIzbKup6sNsNmyg5EFry9x/9tmaFBjyBw/4SOw2ephdojvGzYCrRTL2ggpdo
        j8VeovPQt3f2QA==
X-ME-Sender: <xms:ts13YTPH-ARU_T5aYr42DMXfSMHVphqVFZuaLKdn1M4q2breFNiTgA>
    <xme:ts13Yd--3sWMNizS1vALOiLFI36GCw1rN4oVNQsfP2DFPKVozLTLieWZka8jPLs_p
    PrF_vrKAFZXbUA>
X-ME-Received: <xmr:ts13YST3R64-i8LCfPWQ8FyTAKptWznPNqFfXO7XkPCdmeWIYobTcL3pjhrvKL5t-CjAXNFsI-GtNHKb9PsDQFu3OhgLYr56iR2UuAuCXHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefjedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepvdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ts13YXv-wS4d0slK3qTT1v7sYgRw1SVg35tTEB49qyN3bZ0jCqFIPQ>
    <xmx:ts13Ybeg47K2eRVhI1meD2gCDzHEkklcIkczSZVR-94_bpDdT7A1bA>
    <xmx:ts13YT106gg5dQ0KclQ99V7E5tb8Ws_mXBtnjotlkGgY34vKyhn32Q>
    <xmx:ts13YcEWZR7jSokIlDPPHVFysMiOCKNoSf87lmjfwbcVq32oOb6ZPg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Oct 2021 05:43:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 9/9] selftests: mlxsw: Remove deprecated test cases
Date:   Tue, 26 Oct 2021 12:42:25 +0300
Message-Id: <20211026094225.1265320-10-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211026094225.1265320-1-idosch@idosch.org>
References: <20211026094225.1265320-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

After adding the previous patches, the constraint that all the router
interface MAC addresses have the same prefix is no longer relevant.

Remove the test cases that validated that this constraint is honored.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  | 90 -------------------
 1 file changed, 90 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
index 1075d70e8f25..04f03ae9d8fb 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
@@ -10,9 +10,7 @@
 lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="
-	rif_set_addr_test
 	rif_vrf_set_addr_test
-	rif_inherit_bridge_addr_test
 	rif_non_inherit_bridge_addr_test
 	vlan_interface_deletion_test
 	bridge_deletion_test
@@ -60,55 +58,6 @@ cleanup()
 	ip link set dev $swp1 down
 }
 
-rif_set_addr_test()
-{
-	local swp1_mac=$(mac_get $swp1)
-	local swp2_mac=$(mac_get $swp2)
-
-	RET=0
-
-	# $swp1 and $swp2 likely got their IPv6 local addresses already, but
-	# here we need to test the transition to RIF.
-	ip addr flush dev $swp1
-	ip addr flush dev $swp2
-	sleep .1
-
-	ip addr add dev $swp1 192.0.2.1/28
-	check_err $?
-
-	ip link set dev $swp1 addr 00:11:22:33:44:55
-	check_err $?
-
-	# IP address enablement should be rejected if the MAC address prefix
-	# doesn't match other RIFs.
-	ip addr add dev $swp2 192.0.2.2/28 &>/dev/null
-	check_fail $? "IP address addition passed for a device with a wrong MAC"
-	ip addr add dev $swp2 192.0.2.2/28 2>&1 >/dev/null \
-	    | grep -q mlxsw_spectrum
-	check_err $? "no extack for IP address addition"
-
-	ip link set dev $swp2 addr 00:11:22:33:44:66
-	check_err $?
-	ip addr add dev $swp2 192.0.2.2/28 &>/dev/null
-	check_err $?
-
-	# Change of MAC address of a RIF should be forbidden if the new MAC
-	# doesn't share the prefix with other MAC addresses.
-	ip link set dev $swp2 addr 00:11:22:33:00:66 &>/dev/null
-	check_fail $? "change of MAC address passed for a wrong MAC"
-	ip link set dev $swp2 addr 00:11:22:33:00:66 2>&1 >/dev/null \
-	    | grep -q mlxsw_spectrum
-	check_err $? "no extack for MAC address change"
-
-	log_test "RIF - bad MAC change"
-
-	ip addr del dev $swp2 192.0.2.2/28
-	ip addr del dev $swp1 192.0.2.1/28
-
-	ip link set dev $swp2 addr $swp2_mac
-	ip link set dev $swp1 addr $swp1_mac
-}
-
 rif_vrf_set_addr_test()
 {
 	# Test that it is possible to set an IP address on a VRF upper despite
@@ -128,45 +77,6 @@ rif_vrf_set_addr_test()
 	ip link del dev vrf-test
 }
 
-rif_inherit_bridge_addr_test()
-{
-	RET=0
-
-	# Create first RIF
-	ip addr add dev $swp1 192.0.2.1/28
-	check_err $?
-
-	# Create a FID RIF
-	ip link add name br1 up type bridge vlan_filtering 0
-	ip link set dev $swp2 master br1
-	ip addr add dev br1 192.0.2.17/28
-	check_err $?
-
-	# Prepare a device with a low MAC address
-	ip link add name d up type dummy
-	ip link set dev d addr 00:11:22:33:44:55
-
-	# Attach the device to br1. That prompts bridge address change, which
-	# should be vetoed, thus preventing the attachment.
-	ip link set dev d master br1 &>/dev/null
-	check_fail $? "Device with low MAC was permitted to attach a bridge with RIF"
-	ip link set dev d master br1 2>&1 >/dev/null \
-	    | grep -q mlxsw_spectrum
-	check_err $? "no extack for bridge attach rejection"
-
-	ip link set dev $swp2 addr 00:11:22:33:44:55 &>/dev/null
-	check_fail $? "Changing swp2's MAC address permitted"
-	ip link set dev $swp2 addr 00:11:22:33:44:55 2>&1 >/dev/null \
-	    | grep -q mlxsw_spectrum
-	check_err $? "no extack for bridge port MAC address change rejection"
-
-	log_test "RIF - attach port with bad MAC to bridge"
-
-	ip link del dev d
-	ip link del dev br1
-	ip addr del dev $swp1 192.0.2.1/28
-}
-
 rif_non_inherit_bridge_addr_test()
 {
 	local swp2_mac=$(mac_get $swp2)
-- 
2.31.1

