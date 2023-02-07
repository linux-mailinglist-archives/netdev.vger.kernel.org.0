Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4599068D972
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbjBGNfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjBGNfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:35:14 -0500
Received: from mxout2.routing.net (mxout2.routing.net [IPv6:2a03:2900:1:a::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3615E1E5F2;
        Tue,  7 Feb 2023 05:35:13 -0800 (PST)
Received: from mxbox4.masterlogin.de (unknown [192.168.10.79])
        by mxout2.routing.net (Postfix) with ESMTP id 192C36160D;
        Tue,  7 Feb 2023 13:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1675776911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+qbv0n0dKcwpBoP7NvIb165bwtTu0lYmwjiFWAV1Qec=;
        b=yNgHg9+vnJZKImB57vUO5nu22PU4EMoYJ/Tt69w/2+hT9i9K+J7Du5ra0C7/p2pWScXM6a
        HC/i252pqdVyr7hfGnI34RmllWkXANxUIiBkmItXPPHtefEcBw6T7EVmuMEWdkjtKvYNQR
        ehxl75wS+cpaem5FsPx7BNed4k64aHk=
Received: from frank-G5.. (fttx-pool-217.61.159.155.bambit.de [217.61.159.155])
        by mxbox4.masterlogin.de (Postfix) with ESMTPSA id B407180D97;
        Tue,  7 Feb 2023 13:35:09 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] dt-bindings: mt76: add active-low property for led
Date:   Tue,  7 Feb 2023 14:35:04 +0100
Message-Id: <20230207133504.21826-1-linux@fw-web.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: fcc6f107-9e6a-4587-a7ad-a6af974cf1bc
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

LEDs can be in low-active mode, driver already supports it, but
documentation is missing. Add documentation for the dt property.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
v2:
- change commit message to mention that driver already support this
---
 .../devicetree/bindings/net/wireless/mediatek,mt76.yaml      | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
index f0c78f994491..212508672979 100644
--- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
@@ -112,6 +112,11 @@ properties:
     $ref: /schemas/leds/common.yaml#
     additionalProperties: false
     properties:
+      led-active-low:
+        description:
+          LED is enabled with ground signal.
+        type: boolean
+
       led-sources:
         maxItems: 1
 
-- 
2.34.1

