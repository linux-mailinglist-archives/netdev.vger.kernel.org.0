Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819A44CD2F6
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 12:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238472AbiCDLH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 06:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238416AbiCDLHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 06:07:25 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0B01AEEC3;
        Fri,  4 Mar 2022 03:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646391997; x=1677927997;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k9jGl/0jWS8jr/FW3OeKqHd4qP3bdm9danE8ErYTjJM=;
  b=L3d2KtopJp+YxeJOgyi8jYM5pTfyEj/PkBUYtlEtMIHBaGZD6qHgtVi1
   PYAHwydSs3tZlD1kHecsYRF1iTnbxRMaMpqrN9dQPAWGFSi8CJwI8dPD4
   45BVuLKqJNYu2n7nAWvdlotWf4SVCTvKEmq5BwCoc++dPEhGASceiFwua
   xlqiPGUZlCXao0DQWCnYFurLMNP1fHgn1nrDXfJdkyYoZ3we1ve2mPqJp
   eVangphoCs2TNBNOLWykUb+sh4+D/2THTX1hEW+zJLR3WSsMOmOHr2k/0
   r6k5WDNiAGK33yTMFI75dJrJegNeUQdp0fna6BPA4OQ0Ig6XK0W3zR2E5
   A==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="150853642"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 04:06:36 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 04:06:36 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 04:06:34 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <casper.casan@gmail.com>,
        <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/9] dt-bindings: net: sparx5: Extend with the ptp interrupt
Date:   Fri, 4 Mar 2022 12:08:53 +0100
Message-ID: <20220304110900.3199904-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
References: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend dt-bindings for sparx5 with ptp interrupt. This is generated
when doing 2-step timestamping and the timestamp can be read from the
FIFO.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../devicetree/bindings/net/microchip,sparx5-switch.yaml        | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
index 347b912a46bb..6c86d3d85e99 100644
--- a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
@@ -53,12 +53,14 @@ properties:
     items:
       - description: register based extraction
       - description: frame dma based extraction
+      - description: ptp interrupt
 
   interrupt-names:
     minItems: 1
     items:
       - const: xtr
       - const: fdma
+      - const: ptp
 
   resets:
     items:
-- 
2.33.0

