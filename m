Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB3233F756
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhCQRp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:45:29 -0400
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:58097
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232476AbhCQRpN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 13:45:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJ6emZa3AER9s2DEGACssKT4cRyZJSUCvgL9an3YYVRmZttf+B1kUWXlIb8MyDQbxNR8VnHo25du1z8hTztlQsjPkVpDWdbFOpenFXPMbP+kXgwyOA8PPZYWGwakRq4vJpg+aJXZzAmDaL9NSg+lTrqmATcD1N8swzux7UQA7DTJbYCfroyM8FrMgpMFLpOkhQxk7ASOkFZ/zuKd8CImQgR1rHQaq6jSYH1/B6c4jhx29YobJUlGuQiSi8KzbL/MxCTMGOgMyUZe5UAmYeKTQKfrf56GWv/CcMmVoyR3f7q2DlBVY0I34qqdAo+/884gEFj6XjW8yspaI8au0Mkwmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejTb1agPqXBEVA6xgbMld2JiGCw8d/Yb5Ole8EECt4I=;
 b=INRqo8Ht1Yo+iG156Rbu5DvGC0WDF+LhNl5i8HpqfmHLt88YmtBYdUPnOl4/rtvHSXf8RBhu0Avy/7dYOCXgHIMIkMaH10Zx7dfkvl/AIfvePU/RTh7MO/SZ15dceNgsTGUalxG5ghuD4RmYAXmxF1rGNgmNnf9OsnUHM6MfnTve2JecPovDBsT0ZFOCCy7aB66DjVYKNxItuyXR+K9NPyjlnjcQfJ4KxdpCWatKmVK54dHTU5jdEeCZlz3rVBcQlsrT7FROehheHHotIuXhxHqXOFhTLUM1EFR5ryIROFfVoL7rzwLrOqPmGTKUv4VZS00WgT/vt4Il20jv6uT2Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejTb1agPqXBEVA6xgbMld2JiGCw8d/Yb5Ole8EECt4I=;
 b=qgpl5YBV7Uf0Jp3myx/zCJoKZDx8NsWPcjq3EZrq/BpL1HuTJwCbzMRZ/b+8DiGFQf4B3qFp1l/diEB0cR1X69LLZOlsSQ5KT5GLVOGaUMn7QiW+NMS65D5X4DvG/VuS/BeqOX3p0I3wbmgrOgGfcY5TsaHVWWCcDvPwmR+PnOQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 17:45:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 17:45:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next 0/5] DSA/switchdev documentation fixups
