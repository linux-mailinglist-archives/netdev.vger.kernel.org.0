Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E0E465C2B
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 03:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350100AbhLBCdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 21:33:49 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38602 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1348605AbhLBCds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 21:33:48 -0500
IronPort-Data: =?us-ascii?q?A9a23=3AfmFwEK8PV/iXO2rP7mm0DrUDJXyTJUtcMsCJ2f8?=
 =?us-ascii?q?bfWQNrUok0TUPy2NLWzvSbKyCZTP1c9x/Otuy90MD7JOGmodjTVdlrnsFo1Bi8?=
 =?us-ascii?q?5ScXYvDRqvT04J+FuWaFQQ/qZx2huDodKjYdVeB4EfyWlTdhSMkj/jRHOKlULW?=
 =?us-ascii?q?s1h1ZHmeIdg9w0HqPpMZp2uaEsfDha++8kYuaT//3YTdJ6BYoWo4g0J9vnTs01?=
 =?us-ascii?q?BjEVJz0iXRlDRxDlAe2e3D4l/vzL4npR5fzatE88uJX24/+IL+FEmPxp3/BC/u?=
 =?us-ascii?q?ulPD1b08LXqXPewOJjxK6WYD72l4b+HN0if19aZLwam8O49mNt9Rw2tVMt525T?=
 =?us-ascii?q?y8nI6/NhP8AFRJfFkmSOIUfoe+ceSPk7Jf7I0ruNiGEL+9VJE0/I4Ad0up+H2x?=
 =?us-ascii?q?L8fsWNHYLYwzrr+6tybK2UO9EicEqLc2tN4Qa0llj0DvQJfUrW5bOR+PN/9Aw9?=
 =?us-ascii?q?Cwwm8lONfXTfcwUbXxodhuoSxlOPEoHTZEzhuGlglHhfDBC7lGYv6w65y7U1gM?=
 =?us-ascii?q?Z+LzsNsfFP9+RSMFbgkuDukrY8GnjRBIXLtqSzXyC6H3ErunCgS/2RqoMG7Cis?=
 =?us-ascii?q?P1nmluewioUEhJ+aLcRiZFVkWbnA5QGdRNSoXFo8MAPGIWQZoGVd3WFTLSs53b?=
 =?us-ascii?q?wg+ZtLtA=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A6NrPAazyMCwUc9Z3eKy0KrPwEL1zdoMgy1kn?=
 =?us-ascii?q?xilNoH1uA6ilfqWV8cjzuiWbtN9vYhsdcLy7WZVoIkmskKKdg7NhXotKNTOO0A?=
 =?us-ascii?q?SVxepZnOnfKlPbexHWx6p00KdMV+xEAsTsMF4St63HyTj9P9E+4NTvysyVuds?=
 =?us-ascii?q?=3D?=
X-IronPort-AV: E=Sophos;i="5.87,280,1631548800"; 
   d="scan'208";a="118303353"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 02 Dec 2021 10:30:25 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 9EDD94D13BC1;
        Thu,  2 Dec 2021 10:30:24 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 2 Dec 2021 10:30:25 +0800
Received: from FNSTPC.g08.fujitsu.local (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Thu, 2 Dec 2021 10:30:24 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <shuah@kernel.org>,
        <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Li Zhijian <lizhijian@cn.fujitsu.com>
Subject: [PATCH v2 2/2] selftests: add option to list all available tests
Date:   Thu, 2 Dec 2021 10:29:54 +0800
Message-ID: <20211202022954.23545-2-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211202022954.23545-1-lizhijian@cn.fujitsu.com>
References: <20211202022954.23545-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 9EDD94D13BC1.AE47F
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

$ ./fcnal-test.sh -l
Test names: ipv4_ping ipv4_tcp ipv4_udp ipv4_bind ipv4_runtime ipv4_netfilter
ipv6_ping ipv6_tcp ipv6_udp ipv6_bind ipv6_runtime ipv6_netfilter
use_cases

Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 5cb59947eed2..7e78be99aa4c 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -3993,6 +3993,7 @@ usage: ${0##*/} OPTS
 	-4          IPv4 tests only
 	-6          IPv6 tests only
 	-t <test>   Test name/set to run
+	-l          List all available tests
 	-p          Pause on fail
 	-P          Pause after each test
 	-v          Be verbose
@@ -4006,10 +4007,15 @@ TESTS_IPV4="ipv4_ping ipv4_tcp ipv4_udp ipv4_bind ipv4_runtime ipv4_netfilter"
 TESTS_IPV6="ipv6_ping ipv6_tcp ipv6_udp ipv6_bind ipv6_runtime ipv6_netfilter"
 TESTS_OTHER="use_cases"
 
+list()
+{
+	echo "Test names: $TESTS_IPV4 $TESTS_IPV6 $TESTS_OTHER"
+}
+
 PAUSE_ON_FAIL=no
 PAUSE=no
 
-while getopts :46t:pPvh o
+while getopts :46lt:pPvh o
 do
 	case $o in
 		4) TESTS=ipv4;;
@@ -4018,6 +4024,7 @@ do
 		p) PAUSE_ON_FAIL=yes;;
 		P) PAUSE=yes;;
 		v) VERBOSE=1;;
+		l) list; exit 0;;
 		h) usage; exit 0;;
 		*) usage; exit 1;;
 	esac
-- 
2.33.0



