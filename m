Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A0D597387
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240391AbiHQQDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240367AbiHQQDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:03:04 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60050.outbound.protection.outlook.com [40.107.6.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2CD9F0C7;
        Wed, 17 Aug 2022 09:03:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQf+ozvqPYXlWObzmr1mixuieZhE/50qCPLGOLvhj+13hXXuRt0zIG5yya8fJOEndxvUk4aaIpC8pjMtqpS0x3UOBH9BoK5574yVSXtzn0oLk698Hd8Xr9aJ21/D+FQqVJfiFz9Mn9ZGm8Zq0jXaUtaaaCUgfrfawtj67BUOAuXuu+IXZR1bEQ2+ZT/BqA9yg9MUXfHHS0A2ljQ9xWS0bDE+hVAnCa3pQppENSXxYtkierG88L+HLPLEqENsiiR/VvNT89Wj1PDGh0mG9SzuRFWG61onuJ1Hh+P5FPv2iATbacK1lrMxUORiCeSqodIwAIhioPhnmCe+KSeKmza3XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hL2ue7bxqL6wT/o3f28ReSYaMfSe/S2aKJRm6tvk78c=;
 b=oNZwbeTp1yH68rkw6DiKPRinTPGRd02CB8PLkp605q1Zf90QM+kn+gg3dWKaEWldP8OnPVz8CxothgsNUck8GeqvQ3gYuhHE+Azj67uPLr8rA30ATtfa3mcC/vFoTCkvRYcVJsNi/Uwa+5TEkOk4rqo2ro8vwm5PauvsjxUXmna8H4TYGHW/LQ7l0GBUI/GQtTrwHQN6rPdLwxi/ocTsN5q/5XBb/rlDf0D1/llErPjrx4ydLE0rPgSqWttfoItkBahwBzlrulpT5VnAdqr4cQWw4C2qpEfkcEllqwvuTM0k09JVkV3cJyUHar0fUQ2lX8b7WHnZiYFhfdle7phj6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16) by AM6PR01MB5734.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:fc::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 17 Aug
 2022 16:02:58 +0000
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 ([fe80::19b7:7216:e4a2:b0b]) by
 AM6PR0102MB3159.eurprd01.prod.exchangelabs.com ([fe80::19b7:7216:e4a2:b0b%7])
 with mapi id 15.20.5504.028; Wed, 17 Aug 2022 16:02:58 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v4 3/3] dt-bindings: net: adin1110: Add docs
