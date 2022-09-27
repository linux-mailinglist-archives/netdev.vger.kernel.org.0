Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24D65ECD80
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiI0T7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbiI0T65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:58:57 -0400
Received: from mx08lb.world4you.com (mx08lb.world4you.com [81.19.149.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD101CD69D;
        Tue, 27 Sep 2022 12:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CL09Htm5ST3lpVwSIhlyBg2QCzK4B4EGlDzGo91v2vE=; b=uWT6K+x0Z/4jw6wlf11KGa7Gg9
        KJRXgOTXshn+2G3/pO2rr3ag1kzCZUZrD716avF/K+t3ITCEwh0U2W0StSvLWpKDOW03OhDeNABIS
        7dsGfN7rcw9Wath9fUaYTTH7zqGYoxSmgLd/fYXykhbKKWz0kxhQjZ6Bb8H6mHSmMsU0=;
Received: from 88-117-54-199.adsl.highway.telekom.at ([88.117.54.199] helo=hornet.engleder.at)
        by mx08lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1odGj8-0005u7-4O; Tue, 27 Sep 2022 21:58:46 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 1/6] dt-bindings: net: tsnep: Allow dma-coherent
Date:   Tue, 27 Sep 2022 21:58:37 +0200
Message-Id: <20220927195842.44641-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220927195842.44641-1-gerhard@engleder-embedded.com>
References: <20220927195842.44641-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Within SoCs like ZynqMP, FPGA logic can be connected to different kinds
of AXI master ports. Also cache coherent AXI master ports are available.
The property "dma-coherent" is used to signal that DMA is cache
coherent.

Add "dma-coherent" property to allow the configuration of cache coherent
DMA.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 Documentation/devicetree/bindings/net/engleder,tsnep.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
index d0e1476e15b5..37e08ee744a8 100644
--- a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
+++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
@@ -22,6 +22,8 @@ properties:
   interrupts:
     maxItems: 1
 
+  dma-coherent: true
+
   local-mac-address: true
 
   mac-address: true
-- 
2.30.2

