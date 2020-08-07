Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790C523F30F
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 21:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgHGTbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 15:31:38 -0400
Received: from mailrelay110.isp.belgacom.be ([195.238.20.137]:57815 "EHLO
        mailrelay110.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbgHGTbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 15:31:36 -0400
IronPort-SDR: 1fyfjNk7TYh21MnooOaHM1kLQxRmr0IVJ7A7BlV4g0PWoDOGvC8XN9SL1+2z3btx+xdbm3uS1g
 JSDcBoiWM+a9CAfT0oQ+6QpcOH1qEZnRJz+4MvHLGsBfs4mpDkhsGTfE6qLi1soXu9GO+CsghI
 VYQTiFmiYt4F5rvxd+PrTltxnMHUp/iKMcDtaZ/kZHj4yrZ4pirwD6hrxhlETB0AliSP9tVebK
 ZdDMTG/aaj+QS//ZfVUmRgo6Qex/6aiRcFm/2HQKJNtA5MZeLysl5a1BKN3Z24vaMul7MV/Y2Z
 o30=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3A4BqUPhfX+sSMa0wGZ4kGovmIlGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxc24ZBGN2/xhgRfzUJnB7Loc0qyK6v6mCTZLuM3a+Fk5M7V0Hy?=
 =?us-ascii?q?cfjssXmwFySOWkMmbcaMDQUiohAc5ZX0Vk9XzoeWJcGcL5ekGA6ibqtW1aFR?=
 =?us-ascii?q?rwLxd6KfroEYDOkcu3y/qy+5rOaAlUmTaxe7x/IAi3oAnLtcQan4RuJrs/xx?=
 =?us-ascii?q?bHv3BFZ/lYyWR0KFyJgh3y/N2w/Jlt8yRRv/Iu6ctNWrjkcqo7ULJVEi0oP3?=
 =?us-ascii?q?g668P3uxbDSxCP5mYHXWUNjhVIGQnF4wrkUZr3ryD3q/By2CiePc3xULA0RT?=
 =?us-ascii?q?Gv5LplRRP0lCsKMSMy/WfKgcJyka1bugqsqRxhzYDJbo+bN/1wcazSc94BWW?=
 =?us-ascii?q?ZMXdxcWzBbD4+gc4cCCfcKM+ZCr4n6olsDtRuwChO3C+Pu0DBIgGL9060g0+?=
 =?us-ascii?q?s/DA7JwhYgH9MSv3TXsd74M6kSXvquw6nG1jjDdPBW2Df76IfWbhAtu+qDUq?=
 =?us-ascii?q?xpfMfX1EIgGB/LgE+Kpoz5IzOayP4Ns26D4ud9W++jl24ppg5wrzWhyMoihY?=
 =?us-ascii?q?rEi4MWx1zY8Sh0w5o5KNK4RkNlbtCoDJlduj2EOoZyQs4vQGBltDs7x7AJvZ?=
 =?us-ascii?q?O2ejUBxpogxx7acfOHco6I7wrlVOmPPTd4inNleLajhxms60is0Ov8Vsey3V?=
 =?us-ascii?q?1XrSRFisHBu3QQ2xDJ98SKSeVx8l281TuO1w3f8PxILEEymKHGMZAu2KQwmY?=
 =?us-ascii?q?AWsUnbGy/2n1j5g7GOe0U//+io9/znYrL7pp+AL4N0ih/xMqApmsGnBeQ4NR?=
 =?us-ascii?q?QBUHKf+eS8073j5lH5TK9Ojv0xjqbWqpTaKtkcpq68GQBV04Aj5w6+Dzegzt?=
 =?us-ascii?q?sYgWEKIVZYdB6dkoTkOE/CLOrlAfq+g1mgiipnyvHeMr3kGJrNL3zDkLn7fb?=
 =?us-ascii?q?Z67k5R0AQzwspE6JJaEbwBO/HzW0/3tNPGEh81KRe7zPj/BNVnyoweQX6PAr?=
 =?us-ascii?q?OeMK7KqV+H/PkgI+2LZIIOvjbyNeQl5/DvjX89hV8SY7Op0YEQaHCiEfRsO1?=
 =?us-ascii?q?+Zbmb0gtcdDWcKuRIzTO/wh1KfVT5ceWq9Urk65j4lFIKmA4bDRoSxgLOfxi?=
 =?us-ascii?q?e3BJpWZnpJClqUC3fna52EW+sQaCKVOsJhnDIFWKO6S489zxGusBH1y7x9Iu?=
 =?us-ascii?q?XJ5CISrYjj28Rt5+3PiREy8iR5D8KD3GGRQWF0n2cIRyMo06BluEBy10mM0b?=
 =?us-ascii?q?ZmjPxcDtFT+fxJXRkgNZLGzOx1FcryWgTfcdeNUlqmRc+mAT4pRNIr39AOe1?=
 =?us-ascii?q?p9G8mljh3bwyWqBKUVmKKXBJMq6K3c2mP8J8BjxHba2qkhjl0mQtdROm28nK?=
 =?us-ascii?q?J/8BLTB4HRmUWDi6mqbbgc3DLK9Gqby2qBol1YXxNuXqXbRn0feETWosrj5k?=
 =?us-ascii?q?/YTL+hF64nMg1fxs6GMKdKbcfpjVpeTvf5JNvee36xm3u3BRuQyLODdpHle2?=
 =?us-ascii?q?sG0SXGC0gFkwYT8miaNQQkHSiuvTGWMDs7DVvlZ0TE9+RipnK/UkIuiQaQYA?=
 =?us-ascii?q?kp1LO5/hMerfqRV/0S2q4JomEmsTowVFii98nKEd6NoUxtcfZye9Q4tXlO32?=
 =?us-ascii?q?PQsURTJJGsIrpjjV1WJwp+tU3GzBZmDIhc18In+iB5hDFuIL6VhQsSPwiT2o?=
 =?us-ascii?q?r9b+Xa?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AEBQDUqy1f/xCltltgHgEBCxIMR4R?=
 =?us-ascii?q?cVF+NNZIskXoLAQEBAQEBAQEBJw0BAgQBAYRMgjklOBMCAwEBAQMCBQEBBgE?=
 =?us-ascii?q?BAQEBAQUEAYYPRYI3IoNRASMjgT8SgyYBglcptnCEEIUigUCBOIgfhQqBQT+?=
 =?us-ascii?q?BEYNOijQEjz0jpkKCbIMLhFl9kSYPIaANkiuhQ4F6TSAYgyQJRxkNnGhCMDc?=
 =?us-ascii?q?CBggBAQMJVwE9AZANAQE?=
X-IPAS-Result: =?us-ascii?q?A2AEBQDUqy1f/xCltltgHgEBCxIMR4RcVF+NNZIskXoLA?=
 =?us-ascii?q?QEBAQEBAQEBJw0BAgQBAYRMgjklOBMCAwEBAQMCBQEBBgEBAQEBAQUEAYYPR?=
 =?us-ascii?q?YI3IoNRASMjgT8SgyYBglcptnCEEIUigUCBOIgfhQqBQT+BEYNOijQEjz0jp?=
 =?us-ascii?q?kKCbIMLhFl9kSYPIaANkiuhQ4F6TSAYgyQJRxkNnGhCMDcCBggBAQMJVwE9A?=
 =?us-ascii?q?ZANAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 07 Aug 2020 21:31:24 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/3 linux-next] selftests: netfilter: add checktool function
Date:   Fri,  7 Aug 2020 21:31:11 +0200
Message-Id: <20200807193111.12625-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

avoid repeating the same test for different toolcheck

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 .../selftests/netfilter/nft_flowtable.sh      | 33 +++++++------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index d3e0809ab3681..68a183753c6c3 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -21,29 +21,18 @@ ns2out=""
 
 log_netns=$(sysctl -n net.netfilter.nf_log_all_netns)
 
-nft --version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without nft tool"
-	exit $ksft_skip
-fi
-
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
-
-which nc > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without nc (netcat)"
-	exit $ksft_skip
-fi
+checktool (){
+	$1 > /dev/null 2>&1
+	if [ $? -ne 0 ];then
+		echo "SKIP: Could not $2"
+		exit $ksft_skip
+	fi
+}
 
-ip netns add nsr1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace"
-	exit $ksft_skip
-fi
+checktool "nft --version" "run test without nft tool"
+checktool "ip -Version" "run test without ip tool"
+checktool "which nc" "run test without nc (netcat)"
+checktool "ip netns add nsr1" "create net namespace"
 
 ip netns add ns1
 ip netns add ns2
-- 
2.27.0

