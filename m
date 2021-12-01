Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA5F464C61
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 12:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348869AbhLALOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 06:14:52 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13701 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1348865AbhLALOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 06:14:51 -0500
IronPort-Data: =?us-ascii?q?A9a23=3A2ocnmKzqS1Svkxxn8Xd6t+eSxCrEfRIJ4+MujC/?=
 =?us-ascii?q?XYbTApG4i0WAPz2ccUDvXM/reYjH0eNF1at+3ox4A78PVzYRrHQtv/xmBbVoQ9?=
 =?us-ascii?q?5OdWo7xwmQcns+qBpSaChohtq3yU/GYRCwPZiKa9kjF3oTJ9yEmjPjSHuOkUYY?=
 =?us-ascii?q?oBwgqLeNaYHZ44f5cs75h6mJYqYDR7zKl4bsekeWGULOW82Ic3lYv1k62gEgHU?=
 =?us-ascii?q?MIeF98vlgdWifhj5DcynpSOZX4VDfnZw3DQGuG4EgMmLtsvwo1V/kuBl/ssIti?=
 =?us-ascii?q?j1LjmcEwWWaOUNg+L4pZUc/H6xEEc+WppieBmXBYfQR4/ZzGhm9FjyNRPtJW2Y?=
 =?us-ascii?q?Qk0PKzQg/lbWB5de817FfQfqOWYfCnl6qR/yGWDKRMA2c5GAEgoMIgw9u9pDGR?=
 =?us-ascii?q?K8vIEbjYAcniri/m/wL+hTMFjg80iKI/gO4Z3knJ9xzjxDvs8R53HBaLQ6rdwx?=
 =?us-ascii?q?zctj8BmHvvEYccdLz11Y3zoZxxJJ0dSC58kmuqsrmfwficeq1+Po6czpW/Jw2R?=
 =?us-ascii?q?Z1LnrLcqQeceHQctJk12EjnzJ8n6/ARwAMtGbjz2f/RqEgOLTkS7lcJwdGaf+9?=
 =?us-ascii?q?fNwhlCXgGsJB3UrufGTyRWiohfmHYsBdApPoWxzxZXePXeDFrHVNyBUalbd1vL?=
 =?us-ascii?q?EZ+dtLg=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3Anm+VtqOnCLbCd8BcTq+jsMiBIKoaSvp037BL?=
 =?us-ascii?q?7SFMoHNuHvBw+/rEoB1573HJYVQqN03I8OroUJVoKkmwyXca2+MsAYs=3D?=
X-IronPort-AV: E=Sophos;i="5.87,278,1631548800"; 
   d="scan'208";a="118275923"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 01 Dec 2021 19:11:29 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 38C194D139FD;
        Wed,  1 Dec 2021 19:11:25 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Wed, 1 Dec 2021 19:11:25 +0800
Received: from FNSTPC.g08.fujitsu.local (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Wed, 1 Dec 2021 19:11:04 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <shuah@kernel.org>,
        <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Li Zhijian <lizhijian@cn.fujitsu.com>
Subject: [PATCH 2/3] selftests: add option to list all avaliable tests
Date:   Wed, 1 Dec 2021 19:10:24 +0800
Message-ID: <20211201111025.13834-2-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211201111025.13834-1-lizhijian@cn.fujitsu.com>
References: <20211201111025.13834-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 38C194D139FD.AEF84
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
index 7f5b265fcb90..9111b8952ac8 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -3993,6 +3993,7 @@ usage: ${0##*/} OPTS
 	-4          IPv4 tests only
 	-6          IPv6 tests only
 	-t <test>   Test name/set to run
+	-l          List all avaible tests
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
2.32.0



