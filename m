Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9812132473D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236038AbhBXXAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:00:02 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:58491 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235628AbhBXW77 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 17:59:59 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id F32VlxCf1lChfF32alf7Wj; Wed, 24 Feb 2021 23:53:57 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614207237; bh=jl5f1tB4px5StQFU2IVlCyd+HEkDPcfvymDiEqyycck=;
        h=From;
        b=If68/0AU94kxip7M4BMxD3MPCKMtlkY6j/abeD6HENhJLGFj4iJiTYYG3QYXTOEEH
         HRzWTx9ukxazpye0HW5PT7aOrInQE0buYvl3gpp/GtHV+pgFmmMjl8m6GZxS1emkzS
         uD9BhAa8R0E0BoKt9zfb3HFPdu0yFt3C22sjfoXmQURENaqYZOJmVRvW2HG8XCVWuy
         bnqeX6RuInV8GQEJ0N8j8YuCYmT4KW+ST7HyexNRfM9NBkR+gAq06qRJ+UGIrsbz6j
         cr/yK4ugshI60cYm/ivZNZJqCkMHruXI8049mPH3L7j7slSlBkIVF/F2w7KqfQsGA5
         tvIZRtrHrsc6Q==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=6036d905 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=AkCzXzlJzD4X874_W7gA:9
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
Subject: [PATCH 2/6] can: c_can: fix indentation
Date:   Wed, 24 Feb 2021 23:52:42 +0100
Message-Id: <20210224225246.11346-3-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210224225246.11346-1-dariobin@libero.it>
References: <20210224225246.11346-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfJkuawPBeIAI7RvLQt2PqRPk8oryQV6eJXSBCTbyPJNMKZ5EydhRp9g3DZXGMF1HSBWwV4zzACoFYMCty3ptPV7UMmluayJhF940XCkOjbucwpIKmNGn
 Jz6vyFim9ORgc1NHfEK0rPUbZ5BzSqMd+KRA6yCYCqpYymkntrqekdKlbOR1Oqzb2+wRXyv8hLOLNIu6ht3N0yiT1GoaxnN4q92wevNtJTKgnPZep19Uk5Q8
 CmOHFHzPxR5cgis75WP/k3R91/eV+cPbuWj4rx6b7rhAtelhX35PmCk9mBe6NY+ZJDsOGGkOV2Q9a+N/URJHrsup2+w/74kqYwo4vBjNFPD+X4rk3g8eXp2F
 j+/dN4lW+YXFYsSXQt7ueY6Xl07vbsszPhunCWYg8igatipAvnGkfdnOiX+DfO+3b4+iOLm+J+9bddtiyOPl/RiYFSzHC9WbQd181tAl/rl5wNhI/nx3Vkpd
 g6VVg+2mTUI2eMTOoKkh1I75rAGabjXkm/kwbPHHnItx/2rSebPZwZRklpiNY+F0OS+jNu9wALZczKXhInrDJgKWVCEb6NrigBhMjmu3SzoUMLUDC/gWrxPK
 x/yAFo3hC1S8HehAPnqZE+nd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 524369e2391f ("can: c_can: remove obsolete STRICT_FRAME_ORDERING Kconfig option")
left behind wrong indentation, fix it.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

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