Date:   Wed, 17 Aug 2022 19:02:36 +0300
Message-Id: <20220817160236.53586-4-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220817160236.53586-1-andrei.tachici@stud.acs.upb.ro>
References: <20220817160236.53586-1-andrei.tachici@stud.acs.upb.ro>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: BE1P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::20) To AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b520756-ab04-4ea6-333a-08da8069f3f0
X-MS-TrafficTypeDiagnostic: AM6PR01MB5734:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6sQ13eR0PSUyRFvRJattydqL069G9bLPSFvWTQ0Bk8KBUZpFLzgHbOvgRWS+Md8Zbo0wfYGwkFLiMUngNqmyMt2Ml+mhUZAkFqlbbHsGrkaIIxocS0lkcOEZCR646wRvnUPW6866PFVRsSDs/xtsNAbPkiGX2+/K0qpkiDMZqDc+P3wPQxAG0UGPTRxObtyofXF8k4S0cLFSwHiKxW5BFWLcaRIewXpyOBNl5a9kpe97aPatLOsPPxFbcDRX0ptHdDBJqvrYw/p1zQqBe58Yg113fH+samfslI1cYIwfP1cyukL/EiDEgcWkGSvfxLc8OraJ0fvoVIea4MnlSLiXYRbJLxuLOO27kYCimjxKc0Dda2n/AxmA7wsHq83pv0HLBvK/TYhlqDc4ZvpPeKZhKuNVlLtDIjKnLCH71tjP/KG8Nzo+w93KcsYiJr4pIP5YbjE3BF1+fjYSgS5AXeIluKXURtU4JIBY68mNWPTrY9IW3oBJfe9B7FmSt7EVLs41VgRwgmRhRgSJXcDNBK50wbaPcAIXdXs5wdeQEbDsspFXRMTMX4K2rR86f5u5i7GLvnm6Lb0jfHvJsXgGQOahUerOAQQeWyyisMNMDzzufbS+IC37HnfEL43mJ6JoViIEFR654xhkbKB3kByZuaphCRXN/G+BDDBJLmjPdnKSSUFDabB4v7pMk5tAzWRLwVLvPRpgNERNcM0GTSIodl/hTuhLoXVHjR/TcITpSttsnKIM3G+1JKaxOVs3jfNM3kb9rsbcR9z37F0m3sJ3f499Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0102MB3159.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(376002)(346002)(39860400002)(1076003)(6666004)(6486002)(6512007)(966005)(52116002)(83380400001)(6506007)(5660300002)(9686003)(186003)(41300700001)(786003)(316002)(41320700001)(2616005)(7416002)(478600001)(2906002)(4326008)(86362001)(6916009)(66946007)(66556008)(8676002)(66476007)(38100700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sTdXh+Af0Uzm6AWPAbKNvOv3wAYGTU8+WXl1S49jaioQGMG1xWL2sM8oSvXg?=
 =?us-ascii?Q?51UnsEDvTuhGjJZfXn1JqGFv1WhaYyT4VmlbFyCu21HYUyaqRugxN5DsM5yB?=
 =?us-ascii?Q?x2Yv1HuNbKwmgn9k+G5jNB+3gxbZQZk/uel26MZlgPvSoFoednpr0PzEIg2C?=
 =?us-ascii?Q?yYJBQlh1nv8U8lg2OKesGHfDpAStcBUsuz0k/wokmnXr8p4bbRzTnrRqHRuD?=
 =?us-ascii?Q?ZU7u83HgiR12+fLdwdHZFAcJ2uhhfnNUFQPDDElTwyec2QccpU5D7mZ4rVCA?=
 =?us-ascii?Q?ksxmw3eOMY7lu//lVcSTHjOO+YS0kchyFn/+3l3SB/QIeteT2GpEPdPW7s1/?=
 =?us-ascii?Q?W8Rdo2MkZnzz4uU+0z028ekg9I4FlOWcba/3557191yVcSvFIJ5qeytPqfb+?=
 =?us-ascii?Q?B+lmNxsof8PZdg6PKztpHye09glh247Z+T+YeODY7tZ18gVSvCFA5ncEPBYA?=
 =?us-ascii?Q?GmunCNb4aanqorgocWt4bZavWv08UV8a8izHClFKAkUnLMeAo0zeob+qP0A8?=
 =?us-ascii?Q?5MIlfKcPlzJpzttHwLHsvjbxwpn2hcMhOCWo4LdgNgAdCiT8msZu3ThzbPWd?=
 =?us-ascii?Q?hikabMmDK3WHE0dJWiwBbpL1pudTeAleN2SIErYt7l4OsY9Fo/Psxw5OkBgh?=
 =?us-ascii?Q?jUApgikCf3IJLaNQFJ+XDMf+9BxIhXk8TkUwvHo/AP6IONiG2UvoAgszlSmc?=
 =?us-ascii?Q?kn8m2aaDE0+2N4UCAqIm5Kkq1mPRqg7F0+ILxTCZvZWY6OcpKJ/FKR3fCwXq?=
 =?us-ascii?Q?4Gg4Hn7+ziGI0CeghySVxHH55DyaGjlbh1XFMZwjbUp7d7slUdwFPV7BKofE?=
 =?us-ascii?Q?F+d2uJdtKfiLP5VnHE9BeFJRJI036ETPmQtiNKpFYP3Dxq7LIOkxWfo2MxB4?=
 =?us-ascii?Q?e/yuK0puZkup22v5teSsvuAmNkMFnNKV7maJ3ypfRhB8oxL7bPb4LQsgnmyU?=
 =?us-ascii?Q?QCasq0PK+XTkBbFKJNOg3HMOZP2mF2oof3p2O1E2AbNClAeBFfSzQFGNhBkt?=
 =?us-ascii?Q?70sZ9BeyQ+soFPM2VsTmFySGELr2h0CDnpyh/a/I2jQTTJRYUc41QFQtveAd?=
 =?us-ascii?Q?VX7NLVaWJbV2XoeypmSXoUEQu2gU8/9gMoyqYRpi2j8hhYWDv7ZD8wJI+vBx?=
 =?us-ascii?Q?62i21FvBHbXoSaBNS88p4so3a3KF93Ov1aUoCKRP8PXsoZo9UVCNszWIixFu?=
 =?us-ascii?Q?w5aThq2GHGC/Jsq/4E3bC17Nd82xZYrBJE30YK6sJXnln3yjD0j7MQxuFo4m?=
 =?us-ascii?Q?zsW1+DOm9PkdalTp601siHO16vF8/D5empzGmAm0yn/s9TNb7cWKpqOZ55Rs?=
 =?us-ascii?Q?hj22lhpxGoVKYBxX7z/DhyLmVQdobZFVtUUpxMSMVtXVdzg41aEd6+PFeo3H?=
 =?us-ascii?Q?GMXZzHclHOqJX/kKlqjVOtYgC1njzsiWYy1NUCmRoMS8jFIycKMZpm3OQ41t?=
 =?us-ascii?Q?cBWj9R99EOIK4+RKsfb5P/ZXMKiHoAsiCwq9vMdFWUioBMu9ABJBAs47Tw9D?=
 =?us-ascii?Q?roWOcqTzp0kP0LAYcgv9rklOK9jOoKkzhUNdgK/Y6x4ETqJwuZK4k3AXzhEF?=
 =?us-ascii?Q?YqBr1BICPx0lcVcHT8gUv0IJrxnADhwRCZVUSQmV2llrEcSMgwxfo86tnCdA?=
 =?us-ascii?Q?KIolct5wzX1EY5Qn51y42MVtHLx2yvOrsil0daMuRrQ1gnmrTp3CE32vAOXy?=
 =?us-ascii?Q?ATvnLe+oWNJzqJBvKkvSwFsv7Sg=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b520756-ab04-4ea6-333a-08da8069f3f0
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:02:57.9966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s/9Es+zttqMAoXx9iysgYPTZcF707zK8tz8qIrXA50MNGzazI7yud3KUHrfhkrD3ks4V/Su2WNFv7qExRwFbdyVkXfLwAIsuh71qQwtzHHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR01MB5734
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Add bindings for the ADIN1110/2111 MAC-PHY/SWITCH.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 .../devicetree/bindings/net/adi,adin1110.yaml | 77 +++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml

diff --git a/Documentation/devicetree/bindings/net/adi,adin1110.yaml b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
new file mode 100644
index 000000000000..b6bd8ee38a18
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
@@ -0,0 +1,77 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/adi,adin1110.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: ADI ADIN1110 MAC-PHY
+
+maintainers:
+  - Alexandru Tachici <alexandru.tachici@analog.com>
+
+description: |
+  The ADIN1110 is a low power single port 10BASE-T1L MAC-
+  PHY designed for industrial Ethernet applications. It integrates
+  an Ethernet PHY core with a MAC and all the associated analog
+  circuitry, input and output clock buffering.
+
+  The ADIN2111 is a low power, low complexity, two-Ethernet ports
+  switch with integrated 10BASE-T1L PHYs and one serial peripheral
+  interface (SPI) port. The device is designed for industrial Ethernet
+  applications using low power constrained nodes and is compliant
+  with the IEEE 802.3cg-2019 Ethernet standard for long reach
+  10 Mbps single pair Ethernet (SPE).
+
+  The device has a 4-wire SPI interface for communication
+  between the MAC and host processor.
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+
+properties:
+  compatible:
+    enum:
+      - adi,adin1110
+      - adi,adin2111
+
+  reg:
+    maxItems: 1
+
+  adi,spi-crc:
+    description: |
+      Enable CRC8 checks on SPI read/writes.
+    type: boolean
+
+  interrupts:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    spi {
+
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet@0 {
+            compatible = "adi,adin2111";
+            reg = <0>;
+            spi-max-frequency = <24500000>;
+
+            adi,spi-crc;
+
+            interrupt-parent = <&gpio>;
+            interrupts = <25 IRQ_TYPE_LEVEL_LOW>;
+
+            local-mac-address = [ 00 11 22 33 44 55 ];
+        };
+    };
-- 
2.25.1

