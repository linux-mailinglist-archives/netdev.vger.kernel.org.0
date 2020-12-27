Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0112E313B
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 14:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgL0NFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 08:05:19 -0500
Received: from www.zeus03.de ([194.117.254.33]:37834 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgL0NFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Dec 2020 08:05:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=uOGyk9jK/cDOzN
        G0QbQktOlvOTBx4DRqTyBqOV5sJIU=; b=th1wJoIUD2FLzsV/Z2J+MwC7wK4EDV
        cJroEk0ge/XOrCN1AaMIYUXg+zQYq6P6MnGpQX+64qfACGrDxDx6Dm6HN1pnwu+4
        cUkiDleLVighSfTDOc4ZhtHIbmVax1jj14paiSO8tNOn6nU01jgakYKuS6FE72Bi
        WI6UegnLZfwXQ=
Received: (qmail 1501099 invoked from network); 27 Dec 2020 14:04:18 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 27 Dec 2020 14:04:18 +0100
X-UD-Smtp-Session: l3s3148p1@MeeTy3G3YsEgAwDPXwIpAOUwDQytQs2L
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] dt-bindings: net: renesas,etheravb: Add r8a779a0 support
Date:   Sun, 27 Dec 2020 14:04:02 +0100
Message-Id: <20201227130407.10991-2-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201227130407.10991-1-wsa+renesas@sang-engineering.com>
References: <20201227130407.10991-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the compatible value for the RAVB block in the Renesas R-Car
V3U (R8A779A0) SoC. This variant has no stream buffer, so we only need
to add the new compatible.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index 244befb6402a..6e57e4f157f0 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -40,6 +40,7 @@ properties:
               - renesas,etheravb-r8a77980     # R-Car V3H
               - renesas,etheravb-r8a77990     # R-Car E3
               - renesas,etheravb-r8a77995     # R-Car D3
+              - renesas,etheravb-r8a779a0     # R-Car V3U
           - const: renesas,etheravb-rcar-gen3 # R-Car Gen3 and RZ/G2
 
   reg: true
-- 
2.29.2

