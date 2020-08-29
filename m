Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B339D25674E
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 13:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgH2Lzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 07:55:43 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49752 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726876AbgH2Lzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 07:55:39 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 92653D215371933788B4;
        Sat, 29 Aug 2020 19:55:18 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Sat, 29 Aug 2020
 19:55:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib80211: Remove unused macro DRV_NAME
Date:   Sat, 29 Aug 2020 19:55:06 +0800
Message-ID: <20200829115506.17828-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no caller in tree any more.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/wireless/lib80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index cc7b9fd5c166..d66a913027e0 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -26,8 +26,6 @@
 
 #include <net/lib80211.h>
 
-#define DRV_NAME        "lib80211"
-
 #define DRV_DESCRIPTION	"common routines for IEEE802.11 drivers"
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-- 
2.17.1


