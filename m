Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24DF5B6D48
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbiIMM2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiIMM2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:28:18 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27416113B;
        Tue, 13 Sep 2022 05:27:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmBoW4iZ+m0Usy/9EdCSHM4Zc09fgOV2O3rJnvu9WzO2Qj6/hnkX0Wj7oy7t8aPrygd99R4ceXCT6shDJUmcvOvmOMzNkFQbtl8vq7thHGgw3wtMk+EbGV4kvctC3QCOXH/L+Kwt4WygN6hUsCBP5OEpOpGhy5Q6ZZKIsPR/TFr9TW9HACv4ZkrEwfmUhTFapGA9Zj1If/f7hPp43CjVFjaM9RILdUaaR3G6GPXGaHmnJQj+/4VIuCSGYSgw0JmD7WbKa5OhWVWwKmvY8DK4KVUAPrQ8OHMEGUwd2foIW8ayzLu6ekmz3lYRpXc2/ifOt7Uyp5wBeABI4MbxQGgUag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5Xy1SP/4vVsm2Wx/rag6u83ZWyeEmTFEUaMEib9N/M=;
 b=dLHbpZIp2vgRrypbOvHQ1CQQnlZRfsU4i2UmUsLfs+v8G/QwpAjjPMsQdSe31thQv6gOtHu0S9t4j6cDsEgp73I8vT99bbsoVYJnyJL2/7JR7BO3WCc7ZOLka2yH73NFxVUEiA+FOkD4NP/J3PcaLIvZcUXR7AQasMB7OqIx5kwqJbwISAemTlHHqG40ZmM6flW7td9+JxBiMEbYj/XE61zWDGW3+r13rANdlLbdknM9AoSu4bMsdK0G4VKMtE8AerrX+scM/JPlajiqRKWLN6j6d6IT+ph/XV3nSlfM5Z6iP1uDluF8piWHt9xgfDbqOridqcdtMuAX+L1gfWGcjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11) by PA4PR01MB7421.eurprd01.prod.exchangelabs.com
 (2603:10a6:102:fe::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Tue, 13 Sep
 2022 12:27:04 +0000
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::1829:8b89:a9e5:da36]) by
 VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::1829:8b89:a9e5:da36%3]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 12:27:04 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v8 3/3] dt-bindings: net: adin1110: Add docs
Date:   Tue, 13 Sep 2022 15:26:29 +0300
Message-Id: <20220913122629.124546-4-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220913122629.124546-1-andrei.tachici@stud.acs.upb.ro>
References: <20220913122629.124546-1-andrei.tachici@stud.acs.upb.ro>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR07CA0287.eurprd07.prod.outlook.com
 (2603:10a6:800:130::15) To VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0102MB3166:EE_|PA4PR01MB7421:EE_
