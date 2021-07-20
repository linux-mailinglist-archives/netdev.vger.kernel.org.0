Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6EF3D0061
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbhGTQ6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 12:58:01 -0400
Received: from mail-eopbgr20056.outbound.protection.outlook.com ([40.107.2.56]:38117
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229708AbhGTQ5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 12:57:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kults/aRRAVCHXnkoGCSrpWcErh561X99BATN21YIaIdCSRsmEsLjLERHyez8v5qS2CM88JkQxnNrocI2rFmfLXVt1KujjjHRIhDttJetxyiCNj7LjZ+V+868hh2FuysnHRPFAD8wYLCPES3fquSCa5bJCMTG65STcpje08v6lN4d7aq9Mh0MHLQXOJbM+qVJ+taCYbmlR5p8SgpGwo61TaFIEPMn+hElDc4jswc7qoIvJOzI1oNpuZ5iPMJBro46gz13WpQ39I6Xi/X2fmupc6DAaHjn1grXsJcyfGehMuJFIFsiWahRYF7ZEV2FO+GdS4kFP0UquI6h8VV/DHmvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMH4ZDR5VqSEDXoo9mv7uNvBHMPDB/4/e5ont6OLXzs=;
 b=CdA8eqMiYyko7QyxZ2KGPqGYmIk93oUnZjORTWPLNquQeRw8XGI/niE5mytqe5DrQkc4f869sjFxz/qcCRPGsh+odCoJ4R1U74LB2KC936sohMENoTWGXwfCKjIU1ggpq6lHhEWpLgHxASSTzyYJvAm6f9sX31EBlvHs3QOv9DWX+DeWzdCCbTMODlCeeMG+SbeaVJ0ZmRCTwwducUXhDHx7cXkB/hD/rxJNE/j315lskzM8oo2Vm5JrYG/5iux4ywtVFzlMW4tHviG06u71EZ7r+g9cdV2jto1Hy7rHv63EIXQBe5Xn5RcZPC+B9bQLmsGDUzYHFH1phOgdubEq+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMH4ZDR5VqSEDXoo9mv7uNvBHMPDB/4/e5ont6OLXzs=;
 b=IZJokg4CkpNYlugre433jreRU7ebFTNGlonhZULaJO6vidBDAgLKvqgcvdB/yHnhkg0q+mZjk51CNLC+gwBpa/BqPear/FX5t7DUIBDCiyV2JQ3Usb9LGQFe4/W76Efni6u2czclK0DKPwMNxOqfnVfmkm6HQ5rj0iDW5h3RNvM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3616.eurprd04.prod.outlook.com (2603:10a6:803:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 17:38:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 17:38:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     kernel test robot <lkp@intel.com>
Subject: [PATCH net-next 1/2] net: switchdev: remove stray semicolon in switchdev_handle_fdb_del_to_device shim
Date:   Tue, 20 Jul 2021 20:35:56 +0300
Message-Id: <20210720173557.999534-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720173557.999534-1-vladimir.oltean@nxp.com>
References: <20210720173557.999534-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0054.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR0P264CA0054.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 17:38:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 431f2dac-6db8-4c75-3cf7-08d94ba52364
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3616:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3616725771206D74C90DD7CEE0E29@VI1PR0402MB3616.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V9nVLKqsMkX3rgQLX1nRA4JxY0t5bzUPHCgexbBgRWVgx3YnMXUBi8JPm148w1VTq5nq2A7sF5xozNYN/l/OZe6jJVfD1T3T5/6VzbqYcJNp0Huj0zVhxKUsXmTw75FCPLJxqUTUqh8Pwz8kNrHLAcrNM00R5HTMFaU/xmTcpNF3bCNj5nj3yrBTAypeGRPu98mIDrCHCtrWsSb1Yf+snUadQn8eQ8NOOzvYJ9D/ir+5fdVNB4FspQ41J/vKIM7G6VA2InvGFiOP/YadiE/hFufHgvyZlao7adj2yNml4ZIX1lpkyDzAncQMSSSO0cW99d3OJPCRmIYE27xEuBKvD4BW0pGHygdDfStf0iYM0hkFxExkYemasvuqIh/LBhHjzfUcXK/d69Ua0PV5Ycts8w/1Yfa4IhNhNZYLVJ6MP7f6zPzqOPwBurka/XD31QepRHa73vPEttfOm0Yurvk0I6B8Pq7e9hlwpsWpEEQxO3mkyyda88IUaJVAhXUQfNDapocB8MeOhdHx4mRF2hjDdo+5xbjQo9Lihj1+SxYRDwHoU6JbucYhJsxqJaa1D9+1+xQUaUQcE55tco6qPOxTz8VpsnzOaZAnB14Zg7zrZu2AydB1hNg2cAD+k1thwmT1bgmhnNPUfT20Pm5MaV1kyUMmyEWRkUTdsFyiS0wecBFHiLB71FF64dzEMF6ILhRLSCJJaeRmAxC8Gg7AEzaltA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(136003)(396003)(346002)(376002)(6506007)(26005)(66946007)(6666004)(478600001)(6512007)(186003)(1076003)(86362001)(52116002)(110136005)(66476007)(6486002)(36756003)(4326008)(83380400001)(316002)(66556008)(8676002)(956004)(38100700002)(38350700002)(44832011)(8936002)(2906002)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6NOJ0OIgUQyxsMsBExlX5sF19nSDQ6Pl13ur/W5JsgxVyEKnAjoiMna+xpnp?=
 =?us-ascii?Q?PlfdHcoMTT/ViLfvnxEpo9e7dduFkmfTK09WUseJf3jHEd3/4N1hACOf0/T5?=
 =?us-ascii?Q?4RnLe19n8j09I7zRfXnzNx2dGMW8yx/Mu9jMj4BDBuTN+KTeuEjz7bJKBDPF?=
 =?us-ascii?Q?FUQc1ivOv9Px7MLrCYWkFy9KiCgOzB2SmlaNdbTpC1sQLmrQUaB+UL2QwZUW?=
 =?us-ascii?Q?DPvRQ9gwkx9cRci+jcGc0XFDkOEG36p6Swv+HFjZwDfegepEMqiESbWW6LyA?=
 =?us-ascii?Q?3QST1bc5Fg8u0+2Z2SkugE2yNOikx5c9jMSgMKJFV9wc7tTItXY5n0pA42Vz?=
 =?us-ascii?Q?wMJFgFTkAelYj2k55SGSmLNoB93HZWY2YmDJyyX3vbfwt4NYRRtFoqfl4lK2?=
 =?us-ascii?Q?LDKKc74JsqciNlex2Huqk+0NaLOMRixowKUXAf1JkIKRo6PKeSJ+Oh8d4qXu?=
 =?us-ascii?Q?sty/7JH9pC5HJqplEMg1xInRfpwtV7+OJHh1Fu5TVLR4fOsGDm4XS0dc/YzA?=
 =?us-ascii?Q?n4mz3UNRfx4FdEfbOYAXd39MmynCOCABVLS00pe80OSg3oZ2BRKcjJv4xVWV?=
 =?us-ascii?Q?FkYZ3Rz9ASjEUPKzeW92maw9/haAFYaD+k6FftuZOpMaYx++TWFNqYEGLVlP?=
 =?us-ascii?Q?oGsDafazIQ/ynONiX+ZFhuM7QUcSa+6nNPHHb67bsXVF0qt/lk5Br2RjFXxc?=
 =?us-ascii?Q?UXuiury/DY4uPUGbpBBfYM9xsQCUrT4dDDCrac9rgnLRBQkH8R4L9tsw+oaq?=
 =?us-ascii?Q?A4TnvHeVHsaOlVQ08oyhMgFBRD4BJtPlnz4q96TPblMKtn6uOeEjiHZm1p3z?=
 =?us-ascii?Q?j2GU1d1ZkQMUe97jAxnWxHtmJBeIzPX2ZPeepRsaB5n1eoVFGz49adADgmBy?=
 =?us-ascii?Q?YfHorBiDqZvh7yMCDSPjGetzcRsRbRfb/Ga7XSR3UKT9Nlqpjl4TfS/je3YX?=
 =?us-ascii?Q?RFo2M/dmN4KdXOhC97RWr3UEthjDJu2Kk7mrUEBUQbx1Ls81Kn8JCpGpMDOy?=
 =?us-ascii?Q?/+7dcjvunF3tGbeu1UVxx5Osl7u05WPtCAb3hUtaV/TFPYypDF8fso09oKJm?=
 =?us-ascii?Q?uHmSnXnXo+jamwOXBTUm8bPTZ9L70sK/AidbC7mUuwS/iuHTJ2HKmytjzNJP?=
 =?us-ascii?Q?oRyMUON0jjXs78TIKysS0zrSKa16a0l89JRqZlTRGv9MTm/jlmYZC1Fj0YMv?=
 =?us-ascii?Q?XAnQPRz6akH1ICPPGHsg2aRX68eB9t8hbIUgGNWcY7rXHueWL0zEdPk+E563?=
 =?us-ascii?Q?WiO8wM12HBtWa5fsCwMPFhO3R4OefOnwOVbAp+Ytd5LD/KBvtZQLBg4qQo0Q?=
 =?us-ascii?Q?jU+qE9rcFdNIlq+VVDH2hDg6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 431f2dac-6db8-4c75-3cf7-08d94ba52364
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 17:38:08.6933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwIY65S0S+SvrlZqLmEUL0Drz2IDg8bSiZ7GNKM/MXgF6K6KtmRSl1Ww1KBSYpvzSrF9UqiBvEFcd1LE+Y7cgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the semicolon at the end, the compiler sees the shim function as a
declaration and not as a definition, and warns:

'switchdev_handle_fdb_del_to_device' declared 'static' but never defined

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 8ca07176ab00 ("net: switchdev: introduce a fanout helper for SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 6f57eb2e89cc..66468ff8cc0a 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -406,7 +406,7 @@ switchdev_handle_fdb_del_to_device(struct net_device *dev,
 			      const struct switchdev_notifier_fdb_info *fdb_info),
 		int (*lag_del_cb)(struct net_device *dev,
 				  const struct net_device *orig_dev, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info));
+				  const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	return 0;
 }
-- 
2.25.1

