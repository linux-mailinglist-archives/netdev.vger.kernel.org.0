Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D879F48E2C7
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 04:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238949AbiANDDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 22:03:15 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:1834 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S238933AbiANDDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 22:03:15 -0500
IronPort-Data: =?us-ascii?q?A9a23=3AUYJBQq8g/E+//RGT351kDrUDJXyTJUtcMsCJ2f8?=
 =?us-ascii?q?bfWQNrUp212ZRmzEXUGuFO6yPNGTycoh+Ptu2/EgF7cfWnNM3HVdlrnsFo1Bi8?=
 =?us-ascii?q?5ScXYvDRqvT04J+FuWaFQQ/qZx2huDodKjYdVeB4Ef9WlTdhSMkj/vQH+OgULe?=
 =?us-ascii?q?s1h1ZHmeIdg9w0HqPpMZp2uaEsfDha++8kYuaT//3YTdJ6BYoWo4g0J9vnTs01?=
 =?us-ascii?q?BjEVJz0iXRlDRxDlAe2e3D4l/vzL4npR5fzatE88uJX24/+IL+FEmPxp3/BC/u?=
 =?us-ascii?q?ulPD1b08LXqXPewOJjxK6WYD72l4b+HN0if19aZLwam8O49mNt9Rw2tVMt525T?=
 =?us-ascii?q?y8nI6/NhP8AFRJfFkmSOIUfouecfSbm75H7I0ruNiGEL+9VJE0/I4Ad0up+H2x?=
 =?us-ascii?q?L8fsWNHYLYwzrr+6tybK2UO9EicEqLc2tN4Qa0llj0DvQJfUrW5bOR+PN/9Aw9?=
 =?us-ascii?q?Cwwm8lONfXTfcwUbXxodhuoSxlOPEoHTZEzhuGlglHhfDBC7lGYv6w65y7U1gM?=
 =?us-ascii?q?Z+LzsNsfFP9+RSMFbgkuDukrY8GnjRBIXLtqSzXyC6H3ErunCgS/2RqoMG7Cis?=
 =?us-ascii?q?P1nmluewioUEhJ+aLcRiZFVkWbnA5QGdRNSoXFo8MAPGIWQZoGVd3WFTLSs53b?=
 =?us-ascii?q?wg+ZtLtA=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AnfT3VKgygfGuYF2TURVsRKUWnHBQXjIji2hC?=
 =?us-ascii?q?6mlwRA09TySZ//rBoB19726RtN9xYgBGpTnuAsm9qB/nmaKdgrNhWItKPjOW21?=
 =?us-ascii?q?dARbsKheCJrgEIcBeeygcy78hdmtBFeb/N5EZB/L3HyTj9A9A928OG7aztoe/f?=
 =?us-ascii?q?yk1mRQZsZ7oI1XYBNi+rVl1xWBJdBYc0UL6V5s98rTKmfngNKuuhAH1tZZm6m/?=
 =?us-ascii?q?T70ILhfQUdBwMqrC2HjTaT4rb8FBSCmjcyOgk/p4sfzQ=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,287,1635177600"; 
   d="scan'208";a="120346165"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 14 Jan 2022 11:03:13 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 472024D15A4C;
        Fri, 14 Jan 2022 11:03:11 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 14 Jan 2022 11:03:12 +0800
Received: from FNSTPC.g08.fujitsu.local (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 14 Jan 2022 11:03:11 +0800
From:   Li Zhijian <lizhijian@fujitsu.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <shuah@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Li Zhijian <lizhijian@fujitsu.com>,
        "David Ahern" <dsahern@gmail.com>
Subject: [PATCH v2] kselftests/net: list all available tests in usage()
Date:   Fri, 14 Jan 2022 11:02:46 +0800
Message-ID: <20220114030246.4437-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 472024D15A4C.AB7A2
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So that users can run/query them easily.

$ ./fcnal-test.sh -h
usage: fcnal-test.sh OPTS

	-4          IPv4 tests only
	-6          IPv6 tests only
	-t <test>   Test name/set to run
	-p          Pause on fail
	-P          Pause after each test
	-v          Be verbose

Tests:
	ipv4_ping ipv4_tcp ipv4_udp ipv4_bind ipv4_runtime ipv4_netfilter ipv6_ping ipv6_tcp ipv6_udp ipv6_bind ipv6_runtime ipv6_netfilter use_cases

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 412d85205546..3f4c8cfe7aca 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -4059,6 +4059,9 @@ usage: ${0##*/} OPTS
 	-p          Pause on fail
 	-P          Pause after each test
 	-v          Be verbose
+
+Tests:
+	$TESTS_IPV4 $TESTS_IPV6 $TESTS_OTHER
 EOF
 }
 
-- 
2.33.0



