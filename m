Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A4032B3D3
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1838253AbhCCEHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:25 -0500
Received: from smtp-17.italiaonline.it ([213.209.10.17]:34988 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2359536AbhCBWAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 17:00:48 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id HCz0lBDmUlChfHCzAlGa06; Tue, 02 Mar 2021 22:55:20 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614722120; bh=o/7ch7+V1m2CY14tyIbFbttFZQOGlpyY2sI2NtzRNWM=;
        h=From;
        b=eOxbH4FWtwkffGi8S8R3eq56ekkv0GHtv7vqYsSLRtrhSLFmpUHfOwjNyVV9Ol+RW
         tE668mIkBZG6nxJ40xnPpPxAKCbpsEn63tnYl3Re8hX6xEROU7F2s/89/68+XANJWT
         XRAgaGeVxPvdui/mvjbP86nh5SLzUjLq9zTEeSnxBjb1mIT7Lk7hA5eaznjQWNS7sZ
         +CEnNdsQTLyOU7BOwYq00ByDnc6DGtrGxEFjTjIUITFVraYxnQ+cheNhYDneALCJHD
         MGxcy/R/GY0+aRHSlX24kZ7K4V0yXTgq1aSUeLhK7I8FPfYSbNv8gcBgrJQaYt37U+
         NldwJA69q6Y1Q==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603eb448 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=xyINcoL9mV1Qo4PShlgA:9
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
Subject: [PATCH v4 3/6] can: c_can: add a comment about IF_RX interface's use
Date:   Tue,  2 Mar 2021 22:54:32 +0100
Message-Id: <20210302215435.18286-4-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210302215435.18286-1-dariobin@libero.it>
References: <20210302215435.18286-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfI+vjYn0/uqmevKnPg9KnLpPOBK8b83OBrdtkArRSpSR/lB1fyWXvSx1aaQaq8iD80nZa8tu9Aibepn3Zpu8XMjq659gMLR/wRhhLWws1QoHPXdOdU7t
 nw5q39a2Kyn0BVa6RmrJrV16o7UO0v8frA20GoiQEHGYoHIDOtCE3ui9DrOKS9VvQfqniYmpAdqgeBl0t/IfdgP4WET+0PQDGwL4Oda//5gW4VaROPl1OXYW
 rYXgN8JA2amTRRJDUR/jTtPofmxWKILyJj/XIOPOYHhor5mWUAHbil813bTFeK7Y7z0fwLwD5Lgs24VcbS3zyZsKc7uUt/PO8FF6of6efXqHGbL6ViTcaklM
 jYjoQlnTqZW0AI2PGOK1C4xOESF6WswqM7ZQXZnC4fx7BxwVb2OS49/W7pWILf+5xvO8VkLSU6+YSrrEvL6OjIaEleuxWBt+QoHxMSCiyY2giOfuei32wCSt
 XY7M69zaBK5x8OUTHAtZ2226g2JLAHCm7Tb+8RXIxLmYM6boE19+tr41E4U7UNk/jTH0w0SocPjoYmBumSgIMtgcllXr7pjPIyjk3yIqE3hnAqmzc7bIeRFj
 nFZRk21NuxG+cHREwabEZqM0/fhYh0GDeBRwBKLimBD82BvvTweiFwA52SwJfI0S7UXCdNeEuQ4qfnvO/vA27lW+6CtgHuCavBBkS1QCOfH7YA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After reading the commit 640916db2bf7 ("can: c_can: Make it SMP safe")
it may sound strange to see the IF_RX interface used by the
can_inval_tx_object function. A comment was added to avoid any
misunderstanding.

Signed-off-by: Dario Binacchi <dariobin@libero.it>

---

Changes in v4:
- Restore IF_RX interface.
- Add a comment to clarify why IF_RX interface is used instead of IF_TX.

 drivers/net/can/c_can/c_can.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index dbcc1c1c92d6..6c6d0d0ff7b8 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -732,6 +732,12 @@ static void c_can_do_tx(struct net_device *dev)
 		idx--;
 		pend &= ~(1 << idx);
 		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
+
+		/*
+		 * We use IF_RX interface instead of IF_TX because we are
+		 * called from c_can_poll(), which runs inside NAPI. We are
+		 * not trasmitting.
+		 */
 		c_can_inval_tx_object(dev, IF_RX, obj);
 		can_get_echo_skb(dev, idx, NULL);
 		bytes += priv->dlc[idx];
-- 
2.17.1

