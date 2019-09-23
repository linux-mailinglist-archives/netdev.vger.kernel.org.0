Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D137ABAFA2
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 10:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406580AbfIWIeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 04:34:07 -0400
Received: from mail-eopbgr690060.outbound.protection.outlook.com ([40.107.69.60]:59267
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405465AbfIWIeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 04:34:07 -0400
Received: from DM6PR02CA0047.namprd02.prod.outlook.com (2603:10b6:5:177::24)
 by BY5PR02MB6418.namprd02.prod.outlook.com (2603:10b6:a03:1f7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.25; Mon, 23 Sep
 2019 08:34:03 +0000
Received: from CY1NAM02FT061.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::204) by DM6PR02CA0047.outlook.office365.com
 (2603:10b6:5:177::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.19 via Frontend
 Transport; Mon, 23 Sep 2019 08:34:03 +0000
Authentication-Results: spf=softfail (sender IP is 149.199.60.83)
 smtp.mailfrom=gmail.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=fail action=none header.from=gmail.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 gmail.com discourages use of 149.199.60.83 as permitted sender)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT061.mail.protection.outlook.com (10.152.75.30) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2284.25
 via Frontend Transport; Mon, 23 Sep 2019 08:34:03 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <shubhrajyoti.datta@gmail.com>)
        id 1iCJnF-0000I5-EN; Mon, 23 Sep 2019 01:34:01 -0700
Received: from localhost ([127.0.0.1] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <shubhrajyoti.datta@gmail.com>)
        id 1iCJnA-0001Nx-A0; Mon, 23 Sep 2019 01:33:56 -0700
Received: from [10.140.6.59] (helo=xhdshubhraj40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <shubhrajyoti.datta@gmail.com>)
        id 1iCJn9-0001NG-Cm; Mon, 23 Sep 2019 01:33:55 -0700
From:   shubhrajyoti.datta@gmail.com
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, shubhrajyoti.datta@gmail.com,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Subject: [PATCHv1] net: macb: Remove dead code
Date:   Mon, 23 Sep 2019 14:03:51 +0530
Message-Id: <1569227631-32617-1-git-send-email-shubhrajyoti.datta@gmail.com>
X-Mailer: git-send-email 2.1.1
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No--1.529-7.0-31-1
X-imss-scan-details: No--1.529-7.0-31-1;No--1.529-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-Matching-Connectors: 132137012434589400;(f9e945fa-a09a-4caa-7158-08d2eb1d8c44);()
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(136003)(346002)(189003)(199004)(8676002)(2616005)(126002)(476003)(48376002)(50226002)(50466002)(61266001)(426003)(9686003)(107886003)(76482006)(16586007)(498600001)(47776003)(486006)(82202003)(73392003)(26005)(336012)(86362001)(55446002)(8936002)(305945005)(4326008)(316002)(9786002)(51416003)(2906002)(70206006)(356004)(36756003)(70586007)(5660300002)(81166006)(81156014)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR02MB6418;H:xsj-pvapsmtpgw01;FPR:;SPF:SoftFail;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cad15e1-a298-480c-db2b-08d74000ca47
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(5600167)(711020)(4605104)(1401327)(2017052603328);SRVR:BY5PR02MB6418;
X-MS-TrafficTypeDiagnostic: BY5PR02MB6418:
X-Microsoft-Antispam-PRVS: <BY5PR02MB6418B3F3108F035F1ADC675287850@BY5PR02MB6418.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-Forefront-PRVS: 0169092318
X-Microsoft-Antispam-Message-Info: nsd46ajBS8WWbuKAoRy6QIpOcX7RVQmwLBN8S2lqBnB8T74pB6xfEzVNMD0+2iV2t/Jo5OXWbkuj07wTdV9QK0e0pVi+s/zFD0w/KL0aLZmEwCXtCdivh2LkdCX0Dgt70o4Bks+TS1TDOIR2pOvejnTRljWUMQgYmwBZu7bUxgbwpzf4IlJaX0PZez4W2AOZ/oOeSrmZH6TVYRYLpyXFZM2sEcDCuNS/mxupiXVICpcIJiG3PYeXn7cBPeb4XdFzIoo0B0e3BT7nzjYOsmrd6Y4capA2RTJsiE5E/9lzgu4Ig9qrvBVhkl69uh1uML0GqE84/qrlP3dlx6G9Dfz3K+VeR/1E1krluR3lmHWgEbLJ0kF6gsKEQv6syJKKrjHzba2K4BTjqUOdYrCZuOJtVyaAh7Mfrkm7ROYRCOIBXeA=
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2019 08:34:03.2707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cad15e1-a298-480c-db2b-08d74000ca47
X-MS-Exchange-CrossTenant-Id: 5afe0b00-7697-4969-b663-5eab37d5f47e
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5afe0b00-7697-4969-b663-5eab37d5f47e;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6418
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

macb_64b_desc is always called when HW_DMA_CAP_64B is defined.
So the return NULL can never be reached. Remove the dead code.

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 35b59b5..8e8d557 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -165,9 +165,8 @@ static unsigned int macb_adj_dma_desc_idx(struct macb *bp, unsigned int desc_idx
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 static struct macb_dma_desc_64 *macb_64b_desc(struct macb *bp, struct macb_dma_desc *desc)
 {
-	if (bp->hw_dma_cap & HW_DMA_CAP_64B)
-		return (struct macb_dma_desc_64 *)((void *)desc + sizeof(struct macb_dma_desc));
-	return NULL;
+	return (struct macb_dma_desc_64 *)((void *)desc
+		+ sizeof(struct macb_dma_desc));
 }
 #endif
 
-- 
2.1.1

