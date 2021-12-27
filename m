Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7346F47FAFF
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 09:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbhL0IWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 03:22:19 -0500
Received: from mailgw.kylinos.cn ([123.150.8.42]:37436 "EHLO nksmu.kylinos.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231500AbhL0IWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 03:22:18 -0500
X-UUID: 90049ab5b91947a48a138fd5dbe09533-20211227
X-UUID: 90049ab5b91947a48a138fd5dbe09533-20211227
X-User: wenzhiwei@kylinos.cn
Received: from localhost.localdomain.localdomain [(117.9.201.122)] by nksmu.kylinos.cn
        (envelope-from <wenzhiwei@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 277021046; Mon, 27 Dec 2021 16:34:43 +0800
From:   Wen Zhiwei <wenzhiwei@kylinos.cn>
To:     davem@davemloft.net, kuba@kernel.org, wenzhiwei@kylinos.cn
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net:Remove initialization of static variables to 0
Date:   Mon, 27 Dec 2021 16:22:01 +0800
Message-Id: <20211227082201.186613-1-wenzhiwei@kylinos.cn>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the initialization of three static variables
because it is meaningless.

Signed-off-by: Wen Zhiwei <wenzhiwei@kylinos.cn>
---
 drivers/net/fddi/skfp/hwmtm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/fddi/skfp/hwmtm.c b/drivers/net/fddi/skfp/hwmtm.c
index 107039056511..145767d98445 100644
--- a/drivers/net/fddi/skfp/hwmtm.c
+++ b/drivers/net/fddi/skfp/hwmtm.c
@@ -38,10 +38,10 @@
 	-------------------------------------------------------------
 */
 #ifdef COMMON_MB_POOL
-static	SMbuf *mb_start = 0 ;
-static	SMbuf *mb_free = 0 ;
+static	SMbuf *mb_start;
+static	SMbuf *mb_free;
 static	int mb_init = FALSE ;
-static	int call_count = 0 ;
+static	int call_count;
 #endif
 
 /*
-- 
2.30.0

