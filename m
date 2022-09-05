Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3AC25AD5DD
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 17:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238680AbiIEPJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 11:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238414AbiIEPJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 11:09:16 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2049.outbound.protection.outlook.com [40.107.20.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49218578BA;
        Mon,  5 Sep 2022 08:09:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOlEfPA3+M5ErH2TTjZL+H7Ij+X8PoPozVhezxRKOwRftfizEPCsMkdMQhQu0AvU1r/EaCVl4Wt5evW3CAFirz+HteENU79ryWO385xYyHZ/cHRo8b2E6+2cU0pLkGIq5Ncal0BlcrOkFEbcXgShlx4K2A0gV+au3y5tkRz3oj7NnGv5/ILyVOskEt7TejW4omx7wRuKVSFW3d/Vr3TzNlX4Ge9KHBtxgs3zeLPWZP7qaIVJnJ0PMRAw0aRgW1/q9CvLLfmpFS47v6Gc2t3PsMcMN/unHeaxolK3rLqlcuIolalR5PfEVMQolkNb4uyE18WUW5AN77Wn72J0eMS8cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5Xy1SP/4vVsm2Wx/rag6u83ZWyeEmTFEUaMEib9N/M=;
 b=ixKxdXSs7tGNVtxCqCOsH8tT2x7T0zOfwWhpPIpnP6hugSFEyoC4x8OVOG0dkA+1i5b1UZ1MdSiLsuMWk9Axolk43ZLX2VD8CC7myLv1RRwiZShJjIDc38rZ8rRJRWIZijskNxSqu5tsXL8mqE+MnfcZv03zHy/xLnYbNoVHGWRrwXiiIAq+MNBE7+2ZhdpOtakukNiOORGce4BhMzBqOUXBKZQhT8whYs5Q+wI+jYVu8yUNt2qYv3CDvOhBYuVySbVKiNiSsevStABpRcc5IJKRfk77P02CtrRNRhtaS3dHU8quJb75bMYTpaRUFTUWopXmh8QoVUNLeUFR53rb+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11) by DU2PR01MB8655.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:2fa::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Mon, 5 Sep
 2022 15:09:02 +0000
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::792e:fa13:2b7e:599]) by
 VI1PR0102MB3166.eurprd01.prod.exchangelabs.com ([fe80::792e:fa13:2b7e:599%7])
 with mapi id 15.20.5588.012; Mon, 5 Sep 2022 15:09:02 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v6 3/3] dt-bindings: net: adin1110: Add docs
