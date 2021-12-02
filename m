Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F368465C2E
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 03:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352074AbhLBCd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 21:33:58 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38602 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1349878AbhLBCdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 21:33:50 -0500
IronPort-Data: =?us-ascii?q?A9a23=3A4iYuf6Pj5YbMvOTvrR0AlcFynXyQoLVcMsFnjC/?=
 =?us-ascii?q?WdQS4gjt30jEDnzZOCj+Ab/ffYGWkKd1/YdvipENTu5SHm99gGjLY11k3ESsS9?=
 =?us-ascii?q?pCt6fd1j6vIF3rLaJWFFSqL1u1GAjX7BJ1yHiC0SiuFaOC79CAmjfjQHdIQNca?=
 =?us-ascii?q?fUsxPbV49IMseoUI78wIJqtYAbemRW2thi/uryyHsEAPNNwpPD44hw/nrRCWDE?=
 =?us-ascii?q?xjFkGhwUlQWPZintbJF/pUfJMp3yaqZdxMUTmTId9NWSdovzJnhlo/Y1xwrTN2?=
 =?us-ascii?q?4kLfnaVBMSbnXVeSMoiMOHfH83V4Z/Wpvuko4HKN0hUN/jzSbn9FzydxLnZKtS?=
 =?us-ascii?q?wY1JbCKk+MYO/VdO3gnbfYeo+SafRBTtuTWlSUqaUDEz/xwAUQeMYQG9+NzBm9?=
 =?us-ascii?q?Ss/oVNFglYguKh++sxpq0T+BtgoIoK8yDFIACsHhIzjzDC/siB5fZTM3i/t9F1?=
 =?us-ascii?q?TcYhc1UG/vaIc0DZlJHaBXGfg0KOVoNDp86tPmni2O5cDBCrl+R460t7AD7yA1?=
 =?us-ascii?q?3zaioM8HYftKWSN5JtliXq3iA/GnjBBwectuFxlKt9H+wiuLRtT30VZhUF7Ci8?=
 =?us-ascii?q?PNuxlqJyQQu5Lc+PbegiaDhzBfgBJQEcApJkhfCZJMarCSDJuQRlTXiyJJcgiM?=
 =?us-ascii?q?hZg=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3ABanCzalK8cAjLOvvMqKfaHWnVEjpDfIQ3DAb?=
 =?us-ascii?q?v31ZSRFFG/Fw9vre+MjzsCWYtN9/Yh8dcK+7UpVoLUm8yXcX2/h1AV7BZniEhI?=
 =?us-ascii?q?LAFugLgrcKqAeQeREWmNQ86Y5QN4B6CPDVSWNxlNvG5mCDeOoI8Z2q97+JiI7l?=
 =?us-ascii?q?o0tQcQ=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.87,280,1631548800"; 
   d="scan'208";a="118303354"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 02 Dec 2021 10:30:25 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id B8B644D13BC0;
        Thu,  2 Dec 2021 10:30:23 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 2 Dec 2021 10:30:22 +0800
Received: from FNSTPC.g08.fujitsu.local (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Thu, 2 Dec 2021 10:30:23 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <shuah@kernel.org>,
        <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Li Zhijian <lizhijian@cn.fujitsu.com>
Subject: [PATCH v2 1/2] selftests: net: remove meaningless help option
Date:   Thu, 2 Dec 2021 10:29:53 +0800
Message-ID: <20211202022954.23545-1-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: B8B644D13BC0.AD59F
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

$ ./fcnal-test.sh -t help
Test names: help

Looks it intent to list the available tests but it didn't do the right
thing. I will add another option the do that in the later patch.

Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 7f5b265fcb90..5cb59947eed2 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -4068,8 +4068,6 @@ do
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
 	vrf_setup)	 setup "yes"; exit 0;;
-
-	help)            echo "Test names: $TESTS"; exit 0;;
 	esac
 done
 
-- 
2.33.0



