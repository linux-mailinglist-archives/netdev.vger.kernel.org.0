Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC301DADAA
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 10:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgETIhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 04:37:07 -0400
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:39376
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726852AbgETIhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 04:37:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TT0earZA8dP800TpyvKW00b8S9WiHmdpyclIuck7c90/CeoPLkJJ4FXFlCchzc5FQoN3qPzOUETrRSnyGei946D9Ji/kcToUofseiztkZVYq/XLVaPDgSGN+pO0mQCgQl+eRdJJpZuVCtRRjedTW6N5+2EKXlux8Jz0JmDPIr/9gd3tkj5ppxTCvtuYOVVViW7R6lNAwJ0NTRwL1Yt0s0qZEK4CqRrq921hH5kHAC28DuZvDBByeBCuX8j+bk5TouypKaFOdXcKWNuZ8ZEHjZINdUozdy9F3Jvhc43PQruu25qDrWGmr0Q10IfMVtO+jdJ6/L9C92LmCAC5NoeUPTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtRG06/tr9Gm/ftlPuSkcBfygPlrCYB5w/SQXiqqrF4=;
 b=eZo47XHADNnDLlLPi4w3bhHpmKoDRE15LVU3EyTJ7fdwEhjCfKePtOSJVxChbz4Ukc6JH43ATySo7+cFzAwe0SJEqNEBaxJJrU7Yo8R8q+EsJO3mE8mqaPJIVuxTr5Nwjiuizs0fcwDX9qZu3D5GSpMJkSd/uGm4FkVQlPwFA2ofamjl27vevNQZfjeWrcDyb9issCFIm6qsE613hm69g7E8hFK8kJFarg3oUewkYmlWZn77TK8WwpgoUcwRv2uDAGagUm9z6dvvU5aF9pBbyRWQdJtfdYodYvRAvCYmtHV/WLjlqpySndK5CYMXS5R+keOdHnS/+OhdcnhzLzlL3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtRG06/tr9Gm/ftlPuSkcBfygPlrCYB5w/SQXiqqrF4=;
 b=bO8+nH8D1VI7mXYnjhKKJrMs8gOO2HBFdKP7w/mpOCcjiiqIVb//5NkgKHIOcf7lrk3LoEW4tuTw5Zl7RpYvZq7hRT14lAR7jHIfpj2lqSS6XcDKxx21Wu2Qkg95yDTWoR9bR4OkG/y0uA/Z1pX/V7PCuCeC4j6d6oCIJGr4ai8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3926.eurprd04.prod.outlook.com
 (2603:10a6:209:23::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 20 May
 2020 08:37:00 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3000.034; Wed, 20 May 2020
 08:37:00 +0000
From:   fugang.duan@nxp.com
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, martin.fuzzey@flowbird.group,
        robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, fugang.duan@nxp.com
Subject: [PATCH net 4/4] ARM: dts: imx6qdl-sabresd: enable fec wake-on-lan
Date:   Wed, 20 May 2020 16:31:56 +0800
Message-Id: <1589963516-26703-5-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0233.apcprd06.prod.outlook.com
 (2603:1096:4:ac::17) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR06CA0233.apcprd06.prod.outlook.com (2603:1096:4:ac::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Wed, 20 May 2020 08:36:57 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 29355762-7eec-4496-9c12-08d7fc98f665
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3926:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB392681F381B2ACC9AA4B34C4FFB60@AM6PR0402MB3926.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eyAkNNDExFyFbDnIkrjMt7rNIrIzz8ruTusvFYr0G99+Aap4kz13kFJnzop1tkb2wbnfNWryaWO5mQspwW5mAR2iAPxPNi8+aPWCuyYNx/8wbbdfduh7Xg6n7D+2zgDpEd4zM94eVI6zFbecFnc0z70GKmHvbmrsGTv9qm0tBBcuYL7OGKPHJwziq0ef09H1WDc0QbtLPa4DKQNggFjYUNok7MxPnM3Bz2CV1ob2BmQlQe2v2cVLus9++zHCRHOrDY6y5raDDjTi2BRDjjxNDZPj6gxqxTjzP61lJBsnThhp4pMJXjPgbeE368MiALEurrIu9rt2Ex2KAHOe9nsCwjXBnbCzXTaBH4cLtJCTlH2523mG8E4fkWzSo/khm9xjjkzRU+SPpha1D13q1pFt/hh3NtnJ3pH7IwdOYJd8hzzf+WsdySo6FEna/eBIRWHGQDpdr4BHsAAHazUe5K0jztVZJbucNLXZW2L7aP+db0lc6slK8vosjC6+mpdOwuPd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(6916009)(8936002)(66476007)(8676002)(66946007)(86362001)(66556008)(316002)(2616005)(16526019)(478600001)(186003)(36756003)(26005)(4326008)(956004)(6512007)(6486002)(9686003)(52116002)(6506007)(2906002)(5660300002)(4744005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tiodVuPAJsLtwWXmuO3wgU8j+5hW8EAth6EIPF5IflnhLC7iU60nTa3vnMxLk2Ny78dw+drPOKoqC9ZtMEfnjUQSRMwaZNTZYsCqG00trgIU6yUOLVr3TwYi1y1xy+1N1uD1odMxeoxwdyquuzg6a5aLHhnn62VuHrBdrxc0pQgnakLJ+xuYRS0+uVHlTvDI0Ze1cdE2EvL6mQHjNNXBV7k2AzvCovtD2bE2EufC1SPOoWVQrWfX5ECO7wL+lbCeL0vGY1f2SySJoQ4RioP1zXGrLWqa5mvr8xEpqZY30j+ZZ63U4QnnkYBlYlI0ScXSqqrLgwaFu6+5dG6fJZMXXMNeZ7iMqM228NyfGL3NHH7U8Q5EluxhzlChMHvJ0UVGlJNrWTqkq+d8yf5fSmMReZSTuQxtZNNoOccYj12hltLWwRlOEKTeaBuy/L8t/bKXqKQHSP/5P87NqVx2l0z47FMWSvRdBB64HqMKxS0Vi14vkTFyS2veTuA9krzll1Nb
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29355762-7eec-4496-9c12-08d7fc98f665
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 08:36:59.9245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0bPwkoV/UsPemL0DfJRPbKFn79e9szULOaCRewK0/L10jbyk+o0/yyyuZu9UP/NvcHOgehsLnm7zVVmc+uWPpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3926
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Enable ethernet wake-on-lan feature for imx6q/dl/qp sabresd
boards since the PHY clock is supplied by exteranl osc.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
index fe59dde..28b35cc 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -204,6 +204,7 @@
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii-id";
 	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
+	fsl,magic-packet;
 	status = "okay";
 };
 
-- 
2.7.4

