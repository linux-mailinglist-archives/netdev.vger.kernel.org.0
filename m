Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A9955C1FF
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiF0RH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 13:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbiF0RHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 13:07:55 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B52A18E07;
        Mon, 27 Jun 2022 10:07:54 -0700 (PDT)
Received: from jupiter.universe (dyndsl-095-033-171-114.ewe-ip-backbone.de [95.33.171.114])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 50F71660184F;
        Mon, 27 Jun 2022 18:07:52 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1656349672;
        bh=8EUZhSokoUy572fOzha939IV7xaBmGQX0rZAPrDlbp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANSQI2d3dDVsTENU4yz9KnX6IyapF886hc3bNee50cTvzvW4uz5psj1pc846U17Mp
         rRQF7kz5d3J431CQN6ekI7F3dcuKVbrHjnx8w0RVy2cSJSFD0MuQJ+ZRBPHkRLRVRW
         MG3TJqHqrtd+jMOgvE4djCmcniT/QyKccSNKfDp2y7ykBTfqnIpSxhgP9tKnkZ9wYR
         SjbdC61WEhFN91i2jyHp4LQEkfTui9SEH8oNdvJ0ciyKYy2DHl+IPs0OSXOO78EH8E
         wu/+uIEyV1+buqFV7/uK4Gq/r8Mkz5smpitCxRFQeHKskCiWEA1clj0Pj+zNOnwVIO
         QprgLnnJfr2eA==
Received: by jupiter.universe (Postfix, from userid 1000)
        id F0F1448010C; Mon, 27 Jun 2022 19:07:49 +0200 (CEST)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        kernel@collabora.com
Subject: [PATCHv2 2/2] dt-bindings: net: rockchip-dwmac: add rk3588 gmac compatible
Date:   Mon, 27 Jun 2022 19:07:47 +0200
Message-Id: <20220627170747.137386-3-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220627170747.137386-1-sebastian.reichel@collabora.com>
References: <20220627170747.137386-1-sebastian.reichel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible string for RK3588 gmac, which is similar to the RK3568
one, but needs another syscon device for clock selection.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 6 ++++++
 Documentation/devicetree/bindings/net/snps,dwmac.yaml     | 1 +
 2 files changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
index 083623c8d718..1783f5eb9e50 100644
--- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
@@ -25,6 +25,7 @@ select:
           - rockchip,rk3368-gmac
           - rockchip,rk3399-gmac
           - rockchip,rk3568-gmac
+          - rockchip,rk3588-gmac
           - rockchip,rv1108-gmac
   required:
     - compatible
@@ -50,6 +51,7 @@ properties:
       - items:
           - enum:
               - rockchip,rk3568-gmac
+              - rockchip,rk3588-gmac
           - const: snps,dwmac-4.20a
 
   clocks:
@@ -81,6 +83,10 @@ properties:
     description: The phandle of the syscon node for the general register file.
     $ref: /schemas/types.yaml#/definitions/phandle
 
+  rockchip,php-grf:
+    description: The phandle of the syscon node for the peripheral general register file.
+    $ref: /schemas/types.yaml#/definitions/phandle
+
   tx_delay:
     description: Delay value for TXD timing. Range value is 0~0x7F, 0x30 as default.
     $ref: /schemas/types.yaml#/definitions/uint32
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 36c85eb3dc0d..b5aba399ca5d 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -72,6 +72,7 @@ properties:
         - rockchip,rk3328-gmac
         - rockchip,rk3366-gmac
         - rockchip,rk3368-gmac
+        - rockchip,rk3588-gmac
         - rockchip,rk3399-gmac
         - rockchip,rv1108-gmac
         - snps,dwmac
-- 
2.35.1

