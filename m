Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B0E831DB
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 14:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbfHFMvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 08:51:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50631 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731325AbfHFMuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 08:50:46 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so78092206wml.0
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 05:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yzbvwLA71SutNdcRHcgBexC8KRT0RQ0GJQYA84SLkGA=;
        b=O3dE1DHluIpu7fXmyotf13Fm6oEcfDpRu2r5FwuYeHLyxbncudzQIuUVO0dpLrlcPF
         tGM9uz0klewnYgo+rd6yN2F4qAq82UhQyCJRQxj6dtH4eMEcvzoremBWPJhmfINtmfzx
         upgt7GL6h3RkZUmi+HxHGedeta4NBcC2tNsg1pPlSkqkCRcQ++SGOobtwg91tWVaMbbU
         Bh9T0pYvxKSEdp0vvYRhP7h528nS6XSUJBLXObD//8iAITlP2THqfu7y5F87wRXlQMUE
         hU2mxHpNtD9Qxxog1+yr6cIIO6mnZnXBNXdRSyH8rFuH6r+8kh3o4CSGRLiTj54qJbcq
         iNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yzbvwLA71SutNdcRHcgBexC8KRT0RQ0GJQYA84SLkGA=;
        b=mM1UKlk9IvWlVpyLRNisf4HR28+K2KrKoguq8XO5S0ws4wUow1adSbSHLed2745tpM
         aXdLUy3DP9FmxIuK2Nhyf8Qz9UwRhpZf2XjBANikkdMCe6c8K2UN637aySvFW4SgNtli
         70t6xReKuv2i9O7kZn/k4x8vgFVXtLEdyktfRlOYx/aifmxVTZ2IDVmHSXyGZnaKaUvC
         BbOEADy84h04+B5iy0CWRu8w6Ob4xx1j/Xo7zxQO6T2wuY+wDmyDwmL/2FQsu6reRhOS
         5vdIDbf/zHCBXJWB/mdOw6Z5cJdssGYmgVEBA30yNaphFB3vONHex0OIT2657ZtllYQW
         ILyg==
X-Gm-Message-State: APjAAAXlzJN1zhsSq/HN2YUvplcOZTfJzI4tvI6kTwYFQwywSmE1jmKE
        DGlkrYjRg9mnqZYixPIGdUJNow==
X-Google-Smtp-Source: APXvYqx80EosVrp9UyukzeR9aDnPspDjd/F40dn6Me7nABU+FtMHoLvpD/lZwMP5x40WKWnwAvJUJQ==
X-Received: by 2002:a1c:c14b:: with SMTP id r72mr4792277wmf.166.1565095844304;
        Tue, 06 Aug 2019 05:50:44 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id e3sm109049221wrs.37.2019.08.06.05.50.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 05:50:43 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     robh+dt@kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        martin.blumenstingl@googlemail.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] dt-bindings: net: snps,dwmac: update reg minItems maxItems
Date:   Tue,  6 Aug 2019 14:50:40 +0200
Message-Id: <20190806125041.16105-2-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806125041.16105-1-narmstrong@baylibre.com>
References: <20190806125041.16105-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Amlogic Meson DWMAC glue bindings needs a second reg cells for the
glue registers, thus update the reg minItems/maxItems to allow more
than a single reg cell.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 76fea2be66ac..4377f511a51d 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -61,7 +61,8 @@ properties:
         - snps,dwxgmac-2.10
 
   reg:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
 
   interrupts:
     minItems: 1
-- 
2.22.0

