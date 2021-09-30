Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06CCC41DA7C
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349458AbhI3NHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:07:20 -0400
Received: from mail.fris.de ([116.203.77.234]:50556 "EHLO mail.fris.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349422AbhI3NHT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 09:07:19 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Sep 2021 09:07:19 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 43C78BFC2A;
        Thu, 30 Sep 2021 14:58:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fris.de; s=dkim;
        t=1633006694; h=from:subject:date:message-id:to:cc:mime-version:
         content-transfer-encoding:in-reply-to:references;
        bh=Zm3leV4xiEmZ5I7qYX9SHWVvuSf+WKr59C8LP7tkpH4=;
        b=iCA2dgV6G0ciqJn9DvG7ulPLEw6aZmGXgNRq37AgTXn0c4ZgSXbPbMspAp2/qCSUePYu5F
        YfebJNN5SRujWaECK5cUmFSk9e281YJhXeg5yuV+0IaIxaEKnGqmhIUNK0aqX8EsWCRtcI
        qXgbJI7nqBoXC65qMPE0KHS4BH03ort/R+4ziNIOGiYMpWQl1f1pwGpmtyUsscg2BEcnfY
        CPgYcawn1kOn3bMzhpd4dIzV8N4Qe3Xoobq2IzpgmKci4zCoYH3JYMplkgBjndtvDHyQvX
        5YIDSvBLhdKYxfs4VOOtLewjYz36C5fs3/TZNe0FS86Okf1zrFMltyDWMTz/tw==
From:   Frieder Schrempf <frieder@fris.de>
To:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        Baisheng Gao <gaobaisheng@bonc.com.cn>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 2/3] dt-bindings: net: phy: mscc: vsc8531: Add LED mode combine disable property
Date:   Thu, 30 Sep 2021 14:57:44 +0200
Message-Id: <20210930125747.2511954-2-frieder@fris.de>
In-Reply-To: <20210930125747.2511954-1-frieder@fris.de>
References: <20210930125747.2511954-1-frieder@fris.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

Add the new property to disable the combined LED modes to the bindings
documentation.

Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
 Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
index 0a3647fe331b..1ca11ab4011b 100644
--- a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
+++ b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
@@ -31,10 +31,13 @@ Optional properties:
 			  VSC8531_LINK_100_ACTIVITY (2),
 			  VSC8531_LINK_ACTIVITY (0) and
 			  VSC8531_DUPLEX_COLLISION (8).
+- vsc8531,led-[N]-combine-disable	: Disable the combined mode for LED[N].
+			  This disables the second mode if a combined mode is selected.
 - load-save-gpios	: GPIO used for the load/save operation of the PTP
 			  hardware clock (PHC).
 
 
+
 Table: 1 - Edge rate change
 ----------------------------------------------------------------|
 | 		Edge Rate Change (VDDMAC)			|
-- 
2.33.0

