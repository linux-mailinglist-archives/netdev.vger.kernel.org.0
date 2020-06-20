Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E0420262D
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 21:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgFTT2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 15:28:06 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44863 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbgFTT2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 15:28:05 -0400
Received: by mail-ed1-f68.google.com with SMTP id s28so10420740edw.11;
        Sat, 20 Jun 2020 12:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xlMju2JEREJBGn1W5Gv493VuaaC7wnSC30py7qk3wR0=;
        b=lrwpfi64mqrazoNe8GDi05u/Dqj8jtbPAa1bHuWrhBwGo0iFhAYxvGp/wtaONK2egG
         azPY8nq4+52RSN3SwHreMqnjiyUeM8gc3pYnFw+WzDFY4RfXnJJCZNJ1ME9137N5g5rL
         i5gfxRJkNJ4G2mtbKei/O+itHOco3RN/HX+8nyDNNwHnwDybmkhq/tmI+h/Gmw51LgOd
         umrf2HHPzXXYhfhVxtXfPTbX3qaJ489Ql1paIr6jeitgLqXQ5D+AgwmLUayFQH9KD2Lr
         gp4TtT62XgIRJF7hrMh69aweH/jQuDN6FICg/FiDWdfvAZwQ4VWFT4dyC0ktgPFHs9mR
         1y2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xlMju2JEREJBGn1W5Gv493VuaaC7wnSC30py7qk3wR0=;
        b=SNJTXhIvHiAjCe+xaZeeldgENnaDnnjLiFqaAefKBwZfoVXubRMYV80epd7bWr48e+
         VK7Yg0Dp1hrv7xHb9Txe8DyECUuiDvjxi0EoSSDSlDDqaO2Q7lHWX6WzvSkhFmTps3XN
         iy8mHseAS5/5XHM1zebFlP1GSOuCH23RPusFIcRWHXjfoyo8wbocU7MyYo8pJcADdLvc
         Xq+BKOlXRZxqK0RH52qD9gv6zQW03XVFTn3PZuRuYrUNpe4AgRgAtwj4BcCtPR/IMX3U
         Emaq38Y+sd7ySvgJzkDCQpzaMwFeuqsuH8iavOC/0ChNFW1c2hBeNk1FKAOXO3eWOWHq
         X5fw==
X-Gm-Message-State: AOAM533tdqS6a7jxvpwsgv8BdoLOIkkrpWJUIJuFIfXfMye+W4omSubD
        jRa5z3+IXZv/C3k1pnbIuNY=
X-Google-Smtp-Source: ABdhPJx/JXrXjP1uqPNHJEy8cBhBX22rRDG+D3WwF4EyWe0fbzvib9r//NyBQNuTtOO06TR9dd7kow==
X-Received: by 2002:a50:a721:: with SMTP id h30mr9375012edc.153.1592681223010;
        Sat, 20 Jun 2020 12:27:03 -0700 (PDT)
Received: from localhost.localdomain (p200300f1371df700428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:371d:f700:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id gv18sm8034044ejb.113.2020.06.20.12.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 12:27:02 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/2] dt-bindings: net: dwmac-meson: Add a compatible string for G12A onwards
Date:   Sat, 20 Jun 2020 21:26:40 +0200
Message-Id: <20200620192641.175754-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200620192641.175754-1-martin.blumenstingl@googlemail.com>
References: <20200620192641.175754-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amlogic Meson G12A, G12B and SM1 have the same (at least as far as we
know at the time of writing) PRG_ETHERNET glue register implementation.
This implementation however is slightly different from AXG as it now has
an undocument "auto cali idx val" register in PRG_ETH1[17:16] which
seems to be related to RGMII Ethernet.

Add a compatible string for G12A and newer so the new registers can be
used.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
index 64c20c92c07d..85fefe3a0444 100644
--- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
@@ -22,6 +22,7 @@ select:
           - amlogic,meson8m2-dwmac
           - amlogic,meson-gxbb-dwmac
           - amlogic,meson-axg-dwmac
+          - amlogic,meson-g12a-dwmac
   required:
     - compatible
 
@@ -36,6 +37,7 @@ allOf:
               - amlogic,meson8m2-dwmac
               - amlogic,meson-gxbb-dwmac
               - amlogic,meson-axg-dwmac
+              - amlogic,meson-g12a-dwmac
 
     then:
       properties:
@@ -95,6 +97,7 @@ properties:
           - amlogic,meson8m2-dwmac
           - amlogic,meson-gxbb-dwmac
           - amlogic,meson-axg-dwmac
+          - amlogic,meson-g12a-dwmac
     contains:
       enum:
         - snps,dwmac-3.70a
-- 
2.27.0

