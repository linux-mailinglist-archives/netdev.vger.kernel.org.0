Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E5732590D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 22:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbhBYVyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 16:54:05 -0500
Received: from smtp-17.italiaonline.it ([213.209.10.17]:50917 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234637AbhBYVxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 16:53:12 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id FOYQlNUJ2lChfFOYVlkbfa; Thu, 25 Feb 2021 22:52:20 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614289940; bh=qdqprpCrTgqGjjL1MPD2Trs9CbuR4PMIgLdSlLVKd3w=;
        h=From;
        b=eyAg1IRpgtVyo7sJUr3p+9ngUEWuCS3gwC/fZpmeoufaE/puapXNcPyW6JNRarF0F
         ShBtIIdIPjq9gvKpO0juaHOPA+c45GuRhpPfKGAYTSX0M+jCxxH0GoRHCEp28oiQcF
         FSDCII34hgh4nT/l4LVvsTDBszClrFdL4ZpiT7AFdCqIk7P1qU549wxjjfr9BbsoOQ
         ev06CF7C6j2xG8ioNvQHAdv2UTcSsF+QVPMd6VyyCJIXFvNda3qdllRxVSMqpYs4mL
         imfJj4gKQNauYAIMjs3yGZduh0OXbBE4AM165bSaAsO+3zbff8LddFec3Dyowh4bXo
         zW5YCDke/sqSQ==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=60381c14 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=sBSmD8KNhItU_oXWusYA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
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
Subject: [PATCH v2 1/6] can: c_can: remove unused code
Date:   Thu, 25 Feb 2021 22:51:50 +0100
Message-Id: <20210225215155.30509-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210225215155.30509-1-dariobin@libero.it>
References: <20210225215155.30509-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfEG9PQ+25SLWZPHaldFNnMkDX4Sw1bijmupDMTfL6BZREdLUv4+k53du8bwQYXjZGuTGQNGs3OF5C1J92zxj3qI2ltmGoYfUV7oVMoQAApiBwRRNL+Pr
 gVzciCumKYfVt5inQfFEyyCLWHsx+mU9rjz5AXpQw3BphT7CTBWgjzsA0PWB8NURqY5Vf7duDIk9mGScuspB9iHLVE+dU7RH7pUoZni5JxDCh+04utbBTdez
 G41OCGNUwDcDaycXkH17HIEIDAMbZuD36Do+qYoWpCO5SRsSoAfX9iJc7VdkCyBXAiOoQOcYi8dYng8aHf9vLBt/EKPNT0PNIsobUZGSonOUYZQ+fDUwjZnM
 b6AvdkO46u+GlCTGsgzD57lAihDCLq9T7re3ppMfVPEaJAcZ4I4LMdQh6ID5yZDVgyJO+eTwR6l6qdTGfx69Nkkyh8KZ7bslIAT+6H6guAoMlRXd3H7pK2OO
 Yy/+cynNKuXE1NlNBc0nAQnEhFeJqLgxT/Jlie5u/eiYxOPx/MqerqSPJCBSJm7DMKSoq1f/W1s51YcjzdYTl776glG6ehJO+6cMG+WSJAoznp5Hm+raNYJY
 vRIGbY89kM/dI24K+cOPudt6AV+iRLAyE/5L4uJiwP1Z8kSTGbfI6LsKiR5RK0HzlGs92dAmI67CE8yFCT7ctJaTm5hLBolwycbU9Pp6obLCkw==
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

