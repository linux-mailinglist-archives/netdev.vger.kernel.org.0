Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672C53598E9
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 11:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhDIJMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 05:12:03 -0400
Received: from mail-db8eur05on2078.outbound.protection.outlook.com ([40.107.20.78]:64512
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232772AbhDIJMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 05:12:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7kVuc+KjGV7RWn5+DEOKfLHc48gBBF4eSijFCFSj6IbR1m0TzXF+MseNxgMXTILt7cPJHuIrKNeVvWYsyFXog31PMXKBK+g1g84HwU8AGl/DjYqcC8MDJulx8Nr1JeMAa8pyACs186QA284kGRgDw3hCZyJ3YRyzJphamV0H6ycrvpJP0SN9FLRHabbiSVam2uCAGWn1I8+AgZdCHGpclNHs3pmPDuADuvpCNBWJtyfCWLyCAsvObPZzuA+EEj4tTtFcdny/Sx8Vd9N1xP0XLILytCihxyOoNW/sazNVIAzBMJ7EZ4uIyIBHX1cmh9mQEydqglBUdhBK45yilRM1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rd7IY+5jnBiuRqNvY6f9REYT2D9VryMk0VYs5ot3klo=;
 b=aLqxjJQZ0V6DjJ8n9F3Kb7nrjSoo/YoKiv0ydw2n6Xr14IMjSBM7eO6GMRSYA5bKWR7R6yklknkOdZP6NLzXXcchrke+hGiwGKFslMA70gs2Oy6By0HtzzJM5z7XK7KYv3x/qCtaVJ2hArEh8uJEBN0kg4/MxFoNeuPh2KWzHhy6HPyX8j0acQo8EL3qNmtjg2ewxM5VLu1phbKHwgqPpju2tr4xfofYZPPhVIWjPca55ioqYADpMhKXRqstHrntQ0b5iGhkW+KRTGt/c/1PiVyir9TW2JtLT/WqAKe0S+ETKX2xy+Nh3mKMqngjslq1wQMbIn24MM0dF0+unfzz9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rd7IY+5jnBiuRqNvY6f9REYT2D9VryMk0VYs5ot3klo=;
 b=Gnv4avr5QfBv4Pr9XI1kQ1qPrX1tbwugYBa/gbvF8WGI5zbVgkAA6lBWDhoMoFIJ+SjPbqziLBLxPVqxbN46uCCb5GAz/Nm3A2EJJtCnoAp/MF0/gP7BX+RMOyPNVz0peA9PQov4or3a20XhjabKBySVhLI3iGeqeP8FR3Spudc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3705.eurprd04.prod.outlook.com (2603:10a6:8:c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 9 Apr
 2021 09:11:46 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Fri, 9 Apr 2021
 09:11:46 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, linux-imx@nxp.com
Subject: [PATCH] MAINTAINERS: update maintainer entry for freescale fec driver
Date:   Fri,  9 Apr 2021 17:11:45 +0800
Message-Id: <20210409091145.27488-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR06CA0010.apcprd06.prod.outlook.com
 (2603:1096:202:2e::22) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR06CA0010.apcprd06.prod.outlook.com (2603:1096:202:2e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 09:11:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0743dd37-7bff-426b-56c0-08d8fb377fed
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3705:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB37053F27FB7BC63C322BA1FEE6739@DB3PR0402MB3705.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JlmesmpxsoY1oQ0Bc4IJjsv6/w3OoeTypuzuAv8voLja6rMvpkNcqrfdKstvv1itQH4NGOa8PS5EcWfjIt3jPO7a9Y9UNBwNztOXoVX+p8bASYB95gH7Xci2qNUXvZ1ePm6RhaUQfJtjv0MZC5378I2UCgceCfotExDjNx5B3qFtJG/tm0XPv2hiZJfDHcRQ6c/sQDnAIS3maBg/i6UHCanba4CBLzqSFUs4yrz5ugU6B7lrWcY2k4qUD4JR6zW/c/PeA7HqmfP8fq05XxKb4QtJcE0ZPrHOJfV/HM9/HqktnNrjPlGlF9CzHFuJVwXsvsYVAJIKx71Asc3PclpKQt+laVk2AiudJnubPY97l7AFCywl6uDy9GiIezCKOp6704WCr+Q7Lewu10GdNCNXogxZh0/uuyXB7yalifArSTTOpWbIouwCuGM4yheHE8/YeD83LPeyfAC4G3AtFjU2KnDttx3CNXflQjR6VIzLq0VY6+bLyHgt0iLex5AHMsw513UShcGBpc2+U4ziEbmX229gzWnCSX9BrPb5s/OcofEq7fHohXa7A+tASmLOxRHO+RXbJHuLK2soUtMR2nnwyCjXyiJXLdiNgF9VZJMo4/ri3vyVedWLi9d4vbxFMMML8oFjvkIibWai7S9snsv3jg9Ojaq/VR6alHlL8SDSTsE1UR0ghHVWAULH5CZ2hwdcRnRqMB+o+grs1pSnKc2FU36zIxFuHIgFkoW7Z9WDvtM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(66476007)(316002)(38350700001)(4326008)(2906002)(66556008)(8936002)(6506007)(6486002)(956004)(15650500001)(478600001)(26005)(1076003)(66946007)(2616005)(83380400001)(16526019)(186003)(5660300002)(86362001)(38100700001)(36756003)(52116002)(6512007)(4744005)(8676002)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4o2e9ChHHP3dFZJq4T9qCgu2riUwodJ6TPU3POeYEAeiVJF73CQuPDGgxscb?=
 =?us-ascii?Q?+JbK/rs5edbMb1I91Kdx6kKMno4INWX0ASqAzCDpT7QaFd2Un7CKnOt+Z6iq?=
 =?us-ascii?Q?z4nuCM40dJ3iuhIqN/Sd3h5piFUvqL9YG8iHxnGvrBbqidxXA6+rshxjB12H?=
 =?us-ascii?Q?twyo0MQcu9y6pEGLWtyM9mjaqeNUzMZg3tRfuoR5bMiVZEMSuPwqgdNrF4+Q?=
 =?us-ascii?Q?KTcICtmFm2s0p1idOWbz1K+DpsyHQqjF1tmPHh5IwR5WE3I4JxF0eg8lfy9L?=
 =?us-ascii?Q?GmrnA8M3T/mEkVPpYSTT8M6MQ7zwAb6eTo5tss0Ff35OujUIw+O5xtMlFRxD?=
 =?us-ascii?Q?tf+HxZcrbwag7Coi1HRML5aUqtlsNxYWo8W/nK5bAPSEBoK6FcFgR6I2BgMe?=
 =?us-ascii?Q?IxNS8J7xP6520VP/S9+2bmnyqAFioaVqYku5FwqxTrbW3yRsyBvP1Jju2bxc?=
 =?us-ascii?Q?nCfc5XW5V96GNQ/B44ljf1Ayy6iFdC86T/AbFgPCVQEUpyHdhz0y/m9ZUHOE?=
 =?us-ascii?Q?eYPekpkSKN1QAu1D27Jqe7e7vjCJv3wX1FO9zbJn+CHJkNZpH2PC3DlxKRyR?=
 =?us-ascii?Q?++GB/oBEdpc1siEdTfGL6B3Dzw5zaWvKAS86R/JeBFlxXmlyB1WHHrQonAks?=
 =?us-ascii?Q?TiSUOyzjto+MpRsAohrM9r+1BORtT+TXyhuSR10n/LfFT/dcB1QCjK1HIVSg?=
 =?us-ascii?Q?eYR6QDDl02EoYyzBueC6+MOgMXh4F0ZF3Dk4Fs/QikaTITkqDgLHwvhYlaFt?=
 =?us-ascii?Q?CRue0KEVYgHexlvbh9MuR4moBkIPPRDUzV+VUiXdYslO/LsPn85ebjSK4Vzg?=
 =?us-ascii?Q?+YjrPMtheOPkaLDa64K8FHd6E4QBPdxSP/Bd/g4Z/5zAUQoo4N4I9gQ3BRmv?=
 =?us-ascii?Q?FxyXyEQ0ounW/ixnKkbACz4gOTQVYrG1VN9LZkoBDAUvhBTL3lQa9nxxSZI5?=
 =?us-ascii?Q?/BAMY4jGJfXlkcDgO8qYbisD6LgbQNOCaB/1XnGaKOOZmaPhHNJJdNDZQjW5?=
 =?us-ascii?Q?uVbnUmBA28DLepMuh4AdU+WNYroNHyZtL1LSrxwlv1gJQmZX5KISn/hETIRg?=
 =?us-ascii?Q?+hMRZpoAG/xEjMCxazYQfXb5JbfGj/RgkCmiXiDOmV+iWAwSDenPtPvlix1O?=
 =?us-ascii?Q?6XADRUSOxdNODlXEjoHBPos6gKeKSxITH+QgPsDPW6P9rn/rhNvyRG63BrMC?=
 =?us-ascii?Q?U2Ia0o16BLW2UDDrloU7ZjjzCQqTeK3Os/ZAnf+fMt/eG+ZaqQEsH7wmYcre?=
 =?us-ascii?Q?6akk7jyPWVQH0ZeLs8p0ZFczcIxt1rNbJEVdzlE5bh/X9ce7LMTcZs7tlOMP?=
 =?us-ascii?Q?3VfuSPs5zDy0jA06jJH4Ebeh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0743dd37-7bff-426b-56c0-08d8fb377fed
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 09:11:46.4005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17JWnYMOBAZSrZsogBmr/pELBf9fLNoIRDBwoDnxw8QkoKuHPvxD+Kw0gNhykZRxCmvU//z+4WGoKFdk3R0nQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3705
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update maintainer entry for freescale fec driver.

Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1cc3976040d5..efc76153114c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7091,7 +7091,7 @@ S:	Maintained
 F:	drivers/i2c/busses/i2c-cpm.c
 
 FREESCALE IMX / MXC FEC DRIVER
-M:	Fugang Duan <fugang.duan@nxp.com>
+M:	Joakim Zhang <qiangqing.zhang@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/fsl-fec.txt
-- 
2.17.1

