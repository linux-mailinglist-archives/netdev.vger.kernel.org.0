Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6956B8551
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjCMWxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjCMWxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:53:02 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DC321F91E;
        Mon, 13 Mar 2023 15:52:18 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 400C2E0EBA;
        Tue, 14 Mar 2023 01:51:19 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=PASsM/qfytAun14hsPY6sUMJYcEqmLZqm6dqWbnuxRA=; b=TYulQ7oyCxwP
        l8kO9WtAJOQtyUQbXYI5ug1OyfFfbKc8kdd2sW63nLwgtUQMhLdfXklH3Hkl1u2W
        fgFpp+5LmNn3Pk8DLmUcG6CknbLkCM64WrO1izL+BuMToAp7kYHPYURWbEjaVi/M
        TCatUUJUHhwO/Lu+B9F/ebAdo9H2pEQ=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id C1FC6E0E6A;
        Tue, 14 Mar 2023 01:51:18 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:51:18 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 08/16] dt-bindings: net: dwmac: Drop prop names from snps,axi-config description
Date:   Tue, 14 Mar 2023 01:50:55 +0300
Message-ID: <20230313225103.30512-9-Sergey.Semin@baikalelectronics.ru>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.8.30.10]
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The property is supposed to contain a phandle reference to the DT-node
with the AXI-bus parameters. Such DT-node is described in the same
DT-bindings schema by means of the sub-node with the name
"stmmac-axi-config". Similarly to MTL Tx/Rx config phandle properties
let's drop the target DT-node properties list from the "snps,axi-config"
property description since having that duplicate is not only pointless,
but also worsens the bindings maintainability by causing a need to support
the two identical lists. Instead the reference to the target DT-node is
added to the description.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../devicetree/bindings/net/snps,dwmac.yaml        | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 01f385867c3a..89be67e55c3e 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -98,17 +98,9 @@ properties:
   snps,axi-config:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
-      AXI BUS Mode parameters. Phandle to a node that can contain the
-      following properties
-        * snps,lpi_en, enable Low Power Interface
-        * snps,xit_frm, unlock on WoL
-        * snps,wr_osr_lmt, max write outstanding req. limit
-        * snps,rd_osr_lmt, max read outstanding req. limit
-        * snps,kbbe, do not cross 1KiB boundary.
-        * snps,blen, this is a vector of supported burst length.
-        * snps,fb, fixed-burst
-        * snps,mb, mixed-burst
-        * snps,rb, rebuild INCRx Burst
+      AXI BUS Mode parameters. Phandle to a node that
+      implements the 'stmmac-axi-config' object described in
+      this binding.
 
   snps,mtl-rx-config:
     $ref: /schemas/types.yaml#/definitions/phandle
-- 
2.39.2


