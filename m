Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389E032591B
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 22:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbhBYV5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 16:57:00 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:41073 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234875AbhBYVzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 16:55:19 -0500
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id FOYQlNUJ2lChfFOYWlkbfx; Thu, 25 Feb 2021 22:52:21 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614289941; bh=ZwZwTipdZKxY6qGd4VuGRlxL2+9rpHSGnSFdq6NXms8=;
        h=From;
        b=nPqtD7JEACtSZgRq+Y+7+amJ9UEw2g4F9Ow0l6RJbzEibTAkGaa7bF2WhTVHlxve1
         oHLwSmqke9ZWsWeNFcZGlx7TMv4clil4jCCdM2x2yYk4PPqLqVfF2Q31n89XWG/tr6
         CJODTsADPWI3Qj7pib1oLuWXv4TABf7i96VTYEo2z4eK+UDEFmz00wDFn/6rrvnRY+
         Lyzb1yl/M9JnrVNmFWsMJ8wpYLTEwVZjBPVt97wEgQA7eh34VJ1j63H4uX08SbP6FB
         wZPg1Bq2VrQk6m2qfdl/TKioRQND4v7VMJuZPB4j76gknFcgbnSrW4CjJfrX5h2J1T
         LUv71dyyg42HA==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=60381c15 cx=a_exe
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
Subject: [PATCH v2 2/6] can: c_can: fix indentation
Date:   Thu, 25 Feb 2021 22:51:51 +0100
Message-Id: <20210225215155.30509-3-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210225215155.30509-1-dariobin@libero.it>
References: <20210225215155.30509-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfLyEMjqPMWD6UklMARrB4DSdHDnqxkwrej79EXjWITQpcm3rEgvUMPyPzGMGZPXL/kNJ2iArJDBnhfYbLPSejaI69YZVumO8EuiQyLE4G976ejrsS8FX
 grbzC2RPpJG+jl9ysT98tvGC6yM10VDgeskEII7SoPXfswWqhs2FOsB9AtAj5B5arznhapM0MCs0k5AFr+cr9868DHBba+gY4brGgRirOzQgdNvUBBJxFqyM
 mLRgTzswhkuBukt/9pDXwM3A2qZ8IIajyFDKW9aIo1j1j2p+UUQPNBrNEypdkY/fHOamth4l2O/MmQDolGW/QoFGPfzeKIcZrKBYogn6sI44pcbOHCp6thMt
 Y5xoY8Xw7NSqyhtL/KDG4hzzOSjm4ibSUY7Qxe56qaX74l5F34V0PxC3w+gxNHCRWKY4Xxg1qptR+nnoC4pdZQeM9O5IjX/xMj8RApBZ4EiVO4R3G0tRsnko
 k9CNEsBRDql69PX45vBm9/DHYTb3pqo1g6Y/787aW0Ce7/eX3HMKkglTy4eD5qgWKy6eTBcv3Tu2xcPiRaeKi3f4qZu3fFizD/3R1bHj0Xgz/sccSSvSWjic
 UBgK5sPz7+0D8zoTZZk5UcKYj4dPF9lQroIJtwBjbvnzb0MeCr3X1NKQVZvzDtFHsdXeAJmV7NrSK65/oVfTAklmpJfDFueUkiQeDqTkAk5Cdw==
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

