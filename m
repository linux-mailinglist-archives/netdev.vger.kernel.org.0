Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9EA5AE269
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiIFIZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239148AbiIFIWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:22:54 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80072.outbound.protection.outlook.com [40.107.8.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303C872FFF;
        Tue,  6 Sep 2022 01:22:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOnjoW+Ftc86DgwYiOxd1UHBXDx3SOjtW1uscx3kZrrKp2xicE4UGzSHh3BjyAAknSeQCWm2y8I9LghqJJJQ5a4esdki+phrN2TVXX1F3EjogkOqA02NQbqwrnqA0zY/OvaNwON5ihEgdwE3cD0EdY5jYdtScVrwcziryUgFSGTm0GrqGHZ+Mhe3SZUEQZRvB8N+nKwuMYHh3xAWn6sEQgW9/KEcXgDg38GAOH3b9ar1QLJ0XHRrSMXUvaCYnaHZQVvOw4R+8mPg1nmouJ/q5bd9RMSQLRCbFD2HafiopBLaUbFUeXTo0dqQZiZUYv6VYukTZIabKq/p//cwa6MwfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5Xy1SP/4vVsm2Wx/rag6u83ZWyeEmTFEUaMEib9N/M=;
 b=KzR3UddTM5nuPSZ/9yYnHvRhBTmH4z0KMA02gx0X9CCsTTXVR6iNfiGbfI8lUgSUETly7+p7UqjmJXip8qY3pO0cGUQiI47EOSXePIUw9HSorWkFAPiN45GSlE6NFaFk4SfPtXkSTRf0ZdBCXe9qnxANqt8n+U4RwO4MdY9D5YRvhnnIYo01AhpxU+blqOO0viEe9CXtq2ZNUltG8fg0/tBNn1aryamAkBtxF2Egpuw5HSFqNoIGSxPachBRoE9Fssm+A+qltwv5TjXfmfT01K7OsUJ+xE9z+vOrYh2rA/p08xotk/CIO7HMIk9rTxI/Bxd5THRHqLoKQxGmeE/1Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11) by DU0PR01MB8877.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:350::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Tue, 6 Sep
 2022 08:22:43 +0000
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::792e:fa13:2b7e:599]) by
 VI1PR0102MB3166.eurprd01.prod.exchangelabs.com ([fe80::792e:fa13:2b7e:599%7])
 with mapi id 15.20.5588.012; Tue, 6 Sep 2022 08:22:43 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v7 3/3] dt-bindings: net: adin1110: Add docs
Date:   Tue,  6 Sep 2022 11:22:03 +0300
Message-Id: <20220906082203.19572-4-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906082203.19572-1-andrei.tachici@stud.acs.upb.ro>
References: <20220906082203.19572-1-andrei.tachici@stud.acs.upb.ro>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR08CA0231.eurprd08.prod.outlook.com
 (2603:10a6:802:15::40) To VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f46c27f-1418-41ca-8e98-08da8fe0f896
