Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D53244E9B
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 20:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgHNS4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 14:56:11 -0400
Received: from mailrelay112.isp.belgacom.be ([195.238.20.139]:13761 "EHLO
        mailrelay112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726285AbgHNS4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 14:56:11 -0400
IronPort-SDR: 9TuJwu26yOeK04zBZN2TX7Uvmgr2RDvJZfpHIzdm4x3qIonySFcZfyokTKJHAzt0m2Xyej8aRH
 psFGO0CB6UHpfPZj/HD6pSN0fIOe/xd4MgqHyYggqEeU2nHDZJSHbcdtYHjMA2wnUlsUfJEir5
 1+EdlJQWg5HJUdYMiL7id9uK43N4D3seenVHRjsBXM8CiVYP2XXRMaOkLYjBRfgFeZ4lTWnQVc
 wrW5l5IhoEys3fzsW7L4dO1lXXV1vI7KKUMCrQEyJUgMljMXXgiFYHonRSV/VU+PgkRlfO/4SS
 xR8=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AiEK63BKoRDme/GWajNmcpTZWNBhigK39O0sv0r?=
 =?us-ascii?q?FitYgXK/r4rarrMEGX3/hxlliBBdydt6sazbuJ+Pm6AiQp2tWoiDg6aptCVh?=
 =?us-ascii?q?sI2409vjcLJ4q7M3D9N+PgdCcgHc5PBxdP9nC/NlVJSo6lPwWB6nK94iQPFR?=
 =?us-ascii?q?rhKAF7Ovr6GpLIj8Swyuu+54Dfbx9HiTagYL5+NhG7oAfeusULn4dvJLs6xw?=
 =?us-ascii?q?fUrHdPZ+lY335jK0iJnxb76Mew/Zpj/DpVtvk86cNOUrj0crohQ7BAAzsoL2?=
 =?us-ascii?q?465MvwtRneVgSP/WcTUn8XkhVTHQfI6gzxU4rrvSv7sup93zSaPdHzQLspVz?=
 =?us-ascii?q?mu87tnRRn1gyoBKjU38nzYitZogaxbvhyvuhJxzY3Tbo6aO/RzZb/RcNAASG?=
 =?us-ascii?q?ZdRMtdSzBND4WhZIUPFeoBOuNYopH9qVQUthS+BBOjBOXywTFInH/5w7A13P?=
 =?us-ascii?q?o7EQHHwAMgHM8FvXParNrvL6gSX/u4zLLLzTTDafNZxyv95JLTfR8/uPyBW6?=
 =?us-ascii?q?97fsXNx0c1DQzFkkmQppL/PzOTzukDvWuW4u5gW++ui2MrtQ98rDiyy8swl4?=
 =?us-ascii?q?XFmoMYxF/L+yhkzos4O8C1RU55bNO6H5Vcqy+UOYRyT80iQ29kpiI3x7sbsp?=
 =?us-ascii?q?C4ZCgH0JAqywPFZ/CacIWE/AjvWPuQLDp4nn5pZbOyihCv+ka60OL8TNO70F?=
 =?us-ascii?q?NSoypAldnDq24C2gTI6siCVvt95kCh2SuT1wzL6uFLP0Q0la3DJp4lxb4/io?=
 =?us-ascii?q?AcsUDDHi/xg0X2kLWadkEj+ue08evnZqjpppiZN4BuiwH+NLwims25AesmLg?=
 =?us-ascii?q?gDR2yW9fmm2LH+/kD1Xq9GguA3n6TZqpzWOMUWqra8AwBP04Yj7xi/Dy2h0N?=
 =?us-ascii?q?QdhXQHIkhKdwmJj4XyIFHOI/D5DfGhjFSwijtk3O7JMqX7AprRNnjDjKvhfb?=
 =?us-ascii?q?Fl5k5E0gU81tRf55VPB7EHPv3zRkHxtN3cDh8lLQO02fzrCNJn1oMRQWiPGL?=
 =?us-ascii?q?OWMLvOsV+U4eIiO+qMa5UItzb5Nfcq++XjjXknll8Bc6mp3J8XaGymEfR8OU?=
 =?us-ascii?q?mZZmDsgtgZG2cQogU+VPDqiEGFUTNLaXazUbkx5ionCIK8CYfMWIatjKac0y?=
 =?us-ascii?q?ilBpdWfHxJCkiQEXf0cIWJQ/EMZzyOIs9vkzwEUaShRJE71R23qQD11aRnIf?=
 =?us-ascii?q?TQ+iADq5Lj28Z65/fJmREx6zN0FcKd3H+JT21umWMIXTA21rhloUNh0leDzb?=
 =?us-ascii?q?R4g/tAGNNP4PNJSBk1NYLCwONgDtD/QQTBccmVSFaoQ9WmBS0xQcwrw9MUZE?=
 =?us-ascii?q?Z9AdqihAjZ3yW2G78Vi6CLBJss/6LawXfxO9tyxGjY1KQ6kVkmTdVANXe8iq?=
 =?us-ascii?q?586QfTHYjJnFudl6qwcqQcxiHN/n+ZzWWSpEFYTBJwUaLdUHARfETZttr561?=
 =?us-ascii?q?jZT7+tCbUnNBVOydKYJqRRdNK6xWlBEe/qMtDZS2S8h2mxAQqF3PWLdoWuM2?=
 =?us-ascii?q?YU0CHQA2ACnhwd/HKaOBJ4AT2u5yrQExR1CUjrbkWq/eQthmm8SxoaxguLZk?=
 =?us-ascii?q?sp+aC49hMPhPefA6cd17gKkDwiujN5ABC30oSFWJK7uwN9cfAEMpsG61Bd2D?=
 =?us-ascii?q?eBug=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AFBQD83TZf/xCltlteHgEBCxIMR4R?=
 =?us-ascii?q?dVF+NOJI0kXsLAQEBAQEBAQEBJw0BAgQBAYRMgkolOBMCAwEBAQMCBQEBBgE?=
 =?us-ascii?q?BAQEBAQUEAYYPRYI3IoNRASMjgT8JCYMmAYJXKbRLhBCFGoFAgTiIIoUVgUE?=
 =?us-ascii?q?/hF+KNAS2LoJsgwuEWn6RLQ8hoB+SOKFOgXpNIBiDJAlHGQ2caEIwNwIGCgE?=
 =?us-ascii?q?BAwlXAT0BkAwBAQ?=
X-IPAS-Result: =?us-ascii?q?A2AFBQD83TZf/xCltlteHgEBCxIMR4RdVF+NOJI0kXsLA?=
 =?us-ascii?q?QEBAQEBAQEBJw0BAgQBAYRMgkolOBMCAwEBAQMCBQEBBgEBAQEBAQUEAYYPR?=
 =?us-ascii?q?YI3IoNRASMjgT8JCYMmAYJXKbRLhBCFGoFAgTiIIoUVgUE/hF+KNAS2LoJsg?=
 =?us-ascii?q?wuEWn6RLQ8hoB+SOKFOgXpNIBiDJAlHGQ2caEIwNwIGCgEBAwlXAT0BkAwBA?=
 =?us-ascii?q?Q?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 14 Aug 2020 20:56:01 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/2 nf] selftests: netfilter: exit on invalid parameters
