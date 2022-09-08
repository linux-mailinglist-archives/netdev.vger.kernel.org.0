Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCA55B26CC
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 21:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiIHTfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 15:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiIHTfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 15:35:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BC132EF8;
        Thu,  8 Sep 2022 12:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D59B2B82236;
        Thu,  8 Sep 2022 19:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDD2C433D6;
        Thu,  8 Sep 2022 19:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662665708;
        bh=mzm5L4CAPDFUvFpZmOoeFfGUUflQPsc++RkAX676KYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UpThxICq2otDlIIYFawQj8gPWRjBrQ5CS2MOSsvhqNQ33MpTBSPvEjcwUuoJSzGZt
         kKIiRiIKu7k2q1nhbpWD0mHPs71LTY1pKityb2W6tUTR89Bp9SCSgUy/3Ho+aFTHEJ
         tP7rYVVnld2MqbXjXrEpO4+LlUtdAXddu5UpOE9fqMpBCLoiheAgbUM2N+KStT4c6/
         11wuoXWEH1JI8KaZ0BDTUYyIk8MYShCtNGIfzgb4VZiLIWsOXlSDu9J45j6mBem7Yy
         9B4rRNEbWfmlaESOZ9eW5IE85nf07XjhlhewAnFodoZNHfpSf5IlTvE1X+Cn7SOVLf
         1PMtrBTMaYN+Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org
Subject: [PATCH net-next 02/12] dt-bindings: net: mediatek: add WED binding for MT7986 eth driver
Date:   Thu,  8 Sep 2022 21:33:36 +0200
Message-Id: <e8e2e1134fde632b7f6aaf9d96feab471385f84c.1662661555.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1662661555.git.lorenzo@kernel.org>
References: <cover.1662661555.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the binding for the Wireless Ethernet Dispatch core on the
MT7986 ethernet driver

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 Documentation/devicetree/bindings/net/mediatek,net.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
index f5564ecddb62..0116f100ef19 100644
--- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
@@ -238,6 +238,15 @@ allOf:
           minItems: 2
           maxItems: 2
 
+        mediatek,wed:
+          $ref: /schemas/types.yaml#/definitions/phandle-array
+          minItems: 2
+          maxItems: 2
+          items:
+            maxItems: 1
+          description:
+            List of phandles to wireless ethernet dispatch nodes.
+
 patternProperties:
   "^mac@[0-1]$":
     type: object
-- 
2.37.3

