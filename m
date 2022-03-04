Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEA14CDDDE
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiCDUEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiCDUD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:03:58 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702F223587E
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 11:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423936; x=1677959936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n0a7Bdid3bZzhZq3B9V6fr1g8ODVox60Jnhrg0u4Tgw=;
  b=f1qDFIxXHG/UX4OHSQ/nwZeYM66Oe/OX6u+oSzaPdCiTzgSHTLn9Z8RH
   XDmrOFTduSm7jFJT5YLWqT+adUoEC9dYOaA9GooxTlfzu99UUp5zrN3Zs
   FjZLlTEH8KXFUPtE4iVEJCb29Zann7wMeTkFrMuLZnuvZKEHtHfg47X3s
   HT7/RfH4WbEw5VMcFs34U6TdxYwYbuPYpR20gSK6O6Gd/i+stGaLRKLBl
   dlE3LyA+s+IbrqdKp/x6Fybp8/FFtgngNk3V34GSyAl5rp6WezRv0gfVI
   wnkJ6EZ1g/c/ZKymcA2TpedLLu3N02vqqWhcNA9tkMg/AdNz9UDKj7dML
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253981330"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253981330"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:43 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552340777"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.225.124])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:36:42 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 01/11] selftests: mptcp: adjust output alignment for more tests
Date:   Fri,  4 Mar 2022 11:36:26 -0800
Message-Id: <20220304193636.219315-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
References: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

The number of self tests in mptcp_join.sh will soon be more than 100, the
output alignment is no longer OK. This patch adjusted it.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 77b359a49a47..88740cfe49dd 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -20,6 +20,7 @@ do_all_tests=1
 init=0
 
 TEST_COUNT=0
+nr_blank=40
 
 # generated using "nfbpf_compile '(ip && (ip[54] & 0xf0) == 0x30) ||
 #				  (ip6 && (ip6[74] & 0xf0) == 0x30)'"
@@ -732,9 +733,9 @@ chk_csum_nr()
 	local dump_stats
 
 	if [ ! -z "$msg" ]; then
-		printf "%02u" "$TEST_COUNT"
+		printf "%03u" "$TEST_COUNT"
 	else
-		echo -n "  "
+		echo -n "   "
 	fi
 	printf " %-36s %s" "$msg" "sum"
 	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtDataCsumErr | awk '{print $2}'`
@@ -766,7 +767,7 @@ chk_fail_nr()
 	local count
 	local dump_stats
 
-	printf "%-39s %s" " " "ftx"
+	printf "%-${nr_blank}s %s" " " "ftx"
 	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMPFailTx | awk '{print $2}'`
 	[ -z "$count" ] && count=0
 	if [ "$count" != "$mp_fail_nr_tx" ]; then
@@ -801,7 +802,7 @@ chk_join_nr()
 	local dump_stats
 	local with_cookie
 
-	printf "%02u %-36s %s" "$TEST_COUNT" "$msg" "syn"
+	printf "%03u %-36s %s" "$TEST_COUNT" "$msg" "syn"
 	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMPJoinSynRx | awk '{print $2}'`
 	[ -z "$count" ] && count=0
 	if [ "$count" != "$syn_nr" ]; then
@@ -863,7 +864,7 @@ chk_stale_nr()
 	local stale_nr
 	local recover_nr
 
-	printf "%-39s %-18s" " " "stale"
+	printf "%-${nr_blank}s %-18s" " " "stale"
 	stale_nr=`ip netns exec $ns nstat -as | grep MPTcpExtSubflowStale | awk '{print $2}'`
 	[ -z "$stale_nr" ] && stale_nr=0
 	recover_nr=`ip netns exec $ns nstat -as | grep MPTcpExtSubflowRecover | awk '{print $2}'`
@@ -904,7 +905,7 @@ chk_add_nr()
 
 	timeout=`ip netns exec $ns1 sysctl -n net.mptcp.add_addr_timeout`
 
-	printf "%-39s %s" " " "add"
+	printf "%-${nr_blank}s %s" " " "add"
 	count=`ip netns exec $ns2 nstat -as MPTcpExtAddAddr | grep MPTcpExtAddAddr | awk '{print $2}'`
 	[ -z "$count" ] && count=0
 
@@ -941,7 +942,7 @@ chk_add_nr()
 			echo "[ ok ]"
 		fi
 
-		printf "%-39s %s" " " "syn"
+		printf "%-${nr_blank}s %s" " " "syn"
 		count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMPJoinPortSynRx |
 			awk '{print $2}'`
 		[ -z "$count" ] && count=0
@@ -980,7 +981,7 @@ chk_add_nr()
 			echo "[ ok ]"
 		fi
 
-		printf "%-39s %s" " " "syn"
+		printf "%-${nr_blank}s %s" " " "syn"
 		count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMismatchPortSynRx |
 			awk '{print $2}'`
 		[ -z "$count" ] && count=0
@@ -1030,7 +1031,7 @@ chk_rm_nr()
 		subflow_ns=$ns1
 	fi
 
-	printf "%-39s %s" " " "rm "
+	printf "%-${nr_blank}s %s" " " "rm "
 	count=`ip netns exec $addr_ns nstat -as | grep MPTcpExtRmAddr | awk '{print $2}'`
 	[ -z "$count" ] && count=0
 	if [ "$count" != "$rm_addr_nr" ]; then
@@ -1062,7 +1063,7 @@ chk_prio_nr()
 	local count
 	local dump_stats
 
-	printf "%-39s %s" " " "ptx"
+	printf "%-${nr_blank}s %s" " " "ptx"
 	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMPPrioTx | awk '{print $2}'`
 	[ -z "$count" ] && count=0
 	if [ "$count" != "$mp_prio_nr_tx" ]; then
@@ -1098,7 +1099,7 @@ chk_link_usage()
 	local tx_rate=$((tx_link * 100 / $tx_total))
 	local tolerance=5
 
-	printf "%-39s %-18s" " " "link usage"
+	printf "%-${nr_blank}s %-18s" " " "link usage"
 	if [ $tx_rate -lt $((expected_rate - $tolerance)) -o \
 	     $tx_rate -gt $((expected_rate + $tolerance)) ]; then
 		echo "[fail] got $tx_rate% usage, expected $expected_rate%"
-- 
2.35.1

