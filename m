Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9BB256759
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 13:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgH2L7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 07:59:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49262 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726798AbgH2L7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 07:59:41 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 605F3638B88DA67393BC;
        Sat, 29 Aug 2020 19:59:37 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Sat, 29 Aug 2020
 19:59:29 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] libertas_tf: Remove unused macro QOS_CONTROL_LEN
Date:   Sat, 29 Aug 2020 19:59:24 +0800
Message-ID: <20200829115924.7572-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no caller in tree.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/marvell/libertas_tf/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/net/wireless/marvell/libertas_tf/main.c
index 02bd7c99b358..cb494b59de93 100644
--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -15,7 +15,6 @@
 /* thinfirm version: 5.132.X.pX */
 #define LBTF_FW_VER_MIN		0x05840300
 #define LBTF_FW_VER_MAX		0x0584ffff
-#define QOS_CONTROL_LEN		2
 
 /* Module parameters */
 unsigned int lbtf_debug;
-- 
2.17.1


