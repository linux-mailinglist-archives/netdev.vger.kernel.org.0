Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB993271ED
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 11:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhB1KnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 05:43:23 -0500
Received: from smtp-17.italiaonline.it ([213.209.10.17]:40263 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230468AbhB1Kjx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 05:39:53 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id GJTalhz13lChfGJTilvZSZ; Sun, 28 Feb 2021 11:39:10 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614508750; bh=qdqprpCrTgqGjjL1MPD2Trs9CbuR4PMIgLdSlLVKd3w=;
        h=From;
        b=BVHuokuFUwahbkxu/P4/NP1RNm1HX6GbTvxSxIuK0sbEPcOrtnDBoKbIn5Dw8hv6D
         NdpXHM7DDfbJJCIaf2wD3kp0TvcvnFV/K4WMwBROjf/PHmBfcxA2tGtgG8c2DShBtJ
         e766X+FTlkEpmqpsX5MTmN9vIFd1PTX3FIK9Nz+o9NTUQucRWpzKDRVQr4PEgcoakS
         M//jphmMfGwUYbGfaUNbBY1dufnzUvOdhXMje877GBlt4L6canbXJmfYOLccSqwCVy
         jBoxb1d7tqnn9UCHtFM4rz3nP9NpzpaBbeT5OxaZtl4vHyMFumZtuTxevebZr9UWPD
         q6Jzr6MtEzBMg==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603b72ce cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=sBSmD8KNhItU_oXWusYA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 1/6] can: c_can: remove unused code
Date:   Sun, 28 Feb 2021 11:38:50 +0100
Message-Id: <20210228103856.4089-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210228103856.4089-1-dariobin@libero.it>
References: <20210228103856.4089-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfBfdn0MAFYXUTT9rWnrZZsFBNZzaW6Gt1SyHLr1O1thZ+2m3NdtXD++Z7t/W8X8IBi4zrvE98Wpm0R7zAwtJFRvwa6sw72TfiEm5gJ8+HsLUdMe/y0YC
 11crQcDsOYJ26ES4Z2dm0fUGSl/C5SEf2fDJ8dNzhVFi39Wllrq9LLNOvCluhWxNL7bmZ4u0w9S++GwBWY3WVnRLdyFLevNeN9zrNoQgIVyaVrtGl6ai+6mu
 b8JJCHWwhqiemSq6+Z9rAjNiXEpW9n1ind3ow+I+OZ+8/Y5DvelqcEZlLY8AfMHTD9kQX3i4K4nUwb7QNuaE2ngVCEiEdObb5IqJGLbG/UGye+zHNMIxvTuR
 MasSCjH++pzRwkNWUJCyyUgOzi0/SxBuzE7exZKUenRNZiEJP3KVnZZX1yCuP9FAL9pzHd1WK3ra+M1f1BeUAef7h0GvXohn5v74hrxmn3rIgMSe42ailMqW
 ebMMyxPD5nqTs98SulmNCVmvKQpBIDQC1gJ9e2aImamVefq8zKAsCEoh77Y6E+q5XX10Ovm6R2V0VXEndmyyt6bPtYdjVWNWmWLbZGf5S/r2w9P0rBhda5Qy
 vjw6EGxAdlj9P6Cbj/jDxBOUYmyIhCvUf6riVDLGqpq2wVbORrzOVik68kVTbzshjW9ANZwksgK64W/luXHqDKGIM9AEWipcRm3SQOdGEM8Qzw==
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

(no changes since v1)

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

