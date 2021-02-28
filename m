Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B533271FC
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 11:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhB1Kz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 05:55:56 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:38491 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230075AbhB1Kz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 05:55:26 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id GJTalhz13lChfGJTilvZSw; Sun, 28 Feb 2021 11:39:11 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614508751; bh=ZwZwTipdZKxY6qGd4VuGRlxL2+9rpHSGnSFdq6NXms8=;
        h=From;
        b=nSbXqjkqcU9LUsYPQ/+GP+1e7pIX2R6aiL3JVO5yuS+esKOYcFbKXLBbIXBTFBG78
         7v3urMgLf57pQ3wObHhUkBwLne04AYAQ5klA6349TA+sLZPlI21nWysGbwPA8nVzdr
         oAK75GmrXUQ4RQj9Q1/SfvaVqDo1OqP+qlbeNMlj4A8Qi14JOWD5eABjMCCZbBpxBV
         40cYbMwvB9eK2N8ttHcgQgApSkbLGDRyueimo96MHEJUwhEKwz3u7oD/q+JhYZGcEs
         89rXsY8/tcIlTcjggsQvclaJ2gQuH5JdHJ9WPubkmjAMqs4pUnzb1nRMIXCEYq4RkM
         p1O4RwPEvVteA==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=603b72cf cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=AkCzXzlJzD4X874_W7gA:9
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
Subject: [PATCH v3 2/6] can: c_can: fix indentation
Date:   Sun, 28 Feb 2021 11:38:51 +0100
Message-Id: <20210228103856.4089-3-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210228103856.4089-1-dariobin@libero.it>
References: <20210228103856.4089-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfIqDPzy/TaVyX1bg6cAUd+UcF9va+6YHkGmwVXEdQpTzkqIGram+k2SBaAZr/opzemVZTqRWGxRPqlgTzAq5Lje0vJ/hw33iF9qkLVWSFRsa+ELm4OfF
 WELfPqY1ZNiz+CrNzYnYHYhcQq3t8onaI5iL/Z8/bEDq0cN+GyPCN+UxHndHN0IOFsZBhK8f4J56W7+0wknJCeHWHNZTN5ptK1xBLUNGqy7OGFvVwVV76dwf
 5YJlAMF2auKtsNud0Xg+8fQ4Iu30HEOUrt2VuOqCwRD0cXhbKixdWH9p8mYJOvs4lHDsK0ca5mPFpKK8P9HINPskgX16vmAZxR51SyfZitR34XTFrezRpUgu
 3UQNjGyjvu5Aj0CAtp1KlCKFSaPg/3LFJGawwNFXiad6TMl5GXWLpHZQxzm8lLdvIDksdw+zJXRS6jrRL26et+jZRn1FrNl7aEkgNu0++YMtGjXQQhyg+sn0
 DiVbCXG3UbqsaOcSiIHbQSW7NKLjXAm7r4RPOVtVrD+vNbOVe33+8uyX8F8MQEqqMErcsU6tcjmSOdaa87cJM6bOfZ+5OhRoIaEweVWm8H5dzYzGoAHTAkK0
 JHjcyM4HZSnZcbFDjmQEM0ywX4qZAR5S37Ky/6rOM1PVaVuo3NEqf38Qwi1uCJf5KJUq/8rYbm0LHmgZdXmhrf6AmQkl2nCFcdCl/irOLrSlAg==
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