Date:   Wed, 17 Mar 2021 19:44:53 +0200
Message-Id: <20210317174458.2349642-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.16.165]
X-ClientProxiedBy: AM0PR06CA0106.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.16.165) by AM0PR06CA0106.eurprd06.prod.outlook.com (2603:10a6:208:fa::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 17:45:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 81aaa56e-95ea-4a12-ce7f-08d8e96c69ab
X-MS-TrafficTypeDiagnostic: VI1PR04MB7119:
X-Microsoft-Antispam-PRVS: <VI1PR04MB7119F008AA915BF07A85F120E06A9@VI1PR04MB7119.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JwAx2mrkQXUmiu2Vp5K/psfha4Zyc/O5RMxN6YCuYJMBjddCEPcr3x0A7prJjfGymw9vN+ADjZnqmWzuAb8wjiWpE+I/pOemYnmxPT6todkpYmzDmStZ+fMA+qcvNz7od6Www7a1kEXxz7w5viuAVJ+y3eUpHxJArPfVmPZP5WKFwa4EetOI9BUJMZVI3h4VV447eczqAEYdJtH2TLpu6VRLnPSm96r/DdGBfCmrFPCkLnYKfxWJlJZ2RGopT/Gf3De/tw35dKrLn/uPp6qMZFm9S6g+q+/RV7tvMUTPd0ngnDK6mUabNM1j6ZjY1ASvRVis0kpyxXlknyO5AQ2xRSpAYq6w4s6tla0LKe6ZDxtg4ZrekHMiLlR/1izoIzkhkR/O4A6cZ7D9ez4FMlyUA2hKGpQ0h/zd+Du2HuRSISFHaY+iebuwVyietixXdcHE1SvV50cCd/vdk6gkVjOfcmHa6fAPbpAbFXoW5/K07MRsjgfzMcnSgH4f3Py0ZLUpxXyaaeIpSKUt8YoZln3qMDv0Xy+Let+ykGLh+9RQsXE4sSufw7qoXlv+itCh3GFUxNllk0k62HVZgls3CUxO3wEWmH0lP56pmVG/FnFFJ1U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(346002)(376002)(136003)(396003)(86362001)(110136005)(83380400001)(4744005)(69590400012)(6506007)(36756003)(52116002)(6666004)(1076003)(186003)(16526019)(54906003)(66946007)(66556008)(2906002)(26005)(5660300002)(6512007)(2616005)(8676002)(956004)(4326008)(316002)(44832011)(66476007)(6486002)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JMTxc2MQokhTgzHQYNN5nr1+/ZFs8qrQhBSX+digU/elbJPEofEgVWZ0Pymy?=
 =?us-ascii?Q?0PMQS352YcNNKF7Cx8Uc0d/w52z4mkd3yAL0Bv+fsL2KnROOesjrX1yv291I?=
 =?us-ascii?Q?525Pt2stcdJS1sccfzwl1Lttl45PTw5y0r4591ST0H9vmXF/XhgN3KjueBrB?=
 =?us-ascii?Q?P9YGa8W7tYaCO33CQQB5biNvubFZFOLG6hz68oxwTUTCIx2Zux4lVdgDlM3D?=
 =?us-ascii?Q?auWaDuompao2o3uIhy2thzhahkucRFuX/rpdSESHOzqZGwSWu8ciWiMcgwhJ?=
 =?us-ascii?Q?GSeEAvF3tINzkorNLS8EXVa99hazqVK3buudOAVW1csHRugmiPF3vTZZXNEd?=
 =?us-ascii?Q?pSWB9HrijC3U7SQ/JMJ9HvBM0doZyyZWvZeIk32LaSz5Vm/HdyzCyfvxfRIL?=
 =?us-ascii?Q?BgYMIxBKfCxte/JY6u4GYdyoFslO1D8MHZuweIajjiNM4OyLLv06I8f0+Bwa?=
 =?us-ascii?Q?G4SYJuBOw+79Am6IXB90lb9Wt0J5BegkHvr7WgePxa+3OM6F/n6ZjgFAxpKx?=
 =?us-ascii?Q?ubH0Vw6jAiBEutXvPTJp64G262VAa+I4jVLiXiEz4VBgUfCaLMu7UUexbSie?=
 =?us-ascii?Q?e6O58uZAjDtrhfZ6UMG6nWF2WQPZcZEd7BEbyi8tFdHGvC4j/WJkZkcO3HWF?=
 =?us-ascii?Q?/jL0b05yvUu5jgdbEUzmqovst5kLiq3Dd5McZjTES22T35YceLNLCB/W+m0X?=
 =?us-ascii?Q?V7RmGkVrvLGdPKRinvTe6KB3tyyX22bOvO0yfrGWvl4mMZSxnG9u6/fnbpry?=
 =?us-ascii?Q?LT7ZFI4/XPysGnTUBTHzNPEAAI8VJ2U/ROYQgHQKnXPWXOOGvCoOvHGp8gMN?=
 =?us-ascii?Q?Kzngj4MSxR3PeMACm9Stu9I85oj8Ho2XJzewQBZJnhPIJqZKKHDcjtVGBdXp?=
 =?us-ascii?Q?OwZwhDzS8x9rn4E205EsTCbJMxY+GS/pG1hvuKZocYbV8iUfSwhar0YsbYJZ?=
 =?us-ascii?Q?BXRe2IYPUmWg7gJmRWYNVHMESw8MtuLzt2tfJd2imTUM6FdNOpJMSRMwAqTj?=
 =?us-ascii?Q?Ev+bjnGPS3EdUeIjdZ8bWKOAy6a6P5aclGbbPvJZfJgUpZkS6KujcnIIJz/I?=
 =?us-ascii?Q?O+hAIrh7pQ6VGD3JkDjzOMNe7vt+xGax/n2fDv+tyH0Hqh9+T3oaGOv39GZP?=
 =?us-ascii?Q?tXEpgiTZWy55pJveWxjXDy9j88rcgpqKrRRKLirAUhO7wmmJcFGtpO/VxUhp?=
 =?us-ascii?Q?Ly3KuoWnQoaUk1Xg8KePa0ERHzickBpNClNiHF5Tsu6bSxGdvxYeF4RggpKU?=
 =?us-ascii?Q?LrdIOxmc0qZR7+Fj2FW+CDJbCwZvRFCjiT+5ghisKPohCup9qpuVOt/boogf?=
 =?us-ascii?Q?WrmP6KZBxw14mx3qLf2bExKQ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81aaa56e-95ea-4a12-ce7f-08d8e96c69ab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 17:45:11.4300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyPXhtUWc6dI/qf0DTDK5LO0A12WDa8imPHxoqxVTARDNZScZKIEaf82i4jT8TyN3jfdX+D6lL5ZoN3ZPOfhBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are some small fixups after the recently merged documentation
update.

Vladimir Oltean (5):
  Documentation: networking: switchdev: separate bulleted items with new
    line
  Documentation: networking: switchdev: add missing "and" word
  Documentation: networking: dsa: add missing new line in devlink
    section
  Documentation: networking: dsa: demote subsections to simple
    emphasized words
  Documentation: networking: dsa: mention that the master is brought up
    automatically

 .../networking/dsa/configuration.rst          | 330 +++++++++---------
 Documentation/networking/dsa/dsa.rst          |   1 +
 Documentation/networking/switchdev.rst        |   3 +-
 3 files changed, 169 insertions(+), 165 deletions(-)

-- 
2.25.1

