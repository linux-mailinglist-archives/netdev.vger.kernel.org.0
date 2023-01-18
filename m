Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1C5671CF2
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjARNHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjARNG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:06:58 -0500
Received: from smtp-out-01.comm2000.it (smtp-out-01.comm2000.it [212.97.32.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0487A2963;
        Wed, 18 Jan 2023 04:29:00 -0800 (PST)
Received: from francesco-nb.toradex.int (31-10-206-125.static.upc.ch [31.10.206.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-01.comm2000.it (Postfix) with ESMTPSA id B6F05842D2D;
        Wed, 18 Jan 2023 13:28:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1674044927;
        bh=ydMytKybg4Bf1BHsNiOQ5zccoMmX2G8pKIP49hBn8DY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=dvN2yIaASALK3+hYpiG6M6OwYHlXwprVEFYQKv3T4XHoL7FpdWF6q57VRpqCsqNjY
         ymnaeWg1QAtWtw3+jT/BMcClEhcMPj+atc0HScAg01x5bBvCRdJSP54hIL7VrsL9oa
         /g4aqTGfcK7ng6sDddf9e6Ooe/yssia9o3JJjCXyZmd0PqED3pnyWH62X+nsVLsfAz
         loVEdZbu1rDhZg9bDq1ZkZcireiavw06cZ9FD2Oz+IeSMB1dRPmiTidbn0uAjHaec7
         Deg3ce8F1P4aE8SS7hedIAbwYnVgbycvHZ7zfik607nhJs1RdDU95/cd1qHWEFTEn8
         qSbq2Q/fAlpug==
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
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH v1 1/4] dt-bindings: bluetooth: marvell: add 88W8997 DT binding
Date:   Wed, 18 Jan 2023 13:28:14 +0100
Message-Id: <20230118122817.42466-2-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230118122817.42466-1-francesco@dolcini.it>
References: <20230118122817.42466-1-francesco@dolcini.it>
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
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
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

