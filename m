Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CDE690369
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjBIJUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjBIJTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:19:41 -0500
Received: from mr85p00im-ztdg06021101.me.com (mr85p00im-ztdg06021101.me.com [17.58.23.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F39611C3
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1675934355; bh=XKcEoiU2gkIsuf8FhslnaifLYaGCRhQ1TwjiGMV9VfI=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=CG5JwAgrBupVZ01JDGld5KaTSiptcgPQB1En7wRekjQeEDQNzSi6kGY+ANBrkLzXK
         RvxLX2w5ClVXMLSpH2jBRCmF04WwIq7Vg7rDaLtXRyw/mvA6T1F1/rO3j6IjwW3zgL
         BSEHWgA7lw8XlrshKdX2taOdqDYYd2wryuxhNuvwaZZ4NwkCSHDXYel0t5T3el6355
         STgoy0w76an0YzoAKdJrOZMeg923Gz5HtBzArEqDQrWGVgpV+rtzSWiTQj30/g1fUu
         RnMRKaoJgCulSIBH8waq+KIR+4z9SeLBIf/67b6ANcIM4TKUweBvWRAEGE2mZO6+tT
         LJyolwwr70BDQ==
Received: from localhost (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-ztdg06021101.me.com (Postfix) with ESMTPSA id 08FBA81141;
        Thu,  9 Feb 2023 09:19:15 +0000 (UTC)
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
Subject: [PATCH 10/11] dt-bindings: clock: remove stih416 bindings
Date:   Thu,  9 Feb 2023 10:16:58 +0100
Message-Id: <20230209091659.1409-11-avolmat@me.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209091659.1409-1-avolmat@me.com>
References: <20230209091659.1409-1-avolmat@me.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: e1PY_4y3to8Pai-Bcf2MWlipBBW67qqk
X-Proofpoint-GUID: e1PY_4y3to8Pai-Bcf2MWlipBBW67qqk
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.425,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-14=5F01:2022-01-14=5F01,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 clxscore=1015 spamscore=0 adultscore=0 phishscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=954 classifier=spam adjust=0 reason=mlx scancount=1
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

Remove the stih416 clock dt-bindings since this platform is no
more supported.

Signed-off-by: Alain Volmat <avolmat@me.com>
---
 include/dt-bindings/clock/stih416-clks.h | 17 -----------------
 1 file changed, 17 deletions(-)
 delete mode 100644 include/dt-bindings/clock/stih416-clks.h

diff --git a/include/dt-bindings/clock/stih416-clks.h b/include/dt-bindings/clock/stih416-clks.h
deleted file mode 100644
index 74302278024e..000000000000
--- a/include/dt-bindings/clock/stih416-clks.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * This header provides constants clk index STMicroelectronics
- * STiH416 SoC.
- */
-#ifndef _CLK_STIH416
-#define _CLK_STIH416
-
-/* CLOCKGEN A0 */
-#define CLK_ICN_REG		0
-#define CLK_ETH1_PHY		4
-
-/* CLOCKGEN A1 */
-#define CLK_ICN_IF_2		0
-#define CLK_GMAC0_PHY		3
-
-#endif
-- 
2.34.1

