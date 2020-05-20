Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC431DADA6
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 10:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgETIhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 04:37:02 -0400
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:39376
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726852AbgETIhB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 04:37:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Penvl9gZ3YZn8Y9/ekGnWsto9DLdqnPKfYJ8LjiCDNJPZPJRzaBn+J8sgsPh6kOyvtENu/UQdyo7N+wwMV6b/5u+0joaXCZrleWJVTSWSnOJbEt/sEJFKKBT6Vuybpc4npiSeK9TAQupbzgYAFW0913Ftqw2Fz5MFPdUAVHTarlDwxyjfBjYpyGc1j0HRo1tzSJ8EcbwOlr0UuBxrtVVXdrEqINQCJIz56Y8gXZPxe3Vy0Xo2sTfxd9iivgxy+tIBAiPx3OE3BCryOCccmYN6wQ6SV9zK7h+SDWRcBjCtX80Ic0ynBj9PE4MBuAcHaxaUpJbz3IGUmRTpga2JgqQ7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRfZqtK/Ph/5Pu9votgs3Mh7XI7ud/OtBwE1Ido7RmI=;
 b=bHQLmF2MX30YgmtAQfUIqXSRlx9qOKGvksXQa4H4dR429o2qImIbU/PADBrJV7Z+cGm4FTikyqyX00xxd0TeSI1x2RpTTm2DB2O3iluUllZNl+1fXbJfWSG8qbx+XQgtlXKokJcmoUp3ejiU9GbNme1bvu/Qa2mPu1LGYza+TXts1BoCAdwBoyMt1ChRgBMdgXKJMiuMuTJCuDk44ZhLWiiLmeZRlZi+NLoRCq7z5visFBEyUhGIpYKjgn3qMWwQ5i9mgwjIi/3czAJAxWcbsZjIbv/6c+N1rpbHUC4TFjk8PKeIfiJoKxgX6nxy1LJPGsrZyz6hJmZdqI+Cza79vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRfZqtK/Ph/5Pu9votgs3Mh7XI7ud/OtBwE1Ido7RmI=;
 b=XKTdbO9BjAvnNyBSkQJgV6wycauiGGARJnIkr31cNt2S4GuOmb3Cc2YFAhIEnxfriOw9iqxmFWJod202Ji8uwEHBILJcYE7y8tkVbN/rTQyZuPsAZHICyzliTgHfzV3SU+7llOSX6h/QhDeAfASjfw9l+1NH9UfLNybCjuJrPbc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3926.eurprd04.prod.outlook.com
 (2603:10a6:209:23::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 20 May
 2020 08:36:54 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3000.034; Wed, 20 May 2020
 08:36:54 +0000
From:   fugang.duan@nxp.com
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, martin.fuzzey@flowbird.group,
        robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, fugang.duan@nxp.com
Subject: [PATCH net 2/4] dt-bindings: fec: update the gpr property
Date:   Wed, 20 May 2020 16:31:54 +0800
Message-Id: <1589963516-26703-3-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0233.apcprd06.prod.outlook.com
 (2603:1096:4:ac::17) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR06CA0233.apcprd06.prod.outlook.com (2603:1096:4:ac::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Wed, 20 May 2020 08:36:51 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dee5eaa7-aac4-401b-f8ea-08d7fc98f300
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3926:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3926DA799A15F7C85F9B0361FFB60@AM6PR0402MB3926.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 00+aT3FyZNznNXafMbE5czdZ2Q2/SpFbHHEX0UqkoqD73HIMj2s1+DE3B/MMr0lhB48cCof69h5SDxdDRAyiBJyXlPCggmp3z0PYUEkW3NpQg1f7n6zTaNxVhAWxnKz3l37M1UsNVCiJDBpSAPEyYDKg5Y/7VcI0HZCSdxLIrLlKTljUZ7Qy3Yq4tppR0+XJQ3A2KBzZxM9OTzqVatL+yjdIs44hObYef+uKLgLYjnGa8x0RFC2kTJy63QNmD7Z1AIXWg23rCeVZWY+t+c3gU6dpkIEApoIzEpvLWLrs0DQO85CZZADY4B1PYjtuqblq3NaWMGF4Ob4ARcrYZrrjDXfzmg5TRfU2qroRForiVIJj0+4FR7SXwAiHk1S1C3c1RdyEYoZGQARM6n3LS1owdAIioZ3ufjjyrHkLV4aClzV1bevQKvV0RyA0KsncQlEA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(6916009)(8936002)(66476007)(8676002)(66946007)(86362001)(66556008)(316002)(2616005)(16526019)(478600001)(186003)(36756003)(26005)(15650500001)(4326008)(956004)(6512007)(6486002)(9686003)(52116002)(6506007)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ODeiJg7tsqCFmfBm81EEwldgyO8/LJMU+hA7vvTUuqZl+b1DyM0fJwq4E0xL5JzPQCqLrafW0wp6MVY3vdC84wD91U5Ys89GkKR0eT1+1g3YRdjOjKLenAWywmDIcApXC4O6ufNGiVrsFkcesdC9NT4EB4km10eRke7QRbgJUm4N6e1WsuT9D6+kFK+K/XBxUHDK8gmNHaxKvLmJcL4cosjijlZgpWmfnb//sb7lBUyE9OOLyWXoF9tcnVC/MgAOEno61KEG1dlHgpPDBGhlRnNn0Pklq1+qI5zCHu4j0bTK7NguworKPrgiJc+Z2JFPHzlMaTKJNohWVcVFKhpq8Crqcyy/Xzd5vCiEk/i3rPp/B+x2jVGZsFKxd7GNuVfMLKRBZgqVTGFaQ35OTgVY6raEZXJbpQLo0IYx+q00TUKwhmiatnkIfCrOa3nB/AWvE3WOlt6Iks6mV7wDWWPhov4BEg8YRUDo6LSIuRApreEZyFE+krQA8/Cz8+CP5OZN
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dee5eaa7-aac4-401b-f8ea-08d7fc98f300
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 08:36:54.1918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vkmUSWF1B+fzxqEwJsLApEUcuLjk9h/LbmR9TSWF+6LwTvyIJg6tsDFzuauQXqJboSSuk4sDOxEt5iwUT50G9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3926
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Update the gpr property to define gpr register offset and
bit in DT, since different instance have different gpr bit,
and differnet SOC may have different gpr reigster offset.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl-fec.txt | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
index 26c492a..c2ea818 100644
--- a/Documentation/devicetree/bindings/net/fsl-fec.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
@@ -23,7 +23,12 @@ Optional properties:
   the hardware workaround for ERR006687 applied and does not need a software
   workaround.
 - gpr: phandle of SoC general purpose register mode. Required for wake on LAN
-  on some SoCs
+  on some SoCs. Register bits of stop mode control, the format is
+	<&gpr req_gpr req_bit>.
+	 gpr is the phandle to general purpose register node.
+	 req_gpr is the gpr register offset for ENET stop request.
+	 req_bit is the gpr bit offset for ENET stop request.
+
  -interrupt-names:  names of the interrupts listed in interrupts property in
   the same order. The defaults if not specified are
   __Number of interrupts__   __Default__
-- 
2.7.4

