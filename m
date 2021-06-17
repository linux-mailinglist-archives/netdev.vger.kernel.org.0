Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38C13AB034
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 11:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhFQJvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 05:51:43 -0400
Received: from first.geanix.com ([116.203.34.67]:41950 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231926AbhFQJvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 05:51:35 -0400
Received: from localhost (unknown [185.17.218.86])
        by first.geanix.com (Postfix) with ESMTPSA id A0E214C329E;
        Thu, 17 Jun 2021 09:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1623923366; bh=TsS7BAMz2l0iG7vhnR5TeopRChL28In0UoMCZn1qkw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=QGwXIf1uXAkOYFZlTSJnJFCQGKXNOfQYSVeyrAxePSlzmknUftDpJd0V1TrOBtzmp
         tuqfXyCrfkFgULgOyBfP3i0vUN0HT6y4hzld+lZBpNbybCwNfkyUEzvnUcvhKLwBTJ
         Wobi9zywUN3bgPJkNzIYP8p3O6cO4hyLSE9sbXqvVVL5EPH8vjeH7vIEvFKZlpzC8K
         mdEZZlUV/POqI1GSP4IUA3DGJmKZLMSClU4tIspNP5u1/E4Ff/YscAkak1dX/KqUxA
         vQ+34eKsixFELWPlzT2wywNRyODSvLICpFFfgZsm+Sp4jJcMK0kQp4LJDpv5O+JhNr
         8T3q3Pd7EeDpw==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5/6] net: gianfar: Add definitions for CAR1 and CAM1 register bits
Date:   Thu, 17 Jun 2021 11:49:26 +0200
Message-Id: <dcc317a8868b473eff26a8fea44c234db1c11e85.1623922686.git.esben@geanix.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1623922686.git.esben@geanix.com>
References: <cover.1623922686.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are for carry status and interrupt mask bits of statistics registers.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/freescale/gianfar.h | 54 ++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index d8ae5353e881..c8aa140a910f 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -445,6 +445,60 @@ struct ethtool_rx_list {
 #define RQFPR_PER		0x00000002
 #define RQFPR_EER		0x00000001
 
+/* CAR1 bits */
+#define CAR1_C164		0x80000000
+#define CAR1_C1127		0x40000000
+#define CAR1_C1255		0x20000000
+#define CAR1_C1511		0x10000000
+#define CAR1_C11K		0x08000000
+#define CAR1_C1MAX		0x04000000
+#define CAR1_C1MGV		0x02000000
+#define CAR1_C1REJ		0x00020000
+#define CAR1_C1RBY		0x00010000
+#define CAR1_C1RPK		0x00008000
+#define CAR1_C1RFC		0x00004000
+#define CAR1_C1RMC		0x00002000
+#define CAR1_C1RBC		0x00001000
+#define CAR1_C1RXC		0x00000800
+#define CAR1_C1RXP		0x00000400
+#define CAR1_C1RXU		0x00000200
+#define CAR1_C1RAL		0x00000100
+#define CAR1_C1RFL		0x00000080
+#define CAR1_C1RCD		0x00000040
+#define CAR1_C1RCS		0x00000020
+#define CAR1_C1RUN		0x00000010
+#define CAR1_C1ROV		0x00000008
+#define CAR1_C1RFR		0x00000004
+#define CAR1_C1RJB		0x00000002
+#define CAR1_C1RDR		0x00000001
+
+/* CAM1 bits */
+#define CAM1_M164		0x80000000
+#define CAM1_M1127		0x40000000
+#define CAM1_M1255		0x20000000
+#define CAM1_M1511		0x10000000
+#define CAM1_M11K		0x08000000
+#define CAM1_M1MAX		0x04000000
+#define CAM1_M1MGV		0x02000000
+#define CAM1_M1REJ		0x00020000
+#define CAM1_M1RBY		0x00010000
+#define CAM1_M1RPK		0x00008000
+#define CAM1_M1RFC		0x00004000
+#define CAM1_M1RMC		0x00002000
+#define CAM1_M1RBC		0x00001000
+#define CAM1_M1RXC		0x00000800
+#define CAM1_M1RXP		0x00000400
+#define CAM1_M1RXU		0x00000200
+#define CAM1_M1RAL		0x00000100
+#define CAM1_M1RFL		0x00000080
+#define CAM1_M1RCD		0x00000040
+#define CAM1_M1RCS		0x00000020
+#define CAM1_M1RUN		0x00000010
+#define CAM1_M1ROV		0x00000008
+#define CAM1_M1RFR		0x00000004
+#define CAM1_M1RJB		0x00000002
+#define CAM1_M1RDR		0x00000001
+
 /* TxBD status field bits */
 #define TXBD_READY		0x8000
 #define TXBD_PADCRC		0x4000
-- 
2.32.0

