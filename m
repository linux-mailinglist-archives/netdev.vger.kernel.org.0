Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FAC286A32
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgJGVcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbgJGVce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 17:32:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769FAC0613DD
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 14:32:20 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kQH2o-0005qi-GG; Wed, 07 Oct 2020 23:32:18 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Michael Walle <michael@walle.cc>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 12/17] dt-bindings: can: flexcan: list supported processors
Date:   Wed,  7 Oct 2020 23:31:54 +0200
Message-Id: <20201007213159.1959308-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007213159.1959308-1-mkl@pengutronix.de>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>

The compatible is a pattern match. Explicitly list all possible values.
Also mention that the ls1028ar1 must be followed by lx2160ar1.

Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20201001091131.30514-2-michael@walle.cc
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
index 94c0f8bf4deb..c6152dc2d2d0 100644
--- a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
+++ b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
@@ -4,6 +4,12 @@ Required properties:
 
 - compatible : Should be "fsl,<processor>-flexcan"
 
+  where <processor> is imx8qm, imx6q, imx28, imx53, imx35, imx25, p1010,
+  vf610, ls1021ar2, lx2160ar1, ls1028ar1.
+
+  The ls1028ar1 must be followed by lx2160ar1, e.g.
+   - "fsl,ls1028ar1-flexcan", "fsl,lx2160ar1-flexcan"
+
   An implementation should also claim any of the following compatibles
   that it is fully backwards compatible with:
 
-- 
2.28.0

