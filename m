Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46DE1D6491
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 00:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgEPWnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 18:43:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59971 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726895AbgEPWnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 18:43:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 887CE5C0079;
        Sat, 16 May 2020 18:43:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 16 May 2020 18:43:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ayPlXwCpXVs2OFxOGJX5zU5yA6bw9ihLmapIcCwY2qQ=; b=qgLn/5dJ
        +nkPoAMraCAfKVaZ0fq8ae9nDB3W4BTTD6284wz6MOKNbLcMy5KuawdZPJz3johf
        gKQpNybBjopmrY8VcM8VIrw8ESWYwfY+8TNoOsOkelWz6kMitqVcAm11SPF8ZXgt
        VsPShpYiFQbfchLD5AP9wvVNg+kz5RTgwNh/G2A82AvH1pt+AGrun/XWYW6Vpj1z
        lbvBPbO53OR1kp8UBExU2+Q5/D0sYk1nyBdj44qrlGefOxYpYgAorImhOo/Ay8pG
        XsNYnf0JPxkTly/3kyKf9YjwIZQRHROF7+a0R8p5rXg9j9Rmv3ihrpTTMwfb5Pl3
        geNV4j6/5OJtMg==
X-ME-Sender: <xms:n2zAXvY46F9SVCVNObfFYhGJoj64ze2jxTub-EeoUoJxNZyIVt17NQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtuddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:n2zAXuZgy5dxHk-5OuRx7xpnmVEB2pSc6hUNNUPbUVBEr33wDNtN3A>
    <xmx:n2zAXh8-Dxork-taNtn6AdZ0ym7NWWpoHyDGYsTSUPAVfDLj-K4BXw>
    <xmx:n2zAXlq5xDVB5pE12thLPFESgdQj7OolvG2VLJ9QJTjNzMg2we3Arw>
    <xmx:n2zAXvDV0-iVYtVrNJFW8fvDple59mEFtlNdAF9pYY4Oa5MO5ohi2w>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1967F306639E;
        Sat, 16 May 2020 18:43:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/6] selftests: mlxsw: Do not hard code trap group name
Date:   Sun, 17 May 2020 01:43:10 +0300
Message-Id: <20200516224310.877237-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516224310.877237-1-idosch@idosch.org>
References: <20200516224310.877237-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

It can be derived dynamically from the trap's name, so drop it.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/mlxsw/devlink_trap_acl_drops.sh       |  4 +--
 .../net/mlxsw/devlink_trap_l2_drops.sh        | 33 +++++++----------
 .../net/mlxsw/devlink_trap_l3_drops.sh        | 35 ++++++-------------
 .../net/mlxsw/devlink_trap_l3_exceptions.sh   | 20 ++++-------
 .../net/mlxsw/devlink_trap_tunnel_ipip.sh     |  6 ++--
 .../net/mlxsw/devlink_trap_tunnel_vxlan.sh    |  9 ++---
 .../selftests/net/forwarding/devlink_lib.sh   |  8 +++--
 7 files changed, 43 insertions(+), 72 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_acl_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_acl_drops.sh
index 26044e397157..b32ba5fec59d 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_acl_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_acl_drops.sh
@@ -107,7 +107,7 @@ ingress_flow_action_drop_test()
 
 	RET=0
 
-	devlink_trap_drop_test ingress_flow_action_drop acl_drops $swp2 101
+	devlink_trap_drop_test ingress_flow_action_drop $swp2 101
 
 	log_test "ingress_flow_action_drop"
 
@@ -132,7 +132,7 @@ egress_flow_action_drop_test()
 
 	RET=0
 
-	devlink_trap_drop_test egress_flow_action_drop acl_drops $swp2 102
+	devlink_trap_drop_test egress_flow_action_drop $swp2 102
 
 	log_test "egress_flow_action_drop"
 
diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
index e7aecb065409..a4c2812e9807 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
@@ -96,7 +96,6 @@ source_mac_is_multicast_test()
 {
 	local trap_name="source_mac_is_multicast"
 	local smac=01:02:03:04:05:06
-	local group_name="l2_drops"
 	local mz_pid
 
 	tc filter add dev $swp2 egress protocol ip pref 1 handle 101 \
@@ -107,7 +106,7 @@ source_mac_is_multicast_test()
 
 	RET=0
 
-	devlink_trap_drop_test $trap_name $group_name $swp2 101
+	devlink_trap_drop_test $trap_name $swp2 101
 
 	log_test "Source MAC is multicast"
 
@@ -118,7 +117,6 @@ __vlan_tag_mismatch_test()
 {
 	local trap_name="vlan_tag_mismatch"
 	local dmac=de:ad:be:ef:13:37
-	local group_name="l2_drops"
 	local opt=$1; shift
 	local mz_pid
 
@@ -132,7 +130,7 @@ __vlan_tag_mismatch_test()
 	$MZ $h1 "$opt" -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp2 101
+	devlink_trap_drop_test $trap_name $swp2 101
 
 	# Add PVID and make sure packets are no longer dropped.
 	bridge vlan add vid 1 dev $swp1 pvid untagged master
@@ -140,7 +138,7 @@ __vlan_tag_mismatch_test()
 
 	devlink_trap_stats_idle_test $trap_name
 	check_err $? "Trap stats not idle when packets should not be dropped"
-	devlink_trap_group_stats_idle_test $group_name
+	devlink_trap_group_stats_idle_test $(devlink_trap_group_get $trap_name)
 	check_err $? "Trap group stats not idle with when packets should not be dropped"
 
 	tc_check_packets "dev $swp2 egress" 101 0
@@ -179,7 +177,6 @@ ingress_vlan_filter_test()
 {
 	local trap_name="ingress_vlan_filter"
 	local dmac=de:ad:be:ef:13:37
-	local group_name="l2_drops"
 	local mz_pid
 	local vid=10
 
@@ -193,7 +190,7 @@ ingress_vlan_filter_test()
 	$MZ $h1 -Q $vid -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp2 101
+	devlink_trap_drop_test $trap_name $swp2 101
 
 	# Add the VLAN on the bridge port and make sure packets are no longer
 	# dropped.
@@ -202,7 +199,7 @@ ingress_vlan_filter_test()
 
 	devlink_trap_stats_idle_test $trap_name
 	check_err $? "Trap stats not idle when packets should not be dropped"
-	devlink_trap_group_stats_idle_test $group_name
+	devlink_trap_group_stats_idle_test $(devlink_trap_group_get $trap_name)
 	check_err $? "Trap group stats not idle with when packets should not be dropped"
 
 	tc_check_packets "dev $swp2 egress" 101 0
@@ -222,7 +219,6 @@ __ingress_stp_filter_test()
 {
 	local trap_name="ingress_spanning_tree_filter"
 	local dmac=de:ad:be:ef:13:37
-	local group_name="l2_drops"
 	local state=$1; shift
 	local mz_pid
 	local vid=20
@@ -237,7 +233,7 @@ __ingress_stp_filter_test()
 	$MZ $h1 -Q $vid -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp2 101
+	devlink_trap_drop_test $trap_name $swp2 101
 
 	# Change STP state to forwarding and make sure packets are no longer
 	# dropped.
@@ -246,7 +242,7 @@ __ingress_stp_filter_test()
 
 	devlink_trap_stats_idle_test $trap_name
 	check_err $? "Trap stats not idle when packets should not be dropped"
-	devlink_trap_group_stats_idle_test $group_name
+	devlink_trap_group_stats_idle_test $(devlink_trap_group_get $trap_name)
 	check_err $? "Trap group stats not idle with when packets should not be dropped"
 
 	tc_check_packets "dev $swp2 egress" 101 0
@@ -292,7 +288,6 @@ port_list_is_empty_uc_test()
 {
 	local trap_name="port_list_is_empty"
 	local dmac=de:ad:be:ef:13:37
-	local group_name="l2_drops"
 	local mz_pid
 
 	# Disable unicast flooding on both ports, so that packets cannot egress
@@ -308,7 +303,7 @@ port_list_is_empty_uc_test()
 	$MZ $h1 -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp2 101
+	devlink_trap_drop_test $trap_name $swp2 101
 
 	# Allow packets to be flooded to one port.
 	ip link set dev $swp2 type bridge_slave flood on
@@ -316,7 +311,7 @@ port_list_is_empty_uc_test()
 
 	devlink_trap_stats_idle_test $trap_name
 	check_err $? "Trap stats not idle when packets should not be dropped"
-	devlink_trap_group_stats_idle_test $group_name
+	devlink_trap_group_stats_idle_test $(devlink_trap_group_get $trap_name)
 	check_err $? "Trap group stats not idle with when packets should not be dropped"
 
 	tc_check_packets "dev $swp2 egress" 101 0
@@ -335,7 +330,6 @@ port_list_is_empty_mc_test()
 {
 	local trap_name="port_list_is_empty"
 	local dmac=01:00:5e:00:00:01
-	local group_name="l2_drops"
 	local dip=239.0.0.1
 	local mz_pid
 
@@ -354,7 +348,7 @@ port_list_is_empty_mc_test()
 	$MZ $h1 -c 0 -p 100 -a own -b $dmac -t ip -B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp2 101
+	devlink_trap_drop_test $trap_name $swp2 101
 
 	# Allow packets to be flooded to one port.
 	ip link set dev $swp2 type bridge_slave mcast_flood on
@@ -362,7 +356,7 @@ port_list_is_empty_mc_test()
 
 	devlink_trap_stats_idle_test $trap_name
 	check_err $? "Trap stats not idle when packets should not be dropped"
-	devlink_trap_group_stats_idle_test $group_name
+	devlink_trap_group_stats_idle_test $(devlink_trap_group_get $trap_name)
 	check_err $? "Trap group stats not idle with when packets should not be dropped"
 
 	tc_check_packets "dev $swp2 egress" 101 0
@@ -387,7 +381,6 @@ port_loopback_filter_uc_test()
 {
 	local trap_name="port_loopback_filter"
 	local dmac=de:ad:be:ef:13:37
-	local group_name="l2_drops"
 	local mz_pid
 
 	# Make sure packets can only egress the input port.
@@ -401,7 +394,7 @@ port_loopback_filter_uc_test()
 	$MZ $h1 -c 0 -p 100 -a own -b $dmac -t ip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp2 101
+	devlink_trap_drop_test $trap_name $swp2 101
 
 	# Allow packets to be flooded.
 	ip link set dev $swp2 type bridge_slave flood on
@@ -409,7 +402,7 @@ port_loopback_filter_uc_test()
 
 	devlink_trap_stats_idle_test $trap_name
 	check_err $? "Trap stats not idle when packets should not be dropped"
-	devlink_trap_group_stats_idle_test $group_name
+	devlink_trap_group_stats_idle_test $(devlink_trap_group_get $trap_name)
 	check_err $? "Trap group stats not idle with when packets should not be dropped"
 
 	tc_check_packets "dev $swp2 egress" 101 0
diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
index 616f47d86a61..f5abb1ebd392 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
@@ -161,7 +161,6 @@ ping_check()
 non_ip_test()
 {
 	local trap_name="non_ip"
-	local group_name="l3_drops"
 	local mz_pid
 
 	RET=0
@@ -176,7 +175,7 @@ non_ip_test()
 		00:00 de:ad:be:ef" &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2 101
+	devlink_trap_drop_test $trap_name $rp2 101
 
 	log_test "Non IP"
 
@@ -190,7 +189,6 @@ __uc_dip_over_mc_dmac_test()
 	local dip=$1; shift
 	local flags=${1:-""}; shift
 	local trap_name="uc_dip_over_mc_dmac"
-	local group_name="l3_drops"
 	local dmac=01:02:03:04:05:06
 	local mz_pid
 
@@ -206,7 +204,7 @@ __uc_dip_over_mc_dmac_test()
 		-B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2 101
+	devlink_trap_drop_test $trap_name $rp2 101
 
 	log_test "Unicast destination IP over multicast destination MAC: $desc"
 
@@ -227,7 +225,6 @@ __sip_is_loopback_test()
 	local dip=$1; shift
 	local flags=${1:-""}; shift
 	local trap_name="sip_is_loopback_address"
-	local group_name="l3_drops"
 	local mz_pid
 
 	RET=0
@@ -242,7 +239,7 @@ __sip_is_loopback_test()
 		-b $rp1mac -B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2 101
+	devlink_trap_drop_test $trap_name $rp2 101
 
 	log_test "Source IP is loopback address: $desc"
 
@@ -262,7 +259,6 @@ __dip_is_loopback_test()
 	local dip=$1; shift
 	local flags=${1:-""}; shift
 	local trap_name="dip_is_loopback_address"
-	local group_name="l3_drops"
 	local mz_pid
 
 	RET=0
@@ -277,7 +273,7 @@ __dip_is_loopback_test()
 		-B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2 101
+	devlink_trap_drop_test $trap_name $rp2 101
 
 	log_test "Destination IP is loopback address: $desc"
 
@@ -298,7 +294,6 @@ __sip_is_mc_test()
 	local dip=$1; shift
 	local flags=${1:-""}; shift
 	local trap_name="sip_is_mc"
-	local group_name="l3_drops"
 	local mz_pid
 
 	RET=0
@@ -313,7 +308,7 @@ __sip_is_mc_test()
 		-b $rp1mac -B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2 101
+	devlink_trap_drop_test $trap_name $rp2 101
 
 	log_test "Source IP is multicast: $desc"
 
@@ -329,7 +324,6 @@ sip_is_mc_test()
 ipv4_sip_is_limited_bc_test()
 {
 	local trap_name="ipv4_sip_is_limited_bc"
-	local group_name="l3_drops"
 	local sip=255.255.255.255
 	local mz_pid
 
@@ -345,7 +339,7 @@ ipv4_sip_is_limited_bc_test()
 		-B $h2_ipv4 -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2 101
+	devlink_trap_drop_test $trap_name $rp2 101
 
 	log_test "IPv4 source IP is limited broadcast"
 
@@ -382,7 +376,6 @@ __ipv4_header_corrupted_test()
 	local ihl=$1; shift
 	local checksum=$1; shift
 	local trap_name="ip_header_corrupted"
-	local group_name="l3_drops"
 	local payload
 	local mz_pid
 
@@ -399,7 +392,7 @@ __ipv4_header_corrupted_test()
 	$MZ $h1 -c 0 -d 1msec -a $h1mac -b $rp1mac -q p=$payload &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2 101
+	devlink_trap_drop_test $trap_name $rp2 101
 
 	log_test "IP header corrupted: $desc: IPv4"
 
@@ -429,7 +422,6 @@ __ipv6_header_corrupted_test()
 	local desc=$1; shift
 	local ipver=$1; shift
 	local trap_name="ip_header_corrupted"
-	local group_name="l3_drops"
 	local payload
 	local mz_pid
 
@@ -446,7 +438,7 @@ __ipv6_header_corrupted_test()
 	$MZ $h1 -c 0 -d 1msec -a $h1mac -b $rp1mac -q p=$payload &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2 101
+	devlink_trap_drop_test $trap_name $rp2 101
 
 	log_test "IP header corrupted: $desc: IPv6"
 
@@ -469,7 +461,6 @@ ip_header_corrupted_test()
 ipv6_mc_dip_reserved_scope_test()
 {
 	local trap_name="ipv6_mc_dip_reserved_scope"
-	local group_name="l3_drops"
 	local dip=FF00::
 	local mz_pid
 
@@ -485,7 +476,7 @@ ipv6_mc_dip_reserved_scope_test()
 		"33:33:00:00:00:00" -B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2 101
+	devlink_trap_drop_test $trap_name $rp2 101
 
 	log_test "IPv6 multicast destination IP reserved scope"
 
@@ -495,7 +486,6 @@ ipv6_mc_dip_reserved_scope_test()
 ipv6_mc_dip_interface_local_scope_test()
 {
 	local trap_name="ipv6_mc_dip_interface_local_scope"
-	local group_name="l3_drops"
 	local dip=FF01::
 	local mz_pid
 
@@ -511,7 +501,7 @@ ipv6_mc_dip_interface_local_scope_test()
 		"33:33:00:00:00:00" -B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2 101
+	devlink_trap_drop_test $trap_name $rp2 101
 
 	log_test "IPv6 multicast destination IP interface-local scope"
 
@@ -526,7 +516,6 @@ __blackhole_route_test()
 	local dip=$1; shift
 	local ip_proto=${1:-"icmp"}; shift
 	local trap_name="blackhole_route"
-	local group_name="l3_drops"
 	local mz_pid
 
 	RET=0
@@ -542,7 +531,7 @@ __blackhole_route_test()
 		-B $dip -d 1msec -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $rp2 101
+	devlink_trap_drop_test $trap_name $rp2 101
 	log_test "Blackhole route: IPv$flags"
 
 	devlink_trap_drop_cleanup $mz_pid $rp2 $proto 1 101
@@ -558,7 +547,6 @@ blackhole_route_test()
 irif_disabled_test()
 {
 	local trap_name="irif_disabled"
-	local group_name="l3_drops"
 	local t0_packets t0_bytes
 	local t1_packets t1_bytes
 	local mz_pid
@@ -613,7 +601,6 @@ irif_disabled_test()
 erif_disabled_test()
 {
 	local trap_name="erif_disabled"
-	local group_name="l3_drops"
 	local t0_packets t0_bytes
 	local t1_packets t1_bytes
 	local mz_pid
diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
index 2bc6df42d597..1fedfc9da434 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
@@ -169,7 +169,6 @@ trap_action_check()
 mtu_value_is_too_small_test()
 {
 	local trap_name="mtu_value_is_too_small"
-	local group_name="l3_drops"
 	local expected_action="trap"
 	local mz_pid
 
@@ -191,7 +190,7 @@ mtu_value_is_too_small_test()
 		-B 198.51.100.1 -q &
 	mz_pid=$!
 
-	devlink_trap_exception_test $trap_name $group_name
+	devlink_trap_exception_test $trap_name
 
 	tc_check_packets_hitting "dev $h1 ingress" 101
 	check_err $? "Packets were not received to h1"
@@ -208,7 +207,6 @@ __ttl_value_is_too_small_test()
 {
 	local ttl_val=$1; shift
 	local trap_name="ttl_value_is_too_small"
-	local group_name="l3_drops"
 	local expected_action="trap"
 	local mz_pid
 
@@ -227,7 +225,7 @@ __ttl_value_is_too_small_test()
 		-b $rp1mac -B 198.51.100.1 -q &
 	mz_pid=$!
 
-	devlink_trap_exception_test $trap_name $group_name
+	devlink_trap_exception_test $trap_name
 
 	tc_check_packets_hitting "dev $h1 ingress" 101
 	check_err $? "Packets were not received to h1"
@@ -271,7 +269,6 @@ __mc_reverse_path_forwarding_test()
 	local proto=$1; shift
 	local flags=${1:-""}; shift
 	local trap_name="mc_reverse_path_forwarding"
-	local group_name="l3_drops"
 	local expected_action="trap"
 	local mz_pid
 
@@ -292,7 +289,7 @@ __mc_reverse_path_forwarding_test()
 
 	mz_pid=$!
 
-	devlink_trap_exception_test $trap_name $group_name
+	devlink_trap_exception_test $trap_name
 
 	tc_check_packets "dev $rp2 egress" 101 0
 	check_err $? "Packets were not dropped"
@@ -322,7 +319,6 @@ __reject_route_test()
 	local unreachable=$1; shift
 	local flags=${1:-""}; shift
 	local trap_name="reject_route"
-	local group_name="l3_drops"
 	local expected_action="trap"
 	local mz_pid
 
@@ -341,7 +337,7 @@ __reject_route_test()
 		-B $dst_ip -q &
 	mz_pid=$!
 
-	devlink_trap_exception_test $trap_name $group_name
+	devlink_trap_exception_test $trap_name
 
 	tc_check_packets_hitting "dev $h1 ingress" 101
 	check_err $? "ICMP packet was not received to h1"
@@ -370,7 +366,6 @@ __host_miss_test()
 	local desc=$1; shift
 	local dip=$1; shift
 	local trap_name="unresolved_neigh"
-	local group_name="l3_drops"
 	local expected_action="trap"
 	local mz_pid
 
@@ -405,7 +400,6 @@ __invalid_nexthop_test()
 	local subnet=$1; shift
 	local via_add=$1; shift
 	local trap_name="unresolved_neigh"
-	local group_name="l3_drops"
 	local expected_action="trap"
 	local mz_pid
 
@@ -494,7 +488,6 @@ vrf_without_routes_destroy()
 ipv4_lpm_miss_test()
 {
 	local trap_name="ipv4_lpm_miss"
-	local group_name="l3_drops"
 	local expected_action="trap"
 	local mz_pid
 
@@ -511,7 +504,7 @@ ipv4_lpm_miss_test()
 		-B 203.0.113.1 -q &
 	mz_pid=$!
 
-	devlink_trap_exception_test $trap_name $group_name
+	devlink_trap_exception_test $trap_name
 
 	log_test "LPM miss: IPv4"
 
@@ -522,7 +515,6 @@ ipv4_lpm_miss_test()
 ipv6_lpm_miss_test()
 {
 	local trap_name="ipv6_lpm_miss"
-	local group_name="l3_drops"
 	local expected_action="trap"
 	local mz_pid
 
@@ -539,7 +531,7 @@ ipv6_lpm_miss_test()
 		-B 2001:db8::1 -q &
 	mz_pid=$!
 
-	devlink_trap_exception_test $trap_name $group_name
+	devlink_trap_exception_test $trap_name
 
 	log_test "LPM miss: IPv6"
 
diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
index 039629bb92a3..8817851da7a9 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh
@@ -140,7 +140,6 @@ ecn_payload_get()
 ecn_decap_test()
 {
 	local trap_name="decap_error"
-	local group_name="tunnel_drops"
 	local desc=$1; shift
 	local ecn_desc=$1; shift
 	local outer_tos=$1; shift
@@ -161,7 +160,7 @@ ecn_decap_test()
 
 	mz_pid=$!
 
-	devlink_trap_exception_test $trap_name $group_name
+	devlink_trap_exception_test $trap_name
 
 	tc_check_packets "dev $swp1 egress" 101 0
 	check_err $? "Packets were not dropped"
@@ -200,7 +199,6 @@ ipip_payload_get()
 no_matching_tunnel_test()
 {
 	local trap_name="decap_error"
-	local group_name="tunnel_drops"
 	local desc=$1; shift
 	local sip=$1; shift
 	local mz_pid
@@ -218,7 +216,7 @@ no_matching_tunnel_test()
 		-A $sip -B 192.0.2.65 -t ip len=48,proto=47,p=$payload -q &
 	mz_pid=$!
 
-	devlink_trap_exception_test $trap_name $group_name
+	devlink_trap_exception_test $trap_name
 
 	tc_check_packets "dev $swp1 egress" 101 0
 	check_err $? "Packets were not dropped"
diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
index e11a416323cf..10e0f3dbc930 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
@@ -159,7 +159,6 @@ ecn_payload_get()
 ecn_decap_test()
 {
 	local trap_name="decap_error"
-	local group_name="tunnel_drops"
 	local desc=$1; shift
 	local ecn_desc=$1; shift
 	local outer_tos=$1; shift
@@ -177,7 +176,7 @@ ecn_decap_test()
 		-t udp sp=12345,dp=$VXPORT,tos=$outer_tos,p=$payload -q &
 	mz_pid=$!
 
-	devlink_trap_exception_test $trap_name $group_name
+	devlink_trap_exception_test $trap_name
 
 	tc_check_packets "dev $swp1 egress" 101 0
 	check_err $? "Packets were not dropped"
@@ -228,7 +227,6 @@ short_payload_get()
 corrupted_packet_test()
 {
 	local trap_name="decap_error"
-	local group_name="tunnel_drops"
 	local desc=$1; shift
 	local payload_get=$1; shift
 	local mz_pid
@@ -246,7 +244,7 @@ corrupted_packet_test()
 		-B 192.0.2.17 -t udp sp=12345,dp=$VXPORT,p=$payload -q &
 	mz_pid=$!
 
-	devlink_trap_exception_test $trap_name $group_name
+	devlink_trap_exception_test $trap_name
 
 	tc_check_packets "dev $swp1 egress" 101 0
 	check_err $? "Packets were not dropped"
@@ -297,7 +295,6 @@ mc_smac_payload_get()
 overlay_smac_is_mc_test()
 {
 	local trap_name="overlay_smac_is_mc"
-	local group_name="tunnel_drops"
 	local mz_pid
 
 	RET=0
@@ -314,7 +311,7 @@ overlay_smac_is_mc_test()
 		-B 192.0.2.17 -t udp sp=12345,dp=$VXPORT,p=$payload -q &
 	mz_pid=$!
 
-	devlink_trap_drop_test $trap_name $group_name $swp1 101
+	devlink_trap_drop_test $trap_name $swp1 101
 
 	log_test "Overlay source MAC is multicast"
 
diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 7b6390aea50b..e27236109235 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -365,7 +365,9 @@ devlink_trap_group_stats_idle_test()
 devlink_trap_exception_test()
 {
 	local trap_name=$1; shift
-	local group_name=$1; shift
+	local group_name
+
+	group_name=$(devlink_trap_group_get $trap_name)
 
 	devlink_trap_stats_idle_test $trap_name
 	check_fail $? "Trap stats idle when packets should have been trapped"
@@ -377,9 +379,11 @@ devlink_trap_exception_test()
 devlink_trap_drop_test()
 {
 	local trap_name=$1; shift
-	local group_name=$1; shift
 	local dev=$1; shift
 	local handle=$1; shift
+	local group_name
+
+	group_name=$(devlink_trap_group_get $trap_name)
 
 	# This is the common part of all the tests. It checks that stats are
 	# initially idle, then non-idle after changing the trap action and
-- 
2.26.2

