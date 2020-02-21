Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B2F167024
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 08:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgBUHXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 02:23:09 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:49022 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbgBUHXJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 02:23:09 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C1C63ACB9E65A576160E;
        Fri, 21 Feb 2020 15:23:02 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Fri, 21 Feb 2020
 15:22:53 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <Jason@zx2c4.com>, <shuah@kernel.org>, <davem@davemloft.net>,
        <yuehaibing@huawei.com>
CC:     <wireguard@lists.zx2c4.com>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] wireguard: selftests: remove duplicated include <sys/types.h>
Date:   Fri, 21 Feb 2020 15:22:09 +0800
Message-ID: <20200221072209.10612-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 tools/testing/selftests/wireguard/qemu/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/init.c b/tools/testing/selftests/wireguard/qemu/init.c
index 90bc981..c969812 100644
--- a/tools/testing/selftests/wireguard/qemu/init.c
+++ b/tools/testing/selftests/wireguard/qemu/init.c
@@ -13,7 +13,6 @@
 #include <fcntl.h>
 #include <sys/wait.h>
 #include <sys/mount.h>
-#include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/io.h>
-- 
2.7.4


