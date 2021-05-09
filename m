Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA203776A5
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 14:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhEIMwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 08:52:36 -0400
Received: from smtp-35.italiaonline.it ([213.209.10.35]:53149 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229675AbhEIMwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 May 2021 08:52:33 -0400
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([95.244.94.151])
        by smtp-35.iol.local with ESMTPA
        id fim8lvyCKpK9wfimFlntVO; Sun, 09 May 2021 14:43:19 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1620564199; bh=UhV8rqTENwuZ3s7Sy5Xkw0YwPYTFwDkCVFGaL/kQI2w=;
        h=From;
        b=rLXtuXfu3CHd35KAlnf20j/SOodPwume18srm3/j7/FvFVY0jyewEtb7i1I7WGtKB
         ctLrAaHBobtfeuAcZFGt2b1fAGCMZjodYTIuE+1vvgqx0M/eP5zCx6PFWz4dlB8r41
         z38mpWn7gTpmlLW3YxDIwZ9z5lzRyttrdDBLKizLbqHrJWPSRLsM622tmvz1ZhGP9A
         qnn7xxmX7bKRdR9yIUXMQ3g66SUmtNXlR/2PzfOYShDDm8zIHwnvj9SuZ2vAGc/ji1
         obNMADzk3q86yyl9EU0l4ceHD5IsQrch60myJBRWnvKiYe/d3OA2RoHsEKJZJQ34eQ
         +CRhgbvnpUBWA==
X-CNFS-Analysis: v=2.4 cv=A9ipg4aG c=1 sm=1 tr=0 ts=6097d8e7 cx=a_exe
 a=ugxisoNCKEotYwafST++Mw==:117 a=ugxisoNCKEotYwafST++Mw==:17
 a=G6fnrvWBiLgj45YZLGUA:9
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/3] can: c_can: remove the rxmasked unused variable
Date:   Sun,  9 May 2021 14:43:07 +0200
Message-Id: <20210509124309.30024-2-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210509124309.30024-1-dariobin@libero.it>
References: <20210509124309.30024-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfLeBA7YIlgML9uS/zWAM3EWuzlbsvrGWpYBRNVYTJ50C8o7V9ZZ4dMUF17CEq4I58qOG2IvRufI7QOXChXGq67RpBO2xJ5Vf2W8ZpxPGd0v7ITpAaZAy
 TW5QKyzIU2+H40Oh/q6I0DAYxee3Q/w12skB+vTgsEJE6lb1btjpENqkc2tpzBPuvyM4vSqROCgJO9iS957lX+kCpCQ78SjflV0+P9KJbU/o6PrLRQGa4BRh
 A86S98mXDj0UytUXIeLY4VSmLc0bIW4kcRzBbC63/2l6oZ/skBqVYJwcOL67rt6kqBL20R7UqXiA7SUaQxuBMurTh5C9y6ueb/LtZa8KkDVtNHDgR4ujLvWZ
 45wML/E159Buxwvl5gPzqvJnpmdxjjuqMW5kTZEg7LB8NgYnZpfdObXmCRwzgiioQP24/vuePbKTGIt6XSMH9ZFlqtXpLO50n8Td+SGRzk14S7YZe2znNZ0A
 zkIwFxaM/6osqJYHtexOMqAH0ibF46APal3Uv8HluNrHmy4yhIcHF0YWyvN5r6Yo6EeH55BQAHZgvAkdV4UnkJblzHFYxZc4yhfYN6WeHwYa5rgD0tv1NWyo
 eYtakmw/9+xFG7O+SVcFQJmQD0yLbvZ7kCG2LiXvTUzkhQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialized by c_can_chip_config() it's never used.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

 drivers/net/can/c_can/c_can.c | 1 -
 drivers/net/can/c_can/c_can.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 313793f6922d..1fa47968c2ec 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -599,7 +599,6 @@ static int c_can_chip_config(struct net_device *dev)
 
 	/* Clear all internal status */
 	atomic_set(&priv->tx_active, 0);
-	priv->rxmasked = 0;
 	priv->tx_dir = 0;
 
 	/* set bittiming params */
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 06045f610f0e..517845c4571e 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -205,7 +205,6 @@ struct c_can_priv {
 	struct c_can_raminit raminit_sys;	/* RAMINIT via syscon regmap */
 	void (*raminit)(const struct c_can_priv *priv, bool enable);
 	u32 comm_rcv_high;
-	u32 rxmasked;
 	u32 dlc[];
 };
 
-- 
2.17.1

