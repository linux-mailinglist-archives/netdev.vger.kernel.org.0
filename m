Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A90599D7A
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 16:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349216AbiHSOUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 10:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349504AbiHSOUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 10:20:06 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2085.outbound.protection.outlook.com [40.107.22.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90254BF74;
        Fri, 19 Aug 2022 07:20:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EN+q0tQKUnD93p1BFzTJ+gWJY9dt/Ng7/D2hyP0HM/u2e7WH/CtMi4jZ/RppaA7fXr9cBoiMAYJYD8gKAC2wc7HxzyrlcWLHRlF3hIy5ecLDjyI5W3MF4PyibOh3i3FrbAO8FncRLwOirzHYmgjfiNOlf3lXIqpHyZtktwBZuasbDBKJTNv8/PLU4vtPBdDWDj1Lnuv0T3h3IfKtYlltvnHKcc9GfWbiXTqTRM/Oti/NxJBhfG6C2h4r0Zw3qd4RDFS6/TgxLr5qvorgTUM4miO65h3lfCiu+w0koZo6v4B8f0mXSDCBmvULZhC3bQzm+3b/65H/tuw3FMwmklve9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5Xy1SP/4vVsm2Wx/rag6u83ZWyeEmTFEUaMEib9N/M=;
 b=YInIkXn93kTckzNJES52aM2nnjpRgXR69JSotGyYxzoaLPj1QYT0DIqoumteG1ygOdrnxLuw9Qsp/yOjDE8xHPwC4vqQlW7YwLZvz+dWNVUVik1derAJExBHYvuwH7kwDrt56jb1u/mS3Ij2wipu7wzvYNPUDJZ8/cDdVjTE32ScYCPJPduBkY1t3IqVYBP0K8Be5ZBduuxhpqQk42ONFduuL+wuw21Ae9aMpxkHVZbnIA5/GPWT/CNMsOfhsSXq7BYXb8mLXXGzS/TAlZwSDTxeTY/albz8MpNhjN1TPa12JCVkK6hPVXQfQW412zC63Wma1x9TvkM2o18fso5B/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16) by AS8PR01MB8023.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:376::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 19 Aug
 2022 14:20:02 +0000
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 ([fe80::19b7:7216:e4a2:b0b]) by
 AM6PR0102MB3159.eurprd01.prod.exchangelabs.com ([fe80::19b7:7216:e4a2:b0b%7])
 with mapi id 15.20.5504.028; Fri, 19 Aug 2022 14:20:02 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v5 3/3] dt-bindings: net: adin1110: Add docs
