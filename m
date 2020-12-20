Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B48F2DF511
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 12:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgLTLFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 06:05:40 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58070 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727076AbgLTLFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 06:05:40 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BKAwg3X005816;
        Sun, 20 Dec 2020 03:02:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=a9qmBmRPfawjMhGn0bzMS3ZzLiiICStBEX4CiZ9DOFY=;
 b=FKovx+32UIhP/TMQJb/NdSeaVW07ISzeuIrlxyRI2oFCpzms8EYVEzJvTcgSoU/tL7QP
 PUqvcvoR5gLaN0zD98nWxnuYFlzSNbabCifBS9avTfEvvdN5ikPzDQSKgTeXzeqt/8e4
 KpVGsNa+hefEuXIxzXw7JEMAPnWqHp1XGGU/m6Gknllv900KkuTJlxwW508PxvLyr+TT
 A7qVUIi+1F0RrgaDEk+qUm27o2OYien/4XHbMwj/Y1lVs/ChVsQE5X9Po8tLIQJTtpRM
 Ar+HL36xV88CMsL3k9ZbNSc5Llee47QAyl6Z4GIBfHT2FzOGBvjb20foEJla0QGSIXOA WA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 35j4wvg1bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 20 Dec 2020 03:02:46 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 20 Dec
 2020 03:02:45 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 20 Dec
 2020 03:02:44 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 20 Dec 2020 03:02:44 -0800
Received: from stefan-pc.marvell.com (unknown [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 14B813F703F;
        Sun, 20 Dec 2020 03:02:41 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net v4] net: mvpp2: Fix GoP port 3 Networking Complex Control configurations
Date:   Sun, 20 Dec 2020 13:02:29 +0200
Message-ID: <1608462149-1702-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-20_03:2020-12-19,2020-12-20 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

During GoP port 2 Networking Complex Control mode of operation configurations,
also GoP port 3 mode of operation was wrongly set.
Patch removes these configurations.

Fixes: f84bf386f395 ("net: mvpp2: initialize the GoP")
Acked-by: Marcin Wojtas <mw@semihalf.com>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---

Changes in v4:
- Remove rename change.
Changes in v3:
- No changes.
Changes in v2:
- Added Fixes tag.

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d64dc12..82c6bef 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1231,7 +1231,7 @@ static void mvpp22_gop_init_rgmii(struct mvpp2_port *port)
 
 	regmap_read(priv->sysctrl_base, GENCONF_CTRL0, &val);
 	if (port->gop_id == 2)
-		val |= GENCONF_CTRL0_PORT0_RGMII | GENCONF_CTRL0_PORT1_RGMII;
+		val |= GENCONF_CTRL0_PORT0_RGMII;
 	else if (port->gop_id == 3)
 		val |= GENCONF_CTRL0_PORT1_RGMII_MII;
 	regmap_write(priv->sysctrl_base, GENCONF_CTRL0, val);
-- 
1.9.1

