Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D755F5802EF
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 18:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbiGYQkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 12:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236374AbiGYQkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 12:40:03 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A091D324;
        Mon, 25 Jul 2022 09:40:03 -0700 (PDT)
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26PFFNVB017806;
        Mon, 25 Jul 2022 12:39:39 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3hgau76c5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 12:39:39 -0400
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 26PGdcHw000662
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 25 Jul 2022 12:39:38 -0400
Received: from ASHBCASHYB5.ad.analog.com (10.64.17.133) by
 ASHBMBX9.ad.analog.com (10.64.17.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Mon, 25 Jul 2022 12:39:37 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB5.ad.analog.com (10.64.17.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Mon, 25 Jul 2022 12:39:37 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Mon, 25 Jul 2022 12:39:36 -0400
Received: from localhost.localdomain ([10.48.65.12])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 26PGd7uJ014141;
        Mon, 25 Jul 2022 12:39:32 -0400
From:   <alexandru.tachici@analog.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <devicetree@vger.kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <gerhard@engleder-embedded.com>, <geert+renesas@glider.be>,
        <joel@jms.id.au>, <stefan.wahren@i2se.com>, <wellslutw@gmail.com>,
        <geert@linux-m68k.org>, <robh+dt@kernel.org>,
        <d.michailidis@fungible.com>, <stephen@networkplumber.org>,
        <l.stelmach@samsung.com>, <linux-kernel@vger.kernel.org>
Subject: [net-next v2 1/3] net: phy: adin1100: add PHY IDs of adin1110/adin2111
Date:   Mon, 25 Jul 2022 19:53:10 +0300
Message-ID: <20220725165312.59471-2-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220725165312.59471-1-alexandru.tachici@analog.com>
References: <20220725165312.59471-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: Tmxlj4nY4QKo9TVk1Wuvd-AzouIv_49_
X-Proofpoint-ORIG-GUID: Tmxlj4nY4QKo9TVk1Wuvd-AzouIv_49_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-25_12,2022-07-25_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 mlxlogscore=838 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207250066
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Add additional PHY IDs for the internal PHYs of adin1110 and adin2111.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/phy/adin1100.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/adin1100.c b/drivers/net/phy/adin1100.c
index b6d139501199..7619d6185801 100644
--- a/drivers/net/phy/adin1100.c
+++ b/drivers/net/phy/adin1100.c
@@ -15,6 +15,8 @@
 #include <linux/property.h>
 
 #define PHY_ID_ADIN1100				0x0283bc81
+#define PHY_ID_ADIN1110				0x0283bc91
+#define PHY_ID_ADIN2111				0x0283bca1
 
 #define ADIN_FORCED_MODE			0x8000
 #define   ADIN_FORCED_MODE_EN			BIT(0)
@@ -265,7 +267,8 @@ static int adin_probe(struct phy_device *phydev)
 
 static struct phy_driver adin_driver[] = {
 	{
-		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1100),
+		.phy_id			= PHY_ID_ADIN1100,
+		.phy_id_mask		= 0xffffffcf,
 		.name			= "ADIN1100",
 		.get_features		= adin_get_features,
 		.soft_reset		= adin_soft_reset,
@@ -284,6 +287,8 @@ module_phy_driver(adin_driver);
 
 static struct mdio_device_id __maybe_unused adin_tbl[] = {
 	{ PHY_ID_MATCH_MODEL(PHY_ID_ADIN1100) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_ADIN1110) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_ADIN2111) },
 	{ }
 };
 
-- 
2.25.1

