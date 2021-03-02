Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8878232B3D0
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837947AbhCCEHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:17 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:42085 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1837608AbhCBV6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 16:58:07 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id HCz0lBDmUlChfHCz9lGZzj; Tue, 02 Mar 2021 22:55:20 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614722120; bh=ZwZwTipdZKxY6qGd4VuGRlxL2+9rpHSGnSFdq6NXms8=;
        h=From;
        b=mPrpEseLmRrBAvDVm04K8oNNF28Zo/O/F0qD5uEk4Up7Y3uoqdtz+zXu1AzwFIMdP
         j0HCZMMKK98dqhfU3IWrb8+e7iuMyJ7ki5vqiJ8gruOIvw7wErtVYCWVwFKfpzqmxp
         uwo1acySIN6i/2BVaKJe2jWrdOa2QNzFkZRj/anG6il33wNxYpiMSdWMnKJHppkpxf
         0wIHDFZUWZB6wuI1JN4X859+j3PnCM03RmrjpUPKkPe1YArgRVpez8Gsb2TG59Tobc
         JAj/xle++6jY9sTNqtQaWraAT966UuBpbDaoxG9GeIuqx9UOcDpEa93ToyEJrfOoL0
         PmNRkDJhakNUA==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603eb448 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=AkCzXzlJzD4X874_W7gA:9
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
Subject: [PATCH v4 2/6] can: c_can: fix indentation
Date:   Tue,  2 Mar 2021 22:54:31 +0100
Message-Id: <20210302215435.18286-3-dariobin@libero.it>
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

Commit 524369e2391f ("can: c_can: remove obsolete STRICT_FRAME_ORDERING Kconfig option")
left behind wrong indentation, fix it.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

(no changes since v1)

 drivers/net/can/c_can/c_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index a962ceefd44a..dbcc1c1c92d6 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -786,7 +786,7 @@ static u32 c_can_adjust_pending(u32 pend)
 static inline void c_can_rx_object_get(struct net_device *dev,
 				       struct c_can_priv *priv, u32 obj)
 {
-		c_can_object_get(dev, IF_RX, obj, priv->comm_rcv_high);
+	c_can_object_get(dev, IF_RX, obj, priv->comm_rcv_high);
 }
 
 static inline void c_can_rx_finalize(struct net_device *dev,
-- 
2.17.1

