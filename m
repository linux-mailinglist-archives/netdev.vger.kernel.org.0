Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8296B45CDE4
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238066AbhKXUYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:24:08 -0500
Received: from ixit.cz ([94.230.151.217]:38654 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237467AbhKXUYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 15:24:06 -0500
Received: from localhost.localdomain (ip-89-176-96-70.net.upcbroadband.cz [89.176.96.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id B5B0220064;
        Wed, 24 Nov 2021 21:20:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1637785254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JOY3hYg/Zi65wbuf+lW3mLve82V3ibAcjofnA7CL8QQ=;
        b=L3GNPhK6AqeXR4Bpkrf10oJtJMujxolATVkMbzZsnAnA5GKZXIQ31SqbzxQsKUjoH/aXsz
        AZ/VAz//hVKTIniFu/BqrEsQSnhjuthVvx1LMM3I3oK62qXXxcHvaCfdqTu1Fd2jHyZ7PG
        BbMc4uX4C0Ahw/GZFBtQ4DRzgymyFCs=
From:   David Heidelberg <david@ixit.cz>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     ~okias/devicetree@lists.sr.ht, David Heidelberg <david@ixit.cz>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: ethernet-controller: add 2.5G and 10G speeds
Date:   Wed, 24 Nov 2021 21:20:46 +0100
Message-Id: <20211124202046.81136-1-david@ixit.cz>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both are already used by HW and drivers inside Linux.

Fix warnings as:
arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dt.yaml: ethernet@0,2: fixed-link:speed:0:0: 2500 is not one of [10, 100, 1000]
        From schema: Documentation/devicetree/bindings/net/ethernet-controller.yaml

Signed-off-by: David Heidelberg <david@ixit.cz>
---
 .../devicetree/bindings/net/ethernet-controller.yaml          | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index b0933a8c295a..95b5a3d77421 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -178,7 +178,7 @@ properties:
                   Duplex configuration. 0 for half duplex or 1 for
                   full duplex
 
-              - enum: [10, 100, 1000]
+              - enum: [10, 100, 1000, 2500, 10000]
                 description:
                   Link speed in Mbits/sec.
 
@@ -200,7 +200,7 @@ properties:
               description:
                 Link speed.
               $ref: /schemas/types.yaml#/definitions/uint32
-              enum: [10, 100, 1000]
+              enum: [10, 100, 1000, 2500, 10000]
 
             full-duplex:
               $ref: /schemas/types.yaml#/definitions/flag
-- 
2.33.0

