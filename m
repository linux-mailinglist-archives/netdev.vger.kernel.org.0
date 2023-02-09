Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D5E69039F
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjBIJ1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjBIJ1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:27:49 -0500
Received: from mr85p00im-hyfv06021301.me.com (mr85p00im-hyfv06021301.me.com [17.58.23.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAEE5EF92
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1675934294; bh=fKfon97iRdA8hONSJw4rAYjTeMrB0lcLvBVxv7x5uFI=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=tXaCT+kUjCu4Ej8v/nGvOuhLZSG0/qu7/iJhwCHTuwRfwMw58kImGknThco7uD2mJ
         z/EFZYHIgFrgc89siFXz9evVW3+Ml8gLiabAVM60bJrGlV3zjxNp8y6IBLvZQEvwTO
         ajkU76tJaSjgSfAUeBZuiYjyEVOOoS3BXgQpVaiRsut6SqiCtMEG+VW0csqV0kkhzZ
         rzqhpb1IM6+JMDmom96VeaTAgG0PxnTEnC3Xnm1Yzv4OP+UM9ZaF/797iFXPePlQh1
         GxQ3YsJyvF2mbeeJCeyYwpPZVv/p7iNYsz1cSK0tySLhfMrN9E+t5QtWq3Scw7QBD7
         HIdycWis1SVhg==
Received: from localhost (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-hyfv06021301.me.com (Postfix) with ESMTPSA id CEB2D21512D0;
        Thu,  9 Feb 2023 09:18:13 +0000 (UTC)
From:   Alain Volmat <avolmat@me.com>
To:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-clk@vger.kernel.org, Alain Volmat <avolmat@me.com>
Subject: [PATCH 01/11] Documentation: arm: remove stih415/stih416 related entries
Date:   Thu,  9 Feb 2023 10:16:49 +0100
Message-Id: <20230209091659.1409-2-avolmat@me.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209091659.1409-1-avolmat@me.com>
References: <20230209091659.1409-1-avolmat@me.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: xV8W_Ts5GUg7FdbjkxVSEpo5WGNTiTsX
X-Proofpoint-ORIG-GUID: xV8W_Ts5GUg7FdbjkxVSEpo5WGNTiTsX
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.425,18.0.816,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-18=5F01:2022-01-14=5F01,2022-01-18=5F01,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 spamscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2302090088
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ST's STiH415 and STiH416 platforms support have been removed since
a long time already.  This commit updates the sti related documentation
overview to remove related entries and update the sti part to add
STiH407/STiH410 and STiH418 platforms which are still actively
supported.

Signed-off-by: Alain Volmat <avolmat@me.com>
---
 Documentation/arm/index.rst                |  2 --
 Documentation/arm/sti/overview.rst         | 10 +++-------
 Documentation/arm/sti/stih415-overview.rst | 14 --------------
 Documentation/arm/sti/stih416-overview.rst | 13 -------------
 4 files changed, 3 insertions(+), 36 deletions(-)
 delete mode 100644 Documentation/arm/sti/stih415-overview.rst
 delete mode 100644 Documentation/arm/sti/stih416-overview.rst

diff --git a/Documentation/arm/index.rst b/Documentation/arm/index.rst
index 8c636d4a061f..e70fc72ef136 100644
--- a/Documentation/arm/index.rst
+++ b/Documentation/arm/index.rst
@@ -70,11 +70,9 @@ SoC-specific documents
 
    spear/overview
 
-   sti/stih416-overview
    sti/stih407-overview
    sti/stih418-overview
    sti/overview
-   sti/stih415-overview
 
    vfp/release-notes
 
diff --git a/Documentation/arm/sti/overview.rst b/Documentation/arm/sti/overview.rst
index 70743617a74f..ae16aced800f 100644
--- a/Documentation/arm/sti/overview.rst
+++ b/Documentation/arm/sti/overview.rst
@@ -7,22 +7,18 @@ Introduction
 
   The ST Microelectronics Multimedia and Application Processors range of
   CortexA9 System-on-Chip are supported by the 'STi' platform of
-  ARM Linux. Currently STiH415, STiH416 SOCs are supported with both
-  B2000 and B2020 Reference boards.
+  ARM Linux. Currently STiH407, STiH410 and STiH418 are supported.
 
 
 configuration
 -------------
 
-  A generic configuration is provided for both STiH415/416, and can be used as the
-  default by::
-
-	make stih41x_defconfig
+  The configuration for the STi platform is supported via the multi_v7_defconfig.
 
 Layout
 ------
 
-  All the files for multiple machine families (STiH415, STiH416, and STiG125)
+  All the files for multiple machine families (STiH407, STiH410, and STiH418)
   are located in the platform code contained in arch/arm/mach-sti
 
   There is a generic board board-dt.c in the mach folder which support
diff --git a/Documentation/arm/sti/stih415-overview.rst b/Documentation/arm/sti/stih415-overview.rst
deleted file mode 100644
index b67452d610c4..000000000000
--- a/Documentation/arm/sti/stih415-overview.rst
+++ /dev/null
@@ -1,14 +0,0 @@
-================
-STiH415 Overview
-================
-
-Introduction
-------------
-
-    The STiH415 is the next generation of HD, AVC set-top box processors
-    for satellite, cable, terrestrial and IP-STB markets.
-
-    Features:
-
-    - ARM Cortex-A9 1.0 GHz, dual-core CPU
-    - SATA2x2,USB 2.0x3, PCIe, Gbit Ethernet MACx2
diff --git a/Documentation/arm/sti/stih416-overview.rst b/Documentation/arm/sti/stih416-overview.rst
deleted file mode 100644
index 93f17d74d8db..000000000000
--- a/Documentation/arm/sti/stih416-overview.rst
+++ /dev/null
@@ -1,13 +0,0 @@
-================
-STiH416 Overview
-================
-
-Introduction
-------------
-
-    The STiH416 is the next generation of HD, AVC set-top box processors
-    for satellite, cable, terrestrial and IP-STB markets.
-
-    Features
-    - ARM Cortex-A9 1.2 GHz dual core CPU
-    - SATA2x2,USB 2.0x3, PCIe, Gbit Ethernet MACx2
-- 
2.34.1