Date:   Fri, 14 Aug 2020 20:55:44 +0200
Message-Id: <20200814185544.8732-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

exit script with comments when parameters are wrong during address
addition. No need for a message when trying to change MTU with lower
values: output is self-explanatory

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 tools/testing/selftests/netfilter/nft_flowtable.sh | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 28e32fddf9b2c..c3617d0037f2e 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -97,9 +97,17 @@ do
 done
 
 ip -net nsr1 link set veth0 mtu $omtu
+if [ $? -ne 0 ]; then
+	exit 1
+fi
+
 ip -net ns1 link set eth0 mtu $omtu
 
 ip -net nsr2 link set veth1 mtu $rmtu
+if [ $? -ne 0 ]; then
+	exit 1
+fi
+
 ip -net ns2 link set eth0 mtu $rmtu
 
 # transfer-net between nsr1 and nsr2.
@@ -119,6 +127,11 @@ for i in 1 2; do
   ip -net ns$i addr add 10.0.$i.99/24 dev eth0
   ip -net ns$i route add default via 10.0.$i.1
   ip -net ns$i addr add dead:$i::99/64 dev eth0
+  if [ $? -ne 0 ]; then
+	echo "ERROR: Check Originator/Responder values (problem during address addition)" 1>&2
+	exit 1
+  fi
+
   ip -net ns$i route add default via dead:$i::1
   ip netns exec ns$i sysctl net.ipv4.tcp_no_metrics_save=1 > /dev/null
 
-- 
2.27.0

