Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F85C249308
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 04:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgHSCtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 22:49:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9841 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727063AbgHSCtA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 22:49:00 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CFA3CEE5B3BF5EC6AD4D;
        Wed, 19 Aug 2020 10:48:58 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Wed, 19 Aug 2020
 10:48:54 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <elder@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: ipa: remove duplicate include
Date:   Wed, 19 Aug 2020 10:46:45 +0800
Message-ID: <20200819024645.17107-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove linux/notifier.h which is included more than once

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ipa/ipa.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 55115cfb2972..407fee841a9a 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -10,7 +10,6 @@
 #include <linux/device.h>
 #include <linux/notifier.h>
 #include <linux/pm_wakeup.h>
-#include <linux/notifier.h>
 
 #include "ipa_version.h"
 #include "gsi.h"
-- 
2.17.1

