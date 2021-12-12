Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8928C471904
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 08:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhLLHMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 02:12:50 -0500
Received: from smtpbg128.qq.com ([106.55.201.39]:14646 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229518AbhLLHMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 02:12:49 -0500
X-QQ-mid: bizesmtp44t1639293128tgcghhpq
Received: from localhost.localdomain (unknown [182.132.179.213])
        by esmtp6.qq.com (ESMTP) with 
        id ; Sun, 12 Dec 2021 15:12:06 +0800 (CST)
X-QQ-SSF: 01000000002000D0I000B00A0000000
X-QQ-FEAT: BVRItfLxsF5N0FKv6/avTPr/sb1RniA01AUrRZuUoLjXX1S0Hf7YFxeWXbkTv
        LYqclodWvQTuPxTU38Sm2K1+n2vIQmk6Csjf/mjTY/VB+sz1nGrQSXKlgdabceWJrg1D9gr
        ZdR612YR2OC+QBwozFtMt8nP6n/aepl23BB4luMJJIsqYcJFGMVpA94F30ezyawisMxq6xc
        rvKInz8ptrQ1rDAmSOXJDpwWoWfUfTttgNANo4qU3aV8/1MB+M6eDO/cXwkluK70J25ydFV
        XRaIvWAm0BJZzVIEBP2d8bgutMqS4BWWLMJhLijt4VQZ+w2wQ5mk/F/OSHwlXfInAwiyGl9
        YpOpoKhrd2bRfDthhoo1FwQfsh0xykgnzNyQSkjDwS8DG1lrXbUoLt+YjjqiQ==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     isdn@linux-pingi.de
Cc:     arnd@arndb.de, davem@davemloft.net, wangborong@cdjrlc.com,
        butterflyhuangxx@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: cpai: no need to initialise statics to 0
Date:   Sun, 12 Dec 2021 15:12:04 +0800
Message-Id: <20211212071204.293677-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static variables do not need to be initialised to 0, because compiler
will initialise all uninitialised statics to 0. Thus, remove the
unneeded initializations.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/isdn/capi/kcapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index 7313454e403a..e69c4bf557bf 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -32,7 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
 
-static int showcapimsgs = 0;
+static int showcapimsgs;
 static struct workqueue_struct *kcapi_wq;
 
 module_param(showcapimsgs, uint, 0);
-- 
2.34.1

