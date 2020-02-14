Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFDEB15D990
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 15:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgBNOcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 09:32:33 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:36043 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728123AbgBNOcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 09:32:33 -0500
Received: from localhost (lfbn-lyo-1-1670-129.w90-65.abo.wanadoo.fr [90.65.102.129])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id E977824000A;
        Fri, 14 Feb 2020 14:32:29 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: cnic: fix spelling mistake "reserverd" -> "reserved"
Date:   Fri, 14 Feb 2020 15:32:24 +0100
Message-Id: <20200214143224.23517-1-alexandre.belloni@bootlin.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reserved member should be named reserved3.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 drivers/net/ethernet/broadcom/cnic_defs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/cnic_defs.h b/drivers/net/ethernet/broadcom/cnic_defs.h
index b38499774071..99e2c6d4d8c3 100644
--- a/drivers/net/ethernet/broadcom/cnic_defs.h
+++ b/drivers/net/ethernet/broadcom/cnic_defs.h
@@ -543,13 +543,13 @@ struct l4_kwq_update_pg {
 #define L4_KWQ_UPDATE_PG_RESERVERD2_SHIFT 2
 #endif
 #if defined(__BIG_ENDIAN)
-	u16 reserverd3;
+	u16 reserved3;
 	u8 da0;
 	u8 da1;
 #elif defined(__LITTLE_ENDIAN)
 	u8 da1;
 	u8 da0;
-	u16 reserverd3;
+	u16 reserved3;
 #endif
 #if defined(__BIG_ENDIAN)
 	u8 da2;
-- 
2.24.1

