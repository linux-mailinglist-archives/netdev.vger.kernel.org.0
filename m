Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED314799A6
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 09:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhLRIQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 03:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbhLRIPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 03:15:33 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9004C061574
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:32 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id p3so4562097qvj.9
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pQEVewj8A9w0h+9wlAYy0j8Y8Gq6vevo54Wx7PiNV/o=;
        b=hOEqUwdNS/ljPmGj9i4qxGkSbdwfy+i1jVkKdHm54ZynOTz2ceXfUKhTRrqiIutqoq
         rld7YqLVIKhMFI4JN5z25eoVMZbqH6slRGf6mVruuzTA2ua8ltT9dEmvRf9GU7r/F97t
         Yv6mXtaTP7Q7ucfAds2YPe8oQaFPXuJWc+H93Mtlkm40RKMtkbFA5HTFn+2bH7xIF8MS
         uBmQcfHwSV0xA9P1o02ekBrSUYe3PVXU3vrHDDfGk450ms7+/qRGjyANGpaaiO2NYQ+4
         6oF9QeJI3PI5ZzUmTSAFS2pOToxVB7AF2/TWGj4dbLo/bQneTKux//5WGXQGoJUja53g
         XRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pQEVewj8A9w0h+9wlAYy0j8Y8Gq6vevo54Wx7PiNV/o=;
        b=bXeu//z8w9Y28aRPKWw96D0l7RdkvLEEHV4xvgYaKAJV4WiXcozPL8vr8Hl+tykV8o
         oDmExqNyssEOWgBXBLNAahheDY1wAE6hUPR/1atqHiuwi36eDai2Sp8dr2zEjHta6fHw
         Bl7escLAyLe4FmHcvMz8M7MMCmyKcgW6IjVp8rmHeAb2s9dmLQU6YOLRt3dP5xDCafiZ
         qEDRvSDFydyLuwpxwX31BjJNeA5tAS2WYM71hFx+l/m+XB/aj+xMTQL2XF08O6wK1eQJ
         NYc3XTmG0h+Nx4PzU5k79sY24z2YhJqh77tOwv+htg9FvfWUQHDHDg4Q1YhJY2xA/EPn
         mvYg==
X-Gm-Message-State: AOAM533Ij45pMbwhlN9e7DHsWdS9fEQqMLP05VjY8UTUKvXuwQAPqIny
        3MpoJ9jDzmZA3+M5ysOzVFOXRjeeZsbZaQ==
X-Google-Smtp-Source: ABdhPJzhkAX/UPx2mRGpLuPaiojxMYeG/Xl3V+QArGvq4TsW2qMY3NT9SaiL2A9JT1tU3hKcTeXM+w==
X-Received: by 2002:a05:6214:76a:: with SMTP id f10mr5652043qvz.8.1639815331826;
        Sat, 18 Dec 2021 00:15:31 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id f11sm6423357qko.84.2021.12.18.00.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 00:15:31 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2 13/13] dt-bindings: net: dsa: realtek-{smi,mdio}: add rtl8367s
Date:   Sat, 18 Dec 2021 05:14:25 -0300
Message-Id: <20211218081425.18722-14-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211218081425.18722-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt | 1 +
 Documentation/devicetree/bindings/net/dsa/realtek-smi.txt  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt b/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
index 71e0a3d09aeb..a7f2542f68ee 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-mdio.txt
@@ -14,6 +14,7 @@ Required properties:
       "realtek,rtl8366s"  (4+1 ports) (not supported yet)
       "realtek,rtl8367"               (not supported yet)
       "realtek,rtl8367b"              (not supported yet)
+      "realtek,rtl8367s"  (5+2 ports)
       "realtek,rtl8368s"  (8 port)    (not supported yet)
       "realtek,rtl8369"               (not supported yet)
       "realtek,rtl8370"   (8 port)    (not supported yet)
diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
index 310076be14b2..b181ca03e3a5 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
@@ -16,6 +16,7 @@ Required properties:
       "realtek,rtl8366s"  (4+1 ports) (not supported yet)
       "realtek,rtl8367"               (not supported yet)
       "realtek,rtl8367b"              (not supported yet)
+      "realtek,rtl8367s"  (5+2 ports)
       "realtek,rtl8368s"  (8 port)    (not supported yet)
       "realtek,rtl8369"               (not supported yet)
       "realtek,rtl8370"   (8 port)    (not supported yet)
-- 
2.34.0