Date:   Mon,  5 Sep 2022 18:08:31 +0300
Message-Id: <20220905150831.26554-4-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220905150831.26554-1-andrei.tachici@stud.acs.upb.ro>
References: <20220905150831.26554-1-andrei.tachici@stud.acs.upb.ro>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR0801CA0083.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::27) To VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22fcc361-1f28-49ea-a908-08da8f50913c
X-MS-TrafficTypeDiagnostic: DU2PR01MB8655:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qx+Kz/FwtXSQFfOeZ44edmvkYMz4CSd0bs4KkUNWoc5j2g9DkzgEnXKj0FDs8qvDdVEcE0QAcwuof3OaUx4kFyx6r1cXNxKexFmPQECfOFV6tsWlLSJWlqMVT6vkEn8pFzKcw83Mge9bXDJiSzDlq0d/iK7OSB2lglWfCj7LZ4lPqweJY1zspdiVbAVhKQDX+HAsMmDH4p6ogVuzHYiAI/IbKtGvswDcw0vTr19Wsd4PWSgKw9WGWVUIjMxl+lG9qATeSpgyW91D+818/gzt1EOcFzTNHdn7ulLR6jaS9Rap7VR4Ip0ySUWxfIZPvx0XpGGZZhsEFvv1wuisRkaYJewLlGVx3znpq1cAnYoQx9YYjdZqoGSF8lbZnBHBM5o+j3GK7fU66v3XGpwQWC5Ba1AFNeAPrzWSm6WOI9pgd+KztPTO72GkfjCRhvLxCfc2olEK/cf685PhbEB5cjSx5kScxrBkjGQT9AISz5lems6omCWUZ8/f9Oh7UNdQd1opPxDclgkA3ZwXrKzMLWm1KCjmb1UbGywyV9krLZAVOKTNya3SvMCnWQee5me+SdGk5q1oub4N/VKqg9mukhs2WT8p2zOtPOXEia1MHqOOkVK6VgYuPxkWFNFt2e4niyhgcq2iuOAsLdiWq67LPaN2P8l/rpO0Hmw89NrGA4gWTqgfpa7UUXIMHvaZHOFjI33eX5cwPxuS2xwXDH4/wYkRNgoAs7M2rXnsTH/ML8ghO5vCHUlnS9Pird0cHB7paE4bSNn+4GlBBT1wIJD1DeTwkYfWWd5futpq/GxTD/gLRtk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3166.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(346002)(376002)(366004)(396003)(66556008)(6486002)(966005)(66476007)(2906002)(4326008)(66946007)(316002)(478600001)(786003)(6916009)(5660300002)(41320700001)(8936002)(7416002)(8676002)(83380400001)(38350700002)(86362001)(38100700002)(52116002)(6506007)(6666004)(9686003)(1076003)(26005)(41300700001)(6512007)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sj4Xw/zSOrQQArjAWuICLpM7038acwAnujSqu4WJASOpnuRe/J/6IQbVq4Bq?=
 =?us-ascii?Q?8k4j5tzM6igfWfEFd4bzIbI3R4sKz6H89xUIQxKBipvqyC/wdVTe81bg+TS9?=
 =?us-ascii?Q?gMKvynInm0edjWCsR/UV74nmTJXk2D7erPybtLaU06eElNjQioe7drlLpy0/?=
 =?us-ascii?Q?j4JrwDoJ6YOsVAQwUIqMyWy8bB7qKcsIL3eOrBDtuzvU31nn64FMwkwkIuPC?=
 =?us-ascii?Q?Tvkg5Jdjqly89BWXVyEQCs72P7UHgzLnBJRIf5bjfWyNnPdqmmd7GVIAKZyU?=
 =?us-ascii?Q?a099ve9gycjVew9SS7NvqZzGiqTPQAwNnzdD4OA/le22c4CRXYI/BINmF8p9?=
 =?us-ascii?Q?XYD3Hdw72HuXw6VJdzKbov6l0KgtDix2/zlO0O6ocK99IOX66N67HMIF4leC?=
 =?us-ascii?Q?/cTs21mFgwwqO/hqyNQO+Yl3VmphJ5wrwQejuHjezQINFrReSDT4N2p3wdpA?=
 =?us-ascii?Q?iiI+v6oVA+goJrCmfEYVaN67OAe+WrPUf0CxNpariFUwSSpd9mdbKzCFI3fx?=
 =?us-ascii?Q?ywlE/LiexJuJDF7rFpQpo8DZUqCVcyVtevVUswWbmM89NF8xnI/45epGugGU?=
 =?us-ascii?Q?NN6/YYCTgjaBqNue2p7tXji0GFHRKq1aXT+xYxVEIyDM8rk1dVOVnrA/7mYJ?=
 =?us-ascii?Q?buG3Wwin5SNFiBcDJqN24g3qckJv/Twu7IyEGEdiawLN9kw3Wn8k8AnxsR1T?=
 =?us-ascii?Q?09Ld2XOvRVYxNwJNdExhrUrXilzSFB3+GPi/jYOHIKoTXm3IfgRBTm+Rh1eM?=
 =?us-ascii?Q?gvXvz1Bz7qXdiMvGj5rS/cDTbvrN2zJudAR6IhseVAKB8BOYScD321pAty+Z?=
 =?us-ascii?Q?pPcDVTuXlE7GEWfcQOSrP62OMGv/OP9Q/c0t8YfSUMXU071GekoBvf2F/K3X?=
 =?us-ascii?Q?GFca7zu5JKasUrLyA+tYXcsI5cfst1y2cF0nc5o0PRZCGgFgX1VEeDQc6Cx5?=
 =?us-ascii?Q?w5MrKmbzJIzet5xCC1UbVaJOAlREnJaHk0IZ6T6Byhj2aSrUFfIoXVCHqzlX?=
 =?us-ascii?Q?dHehh5WHazNkGZxqHM4k6pwFYx0qBCQeF3nq+ggvUDlATikQ3xTvKwgKIYlj?=
 =?us-ascii?Q?6es5u4qkdIEpxBCJAoGa066q3gUgwyetycATVRgT3fq+c+o1m2Ua2RCno1G4?=
 =?us-ascii?Q?FFoAWes9Ghh2vgVjkgumv9XIr2CBoO7q18SisDLb2iTPYabW2xoMTvzNTEbU?=
 =?us-ascii?Q?4mnjkmeHlLkJKyi+a18oDEnQae6Yr20CCmOZMcoVv7d9hb65IlFu3yQceSwQ?=
 =?us-ascii?Q?M6anGXkHFU7/FgSnUywsRcr0w+ZdFkCYBgs4foXibjNmDg0SLZD0WClTn5bz?=
 =?us-ascii?Q?r64HPi14LecDfV2u3uNWFwyXo5zkHcodIohdVpkcxgwjUGAXwMWku12L31au?=
 =?us-ascii?Q?yYH76rTXIwHp7U3Sx1zjbprgGXVZcQKjJZB6OOXyhIzmemEEJi1x3zcGj5lG?=
 =?us-ascii?Q?oRo/IeE1sWcrJSzqNDqbFK8uJBpfS9EO6qbgUSgmeFRT3HkLwO/KlI3Ylch0?=
 =?us-ascii?Q?mAYWypqMSWa9z19oCjtgEM7m6gaLtCxHve23kmFl3PhyRlB7uFC1IE/3bKqm?=
 =?us-ascii?Q?bdblXh7clyy7Syj/WxJ8SeOdODC51NCTZo3Oggb6ter3JSVRl46gKoLQ9K/h?=
 =?us-ascii?Q?cIpeCLgHiOKudQvOld0Huws=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: 22fcc361-1f28-49ea-a908-08da8f50913c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 15:09:02.5829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: skPGUQo4+lNs8LwX4buD3FD+/4nt58T4KV+W9ygGnU/ccJB4DLyQWVOTaCgBpCFcujmJo6cQH9MIgkYmYZ+4Jeg+5fErPYlPnSuvvz3rMTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR01MB8655
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

