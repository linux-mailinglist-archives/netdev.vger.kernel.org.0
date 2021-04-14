Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCC935F5DD
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351781AbhDNOGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:06:39 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:47940 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348295AbhDNOGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:06:18 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13EE5Wgu011837;
        Wed, 14 Apr 2021 09:05:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618409132;
        bh=IlU5JTHbgq4me6qjMbuUKqaDA5SuF5DOc/xXRU46LRk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=aciUSPPkr5LOFvGp9aEIqjd0H9j5GrYgSaRhrl/7HxHNsJLrTJmuk7dN3f5tZE3P9
         5sfk4cppyA/6SMjjCHNNV8C3df1G4pP9FNsI8e4U4ft22pyOm4RHbb05brD3rEfzQF
         79CPUwNW08FbPS2xI5Cq6j8tTL0AvtuQ5IHofgck=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13EE5VZt119446
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Apr 2021 09:05:31 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 14
 Apr 2021 09:05:31 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 14 Apr 2021 09:05:31 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13EE5Lu9074247;
        Wed, 14 Apr 2021 09:05:27 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-phy@lists.infradead.org>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>
Subject: [PATCH v2 1/6] phy: core: Reword the comment specifying the units of max_link_rate to be Mbps
Date:   Wed, 14 Apr 2021 19:35:16 +0530
Message-ID: <20210414140521.11463-2-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210414140521.11463-1-a-govindraju@ti.com>
References: <20210414140521.11463-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some subsystems (eg. CAN, SPI), the max link rate supported can be less
than 1 Mbps and if the unit for max_link_rate is Mbps then it can't be
used. Therefore, leave the decision of units to be used, to the producer
and consumer.

Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
---
 include/linux/phy/phy.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 0ed434d02196..f3286f4cd306 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -125,7 +125,7 @@ struct phy_ops {
 /**
  * struct phy_attrs - represents phy attributes
  * @bus_width: Data path width implemented by PHY
- * @max_link_rate: Maximum link rate supported by PHY (in Mbps)
+ * @max_link_rate: Maximum link rate supported by PHY (units to be decided by producer and consumer)
  * @mode: PHY mode
  */
 struct phy_attrs {
-- 
2.17.1

