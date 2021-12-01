Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96736464C7B
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 12:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbhLALXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 06:23:13 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:20217 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231332AbhLALXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 06:23:12 -0500
IronPort-Data: =?us-ascii?q?A9a23=3A8CazuqBuK2sqQxVW/4zhw5YqxClBgxIJ4g17XOL?=
 =?us-ascii?q?fUAXqgDkj0WBTzzAYUGzVPvjfZGWjL9klPITl80MDvJGAx9UxeLYW3SszFioV8?=
 =?us-ascii?q?6IpJjg4wn/YZnrUdouaJK5ex512huLocYZkERcwmj/3auK49CMkjPnRLlbBILW?=
 =?us-ascii?q?s1h5ZFFYMpBgJ2UoLd94R2uaEsPDha++/kYqaT/73ZDdJ7wVJ3lc8sMpvnv/AU?=
 =?us-ascii?q?MPa41v0tnRmDRxCUcS3e3M9VPrzLonpR5f0rxU9IwK0ewrD5OnREmLx9BFrBM6?=
 =?us-ascii?q?nk6rgbwsBRbu60Qqm0yIQAvb9xEMZ4HFaPqUTbZLwbW9TiieJntJwwdNlu4GyS?=
 =?us-ascii?q?BsyI+vHn+F1vxxwSnguZ/IYoeOdSZS4mYnJp6HcSFPgyutjCWk6NJMV/+JwD30?=
 =?us-ascii?q?I8/EEQBgBdRmDiviw6L2+Q+howM8kKaHDP54Vs1ljwCvfAPJgRorMK43R5cJR3?=
 =?us-ascii?q?B8zi9pIEPKYYNAWARJrbRLdc1hMN00RBZYWguilnD/8fidepVbTorA4i0DXzQp?=
 =?us-ascii?q?swP3uK9fRdMCHXtl9gEmVvCTF8n7/DxVcM8aQoRKD/26gi/Hngyz2QsQRGae++?=
 =?us-ascii?q?/osh0ecrlH/ojV+uUCT+KH/0xDhHYkEbRF8x8bnloBqnGTDczU3d0TQTKa4gyM?=
 =?us-ascii?q?h?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3Ak3v3zapLx5LivReFk/+A9x4aV5pOeYIsimQD?=
 =?us-ascii?q?101hICG9E/b5qynAppkmPHPP4gr5O0tApTnjAsa9qBrnnPYf3WB4B8bAYOCMgg?=
 =?us-ascii?q?eVxe9Zg7ff/w=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.87,278,1631548800"; 
   d="scan'208";a="118276142"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 01 Dec 2021 19:19:48 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 057704D13A00;
        Wed,  1 Dec 2021 19:19:44 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Wed, 1 Dec 2021 19:19:42 +0800
Received: from FNSTPC.g08.fujitsu.local (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Wed, 1 Dec 2021 19:19:43 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <shuah@kernel.org>,
        <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Li Zhijian <lizhijian@cn.fujitsu.com>
Subject: [PATCH v2 2/3] selftests: add option to list all available tests
Date:   Wed, 1 Dec 2021 19:17:59 +0800
Message-ID: <20211201111759.14613-1-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211201111025.13834-2-lizhijian@cn.fujitsu.com>
References: <20211201111025.13834-2-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 057704D13A00.AAD08
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
2.32.0



