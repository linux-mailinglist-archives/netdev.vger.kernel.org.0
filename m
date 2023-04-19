Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4449D6E81A5
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 21:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjDSTFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 15:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjDSTEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 15:04:55 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAE46A4E;
        Wed, 19 Apr 2023 12:04:50 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ppD6n-0003lm-07;
        Wed, 19 Apr 2023 21:04:49 +0200
Date:   Wed, 19 Apr 2023 20:04:43 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Subject: [PATCH net-next 1/2] dt-bindings: net: mediatek: add WED RX binding
 for MT7981 eth driver
Message-ID: <e970078a937c39067d5733ddafb64d0eb56ac474.1681930898.git.daniel@makrotopia.org>
References: <cover.1681930898.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1681930898.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible string for mediatek,mt7981-wed as MT7981 also supports
RX WED just like MT7986, but needs a different firmware file.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 .../devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml    | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
index 5c223cb063d48..2c5e04c9adcc8 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
@@ -21,6 +21,7 @@ properties:
       - enum:
           - mediatek,mt7622-wed
           - mediatek,mt7986-wed
+          - mediatek,mt7981-wed
       - const: syscon
 
   reg:
-- 
2.40.0

