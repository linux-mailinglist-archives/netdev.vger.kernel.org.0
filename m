Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC10689B85
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbjBCOZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjBCOZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:25:46 -0500
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4072C6278D;
        Fri,  3 Feb 2023 06:25:45 -0800 (PST)
Received: from robin.home.jannau.net (p579ad32f.dip0.t-ipconnect.de [87.154.211.47])
        by soltyk.jannau.net (Postfix) with ESMTPSA id 0133826F704;
        Fri,  3 Feb 2023 14:56:33 +0100 (CET)
From:   Janne Grunau <j@jannau.net>
Date:   Fri, 03 Feb 2023 14:56:27 +0100
Subject: [PATCH RFC 2/3] dt-bindings: wireless: bcm4329-fmac: Use
 network-class.yaml schema
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230203-dt-bindings-network-class-v1-2-452e0375200d@jannau.net>
References: <20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net>
In-Reply-To: <20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?utf-8?q?J=C3=A9r=C3=B4me_Pouiller?= <jerome.pouiller@silabs.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Janne Grunau <j@jannau.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1073; i=j@jannau.net;
 h=from:subject:message-id; bh=hIczjgZ3j0WKhMWdXkOeVhlbmC36N4y+R9jOPHgn32g=;
 b=owGbwMvMwCG2UNrmdq9+ahrjabUkhuS7QhO4fPPWehkeKeScrxe+LtBjz/xSpw/ZS/7fyJIP6
 rNcGMndUcrCIMbBICumyJKk/bKDYXWNYkztgzCYOaxMIEMYuDgFYCJtBxkZWhfvzUtOlPz4+q9J
 sPry1dJtP3IE9N5Ilc+uuLbQ4BvnWqAKteccIQb28jst3shlHDpWfULjPjcvv/89fg9Hl97GH1w A
X-Developer-Key: i=j@jannau.net; a=openpgp;
 fpr=8B336A6BE4E5695E89B8532B81E806F586338419
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The network-class schema specifies local-mac-address as used in the
bcm4329-fmac device nodes of Apple silicon devices
(arch/arm64/boot/dts/apple).
Fixes `make dtbs_check` for those devices.

Signed-off-by: Janne Grunau <j@jannau.net>
---
 .../devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml          | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
index fec1cc9b9a08..55b0a21acb96 100644
--- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
@@ -116,11 +116,14 @@ properties:
       NVRAM. This would normally be filled in by the bootloader from platform
       configuration data.
 
+allOf:
+  - $ref: /schemas/net/network-class.yaml#
+
 required:
   - compatible
   - reg
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |

-- 
2.39.1

