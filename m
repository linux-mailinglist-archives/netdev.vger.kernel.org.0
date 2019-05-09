Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A669B18DB2
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfEIQLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:11:15 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:32906 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfEIQLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:11:14 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x49GB3I2109737;
        Thu, 9 May 2019 11:11:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1557418263;
        bh=vYDEaMEL5i/DNwQ5MyfpbPCp2Sb+a1ukplyuBk6CKH4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=OzGwQQg26KKFe+AmQUdYMx98QjB1RGu3PgrhPqXvYyKm26Mv3NaRDPXcHTL7mXMeP
         LQ+b6mEkie8DmE1RDwwN87tSwkOnMISpGA2wGWTl71xJa+4JwebZW64GrKCHBTUSfG
         /AFT4pzc5zDN4OWYuWy8WdtYhqQvKmky64H1izz0=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x49GB34G036053
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 May 2019 11:11:03 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 9 May
 2019 11:11:03 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 9 May 2019 11:11:03 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x49GB3HP044771;
        Thu, 9 May 2019 11:11:03 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH v12 5/5] can: m_can: Fix checkpatch issues on existing code
Date:   Thu, 9 May 2019 11:11:09 -0500
Message-ID: <20190509161109.10499-5-dmurphy@ti.com>
X-Mailer: git-send-email 2.21.0.5.gaeb582a983
In-Reply-To: <20190509161109.10499-1-dmurphy@ti.com>
References: <20190509161109.10499-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix checkpatch issues found during the m_can framework creation.
The code the issues were in, was in untouched code and these
changes should be done separately as to not be confused with the
framework changes.

Fix these 3 check issues:
CHECK: Unnecessary parentheses around 'cdev->can.state != CAN_STATE_ERROR_WARNING'
	if (psr & PSR_EW &&
	    (cdev->can.state != CAN_STATE_ERROR_WARNING)) {

CHECK: Unnecessary parentheses around 'cdev->can.state != CAN_STATE_ERROR_PASSIVE'
	if ((psr & PSR_EP) &&
	    (cdev->can.state != CAN_STATE_ERROR_PASSIVE)) {

CHECK: Unnecessary parentheses around 'cdev->can.state != CAN_STATE_BUS_OFF'
	if ((psr & PSR_BO) &&
	    (cdev->can.state != CAN_STATE_BUS_OFF)) {

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---

v12 - No Changes - https://lore.kernel.org/patchwork/patch/1052304/

v11 - New change to clean up last remaining checkpatch issues on original code.

 drivers/net/can/m_can/m_can.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 923c53204d7d..ef4282a98fe1 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -733,22 +733,19 @@ static int m_can_handle_state_errors(struct net_device *dev, u32 psr)
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int work_done = 0;
 
-	if ((psr & PSR_EW) &&
-	    (cdev->can.state != CAN_STATE_ERROR_WARNING)) {
+	if (psr & PSR_EW && cdev->can.state != CAN_STATE_ERROR_WARNING) {
 		netdev_dbg(dev, "entered error warning state\n");
 		work_done += m_can_handle_state_change(dev,
 						       CAN_STATE_ERROR_WARNING);
 	}
 
-	if ((psr & PSR_EP) &&
-	    (cdev->can.state != CAN_STATE_ERROR_PASSIVE)) {
+	if (psr & PSR_EP && cdev->can.state != CAN_STATE_ERROR_PASSIVE) {
 		netdev_dbg(dev, "entered error passive state\n");
 		work_done += m_can_handle_state_change(dev,
 						       CAN_STATE_ERROR_PASSIVE);
 	}
 
-	if ((psr & PSR_BO) &&
-	    (cdev->can.state != CAN_STATE_BUS_OFF)) {
+	if (psr & PSR_BO && cdev->can.state != CAN_STATE_BUS_OFF) {
 		netdev_dbg(dev, "entered error bus off state\n");
 		work_done += m_can_handle_state_change(dev,
 						       CAN_STATE_BUS_OFF);
-- 
2.21.0.5.gaeb582a983

