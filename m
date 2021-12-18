Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D26479995
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 09:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhLRIPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 03:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbhLRIPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 03:15:00 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6C7C061574
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:14:59 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id m6so4570834qvh.10
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VX3zaPwkmDMsZiVnxRcMegeialZEFhp8oEor90T5jZ8=;
        b=fyUfvYQa3Z29FJX/6LtIP9SOiISURsc5NrLnYTLRkZZ22gTMIM2WbwAec1F347p2gz
         /mdRTfsCTHEgk34wOxzgA+7lYDFzSngMeI14amIvIEdMdHMRbdYN84a5q0RfuSyKqmt8
         Rgekk3IpuJfV4jPU696CLFZzWZEes+TmoJ+1uAIXZDOBH/CnLog47IrRS4rj0CGpUrzq
         pMvs30R7RAIaCf2A3gsla4M2zdflD7PajxdBF6M6N7LH8uU/By0BqWZ6e+A1ZxVrCw9Q
         6JDpAQZdZFUD5XhiKmFJl69ppZxH067jq/9D0On73zmeiDe6Ws0auHWgoFU0685Z2+1c
         KS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VX3zaPwkmDMsZiVnxRcMegeialZEFhp8oEor90T5jZ8=;
        b=YHZKY8c9kW9zDHClNErk6VrEGqEs2UJwl/D+ltA1uM7qiiFDdTH9URDHpSV7IkxRBZ
         13B5sJBUog515l4IpsS8YCs2xo+nkxwmsg9Y06dhmC8xgeZAfmYZgxMUwHvGuY544unz
         dj/bgTItWbj+N/rk70B6Xa4f29y0s5YHFx5dF08VHPZ6CxA4DANeAuhTVUy63u3rBou8
         e26R7soV1ljFqG+oCmyNn8M/uDbMSquxSD5Nzrdc4fEipAmHI/oYUuz6hwfPr6RWNDhb
         2aLw/+TBe+aWDlG014aenw9Gg3eZb5aqkrnRuI0oh/lgKYeluIG4WCXJUr0Gj3KQ6YO0
         +3Rg==
X-Gm-Message-State: AOAM530JrNn7T1Ou/0dgnk2fc+ZznliRuYwa5QdUX1PWY92bt2SzVb+H
        7Y6LOedziLuRklb3rZg0PVv29+IINXMCQQ==
X-Google-Smtp-Source: ABdhPJyG3va4ABC8XurN5gGiE9wigIqF9gfDA9ckKbee/tXibaiZL3yrRkKdJXZTQbT2pnW7fX4CEw==
X-Received: by 2002:a05:6214:252d:: with SMTP id gg13mr3582853qvb.96.1639815298528;
        Sat, 18 Dec 2021 00:14:58 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id f11sm6423357qko.84.2021.12.18.00.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 00:14:58 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2 01/13] dt-bindings: net: dsa: realtek-smi: mark unsupported switches
Date:   Sat, 18 Dec 2021 05:14:13 -0300
Message-Id: <20211218081425.18722-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211218081425.18722-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some listed switches are not really supported yet.

Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 .../devicetree/bindings/net/dsa/realtek-smi.txt | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
index 7959ec237983..ec96b4035ed5 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
@@ -4,20 +4,21 @@ Realtek SMI-based Switches
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
+      "realtek,rtl8366"               (not supported yet)
       "realtek,rtl8366rb" (4+1 ports)
-      "realtek,rtl8366s"  (4+1 ports)
-      "realtek,rtl8367"
-      "realtek,rtl8367b"
-      "realtek,rtl8368s"  (8 port)
-      "realtek,rtl8369"
-      "realtek,rtl8370"   (8 port)
+      "realtek,rtl8366s"  (4+1 ports) (not supported yet)
+      "realtek,rtl8367"               (not supported yet)
+      "realtek,rtl8367b"              (not supported yet)
+      "realtek,rtl8368s"  (8 port)    (not supported yet)
+      "realtek,rtl8369"               (not supported yet)
+      "realtek,rtl8370"   (8 port)    (not supported yet)
 
 Required properties:
 - mdc-gpios: GPIO line for the MDC clock line.
-- 
2.34.0

