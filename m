Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA82524EF36
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 20:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgHWSSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 14:18:05 -0400
Received: from mailrelay102.isp.belgacom.be ([195.238.20.129]:53596 "EHLO
        mailrelay102.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbgHWSSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 14:18:03 -0400
IronPort-SDR: A3xFN6t9Z0Jf7B9yz6a2cOd/UOqUdVfeyMkYmU/+dEjcClsRhFiFlDV5ULz9jOttmN/lZyskSK
 gSgiNnT0F3MUfyaFTlUzaTcPU7cTDumBrB1DML/vSIZ0lsboFhSEsLlrer7FfgPzjIuH0U2BJV
 D8eWvw6ZAdAaQ9lbUZN2bLNtp0IqNloCyiEhNcPPaL2bdilrg+aemN+8AuQaPyjXtvaEkYGsaf
 1+U+OPt5KZyDwR5XIUqH6MYsrR1zHJtkosDPgqk00i0FbOTFeL6um5l4EC1F+UFZ6rwatf72hP
 5rg=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AEglLQRWlC0LMm7pov4/DkRZTf7vV8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYZRaPvadThVPEFb/W9+hDw7KP9fy5BypZuMjK6SpZOLV3FD?=
 =?us-ascii?q?Y9wf0MmAIhBMPXQWbaF9XNKxIAIcJZSVV+9Gu6O0UGUOz3ZlnVv2HgpWVKQk?=
 =?us-ascii?q?a3OgV6PPn6FZDPhMqrye+y54fTYwJVjzahfL9+Nhq7oRjQu8UMnIduN6c8xh?=
 =?us-ascii?q?TUrndWdeld2H9lK0+Ukxvg/Mm74YRt8z5Xu/Iv9s5AVbv1cqElRrFGDzooLn?=
 =?us-ascii?q?446tTzuRbMUQWA6H0cUn4LkhVTGAjK8Av6XpbqvSTksOd2xTSXMtf3TbAwXj?=
 =?us-ascii?q?Si8rtrRRr1gyoJKzI17GfagdF2galGohyuugZ/zpbUbo+LKfRwcKDTc9QVSm?=
 =?us-ascii?q?RORctdSy9MD5mgY4YVE+YNIeBVpJT9qVsUqhu+ABGhCuP1xTBTh3/5x6s62P?=
 =?us-ascii?q?khHwHcwgMvAswBsG7VrNrpN6cZTOe4zKfSwjrYYfNbwiz96IvIcxAnv/6MQa?=
 =?us-ascii?q?h8ftHPxkQ2EQ7Ok1qfp5D/MTyPyuQNr3aU7/BmVe+3lmMqpR19rDigy8othI?=
 =?us-ascii?q?TEiI0bx1PF+Ch63Io4Id61RFJ0bNCkDpZeuD2WOolqT848R2xluCU3x7wbtZ?=
 =?us-ascii?q?O6cyUHzJIqzAPRZfyAdoiH+BPjVOCJLDd+mn1lZLy/hxe28Ui81OL8TNO40F?=
 =?us-ascii?q?BEridDj9LCtWgN2gTX58SaUPdx40Ss1SiV2wzO6+xJIVo4mbfaJpMn37U+jI?=
 =?us-ascii?q?AcsV7ZES/zgEj2iaiWeVg69eWw8OTnZ6nmpoebN49plgHyKqQuldK7AeQ/Kg?=
 =?us-ascii?q?UOW2+b9vim273n/U35R65KjuEsnqndt5DVOd4UpqqkDA9S14Ys8Re/DzG+3N?=
 =?us-ascii?q?QZm3kIMk5FdQqDgoT0IV3CPfP1Aemlj1ixkTpmx+rKMqDgD5nVK3jMirbhfb?=
 =?us-ascii?q?Jz605GzwozyMhS55xOBb4aLvL+QVTxtN/YDx8/LQO03/zrB85j2Y8GQ2KAHr?=
 =?us-ascii?q?eZML/OsV+P/u8vO/ODa5QRuDb6MPUl4eDhjWM3mV8ceampwYUYaGqiEvRhOU?=
 =?us-ascii?q?WZbmLmgs0dHmcSogo+UOvqhUWBUTFJenmyW7wz6S0gBYKgE4jDWo6tgL2F3C?=
 =?us-ascii?q?enAJJWfHpKCleWEXfnb4+EQesDaDqOIs99lTwJTbahSoE62BG1qA/60b5nIf?=
 =?us-ascii?q?TS+iECqJ3sysB/5/fPmhEq6Tx0E8Od3nmWT25vhGMIRiE23KF4oUFm0FeMz7?=
 =?us-ascii?q?V3g/xCGtxP/f9GTgA6NZvExexgF9/yQh7BfsuOSFu+RNWpHy0xTtwww98Kf0?=
 =?us-ascii?q?ZyBc+iggne0CW0Hb8aibiLCYcq8qLTwXfxPdxxy3XY26k7iVkpXM9POXehhq?=
 =?us-ascii?q?5l+AjZH5TJnFmBl6a2aaQc2zbA+3uEzWqUok5YTBB/Xr/AXX0EYEvZs8j55k?=
 =?us-ascii?q?3DT7+qFbQoLBFBxdSFKqtQZd3jlU9GS+v7ONTCf2KxnH+9BRCWybOQcYXlZX?=
 =?us-ascii?q?sd0T7DCEgLjQ8T52yKNQsgCSe7pWLREjhuGUjoY0P2/ul0sGm7QVMszwGWc0?=
 =?us-ascii?q?1h0KK4+hAPivOHRfMexakEuCQhqjVyAlm9w8jaBMGeqFkpQKIJedo35FBv02?=
 =?us-ascii?q?/FuQ15IpG6aad4iRpWcA17u07l/xN6FotBldQntjUt1gU2YayH+EhdbTeV29?=
 =?us-ascii?q?b8N/mfMWPo/Q6ubIbM113e2crQ8aAKu9oirFC2kgijF0Mku1t93tVYyXqX5d?=
 =?us-ascii?q?2eAgMYX7rqUVcx+gQ8rbyMMXp13J/dyXA5afr8iTTFwd98XOY=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DPBwB9skJf/xCltltfHQEBAQEJARI?=
 =?us-ascii?q?BBQUBR4FDAoMYVF+NOJJKkgILAQEBAQEBAQEBJw0BAgQBAYRMgkclOBMCAwE?=
 =?us-ascii?q?BAQMCBQEBBgEBAQEBAQUEAYYPRUMWAYFdIoNHCwEjI4E/EoMmAYJXKbIcM4Q?=
 =?us-ascii?q?QhGeBQIE4AYgjhRmBQT+BEYNOijQEj2UEplaCbYMMhFp+kTEPIaAykkOhWoF?=
 =?us-ascii?q?6TSAYO4JpCUcZDZxoQjA3AgYKAQEDCVcBPQGMBYQfAQE?=
X-IPAS-Result: =?us-ascii?q?A2DPBwB9skJf/xCltltfHQEBAQEJARIBBQUBR4FDAoMYV?=
 =?us-ascii?q?F+NOJJKkgILAQEBAQEBAQEBJw0BAgQBAYRMgkclOBMCAwEBAQMCBQEBBgEBA?=
 =?us-ascii?q?QEBAQUEAYYPRUMWAYFdIoNHCwEjI4E/EoMmAYJXKbIcM4QQhGeBQIE4AYgjh?=
 =?us-ascii?q?RmBQT+BEYNOijQEj2UEplaCbYMMhFp+kTEPIaAykkOhWoF6TSAYO4JpCUcZD?=
 =?us-ascii?q?ZxoQjA3AgYKAQEDCVcBPQGMBYQfAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 23 Aug 2020 20:17:59 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        sbrivio@redhat.com
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 4/5 nf] selftests: netfilter: simplify command testing
Date:   Sun, 23 Aug 2020 20:17:39 +0200
Message-Id: <20200823181740.13413-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some shellcheck SC2181 warnings:
"Check exit code directly with e.g. 'if mycmd;', not indirectly with
$?." as suggested by Stefano Brivio.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: new patch

 .../selftests/netfilter/nft_flowtable.sh      | 34 ++++++-------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 1058952d1b364..44a8798262369 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -27,8 +27,7 @@ ns2out=""
 log_netns=$(sysctl -n net.netfilter.nf_log_all_netns)
 
 checktool (){
-	$1 > /dev/null 2>&1
-	if [ $? -ne 0 ];then
+	if ! $1 > /dev/null 2>&1; then
 		echo "SKIP: Could not $2"
 		exit $ksft_skip
 	fi
@@ -187,15 +186,13 @@ if [ $? -ne 0 ]; then
 fi
 
 # test basic connectivity
-ip netns exec ns1 ping -c 1 -q 10.0.2.99 > /dev/null
-if [ $? -ne 0 ];then
+if ! ip netns exec ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
   echo "ERROR: ns1 cannot reach ns2" 1>&2
   bash
   exit 1
 fi
 
-ip netns exec ns2 ping -c 1 -q 10.0.1.99 > /dev/null
-if [ $? -ne 0 ];then
+if ! ip netns exec ns2 ping -c 1 -q 10.0.1.99 > /dev/null; then
   echo "ERROR: ns2 cannot reach ns1" 1>&2
   exit 1
 fi
@@ -230,8 +227,7 @@ check_transfer()
 	out=$2
 	what=$3
 
-	cmp "$in" "$out" > /dev/null 2>&1
-	if [ $? -ne 0 ] ;then
+	if ! cmp "$in" "$out" > /dev/null 2>&1; then
 		echo "FAIL: file mismatch for $what" 1>&2
 		ls -l "$in"
 		ls -l "$out"
@@ -268,13 +264,11 @@ test_tcp_forwarding_ip()
 
 	wait
 
-	check_transfer "$ns1in" "$ns2out" "ns1 -> ns2"
-	if [ $? -ne 0 ];then
+	if ! check_transfer "$ns1in" "$ns2out" "ns1 -> ns2"; then
 		lret=1
 	fi
 
-	check_transfer "$ns2in" "$ns1out" "ns1 <- ns2"
-	if [ $? -ne 0 ];then
+	if ! check_transfer "$ns2in" "$ns1out" "ns1 <- ns2"; then
 		lret=1
 	fi
 
@@ -308,8 +302,7 @@ make_file "$ns2in"
 
 # First test:
 # No PMTU discovery, nsr1 is expected to fragment packets from ns1 to ns2 as needed.
-test_tcp_forwarding ns1 ns2
-if [ $? -eq 0 ] ;then
+if test_tcp_forwarding ns1 ns2; then
 	echo "PASS: flow offloaded for ns1/ns2"
 else
 	echo "FAIL: flow offload for ns1/ns2:" 1>&2
@@ -340,9 +333,7 @@ table ip nat {
 }
 EOF
 
-test_tcp_forwarding_nat ns1 ns2
-
-if [ $? -eq 0 ] ;then
+if test_tcp_forwarding_nat ns1 ns2; then
 	echo "PASS: flow offloaded for ns1/ns2 with NAT"
 else
 	echo "FAIL: flow offload for ns1/ns2 with NAT" 1>&2
@@ -354,8 +345,7 @@ fi
 # Same as second test, but with PMTU discovery enabled.
 handle=$(ip netns exec nsr1 nft -a list table inet filter | grep something-to-grep-for | cut -d \# -f 2)
 
-ip netns exec nsr1 nft delete rule inet filter forward $handle
-if [ $? -ne 0 ] ;then
+if ! ip netns exec nsr1 nft delete rule inet filter forward $handle; then
 	echo "FAIL: Could not delete large-packet accept rule"
 	exit 1
 fi
@@ -363,8 +353,7 @@ fi
 ip netns exec ns1 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 ip netns exec ns2 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 
-test_tcp_forwarding_nat ns1 ns2
-if [ $? -eq 0 ] ;then
+if test_tcp_forwarding_nat ns1 ns2; then
 	echo "PASS: flow offloaded for ns1/ns2 with NAT and pmtu discovery"
 else
 	echo "FAIL: flow offload for ns1/ns2 with NAT and pmtu discovery" 1>&2
@@ -410,8 +399,7 @@ ip -net ns2 route del 192.168.10.1 via 10.0.2.1
 ip -net ns2 route add default via 10.0.2.1
 ip -net ns2 route add default via dead:2::1
 
-test_tcp_forwarding ns1 ns2
-if [ $? -eq 0 ] ;then
+if test_tcp_forwarding ns1 ns2; then
 	echo "PASS: ipsec tunnel mode for ns1/ns2"
 else
 	echo "FAIL: ipsec tunnel mode for ns1/ns2"
-- 
2.27.0

