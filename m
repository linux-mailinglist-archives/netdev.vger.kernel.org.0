Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700F7587FA0
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 18:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbiHBQAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 12:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbiHBQAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 12:00:13 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B053E9C;
        Tue,  2 Aug 2022 09:00:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZ8bwUS69x4x6TaDmzB++p9zlunu7wT1gVVRMTKXAwl4TkiyEO3XysoFxLqbjxMq0oWrltwrK2CbVt2vJi7nxW+nmwLfAYb+ZbSnNHC92lBmXJ0Fl8lDuKE415TTJVe7q4B+lfoLNf1+9b22F4q5QpMb+aGIQ8ZbHLflTU6mFFenBft0Un5n70uGiUxOwqGKq+AZZhzxefHleMR82zd2kSsPHTYGd0MAHO7jZhLayPsmkIr2kmqM5kHtcJJgiuL7DIo/jwbTTofZmq1jpzaVFg9bxPEkZN4KeAQMhEYWoJ5/SWP3VqJZT07S9lq6SRMv7bMAbKApilSV+E6CC9jnOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxhNg2lo9oFql/xA9YKHjcmjftjQv3+7x7woWbwwrZU=;
 b=lVFWiJWxjmdsd4KZyuxidqfn935x2l2TAqHBGvyMLTJEABkb7+rrIg3b95L2fehc/1sIQOZTJXqQ+z1q0TjEGMAbCJ/pxTY1/q9pc6Y2MQyYePAzMxWyPruxAi8b0yu2zfuEni0zE/LzF7lG/yFTXD2T9DVVHXMlxcTmGUpWZRKXrQTDO6rogSSTnV8kHhTo+pbyz12djNKO3bKZbA1nWxLKTEUQAJrdGcvJvkhSamGKBLpaD6bsdYPVaDGa4JUNcXD7YPJgXqMhKU/h/YnncNmMJNkarx4JFdeBw2hl/ovs2w5ttVMam9Qr7DafCeheoqsHGE3osCteFcQnd3UsCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11) by AM9PR01MB7252.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:2cf::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10; Tue, 2 Aug
 2022 16:00:05 +0000
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::85e9:83cf:765b:ca12]) by
 VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::85e9:83cf:765b:ca12%5]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 16:00:05 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v3 3/3] dt-bindings: net: adin1110: Add docs
