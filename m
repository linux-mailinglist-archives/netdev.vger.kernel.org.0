Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68ECE389C22
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 05:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhETDwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 23:52:41 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4550 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbhETDwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 23:52:36 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Flwgv6T6tzkWMD;
        Thu, 20 May 2021 11:48:27 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 11:50:57 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 11:50:57 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>, Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH net-next 3/9] net: slip: remove leading spaces before tabs
Date:   Thu, 20 May 2021 11:47:48 +0800
Message-ID: <1621482474-26903-4-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621482474-26903-1-git-send-email-tanghui20@huawei.com>
References: <1621482474-26903-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running
the following commard:

    $ find . -name '*.[ch]' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/slip/slhc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/slip/slhc.c b/drivers/net/slip/slhc.c
index f78ceba..ba93bab 100644
--- a/drivers/net/slip/slhc.c
+++ b/drivers/net/slip/slhc.c
@@ -325,7 +325,7 @@ slhc_compress(struct slcompress *comp, unsigned char *icp, int isize,
 	 * Found it -- move to the front on the connection list.
 	 */
 	if(lcs == ocs) {
- 		/* found at most recently used */
+		/* found at most recently used */
 	} else if (cs == ocs) {
 		/* found at least recently used */
 		comp->xmit_oldest = lcs->cs_this;
-- 
2.8.1