Date:   Fri, 19 Aug 2022 17:19:41 +0300
Message-Id: <20220819141941.39635-4-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220819141941.39635-1-andrei.tachici@stud.acs.upb.ro>
References: <20220819141941.39635-1-andrei.tachici@stud.acs.upb.ro>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: BE0P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::16) To AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28a4aac9-a9f4-4b95-2067-08da81ede7e0
X-MS-TrafficTypeDiagnostic: AS8PR01MB8023:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4sbbiDSgAKMaWaINdCcNs88v+THOq5BmeUFnZUGbeHSVGk3dcg1TH7WbBBntUOqISFa0eVAaZuapiUfZnOiG2ilRIH659p/pg63yhFOQKk2hoUKFPQdFOcoEiyCxvBL1ykEZLhIrXJf8PJJUjXzkOgn+ifceioWXrM5vfwlLs6lamUItNRI7oToVkQc7GBqnbI5XgxbcH8UxmMI9JOwLDMFLmFQhFvEHn+jdxC4iI3rjMynuoZhfm+OgIq5dUlafjfYjD21IFuVBFeHc7mDln6F7CdhhAFIhmHIkxQaEmnY5NcvHveiA4ICSotfyWCXXRRqrbXKgZzHfMuT7OuT3pdh0Md3tXeQ9sbxxUyQ2kcqHjpAdJMu68xBOpUkRuNxRxEU1PpwwRC2uZT5EvdR9jFEb8BjNyWnWKZf3JJY8X2YqDGsOJWAgGtXbCE2yv7IlEmYbwwkeKYPQj6bMa8TNoc2n/po0deWGViPRl4WavE68eWR7DnLGlT9oHzDQ+oleZDKFtVJIeuzbQTwcyVBKf84V801qRqYqjHWRg9DWV96q21WRblPeKQ+WQ7N3JnxgIyHtjNYWnLTLr8x0XCQIftgvHHC8EqM1m3g3+8FTGglUoVt94+Geo8TDHO/M4bLE3V4fuAKoHhs7PjmAeDzQ2dfks9zaBYe82ahNuO8kvC0CWMvGRx7xEAy5vt23zrQVB6lAfLBqgjOK+LUhoX3naWdMjlZMjW62A43Gj6zzxds=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0102MB3159.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(396003)(366004)(39860400002)(6512007)(86362001)(478600001)(52116002)(6666004)(6506007)(9686003)(2616005)(1076003)(186003)(6486002)(83380400001)(41300700001)(966005)(5660300002)(41320700001)(66476007)(6916009)(4326008)(8676002)(786003)(316002)(7416002)(66946007)(66556008)(2906002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mxKtGGZW6fIU97QeqWbxBDixlzgRd4CXSzkuAERjl7/JJYu6XQ9Ho7skPIgT?=
 =?us-ascii?Q?2g1ck5DaAHvPnyIo3c6QXrB2qWhry9YRQ7UQDl4IvqPLKXO2H5KaolrQjOQp?=
 =?us-ascii?Q?ZB1WoLxdr+kvosir5ca1ed6zcV6izmRkr+hcpHX9QDtIEQ3XwZvOfIxACFUg?=
 =?us-ascii?Q?jTnwHwASdgd2/I+HLsB1G4mCRchPe6KNxyctvfsV/cpXTTySj9ai6Sga3b/X?=
 =?us-ascii?Q?dcfNANMf60QGkZOKNVDxFK3g0lcWjDqW35PTgdI0BAoTIv5yq3LXy1BZLHo+?=
 =?us-ascii?Q?JP+DvUxaT72wsiiRt/w26cumpTfQMK7YQNuuPWa1AvCSFAWpiBqC1n7jSW0m?=
 =?us-ascii?Q?IhrBjNw9upgfcoDRBVh2dHzbuwM8DE9/sLZe+45R4qdBAYNe3iRqP1psiUK2?=
 =?us-ascii?Q?C3bpC+QJ+TXt2JhN+xgM8GsxoxMdcwzONkOMP5K0mVTS6XwfJUvJk+GmkbdE?=
 =?us-ascii?Q?XrvQLtyfL6EE5Xx7sOqrLguKoNoOUTlfR5HxQOiFXe2ofi4pChWQX/fEb5G+?=
 =?us-ascii?Q?qPJ2PB7YdBeSf+PABVTvQRM7q+/Qg+Y+BtoTUpHAHkOaoNoW+GQd/FwT3z4w?=
 =?us-ascii?Q?5/y5I/YRbi2+b9pXk/Fzx7MwZ0qPtpJYcDMnFfkm7R5r0254kpcWWSwDLJcs?=
 =?us-ascii?Q?Qz+26KzPBZjhR+WxFzymNsTNGq/b49djpJJAGkV3O+guiDklZf8YIkVmlqH/?=
 =?us-ascii?Q?aASyCfmgdfax7FS2+rVKXWpTorfniOBR8Eum6cRhfbf+t3YJXX9WqkpHVvYp?=
 =?us-ascii?Q?C/dCqcpy6qW6mFKGY2AleYbbMXn3PXIw1kagG6mFrrMiGSLng1bYwA40by/e?=
 =?us-ascii?Q?ciDtOoMNqKUsCyOOwcNLg597peERRpwlhqOHvHMbtstqv5VdVq4s8Lq+jPov?=
 =?us-ascii?Q?s47zX46IGRM5Kmdry5Qd4z9GiMSPssIV2o+Z6s5Rsh7KnLvoeNKjX6M6vq18?=
 =?us-ascii?Q?vizS/Wb32Wg86Bn7T3TvG2KB2bajxDxsh12wt0hJE20bjLj2PLpJzOvOJE+y?=
 =?us-ascii?Q?D6vP3Q+94+ehffMMy0r3VFgJ6AgbsaEIhmdQ8xE3XlMP9mY2N0TxSiCa5zwf?=
 =?us-ascii?Q?bTiE5uVX3604ZxR7xkFHU5+CExpUVkDhHOquvZiBFdbyuZL3U8b1IBzlQtj4?=
 =?us-ascii?Q?unCk8XALqG3hFIXUmr/JaZxj8LwO/sMAP9+nSjuZ16FBLj245SQyMJONGp8R?=
 =?us-ascii?Q?MSA5tg3AGa65sISuL5NKXtFocyI3uCPGDUSupShqARnhqsgQkQOP3xSDdMec?=
 =?us-ascii?Q?Oen+0qXjvApCypriD4lWYWBFw8kXKnXt41lsF/RkhGfBHPMITmHZDktG93wR?=
 =?us-ascii?Q?k1C8A3k4+mPOmHcizfUOL0xkr+aYAcb1XKe5g9/9pFnG0oBUB9u/xsM7AARx?=
 =?us-ascii?Q?1qukxg9frXPBE8t6mdLCN+pcjpi2fB4X01nKrGnUcqiVTgxUrJ9zTzPp5cMy?=
 =?us-ascii?Q?ZqaPEuN4YiQA64QafP7HYLn3K2W58o4cQBu1CJzyyRWicilgenyzlADnvEe7?=
 =?us-ascii?Q?qLgzvYdPKW44oayTNerWaHiJFa+uIQNSMOULEj1q8hTCmAGfqpz4DSE359SU?=
 =?us-ascii?Q?30S8BpizZvfmwwAYEfpcUPzt0B1OOR0MFvmDfVUL+PRG32o84WGIxcrG/WZh?=
 =?us-ascii?Q?eNUicdfeNddf5XcSr4R/y76xQuan3wRtU4/xHkNEnueC/FI9Vm/u6RDjGd35?=
 =?us-ascii?Q?sOZGH7MPGs93YoKsuUKApDjauLQ=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a4aac9-a9f4-4b95-2067-08da81ede7e0
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 14:20:02.5210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qr2bfDtnmxvHxmy80icpu/qG9GFDX5paAWjYV9BO5aqF8Q3ezXpDIKELzXPBdrOZz37swneBWWJtbFdp55+94IsYGEQMWA3iw/C+bNlhjuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR01MB8023
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Add bindings for the ADIN1110/2111 MAC-PHY/SWITCH.

Reviewed-by: Rob Herring <robh@kernel.org>
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

