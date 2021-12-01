Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CE4464C63
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 12:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348881AbhLALOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 06:14:54 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13701 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230003AbhLALOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 06:14:53 -0500
IronPort-Data: =?us-ascii?q?A9a23=3AWJZJqqCx+WFzfRVW/4zhw5YqxClBgxIJ4g17XOL?=
 =?us-ascii?q?fUAXt1Wt30jQEyDYbXjqEPq2LNmShfYx0bYuy8ExV6JWAx9UxeLYW3SszFioV8?=
 =?us-ascii?q?6IpJjg4wn/YZnrUdouaJK5ex512huLocYZkERcwmj/3auK49CMkjPnRLlbBILW?=
 =?us-ascii?q?s1h5ZFFYMpBgJ2UoLd94R2uaEsPDha++/kYqaT/73ZDdJ7wVJ3lc8sMpvnv/AU?=
 =?us-ascii?q?MPa41v0tnRmDRxCUcS3e3M9VPrzLonpR5f0rxU9IwK0ewrD5OnREmLx9BFrBM6?=
 =?us-ascii?q?nk6rgbwsBRbu60Qqm0yIQAvb9xEMZ4HFaPqUTbZLwbW9TiieJntJwwdNlu4GyS?=
 =?us-ascii?q?BsyI+vHn+F1vxxwSnguZ/IbqeWbSZS4mYnJp6HcSFPgyutjCWk6NJMV/+JwD30?=
 =?us-ascii?q?I8/EEQBgBdRmDiviw6L2+Q+howM8kKaHDP54Vs1ljwCvfAPJgRorMK43R5cJR3?=
 =?us-ascii?q?B8zi9pIEPKYYNAWARJrbRLdc1hMN00RBZYWguilnD/8fidepVbTorA4i0DXzQp?=
 =?us-ascii?q?swP3uK9fRdMCHXtl9gEmVvCTF8n7/DxVcM8aQoRKD/26gi/Hngyz2QsQRGae++?=
 =?us-ascii?q?/osh0ecrlH/ojV+uUCT+KH/0xDhHYkEbRF8x8bnloBqnGTDczU3d0fQTKa4gyM?=
 =?us-ascii?q?h?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AjowFPa9AWfju6Xy+yi9uk+C2I+orL9Y04lQ7?=
 =?us-ascii?q?vn2ZKCY1TiX2rayTdZggviMc6wx+ZJhDo7+90cC7KBvhHPVOjLX5U43JYDXb?=
X-IronPort-AV: E=Sophos;i="5.87,278,1631548800"; 
   d="scan'208";a="118275924"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 01 Dec 2021 19:11:29 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id B6AEF4D13A00;
        Wed,  1 Dec 2021 19:11:25 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Wed, 1 Dec 2021 19:11:26 +0800
Received: from FNSTPC.g08.fujitsu.local (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Wed, 1 Dec 2021 19:11:25 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <shuah@kernel.org>,
        <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Li Zhijian <lizhijian@cn.fujitsu.com>
Subject: [PATCH 3/3] selftest: net: remove meaningless help option
Date:   Wed, 1 Dec 2021 19:10:25 +0800
Message-ID: <20211201111025.13834-3-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211201111025.13834-1-lizhijian@cn.fujitsu.com>
References: <20211201111025.13834-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: B6AEF4D13A00.AFDBA
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

$ ./fcnal-test.sh -t help
Test names: help

Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 9111b8952ac8..a4d86862764d 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -4075,8 +4075,6 @@ do
 	# setup namespaces and config, but do not run any tests
 	setup)		 setup; exit 0;;
 	vrf_setup)	 setup "yes"; exit 0;;
-
-	help)            echo "Test names: $TESTS"; exit 0;;
 	esac
 done
 
-- 
2.32.0