X-MS-TrafficTypeDiagnostic: DU0PR01MB8877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hljyCOjJpJ//iNSP2Cb4bj6YdM3KmusmRma6R+Y4W8m3CzgQHL9vuGhZkCPxg1o43ozlSzF+YjQ0Gg4LYNbZB5gzfbkmZclD6C2UTU7qkvuqUdtGsVq6PNEhvze8j/0WwGGbGPQWiOn4uJjQuSuJvcCFIQjNrDLCVMod1zL70byekNyag/j0McfuYdshJkchw0g3fNHwQBalXkxhjJ6oPH2RHUFv81yzB9g0P0akggiE60XFNqa/EJiQwT91SmEkeIVyvXkhJrf2jVHfHQIy8nVuBG3qsxpmcqgmUZAodHLmKLuAOjitUxueUQYIA5rEJsHqRPz7BaiBI4Rysx+vGbZzDdY6FWvfe6THV2lw/I8nxhwPpN1gVCyzDZ/3i7tLTtbjQI/D3nYk2TeHrAtnQN6AEj6dhOPOZ3Nz1b3qfx0gPCNETneyn+zmFJYxvkQiAan/UUDzIKajreNOY9vcXCtyAFFXFfAao6/31VSm9PmZvCQ/887K3jtUF1dt8dELWAuQcjbPvQ6WWGrDpzDd+fQxZoXrBewB1IbpkQ8+WSkYVSA7zZxZIc8Mirhui3J5lNxY/Jyn9etqzlKKbhLx3nNUCBMDKcHhxEaB49HSTss2kbquobCo6c0cSVpAC4F78uTpk0TtPBEsSCJUiArYSHTHt8dJxOkVMzfGhfx3ztnuPbY3T8fmspmTVq0GmlkjYGhamrhI7gHTnvkkoFYGWuwbW0szwNCL/HpdobG70DiNhZqk65TdzDy4a9kgbCpr8cqHBB7To0bUneXmP8CzCQO72UsQjU6cRVcfrcUhg0I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3166.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(346002)(366004)(376002)(396003)(5660300002)(2906002)(66476007)(8676002)(4326008)(8936002)(66946007)(66556008)(316002)(6916009)(786003)(478600001)(7416002)(966005)(6486002)(1076003)(9686003)(6512007)(41320700001)(6506007)(26005)(52116002)(2616005)(83380400001)(186003)(6666004)(41300700001)(86362001)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P+KpH/T2MnRBjM6MmAoIjwXYg1sWImmJxpAAf+aC/HsGWrAU7MZE5xtvTeoz?=
 =?us-ascii?Q?qwNCvHS6+UdW/sp9XZL700a6Dti0q01A2cPrpXJJ4b0VGCY8czXL3vcn6kaq?=
 =?us-ascii?Q?UmRHalOHPY5lpnO1bbKTyETJtyy/cLUOd6umrbLhifr8OOuYKF4IBA2J8K7H?=
 =?us-ascii?Q?rUtIMQJEG9UgBIh5+mnDUl31flyxK6LFtFl/aRSasNeD6DS1L8vlQ3g2ZOY5?=
 =?us-ascii?Q?tAHDUmPqjsKO7OPlSv1Ryy0Eqmr3b7biVtujQU/Jh11bhhcWlkfIoKobXyNu?=
 =?us-ascii?Q?a3HpRMhJR3GZDgzEGCGYv86d2W8tKHsxRxlbC47c13Fd4z6IiucfMLP7zKWE?=
 =?us-ascii?Q?9WxggdeFB1xOCjlu8/EsjlwJVhRLm4FLacwZZ/8yOOIWl22A75NhlDVX2Wh1?=
 =?us-ascii?Q?hLSpTK5o2CpmLKDejgfrWtykayP9QOviYOV3wUFofJbqDDrhcAYycGg4C3nw?=
 =?us-ascii?Q?MY8qv6BUlhdtNtOnJqrQ471qwfxYefUHGWXxAn17OVwGEztD+TkHEM0cenSN?=
 =?us-ascii?Q?sc8+6amcEhGcqFebNsGbwFRYVZXrAggn3wU+kFQVl3iVtdS/bFuMfXLCf+Zt?=
 =?us-ascii?Q?CMVSL1QEx3+dNAjb6pcn8N4+DQDrWmCIcqxBqMj1qSp1F4s3++QbnFluX1mf?=
 =?us-ascii?Q?2kB6Ng1DLKb4jMYJcBPSTWgwJ1zE6M91BuZQH/up6I4sxHP9VO4V15TqKDOU?=
 =?us-ascii?Q?IpuKOR+jlqUqrugHCG5oi3ti47JwSyzo67CDc01laxifUCv5nygv1mgb7Wfv?=
 =?us-ascii?Q?nhLGV4kSV4EJFkaTGfoQ+S1FAMgdcSlFNxb9vlN0QUXAKOvqJ41p3nJ1Mftt?=
 =?us-ascii?Q?CB0pZhHON1u01trPMuy32LhrCsk9JAakJ3jQ3v8mIFolO+IO6G/1Y3g+gwbd?=
 =?us-ascii?Q?YyKMJdHb7Q4f35kPh16Xp4Xn06JUOge8MXPEQhxjH+A9MDHTZO62N4xbs4iw?=
 =?us-ascii?Q?/uQWjMTpU1LMmQBwbjohuckXc1kBwqGB8FmYwdlawNfZqtx0WuhKRiQA4W9Y?=
 =?us-ascii?Q?1mDCmh1YuDvba421C8ENdvor7rRknKew5IdaV/6xzJfJdbRgGPqzvdVkaT0X?=
 =?us-ascii?Q?+hMFIbP6ddioKAOIJg/5ihLRQjCiuXZHJjYxCzcYhdg1efFr0o55PZdqlCYq?=
 =?us-ascii?Q?5aJSQ2Ll0pGGRxgHMsoNFmbpkEZd/DMmHjrxRr3KiwBIQFiT/TZfrQ6benFv?=
 =?us-ascii?Q?5eq4Bq+Wo+HV8Dk51zsHtExTmLfLLhkBO8UqhY5meeLngNG7V7MSljNh9Bfs?=
 =?us-ascii?Q?iBEJJJ8HwuOnj6zWOoPS4GuUkXMfJJ6hIA7iAfTmBktZ6Ts0vtTxft18WeMI?=
 =?us-ascii?Q?fhxxhxONxH89RDt2AyK/vqp+1A+5LoxdszGUSnhNB8f1mmEOfwMGbE4PexLA?=
 =?us-ascii?Q?UpZOeIxf7MvYbk4aBYhPafCDNuVeea2OCx6bVuxH8nBBpW1X43cR3PkM5l9x?=
 =?us-ascii?Q?wzU6heP55ec8kHPuceuWufyjtLFclSOA8JSfFJMfa+EP1s76ylJFGzO1fv4+?=
 =?us-ascii?Q?uNKrXLHJ/jPS/ntCRjwnXN0UCN9hBjB45eQpUxRNQCEKlf8ThjDd7lB5WQxn?=
 =?us-ascii?Q?bHZoF8xxIoKYGVpCdRjBHs2Lp0Vo+wSAdjqDACr+U8GCunXEAy14BDjH/xSZ?=
 =?us-ascii?Q?Vb0p82054TPAXzKNk9YToJc=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f46c27f-1418-41ca-8e98-08da8fe0f896
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 08:22:43.4596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RU6IyXtoMLl6rRmA10A0lBgAWS+2+51LcXO6Bz0EUPJ4sWULNKIs3YBlQOJHjJgRv+NgFK3RWLz1dEL2oDzwNfcWaDBRtpCErR+vP4hYong=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR01MB8877
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

