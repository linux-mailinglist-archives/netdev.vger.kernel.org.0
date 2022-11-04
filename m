Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D98619D06
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiKDQVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKDQVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:21:54 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0444220F6C;
        Fri,  4 Nov 2022 09:21:51 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7C33CFF804;
        Fri,  4 Nov 2022 16:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667578909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9HchoTCX6YVHNGcWcXAvQMr2LjZVh92FKk3oVYUFEoE=;
        b=lebu3URtD5BNezq33EsxC2+z6KVIPWxxOIs/C1qOa68hmd9pGGfslmZdX1DTeetA7ZCrYq
        TjEHbptgAtpUIFDItmvRdeSVeG7CJRlvXC2znfVUFWNPHiUx+dIUekntTwCEYx4Q4cBpjU
        tPMDmJG8y4eoQ3q82a94kteyLX9xHVH8OT2+TcNfiJGUaAWCQ1bpvqSXFUu3TV8bjoBOXi
        wpn2Ugh0G3H5G66nnv5P4R/XqOfNQQ+Bicf3r4OM4+TvzgHIgsGyCicCHF0io+ffg0FUJO
        OfhBCh1arriKA55pkIxHdZHTi3OVeWlhyl3I8CJdYABnMEXTs8QzWadSkTphBQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH net-next] dt-bindings: net: tsnep: Fix typo on generic nvmem property
Date:   Fri,  4 Nov 2022 17:21:47 +0100
Message-Id: <20221104162147.1288230-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While working on the nvmem description I figured out this file had the
"nvmem-cell-names" property name misspelled. Fix the typo, as
"nvmem-cells-names" has never existed.

Fixes: 603094b2cdb7 ("dt-bindings: net: Add tsnep Ethernet controller")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 Documentation/devicetree/bindings/net/engleder,tsnep.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
index 5bd964a46a9d..a6921e805e37 100644
--- a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
+++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
@@ -47,7 +47,7 @@ properties:
 
   nvmem-cells: true
 
-  nvmem-cells-names: true
+  nvmem-cell-names: true
 
   phy-connection-type:
     enum:
-- 
2.34.1

