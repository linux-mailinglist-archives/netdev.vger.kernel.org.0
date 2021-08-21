Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AE53F3CAC
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 01:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhHUXGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 19:06:21 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:31556
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230343AbhHUXGV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 19:06:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KChEyvayEZzJCzb6+AkkGGtKZe6lslKjUobOQjn1BpQo7KWRIkv0clBhlioAFe8EHyZzyXc3WI1vXfF8gS2uBCiZ0aW3YW6EpDbG2mFZC/tKHv64y6QAb4yw00pGpClio2SxLBq5nAupNd/EeqjK9yLiiFVoguSWocFPp4zt6iTDleRk9D8AUw4WSoJddecrOJm0LOJxToMcZbo17cd30FXajXX+Aim/Mm1FJXYA8xdB1PKs1Wfvmm2WnCQMRrsHrbEQRmohhyrTv5B79j98CAc5hlhF54EpND5l5YVHPGMCs2BnXLkezIdAf4lxm7yIKUn6twWGZ9UwltVMS/UDeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FuR6TJNF6KVe0D7RhXWIavgArkwq7Go5h43Is2L1bc=;
 b=gHvOnVWsk83ihXcPqK4sJ6SaIBoXZik6wjMpm89sGnVmR4enGY+hyLIZ7MqIONiZ/kXoZF3ec320GQwZroiooEj5hhdPO7OyJp+UnvvAMu4vsWVo9IY/hiB7gCyhC+8ynJNpDKbFTHuXdc2P/nJlCIsz4gRbdFQuCnHIcAoWcZn9JiNcchhZ5FmnRKvH2Iwz15NXGp5k3Nv8Frc6w201a6lwyQrywlpIBDnrQE0+kqoGUuewHmsfgTCfykPm6v4cxWX3eqO9AbSzMoBW72u5BiITLn2RIypDNjmWY7m7IquNiU7Hq1tspzi2sM8kCdfdQ2q8LjAOMjpzP5Bl5tz7iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FuR6TJNF6KVe0D7RhXWIavgArkwq7Go5h43Is2L1bc=;
 b=s2IAbqWugi11HbgbXl5ZmdxvfRDYmEhVi+dcSmBhqsTX/SRMcqtV/YFM6DsSMHaVJKV4H3b4y8e7WMwJ0/PksLd73gzy8CFkB4Slz3UdgyiQrQbR+lLRQRm+WbDapnyZ9qBv1+WuZpAi9Sa6znAKiTphV9ByqZgKxjDLyXvV0A0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5133.eurprd04.prod.outlook.com (2603:10a6:803:5a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Sat, 21 Aug
 2021 23:05:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.022; Sat, 21 Aug 2021
 23:05:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] DSA documentation updates for v5.15
