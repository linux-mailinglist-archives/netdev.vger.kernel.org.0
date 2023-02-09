Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5610A690333
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjBIJT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjBIJTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:19:12 -0500
Received: from mr85p00im-zteg06022001.me.com (mr85p00im-zteg06022001.me.com [17.58.23.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FD161851
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1675934338; bh=S91TVxwJ6JLM4iiw8Hh3bJf1VOjeGLK1M2nvPhvifOk=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=C/qW3M/kXa6D61s2IQ2SNYsC2Qjns0j83s36Y6UZe9CxMF+DR4kb6SdV8wipe4WqE
         mO0UYbUaLnWpt3c0p7YkzqPUsmXTxRu9eY/ezttz9WH+iES6ed1pQHFxbfHNRb2j0r
         Z5Ma8rc/6ITzDnDG+ioDgbv8wJs1Mi1mj8+VcxiXKU8lSH+zzB+6U/bWVd6BBCHF2n
         C+20L+hFcbnQ2MtDb5Zb8eGJFBTIh92U/acaHg6W03jW76dN6xVUd3QW1qVbSbCcja
         naLZdj1fh5Epy+hJCMfbvsz4xhWt6TrmtmF2FFPZn9sUehGYzfSOtwZ9K8AsKqfWFr
         HLPZ01NoOjw7w==
Received: from localhost (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-zteg06022001.me.com (Postfix) with ESMTPSA id 2B09680217A;
        Thu,  9 Feb 2023 09:18:57 +0000 (UTC)
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
Subject: [PATCH 05/11] dt-bindings: arm: sti: remove bindings for stih415 and stih416
Date:   Thu,  9 Feb 2023 10:16:53 +0100
Message-Id: <20230209091659.1409-6-avolmat@me.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209091659.1409-1-avolmat@me.com>
References: <20230209091659.1409-1-avolmat@me.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: UU4yCoGHveEGHB4tnWOexA9q8eTTOfp1
X-Proofpoint-ORIG-GUID: UU4yCoGHveEGHB4tnWOexA9q8eTTOfp1
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=980
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
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

STiH415 and STiH416 platforms are no more supported hence remove
the bindings for those two platforms.

Signed-off-by: Alain Volmat <avolmat@me.com>
---
 Documentation/devicetree/bindings/arm/sti.yaml | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/sti.yaml b/Documentation/devicetree/bindings/arm/sti.yaml
index 3ca054c64377..a2822f4d60e7 100644
--- a/Documentation/devicetree/bindings/arm/sti.yaml
+++ b/Documentation/devicetree/bindings/arm/sti.yaml
@@ -15,8 +15,6 @@ properties:
   compatible:
     items:
       - enum:
-          - st,stih415
-          - st,stih416
           - st,stih407
           - st,stih410
           - st,stih418
-- 
2.34.1

