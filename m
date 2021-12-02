Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC122465C26
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 03:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237707AbhLBCcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 21:32:42 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12354 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231411AbhLBCcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 21:32:41 -0500
IronPort-Data: =?us-ascii?q?A9a23=3A0x9mYKyDt1AQiu22OEd6t+eSxCrEfRIJ4+MujC/?=
 =?us-ascii?q?XYbTApGwqgTdUzmQaDzyEOKzbM2L0eN1xb43kox4C65bRnNM2HQtv/xmBbVoQ9?=
 =?us-ascii?q?5OdWo7xwmQcns+qBpSaChohtq3yU/GYRCwPZiKa9kjF3oTJ9yEmjPjSHuOkU4Y?=
 =?us-ascii?q?oBwgqLeNaYHZ44f5cs75h6mJYqYDR7zKl4bsekeWGULOW82Ic3lYv1k62gEgHU?=
 =?us-ascii?q?MIeF98vlgdWifhj5DcynpSOZX4VDfnZw3DQGuG4EgMmLtsvwo1V/kuBl/ssIti?=
 =?us-ascii?q?j1LjmcEwWWaOUNg+L4pZUc/H6xEEc+WppieBmXBYfQR4/ZzGhm9FjyNRPtJW2Y?=
 =?us-ascii?q?Qk0PKzQg/lbWB5de817FfQfqOSfeiPn7aR/yGWDKRMA2c5GAEgoMIgw9u9pDGR?=
 =?us-ascii?q?K8vIEbjYAcniri/m/wL+hTMFjg80iKI/gO4Z3knJ9xzjxDvs8R53HBaLQ6rdwx?=
 =?us-ascii?q?zctj8BmHvvEYccdLz11Y3zoZxxJJ0dSC58kmuqsrmfwficeq1+Po6czpW/Jw2R?=
 =?us-ascii?q?Z1LnrLcqQeceHQctJk12EjnzJ8n6/ARwAMtGbjz2f/RqEgOLTkS7lcJwdGaf+9?=
 =?us-ascii?q?fNwhlCXgGsJB3UrufGTyRWiohfmHYsBdApPoWxzxZXePXeDFrHVNyBUalbd1vL?=
 =?us-ascii?q?EZ+dtLg=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3Aa4jTOKM3yJKG9cBcTv2jsMiBIKoaSvp037BL?=
 =?us-ascii?q?7TEUdfUxSKGlfq+V8sjzqiWftN98YhAdcLO7Scy9qBHnhP1ICOAqVN/MYOCMgh?=
 =?us-ascii?q?rLEGgN1+vf6gylMyj/28oY7q14bpV5YeeaMXFKyer8/ym0euxN/OW6?=
X-IronPort-AV: E=Sophos;i="5.87,280,1631548800"; 
   d="scan'208";a="118303304"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 02 Dec 2021 10:29:16 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 9DB8D4D13BC0;
        Thu,  2 Dec 2021 10:29:14 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 2 Dec 2021 10:29:15 +0800
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 2 Dec 2021 10:29:14 +0800
Received: from FNSTPC.g08.fujitsu.local (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Thu, 2 Dec 2021 10:29:14 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <shuah@kernel.org>,
        <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Li Zhijian <lizhijian@cn.fujitsu.com>
Subject: [PATCH v2] selftests: net: Correct case name
Date:   Thu, 2 Dec 2021 10:28:41 +0800
Message-ID: <20211202022841.23248-1-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 9DB8D4D13BC0.AF1C1
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipv6_addr_bind/ipv4_addr_bind are function names. Previously, bind test
would not be run by default due to the wrong case names

Fixes: 34d0302ab861 ("selftests: Add ipv6 address bind tests to fcnal-test")
Fixes: 75b2b2b3db4c ("selftests: Add ipv4 address bind tests to fcnal-test")
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 3313566ce906..7f5b265fcb90 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -4002,8 +4002,8 @@ EOF
 ################################################################################
 # main
 
-TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_addr_bind ipv4_runtime ipv4_netfilter"
-TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_addr_bind ipv6_runtime ipv6_netfilter"
+TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_bind ipv4_runtime ipv4_netfilter"
+TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_bind ipv6_runtime ipv6_netfilter"
 TESTS_OTHER="use_cases"
 
 PAUSE_ON_FAIL=no
-- 
2.33.0



