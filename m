Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE241477D21
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239002AbhLPUOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240623AbhLPUOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:14:14 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3B4C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:14 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id 132so56360qkj.11
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AJle7xpTRi90OQxhDacPhG+DjfUCETSyA8Epf2KmwWg=;
        b=jsJTQmVwBLp1udcOPGPKg4qr44pfkBH8i1ORa0z8XfCg0CfWdloDneJtJbrHdeINTf
         8a+8cqLzB/z8TlJk/dH31ktxXfYnknJt00miXXWS4Xo30VShdgzSR/mljGUholtnSOka
         rJKwZPg0Z0IcnuAl8Wy6URI8Pv+Lsa8hb7VCO+co7ni5SYoYx022TbfcZv4H0DCTX53D
         TBhvME7GUSI6ZByd80pgz1xd3eDjWwNwEK/lkIqJsw4txZPvS+mPyUUIQOkG3ngVVFKk
         tSqrWM02RjgzO89itWJS5DIsMLvEYK1g5eJtFZPM42znaJO377je/ez3Nd93JEJmbzgG
         lH8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AJle7xpTRi90OQxhDacPhG+DjfUCETSyA8Epf2KmwWg=;
        b=QdFtniB5qsh1u/o3DRvlTLNSLj94m7RTSOsAV/56Hlyt+R2kGX8L6l4n1+fOQ1/aSf
         T53UXLf1XSUR15MAPZwou10vOF1baC5Eo9FFCnNQ8NHrupaU9cMdLzp5EDDywcZCVAYZ
         C1EY0P6fpU6UdhzC83/3Q89QXCKa61015L8zachQt912dPiJhNcgjKmpTqet42Ug7DgP
         x0rDa+bbu4+q64kBS5LsUZbKlv0KR9BK1/LSDXCI1ro+LRUVJgSTJJ20fnMxyz1Fs0cN
         Ymw/bfv7dO7xibzuqH5I0X9Z9eL7Uvc81n7gXCQBmlpV+uIqP+GJ9hGwZVPoFtIYGLLt
         NBtA==
X-Gm-Message-State: AOAM533JKChYOoQt9FVCsT2UVofQQvhvHmdMdOKJI7KYJ3+KwoSjPXOK
        y/NgtSABJRYiNUhPzXkhwL0LQdSx1K3A1w==
X-Google-Smtp-Source: ABdhPJzPDW+JstwGXEOxdfe5YQDZ+cnYkj7Tv0ogKQbWTgFem0JRBsRM4VE83MFVHhaR2ZGLYXymoA==
X-Received: by 2002:a37:8845:: with SMTP id k66mr13541663qkd.664.1639685653522;
        Thu, 16 Dec 2021 12:14:13 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a15sm5110266qtb.5.2021.12.16.12.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:14:12 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next 01/13] dt-bindings: net: dsa: realtek-smi: remove unsupported switches
Date:   Thu, 16 Dec 2021 17:13:30 -0300
Message-Id: <20211216201342.25587-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Remove some switch models that are not cited in the code. Although rtl8366s
was kept, it looks like a stub driver (with a FIXME comment).

Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 .../devicetree/bindings/net/dsa/realtek-smi.txt          | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
index 7959ec237983..3a60e77ceed4 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
@@ -4,20 +4,15 @@ Realtek SMI-based Switches
 The SMI "Simple Management Interface" is a two-wire protocol using
 bit-banged GPIO that while it reuses the MDIO lines MCK and MDIO does
 not use the MDIO protocol. This binding defines how to specify the
-SMI-based Realtek devices.
+SMI-based Realtek devices. The realtek-smi driver is a platform driver
+and it must be inserted inside a platform node.
 
 Required properties:
 
 - compatible: must be exactly one of:
       "realtek,rtl8365mb" (4+1 ports)
-      "realtek,rtl8366"
       "realtek,rtl8366rb" (4+1 ports)
       "realtek,rtl8366s"  (4+1 ports)
-      "realtek,rtl8367"
-      "realtek,rtl8367b"
-      "realtek,rtl8368s"  (8 port)
-      "realtek,rtl8369"
-      "realtek,rtl8370"   (8 port)
 
 Required properties:
 - mdc-gpios: GPIO line for the MDC clock line.
-- 
2.34.0

