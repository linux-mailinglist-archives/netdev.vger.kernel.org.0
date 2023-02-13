Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61673694557
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 13:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjBMMKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 07:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjBMMKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 07:10:24 -0500
Received: from smtp-out-12.comm2000.it (smtp-out-12.comm2000.it [212.97.32.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3266E5FD3;
        Mon, 13 Feb 2023 04:10:10 -0800 (PST)
Received: from francesco-nb.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-12.comm2000.it (Postfix) with ESMTPSA id 8F51BBA1889;
        Mon, 13 Feb 2023 13:09:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1676290172;
        bh=5IFF+MAeEg7aqa9/TtrzCHtylps+zzbsIxIw3e0+S6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=RnFEKeh0rJwNdYqYkK/mXnCDcB0yVR9qo9ttiQ4fXutgA74PmrVAzra15tgxJiTVQ
         i1J+8X4tsYYOkU9eJnChMefV3PO3cza7QnIj1ArR3g96fsFVSKM/PiP2W73DrVdDxw
         4NSd6l5KkQBLrjhKVStWmsxvLFPxLzfiXI+pLI6gP9Jrg7Cf7qiLtOtQfCD4z/iemJ
         cTsCeAOfsXyFnRnsEMG95wHFoGF5oilERnypOPFb12PCunk5UAHkvUBww+Qb7Ic9iz
         FU15sVEmzmDvbxSKqFBcsGmamWEDOBsddJOFHpnyxMzlsmiE3U7qRC9BTEffU0o80q
         jnvQ5oXh0TPCA==
From:   Francesco Dolcini <francesco@dolcini.it>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Stefan Eichenberger <stefan.eichenberger@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH v3 1/5] dt-bindings: bluetooth: marvell: add 88W8997
Date:   Mon, 13 Feb 2023 13:09:22 +0100
Message-Id: <20230213120926.8166-2-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213120926.8166-1-francesco@dolcini.it>
References: <20230213120926.8166-1-francesco@dolcini.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

Update the documentation with the device tree binding for the Marvell
88W8997 bluetooth device.

Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
v3: no changes
v2:
 - removed redundant "DT binding" from commit message title
 - add acked-by Krzysztof
---
 Documentation/devicetree/bindings/net/marvell-bluetooth.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml b/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
index 309ef21a1e37..83b64ed730f5 100644
--- a/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
@@ -15,7 +15,9 @@ maintainers:
 
 properties:
   compatible:
-    const: mrvl,88w8897
+    enum:
+      - mrvl,88w8897
+      - mrvl,88w8997
 
 required:
   - compatible
-- 
2.25.1

