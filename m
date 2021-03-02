Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104BF32B3D2
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1838144AbhCCEHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:24 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:33875 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2359512AbhCBWAY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 17:00:24 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id HCz0lBDmUlChfHCz9lGZyy; Tue, 02 Mar 2021 22:55:19 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614722119; bh=qdqprpCrTgqGjjL1MPD2Trs9CbuR4PMIgLdSlLVKd3w=;
        h=From;
        b=s7EJYlgnGzzV4Ryga4AqcroedD4vs9eeUDk6FVtDA4XEPrjWvajfER68wFp56kdB5
         FbNtq+/QO/fxgMHqYuYSlSdqUOk2yoN/4io0NDmOLsidK0oIpzpl8Knv34Op405RcY
         Mp/qsUhjx7e8LjvMQMMlGkwnzXQRyKP4+Iifk1j+0IEAMd/qzeTzXv1l2wtQaCr171
         vi+c4/uvV4c+JZwg8P0OOeihm28Tey1nPIc9MF47EG1JxfnNg0KIqeYnx4gv3g79FN
         e8fUnRK8cdTK043DaEGv9XWbEMJr9L1k9zsVHxVVl5z+yuDWEE2Z3DmO6uHEI2U8fO
         nWtcEhHhkY9wg==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603eb447 cx=a_exe
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
Subject: [PATCH v4 1/6] can: c_can: remove unused code
Date:   Tue,  2 Mar 2021 22:54:30 +0100
Message-Id: <20210302215435.18286-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210302215435.18286-1-dariobin@libero.it>
References: <20210302215435.18286-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfCNlwnz3gfkmh0/i+idqmVXV3IC5zhju5NcNjmP77+0Sy4O0/i5t7BHkMNi08XyPTlPv2sB4vCqUCvz/7ifRdCVVcAqVLLovQAbiOld/IqVqy++PRsNH
 LPWSEUzarsR2z4SFq/slAp18rS+7kp+XCGL9PnM99yB2EMRB2daQsNPaEI+yzen7u/lXxMzJzAldven4Y4oa+tKcKW4/C3u8m5mSi2i6szDAmRjDlsEJKGyJ
 03YdaVENCNeYo9GLMo34CTVOXBgRSyAZPqO3I/GXKJ7wHYOncGVN2jboI2nykNmhfT3LT/9xcpIJPWRKcs7xI4ia2+Mct40avnilfc4/60a0AdkvPTiKicyS
 Wq8jwC6oz9WkLnzjUlvT4aChXKS64mBDsACwJa5TLcJYMYh/U82FrLKxMSSZsuo4wTMyrgPYVCQa/ydDeyzzqd4rRV7peiMsn23y2Z67Dd9GaLz1IovrFcDS
 f09PwDeJb3LwU0l7fU21iTrIn8AciGYg52U5d3Fp26ljIIoPiwZhOW1D6IIP48nks3/LORWGTsODxyhCmPKMqmx0Vpfslhvrt8D4KK71UhRv9C02zFfqvAAU
 ID1aS29j/z0D3Mcz0yT39OKFStf2wS9nkou1EcYUe5Z36VN8/N6tyTBHZD5Oz2Mhmnb8f06qtymwzmHbwauXc58oooXHW3IkBoPM/ovqnURybA==
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

