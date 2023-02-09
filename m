Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F0869034E
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjBIJTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjBIJTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:19:21 -0500
Received: from mr85p00im-zteg06021901.me.com (mr85p00im-zteg06021901.me.com [17.58.23.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D743F11EA8
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1675934349; bh=DUltBeSQib27mTpQ0LQ3TLKQqhLhZZMnbOjDd3/GZrM=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=QEtNx70FnVYayIvHdFkNZl7jGNeKYED0YmFIJ4quODIv6bGV5uRnzHVVx8t761gKt
         nbif4MjZtu2au4Uhvou5uKcMTRfQEhaOHeJK2hrWKbzfe7OkQzXhKoIC9W/+g0cY4M
         XfeDoP+GMWaeeY0Wo0hWXKaji64lz+1eE50uennTK3XSQu3MZbg9UjfsSFfMsCShAk
         wTKlpIm3AgGyNkjosWUCy1A8FPaB/R74EQhSWg8ftA7uVHVnCjfFMXaSHSp4QC0dZB
         xTfLKV+H6L3SKllSJ9EdG4UXmtbCABWiSCOsED/L012ok4mReqnYC2icJ341mJhdZ/
         G3H7rRo/WRwwg==
Received: from localhost (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-zteg06021901.me.com (Postfix) with ESMTPSA id 5222B740F86;
        Thu,  9 Feb 2023 09:19:08 +0000 (UTC)
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
Subject: [PATCH 08/11] dt-bindings: net: dwmac: sti: remove stih415/sti416/stid127
Date:   Thu,  9 Feb 2023 10:16:56 +0100
Message-Id: <20230209091659.1409-9-avolmat@me.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209091659.1409-1-avolmat@me.com>
References: <20230209091659.1409-1-avolmat@me.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: whstFxbSkOc06pbJYDNEpWvhfqS-wG34
X-Proofpoint-GUID: whstFxbSkOc06pbJYDNEpWvhfqS-wG34
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
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

Remove compatible for stih415/stih416 and stid127 which are
no more supported.

Signed-off-by: Alain Volmat <avolmat@me.com>
---
 Documentation/devicetree/bindings/net/sti-dwmac.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/sti-dwmac.txt b/Documentation/devicetree/bindings/net/sti-dwmac.txt
index 062c5174add3..42cd075456ab 100644
--- a/Documentation/devicetree/bindings/net/sti-dwmac.txt
+++ b/Documentation/devicetree/bindings/net/sti-dwmac.txt
@@ -7,8 +7,7 @@ and what is needed on STi platforms to program the stmmac glue logic.
 The device node has following properties.
 
 Required properties:
- - compatible	: Can be "st,stih415-dwmac", "st,stih416-dwmac",
-   "st,stih407-dwmac", "st,stid127-dwmac".
+ - compatible	: "st,stih407-dwmac"
  - st,syscon : Should be phandle/offset pair. The phandle to the syscon node which
    encompases the glue register, and the offset of the control register.
  - st,gmac_en: this is to enable the gmac into a dedicated sysctl control
-- 
2.34.1

