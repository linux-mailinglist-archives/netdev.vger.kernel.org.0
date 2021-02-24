Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F64324760
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhBXXJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:09:07 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:49366 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235541AbhBXXJG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 18:09:06 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id F32VlxCf1lChfF32alf7WN; Wed, 24 Feb 2021 23:53:56 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614207236; bh=0ykPYfWxyqIVxDt8UvrzXrUO0o+7ipzhDcLQFeXI3A8=;
        h=From;
        b=F/Jb9O/mpenBhE/SJ2atdG4sVIchyM7wxIYZf1pweKkr91e2STjDEHauK8FqyqLbP
         K94SCJ//IwlqMZWij4F7SauKE1YYpUEcpX18DiLUhHHTnzcJgcIcn80gBxhq9vWUDQ
         sOBU0QICCRDcsGpxH5v73+r2IQMvMbFYblCPmNDHTZSTWzkCI7xO3criPbCcZf97UG
         lv7kksSR8DNiO+MLWAoIor9Sfcos6G7ikXoQ1EUKqC66ZRWllRrfjHYZ+0/FaeZB2B
         3sc1HarnhTXeoJOVHdHzqJo5xqbCxNIiPqwb7YKyXr0R2DIGlVCzF1BOwiy1Yxs36B
         Fi/oFL+QUwixQ==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=6036d904 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=sBSmD8KNhItU_oXWusYA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/6] can: c_can: remove unused code
Date:   Wed, 24 Feb 2021 23:52:41 +0100
Message-Id: <20210224225246.11346-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210224225246.11346-1-dariobin@libero.it>
References: <20210224225246.11346-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfMOLlCecWLvUGrZ7U5u1wIQsmh8zYjADupowNCTunlqn3AYJ7cx8lPJ5yDyX/ogisOrWL37tzz2APPsamdAFFz7RVfq6ILVDTaGTkwAYAyYMKMmju+Xq
 ePNcq/wACcZ5kKxR5dJ/AUMgfJ+odwsBZqSD9gsmUVWbH4CAHg5j+lllLg14qWp1UytCf11ESQZ9TGbEvW+asfU2+au/UIyKp0/jI6vrbaM14GyH9hmXLChT
 hbjtTFRt8arwVuXsjGfMkIaxiROIHm0WWNye3GNqan2EKzOpJYsNlqs5qxrUekH3XvGqbyJ24Nh6wvDi5OOEV+aiMqVZCnI0yqo6HEUBPgfXEgQMqmM/+mNw
 +dfF8VhFQabo+sb2C3hUcatQCudUvCfQfP8FHZNWtYYNeHB28eap5vmwElBfxDp6K5ognpcMr4+bH3+cLstLS4RLve3UpUIFsQ3407/G77JTxlJdGFBkB956
 tds9OXOuvwXkUZVkO+Hh0mnH+o0ZhN6aL2/r9uHb/m9QFn8+yGLg1u7aOvAa4NEBjIg/Id48aGuWTa11wQpx9/0mNjF4nOZM7PrjoLZdbJo3Uifc/lJzkJ/c
 aLniYsX/CbTlG5xsV7fqGUKQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 9d23a9818cb1 ("can: c_can: Remove unused inline function") left
behind C_CAN_MSG_OBJ_TX_LAST constant.

Commit fa39b54ccf28 ("can: c_can: Get rid of pointless interrupts") left
behind C_CAN_MSG_RX_LOW_LAST and C_CAN_MSG_OBJ_RX_SPLIT constants.

The removed code also made a comment useless and misleading.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

 drivers/net/can/c_can/c_can.c | 3 +--
 drivers/net/can/c_can/c_can.h | 4 ----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index ef474bae47a1..a962ceefd44a 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -848,8 +848,7 @@ static inline u32 c_can_get_pending(struct c_can_priv *priv)
  * c_can core saves a received CAN message into the first free message
  * object it finds free (starting with the lowest). Bits NEWDAT and
  * INTPND are set for this message object indicating that a new message
- * has arrived. To work-around this issue, we keep two groups of message
- * objects whose partitioning is defined by C_CAN_MSG_OBJ_RX_SPLIT.
+ * has arrived.
  *
  * We clear the newdat bit right away.
  *
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 92213d3d96eb..90d3d2e7a086 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -32,11 +32,7 @@
 				C_CAN_MSG_OBJ_RX_NUM - 1)
 
 #define C_CAN_MSG_OBJ_TX_FIRST	(C_CAN_MSG_OBJ_RX_LAST + 1)
-#define C_CAN_MSG_OBJ_TX_LAST	(C_CAN_MSG_OBJ_TX_FIRST + \
-				C_CAN_MSG_OBJ_TX_NUM - 1)
 
-#define C_CAN_MSG_OBJ_RX_SPLIT	9
-#define C_CAN_MSG_RX_LOW_LAST	(C_CAN_MSG_OBJ_RX_SPLIT - 1)
 #define RECEIVE_OBJECT_BITS	0x0000ffff
 
 enum reg {
-- 
2.17.1

