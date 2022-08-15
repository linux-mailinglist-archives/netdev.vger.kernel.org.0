Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD04B592D3D
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241481AbiHOIHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 04:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbiHOIHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 04:07:07 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51AE1E3C9;
        Mon, 15 Aug 2022 01:07:06 -0700 (PDT)
Received: from stefanw-SCHENKER ([37.4.248.80]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M8k65-1oIoHv0ONV-004nDA; Mon, 15 Aug 2022 10:06:54 +0200
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 1/2] dt-bindings: vertexcom-mse102x: Update email address
Date:   Mon, 15 Aug 2022 10:06:25 +0200
Message-Id: <20220815080626.9688-1-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:66NYIEABEw2lFmB4CyU8k3G6w89V9rvVHumYyKy6UGaICg9s/B8
 Rvx/p0i835oyz/oztKo5Jlwv1dqslskeZYzfR3mCmwYMnVb2+r/vADftkiHqRcCgyOK+4XA
 AVhuv/C48gxn2s3BOFVwGjdvpfO+hAxxKFMsgfcaA4JHYr4aGRRx0pb0rhz42rn5nQ9y3Fg
 49c1aNEBS+zhXg841pKsQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3WvnVBQ2lgs=:fOyWd3Kv176WtYR1GsCvGl
 hoAaUcTde1Oj3rzakW/gHBf47NIzJs1vD7bSNtNtSWea0b7YTOwQhILnLAKzLPLGwdW89nIek
 sW9CMI7Qqawrkv177i9O2bzUQ+SoPfroLoBPer5hXaP/T1RgwomXpZj7WPNoKBdDCNi0AVprq
 6LpvKa2y/buTixUGPxPNd6KjKiqWRpp4INKax1Rmp6Ec7et3XdXROw+qPJviBhlZQxb7vy9eI
 wSDqlGGeFvlQzaTwUHMs506fA+hgxFTGrRAunGbysDGEvzk4UyhNAmYFqhfQbuhWNyCWRDS5j
 Tj/QU12PC9owDcoO3yWJ1rUhggLc8gTNNODYuRrvJ9HuAnFIynp5tTl8ukyVBHCdmnv/shgxn
 oRFLiUFmcjiXjhNW9xN2XpXK9Srljs20DhtxuYZTnIYTFwPOSOz36Pph/wIODJMCJn6HsUg6D
 Yw2IRBsw0v4nLfTaijWby3QTM45G1pN9Cs7/KCFbl/cf/4IPAqUUyAxNT0WlDTOlstGR+cRyf
 eFZS99hnvaRCVjVrljOvws4sLgHLKt6pIOKxkgQ2qrXUsY9aPsxNQhvM67FMjG37/xV/wmxIr
 G5I93/f1JPf3IaE15rD2fF2RuYyopkHqk6Hcs8IlyTVMITdtQMod+iKvNAc1j9Lj7myn0uH/G
 ih9AKra7Kq6Cqy3ebH/BX7Mmipoz5L2YOjPF/f8YpxHEgtpQRcfRdKRomb4o9yt4xeEVuKiZp
 0QjAxQZZaMQ5Mmogj7XsSyb2QCgyAQf6Pk/0qlMVRN4Ee0JK3TmQJ11L8+8=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in-tech smart charging is now chargebyte. So update the email address
accordingly.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml b/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
index 8156a9aeb589..304757bf9281 100644
--- a/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
+++ b/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
@@ -7,7 +7,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: The Vertexcom MSE102x (SPI) Device Tree Bindings
 
 maintainers:
-  - Stefan Wahren <stefan.wahren@in-tech.com>
+  - Stefan Wahren <stefan.wahren@chargebyte.com>
 
 description:
   Vertexcom's MSE102x are a family of HomePlug GreenPHY chips.
-- 
2.34.1

