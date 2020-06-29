Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E0E20CBA0
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 04:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgF2CCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 22:02:54 -0400
Received: from mail-eopbgr00043.outbound.protection.outlook.com ([40.107.0.43]:44357
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbgF2CCx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jun 2020 22:02:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWKvMpwGYX5bL/biGoNGTUQI6gERmpf+pW8/WRBPN8b3O4COLr9Jvy7cwJlmTUkoYj8keaP/635f7BO20GGOacam73ZlFt1PKldFJ4mSy/5YynLjITrkHvzcrOfBP9Cyqk/+ppcJpDjPxliZ0Yb+76DOHnaBH9zyRtMszB9pUup04LueuzxkcvUM476Lw5q5X7CEAxjOWYOihgvBEB9n5Aiqlm6mSF19FfHveENj4ooYmq2IUCAI573tEgWGF3HhDinmQpeKCEClDZpOjX6rPVOGWAyvbHxfBj/LUV7nyTkCvzF+Cpdy+B8NrhQurnWPrCbwNf2tOcF2wvWuaa8ctQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KyJnTK4Oaadl1RzTmUj7fUB/LwuBe+UA5HccmP9kH6I=;
 b=dXwKZGi2S8SLIE+ReydLtK5u2GXVhEuIH+QSSm7BnORvgbsWDjwvDtmh9DBmKbggkQjxPkZhYSaahiov3x+mBvLZN7ALTqNMEu6eSBd3ODtsARMpXhR5KlWM84T5HNdY8MYuvVXoCV+ub2wOmaaNpJUzcFITJNaeLEagvGaG55thcix9DbJHI6/H7A4gdDzekwtTJkRQm0rKsCdWTmxx4JpZDq2dqLErX87ucwlXHkgQPihnXIT0K6cN70fWcYHBCqSUg8pbTiGCGhUdVrZxsg7J94vJDmqJt7tT34MZhbEK2fQ/xI4ck48p9j2UM3JL9gZqTrGD1eaePrfNMQL5GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KyJnTK4Oaadl1RzTmUj7fUB/LwuBe+UA5HccmP9kH6I=;
 b=sM0rT/hRbzV0uDh9R6oUOKm78aJR9yshxOVFO8TbHcD/qKOj0CbODTkHVUQEfQ6Nd0CxtZgtG15eITXuWjiXexB0Y+ymUf4fpNfNUHobZIAMZJb+0TbZAo1i5aMLZ9j0eHhf7gkP7Z1O3QvXStO0AGDrQo8tgdIDAWElmckGwig=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VI1PR04MB6030.eurprd04.prod.outlook.com (2603:10a6:803:f8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 02:02:49 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 02:02:49 +0000
From:   Po Liu <po.liu@nxp.com>
To:     dsahern@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, davem@davemloft.net, jhs@mojatatu.com,
        vlad@buslov.dev, po.liu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com
Subject: [v2,iproute2-next 1/2] action police: change the print message quotes style
Date:   Mon, 29 Jun 2020 10:04:19 +0800
Message-Id: <20200629020420.30412-1-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200628014602.13002-1-po.liu@nxp.com>
References: <20200628014602.13002-1-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0164.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::20) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tsn.ap.freescale.net (119.31.174.73) by SG2PR01CA0164.apcprd01.prod.exchangelabs.com (2603:1096:4:28::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Mon, 29 Jun 2020 02:02:45 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7530ae36-77d3-470d-a2c7-08d81bd085be
X-MS-TrafficTypeDiagnostic: VI1PR04MB6030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB603019C3394D55C4F08F5B75926E0@VI1PR04MB6030.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 044968D9E1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZVYPaglvU+TjapwrqKOAowxKYssCNQP//5P8n/XQqL0H79lMyOmR8/Bmca1tCEwjvcsUtGQz3UKmNGLSW7C51MNGSLEfuEg0YlyaGfYQYltunAlMA0ZDatkMzQ8JYgNzCz8alCOymoaHvWmbYhv2QEpHIJfbGgfVqB6G1+U879fsKkegu+ejgu/eP7O+/OZbeTaZbsSEzF7bT7Z+fyuxNn9ZvPWwa/brjoYx+j2gM1JzlgdZZRnhEBzwtjKgbSO3p/g8FNC2EBrzmidCNXgJ+Fz7QnbCVzAQ2HtC/QJNvnA40S0EXGaRE0asYPqbLD2DPYzm7L/kny88rAaJVLF7ZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(1076003)(26005)(6486002)(16526019)(316002)(5660300002)(8936002)(83380400001)(186003)(44832011)(956004)(8676002)(2616005)(2906002)(36756003)(66476007)(66946007)(66556008)(6506007)(4326008)(6666004)(15650500001)(6512007)(478600001)(86362001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YS7cUVB8oqY6x0V4mrIUngQkYh5a8bVGOfmTL4yklLhTvPALweblmZYiXNVyLaYxObxtU3NCnmnmFKTxlPYJmc2l99+ghptb2DgUhkbApL9QMuCxxV1KR9cqagaND89zp8o5w86WfO/feEFZQUykfNiVhO2dAbzqlK4/xTqhO8ZJITmhd08GwwlkcDS+VarOZKgahTBn1aGPRuDH356Jbom2vrzm+HagiV7gtpQkN5lJbuDImvJutbn6AjPu8QspLNKI4kBl3kqlCSnq1mjoxgeoOBgRM6iEWhXz+zaIrKdGKToqE2NuYTdtAjR/+pn8PKKeW7IRn+vylOyFF2FaU9n/2GqJY0t/KHng3YJDqqS3rJfAy/kFnl0r/wkFuVZnvyuago7DRNnXI7wXo69YuCzOc5mdU7tNdpWePrlL0NahQUQnV+62g8cWtcczgYfrg46fWnnA88Upc8vMzhSvmEo4W/fWiVmfXKJCdxoIeM8=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7530ae36-77d3-470d-a2c7-08d81bd085be
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6496.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2020 02:02:49.2840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sAb7q9OIobMOV+EJyjSbUGGciqC6fwcFHKhBVXsYbRzoDB9h9/4VLL0973sOaBTq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6030
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the double quotes to single quotes in fprintf message to make it
more readable.

Signed-off-by: Po Liu <po.liu@nxp.com>
---
v1->v2 changes:
- Patch new added

 tc/m_police.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tc/m_police.c b/tc/m_police.c
index a5bc20c0..7eb47f8e 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -162,23 +162,23 @@ action_ctrl_ok:
 
 	/* Must at least do late binding, use TB or ewma policing */
 	if (!rate64 && !avrate && !p.index) {
-		fprintf(stderr, "\"rate\" or \"avrate\" MUST be specified.\n");
+		fprintf(stderr, "'rate' or 'avrate' MUST be specified.\n");
 		return -1;
 	}
 
 	/* When the TB policer is used, burst is required */
 	if (rate64 && !buffer && !avrate) {
-		fprintf(stderr, "\"burst\" requires \"rate\".\n");
+		fprintf(stderr, "'burst' requires 'rate'.\n");
 		return -1;
 	}
 
 	if (prate64) {
 		if (!rate64) {
-			fprintf(stderr, "\"peakrate\" requires \"rate\".\n");
+			fprintf(stderr, "'peakrate' requires 'rate'.\n");
 			return -1;
 		}
 		if (!mtu) {
-			fprintf(stderr, "\"mtu\" is required, if \"peakrate\" is requested.\n");
+			fprintf(stderr, "'mtu' is required, if 'peakrate' is requested.\n");
 			return -1;
 		}
 	}
-- 
2.17.1

