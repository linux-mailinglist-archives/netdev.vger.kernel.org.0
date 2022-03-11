Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34584D6243
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 14:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348851AbiCKNWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 08:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239206AbiCKNWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 08:22:03 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722151C2D97;
        Fri, 11 Mar 2022 05:21:00 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id y22so10914792eds.2;
        Fri, 11 Mar 2022 05:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=KeIcFi3Rr2zXYQr6fLEKbqt/2PwXApn2VhoSkP/Ntyc=;
        b=jkyAQPSP/xz+inFQxVFY0mppDO9MzYQLQeOd8v14TimD8JzQhX/JidRRqqZ0OWKxGv
         g1/khMtqk+7ZUFDvfh/oW8w8YCifaIKwqVewNuy3v6rZ/BXuX5tsI5avxWJVKxLbcpaT
         nkJwKbI6B7s+bswHpbWkRo0SFhYem9Boj/Tx5t90dgDjDx1Lr5a+iICusDlGH4KK22A1
         qmNtCi5kADJ5ETV0BQtaNZVraQV1qYnIhiueBBBjhMZZmRKjgykSpagzpt+J5VAQnnga
         N/x6/ml5uL3utQoVAzkvJZSshTI2Oy99aMVh+2ftyXpfwjybDmSkFaSpjowP6OLsyg68
         FLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KeIcFi3Rr2zXYQr6fLEKbqt/2PwXApn2VhoSkP/Ntyc=;
        b=Vm8JUV8zsXmNmw6qaQUIuJgwqy//0jGzxWvd7M7cFJqQUauvWQzH6r+S4dPCoj0fhp
         zDWn4r+ODSO/n47JEMuz4pkrYsJ5Zl7IESEvPTWHsXYBQ4rsTni6Yz2SdZBgKMS3uYw+
         RvwyaoTc5BA2Ra2J5X9hcXmjT/u/ES92eyhcN0NSzZo/EYszN40r7XFtAf8gs07OIj3H
         aA8X+CFNUQSNToZvjAJnHprc1dhwftQ9iG+V5h8lMR8OP9w/f8HYlVSzgnPwSJLxIrS1
         4xdpqpf7MTOAcl4pku0zayAPC5Ju+UfXPXK3vsqV52k0niRc0+tcjisYN75aOC+EimGR
         k0Sg==
X-Gm-Message-State: AOAM533B9bhTMaaR1ZxVv954D9EcsZxcQmT87DjEAYnE5xpeMPcsKBjy
        6hFJ/JObPWYFm8DI3dK9l4U=
X-Google-Smtp-Source: ABdhPJwVXUzZB5cpKF2x75RtFG3YEMTiKoforB885AlXxaBQxm2RTqSxA2WUUMN/51rejK5FcxSHGA==
X-Received: by 2002:a05:6402:4414:b0:408:4dc0:3ee9 with SMTP id y20-20020a056402441400b004084dc03ee9mr8686736eda.203.1647004858571;
        Fri, 11 Mar 2022 05:20:58 -0800 (PST)
Received: from felia.fritz.box (200116b826a9a900147fc2a0771e144b.dip.versatel-1u1.de. [2001:16b8:26a9:a900:147f:c2a0:771e:144b])
        by smtp.gmail.com with ESMTPSA id u9-20020a170906124900b006ce88a505a1sm3027146eja.179.2022.03.11.05.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 05:20:58 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     robh+dt@kernel.org, devicetree@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: rectify entry for ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE
Date:   Fri, 11 Mar 2022 14:20:16 +0100
Message-Id: <20220311132016.24090-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 208b65f7b5cc ("dt-bindings: net: convert net/cortina,gemini-ethernet
to yaml") converts cortina,gemini-ethernet.txt to yaml, but missed to
adjust its reference in MAINTAINERS.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
broken reference.

Repair this file reference in ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Rob, please pick this minor non-urgent cleanup patch in your -next tree on
top of the commit above.

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d0a17fcf264b..80e5867b2afa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2004,7 +2004,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 T:	git git://github.com/ulli-kroll/linux.git
 F:	Documentation/devicetree/bindings/arm/gemini.yaml
-F:	Documentation/devicetree/bindings/net/cortina,gemini-ethernet.txt
+F:	Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
 F:	Documentation/devicetree/bindings/pinctrl/cortina,gemini-pinctrl.txt
 F:	Documentation/devicetree/bindings/rtc/faraday,ftrtc010.yaml
 F:	arch/arm/boot/dts/gemini*
-- 
2.17.1

