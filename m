Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C2B48D2D2
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 08:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiAMH3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 02:29:06 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44522 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230176AbiAMH3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 02:29:06 -0500
IronPort-Data: =?us-ascii?q?A9a23=3Auv5Ahq3c2ZxYqp1vjvbD5Vtzkn2cJEfYwER7XOP?=
 =?us-ascii?q?LsXnJ3D1z3jAEy2AaXGCEb/iOZ2Twc40nbo7n90IP68XUxtU2QQE+nZ1PZygU8?=
 =?us-ascii?q?JKaX7x1DatR0xu6d5SFFAQ+hyknQoGowPscEzmM9n9BDpC79SMmjfjRHeKlYAL?=
 =?us-ascii?q?5EnsZqTFMGX5JZS1Ly7ZRbr5A2bBVMivV0T/Ai5S31GyNh1aYBlkpB5er83uDi?=
 =?us-ascii?q?hhdVAQw5TTSbdgT1LPXeuJ84Jg3fcldJFOgKmVY83LTegrN8F251juxExYFAdX?=
 =?us-ascii?q?jnKv5c1ERX/jZOg3mZnh+AvDk20Yd4HdplPtT2Pk0MC+7jx2NnsJxyddMvJqYR?=
 =?us-ascii?q?xorP7HXhaIWVBww/yRWZPceo+eXfSTu2SCU5wicG5f2+N1iBV87OKUU8/h6BGV?=
 =?us-ascii?q?J++BeLj0RBjiAmui/6LG2UO9hgoIkNsaDFJgfp3hg5TLUF/ArRdbEWaqizdtZ2?=
 =?us-ascii?q?iogw8NDB/DTY+IHZjd1KhfNeRtCPhEQEp1WtOOpgGTvNj5DpVabuacs/0DNwwF?=
 =?us-ascii?q?rlrvgKtzYfpqNX8o9tkCVum7L4UznDRwAct+S0zyI9jSrnOCnoM9RcOr+D5Xhr?=
 =?us-ascii?q?rgz3gLVnTdVVXUruZKAiaHRoiaDtxh3cST4IhYTkJU=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3Ac4adv68JfVls0fRZO1Juk+DkI+orL9Y04lQ7?=
 =?us-ascii?q?vn2ZKCYlFvBw8vrCoB1173HJYUkqMk3I9ergBEDiewK4yXcW2/hzAV7KZmCP11?=
 =?us-ascii?q?dAR7sSj7cKrQeBJwTOssZZ1YpFN5N1EcDMCzFB5vrS0U2VFMkBzbC8nJyVuQ?=
 =?us-ascii?q?=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.88,284,1635177600"; 
   d="scan'208";a="120308449"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 13 Jan 2022 15:29:03 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id 13D9E4D15A4A;
        Thu, 13 Jan 2022 15:29:02 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 13 Jan 2022 15:29:03 +0800
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 13 Jan 2022 15:29:02 +0800
Received: from FNSTPC.g08.fujitsu.local (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Thu, 13 Jan 2022 15:29:02 +0800
From:   Li Zhijian <lizhijian@fujitsu.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <shuah@kernel.org>,
        <netdev@vger.kernel.org>
CC:     <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Li Zhijian" <lizhijian@fujitsu.com>,
        Zhou Jie <zhoujie2011@fujitsu.com>
Subject: [PATCH] kselftests/net: adapt the timeout to the largest runtime
Date:   Thu, 13 Jan 2022 15:28:59 +0800
Message-ID: <20220113072859.3431-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 13D9E4D15A4A.ADFC2
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

timeout in settings is used by each case under the same directory, so
it should adapt to the maximum runtime.

A normally running net/fib_nexthops.sh may be killed by this unsuitable
timeout. Furthermore, since the defect[1] of kselftests framework,
net/fib_nexthops.sh which might take at least (300 * 4) seconds would
block the whole kselftests framework previously.
$ git grep -w 'sleep 300' tools/testing/selftests/net
tools/testing/selftests/net/fib_nexthops.sh:    sleep 300
tools/testing/selftests/net/fib_nexthops.sh:    sleep 300
tools/testing/selftests/net/fib_nexthops.sh:    sleep 300
tools/testing/selftests/net/fib_nexthops.sh:    sleep 300

Enlarge the timeout by plus 300 based on the obvious largest runtime
to avoid the blocking.

[1]: https://www.spinics.net/lists/kernel/msg4185370.html

Signed-off-by: Zhou Jie <zhoujie2011@fujitsu.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 tools/testing/selftests/net/settings | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/settings b/tools/testing/selftests/net/settings
index 694d70710ff0..dfc27cdc6c05 100644
--- a/tools/testing/selftests/net/settings
+++ b/tools/testing/selftests/net/settings
@@ -1 +1 @@
-timeout=300
+timeout=1500
-- 
2.33.0



