Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B228227813D
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgIYHK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:10:28 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:22663
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbgIYHK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 03:10:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKywID47uU59S6SdHCfws6UQABFCZW4B/H+bU6VYMw2SJhNFBfwSWYP3VZpRSMJKllFPkrUlcQziSvyxfvRYjMDed/F9/INEoQsPbXxHlQhVSdVzkRVOn2EWcGmceu7F/3u1QwAHU0WCMSbQU3s5Ahvu6TTEvMsj6+TUKS3ua3O4y+RTjxqrMoPeRO8sVkzxlAgP577wpr5koWxcaPyG7ThyCuWVRbGmZwHJGkesFoOAoil9cBwy7nFk0LfV5kE4R6o769YyZ3cZA+hB0A2V6glGbxY/Ovg/aPJSXrMhcYX10usIz4jCpIXRprSV4/E0qoHbI3GB7ZqdljTrpb4Sfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2/9N695CiDKJaixvpibrWBHOti/bYR/nt/3COkjfUQ=;
 b=EMTFIX+B4aiD01YWnb+eMmNbFJ3d3UeZ7ZII3ddhk+UCQuiDzOKrE5mP0SQ1wS8M/aqHPRgSTIsbnPJUZDDKmxz/5OdWtc+Wxg09TysXUGWGEeY/krY/oAbYywSQvhgYYEre5ScjZEiEgUdeeRKfTz2LVvd+ZGaCPfUmmKL+sIM5DagI/GzVuc3zbEqwBW0Aj9Ft7sjkbtQin0/ZUx9FjFSyRMF1uyQ1d67/0DZjmpWK8on4YTtpg3T1KmaHbotrBDZCUKwLAcq0ubbRFsoJcPRBi6mEN6/9BYp6aDUk0AU6CQl6xzOj+o8o1QoyOKt69KH4tUkPAKQ7Z7CEI6PECQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2/9N695CiDKJaixvpibrWBHOti/bYR/nt/3COkjfUQ=;
 b=m9bEKPc/34v8Q1KxAZF99BCr/3wOB1FXluo9TfMYseT2MSpGuGSGaJCMSd/Q/jj2G99h/TNyRV8K/I2/oebASVl6+tQy0uMJN/jH7xOJBqWu++EfNo52NyVxVsyUhp9mIQgDH/GJ2i2tnfIk2GSnn/746tF4/ilq5BcKkVkyWGU=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Fri, 25 Sep
 2020 07:10:24 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 07:10:24 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH linux-can-next/flexcan 0/4] patch set for flexcan
Date:   Fri, 25 Sep 2020 23:10:24 +0800
Message-Id: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0240.apcprd06.prod.outlook.com
 (2603:1096:4:ac::24) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0240.apcprd06.prod.outlook.com (2603:1096:4:ac::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 07:10:22 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e07a8653-33ca-49e0-19a5-08d861221275
X-MS-TrafficTypeDiagnostic: DB8PR04MB6971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB69717377A50A8DEE9CBED64BE6360@DB8PR04MB6971.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6N3foUJ6TFm4Tm8JJti1YrgfN7uaTHhNL6pvzB8guVQ02hBH/iEDsWI4KkKEwwG+XMOYj4s6pveMJvFHGObV1sD3FYPADNj5jo/sJHhC+h7FMGUwvSf9DnEpbzCHTsb/RFD3xeD/A2IrUja3/12R6/EgSxqHnHDRg3DmsR1+HKZD0VmTGglrfbSjqmo4FhmR8rdwNkoolBLp/cxpk6Z0deZPgs2AqR6rjRcyFdN2b7xa+T+Nv063yfVgtkDNi2uzg8m/RAS0UiVi0sh2JrLwE9+KsXQ+r9OE1d7Pxca17haiCXo8VAWZ6ZHUhkuxg1dsK4JpSyMquTro6SpzODml2NelWrt0yu01QgsUzraJSbj/hZXtNOaRnpBFj5atEZ72ISAD3BL2vNENEfbB04L0xqrV7loPlH5YuxsZix9oEdIMYhEqU44Q5Ed9DgNqMe/B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(478600001)(6486002)(66556008)(956004)(2616005)(1076003)(66476007)(36756003)(16526019)(186003)(5660300002)(4744005)(26005)(66946007)(69590400008)(316002)(8936002)(6506007)(4326008)(2906002)(86362001)(6512007)(83380400001)(52116002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: D7ahpPt+wF1EO1vMxz6Sn7pbW0yII5OaJsygNBDbXYy4EXac/b1f/P9gZNFUMpHACE2ZQaUwN8Wk2Hy8S8S9RCR30063AnmsAW1g+KRbqBhFd6DfU7Z2n4GG5Z73HyV/10twtmDrjf9LVkial1dA6tZ67h8Fz1z7xAj4wk9RrVGhMns0yOH1gCuGEM/iV0ASE8y7zWnsmkiFPIJs9HSK4mDBLu2EhbpgsdOl2YdHV/8VEID2P8/HdZiekGU/FxnbkhOb9Z0RaHyE8xzv97SN5svWAAh+1LOuKeXMSM3ewDHP9b++CsRraGSLloHyK/D0SeqFawkSBijpcxHTOaYI9eRuNZpbNEFJ+7hVeqpF1pYCCVd12gUDoJ5TusLO94z87nbHE4tNWhX56JMooMF49zhJxelpoaIj1F9KZDCtDAAwkGaLU+opm1O+krJahyWDy/7T1Cl+t7nYixhpLAM6DgN2/EqPKcCAbgKXkhWytKKEpeHEf2Wkya8/7pw908unk9xkAQe/uDO3/S2KHwXwAcibnB23QZ3OWD1fa5CgvlOt4dIKL2kFvuCXRcesUNpJ0/R/Zipwtnag8lIbYN+9XMK/K2OtHYd+gDJqvmfcC+EtHapeuAijhmpqDu0Tla/2Sr/ZfJzeE3H0GmOGqQAT/g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e07a8653-33ca-49e0-19a5-08d861221275
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 07:10:24.2249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KNXti2FwrPUrv2ePQZS3/7BNDD8+rQzojeiY6iTQbdlBLq8I7uAeWNwYAOiUCgqbgBkOm7U37jMPU0HzayQLRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

can: flexcan: initialize all flexcan memory for ECC function
can: flexcan: add flexcan driver for i.MX8MP
These two patches add i.MX8MP driver support.

can: flexcan: add CAN wakeup function for i.MX8
This single patch add stop mode support for i.MX8 serials, e.g.
i.MX8QM/QXP

can: flexcan: disable runtime PM if register flexcandev failed
Resend this patch as a small driver improvement.

Joakim Zhang (4):
  can: flexcan: initialize all flexcan memory for ECC function
  can: flexcan: add flexcan driver for i.MX8MP
  can: flexcan: add CAN wakeup function for i.MX8
  can: flexcan: disable runtime PM if register flexcandev failed

 drivers/net/can/flexcan.c | 184 ++++++++++++++++++++++++++++++++++----
 1 file changed, 169 insertions(+), 15 deletions(-)

-- 
2.17.1

