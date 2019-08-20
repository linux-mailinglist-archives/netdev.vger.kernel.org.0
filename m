Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37DC895902
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 09:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbfHTH5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 03:57:55 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53814 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729210AbfHTH5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 03:57:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id 10so1734381wmp.3
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 00:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FvEHw13SSjNx0rO+Eb5GpaVPObzVB7Z/B/DYj0wmNjo=;
        b=FydfL8pH1IFg/KxMUBQwORlq9rRP+hJPHFX2ukRJ1GxBI/LZs8N6sx0MxvQi+Jllzl
         8VcOcIILZBwRg7Xub/GuO7FtE4N8AJoYYLQq41KLjkRzEHgVGHcRm9lz/9c8bXirkrdv
         hntEeiFjObQNEwJMYdUPq48RvrsXYSyy8N1FOtow+IqnqQjisiDyYhKlg5Xw9xfkbPhE
         566AZYy78ldJlFzn4ajapmh2BBq5sKT9tTDPSOQXEmebTyOb0GEA4UmpGy6JWMCj9lgx
         9c5NZ2BPO73PfNBWiSFk38q6k21OaGegzkaLvotAxI0Lmh2ewwLLMuej9lgDjIsZhy3m
         A2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FvEHw13SSjNx0rO+Eb5GpaVPObzVB7Z/B/DYj0wmNjo=;
        b=AYxZQ5omPiawjT/wvEarIbfjvHw6r3X+uDhOues6A1RnuVKa7/+SadLMFXiUd6pWHs
         xsny+x5zijvfWhLvF9G5T8xbJ0CqARGSwwUxjioRC5N4+U2fkrBByvkSlAhkPeaAyDvg
         sc2C9ZXyTOCM5f416I3fWaEXmYEGtyVodHqY/Id8m6AfmrJh8Eelqmj4XDjvF9nFQ9RY
         G0nvNHxBdw7BHttP2bdBgEB3pV5A7clpgF4qlh7RAuJ0y4HgWDDRbFn4ABNEJ3rRcVhQ
         SDOYNHtVcVzN2FL2po96vv8aoo2MF5uzswL3Is+1LOa3Lt4bzJlnYp18Q6F2qTyY6Ag8
         MUCg==
X-Gm-Message-State: APjAAAX8KvN2eeFdMsH/L+iO/WAsTZOM50su2OIwMWIZhglCZP8Zsb9x
        Ajt9zuK4DXXGm4e/vvvj8iFwxg==
X-Google-Smtp-Source: APXvYqxZ4XMFt3LxDKlYE+RW1ckDW1+fl4lBDePImr6M/WUYqMF4wT+8AJVCrU2RxsTTpEw51tO1Nw==
X-Received: by 2002:a1c:18a:: with SMTP id 132mr24806881wmb.15.1566287870642;
        Tue, 20 Aug 2019 00:57:50 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id q24sm1506467wmc.3.2019.08.20.00.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 00:57:49 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     davem@davemloft.net, robh+dt@kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        martin.blumenstingl@googlemail.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH net-next v4 1/2] dt-bindings: net: snps,dwmac: update reg minItems maxItems
Date:   Tue, 20 Aug 2019 09:57:41 +0200
Message-Id: <20190820075742.14857-2-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190820075742.14857-1-narmstrong@baylibre.com>
References: <20190820075742.14857-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Amlogic Meson DWMAC glue bindings needs a second reg cells for the
glue registers, thus update the reg minItems/maxItems to allow more
than a single reg cell.

Also update the allwinner,sun7i-a20-gmac.yaml derivative schema to specify
maxItems to 1.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 .../devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml      | 3 +++
 Documentation/devicetree/bindings/net/snps,dwmac.yaml          | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml
index 06b1cc8bea14..ef446ae166f3 100644
--- a/Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml
+++ b/Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml
@@ -17,6 +17,9 @@ properties:
   compatible:
     const: allwinner,sun7i-a20-gmac
 
+  reg:
+    maxItems: 1
+
   interrupts:
     maxItems: 1
 
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