X-MS-Office365-Filtering-Correlation-Id: bbfdf78f-81e1-4fd6-35dc-08da95834417
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fv/m2xvHEdXXc3OoU2nkrRHZrVTrMXVsbMGjf9i7QhtYkXyUeOf4LVFhGXlvScS3cJjoBpYVc2MfI47tO15+G1wQo+bZdIBMNQ4kU86NsS2OQjGXTP/sDNO75ynX6WdR8l1T3hzAy1qBNGIK9wyEzRjU/eLP4EXPFy+UrqxMo4yu8EnHrf97t/obkCHqM9VGp6vZ54OzANrWkS/irqNz1uGlD626ZzVznAI2Ipn+sJc08RJCwpo/n1ZCBMUcXNlZgyyISPkWtb94QA4g8k672wlE7NgxAJjxmXSD8esdhtOFWLJUSb+K4RB6el1cyo4yzb1kr7xijPoKnYj7hq0bqdT5bFnNFSoMXMMwqQE1+o/fYw5ECcAIBkN7QWX4S1LVdaoiXxCsBSEfty0bPgtToBVWH2xCJj1L3t+nKeMZAUJ1+9Z2AqZxwMyIG0aYNZD9Hxz9wXsUCv6KFC+QjNJmCeXWsChl8syAP2EWjffdoa5aL2dT9hB1HlyOE+7q7AT06oMMKy//XJUsSGNx8X+FO9oOoBXxs9x4jKxozaoLHNTrytxOMFvFy3jYu6Wnn7ioC5TVW6bY5UP+HQLBj/78hqhNJSnrc7Y3znHdQYsWab+sED1nG3KNM/WTPsIJw4ETdX3JAB1rAQ8xICsk1fYnPqO9HML9drYaXh0RuHH7a/7PjkhjFS3BY8QgVIY6ZjeJaFhHlMOqJ3yNNJkFMBZ4j3aSnlrbub4Fx7qQzFSWvM9uU1TLGJzCJ+HxHqZZykhyumeG9c+FczI7bW0VKlc7No3rVgVVbFlcZyuBWinefNI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3166.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(366004)(136003)(346002)(39860400002)(451199015)(83380400001)(9686003)(186003)(2616005)(6486002)(1076003)(8676002)(41320700001)(6916009)(5660300002)(4326008)(6666004)(86362001)(66556008)(52116002)(966005)(6506007)(66476007)(7416002)(6512007)(8936002)(38350700002)(38100700002)(786003)(478600001)(2906002)(316002)(66946007)(41300700001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y23lq+gBSdLJ1W4tWLdJjljfx1bYgNtMY8yXmdCYPbX5RxFX6P/XYrpjqaGl?=
 =?us-ascii?Q?hr0emF9IDb3FHWAVcLM3FDxj40MANYd2FBmaM1Vhb0UEyB7Kc5+2dzFZeFAL?=
 =?us-ascii?Q?6RBHGDcKvzv0UNdxder8ZULSInKW95eCHGOJIpfduFItqxKUtoiMDvOO/9ma?=
 =?us-ascii?Q?zvtHzyqc6g0hwYczzSjY4H624NAkjAFCaE5bJPMR9z7pjnL/ZgYXJsSflg8X?=
 =?us-ascii?Q?EV5biZsv+8CPWXtcpS7QcNEPS0KJgMieWUDSUl4ZzI4r+UHIDqUqWShkhEPa?=
 =?us-ascii?Q?zL0CeJ9EYKZnwFHer5iTg2Egt0Z7oBUt6dx0tFpwksatz8TP0885PbbglMM7?=
 =?us-ascii?Q?//URLvzYunJU2tjSmBPpqHr7TvayRSJNvln+pXOFE3qHqt3D+m1NPESAm3AO?=
 =?us-ascii?Q?pMMi1q3c7pQzrPNw72cgpllcXpy6a3QIPXjgY8zYyIPWZD1Au2qx9pQfvTAN?=
 =?us-ascii?Q?Ec887rYVm0t8TkOGZvNwKl6Kyo7qPbQisj1JytZtlvwLmbwOPGEGa7+P1w5g?=
 =?us-ascii?Q?thPukJ6ltYWhJsaZxkkWGuHwbk3eWZZoTdacX/1Q/5EmOnh6I57VW40Z7V9p?=
 =?us-ascii?Q?CAWAVuW3is+k5d8UzV9a+flIG7AZC742UPwtStHwZwn067BBOz52fDBfO90c?=
 =?us-ascii?Q?WPz3o4oOs7sn4yEr8lJacfkCISzLi3h0ralzBnQT2bk4FVEnIpHOT6NZ/GJM?=
 =?us-ascii?Q?9M11AzMMEmDhQ7E2/vpQVyqE5QuTuZVtLlMdnI6EabL6CGPnsi88+ZwFW0pd?=
 =?us-ascii?Q?rovOAocf4B90cYSttrs5KmYFFiW19SMsIA0bEuYj0CSuibSgB1PGiyZrHo5f?=
 =?us-ascii?Q?g2Je3Bj4mqercwon98EhFHNm8XnMSqVG3/6BJIqkt9Xk9oaA1Yf71lvVLVtT?=
 =?us-ascii?Q?8u+r6tj4eAuf/aS/yIjEQxMqkF/zLbgBb7wwIqHF+hv7Q1FnLpM+joyvCYhh?=
 =?us-ascii?Q?Vv+AxCVMpjRNPc97NP6g57id4Ve7Asi2xPEg7w2cLwKBf6lh6i8b0OI1BnHC?=
 =?us-ascii?Q?4y2754QrTIjbcqtE1YEK1Vk01ZEGrz9yU9GSWlT705KrDlyZ5Zgugb9RHbfy?=
 =?us-ascii?Q?kMqwqVp1cHtFYmOoeVRrXZ4tYL6GfunLgb61Rgct6bEkP7BeasSrUhfYgVBX?=
 =?us-ascii?Q?CjR+Xdn2JXlJVsc7FUrjrqn3coB3679hudKusezTCxjSPB2pjqNNWSTn82UX?=
 =?us-ascii?Q?kFYsL8NavaLnwVCym6Bo1C2Ip8KPkI8c7Zj3821FTEKxLKNb9FKSu1ErFv/O?=
 =?us-ascii?Q?jPYZtrCyYQF4ariDZGy/Sc1nbF7JNxbQS/6iJ5oS8RfNh5ci5miqAN6L/tPn?=
 =?us-ascii?Q?CGk7Fj4OjvasuN7Sj2pBLBPukT1Mascd/jk6WmEoJEpKlvXvPc7DM3oWu6vZ?=
 =?us-ascii?Q?S6RpdvP6mdl75eqa5cCe6Eod6mcSnBsO0ji+yUlkmG3Z2VVtxs48PmxS6l1l?=
 =?us-ascii?Q?4uJkXbU3MfCVRUGsS9KCnvCN3UpDvEr8p787KCmQu6IKyb3sHmDaogAhD8Vm?=
 =?us-ascii?Q?nFvo7wFTCFd1FFd+neSMFroNfiy5dFOtKz/PwfURQ1FgQ7+PTBeIXPTYGHv5?=
 =?us-ascii?Q?j2IxlQtwQklNqysOusA53GUTcAnZ2TMjSW0f/2dAVkYUWwMNbCESpS3wUvkE?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: bbfdf78f-81e1-4fd6-35dc-08da95834417
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 12:27:04.3691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ytXPuCJgngFf89GYpEc+GKibpuXS1EXU7HbBi7cIM2vKWYDYpMeeFjTWIBLh2J2ICtb2au0sFdTYWIoRi01xaWh3n/KN47bbk5cjVf5zc68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR01MB7421
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

