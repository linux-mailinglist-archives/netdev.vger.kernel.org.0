Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D509A633BDE
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbiKVLyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbiKVLys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:54:48 -0500
Received: from inva021.nxp.com (inva021.nxp.com [92.121.34.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423B525C52;
        Tue, 22 Nov 2022 03:54:48 -0800 (PST)
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id F1E5F200D45;
        Tue, 22 Nov 2022 12:54:46 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BA76B200D37;
        Tue, 22 Nov 2022 12:54:46 +0100 (CET)
Received: from local (shlinux2.ap.freescale.net [10.192.224.44])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id D3CBC183ABF1;
        Tue, 22 Nov 2022 19:54:44 +0800 (+08)
From:   haibo.chen@nxp.com
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        haibo.chen@nxp.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 2/3] dt-bindings: can: fsl,flexcan: add imx93 compatible
Date:   Tue, 22 Nov 2022 19:32:31 +0800
Message-Id: <1669116752-4260-2-git-send-email-haibo.chen@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1669116752-4260-1-git-send-email-haibo.chen@nxp.com>
References: <1669116752-4260-1-git-send-email-haibo.chen@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

Add a new compatible string for imx93.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
---
 Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
index e52db841bb8c..6e59bd2a6094 100644
--- a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
@@ -17,6 +17,7 @@ properties:
   compatible:
     oneOf:
       - enum:
+          - fsl,imx93-flexcan
           - fsl,imx8qm-flexcan
           - fsl,imx8mp-flexcan
           - fsl,imx6q-flexcan
-- 
2.34.1

