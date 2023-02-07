Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C7A68D4A0
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjBGKmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjBGKmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:42:53 -0500
X-Greylist: delayed 593 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Feb 2023 02:42:18 PST
Received: from mxout3.routing.net (mxout3.routing.net [IPv6:2a03:2900:1:a::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909AA7A97;
        Tue,  7 Feb 2023 02:42:15 -0800 (PST)
Received: from mxbulk.masterlogin.de (unknown [192.168.10.85])
        by mxout3.routing.net (Postfix) with ESMTP id 546166003B;
        Tue,  7 Feb 2023 10:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1675765518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uj3s91N95T2F3BwhUboKahqX3DOnIiHlbQ37Lz6ta+g=;
        b=JOp9XjaFJmuJYY2z436g99uQ5iccj+m5ZbLs0A6C0TTT9Y72j1wYnqHqrmi1dG2o+u74Yi
        JqipeNbljDl8LdBejFBhwpLWcJ4ABa99YWUkEn34ncqn6/T5E3L4o9yonq9DmsW6OAJYsx
        fLNRy2vea1KYTeErgeP4iGjBCVXeeAs=
Received: from frank-G5.. (fttx-pool-217.61.159.155.bambit.de [217.61.159.155])
        by mxbulk.masterlogin.de (Postfix) with ESMTPSA id B6FA31226E8;
        Tue,  7 Feb 2023 10:25:17 +0000 (UTC)
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
Subject: [PATCH] dt-bindings: mt76: add active-low property to led
Date:   Tue,  7 Feb 2023 11:25:01 +0100
Message-Id: <20230207102501.11418-1-linux@fw-web.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

LEDs can be in low-active mode, so add dt property for it.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
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

