Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5206E600E
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjDRLkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbjDRLkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:40:12 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2074.outbound.protection.outlook.com [40.107.14.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CE4E58
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:40:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGLHtex3UwRu4qx7oyZ8K440A9RebT0w7wrplanChIlsSt3J7f7svyiC8JdTmkvbDBxmTrMojeMhNgZXSU44an33ZZoP23hxWv1Sq0KSwVDBgVmsAiGOPtIaTpbYyepbdLXd4SumLTWA43piS+gaFXBQ9JMU5hrE0iqS1+TFLAuV9kMFwRncZ4tTKOVOx8YCwtgSJYlWsyH70gq//XO8Vydo7596Yq+X3GvrzIN9UtLnG9R3pr0weBOxeWm6leJJmpGnsFklN2GKKGBpUUivj6I+agp5faXnZlK87NV5GQ4IwOnQ3sVEhVfjRdDjYJXf1jU/Nqd5pbBsUIvjOTRu3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LHUKjdRdLt90b4bpVCfhoE8M+YD/IMIyeJeYAbEQ9I=;
 b=EInc8z2iFSzWpZShRinfWRRQzROxIJdQ69byvJOJn5LJLpphNfTDEQkYeBtPoy/nvdwCEq9G2EZSq5eg3SbNb30ceLXWEf6Jl6+TNLbQZijpWr/HejlK8FWpqpqWehNu6hqBccSbPWbVcxyNCfmw/xHdbHw3jYrB2VwW55unzn2pCmHa3oBb24rDrklp3rMhDk/QzJ55cO6TOzfFezyHbbH+qxxFJBK+MMYJ1dOt9AX063+/tj3XlHWTt432LfHoXiYXlBdKe+BSbKoVxv5lhr3dXV5auujUMHzW/yysFBwAsMv5lPTf0C5FmoxOGvgGA+9cIHw8TO2YktZTPkvtIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LHUKjdRdLt90b4bpVCfhoE8M+YD/IMIyeJeYAbEQ9I=;
 b=gemaGLHvxYZ1EfcwDJJgv34IDCED7PJGGoIaLKZGawhBs+0tSMe9pOR8f3I1PSpAcgxLeGeyxqyQ/OQkz5u4pBtJfeZBTKaxcvBTaM11EadDZTgusZt/Zdd0LdjBPuuz8e5gYx+N0oJdv17cH7YioFN2TaPsV3YPU73semnkRhk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8557.eurprd04.prod.outlook.com (2603:10a6:102:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Tue, 18 Apr
 2023 11:40:09 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:40:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 05/10] tc/mqprio: break up synopsis into multiple lines
Date:   Tue, 18 Apr 2023 14:39:48 +0300
Message-Id: <20230418113953.818831-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418113953.818831-1-vladimir.oltean@nxp.com>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0003.eurprd05.prod.outlook.com
 (2603:10a6:800:92::13) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8557:EE_
X-MS-Office365-Filtering-Correlation-Id: bae2be6c-9e2d-4ae9-3a5a-08db4001a98b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: popdYHbw5afF688goqQV4ok/Ve/W9HzhEortPh3eCU7LsXNSsUoWYDUKwxNeMcRqxjQvX/3mLl2lGYEADISxzjvySliE8vktHDtK2nK4gw7FjettLJkAl28SEUBurLowBKSYKjtAOihLiw8sEquV5IU1TORvIuSh/EoqZHD3U60fXIAv6FQ9FkwqqKVgfZxT2RjbmAGB5+Iwu3nyE6BKbqOc+zsxkAqGHSD41BcxjxUeIbDJfW/VMyw3a6wcbf/hu5Tonga4X7EgN2FhGotq7aokxn6jXBE+Jy36Cvn5ewa02AuTnbBjvcFYGLEeFJHzmbRi1TO+vLPoPoaogQbT+T8JZp55vN9k+DlxVVn6SdJsVkG3p5wDDXu/sFYKhHTV7Luc6vu1t8X2+AgmjIKswFCoqvVX2PrrwrXC19RofjYK9jRmMAaOnnFndnpQba8UB5/YWFqyCWDjMmwOzv7Os8Iem1PrSd9N9Sny9LvuN+DER51967NFCh8wzm2alnq03GXmMXUeR8Y8NNJp8pKSKtClbAkmy4bUbHQJLBWWs7birczprP9myKY+WiKHXbMZH2rx438Zay5ov8/p/rM4tr1x09Sq2qryMzrvsRj5SdLmOQbGqzo7nGQPOLCjX9/S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(316002)(4326008)(66946007)(66556008)(66476007)(6916009)(478600001)(54906003)(8936002)(8676002)(5660300002)(44832011)(41300700001)(38100700002)(38350700002)(186003)(83380400001)(2616005)(6486002)(6666004)(52116002)(6512007)(6506007)(1076003)(26005)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W2QCMLM7+DUTO3tY7z4iDHe+cJG8QXbqUCIi1A2NI4vZu9LNqo6OMPYiY1zt?=
 =?us-ascii?Q?kSjZ5tHfwK2SySkYWylv91/YA2kNL4NtmZZEFLSGWZtzaUb4nMfLMvAtJdAo?=
 =?us-ascii?Q?ZJb34mf5hh+gAycx1l3wbUThe2x/1+entMtryRHOMRyLoVZDFKu6TSJ3GIT0?=
 =?us-ascii?Q?YQ+y0Wvkoy4SWJPtn9T3NbQiWh0bqlJXo4vbplnFabG+E93SQcit/8ogaVce?=
 =?us-ascii?Q?ZTO9yClzroGtC1SmMzbiJvIyJ3j4FbhfCjpfhMA9PRJ7uocKAWJD7hT+2vFi?=
 =?us-ascii?Q?B3MKJFHpa5q85RTRWiAKPIfOG2/fH773zHXYq/zyqQSm6mw3SPU1NOAukX+X?=
 =?us-ascii?Q?VJ5srFrz3T/LeSh0tMNfMtorAHqk09E0w6fz3K91I/77VOr0y59OTL1O1cPG?=
 =?us-ascii?Q?WxxcnAVK2+J1JKKR9ovd+hKbsOtTL9vYYDBvsRsXJUzI/hDzB7kC1uWVGfIs?=
 =?us-ascii?Q?Zn5PXN/4Mi6Es1y6VdLnDsmAXAeFG4txtj5nBmSS0DYbIYgvu7KMqeF5gXS1?=
 =?us-ascii?Q?N7v+x7S03sSnhQbJ4UDrOuhIYkXuUmycs/mhd0AehqIaSFS3dYDfPDa0RukG?=
 =?us-ascii?Q?Tz9eO2AlVhMWxXb/sZq3tgH8PScubJLlem7BgibpwE7ADQtDCqMI/STTEBct?=
 =?us-ascii?Q?w6E59VF8xvHp37+RujSV5uIzfpqWYVuHy11qswyMBZIPr8ZdBBNM4ZQ2iSnJ?=
 =?us-ascii?Q?e4Ckz4+PaNUGPrX+73gHy0wSBDhW5DON8lQ7XG9LkA32L+OrCj3FmuI0YGF7?=
 =?us-ascii?Q?zNQtH4NiiVJwDzZ01XhLHUXt5x0YXBatNshW8KtjmUNDrYcu5htAmJYUMuXd?=
 =?us-ascii?Q?n8+eWxuq84q9gEEwRyqOrnZrdDX+igPEkyMScoIx4HxjoSiKl966frFRSReb?=
 =?us-ascii?Q?mlrvMbcYK+UAziBAatgOJVErayRQwJh3jWcLn15W1xedIOZu9WYk+4MThtOz?=
 =?us-ascii?Q?0LFIaa+htcJJFZWC+suYq6ZE9sfzNGmcLeZUizUbIg8DqANQnvjV3t8OFYO/?=
 =?us-ascii?Q?Od4gYFuP8t3fBfjuqQDN55YnUz9JlSvBs9Ck72w45YoVkvwU8VjdwZaFfbeI?=
 =?us-ascii?Q?9RuWhHbfieNkfl/19FE3mu1WyxjsVcJCWgrCskAz4y5GgCh7W+/VxhjjHCJQ?=
 =?us-ascii?Q?YEvbgIAo1sdOB78OVLsjrh3Q+InVxfAMWukSUyqyELdDsdWdcymTjJYlD5rj?=
 =?us-ascii?Q?Tu5TOVeG9YpMCwom0QVQJqPsYBMsleYg/QcUqTwri+EYpBJ21GU3N4/hb22F?=
 =?us-ascii?Q?9VU+rWyqGMRzLpg4nzx8p3LQxBo7LK5UzINwQDv/FjW7o/t9xPrN9ozxaKk5?=
 =?us-ascii?Q?OS++NQHPRUiPXPPxWi2QZcrzTgxgB4xDfX4EbudZon0suEmZH0ZzTerSLynp?=
 =?us-ascii?Q?+kdGvcwyBfRhcrC2xyHaghdtWjBsLF4s/cgoYdwW6TSjFbwRFBdFVz9zh6JL?=
 =?us-ascii?Q?mT0gmj1oI5PO3GNVGtwzZ1VZ0db66QhkhZDMQAiFAXM9IIWE2s8Xg4vjAFW8?=
 =?us-ascii?Q?AesZ2UKoGRx1p65ejSfh9RDpJt4MKwpPvULkfu9i4BNMjNisODt9pmw9K5qX?=
 =?us-ascii?Q?KrA/cyO6Lq2iEQMnC6gqdetBLXmIaxJTI7rhTcs7QIGN0DR8Wwnz33WYxBvl?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bae2be6c-9e2d-4ae9-3a5a-08db4001a98b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:40:08.8372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUEOKR1D5UfTwecQz3I58cFQTuntYno/+qAAFzh/6cEc49mUHxIDJMI6+v8dfYszrTIJDKEW6iN5C9Qnr+xkeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8557
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tc-taprio(8) has a synopsis which is much easier to follow, because it
breaks up the command line arguments on multiple lines. Do this in
tc-mqprio(8) too.

Also, the highlighting (bold) of the keywords is all wrong. Take the
opportunity to fix that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 man/man8/tc-mqprio.8 | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/man/man8/tc-mqprio.8 b/man/man8/tc-mqprio.8
index e17c50621af0..3441cb68a27f 100644
--- a/man/man8/tc-mqprio.8
+++ b/man/man8/tc-mqprio.8
@@ -3,23 +3,30 @@
 MQPRIO \- Multiqueue Priority Qdisc (Offloaded Hardware QOS)
 .SH SYNOPSIS
 .B tc qdisc ... dev
-dev
-.B  ( parent
-classid
-.B | root) [ handle
-major:
-.B ] mqprio [ num_tc
-tcs
-.B ] [ map
-P0 P1 P2...
-.B ] [ queues
-count1@offset1 count2@offset2 ...
-.B ] [ hw
-1|0
-.B ] [ mode
-dcb|channel
-.B ] [ shaper
-dcb|bw_rlimit ] [
+dev (
+.B parent
+classid | root) [
+.B handle
+major: ]
+.B mqprio
+.ti +8
+[
+.B num_tc
+tcs ] [
+.B map
+P0 P1 P2... ] [
+.B queues
+count1@offset1 count2@offset2 ... ]
+.ti +8
+[
+.B hw
+1|0 ] [
+.B mode
+dcb|channel ] [
+.B shaper
+dcb|bw_rlimit ]
+.ti +8
+[
 .B min_rate
 min_rate1 min_rate2 ... ] [
 .B max_rate
-- 
2.34.1

