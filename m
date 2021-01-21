Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E802FE72B
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 11:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbhAUKJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 05:09:56 -0500
Received: from www.zeus03.de ([194.117.254.33]:48376 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728896AbhAUKH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 05:07:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=h70BkSbftDHvdg
        OoDJAZ1FmD9GbR4klNFsNkdC9yb5k=; b=rMKG5roFmmlvaRsoNjab/CY1aFkN1n
        8ou4zB4K5DDN8KmG+nrOv83aDITF07t1czBkmZ54SiRSRnlcuHBtstCeFE7xEG1H
        S/xh6VnGhOGyKLjzIubNQy5F2GLpFkJft95MKuANu4UVBbwJXJWiA0eoQGx9gWPX
        3yG0evTMDJ4QQ=
Received: (qmail 1790393 invoked from network); 21 Jan 2021 11:06:26 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 21 Jan 2021 11:06:26 +0100
X-UD-Smtp-Session: l3s3148p1@mhNxOWa5sr4gAwDPXyX1ACWcscxtZ2TX
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] dt-bindings: net: renesas,etheravb: Add r8a779a0 support
Date:   Thu, 21 Jan 2021 11:06:15 +0100
Message-Id: <20210121100619.5653-2-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121100619.5653-1-wsa+renesas@sang-engineering.com>
References: <20210121100619.5653-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the compatible value for the RAVB block in the Renesas R-Car
V3U (R8A779A0) SoC. This variant has no stream buffer, so we only need
to add the new compatible and add it to the TX delay block.

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

Please apply via netdev tree.

Change since v1:
* add entry to TX delay block
* added tags

 Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index 244befb6402a..c4c441c493ff 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -40,6 +40,7 @@ properties:
               - renesas,etheravb-r8a77980     # R-Car V3H
               - renesas,etheravb-r8a77990     # R-Car E3
               - renesas,etheravb-r8a77995     # R-Car D3
+              - renesas,etheravb-r8a779a0     # R-Car V3U
           - const: renesas,etheravb-rcar-gen3 # R-Car Gen3 and RZ/G2
 
   reg: true
@@ -169,6 +170,7 @@ allOf:
               - renesas,etheravb-r8a77965
               - renesas,etheravb-r8a77970
               - renesas,etheravb-r8a77980
+              - renesas,etheravb-r8a779a0
     then:
       required:
         - tx-internal-delay-ps
-- 
2.29.2

