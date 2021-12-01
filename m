Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87895464C5D
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 12:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348857AbhLALO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 06:14:27 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13691 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230407AbhLALO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 06:14:27 -0500
IronPort-Data: =?us-ascii?q?A9a23=3AJ3L3raN2ZYdhVTvvrR0AlcFynXyQoLVcMsFnjC/?=
 =?us-ascii?q?WdQft029w1TJSyGAdUW+HMvveZWrzL9tya4/j8kwE6MLdm99gGjLY11k3ESsS9?=
 =?us-ascii?q?pCt6fd1j6vIF3rLaJWFFSqL1u1GAjX7BJ1yHiC0SiuFaOC79CAmjfjQH9IQNca?=
 =?us-ascii?q?fUsxPbV49IMseoUI78wIJqtYAbemRW2thi/uryyHsEAPNNwpPD44hw/nrRCWDE?=
 =?us-ascii?q?xjFkGhwUlQWPZintbJF/pUfJMp3yaqZdxMUTmTId9NWSdovzJnhlo/Y1xwrTN2?=
 =?us-ascii?q?4kLfnaVBMSbnXVeSMoiMOHfH83V4Z/Wpvuko4HKN0hUN/jzSbn9FzydxLnZKtS?=
 =?us-ascii?q?wY1JbCKk+MYO/VdO3gnbfcZpe6eeRBTtuTWlSUqaUDEz/xwAUQeMYQG9+NzBm9?=
 =?us-ascii?q?Ss/oVNFglYguKh++sxpq0T+BtgoIoK8yDFIACsHhIzjzDC/siB5fZTM3i/t9F1?=
 =?us-ascii?q?TcYhc1UG/vaIc0DZlJHaBXGfg0KOVoNDp86tPmni2O5cDBCrl+R460t7AD7yA1?=
 =?us-ascii?q?3zaioM8HYftKWSN5JtliXq3iA/GnjBBwectuFxlKt9H+wiuLRtT30VZhUF7Ci8?=
 =?us-ascii?q?PNuxlqJyQQu5Lc+PbegiaDhzBfgBJQEcApJkhfCZJMarCSDJuQRlTXhyJJcgiM?=
 =?us-ascii?q?hZg=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AAHC/kqHeofe77q3qpLqEhseALOsnbusQ8zAX?=
 =?us-ascii?q?PiFKKCC9Hfb1qynDpp8mPHzP5gr5OktOpTnoAsDpfZq2z/NICOcqV4ufYA=3D?=
 =?us-ascii?q?=3D?=
X-IronPort-AV: E=Sophos;i="5.87,278,1631548800"; 
   d="scan'208";a="118275910"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 01 Dec 2021 19:11:04 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 96A7F4D139FF;
        Wed,  1 Dec 2021 19:11:03 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Wed, 1 Dec 2021 19:11:02 +0800
Received: from FNSTPC.g08.fujitsu.local (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Wed, 1 Dec 2021 19:11:03 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <shuah@kernel.org>,
        <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Li Zhijian <lizhijian@cn.fujitsu.com>
Subject: [PATCH 1/3] selftest: net: Correct case name
Date:   Wed, 1 Dec 2021 19:10:23 +0800
Message-ID: <20211201111025.13834-1-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 96A7F4D139FF.AFE2A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipv6_addr_bind/ipv4_addr_bind are function name.

Fixes: 34d0302ab86 ("selftests: Add ipv6 address bind tests to fcnal-test")
Fixes: 75b2b2b3db4 ("selftests: Add ipv4 address bind tests to fcnal-test")
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
2.32.0