Date:   Tue,  2 Aug 2022 18:59:47 +0300
Message-Id: <20220802155947.83060-4-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220802155947.83060-1-andrei.tachici@stud.acs.upb.ro>
References: <20220802155947.83060-1-andrei.tachici@stud.acs.upb.ro>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: FR2P281CA0009.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::19) To VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44d732ab-2f5f-4e2b-698e-08da74a010c9
X-MS-TrafficTypeDiagnostic: AM9PR01MB7252:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jCa+b3ksnLSR/T3L6xUgDjWziaVTGAWAECMiFzCg60kzBasPTZmvZdlOf9WfSOFjberFfeEzndzfc8LUVl0eMs/2/6B1xK4qC2drO846IoxUDEemH/7vYUMlxtwQatfAWLh3S5gvyrr7sQHLz7dKBcc5JDcgpD2h2Kjyn0KlCEv5SeuAqpPWahm9OCEvCxvrL3qGv+78r7ztnRtPQdX+navKJ40t5/yFuuSxja920jaLk5xiQDbhFxPEeakXWy5cGGMnUXZHSeN37QK6kA8ZtWjX9e+PPf28kWW2FURM3mcocC5M/up1lfWmUJVE1y86rJuXLh+ioc3oFbIVmMV7M67FF3jq0fUQbf9gCLHxQ7EVRCwinloFpCZD7LICm+J4mO0QvfH3Evh/q8MIOEwukt/Qd+bk9TvG1iYzzlMqMWSyVTGEsB3DW6qu76RyeJI7RYeIlB2wJyLeLevE2opbnN0cvSk1+EoC5Ed1cdIohYdwivdLyEdfWA14cxy4rX5hgHVVVIegJP6VPCpLbvbPk65cuTxfS0A9zS5MvoHxf0rnYMuB32SYncvXv+7Jb8/1cihMsk2+nyLZu57UpNwWoqGL3I8UqJPmEGGnq8bnBDQyxlMoS9aTrKSqiaHMYBQ1cVKko5kgkjUhhawtZcHpDJraQECPsFWtXATFyAHKgAUAWSZAuf7TzNXdT12KtWw1LT0ZgM0+4oyVireaJvfJpTPh5vbxPJGgli557U3S59q5ykV7VFY4bXP3YFII7+Cn9hj0cvPsvLDaEIjTWrZUPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3166.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(39850400004)(376002)(346002)(136003)(41300700001)(2906002)(2616005)(83380400001)(86362001)(6666004)(6916009)(52116002)(6506007)(1076003)(9686003)(6512007)(186003)(38100700002)(7416002)(6486002)(5660300002)(66476007)(66946007)(66556008)(8936002)(478600001)(8676002)(4326008)(41320700001)(786003)(316002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VAGkTeybK6EuG17FYgdRLOvaBt3oTGrCKcbisEO6e5japTzYqV1lgHTBi9Lv?=
 =?us-ascii?Q?zKPB745d5Kk/t6a7CSZmFnNN+qIIXYsnWCm+nPMgHNvzJE57lKI8XWFl77tf?=
 =?us-ascii?Q?exhJcG5XSkJWvkUtbAtUv7s1hkV2xL2L1AN4t4F73flsRDZIrtobt51D0z3H?=
 =?us-ascii?Q?EfO/iiqNwp9aTcUSEGDkbx36QdB6uQebleaRD8cESWzR+f7r4bCOv7g4uze4?=
 =?us-ascii?Q?whNAfXaQog9CZJkyxw4JyFeLZZ6BG5Cxno5/1WL8DvimrqneDAF8E7Uov9sD?=
 =?us-ascii?Q?9WJrZNtVvvUwnUzQ0p+kPUQJKPES5nxi7i7DGEhDw8pSH/vnozlLspw3So2i?=
 =?us-ascii?Q?syL9Mtm31shRYbac5VZRx8odsJjBwoGBS2od0KyATWBBjzeaP0EGefmoEmQU?=
 =?us-ascii?Q?QStURmWMt0GUH+ESsW0trNq9kAy4+logoMpIRHwCmWe+OLT/eNuRL62T3+hD?=
 =?us-ascii?Q?LBd8DSymtH7utYKZocgaBxmCWzur5nQAkuokHdvxV0Daa+fg0t7Ixs/acWxB?=
 =?us-ascii?Q?vCSBy4kOf6VeDvZJDmE0BTSNg4vboPo61iZyWQkR/7WKps8Jt1g5S6qQj6MG?=
 =?us-ascii?Q?08TL9+Hd9v797a8eUA5SeDoW/Ym2ZDY/vyTPXaxyyJFxU1tGs1z2a9sJFaN2?=
 =?us-ascii?Q?nWaamHIAhVDf3Xn6mlKabRXJm6AU6UW/SynlYgD0ULeAeurDo+lKV4VOZJn1?=
 =?us-ascii?Q?3806F/0WPfm47hUWQtwRbm9yU6zBvapHMSrWtGWbdTGHgXk/rBIaft44/vFe?=
 =?us-ascii?Q?jrbb3C0EJ4WvtHXOtfDhqzX8DZl0EIjwVvbqDzI25hE+EBN8OWe8oWfJ7IFq?=
 =?us-ascii?Q?C9TL4Sjmc++IRvRTpM5cbmQ2z/5az37TOmYXjVfI8Z9XU88pXwMP2m4Se3dQ?=
 =?us-ascii?Q?0il66ckJUbqIMfa1iwID/CWJ5xi+Xu4KB+1lEcP1NhUTrh5sY0lva16Mc4FD?=
 =?us-ascii?Q?ziNVbXMtqX/XBKH7e1PiQZykSRd3qbdMVGPottqLr0hwl7oac/zTEIMxqKek?=
 =?us-ascii?Q?uvWdoTjl3TZuC5g2sgVK8oKAjuR5zuYZ/0RW2nOGaDjYlfyPSuzDvsmqtTpt?=
 =?us-ascii?Q?FOOKdDMmwu3cobdDAwOsBAPjH7U769en/FyIS50tSWqBD/Z1Rak3+tbhc9Xf?=
 =?us-ascii?Q?bFh3wgFegzkIh1APEodtxiebDfHL1kEOwtQLGAK/wgGWF2F3xO4HNgFAk+l8?=
 =?us-ascii?Q?avzURJqhEe5DsMmV4KrazeeYdDl9tSrWkI5970xoTES9MhvJyEeb2f8cPGe/?=
 =?us-ascii?Q?R/9aCsuSzulwts3lt6f6Pd7PWB2vM9Vg2TdZ2kSlvDjI2IDlpwNpd3EVVOao?=
 =?us-ascii?Q?nV59al9yUoH0xk0rqUeQwKp6aIi0ZLD0Tsq3Hfv3w/Sfm+nlW2zOmbDxF7H3?=
 =?us-ascii?Q?iPynLmL4zla29/jB0oMuZ9XyCoCJW9IvoiG3kNLO6vbVW24Tn7czleTfh2kb?=
 =?us-ascii?Q?AcNUIZXo/jNfQshGhm9Nh2FpajSTSLjEllGVYcrLn1+01Bi6LOsPYFZelcoM?=
 =?us-ascii?Q?8FPoOyt3/qzUOR98JcmGv2HK/wd4EakSXutXrO26niJP9+lTwOoHeHu+i0K+?=
 =?us-ascii?Q?uFJ8iAMVlxBurTbe+MWhuo30+qyi1DxMqWCR+GSj94dVyVVMHiYSsg/TiE2W?=
 =?us-ascii?Q?TeR7+1+5uYWc763+MZBYuWXuXYL2OJOT8X/Xmzze4IBN4AADx5pms2ywy7JT?=
 =?us-ascii?Q?8zFfSweBBvPNGTvVsaU33xtUNmI=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: 44d732ab-2f5f-4e2b-698e-08da74a010c9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 16:00:05.2977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7z18Xag6Jsy8AsyGUUhQERMC+vMYfF33x/72uGw/0k6I/0xPcENDyQZs0fRk8WreRUYmMCO6lpr/lc/JNdjitVyFHML3G0FNUNI+h2V+NxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR01MB7252
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Add bindings for the ADIN1110/2111 MAC-PHY/SWITCH.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 .../devicetree/bindings/net/adi,adin1110.yaml | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml

diff --git a/Documentation/devicetree/bindings/net/adi,adin1110.yaml b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
new file mode 100644
index 000000000000..b929b677f16a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
@@ -0,0 +1,82 @@
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
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 0
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
+        ethernet@0 {
+            compatible = "adi,adin2111";
+            reg = <0>;
+            spi-max-frequency = <24500000>;
+
+            adi,spi-crc;
+
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            interrupt-parent = <&gpio>;
+            interrupts = <25 IRQ_TYPE_LEVEL_LOW>;
+
+            local-mac-address = [ 00 11 22 33 44 55 ];
+        };
+    };
-- 
2.25.1