Date:   Sun, 22 Aug 2021 02:04:37 +0300
Message-Id: <20210821230441.1371168-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0047.eurprd05.prod.outlook.com
 (2603:10a6:200:68::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR0501CA0047.eurprd05.prod.outlook.com (2603:10a6:200:68::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Sat, 21 Aug 2021 23:05:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8150cd3-6063-421b-f74d-08d964f8303a
X-MS-TrafficTypeDiagnostic: VI1PR04MB5133:
X-Microsoft-Antispam-PRVS: <VI1PR04MB513334A01864A9C672DFEFB1E0C29@VI1PR04MB5133.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YIzpR0GrNba5EVersQ2kMiekbTKt7c/VywwtA+t7S33yFp4Mfvw895UuyLOgTErwSeoLKn640s9/x03UK3RpEFky6o/EVZXuEf+2Qs5YPge2Ct0Ga7IRy/oUH3VV0PQLlJDIAShCNirjJuP4OWEGUzkjo64bWtzKFmxWKhmKbloPLJcL4OOE6JPU9l7UlV4gUXKfhMXzv05PKxUikAWshqxpZjySaBfwj+sYIK3i7kGDcw8K1ScOsZ7LvqgOiDkxTKtkNDs7N1CveQ1C6G3hMR9ovHQhS08AGEM/81Hpx4blR3nisyCg364cMgl4+gGHPtVOAYYhi34yvyjw5F+CDO1imkG4mnHb/DrdzdeBoZKIzJRpE1g7Y9NKBIo6uKfXYrXPKNEeWlXxtakCG/vRqfl3nBL3xKhUAh9M8fdEsUgykNfkZHJSs6H7hJsZxLJFTMabAfumRFoKdbvwGeOLOUImisPpS+z7pHDtTUoSAGY7xYWwyxqUCdrgsXYVtZfjCI4xIbVv2duxNOHXh1uA3IFWpvaH59gzyPhjJryMgrBehjO0/Qi8IYdnfnczvB02PaeEZL3jyT8UN3qJyf5jgSKSaylwrnY2Y8UoG+PlRze33ulwF69LwuBBS6ofRIqw28TK6sLcWIGgYqLF1BlNf4m4FOWmtsd2vQEHfKG/0zRsh/csiLEAipJ2/sJu3CXy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39850400004)(346002)(396003)(66556008)(66476007)(86362001)(66946007)(2616005)(956004)(44832011)(38100700002)(38350700002)(316002)(6486002)(1076003)(6512007)(478600001)(83380400001)(36756003)(6506007)(52116002)(6916009)(26005)(186003)(8676002)(8936002)(2906002)(5660300002)(15650500001)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zgYOvjfWW1erpMLrZTne5DUPMqgTkbeiTfsE7UnwCUP6As/vQjlh1HEAMXGl?=
 =?us-ascii?Q?c3YIU2exxJMtP+9Xzi+pWxvCzVMWa6sS4y0t1tWbdVbxXsw7Xq7qTPYdITtv?=
 =?us-ascii?Q?oNPNXGixBxgBrFEwXJtABskJ+RFLEyPJ3yIqmOc65J96VQ5OEcOGj2ye1ecP?=
 =?us-ascii?Q?AiNI+tNZJpBDulWdKAozHFrPrA3OKY0AgIRiqON3PXbvIT5AyW++o2LYOkdl?=
 =?us-ascii?Q?ThPwKRROWDprEuBcp/vCyRd8Us553banhmuO0Z8ZkDIc3OwZ8YoZpg/1o24z?=
 =?us-ascii?Q?PE9KXtRmD5oulaRDjrHg3l4sG5h3xVk0oXJJ8wMxUrGZwI0LNreM00LAmmXS?=
 =?us-ascii?Q?dWv++I3C9FRqPYyumc1JiemNJh474HalDu2z96rHzKmmw5PVKdH5QFJn9JK7?=
 =?us-ascii?Q?0iqvxfBSp7Wcp9lavKISxmnp/A9gWzZzHnjrT5PGGJpS0bDGZu7wxN6OK6q6?=
 =?us-ascii?Q?917yM/wxITHM1miWZVx2bixeGDd+ht2XEPvX8XdZ0WUi3LiYAFJbf72+Gmco?=
 =?us-ascii?Q?rI5jT5drT9cqb8X8ue3+uyWoIJfwtyXU2gfozu0eEqBJLiUPuZxWcs4B5a+m?=
 =?us-ascii?Q?V4iKIsNxkCqXJcfeUiWDqBsOLpN0bjkd0fihNtPT+IQl8peGzI3MbvXF9XIC?=
 =?us-ascii?Q?eEK3bkRTu+4yNvnbDnEh+c5ZXEgMz1Wsud/egIS9On4i9zLUnqrK7eLEDqJN?=
 =?us-ascii?Q?r+4SyT3/NmWIlE6aVPQhdx5EmUT7vDPExsBRBZ5BeuyeU/1WX6naGjIFp8Ak?=
 =?us-ascii?Q?Y8ZliTvZLPgvIWadYgJSJC1D9jS6iyZYaVylGonULsN+nwRWOVZExISaaRrC?=
 =?us-ascii?Q?St+a+OqpGgFDiEWA+OP/lH0ufQ8rhmkeZet9MeeNJtd0B+KKoYVinkK1+UVv?=
 =?us-ascii?Q?w5pITyz9WXNz/IYykmKrQXv9Dbns2vB4/pmgrU2LyHMXY+3+Su6fqFNfBz7T?=
 =?us-ascii?Q?r3R6lVyAiuVSdn3XeOL9gI9LRPi3IDM1Liis5fMdbhauwY74hpunmltinouB?=
 =?us-ascii?Q?an4afp4VmmL5IN/tUHQCvuhurGpYgm8kQXp2elpE4yCJbUx53cQpNuDnHQNo?=
 =?us-ascii?Q?Tv7Qg3KN/671QEvDgJCR+EYaIXvhX+5DblXydmYb9f7IvbW56FvJXPk3Pv99?=
 =?us-ascii?Q?ueyJftCDh8cO+wT75LA81E3R/uiTmnbBH0c6AoIgXT8Qwl14TbtHo0c/YeYG?=
 =?us-ascii?Q?46O80K6N6RVV97JwXRCGtY4RmSTDxt7v8R6lMQNL+JneO7aLu2VnEN+rU1Gl?=
 =?us-ascii?Q?jXlUiYIA7+UgeRWwAA78kr631nB7MeZuc3wwj6UEAICErbCNfp5zu/2Estfz?=
 =?us-ascii?Q?HS6TWUgdx7RnmDu9FnyIbiOS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8150cd3-6063-421b-f74d-08d964f8303a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2021 23:05:37.4922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V5eLVZ0US/EKWLdYYT2NjKJbIA4+9cte9x1GKwMX2zdLO0NrX7WTMV8JsqLO9SjVYzTRI7ysEiXzYFU4VxzxBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There were some documentation-visible changes made to DSA in the
net-next tree for v5.15. There may be more, but these are the ones I am
aware of.

Vladimir Oltean (4):
  docs: devlink: remove the references to sja1105
  docs: net: dsa: sja1105: update list of limitations
  docs: net: dsa: remove references to struct dsa_device_ops::filter
  docs: net: dsa: document the new methods for bridge TX forwarding
    offload

 Documentation/networking/devlink/index.rst   |   1 -
 Documentation/networking/devlink/sja1105.rst |  49 -----
 Documentation/networking/dsa/dsa.rst         |  29 +--
 Documentation/networking/dsa/sja1105.rst     | 218 +------------------
 4 files changed, 17 insertions(+), 280 deletions(-)
 delete mode 100644 Documentation/networking/devlink/sja1105.rst

-- 
2.25.1

